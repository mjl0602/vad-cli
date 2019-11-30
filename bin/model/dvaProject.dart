import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:io';
import 'dvaTable.dart';

class DvaProject {
  /// 下属table
  final List<DvaTable> list;

  DvaProject({
    this.list,
  });

  // 从路径读取项目
  static DvaProject fromPath(Uri dataPath) {
    Directory directory = Directory.fromUri(dataPath);
    directory.createSync(recursive: true);
    List<FileSystemEntity> list = directory.listSync();
    List<DvaTable> tableList = [];
    for (var file in list) {
      if (file is File) {
        DvaTable table = DvaTable.formJson(
          json.decode(file.readAsStringSync()),
          path.basenameWithoutExtension(file.path),
        );
        tableList.add(table);
      }
    }
    return DvaProject(
      list: tableList,
    );
  }
}
