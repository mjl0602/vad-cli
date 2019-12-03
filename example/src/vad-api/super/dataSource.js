function defaultObjectBuilder() {
  return {
    id: parseInt(Math.random() * 10),
    title: "Title#" + parseInt(Math.random() * 100000),
  };
}

/**
 * 默认的表格管理类，封装了增删查改
 */
export default class DataSource {
  // 默认的内容
  static defaultObject = {
    id: "",
    title: "",
  };

  // 表单规则
  static rules = {
    title: [{ required: false, message: "必填", trigger: "blur" }],
  };

  // 查询全部
  static all() {
    return asyncCompleter([
      defaultObjectBuilder(),
      defaultObjectBuilder(),
      defaultObjectBuilder(),
    ]);
  }

  // 上传修改
  static edit(obj) {
    return asyncCompleter("修改结果");
  }

  // 添加
  static add(obj) {
    return asyncCompleter("添加结果");
  }

  // 通过id删除
  static deleteObj(obj) {
    return asyncCompleter("删除结果");
  }
}

function asyncCompleter(obj) {
  console.log("模拟返回");
  return new Promise((r, e) => {
    r(obj);
  });
}
