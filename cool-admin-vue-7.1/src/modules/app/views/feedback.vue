<template>
	<cl-crud ref="Crud">
		<cl-row>
			<!-- 刷新按钮 -->
			<cl-refresh-btn />
			<cl-filter>
				<cl-select
					placeholder="选择状态"
					:options="options.status"
					prop="status"
					:width="120"
				/>
			</cl-filter>
			<cl-flex1 />
			<!-- 关键字搜索 -->
			<cl-search-key placeholder="搜索联系人、用户、处理人" />
		</cl-row>

		<cl-row>
			<!-- 数据表格 -->
			<cl-table ref="Table" />
		</cl-row>

		<cl-row>
			<cl-flex1 />
			<!-- 分页控件 -->
			<cl-pagination />
		</cl-row>

		<!-- 新增、编辑 -->
		<cl-upsert ref="Upsert" />
	</cl-crud>
</template>

<script lang="ts" name="app-feedback" setup>
import { useCrud, useTable, useUpsert } from "@cool-vue/crud";
import { useCool } from "/@/cool";
import { reactive } from "vue";

const options = reactive({
	status: [
		{
			label: "未处理",
			value: 0,
			color: "#E6A23C"
		},
		{
			label: "已处理",
			value: 1
		}
	]
});

const { service } = useCool();

// cl-upsert
const Upsert = useUpsert({
	items: [
		{
			prop: "status",
			label: "状态",
			component: { name: "el-radio-group", options: options.status },
			required: true
		},
		{
			prop: "remark",
			label: "备注",
			component: {
				name: "el-input",
				props: {
					type: "textarea",
					rows: 4
				}
			}
		}
	]
});

// cl-table
const Table = useTable({
	columns: [
		{ type: "selection" },
		{ prop: "avatarUrl", label: "头像", component: { name: "cl-avatar" } },
		{ prop: "nickName", label: "用户" },
		{ prop: "contact", label: "联系方式" },
		{
			prop: "content",
			label: "内容",
			component: { name: "cl-editor-preview", props: { name: "wang" } }
		},
		{ prop: "images", label: "图片", component: { name: "cl-image", props: { size: 60 } } },
		{ prop: "status", label: "状态", dict: options.status },
		{ prop: "handlerName", label: "处理人" },
		{ prop: "remark", label: "备注", showOverflowTooltip: true },
		{ prop: "createTime", label: "创建时间", sortable: "desc", width: 160 },
		{ prop: "updateTime", label: "更新时间", sortable: "custom", width: 160 },
		{
			type: "op",
			buttons({ scope }) {
				if (scope.row.status == 0) {
					return ["edit"];
				}
				return [];
			}
		}
	]
});

// cl-crud
const Crud = useCrud(
	{
		service: service.app.feedback,
		dict: {
			label: {
				update: "处理"
			}
		}
	},
	(app) => {
		app.refresh();
	}
);
</script>
