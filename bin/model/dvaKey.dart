///
/// 枚举：在表格中显示的样式
///
enum TableType {
  string,
  // time,
  // date,
  dateTime,
}

///
/// 枚举：在表单中显示的样式
///
enum FormType {
  string,
  date,
  time,
  datetime,
}

///
/// 枚举：提交时强制转换的格式
///
enum SubmitType {
  string,
  date,
  float,
  integer,
}

///
/// 解析单个key的描述
///

class DvaKey {
  /// 名称,键
  final String description;
  final String key;

  /// 默认值,是一个js表达式
  final String value;

  // 各种枚举类型
  final TableType tableType;
  final FormType formType;
  final SubmitType submitType;

  DvaKey({
    this.key,
    this.description,
    this.value,
    this.tableType: TableType.string,
    this.formType: FormType.string,
    this.submitType: SubmitType.string,
  });
}
