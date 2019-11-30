import '../utils/safeMap.dart';
import '../utils/type.dart';
import 'dvaKey.dart';

class DvaTable {
  final String name;
  final List<DvaKey> list;

  DvaTable({
    this.name,
    this.list,
  });

  /// 通过闭包创建当前行，闭包会反复执行，并以`\n`连接
  String build(String Function(DvaKey) builder) =>
      list.map<String>(builder).join('\n');

  /// 读取json
  static DvaTable formJson(Map<String, dynamic> map, String tableName) {
    SafeMap safeMap = SafeMap(map);
    List<DvaKey> list = [];
    for (var key in map.keys) {
      var value = safeMap[key];
      if (value.string != null) {
        list.add(DvaKey(
          key: key,
          description: value.string,
          value: '""',
        ));
      } else if (value.map != null) {
        var config = SafeMap(value.map);
        list.add(DvaKey(
          key: key,
          description: config['description'].value ?? '??',
          value: config['defaultValue'].value ?? '??',
          tableType: tableTypeOfStr(config['type'].string),
          formType: formTypeOfStr(config['formType'].string),
          submitType: submitTypeOfStr(config['submitType'].string),
        ));
      } else {
        print('$tableName 未读取成功');
      }
    }
    return DvaTable(
      name: tableName,
      list: list,
    );
  }
}
