<template>
	<cl-crud ref="Crud">
		<cl-row>
			<!-- 刷新按钮 -->
			<cl-refresh-btn />
			<el-button
				type="danger"
				:disabled="Table?.selection.length == 0"
				v-permission="service.content.report.permission.ban"
				@click="ban()"
				>封禁内容</el-button
			>

			<cl-flex1 />
			<!-- 关键字搜索 -->
			<cl-search-key />
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
	</cl-crud>
</template>

<script lang="ts" name="content-report" setup>
import { useCrud, useTable } from "@cool-vue/crud";
import { ElMessage, ElMessageBox } from "element-plus";
import { onActivated } from "vue";
import { useCool } from "/@/cool";

const { service } = useCool();

// cl-table
const Table = useTable({
	columns: [
		{
			type: "selection"
		},
		{ label: "举报人", prop: "userName", minWidth: 120 },
		{
			label: "举报时的内容",
			prop: "extra",
			minWidth: 200,
			component: {
				name: "cl-code-json",
				props: {
					popover: true
				}
			}
		},
		{ label: "举报原因", prop: "description", showOverflowTooltip: true, minWidth: 150 },
		{
			label: "当前的内容",
			prop: "data",
			minWidth: 150,
			component: {
				name: "cl-code-json",
				props: {
					popover: true
				}
			}
		},
		{ label: "创建时间", prop: "createTime", minWidth: 160, sortable: "desc" },
		{
			type: "op",
			width: 120,
			buttons: [
				{
					label: "封禁",
					hidden: !service.content.report._permission.ban,
					type: "danger",
					onClick({ scope }) {
						ban(scope.row.id);
					}
				}
			]
		}
	]
});

// cl-crud
const Crud = useCrud({
	service: service.content.report
});

// 刷新
function refresh(params?: any) {
	Crud.value?.refresh(params);
}

// 数据恢复
function ban(id?: string) {
	const ids = id ? [id] : Table.value?.selection;

	ElMessageBox.confirm("此操作将封禁相关内容，是否继续？", "提示", {
		type: "warning"
	})
		.then(() => {
			service.content.report
				.ban({
					ids
				})
				.then(() => {
					ElMessage.success("封禁内容成功");
					refresh();
				})
				.catch((err) => {
					ElMessage.error(err.message);
				});
		})
		.catch(() => null);
}

onActivated(() => {
	refresh();
});
</script>
