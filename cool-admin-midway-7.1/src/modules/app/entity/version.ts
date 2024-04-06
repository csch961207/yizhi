import { BaseEntity } from '@cool-midway/core';
import { Column, Entity } from 'typeorm';

/**
 * 应用版本
 */
@Entity('app_version')
export class AppVersionEntity extends BaseEntity {
  @Column({ comment: '名称' })
  name: string;

  @Column({ comment: '版本号' })
  version: string;

  @Column({ comment: '类型', default: 0 })
  type: number;

  @Column({ comment: '下载地址' })
  url: string;

  @Column({ comment: '强制更新 0-否 1-是', default: 0 })
  forceUpdate: number;

  @Column({ comment: '状态 0-禁用 1-启用', default: 1 })
  status: number;

  @Column({ comment: '热更新 0-否 1-是', default: 0 })
  hotUpdate: number;

  @Column({ comment: '描述', type: 'text' })
  description: string;
}
