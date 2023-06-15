import 'dart:convert';
import 'dart:io';

import '../utils/safeMap.dart';

class VadConfig {
  /// 项目类型
  // final String type;

  /// 项目名
  final String name;

  /// 接口的路径，可以为空
  final String apiPath;

  /// 数据源的路径
  final String dataPath;

  /// 页面的路径，可以为空
  final String? pageTemplate;

  /// 数据源的路径，可以为空
  final String? apiTemplate;

  /// 页面的路径，可以为空
  final String? dataSource;

  /// 数据源的路径，可以为空
  final String? mixinPath;

  Uri get dataUri => Uri.parse(dataPath);

  /// 页面的路径，可以为空
  final String pagePath;

  const VadConfig({
    // this.type,
    required this.name,
    required this.apiPath,
    required this.dataPath,
    required this.pagePath,
    this.pageTemplate,
    this.apiTemplate,
    this.dataSource,
    this.mixinPath,
  });

  VadConfig.fromJson(Map<String, dynamic> map)
      : this(
          // type: SafeMap(map)['type'].string,
          name: SafeMap(map)['name'].string ?? '',
          apiPath: SafeMap(map)['apiPath'].string ?? '',
          pagePath: SafeMap(map)['pagePath'].string ?? '',
          dataPath: SafeMap(map)['dataPath'].string ?? '',
          pageTemplate: SafeMap(map)['pageTemplate'].string,
          apiTemplate: SafeMap(map)['apiTemplate'].string,
          dataSource: SafeMap(map)['pageTemplate'].string,
          mixinPath: SafeMap(map)['apiTemplate'].string,
        );

  const VadConfig.defaultConfig()
      : this(
          // type: 'normal',
          name: 'Vad-Cli Project',
          apiPath: './src/vad-api/',
          pagePath: './src/vad-pages/',
          dataPath: './src/vad-raw-json/',
        );

  Map<String, dynamic> get map => {
        // 'type': type,
        'name': name,
        'apiPath': apiPath,
        'pagePath': pagePath,
        'dataPath': dataPath,
        'pageTemplate': pageTemplate,
        'apiTemplate': apiTemplate,
        'dataSource': dataSource,
        'mixinPath': mixinPath,
      };

  /// 创建默认配置
  static VadConfig fromFile(File file, String tag) {
    if (!file.existsSync()) {
      throw '没有找到config文件,读取配置失败\n你可以使用 vad config 命令来初始化一个config';
    } else {
      print('配置读取完成 ${tag}');
      var jsonConfig = json.decode(file.readAsStringSync());
      var map = SafeMap(jsonConfig);
      var config = map['override'][tag];
      if ((config.map ?? {}).isNotEmpty) {
        print('已经按tag重写配置：${tag}');
        for (var key in config.map!.keys) {
          jsonConfig[key] = config.map![key];
        }
        print('重写配置成功：${jsonConfig}');
      } else {
        print('未匹配tag：${tag}');
      }
      return VadConfig.fromJson(jsonConfig);
    }
  }

  @override
  String toString() {
    return 'VadConfig:$map';
  }
}
