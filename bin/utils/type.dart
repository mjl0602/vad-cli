///
/// 枚举：在表格中显示的样式
///
enum TableType {
  string,
  // time,
  // date,
  dateTime,
  tagArray,
}

///
/// 枚举：在表单中显示的样式
///
enum FormType {
  string,
  date,
  time,
  dateTime,
  stringArray,
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

TableType tableTypeOfStr(String str) {
  if (str == 'string') {
    return TableType.string;
  } else if (str == 'dateTime') {
    return TableType.dateTime;
  } else if (str == 'tagArray') {
    return TableType.tagArray;
  }
  return TableType.string;
}

FormType formTypeOfStr(String str) {
  if (str == 'string') {
    return FormType.string;
  } else if (str == 'date') {
    return FormType.date;
  } else if (str == 'time') {
    return FormType.time;
  } else if (str == 'dateTime') {
    return FormType.dateTime;
  } else if (str == 'stringArray') {
    return FormType.stringArray;
  }
  return FormType.string;
}

SubmitType submitTypeOfStr(String str) {
  if (str == 'string') {
    return SubmitType.string;
  } else if (str == 'date') {
    return SubmitType.date;
  } else if (str == 'float') {
    return SubmitType.float;
  } else if (str == 'integer') {
    return SubmitType.integer;
  }
  return SubmitType.string;
}
