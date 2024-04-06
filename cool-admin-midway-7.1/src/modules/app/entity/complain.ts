import { BaseEntity } from '@cool-midway/core';
import { Column, Entity, Index } from 'typeorm';

/**
 * 举报投诉
 */
@Entity('app_complain')
export class AppComplainEntity extends BaseEntity {
  @Index()
  @Column({ comment: '用户ID' })
  userId: number;

  @Column({ comment: '类型' })
  type: number;

  @Column({ comment: '联系方式' })
  contact: string;

  @Column({ comment: '内容' })
  content: string;

  @Column({ comment: '图片', type: 'json', nullable: true })
  images: string[];

  @Column({ comment: '状态 0-未处理 1-已处理', default: 0 })
  status: number;

  @Column({ comment: '处理人ID', nullable: true })
  handlerId: number;

  @Column({ comment: '备注', type: 'text', nullable: true })
  remark: string;
}
