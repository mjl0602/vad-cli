import DataSource from "../../../dva-api/super/dataSource.js";

export default {
  computed: {
    dialogTitle() {
      return (this.isNew ? "新增" : "修改") + this.objStr;
    },
  },
  filters: {},
  data() {
    return {
      // 表格内容
      objStr: "#对象#",
      list: [],
      listLoading: true,
      query: {
        total: 0,
        pageSize: 5,
        page: 1,
      },
      // 添加的Dialog
      addDialogVisible: false,
      isNew: false,
      // 增加使用的对象
      row: {},
      rules: {},
      source: new DataSource(),
      datePickOption: {
        shortcuts: [
          {
            text: "今天",
            onClick(picker) {
              picker.$emit("pick", new Date());
            },
          },
          {
            text: "昨天",
            onClick(picker) {
              const date = new Date();
              date.setTime(date.getTime() - 3600 * 1000 * 24);
              picker.$emit("pick", date);
            },
          },
          {
            text: "一周前",
            onClick(picker) {
              const date = new Date();
              date.setTime(date.getTime() - 3600 * 1000 * 24 * 7);
              picker.$emit("pick", date);
            },
          },
        ],
      },
    };
  },
  created() {
    this.queryAll();
  },
  methods: {
    // 查询
    async queryAll() {
      this.listLoading = true;
      try {
        let res = await this.source.all(this.query);
        if (res.total) {
          this.list = res.data;
          this.query.total = res.total;
        } else {
          this.list = res;
        }
        console.log("查询数据:", this.list);
      } catch (error) {
        console.error(error);
        this.notifyError("查询失败", "查询数据时发生错误");
        this.listLoading = false;
      }
      this.listLoading = false;
    },
    // 增加
    async add() {
      this.isNew = true;
      this.row = Object.assign({}, this.source.defaultObject);
      this.rules = DataSource.rules;
      this.addDialogVisible = true;
    },
    // 编辑
    edit(row) {
      console.log("edit", row);
      this.isNew = false;
      this.row = Object.assign({}, row);
      this.rules = DataSource.rules;
      this.addDialogVisible = true;
    },
    // 提交（增加与修改）
    async submit(obj = this.row) {
      console.log("###submit", obj, this.isNew);
      try {
        if (this.isNew) {
          console.log("add");
          await this.source.add(this.row);
          this.notifySuccess("新增成功", `成功新增${this.objStr}`);
        } else {
          console.log("edit");
          await this.source.edit(this.row);
          this.notifySuccess("修改成功", `${this.objStr}修改成功`);
        }
      } catch (error) {
        console.error(error);
        this.notifyError("失败", "操作发生错误，数据提交失败.");
      }

      this.addDialogVisible = false;
      await this.queryAll();
    },
    // 删除
    async deleteRow(row) {
      await this.$confirm("删除操作将不能撤销, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "error",
      });
      await this.source.deleteObj(row);
      this.notifySuccess("删除成功", `${this.objStr}已被删除`);
      await this.queryAll();
    },
    handleSizeChange(size) {
      this.query.page = 1;
      this.query.pageSize = size;
      console.log("handleSizeChange", size);
      this.queryAll();
    },
    handleCurrentChange(page) {
      this.query.page = page;
      console.log("handleCurrentChange", page);
      this.queryAll();
    },
    // 工具方法
    goback() {
      this.$router.go(-1);
    },
    notifyError(title, detail) {
      this.$notify({
        title: title,
        message: detail,
        type: "error",
        duration: 2000,
      });
    },
    notifyWarning(title, detail) {
      this.$notify({
        title: title,
        message: detail,
        type: "warning",
        duration: 2000,
      });
    },
    notifySuccess(title, detail) {
      this.$notify({
        title: title,
        message: detail,
        type: "success",
        duration: 2000,
      });
    },

    needInterface() {
      this.$notify({
        title: "等待开发",
        message: "需要后台接口",
        type: "warning",
        duration: 2000,
      });
    },

    fakePromise() {
      return new Promise((r, e) => {
        r();
      });
    },
  },
};
