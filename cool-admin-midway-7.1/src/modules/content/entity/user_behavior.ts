import { Column, Entity } from 'typeorm';
import { BaseEntity } from '@cool-midway/core';

export enum BehaviorType {
  VIEW = 'view',
  FAVORITE = 'favorite',
  EXPLORE = 'explore',
  FOLLOW = 'follow',
  REPORT = 'report',
  WATCHING = 'watching',
}

/**
 * 用户行为
 */
@Entity('content_user_behavior')
export class ContentUserBehaviorEntity extends BaseEntity {
  @Column({ comment: '内容ID', nullable: true })
  dataId: number;
  @Column({ comment: '用户ID' })
  userId: number;
  @Column({ comment: '标签', type: 'json', nullable: true })
  tags: String[];
  @Column({
    type: 'enum',
    enum: BehaviorType,
    default: BehaviorType.VIEW,
    comment: '行为类型',
  })
  behaviorType: BehaviorType;
  @Column({ comment: '作者', nullable: true })
  author: number;
  @Column({ comment: '描述', nullable: true })
  description: string;
  @Column({ comment: '额外信息', type: 'json', nullable: true })
  extra: object;
}
