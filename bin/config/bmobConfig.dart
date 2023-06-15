import 'dart:convert';
import 'dart:io';

import '../utils/safeMap.dart';
import 'vadConfig.dart';

/// TODO: 未完成key的操作
/// TODO: 未完成自动生成json
class BmobConfig extends VadConfig {
  const BmobConfig({
    this.bmobAppId,
    this.bmobKey,
    // String type,
    required String name,
    required String apiPath,
    required String dataPath,
    required String pagePath,
  }) : super(
          // type: type,
          name: name,
          apiPath: apiPath,
          dataPath: dataPath,
          pagePath: pagePath,
        );

  final String? bmobAppId;
  final String? bmobKey;

  BmobConfig.fromJson(SafeMap map)
      : this(
          bmobAppId: map['bmob']['appid'].string,
          bmobKey: map['bmob']['key'].string,
          name: map['name'].string ?? '',
          apiPath: map['apiPath'].string ?? '',
          pagePath: map['pagePath'].string ?? '',
          dataPath: map['dataPath'].string ?? '',
        );

  const BmobConfig.defaultConfig()
      : this(
          name: 'Vad-Cli Bmob Project',
          apiPath: './src/vad-api/',
          pagePath: './src/vad-pages/',
          dataPath: './src/vad-raw-json/',
        );

  Map<String, dynamic> get map => {
        'bmob': {
          'appid': bmobAppId,
          'key': bmobKey,
        },
        'name': name,
        'apiPath': apiPath,
        'pagePath': pagePath,
        'dataPath': dataPath,
      };

  /// 创建默认配置
  static BmobConfig fromFile(File file) {
    if (!file.existsSync()) {
      throw '没有找到config文件,读取配置失败\n你可以使用 vad config -m bmob 命令来初始化一个config';
    } else {
      print('配置读取完成');
      return BmobConfig.fromJson(SafeMap(json.decode(file.readAsStringSync())));
    }
  }

  @override
  String toString() {
    return 'BmobConfig:$map';
  }
}
