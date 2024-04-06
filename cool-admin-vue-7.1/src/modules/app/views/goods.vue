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
			<cl-search-key placeholder="搜索标题" />
		</cl-row>

		<cl-row>
			<!-- 数据表格 -->
			<cl-table ref="Table">
				<template #column-tagColor="{ scope }">
					<!-- 显示颜色 -->
					<el-tag :style="{ backgroundColor: scope.row.tagColor }" />
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

<script lang="ts" name="app-goods" setup>
import { useCrud, useTable, useUpsert } from "@cool-vue/crud";
import { useCool } from "/@/cool";
import { reactive } from "vue";

const options = reactive({
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
	type: [
		{ label: "天", value: 0 },
		{ label: "月", value: 1, color: "#67C23A" },
		{ label: "年", value: 2, color: "#E6A23C" }
	]
});

const { service } = useCool();

// cl-upsert
const Upsert = useUpsert({
	items: [
		{ prop: "title", label: "标题", required: true, component: { name: "el-input" } },
		{
			prop: "description",
			label: "描述",
			component: {
				name: "el-input",
				props: {
					type: "textarea",
					rows: 3
				}
			}
		},
		{
			span: 12,
			required: true,
			prop: "price",
			label: "价格",
			hook: { bind: ["number"] },
			component: { name: "el-input-number", props: { min: 0 } }
		},
		{
			required: true,
			span: 12,
			prop: "originalPrice",
			label: "原价",
			hook: { bind: ["number"] },
			component: { name: "el-input-number", props: { min: 0 } }
		},
		{
			span: 12,
			prop: "type",
			label: "类型",
			component: {
				name: "el-radio-group",
				options: options.type
			},
			value: 0,
			required: true
		},
		{
			span: 12,
			prop: "duration",
			label: "时长",
			required: true,
			component: { name: "el-input-number", props: { min: 0 } }
		},
		{ span: 12, prop: "tag", label: "标签", component: { name: "el-input" } },
		{
			span: 12,
			prop: "tagColor",
			label: "标签颜色",
			value: "#26A7FD",
			component: { name: "el-color-picker" }
		},
		{
			value: 0,
			prop: "sort",
			label: "排序",
			hook: { bind: ["number"] },
			component: { name: "el-input-number", props: { min: 0 } },
			required: true
		},
		{
			prop: "status",
			flex: false,
			value: 1,
			label: "状态",
			component: { name: "cl-switch" },
			required: true
		}
	]
});

// cl-table
const Table = useTable({
	columns: [
		{ type: "selection" },
		{ prop: "title", label: "标题" },
		{ prop: "price", label: "价格" },
		{ prop: "originalPrice", label: "原价" },
		{ prop: "description", label: "描述", showOverflowTooltip: true },
		{ prop: "status", label: "状态", component: { name: "cl-switch" } },
		{ prop: "sort", label: "排序" },
		{
			prop: "type",
			label: "类型",
			dict: options.type
		},
		{ prop: "duration", label: "时长" },
		{ prop: "tag", label: "标签" },
		{ prop: "tagColor", label: "标签颜色" },
		{ prop: "createTime", label: "创建时间", sortable: "desc", width: 160 },
		{ prop: "updateTime", label: "更新时间", sortable: "custom", width: 160 },
		{ type: "op", buttons: ["edit", "delete"] }
	]
});

// cl-crud
const Crud = useCrud(
	{
		service: service.app.goods
	},
	(app) => {
		app.refresh();
	}
);
</script>
