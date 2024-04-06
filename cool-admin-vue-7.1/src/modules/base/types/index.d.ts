import { RouteComponent, RouteLocationNormalized } from "vue-router";

export declare namespace Menu {
	enum Type {
		"目录" = 0,
		"菜单" = 1,
		"权限" = 2
	}

	interface Item {
		id: number;
		parentId: number;
		path: string;
		router?: string;
		viewPath?: string;
		type: Type;
		name: string;
		icon: string;
		orderNum: number;
		isShow: number | boolean;
		keepAlive?: number;
		meta?: {
			label?: string;
			keepAlive?: number | boolean;
			iframeUrl?: string;
			isHome?: boolean;
			[key: string]: any;
		};
		children?: Item[];
		component?: RouteComponent;
		redirect?: string;
		[key: string]: any;
	}

	type List = Item[];
}

export declare namespace Process {
	interface Item extends RouteLocationNormalized {
		active: boolean;
	}

	type List = Item[];
}
