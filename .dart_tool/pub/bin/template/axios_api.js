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
  // async all(query = { pageSize: 20, page: 1 }) {
  //   let res = await request({
  //     url: `/##tableName##`,
  //     method: "get",
  //     params: {
  //       skip: (query.page - 1) * query.pageSize,
  //       range: query.pageSize,
  //     },
  //   });
  //   if(res.data.count==undefined) return res.data.data;
  //   return {
  //     data: res.data.data,
  //     total: res.data.count,
  //   };
  // }
  // // 上传修改
  // edit(obj) {
  //   console.log("修改", obj);
  //   let id = obj.id;
  //   delete obj.id;
  //   return request({
  //     url: `/##tableName##/${id}`,
  //     method: "put",
  //     data: obj,
  //   });
  // }

  // // 添加
  // add(obj) {
  //   delete obj.id;
  //   return request({
  //     url: "/##tableName##",
  //     method: "post",
  //     data: obj,
  //   });
  // }

  // // 通过id删除
  // deleteObj(obj) {
  //   return request({
  //     url: `/##tableName##/${obj.id}`,
  //     method: "delete",
  //   });
  // }
}
