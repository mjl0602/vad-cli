import '../model/dvaConfig.dart';
import '../model/dvaProject.dart';
import '../utils/path.dart';
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
  Uri get apiTemplate => templatePath.resolve('bmob_api.js');
}
