<template>
	<cl-crud ref="Crud">
		<cl-row>
			<!-- 刷新按钮 -->
			<cl-refresh-btn />
			<!-- 新增按钮 -->
			<cl-add-btn />
			<!-- 删除按钮 -->
			<cl-multi-delete-btn />
			<cl-filter>
				<cl-select
					placeholder="选择状态"
					:options="options.status"
					prop="status"
					:width="120"
				/>
			</cl-filter>
			<cl-filter>
				<cl-select
					placeholder="选择类型"
					:options="options.type"
					prop="type"
					:width="120"
				/>
			</cl-filter>
			<cl-flex1 />
			<!-- 关键字搜索 -->
			<cl-search-key placeholder="搜索名称、版本" />
		</cl-row>

		<cl-row>
			<!-- 数据表格 -->
			<cl-table ref="Table">
				<template #column-forceUpdate="{ scope }">
					{{ scope.row.forceUpdate ? "是" : "否" }}
				</template>
			</cl-table>
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

<script lang="ts" name="app-version" setup>
import { useCrud, useTable, useUpsert } from "@cool-vue/crud";
import { useCool } from "/@/cool";
import { useDict } from "/$/dict";
import { computed, reactive } from "vue";
const { dict } = useDict();

const options = reactive({
	// 状态
	status: [
		{
			label: "启用",
			value: 1
		},
		{
			label: "禁用",
			value: 0
		}
	],
	// 类型
	type: computed(() => {
		return dict.get("upgradeType");
	})
});

const { service } = useCool();

// cl-upsert
const Upsert = useUpsert({
	items: [
		{ span: 12, prop: "name", label: "名称", required: true, component: { name: "el-input" } },
		{
			span: 12,
			prop: "version",
			label: "版本号",
			required: true,
			component: { name: "el-input" }
		},
		{
			prop: "description",
			label: "描述",
			required: true,
			component: {
				name: "el-input",
				props: {
					type: "textarea",
					rows: 3
				}
			}
		},
		{
			prop: "type",
			label: "类型",
			value: 0,
			component: { name: "el-radio-group", options: options.type },
			required: true
		},
		{
			prop: "url",
			label: "下载地址",
			component: { name: "cl-upload", props: { type: "file", limit: 1 } },
			required: true
		},
		{
			prop: "forceUpdate",
			label: "强制更新",
			flex: false,
			value: 0,
			component: {
				name: "cl-switch"
			},
			required: true
		},
		{
			prop: "status",
			label: "状态",
			value: 1,
			flex: false,
			component: { name: "cl-switch" },
			required: true
		}
	]
});

// cl-table
const Table = useTable({
	columns: [
		{ type: "selection" },
		{ prop: "name", label: "名称" },
		{ prop: "version", label: "版本号" },
		{ prop: "type", label: "类型", dict: options.type },
		{ prop: "url", label: "下载地址", component: { name: "cl-link" } },
		{
			prop: "forceUpdate",
			label: "强制更新",
			component: { name: "cl-date-text", props: { format: "YYYY-MM-DD" } }
		},
		{ prop: "status", label: "状态", component: { name: "cl-switch" } },
		{ prop: "description", label: "描述", showOverflowTooltip: true },
		{ prop: "createTime", label: "创建时间", sortable: "desc", width: 160 },
		{ prop: "updateTime", label: "更新时间", sortable: "custom", width: 160 },
		{ type: "op", buttons: ["edit", "delete"] }
	]
});

// cl-crud
const Crud = useCrud(
	{
		service: service.app.version
	},
	(app) => {
		app.refresh();
	}
);
</script>
