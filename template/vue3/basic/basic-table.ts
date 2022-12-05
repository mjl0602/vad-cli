import Queryable, { BasicQueryParams, PagedData } from "../vad-api/source/queryable";
import { onMounted, ref, Ref } from "vue";
import { ElNotification, ElMessageBox } from 'element-plus'

interface TableState<T, E extends BasicQueryParams, F extends Queryable<T, E>> {
  // 表格内容
  list: T[],
  total: number,
  listLoading: boolean,
  submitLoading: boolean,
  query: E,
  // 添加的Dialog
  addDialogVisible: boolean,
  isNew: boolean,
  // 增加使用的对象
  row: Partial<T>,
  rules: { [P in keyof T]?: any },
  source: F,
}

class BasicTable<T, E extends BasicQueryParams, F extends Queryable<T, E>> {
  private _ref?: Ref<TableState<T, E, F>>;

  private get ref() {
    return this._ref!;
  }

  private get v() {
    return this._ref!.value;
  }

  private get objName() {
    return this.v.source.objectName;
  }

  static refTable = function <T, E extends BasicQueryParams = any, F extends Queryable<T, E> = any>(
    data: Queryable<T, E>,
    queryParams: E,
  ): [Ref<TableState<T, E, F>>, BasicTable<T, E, F>] {
    const table = new BasicTable<T, E, F>();
    const finalConfig = {
      list: [],
      total: 0,
      listLoading: false,
      submitLoading: false,
      query: Object.assign({
        pageNum: 1,
        pageSize: 5,
      }, queryParams),
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
    const tableRef = ref(finalConfig) as Ref<TableState<T, E, F>>
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
  async submit(obj?: Partial<T>, forceIsNew?: boolean) {
    if (forceIsNew !== undefined) this.v.isNew = forceIsNew;
    console.log("###submit", obj, this.v.isNew);
    if (obj?.["screenX"] && obj?.["screenY"]) obj = undefined;
    obj = Object.assign({}, obj || this.v.row);
    try {
      this.v.submitLoading = true;
      if (this.v.isNew) {
        console.log("add");
        await this.v.source.add(obj);
        this.notifySuccess("新增成功", `成功新增${this.objName}`);
      } else {
        console.log("edit");
        await this.v.source.edit(obj);
        this.notifySuccess("修改成功", `${this.objName}修改成功`);
      }
      this.v.addDialogVisible = false;
      await this.queryAll();
    } catch (error) {
      console.error(error);
      this.notifyError("失败", "操作发生错误，数据提交失败");
    }
    this.v.submitLoading = false;
  }
  async act(caller: () => Promise<any>, confirm?: { title?: string, msg?: string, action?: string, success?: string, fail?: string }) {
    try {
      if (confirm?.title || confirm?.msg || confirm?.action) {
        try {
          await ElMessageBox.confirm(confirm.msg ?? "确定要继续当前操作吗?", confirm.title ?? "提示", {
            confirmButtonText: confirm.action ?? "继续",
            cancelButtonText: "取消",
            type: "info",
          });
        } catch (error) {
          console.error(error);
          return;
        }
      }
      this.v.listLoading = true;
      await caller()
      this.notifySuccess("操作成功", confirm?.success ?? `${this.objName}修改成功`);
      await this.queryAll();
    } catch (error) {
      console.error(error);
      this.notifyError("失败", confirm?.fail ?? "操作发生错误，数据提交失败");
    }
    this.v.listLoading = false;
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
      this.v.submitLoading = true;
      await this.v.source.deleteObj(row);
      this.notifySuccess("删除成功", `${this.objName}已被删除`);
    } catch (error) {
      console.error(error);
      this.notifyError("失败", "操作发生错误，数据提交失败");
    }
    this.v.submitLoading = false;
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