import 'dart:js' as js;
import './main.dart' as Dart;

main(List<String> args) {
  js.context['main'] = mainOfJs;
}

// TODO: js环境中，获取process相关操作的方法并不相同
mainOfJs(js.JsArray array) {
  var cm = [];
  for (var i = 0; i < array.length; i++) {
    cm.add(array[i].toString());
  }
  print('$cm');
  Dart.main(List<String>.from(cm));
}
