import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../config/vadConfig.dart';
import '../model/vadKey.dart';
import '../model/vadProject.dart';
import '../model/vadTable.dart';
import '../utils/path.dart';
import '../utils/safeMap.dart';
import '../utils/type.dart';

/// @@@ 将会被替换为description
/// ### 会被替换成key

/// 默认的项目创建器
class VadProjectBuilder {
  final VadProject project;
  final VadConfig config;

  VadProjectBuilder(
    this.config,
    this.project,
  ) : assert(project != null);

  // 模板路径
  Uri get jsonTemplate => templatePath.resolve('temp_admin.json');
  Uri get dataSourceTemplate => templatePath.resolve('temp_dataSource.js');
  Uri get pageTemplate => templatePath.resolve('temp_page.vue');
  Uri get mixinTemplate => templatePath.resolve('temp_mixin.js');
  Uri get apiTemplate => templatePath.resolve('temp_api.js');

  /// 示范JSON
  Uri get exampleJson => Uri.parse(config.dataPath).resolve('admin.json');

  /// 数据源的父类路径
  Uri get dataSource =>
      Uri.parse(config.apiPath).resolve('super/dataSource.js');

  /// mixin的路径
  Uri get mixinPath => Uri.parse(config.pagePath).resolve('basic/mixin.js');

  String get langType => 'js';

  /// 修正json
  /// 把一个简写的json改为完整json
  void completeFile(String fileName) {
    var file = File.fromUri(
      Uri.parse(config.dataPath).resolve('${fileName}.json'),
    );
    print('读取文件：${file.path}');
    Map<String, dynamic> map = json.decode(file.readAsStringSync());
    var table = VadTable.formJson(map, fileName, file.uri);
    var jsonContent = table.list.map<String>((VadKey vadKey) {
      var content = JsonEncoder.withIndent('  ').convert(vadKey.jsonMap);
      return '"${vadKey.key}":$content';
    }).join(',\n');
    file.writeAsStringSync('{\n$jsonContent}\n');
  }

  /// 初始化项目文件夹结构
  /// 其中mixin需要关联dataSource
  void initProject() {
    // 创建数据源结构，用于举例子
    File.fromUri(exampleJson)
      ..createSync(recursive: true)
      ..writeAsStringSync(
        File.fromUri(jsonTemplate).readAsStringSync(),
      );
    // 创建api父类结构并写入父类
    var apiContent = File.fromUri(dataSourceTemplate).readAsStringSync();
    var api = File.fromUri(dataSource)
      ..createSync(recursive: true)
      ..writeAsStringSync(apiContent);
    // 创建页面结构并写入mixin,并依赖到api类的父类
    var mixinContent = File.fromUri(mixinTemplate).readAsStringSync();

    /// 不知道为啥这里如果使用两个文件关联，依赖会有问题，会多一个 [../]
    var relationPath = path.relative(
      api.path,
      // from: Uri.parse(config.pagePath).resolve('basic/').path,
      from: File(mixinPath.path).parent.path, // 取上一级的路径作为依赖项,TODO:待测试
    );
    print('----------');
    print(api.path);
    print(relationPath);
    print(mixinPath.path);
    print('----------');
    File.fromUri(mixinPath)
      ..createSync(recursive: true)
      ..writeAsStringSync(
        mixinContent.replaceAll(
          '##dataSourcePath##',
          relationPath,
        ),
      );
  }

  /// 保存项目
  void saveProject([String? target]) {
    print('生成主要文件: ${project.list}');

    /// 生成主要文件
    for (var table in project.list) {
      if (table.camelName == '') {
        return;
      }
      // 生成数据
      var dataUri = Uri.parse(config.apiPath).resolve(
        '${table.camelName}.$langType',
      );
      var dataFile = File.fromUri(dataUri);
      // 如果指定文件
      if (target != null && target != 'all') {
        if (target != table.name) {
          print('$target ${table.name}');
          continue;
        }
      }
      dataFile.createSync(recursive: true);
      dataFile.writeAsStringSync(
        buildPage(
          apiTemplate,
          table,
        ),
      );
      print('生成:${dataFile.path}');
      // 生成页面
      savaFile(
        buildPage(pageTemplate, table).replaceAll(
          '##dataPath##',
          path.relative(
            dataUri.path,
            from: shellPath.resolve(config.pagePath).path,
          ),
        ),
        shellPath.resolve(config.pagePath),
        table.camelName,
      );
    }
  }

  // 保存文件，如果存在，会将旧文件重命名为old后继续保存
  void savaFile(String content, Uri path, String fileName) {
    var file = File.fromUri(path.resolve('${fileName}Manage.vue'));
    print('生成:${file.path}');
    file.createSync(recursive: true);
    file.writeAsStringSync(content);
  }

