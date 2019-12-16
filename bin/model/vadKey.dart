import '../utils/type.dart';


/// 解析单个key的描述
/// 必须的参数：
/// key: 键(例如[password])
/// description: 描述(例如[密码])
class VadKey {
  /// 名称,键
  final String description;
  final String key;

  /// html属性字符串，通常用来控制宽度
  /// 例如: [min-width='30']
  /// 或者: [v-if='isSuperAdmin'] (需要添加属性)
  final String property;

  /// 默认值,是一个js表达式
  final String value;

  // 各种枚举类型
  final TableType tableType;
  final FormType formType;
  final SubmitType submitType;

  VadKey(
    this.key,
    this.description, {
    this.value,
    this.property,
    this.tableType: TableType.string,
    this.formType: FormType.string,
    this.submitType: SubmitType.string,
  });
}
