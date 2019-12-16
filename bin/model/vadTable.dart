import '../utils/safeMap.dart';
import '../utils/type.dart';
import 'vadKey.dart';

class VadTable {
  /// TODO: 路由创建

  /// TODO:权限,用于路由创建
  // final List<String> permission;

  /// TODO: 有同样父级的table在边栏合并在一起
  // final String parent;

  final String name;
  final List<VadKey> list;

  VadTable({
    this.name,
    this.list,
  });

  /// 通过闭包创建当前行，闭包会反复执行，并以`\n`连接
  String build(String Function(VadKey) builder) =>
      list.map<String>(builder).join('\n');

  /// 读取json
  static VadTable formJson(Map<String, dynamic> map, String tableName) {
    SafeMap safeMap = SafeMap(map);
    List<VadKey> list = [];
    for (var key in map.keys) {
      var value = safeMap[key];
      if (value.string != null) {
        list.add(VadKey(
          key,
          value.string,
          value: '""',
        ));
      } else if (value.map != null) {
        var config = SafeMap(value.map);
        list.add(VadKey(
          key,
          config['description'].value ?? '??',
          value: config['defaultValue'].value ?? '??',
          property: config['property'].value,
          tableType: tableTypeOfStr(config['type'].string),
          formType: formTypeOfStr(config['formType'].string),
          submitType: submitTypeOfStr(config['submitType'].string),
        ));
      } else {
        print('$tableName 未读取成功');
      }
    }
    return VadTable(
      name: tableName,
      list: list,
    );
  }
}
