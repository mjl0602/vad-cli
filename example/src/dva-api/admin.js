import Source from "../super/dataSource.js";

/**
 * 增删查改等处理
 */

export default class DataSource extends Source {
  // 默认的内容
  defaultObject = {
    roles:"",
    
update:23135,
    
name:23135,
    
  };

  // 表单规则
  rules = {
    roles:[{ required: true, message: "必填", trigger: "blur" }],
    
update:[{ required: true, message: "必填", trigger: "blur" }],
    
name:[{ required: true, message: "必填", trigger: "blur" }],
    
  };
  /**
   * 【查询全部】
   * 如果返回数组对象，则页面不翻页，
   * 如果返回{total:88,data:[]}对象，
   * 则页面出现翻页标签。
   *
   * */
  //   async all(q) {}

  //   // 上传修改
  //   async edit(obj) {}

  //   // 添加
  //   async add(obj) {}

  //   // 删除
  //   async deleteObj(obj) {}
}
