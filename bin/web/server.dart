import 'dart:convert';
import 'dart:io';

import '../config/vadConfig.dart';
import '../model/vadProject.dart';

class VadServer {
  static Future start(VadConfig config) async {
    var editPagePath = Platform.script.resolve('../bin/web/edit.html').path;

    /// 打开页面
    final ProcessResult result = Process.runSync(
      'open',
      [editPagePath],
      runInShell: true,
    );

    print('Server Shell ExitCode: ${result.exitCode}');
    print('Server Shell Result: ${result.stdout}');

    /// 启动服务器
    var requestServer = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      8045,
    );
    //监听请求
    await for (HttpRequest request in requestServer) {
      print(request.method);
      print(request.uri);
      // 全部跨域
      request.response.headers.add('Access-Control-Allow-Origin', '*');
      request.response.headers
          .add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
      request.response.headers.add(
        'Access-Control-Allow-Headers',
        'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization',
      );
      request.response.headers.contentType = ContentType.json;
      // request.response.headers.a;
      String path = request.uri.path;
      String methods = request.method;
      if (methods == 'GET' && path == '/ping') {
        request.response
          ..write('pong')
          ..close();
      } else if (methods == 'GET' && path.startsWith('/edit/')) {
        var key = path.split('/').last;
        var filePath = config.dataUri.resolve('$key.json');
        var content = File.fromUri(filePath).readAsStringSync();
        request.response
          ..write(content)
          ..close();
      } else if (methods == 'POST' && path.startsWith('/edit/')) {
        var key = path.split('/').last;
        var filePath = config.dataUri.resolve('$key.json');
        // 取出Post的Data
        var data = await _dataOf(request);
        request.response
          ..write('OK')
          ..close();
        // TODO: 保存文件修改
      } else if (methods == 'GET' && path.startsWith('/allKeys')) {
        var project = VadProject.fromPath(config.dataUri);
        var nameList = project.list.map<String>((d) => d.name).toList();
        request.response
          ..write(nameList)
          ..close();
      } else {
        request.response
          ..write('Command Not Found')
          ..close();
      }
    }
    return;
  }
}

Future<Map<String, dynamic>> _dataOf(HttpRequest request) async {
  var raw = await request.toList();
  print(raw);
  var str = String.fromCharCodes(raw.first);
  return json.decode(str);
}
