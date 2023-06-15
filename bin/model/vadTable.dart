import '../utils/safeMap.dart';
import '../utils/textTransfer.dart';
import '../utils/type.dart';
import 'vadKey.dart';

class VadTable {
  /// TODO: 路由创建

  /// TODO: 权限,用于路由创建
  // final List<String> permission;

  /// TODO: 有同样父级的table在边栏合并在一起
  // final String parent;

  final String name;
  final List<VadKey> list;

  // 驼峰表名
  String get camelName => TextTransfer.camelName(name);

  /// 表所在的文件
  final Uri dataUri;

  VadTable({
    required this.dataUri,
    required this.name,
    required this.list,
  }) : assert(dataUri != null);

  /// 通过闭包创建一行，闭包会反复执行，并以`\n`连接
  String build(String Function(VadKey) builder) =>
      list.map<String>(builder).join('\n').trimLeft();

  /// TODO: 直接在这里读文件还靠谱点，因为一个table对应一个文件
  static VadTable? formFile(Uri dataUri) => null;

  /// 读取json
  static VadTable formJson(
    Map<String, dynamic> map,
    String tableName,
    Uri dataUri,
  ) {
    SafeMap safeMap = SafeMap(map);
    List<VadKey> list = [];
    for (var key in map.keys) {
      var value = safeMap[key];
      if (value.string != null) {
        list.add(VadKey(
          key,
          value.string ?? '',
          value: '""',
        ));
      } else if (value.map != null) {
        var config = SafeMap(value.map);
        list.add(VadKey(
          key,
          config['description'].value ?? '??',
          value: config['defaultValue'].value ?? '""',
          property: config['property'].value,
          tableType: tableTypeOfStr(config['type'].string ?? ''),
          formType: formTypeOfStr(config['formType'].string ?? ''),
          submitType: submitTypeOfStr(config['submitType'].string ?? ''),
        ));
      } else {
        print('$tableName 未读取成功');
      }
    }
    return VadTable(
      dataUri: dataUri,
      name: tableName,
      list: list,
    );
  }
}
