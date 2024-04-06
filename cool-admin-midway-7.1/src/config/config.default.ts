import { CoolConfig, MODETYPE } from '@cool-midway/core';
import { MidwayConfig } from '@midwayjs/core';
import * as fsStore from '@cool-midway/cache-manager-fs-hash';

export default {
  // use for cookie sign key, should change to your own and keep security
  keys: 'cool-admin for node',
  koa: {
    port: 8001,
  },
  // 模板渲染
  view: {
    mapping: {
      '.html': 'ejs',
    },
  },
  // 静态文件配置
  staticFile: {
    buffer: true,
  },
  // 文件上传
  upload: {
    fileSize: '200mb',
    whitelist: null,
  },
  // 缓存 可切换成其他缓存如：redis http://midwayjs.org/docs/extensions/cache
  cache: {
    store: fsStore,
    options: {
      path: 'cache',
      ttl: -1,
    },
  },
  cool: {
    file: {
      // 上传模式 本地上传或云存储
      // mode: MODETYPE.LOCAL,
      // 本地上传 文件地址前缀
      // domain: 'http://127.0.0.1:8001',
      mode: MODETYPE.CLOUD,
      cos: {
        accessKeyId: 'AKIDxoeTPD5vumOsEUizKdp1BKSdxKh6Pbj9',
        accessKeySecret: 'cJA3sW1DICtcIxuu5MdtJiu2yiIpibM2',
        bucket: 'yizhi-1259138786',
        region: 'ap-beijing',
        publicDomain: 'https://yizhi-1259138786.cos.ap-beijing.myqcloud.com',
      },
    },
    // crud配置
    crud: {
      // 插入模式，save不会校验字段(允许传入不存在的字段)，insert会校验字段
      upsert: 'save',
      // 软删除
      softDelete: true,
    },
    sms: {
      tx: {
        /**
         * 应用ID
         */
        appId: '1400875013',
        /**
         * 腾讯云secretId
         */
        secretId: 'AKIDxoeTPD5vumOsEUizKdp1BKSdxKh6Pbj9',
        /**
         * 腾讯云secretKey
         */
        secretKey: 'cJA3sW1DICtcIxuu5MdtJiu2yiIpibM2',
        /**
         * 签名，非必填，调用时可以传入
         */
        signName: '沧斑斓网站',
        /**
         * 模板，非必填，调用时可以传入
         */
        template: '2021970',
      },
    },
  } as CoolConfig,
  socketIO: {
    cors: {
      origin: 'http://localhost:9000',
      methods: ['GET', 'POST'],
    },
  },
} as MidwayConfig;
