import 'dvaKey.dart';

class DvaTable {
  final String name;
  final List<DvaKey> list;

  /// 通过闭包创建当前行
  String build(String Function(DvaKey) builder) =>
      list.map<String>(builder).join('\n');

  DvaTable({
    this.name,
    this.list,
  });

  
}
