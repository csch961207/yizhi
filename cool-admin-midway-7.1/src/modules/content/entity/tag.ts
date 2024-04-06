import { Column, Index, Entity } from 'typeorm';
import { BaseEntity } from '@cool-midway/core';

/**
 * 系统配置
 */
@Entity('content_tag')
export class ContentTagEntity extends BaseEntity {
  @Index({ unique: true })
  @Column({ comment: '名称' })
  label: string;
  @Column({ comment: '关联内容数', default: 0 })
  count: number;
}
