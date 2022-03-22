import request from "@/utils/request";

import Source from "./super/dataSource.js";

export default class DataSource extends Source {
  // 默认的内容
  defaultObject = {
    avatar:'',
    
name:'管理员',
    
account:"",
    
password:'',
    
roles:[],
    
introduction:"",
    
  };

  // 表单规则
  rules = {
    avatar:[{ required: true, message: "必填", trigger: "blur" }],
    
name:[{ required: true, message: "必填", trigger: "blur" }],
    
account:[{ required: true, message: "必填", trigger: "blur" }],
    
password:[{ required: true, message: "必填", trigger: "blur" }],
    
roles:[{ required: true, message: "必填", trigger: "blur" }],
    
introduction:[{ required: true, message: "必填", trigger: "blur" }],
    
  };

  // 查询全部
  // async all(query = { pageSize: 20, page: 1 }) {
  //   let res = await request({
  //     url: `/admin`,
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
  //     url: `/admin/${id}`,
  //     method: "put",
  //     data: obj,
  //   });
  // }

  // // 添加
  // add(obj) {
  //   delete obj.id;
  //   return request({
  //     url: "/admin",
  //     method: "post",
  //     data: obj,
  //   });
  // }

  // // 通过id删除
  // deleteObj(obj) {
  //   return request({
  //     url: `/admin/${obj.id}`,
  //     method: "delete",
  //   });
  // }
}
