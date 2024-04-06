import { Column, Entity } from 'typeorm';
import { BaseEntity } from '@cool-midway/core';

/**
 * 分享内容实时聊天记录
 */
@Entity('content_message')
export class ContentMessageEntity extends BaseEntity {
  @Column({ comment: '内容ID' })
  dataId: number;
  @Column({ comment: '消息' })
  message: string;
  @Column({ comment: '发送者ID' })
  userId: number;
  nickName: string;
  avatarUrl: string;
}
