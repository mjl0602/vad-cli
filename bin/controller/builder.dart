import 'dart:io';
import 'package:path/path.dart' as path;
import '../model/dvaConfig.dart';
import '../model/dvaKey.dart';
import '../model/dvaProject.dart';
import '../model/dvaTable.dart';
import '../utils/path.dart';

/// @@@ 将会被替换为description
/// ### 会被替换成key
class DvaProjectBuilder {
  final DvaProject project;
  final DvaConfig config;

  DvaProjectBuilder({
    this.config: const DvaConfig.defaultConfig(),
    this.project,
  }) : assert(project != null);

  /// 初始化项目文件夹结构
  /// 其中mixin需要关联dataSource
  initProject() {
    // 创建数据源结构，用于举例子
    var dvaSource = File.fromUri(
      Uri.parse(config.dataPath).resolve('admin.json'),
    );
    dvaSource.createSync(recursive: true);
    dvaSource.writeAsStringSync(
      File.fromUri(templatePath.resolve('admin.json')).readAsStringSync(),
    );

    // 创建api父类结构并写入父类
    var api = File.fromUri(
      Uri.parse(config.apiPath).resolve('utils/dataSource.js'),
    );
    api.createSync(recursive: true);
    var apiContent = File.fromUri(
      templatePath.resolve('dataSource.js'),
    ).readAsStringSync();
    api.writeAsStringSync(apiContent);

    // 创建页面结构并写入mixin,并依赖到api类的父类
    var pageMixin = File.fromUri(
      Uri.parse(config.pagePath).resolve('basic/mixin.js'),
    );
    pageMixin.createSync(recursive: true);
    var mixinContent = File.fromUri(
      templatePath.resolve('mixin.js'),
    ).readAsStringSync();
    pageMixin.writeAsStringSync(
      mixinContent.replaceAll(
        '##dataSourcePath##',
        path.relative(api.path, from: pageMixin.path),
      ),
    );
  }

  /// 保存项目
  saveProject() {
    initProject();

    /// 生成主要文件
    for (var table in project.list) {
      // 生成数据
      var dataUri = Uri.parse(config.apiPath).resolve('${table.name}.js');
      var api = File.fromUri(
        dataUri,
      );
      api.createSync(recursive: true);
      var apiContent = File.fromUri(
        templatePath.resolve('dataSource.js'),
      ).readAsStringSync();
      api.writeAsStringSync(apiContent);
      // 生成页面
      var content = buildVuePage(
        templatePath.resolve('./template.vue'),
        path.relative(
          dataUri.path,
          from: shellPath.resolve(config.pagePath).path,
        ),
        table,
      );
      savaFileAndRenameOld(
        content,
        shellPath.resolve(config.pagePath),
        table.name,
      );
    }
  }

  // 保存文件，如果存在，会将旧文件重命名为old后继续保存
  savaFileAndRenameOld(String content, Uri path, String fileName) {
    var file = File.fromUri(path.resolve('${fileName}Manage.vue'));
    if (file.existsSync()) {
      file.renameSync(
        path
            .resolve('old_${fileName}Manage.vue.vue')
            .toFilePath(windows: Platform.isWindows),
      );
      file = File.fromUri(path.resolve('${fileName}Manage.vue'));
    }
    print('写入文件:${file.path}');

    file.createSync(recursive: true);
    file.writeAsStringSync(content);
  }

  /// 获取Vue Page内容，并写入到对应Uri的文件
  /// page需要关联到dataSource的子类上
  String buildVuePage(Uri tempUri, String dataRelative, DvaTable table) {
    // 内容
    String tableContent = table.build((key) => tableTemp(key));
    String formContent = table.build((key) => formTemp(key));
    String defaultObjectContent = table.build((key) => defaultValueTemp(key));
    String rulesContent = table.build((key) => rulesTemp(key));
    String submitContent = table.build((key) => sumitTemp(key));

    /// 替换 vue 内容
    return File.fromUri(tempUri)
        .readAsStringSync()
        .replaceAll(
          '##dataPath##',
          dataRelative,
        )
        .replaceAll('##filename##', table.name)
        .replaceAll("##tableName##", table.name)
        .replaceAll("<!-- table insert -->", tableContent)
        .replaceAll("<!-- form insert -->", formContent)
        .replaceAll("/** property */", defaultObjectContent)
        .replaceAll("/** rules */", rulesContent)
        .replaceAll("/** edit */", submitContent);
  }

  /// 表单
  String formTemp(DvaKey key) {
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
      case FormType.datetime:
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
  String tableTemp(DvaKey key) {
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
  String defaultValueTemp(DvaKey key) {
    return '###:"${key.value}",\n    '
        .replaceAll('@@@', key.description)
        .replaceAll('###', key.key);
  }

  /// 规则
  String rulesTemp(DvaKey key) {
    return '###:[{ required: true, message: "必填", trigger: "blur" }],\n    '
        .replaceAll('@@@', key.description)
        .replaceAll('###', key.key);
  }

  /// 提交
  String sumitTemp(DvaKey key) {
    String str = '';
    switch (key.submitType) {
      case SubmitType.string:
        str = 'res.set("###", obj.###)\n';
        break;
      case SubmitType.date:
        str = 'res.set("###", new Date(obj.###))\n';
        break;
      case SubmitType.float:
        str = 'res.set("###", parseFloat(obj.###))\n';
        break;
      case SubmitType.integer:
        str = 'res.set("###", parseInt(obj.###))\n';
        break;
    }
    return str.replaceAll('@@@', key.description).replaceAll('###', key.key);
  }
}
