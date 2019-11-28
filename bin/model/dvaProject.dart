import 'dvaTable.dart';

class DvaProject {
  final String name;

  // /// 页面模板
  // final String pageTemp;

  // /// 数据源模板
  // final String dataSourceTemp;

  /// 下属table
  final List<DvaTable> list;

  DvaProject({
    // this.pageTemp,
    // this.dataSourceTemp,
    this.name,
    this.list,
  });
}
