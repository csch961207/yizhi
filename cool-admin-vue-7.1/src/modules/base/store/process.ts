import { defineStore } from "pinia";
import { ref } from "vue";
import { Process } from "../types";

export const useProcessStore = defineStore("process", function () {
	const list = ref<Process.List>([]);

	// 添加
	function add(data: any) {
		list.value.forEach((e: Process.Item) => {
			e.active = false;
		});

		if (!data.meta?.isHome && data.meta?.process !== false) {
			const index = list.value.findIndex((e) => e.path === data.path);

			if (index < 0) {
				list.value.push({
					...data,
					active: true
				});
			} else {
				Object.assign(list.value[index], data, { active: true });
			}
		}
	}

	// 移除
	function remove(index: number) {
		list.value.splice(index, 1);
	}

	// 设置
	function set(data: Process.Item[]) {
		list.value = data;
	}

	// 清空
	function clear() {
		list.value = [];
	}

	// 设置标题
	function setTitle(title: string) {
		const item = list.value.find((e) => e.active);

		if (item) {
			item.meta.label = title;
		}
	}

	return {
		list,
		add,
		remove,
		set,
		clear,
		setTitle
	};
});
