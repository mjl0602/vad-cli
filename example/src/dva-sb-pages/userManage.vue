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
      <el-table-column label="safasgfsag" align="center">
        <template slot-scope="scope">{{scope.row.asdfasf}}</template>
      </el-table-column>
      <el-table-column label="safasgfsag" align="center">
        <template slot-scope="scope">{{scope.row.asdfas214f}}</template>
      </el-table-column>
      <el-table-column label="safasgfsag" align="center">
        <template slot-scope="scope">{{scope.row.asdfa21421sf}}</template>
      </el-table-column>
      <el-table-column label="safasgfsag" align="center">
        <template slot-scope="scope">{{scope.row.asdfa4214sf}}</template>
      </el-table-column>
      <el-table-column label="safasgfs124ag" align="center">
        <template slot-scope="scope">{{scope.row.asdfa214sf}}</template>
      </el-table-column>
      <el-table-column label="更新日期" align="center">
        <template slot-scope="scope">{{scope.row.asd}}</template>
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
        <el-form-item label="safasgfsag" prop="asdfasf">
          <el-input v-model="row.asdfasf" placeholder="请输入safasgfsag" />
        </el-form-item>
        <el-form-item label="safasgfsag" prop="asdfas214f">
          <el-input v-model="row.asdfas214f" placeholder="请输入safasgfsag" />
        </el-form-item>
        <el-form-item label="safasgfsag" prop="asdfa21421sf">
          <el-input v-model="row.asdfa21421sf" placeholder="请输入safasgfsag" />
        </el-form-item>
        <el-form-item label="safasgfsag" prop="asdfa4214sf">
          <el-input v-model="row.asdfa4214sf" placeholder="请输入safasgfsag" />
        </el-form-item>
        <el-form-item label="safasgfs124ag" prop="asdfa214sf">
          <el-input v-model="row.asdfa214sf" placeholder="请输入safasgfs124ag" />
        </el-form-item>
        <el-date-picker
          v-model="row.asd"
          align="right"
          type="date"
          placeholder="选择更新日期"
          :picker-options="datePickOption"
        ></el-date-picker>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submit">提交</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import AdminTableMixin from "./basic/mixin.js";
import AdminObject from "../dva-sb-api/user.js";

export default {
  filters: {},
  mixins: [
    // 混入表格Mixin
    AdminTableMixin
  ],
  data() {
    return {
      // 本页查看的对象名称
      objStr: "user",
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
