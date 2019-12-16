import 'vadConfig.dart';

// TODO: 未完成Config的读取等操作
class BmobConfig extends VadConfig {
  BmobConfig(
    this.bmobAppId,
    this.bmobKey,
    // String type,
    String name,
    String apiPath,
    String dataPath,
    String pagePath,
  ) : super(
          // type: type,
          name: name,
          apiPath: apiPath,
          dataPath: dataPath,
          pagePath: pagePath,
        );

  final String bmobAppId;
  final String bmobKey;
}
