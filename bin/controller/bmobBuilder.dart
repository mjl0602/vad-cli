import '../model/dvaConfig.dart';
import '../model/dvaKey.dart';
import '../model/dvaProject.dart';
import '../utils/path.dart';
import '../utils/type.dart';
import 'builder.dart';

/// Bmob的builder，使用一个不同的template
class BmobProjectBuilder extends DvaProjectBuilder {
  BmobProjectBuilder(
    DvaConfig config,
    DvaProject project,
  ) : super(
          config,
          project,
        );
  @override
  String sumitTemp(DvaKey key) {
    String str = '';
    switch (key.submitType) {
      case SubmitType.string:
        str = 'res.set("###", obj.###)\n';
        break;
      case SubmitType.date:
        str = 'res.set("###", new Date(obj.###))\n';
        break;
      case SubmitType.float:
        str = 'res.set("###", parseFloat(obj.###))\n';
        break;
      case SubmitType.integer:
        str = 'res.set("###", parseInt(obj.###))\n';
        break;
    }
    return str.replaceAll('@@@', key.description).replaceAll('###', key.key);
  }

  @override
  Uri get apiTemplate => templatePath.resolve('bmob_api.js');
}
