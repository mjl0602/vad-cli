import 'dart:io';
import 'package:path/path.dart' as path;
import '../config/vadConfig.dart';
import '../model/vadKey.dart';
import '../model/vadProject.dart';
import '../model/vadTable.dart';
import '../utils/path.dart';
import '../utils/type.dart';

/// @@@ 将会被替换为description
/// ### 会被替换成key

/// 默认的项目创建器
class VadProjectBuilder {
  final VadProject project;
  final VadConfig config;

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

  VadProjectBuilder(
    this.config,
    this.project,
  ) : assert(project != null);

  /// 初始化项目文件夹结构
  /// 其中mixin需要关联dataSource
  initProject() {
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
  saveProject([String target]) {
    /// 生成主要文件
    for (var table in project.list) {
      // 生成数据
      var dataUri = Uri.parse(config.apiPath).resolve('${table.name}.js');
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
        table.name,
      );
    }
  }

  // 保存文件，如果存在，会将旧文件重命名为old后继续保存
  savaFile(String content, Uri path, String fileName) {
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
        .replaceAll('##filename##', table.name)
        .replaceAll("##tableName##", table.name)
        .replaceAll("<!-- table insert -->", tableContent)
        .replaceAll("<!-- form insert -->", formContent)
        .replaceAll("/** property */", defaultObjectContent)
        .replaceAll("/** rules */", rulesContent)
        .replaceAll("/** edit */", submitContent);
  }

  /// 表单
  String formTemp(VadKey key) {
    String str = '<!--error-->';
    switch (key.formType) {
      case FormType.string:
        str = '''
    <el-form-item label="@@@" prop="###">
      <el-input v-model="row.###" placeHolder="请输入@@@"/>
    </el-form-item>''';
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
    </el-date-picker>
        ''';
        break;
      case FormType.time:
        str = '''
    <el-time-picker
      arrow-control
      v-model="row.###"
      placeholder="选择@@@">
    </el-time-picker>
    ''';
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
    }
    return str.replaceAll('@@@', key.description).replaceAll('###', key.key);
  }

  /// 表格内容
  String tableTemp(VadKey key) {
    String str = '<!--error-->';
    switch (key.tableType) {
      case TableType.string:
        str = '''
    <el-table-column label="@@@" align="center">
      <template slot-scope="scope">
        {{scope.row.###}}
      </template>
    </el-table-column>''';
        break;
      case TableType.dateTime:
        str = '''
    <el-table-column label="@@@" align="center">
      <template slot-scope="scope">
        {{new Date(scope.row.###).toLocaleString()}}
      </template>
    </el-table-column>
        ''';
        break;
    }
    return str.replaceAll('@@@', key.description).replaceAll('###', key.key);
  }

  /// 默认值
  String defaultValueTemp(VadKey key) {
    return '###:${key.value},\n    '
        .replaceAll('@@@', key.description)
        .replaceAll('###', key.key);
  }

  /// 规则
  String rulesTemp(VadKey key) {
    return '###:[{ required: true, message: "必填", trigger: "blur" }],\n    '
        .replaceAll('@@@', key.description)
        .replaceAll('###', key.key);
  }

  /// 提交
  String sumitTemp(VadKey key) {
    return '';
  }
}

/// TODO: JSON生成工具
class VadResourceBuilder {}

/// TODO: 路由生成工具
class VadRouteBuilder {}