  /// 获取Vue Page内容，并写入到对应Uri的文件
  /// page需要关联到dataSource的子类上
  String buildPage(Uri tempUri, VadTable table) {
    // 内容
    String tableContent = table.build((key) => tableTemp(key));
    String formContent = table.build((key) => formTemp(key));
    String defaultObjectContent = table.build((key) => defaultValueTemp(key));
    String rulesContent = table.build((key) => rulesTemp(key));
    String submitContent = table.build((key) => sumitTemp(key));

    /// 替换 vue 内容
    return File.fromUri(tempUri)
        .readAsStringSync()
        .replaceAll("<!-- table insert -->", tableContent)
        .replaceAll("<!-- form insert -->", formContent)
        .replaceAll("/** property */", defaultObjectContent)
        .replaceAll("/** rules */", rulesContent)
        .replaceAll("/** edit */", submitContent)
        .replaceAll('##filename##', table.name)
        .replaceAll("##tableName##", table.name)
        .replaceAll(
          "##TableName##",
          table.name.replaceRange(0, 1, table.name[0].toUpperCase()),
        );
  }

  /// 表单
  String formTemp(VadKey key) {
    String str = '<!--error-->';
    switch (key.formType) {
      case FormType.string:
        str = '''
    <el-input v-model="row.###" placeholder="请输入@@@"/>''';
        break;
      case FormType.date:
        str = '''
    <el-date-picker
      v-model="row.###"
      align="right"
      type="date"
      placeholder="选择@@@"
      :picker-options="datePickOption"
      >
    </el-date-picker>''';
        break;
      case FormType.time:
        str = '''
    <el-time-picker
      arrow-control
      v-model="row.###"
      placeholder="选择@@@">
    </el-time-picker>''';
        break;
      case FormType.dateTime:
        str = '''
    <el-date-picker
      v-model="row.###"
      type="datetime"
      placeholder="选择@@@"
      align="right"
      :picker-options="datePickOption">
    </el-date-picker>''';
        break;
      case FormType.stringArray:
        str = '''
    <el-checkbox-group v-model="row.###" style="width:0px;">
      <el-checkbox label="superadmin" key="superadmin" style="margin:0;"></el-checkbox>
      <el-checkbox label="admin" key="admin" style="margin:0;"></el-checkbox>
      <el-checkbox label="editor" key="editor" style="margin:0;"></el-checkbox>
    </el-checkbox-group> ''';
        break;
      case FormType.boolean:
        str = '''
    <el-switch
      v-model="row.###"
      active-color="#13ce66"
      inactive-color="#9b9b9b">
    </el-switch>''';
        break;
    }
    str = '''
  <el-form-item label="@@@" prop="###">
$str
  </el-form-item>''';
    str = str.split('\n').map((e) => '${' ' * 6}$e').join('\n');
    return str.replaceAll('@@@', key.description).replaceAll('###', key.key);
  }

  /// 表格内容
  String tableTemp(VadKey key, [String Function(String)? columnBuilder]) {
    String str = '<!--error-->';
    switch (key.tableType) {
      case TableType.string:
        str = '{{scope.row.###}}';
        break;
      case TableType.dateTime:
        str = '{{new Date(scope.row.###).toLocaleString()}}';
        break;
      case TableType.tagArray:
        str = '''<div v-for="text in scope.row.###" style="margin:4px;">
          <el-tag>{{text}}</el-tag>
        </div>''';
        break;
      case TableType.boolean:
        str = '''<el-switch
          disabled
          v-model="scope.row.###"
          active-color="#13ce66"
          inactive-color="#9b9b9b">
        </el-switch>''';
        break;
      case TableType.image:
        str = '<img style="height:66px;" :src="scope.row.###">';
        break;
    }
    str = columnBuilder?.call(str) ??
        '''
    <el-table-column label="@@@" align="center" &&&>
      <template slot-scope="scope">
        $str
      </template>
    </el-table-column>''';
    str = str.split('\n').map((e) => '${' ' * 2}$e').join('\n');
    return str
        .replaceAll('@@@', key.description)
        .replaceAll('###', key.key)
        .replaceAll('&&&', key.property ?? '');
  }

  /// 默认值
  String defaultValueTemp(VadKey key) {
    return '      ###:${key.value},'
        .replaceAll('@@@', key.description)
        .replaceAll('###', key.key);
  }

  /// 规则
  String rulesTemp(VadKey key) {
    return '      ###:[{ required: true, message: "必填", trigger: "blur" }],'
        .replaceAll('@@@', key.description)
        .replaceAll('###', key.key);
  }

  /// 提交
  String sumitTemp(VadKey key) {
    return '';
  }
}

/// TODO: 路由生成工具
class VadRouteBuilder {}
