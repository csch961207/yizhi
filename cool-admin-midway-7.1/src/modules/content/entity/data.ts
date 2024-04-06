import { Column, Entity } from 'typeorm';
import { BaseEntity } from '@cool-midway/core';

/**
 * 分享内容
 */
@Entity('content_data')
export class ContentDataEntity extends BaseEntity {
  @Column({ comment: '标题' })
  title: string;
  @Column({ comment: '作者ID' })
  userId: number;
  @Column({ comment: '标签列表', type: 'json', nullable: true })
  tagList: string[];
  @Column({ comment: '分享链接', nullable: true })
  url: string;
  @Column({ comment: '隐藏内容', nullable: true })
  hiddenContent: string;
  @Column({ comment: '是否可见', default: true })
  visible: boolean;
  userName: string;
  avatarUrl: string;
}
