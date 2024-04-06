import { BaseEntity } from '@cool-midway/core';
import { Column, Entity, Index } from 'typeorm';

/**
 * 意见反馈
 */
@Entity('app_feedback')
export class AppFeedbackEntity extends BaseEntity {
  @Index()
  @Column({ comment: '用户ID' })
  userId: number;

  @Column({ comment: '联系方式' })
  contact: string;

  @Column({ comment: '类型' })
  type: number;

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
