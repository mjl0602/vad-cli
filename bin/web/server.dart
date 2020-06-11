import 'dart:io';

import '../config/vadConfig.dart';

class VadServer {
  static Future start(VadConfig config) async {
    /// 打开页面
    final ProcessResult result = Process.runSync(
      'open',
      ['./bin/web/edit.html'],
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
      print(request.uri);
      // 全部跨域
      request.response.headers.add('Access-Control-Allow-Origin', '*');
      String path = request.uri.path;
      String methods = request.method;
      if (methods == 'GET' && path == '/edit') {
        request.response
          ..write('Edit')
          ..close();
      } else if (methods == 'GET' && path.startsWith('/edit/')) {
        var key = path.split('/').last;
        var filePath = config.dataUri.resolve('$key.json');
        var content = File.fromUri(filePath).readAsStringSync();
        request.response
          ..write(content)
          ..close();
      } else {
        request.response
          ..write('Hello World!')
          ..close();
      }
    }
    return;
  }
}
