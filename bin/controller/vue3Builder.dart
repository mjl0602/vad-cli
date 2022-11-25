import 'dart:io';

import '../config/vadConfig.dart';
import '../model/vadKey.dart';
import '../model/vadProject.dart';
import '../model/vadTable.dart';
import '../utils/path.dart';
import '../utils/type.dart';
import 'builder.dart';
import 'package:path/path.dart' as path;

class Vue3Builder extends VadProjectBuilder {
  Vue3Builder(
    VadConfig config,
    VadProject project,
  ) : super(
          config,
          project,
        );
  // 模板路径
  Uri get jsonTemplate => templatePath.resolve('./temp_admin.json');
  // 基础文件
  Uri get dataSourceTemplate =>
      templatePath.resolve('./vue3/basic/queryable.ts');
  Uri get mixinTemplate => templatePath.resolve('./vue3/basic/basic-table.ts');
  // 模板文件
  Uri get pageTemplate => templatePath.resolve('./vue3/table.vue.sample');
  Uri get apiTemplate => templatePath.resolve('./vue3/data.ts.sample');

  /// 数据源的父类路径
  Uri get dataSource =>
      Uri.parse(config.apiPath).resolve('./source/queryable.ts');

  /// mixin的路径
  Uri get mixinPath =>
      Uri.parse(config.pagePath).resolve('./basic/basic-table.ts');

  String get langType => 'ts';

  /// 表单
  String formTemp(VadKey key) {
    return super.formTemp(key).replaceAll('"row.', '"tb.row.');
  }

  /// 表格内容
  String tableTemp(VadKey key, [String Function(String) columnBuilder]) {
    var content = super.tableTemp(key, (str) {
      return '''
    <el-table-column label="@@@" align="center" &&&>
      <template #default="scope: ##TableName##ModelRow">
        $str
      </template>
    </el-table-column>''';
    });
    return content.replaceAll('slot-scope=', '#default=');
  }

  /// 获取Vue Page内容，并写入到对应Uri的文件
  /// page需要关联到dataSource的子类上
  String buildPage(Uri tempUri, VadTable table) {
    var content = super.buildPage(tempUri, table);

    return content.replaceAll(
      "/** interface */",
      table.build((key) {
        var tsType = [
          "string",
          "boolean",
          "string",
          "Date",
          "string[]",
        ][key.tableType.index];
        return '  /** ${key.description} */\n'
            '  ${key.key}?: $tsType';
      }),
    );
  }
}
