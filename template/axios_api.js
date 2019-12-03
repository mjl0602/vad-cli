import request from "@/utils/request";

import Source from "./super/dataSource.js";

export default class DataSource extends Source {
  // 默认的内容
  defaultObject = {
    /** property */
  };

  // 表单规则
  rules = {
    /** rules */
  };

  // 查询全部
  async all(query = { pageSize: 20, page: 1 }) {
    let res = await request({
      url: `/##tableName##`,
      method: "get",
      params: {
        skip: (query.page - 1) * query.pageSize,
        range: query.pageSize,
      },
    });
    return {
      data: res.data.data,
      total: res.data.count || 99,
    };
  }
  // 上传修改
  edit(obj) {
    console.log("修改666", obj);
    return request({
      url: `/##tableName##/${obj.id}`,
      method: "put",
      data: obj,
    });
  }

  // 添加
  add(obj) {
    return request({
      url: "/##tableName##",
      method: "post",
      data: obj,
    });
  }

  // 通过id删除
  deleteObj(obj) {
    return request({
      url: `/##tableName##/${obj.id}`,
      method: "delete",
    });
  }
}
