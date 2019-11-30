import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

import 'controller/builder.dart';
import 'model/dvaConfig.dart';
import 'model/dvaKey.dart';
import 'model/dvaProject.dart';
import 'model/dvaTable.dart';
import 'utils/path.dart'; // 使用其中两个类ArgParser和ArgResults

ArgResults argResults; // 声明ArgResults类型的顶级变量，保存解析的参数结果
// 同时，argResults也是ArgResults的实例

main(List<String> args) async {
  // 创建ArgParser的实例，同时指定需要输入的参数
  final ArgParser argParser = new ArgParser()
    ..addOption(
      'name',
      abbr: 'n',
      defaultsTo: 'World',
    );
  var command = argParser.parse(args).arguments.first;
  // abbr表示缩写或别名，defaultsTo表示默认值
  print('读取命令:$command');
  var file = File.fromUri(shellPath.resolve('dva-config.json'));
  DvaConfig config = DvaConfig.defaultConfig();
  print('读取配置...');
  if (command == 'config') {
    file.createSync();
    file.writeAsStringSync(
      JsonEncoder.withIndent('   ').convert(config.map),
    );
    return;
  } else {
    if (!file.existsSync()) {
      print('没有找到config文件');
      return;
    } else {
      config = DvaConfig.fromJson(json.decode(file.readAsStringSync()));
      print(JsonEncoder.withIndent('   ').convert(config.map));
    }
  }
  DvaProjectBuilder(
    config: config,
    project: DvaProject(
      name: '',
      list: [
        DvaTable(
          name: 'admin',
          list: [
            DvaKey(
              value: '默认管理员',
              key: 'name',
              description: '姓名',
            ),
          ],
        ),
      ],
    ),
  ).saveProject();
}
