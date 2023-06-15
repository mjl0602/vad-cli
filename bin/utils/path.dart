import 'dart:io';

/// 模板路径
Uri templatePath = Platform.script.resolve('../template/');

/// 脚本运行路径
Uri shellPath = Uri.parse(Platform.environment['PWD']!+'/');
