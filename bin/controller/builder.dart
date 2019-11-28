import 'dart:io';

import '../model/dvaConfig.dart';
import '../model/dvaKey.dart';
import '../model/dvaProject.dart';
import '../model/dvaTable.dart';
import '../utils/dvaPath.dart';

/// @@@ 将会被替换为key
/// ### 会被替换成description
class DvaProjectBuilder {
  final DvaProject project;
  final DvaConfig config;

  DvaProjectBuilder({
    this.config: const DvaConfig.defaultConfig(),
    this.project,
  }) : assert(project != null);

  saveProject() {
    for (var table in project.list) {
      var content = buildVuePage(templatePath.resolve('./template.vue'), table);
      // 保存页面
      _savaFile(content, shellPath.resolve(config.pagePath), table.name);
    }
  }

  // 保存文件，如果存在，会命名为old后继续保存
  _savaFile(String content, Uri path, String fileName) {
    var file = File.fromUri(path.resolve('${fileName}Manage.vue'));
    if (file.existsSync()) {
      file.renameSync(
        path
            .resolve('old_${fileName}Manage.vue.vue')
            .toFilePath(windows: Platform.isWindows),
      );
      file = File.fromUri(path.resolve('userManage.vue'));
    }
    print('写入文件:${file.path}');

    file.createSync(recursive: true);
    file.writeAsStringSync(content);
  }

  /// 获取Vue Page内容
  String buildVuePage(Uri tempUri, DvaTable table) {
    /// 表格内容
    String tableContent = table.build((key) => _tableTemp(key));

    String formContent = table.build((key) => _formTemp(key));

    String defaultObjectContent = '';
    String rulesContent = '';
    String submitContent = '';

    /// vue 内容
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

  // String buildDataSource() {}

  /// 表单
  String _formTemp(DvaKey key) {
    switch (key.formType) {
      case FormType.string:
        return '';
        break;
      case FormType.date:
        return '';
        break;
      case FormType.time:
        return '';
        break;
      case FormType.datetime:
        return '';
        break;
    }
    return '<!--error-->';
  }

  /// 表格内容
  String _tableTemp(DvaKey key) {
    switch (key.tableType) {
      case TableType.string:
        return '''
    <el-table-column label="@@@" align="center">
      <template slot-scope="scope">
        {{scope.row.###}}
      </template>
    </el-table-column>''';
        break;
      case TableType.dateTime:
        return '''
    <el-table-column label="@@@" align="center">
      <template slot-scope="scope">
        {{new Date(scope.row.###).toLocaleString()}}
      </template>
    </el-table-column>
        ''';
        break;
    }
    return '<!-- error -->';
  }
}
