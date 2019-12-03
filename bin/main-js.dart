import 'dart:js' as js;
import './main.dart' as Dart;

main(List<String> args) {
  js.context['main'] = mainOfJs;
}

mainOfJs(js.JsArray array) {
  var cm = [];
  for (var i = 0; i < array.length; i++) {
    cm.add(array[i].toString());
  }
  print('$cm');
  Dart.main(List<String>.from(cm));
}
