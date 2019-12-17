import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

import 'config/bmobConfig.dart';
import 'controller/axiosBuilder.dart';
import 'controller/bmobBuilder.dart';
import 'controller/builder.dart';
import 'config/vadConfig.dart';
import 'model/vadProject.dart';
import 'utils/help.dart';
import 'utils/path.dart'; // 使用其中两个类ArgParser和ArgResults

ArgResults _argResults; // 声明ArgResults类型的顶级变量，保存解析的参数结果

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
      help: "指定生成源文件，例如：vad build -d user,将只会生成user相关的页面",
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: "查看vad-cli的指令帮助",
    );
  _argResults = argParser.parse(args);
  VadHelp help = VadHelp(argParser.usage);
  if (_argResults['help'] || _argResults.arguments.length == 0) {
    help.show();
    return;
  }
  var command = _argResults.arguments.first;
  print('执行命令:$command');
  onCommand(command);
}

onCommand(String command) {
  String mode = _argResults['mode'];
  String target = _argResults['data'];
  var file = File.fromUri(shellPath.resolve('vad-config.json'));
  VadConfig config = defaultConfigOfType(mode);

  if (command == 'config') {
    file.createSync();
    file.writeAsStringSync(
      JsonEncoder.withIndent('   ').convert(config.map),
    );
    print('已成功创建Config文件\n在配置Config文件后，你应该立即使用命令 vad init 来创建目录结构');
    return;
  }
  print('读取配置...');
  config = configOfType(mode, file);
  print(JsonEncoder.withIndent('   ').convert(config.map));

  VadProjectBuilder project = builderOfType(mode, config);

  // 指令
  if (command == 'init') {
    project.initProject();
  } else if (command == 'build') {
    project.saveProject(target);
  } else {
    throw '无法识别命令: $command';
  }
}

/// 通过Type获取builder
/// TODO: 增加更多builder类型
VadProjectBuilder builderOfType(String type, VadConfig config) {
  if (type == 'standard') {
    return VadProjectBuilder(
      config,
      VadProject.fromPath(Uri.parse(config.dataPath)),
    );
  } else if (type == 'bmob') {
    return BmobProjectBuilder(
      config,
      VadProject.fromPath(Uri.parse(config.dataPath)),
    );
  } else if (type == 'axios') {
    return AxiosBuilder(
      config,
      VadProject.fromPath(Uri.parse(config.dataPath)),
    );
  } else {
    throw '没有找到指定编辑模式: $type';
  }
}

VadConfig configOfType(String type, File file) {
  if (type == 'standard') {
    return VadConfig.fromFile(file);
  } else if (type == 'bmob') {
    return BmobConfig.fromFile(file);
  } else {
    throw '没有找到指定配置文件: $type';
  }
}

VadConfig defaultConfigOfType(String type) {
  if (type == 'standard') {
    return VadConfig.defaultConfig();
  } else if (type == 'bmob') {
    return BmobConfig.defaultConfig();
  } else {
    throw '没有找到指定配置文件: $type';
  }
}
