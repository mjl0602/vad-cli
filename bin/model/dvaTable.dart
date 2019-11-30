import 'dvaKey.dart';

class DvaTable {
  final String name;
  final List<DvaKey> list;

  /// 通过闭包创建当前行，闭包会反复执行，并以`\n`连接
  String build(String Function(DvaKey) builder) =>
      list.map<String>(builder).join('\n');

  DvaTable({
    this.name,
    this.list,
  });
}
