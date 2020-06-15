///
/// 枚举：在表格中显示的样式
///
enum TableType {
  string,
  boolean,
  image,
  dateTime,
  tagArray,
}

const List<String> tableTypeKeyWords = [
  "string",
  "bool",
  "image",
  "dateTime",
  "tagArray",
];

String strOfTableType(TableType type) {
  switch (type) {
    case TableType.string:
      return "string";
    case TableType.boolean:
      return "bool";
    case TableType.image:
      return "image";
    case TableType.dateTime:
      return "dateTime";
    case TableType.tagArray:
      return "tagArray";
  }
  return "";
}

TableType tableTypeOfStr(String str) {
  if (str == 'string') {
    return TableType.string;
  } else if (str == 'dateTime') {
    return TableType.dateTime;
  } else if (str == 'tagArray') {
    return TableType.tagArray;
  } else if (str == 'bool') {
    return TableType.boolean;
  } else if (str == 'image') {
    return TableType.image;
  }
  return TableType.string;
}

///
/// 枚举：在表单中显示的样式
/// TODO:增加长文本格式
enum FormType {
  string,
  date,
  boolean,
  time,
  dateTime,
  stringArray,
}

const List<String> formTypeKeyWords = [
  "bool",
  "string",
  "date",
  "bool",
  "time",
  "dateTime",
  "stringArray",
];

String strOfFormType(FormType type) {
  switch (type) {
    case FormType.string:
      return "string";
    case FormType.date:
      return "date";
    case FormType.boolean:
      return "bool";
    case FormType.time:
      return "time";
    case FormType.dateTime:
      return "dateTime";
    case FormType.stringArray:
      return "stringArray";
  }
  return "";
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
  } else if (str == 'bool') {
    return FormType.boolean;
  }
  return FormType.string;
}

///
/// 枚举：提交时强制转换的格式
///
enum SubmitType {
  string,
  date,
  float,
  integer,
  boolean,
}

const List<String> submitTypeKeyWords = [
  "string",
  "date",
  "bool",
  "float",
  "integer",
];

String strOfSubmitType(SubmitType type) {
  switch (type) {
    case SubmitType.string:
      return "string";
    case SubmitType.date:
      return "date";
    case SubmitType.boolean:
      return "bool";
    case SubmitType.float:
      return "float";
    case SubmitType.integer:
      return "integer";
      break;
  }
  return "";
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
  } else if (str == 'bool') {
    return SubmitType.boolean;
  }
  return SubmitType.string;
}
