import '../utils/safeMap.dart';

class DvaConfig {
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

  const DvaConfig({
    this.type,
    this.name,
    this.apiPath,
    this.dataPath,
    this.pagePath,
  });

  DvaConfig.fromJson(Map<String, dynamic> map)
      : this(
          type: SafeMap(map)['type'].string,
          name: SafeMap(map)['name'].string,
          apiPath: SafeMap(map)['apiPath'].string,
          pagePath: SafeMap(map)['pagePath'].string,
          dataPath: SafeMap(map)['dataPath'].string,
        );

  const DvaConfig.defaultConfig()
      : this(
          type: 'normal',
          name: 'Dva-Cli Project',
          apiPath: './src/dva-api/',
          pagePath: './src/dva-pages/',
          dataPath: './src/dva-data/',
        );

  Map<String, dynamic> get map => {
        'type': type,
        'name': name,
        'apiPath': apiPath,
        'pagePath': pagePath,
        'dataPath': dataPath,
      };

  @override
  String toString() {
    return 'DvaConfig:$map';
  }
}
