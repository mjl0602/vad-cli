import Queryable, { BasicQueryParams } from "./source/queryable";

/** 模型 */
export interface AdminModel {
  /** 头像 */
  avatar: string
  /** 名称 */
  name: string
  /** 用户名 */
  account: string
  /** 密码 */
  password: string
  /** 权限 */
  roles: string[]
  /** 描述 */
  introduction: string
}

/** 搜索条件 */
export interface AdminQueryParmas extends BasicQueryParams {
  
}

/** 数据源，增删查改等请求 */
export default class AdminQuery extends Queryable <AdminModel, AdminQueryParmas > {
  // 可设置父ID，例如查询用户下的全部文章
  // constructor(id) {
  //     super();
  //     this.id = id;
  // }

  /** 对象名称 */
  get objectName(): string {
    return '数据'
  };

  // 默认的内容
  get defaultObject(): AdminModel {
    return {
      avatar:'',
      name:'管理员',
      account:"",
      password:'',
      roles:[],
      introduction:"",
    };
  }

  // 读取正在输入的数据，用于表单校验
  _valueGetter: () => Partial<AdminModel> = () => ({});

  // 已输入的数据的Getter
  get currentEditRow(): Partial<AdminModel> {
    return this._valueGetter();
  }

  // 表单规则
  get rules() {
    return {
      avatar:[{ required: true, message: "必填", trigger: "blur" }],
      name:[{ required: true, message: "必填", trigger: "blur" }],
      account:[{ required: true, message: "必填", trigger: "blur" }],
      password:[{ required: true, message: "必填", trigger: "blur" }],
      roles:[{ required: true, message: "必填", trigger: "blur" }],
      introduction:[{ required: true, message: "必填", trigger: "blur" }],
    }
  };

  // 查询全部
  // async all(params: AdminQueryParmas) {
  //   let res = await request({
  //     url: `/admin`,
  //     method: "get",
  //     params: {
  //       pageNum: query.pageNum,
  //       pageSize: query.pageSize,
  //     },
  //   });
  //   if(res.data.count==undefined) return res.data.data;
  //   return {
  //     data: res.data.data,
  //     total: res.data.count,
  //   };
  // }

  // // 上传修改
  // async edit(obj: AdminModel) {
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
  // async add(obj: AdminModel) {
  //   delete obj.id;
  //   return request({
  //     url: "/admin",
  //     method: "post",
  //     data: obj,
  //   });
  // }

  // // 通过id删除
  // async deleteObj(obj: AdminModel) {
  //   return request({
  //     url: `/admin/${obj.id}`,
  //     method: "delete",
  //   });
  // }
}