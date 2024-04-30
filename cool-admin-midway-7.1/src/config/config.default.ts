import { CoolConfig, MODETYPE } from '@cool-midway/core';
import { MidwayConfig } from '@midwayjs/core';
import * as fsStore from '@cool-midway/cache-manager-fs-hash';
// redis缓存
import * as redisStore from 'cache-manager-ioredis';
import { createRedisAdapter } from '@midwayjs/socketio';

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
  // Redis缓存
  cache: {
    store: redisStore,
    options: {
      port: 6379,
      host: '127.0.0.1',
      password: '',
      db: 0,
      keyPrefix: 'cool:',
      ttl: null,
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
        accessKeyId: '换成你的accessKeyId',
        accessKeySecret: '换成你的accessKeySecret',
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
  } as CoolConfig,
  socketIO: {
    cors: {
      origin: 'http://localhost:9000',
      methods: ['GET', 'POST'],
      adapter: createRedisAdapter({ host: '127.0.0.1', port: 6379 }),
    },
  },
} as MidwayConfig;
