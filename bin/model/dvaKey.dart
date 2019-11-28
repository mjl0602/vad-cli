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
  number,
  float,
  integer,
}

///
/// 解析单个key的描述
///

class DvaKey {
  /// 名称
  final String description;

  /// 默认值
  final String value;

  // 各种枚举类型
  final TableType tableType;
  final FormType formType;
  final SubmitType submitType;

  DvaKey({
    this.value,
    this.description,
    this.tableType,
    this.formType,
    this.submitType,
  });
}
