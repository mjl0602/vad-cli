import '../utils/safeMap.dart';
import '../utils/type.dart';



///
/// 解析单个key的描述
///

class VadKey {
  /// 名称,键
  final String description;
  final String key;

  /// 默认值,是一个js表达式
  final String value;

  // 各种枚举类型
  final TableType tableType;
  final FormType formType;
  final SubmitType submitType;

  VadKey({
    this.key,
    this.description,
    this.value,
    this.tableType: TableType.string,
    this.formType: FormType.string,
    this.submitType: SubmitType.string,
  });


}