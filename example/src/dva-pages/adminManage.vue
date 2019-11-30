<template>
  <div class="app-container">
    <div class="filter-container">
      <el-button class="filter-item" type="primary" icon="el-icon-edit" @click="add">添加</el-button>
    </div>
    <el-table
      v-loading="listLoading"
      :data="list"
      element-loading-text="Loading"
      border
      fit
      highlight-current-row
    >
      <!-- 内容 -->
          <el-table-column label="角色" align="center">
      <template slot-scope="scope">
        {{scope.row.roles}}
      </template>
    </el-table-column>
    <el-table-column label="更新日期" align="center">
      <template slot-scope="scope">
        {{scope.row.update}}
      </template>
    </el-table-column>
    <el-table-column label="NNNNN" align="center">
      <template slot-scope="scope">
        {{scope.row.name}}
      </template>
    </el-table-column>
      <!-- 操作 -->
      <el-table-column class-name="status-col" label="操作" align="center" width="220">
        <template slot-scope="scope">
          <el-button-group>
            <el-button type="primary" @click="edit(scope.row)" size="mini">修改</el-button>
            <el-button type="danger" @click="deleteRow(scope.row)" size="mini">删除</el-button>
          </el-button-group>
        </template>
      </el-table-column>
    </el-table>
    <!-- 翻页 -->
    <div class="pagination-container" v-if="query.total">
      <el-pagination
        :current-page="query.pageNum"
        :page-sizes="[5,10,20,30,50]"
        :page-size="query.pageSize"
        :total="query.total"
        background
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>
    <el-dialog :visible.sync="addDialogVisible" :title="dialogTitle">
      <el-form
        :model="row"
        :rules="source.rules"
        label-position="left"
        label-width="100px"
        style="width: 400px; margin-left:50px;"
      >
            <el-form-item label="角色" prop="roles">
      <el-input v-model="row.roles" placeHolder="请输入角色"/>
    </el-form-item>
    <el-date-picker
      v-model="row.update"
      align="right"
      type="date"
      placeholder="选择更新日期"
      :picker-options="datePickOption"
      >
    </el-date-picker>
        
    <el-date-picker
      v-model="row.name"
      align="right"
      type="date"
      placeholder="选择NNNNN"
      :picker-options="datePickOption"
      >
    </el-date-picker>
        
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submit">提交</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import AdminTableMixin from "./basic/mixin.js";
import AdminObject from "../dva-api/admin.js";

export default {
  filters: {},
  mixins: [
    // 混入表格Mixin
    AdminTableMixin
  ],
  data() {
    return {
      // 本页查看的对象名称
      objStr: "admin",
      // 数据源
      source: new AdminObject()
      // rules: this.source.rules,
    };
  },
  methods: {}
};
</script>
<style>
</style>
