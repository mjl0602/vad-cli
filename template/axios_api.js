import request from "@/utils/request";

import Source from "../utils/dataSource.js";

export default class DataSource extends Source {
  // 默认的内容
  static defaultObject = {
    /** property */
  };

  // 表单规则
  static rules = {
    /** rules */
  };

  // 查询全部
  static all(q) {
    return request({
      url: "/##tableName##",
      method: "get",
    });
  }

  // 上传修改
  static edit(obj) {
    console.log("修改666", obj);
    return request({
      url: `/##tableName##/${obj.id}`,
      method: "put",
      data: obj,
    });
  }

  // 添加
  static add(obj) {
    return request({
      url: "/##tableName##",
      method: "post",
      data: obj,
    });
  }

  // 通过id删除
  static deleteObj(obj) {
    return request({
      url: `/##tableName##/${obj.id}`,
      method: "delete",
    });
  }
}
