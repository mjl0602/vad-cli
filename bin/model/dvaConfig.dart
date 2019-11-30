import '../utils/safeMap.dart';
import 'package:path/path.dart' as path;

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

  // String get relativeFromPageToMixin {
  //   Uri.parse(
  //     path.relative(
  //       Uri.parse(dataPath).resolve('admin'),
  //       from: pagePath,
  //     ),
  //   ).resolve('${name}.js').path;
  // }

  const DvaConfig({
    this.type: 'normal',
    this.name: 'Dva-Cli Project',
    this.apiPath: './src/dva-api/',
    this.pagePath: './src/dva-pages/',
    this.dataPath: './src/dva-data/',
  });

  DvaConfig.fromJson(Map<String, dynamic> map)
      : this(
          type: SafeMap(map)['type'].string,
          name: SafeMap(map)['name'].string,
          apiPath: SafeMap(map)['apiPath'].string,
          pagePath: SafeMap(map)['pagePath'].string,
          dataPath: SafeMap(map)['dataPath'].string,
        );

  const DvaConfig.defaultConfig() : this();

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
