import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:io';
import 'vadTable.dart';

class VadProject {
  /// 下属table
  final List<VadTable> list;
  final Uri dataPath;

  VadProject({
    required this.dataPath,
    required this.list,
  });

  /// 从路径读取项目
  static VadProject fromPath(Uri dataPath) {
    Directory directory = Directory.fromUri(dataPath);
    directory.createSync(recursive: true);
    List<FileSystemEntity> list = directory.listSync();
    List<VadTable> tableList = [];
    for (var file in list) {
      if (file is File) {
        print('read:${file.path}');
        VadTable table = VadTable.formJson(
          json.decode(file.readAsStringSync()),
          path.basenameWithoutExtension(file.path),
          file.uri,
        );
        tableList.add(table);
      }
    }
    if (list.length == 0) throw '${directory.path}未发现文件';
    return VadProject(
      dataPath: dataPath,
      list: tableList,
    );
  }
}
