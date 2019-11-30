import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

import 'controller/bmobBuilder.dart';
import 'controller/builder.dart';
import 'model/dvaConfig.dart';
import 'model/dvaKey.dart';
import 'model/dvaProject.dart';
import 'model/dvaTable.dart';
import 'utils/path.dart'; // 使用其中两个类ArgParser和ArgResults

ArgResults _argResults; // 声明ArgResults类型的顶级变量，保存解析的参数结果
// 同时，argResults也是ArgResults的实例

main(List<String> args) {
  // 创建ArgParser的实例，同时指定需要输入的参数
  final ArgParser argParser = new ArgParser()
    ..addOption(
      'mode',
      abbr: 'm',
      defaultsTo: 'standard',
      help: "指定生成模式，当前支持:standard,bmob",
    )
    ..addOption(
      'data',
      abbr: 'd',
      defaultsTo: 'all',
      help: "指定生成源文件，例如：dva build -d user,将只会生成user相关的页面",
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: "查看dva-cli的指令帮助",
    );
  _argResults = argParser.parse(args);
  if (_argResults['help']) {
    print("""
** DVA-CLI 帮助 **
主要指令
dva config  生成config文件，在编辑完config文件后，你应当立即调用一次dva init
dva init    生成基础的mixin与数据源结构
dva build   生成页面，可以使用-m,-d指令指定对应参数，也可以不指定

修饰指令
${argParser.usage}
    """);
    return;
  }

  if (_argResults.arguments.length == 0) {
    print('TODO:显示帮助');
    return;
  }
  var command = _argResults.arguments.first;
  String type = _argResults['mode'];
  String target = _argResults['data'];
  // abbr表示缩写或别名，defaultsTo表示默认值
  print('读取命令:$command');
  var file = File.fromUri(shellPath.resolve('dva-config.json'));

  DvaConfig config = DvaConfig.defaultConfig();

  if (command == 'config') {
    file.createSync();
    file.writeAsStringSync(
      JsonEncoder.withIndent('   ').convert(config.map),
    );
    print('已成功创建Config文件\n在配置Config文件后，你应该立即使用命令 dva init 来创建目录结构');
    return;
  } else {
    print('读取配置...');
    config = DvaConfig.fromFile(file);
    print(JsonEncoder.withIndent('   ').convert(config.map));
  }
  _buildProject(
    type,
    config,
    command,
    target,
  );
}

void _buildProject(
  String type,
  DvaConfig config,
  String command,
  String target,
) {
  DvaProjectBuilder project;
  // TODO: 增加更多builder类型
  if (type == 'standard') {
    project = DvaProjectBuilder(
      config,
      DvaProject.fromPath(Uri.parse(config.dataPath)),
    );
  } else if (type == 'bmob') {
    project = BmobProjectBuilder(
      config,
      DvaProject.fromPath(Uri.parse(config.dataPath)),
    );
  } else {
    throw '没有找到指定编辑模式: $type';
  }

  // 指令
  if (command == 'init') {
    project.initProject();
  } else if (command == 'build') {
    project.saveProject(target);
  } else {
    throw '无法识别命令: $command';
  }
}
