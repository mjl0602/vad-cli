import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

import 'config/bmobConfig.dart';
import 'controller/axiosBuilder.dart';
import 'controller/bmobBuilder.dart';
import 'controller/builder.dart';
import 'config/vadConfig.dart';
import 'controller/vue3Builder.dart';
import 'model/vadKey.dart';
import 'model/vadProject.dart';
import 'utils/help.dart';
import 'utils/path.dart';
import 'utils/safeMap.dart';
import 'web/server.dart'; // 使用其中两个类ArgParser和ArgResults

late ArgResults _argResults; // 声明ArgResults类型的顶级变量，保存解析的参数结果

main(List<String> args) async {
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
    ..addOption(
      'tag',
      abbr: 't',
      help: "生成tag，会按tag读取配置文件",
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
  await onBuildCommand(command);
}

Future onBuildCommand(String command) async {
  String mode = _argResults['mode'] ?? 'no-mode';
  String? target = _argResults['data'];
  String tag = _argResults['tag'] ?? 'no-tag';
  print(_argResults['tag']);
  var file = File.fromUri(shellPath.resolve('vad-config.json'));
  var jsonConfig = json.decode(file.readAsStringSync());
  var map = SafeMap(jsonConfig);
  var configMode = map['mode'].string;
  if (configMode != null) mode = configMode;

  if (configMode == null) throw '未提供mode或在vad-config.json中配置mode';
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
  config = configOfType(mode, file, tag);
  print(JsonEncoder.withIndent('   ').convert(config.map));

  VadProjectBuilder projectBuilder = builderOfType(mode, config);

  // 指令
  if (command == 'init') {
    projectBuilder.initProject();
  } else if (command == 'build') {
    projectBuilder.saveProject(target);
  } else if (command == 'complete') {
    projectBuilder.completeFile(target ?? 'no-target');
  } else if (command == 'serve') {
    await VadServer.start(config);
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
  } else if (type == 'vue3') {
    return Vue3Builder(
      config,
      VadProject.fromPath(Uri.parse(config.dataPath)),
    );
  } else {
    throw '没有找到指定编辑模式: $type';
  }
}

VadConfig configOfType(String type, File file, String tag) {
  if (type == 'standard') {
    return VadConfig.fromFile(file, tag);
  } else if (type == 'bmob') {
    return BmobConfig.fromFile(file);
  } else if (type == 'axios') {
    return VadConfig.fromFile(file, tag);
  } else if (type == 'vue3') {
    return VadConfig.fromFile(file, tag);
  } else {
    throw '没有找到指定配置文件(configOfType): $type';
  }
}

VadConfig defaultConfigOfType(String type) {
  if (type == 'standard') {
    return VadConfig.defaultConfig();
  } else if (type == 'bmob') {
    return BmobConfig.defaultConfig();
  } else if (type == 'axios') {
    return VadConfig.defaultConfig();
  } else if (type == 'vue3') {
    return VadConfig.defaultConfig();
  } else {
    throw '没有找到指定默认配置文件(defaultConfigOfType): $type \n'
        '可用的config值:${["standard", "bmob", "axios", "vue3"]}';
  }
}
