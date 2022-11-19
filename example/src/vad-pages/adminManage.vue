<template>
    <div class="app-container">
      <div class="filter-container-flex">
        <el-button class="filter-item" type="primary" :icon="Edit" @click="actions.add()">添加</el-button>
      </div>
      <el-table v-loading="tb.listLoading" :data="tb.list" element-loading-text="Loading" border fit
        highlight-current-row>
        <!-- 内容 -->
        <el-table-column label="头像" align="center" >
          <template #default="scope">
            <img style="height:66px;" :src="scope.row.avatar">
          </template>
        </el-table-column>
        
        <el-table-column label="名称" align="center" >
          <template #default="scope">
            {{scope.row.name}}
          </template>
        </el-table-column>
        
        <el-table-column label="用户名" align="center" >
          <template #default="scope">
            {{scope.row.account}}
          </template>
        </el-table-column>
        
        <el-table-column label="密码" align="center" >
          <template #default="scope">
            {{scope.row.password}}
          </template>
        </el-table-column>
        
        <el-table-column label="权限" align="center" >
          <template #default="scope">
            <div v-for="text in scope.row.roles" style="margin:4px;">
              <el-tag>{{text}}</el-tag>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="描述" align="center" >
          <template #default="scope">
            {{scope.row.introduction}}
          </template>
        </el-table-column>
        
        <!-- 操作 -->
        <el-table-column class-name="status-col" label="操作" align="center" width="220">
          <template #default="scope">
            <el-button-group>
              <el-button type="primary" @click="actions.edit(scope.row)" size="mini">修改</el-button>
              <el-button type="danger" @click="actions.deleteRow(scope.row)" size="mini">删除</el-button>
            </el-button-group>
          </template>
        </el-table-column>
      </el-table>
      <!-- 翻页 -->
      <div class="pagination-container" v-if="tb.total">
        <el-pagination v-model:current-page="tb.query.pageNum" :page-sizes="[5, 10, 20, 30, 50]"
          v-model:page-size="tb.query.pageSize" :total="tb.total" background
          layout="total, sizes, prev, pager, next, jumper" @size-change="(v) => actions.sizeChange(v)"
          @current-change="(v) => actions.pageChange(v)" />
      </div>
      <!-- 添加/删除数据的弹窗 -->
      <el-dialog v-model="tb.addDialogVisible" :title="actions.dialogTitle">
      <el-form-item label="头像" prop="avatar">
        <el-input v-model="tb.row.avatar" placeHolder="请输入头像"/>
      </el-form-item>
        
      <el-form-item label="名称" prop="name">
        <el-input v-model="tb.row.name" placeHolder="请输入名称"/>
      </el-form-item>
        
      <el-form-item label="用户名" prop="account">
        <el-input v-model="tb.row.account" placeHolder="请输入用户名"/>
      </el-form-item>
        
      <el-form-item label="密码" prop="password">
        <el-input v-model="tb.row.password" placeHolder="请输入密码"/>
      </el-form-item>
        
      <el-form-item label="权限" prop="roles">
        <el-checkbox-group v-model="tb.row.roles" style="width:0px;">
          <el-checkbox label="superadmin" key="superadmin" style="margin:0;"></el-checkbox>
          <el-checkbox label="admin" key="admin" style="margin:0;"></el-checkbox>
          <el-checkbox label="editor" key="editor" style="margin:0;"></el-checkbox>
        </el-checkbox-group> 
      </el-form-item>
        
      <el-form-item label="描述" prop="introduction">
        <el-input v-model="tb.row.introduction" placeHolder="请输入描述"/>
      </el-form-item>
        
        <template #footer class="dialog-footer">
          <el-button type="primary" @click="actions.submit()">提交</el-button>
        </template>
      </el-dialog>
    </div>
  </template>
  <script lang="ts" setup>
  import AdminQuery, { AdminModel, AdminQueryParmas } from '@/vad-api/admin';
  import { ElButton, ElButtonGroup, ElTable, ElTableColumn, ElDialog, ElForm, ElFormItem, ElInput, ElPagination } from 'element-plus'
  import { Edit } from '@element-plus/icons-vue'
  import refTable from './basic/basic-table';
  
  /** 创建表格，与表格相关操作 */
  const [tb, actions] = refTable<AdminModel, AdminQueryParmas>(
    new AdminQuery(),
    {
      // searchString: '',
    }
  );
  
  </script>