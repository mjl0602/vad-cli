import '../config/vadConfig.dart';
import '../model/vadProject.dart';
import '../utils/path.dart';
import 'builder.dart';

class AxiosBuilder extends VadProjectBuilder {
  AxiosBuilder(
    VadConfig config,
    VadProject project,
  ) : super(
          config,
          project,
        );
  @override
  Uri get apiTemplate => templatePath.resolve('axios_api.js');
}
