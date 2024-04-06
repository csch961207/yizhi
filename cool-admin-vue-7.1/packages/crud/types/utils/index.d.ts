export declare function isObject(val: any): boolean;
export declare function parsePx(val: string | number): string;
export declare function dataset(obj: any, key: string, value: any): any;
export declare function contains(parent: any, node: any): any;
export declare function mergeConfig(a: any, b?: any): any;
export declare function merge(d1: any, d2: any): any;
export declare function addClass(el: Element, name: string): void;
export declare function removeClass(el: Element, name: string): void;
export declare function getValue(data: any, params?: any): any;
export declare function deepFind(value: any, list: any[], options?: {
    allLevels: boolean;
}): any;
export declare function uuid(separator?: string): string;
