import 'dart:convert';
import 'dart:io';

import '../utils/safeMap.dart';

class VadConfig {
  /// 项目类型
  final String type;

  /// 项目名
  final String name;

  /// 接口的路径，可以为空
  final String apiPath;

  /// 数据源的路径，可以为空
  final String dataPath;

  /// 页面的路径，可以为空
  final String pagePath;

  const VadConfig({
    this.type,
    this.name,
    this.apiPath,
    this.dataPath,
    this.pagePath,
  });

  VadConfig.fromJson(Map<String, dynamic> map)
      : this(
          type: SafeMap(map)['type'].string,
          name: SafeMap(map)['name'].string,
          apiPath: SafeMap(map)['apiPath'].string,
          pagePath: SafeMap(map)['pagePath'].string,
          dataPath: SafeMap(map)['dataPath'].string,
        );

  const VadConfig.defaultConfig()
      : this(
          type: 'normal',
          name: 'Vad-Cli Project',
          apiPath: './src/vad-api/',
          pagePath: './src/vad-pages/',
          dataPath: './src/vad-data/',
        );

  Map<String, dynamic> get map => {
        'type': type,
        'name': name,
        'apiPath': apiPath,
        'pagePath': pagePath,
        'dataPath': dataPath,
      };

  /// 创建默认配置
  static VadConfig fromFile(File file) {
    if (!file.existsSync()) {
      throw '没有找到config文件,读取配置失败\n你可以使用 vad config 命令来初始化一个config';
    } else {
      print('配置读取完成');
      return VadConfig.fromJson(json.decode(file.readAsStringSync()));
    }
  }

  @override
  String toString() {
    return 'VadConfig:$map';
  }
}
