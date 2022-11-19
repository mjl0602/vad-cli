
export interface BasicQueryParams {
  pageNum?: number,
  pageSize?: number,
}

export interface PagedData<T> { total: number, data: T[] }

export default abstract class Queryable<T, E> {

  get objectName(): string {
    return '数据'
  };

  // 默认的内容
  get defaultObject(): Partial<T> { return {} }

  // 读取正在输入的数据，用于表单校验
  _valueGetter: () => Partial<T> = () => ({});

  // 已输入的数据的Getter
  get currentEditRow(): Partial<T> {
    return this._valueGetter();
  }

  // 表单规则
  get rules(): { [P in keyof T]?: any } {
    return {}
  };

  // 查询全部
  async all(_: E): Promise<T[] | PagedData<T>> {
    // return [
    //   defaultObjectBuilder() as T,
    //   defaultObjectBuilder() as T,
    //   defaultObjectBuilder() as T,
    // ]
    return {
      total: 12,
      data: [
        defaultObjectBuilder() as T,
        defaultObjectBuilder() as T,
        defaultObjectBuilder() as T,
        defaultObjectBuilder() as T,
        defaultObjectBuilder() as T,
      ]
    };
  }

  // 上传修改
  edit(_: Partial<T>) {
    return asyncCompleter("修改结果");
  }

  // 添加
  add(_: Partial<T>) {
    return asyncCompleter("添加结果");
  }

  // 通过id删除
  deleteObj(_: Partial<T>) {
    return asyncCompleter("删除结果");
  }
}

function asyncCompleter(obj) {
  return new Promise((r) => {
    r(obj);
  });
}

function defaultObjectBuilder() {
  return {
    id: Math.floor(Math.random() * 10),
    name: "Name#" + Math.floor(Math.random() * 100000),
    title: "Title#" + Math.floor(Math.random() * 100000),
  };
}
