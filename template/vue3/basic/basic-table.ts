import Queryable, { BasicQueryParams, PagedData } from "../vad-api/source/queryable";
import { onMounted, ref, Ref } from "vue";
import { ElNotification, ElMessageBox } from 'element-plus'

interface TableState<T, E extends BasicQueryParams> {
  // 表格内容
  list: T[],
  total: number,
  listLoading: boolean,
  query: E,
  // 添加的Dialog
  addDialogVisible: boolean,
  isNew: boolean,
  // 增加使用的对象
  row: Partial<T>,
  rules: { [P in keyof T]?: any },
  source: Queryable<T, E>,
}

class BasicTable<T, E extends BasicQueryParams> {
  private _ref?: Ref<TableState<T, E>>;

  private get ref() {
    return this._ref!;
  }

  private get v() {
    return this._ref!.value;
  }

  private get objName() {
    return this.v.source.objectName;
  }

  static refTable = function <T, E extends BasicQueryParams = any>(
    data: Queryable<T, E>,
    queryParams: E,
  ): [Ref<TableState<T, E>>, BasicTable<T, E>] {
    const table = new BasicTable<T, E>();
    const finalConfig = {
      list: [],
      total: 0,
      listLoading: false,
      query: Object.assign(queryParams, {
        pageNum: 1,
        pageSize: 5,
      }),
      addDialogVisible: false,
      isNew: false,
      row: {},
      rules: {},
      source: data,
    };
    onMounted(() => {
      data._valueGetter = () => table.v.row;
      table.queryAll();
    })
    const tableRef = ref(finalConfig) as Ref<TableState<T, E>>
    table._ref = tableRef;
    return [
      tableRef,
      table,
    ]
  }

  // 查询
  async queryAll(args?: { resetPage: boolean }) {
    this.v.listLoading = true;
    try {
      if (args?.resetPage === true) {
        this.v.query.pageNum = 1;
      }
      let res = await this.v.source.all(this.v.query);
      if (res.hasOwnProperty("total")) {
        res = res as PagedData<T>;
        this.v.list = res.data;
        this.v.total = res.total;
      } else {
        this.v.list = res as T[];
      }
      console.log("查询数据:", this.v.list);
    } catch (error) {
      console.error(error);
      this.notifyError("查询失败", "查询数据时发生错误");
      this.v.listLoading = false;
    }
    this.v.listLoading = false;
  }
  // 增加
  async add() {
    console.log("add", this);
    this.v.isNew = true;
    this.v.row = Object.assign({}, this.v.source.defaultObject);
    this.v.rules = this.v.source.rules;
    this.v.addDialogVisible = true;
  }
  // 编辑
  edit(row: T) {
    console.log("edit", row);
    this.v.isNew = false;
    this.v.row = Object.assign({}, row);
    this.v.rules = this.v.source.rules;
    this.v.addDialogVisible = true;
  }
  // 提交（增加与修改）
  async submit(obj = this.v.row) {
    console.log("###submit", obj, this.v.isNew);
    try {
      if (this.v.isNew) {
        console.log("add");
        await this.v.source.add(this.v.row);
        this.notifySuccess("新增成功", `成功新增${this.objName}`);
      } else {
        console.log("edit");
        await this.v.source.edit(this.v.row);
        this.notifySuccess("修改成功", `${this.objName}修改成功`);
      }
      this.v.addDialogVisible = false;
      await this.queryAll();
    } catch (error) {
      console.error(error);
      this.notifyError("失败", "操作发生错误，数据提交失败");
    }
  }
  // 删除
  async deleteRow(row: T) {
    try {
      try {
        await ElMessageBox.confirm("删除操作将不能撤销, 是否继续?", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "error",
        });
      } catch (error) {
        console.error(error);
        return;
      }
      await this.v.source.deleteObj(row);
      this.notifySuccess("删除成功", `${this.objName}已被删除`);
    } catch (error) {
      console.error(error);
      this.notifyError("失败", "操作发生错误，数据提交失败");
    }
    await this.queryAll();
  }

  get dialogTitle() {
    return (this.v.isNew ? "新增" : "修改") + this.objName;
  }

  sizeChange(size: number) {
    this.v.query.pageNum = 1;
    this.v.query.pageSize = size;
    this.queryAll();
  }

  pageChange(page: number) {
    this.v.query.pageNum = page;
    this.queryAll();
  }

  notifySuccess(title: string, msg: string) {
    ElNotification({
      title: title,
      message: msg,
      type: 'success',
    })
  }
  notifyError(title: string, msg: string) {
    ElNotification({
      title: title,
      message: msg,
      type: 'error',
    })
  }
}

export default BasicTable.refTable;