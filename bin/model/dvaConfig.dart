import '../utils/safeMap.dart';

class DvaConfig {
  final String type;
  final String name;

  /// 数据的路径，可以为空
  final String dataPath;

  /// 页面的路径，可以为空
  final String pagePath;

  const DvaConfig({
    this.type,
    this.name,
    this.dataPath,
    this.pagePath,
  });

  DvaConfig.fromJson(Map<String, dynamic> map)
      : this(
          type: SafeMap(map)['type'].string,
          name: SafeMap(map)['name'].string,
          dataPath: SafeMap(map)['dataPath'].string,
          pagePath: SafeMap(map)['pagePath'].string,
        );

  const DvaConfig.defaultConfig()
      : this(
          type: 'normal',
          name: 'Dva-Cli Project',
          dataPath: './src/table-data/',
          pagePath: './src/table-page/',
        );

  Map<String, dynamic> get map => {
        'type': type,
        'name': name,
        'dataPath': dataPath,
        'pagePath': pagePath,
      };

  @override
  String toString() {
    return 'DvaConfig:$map';
  }
}
