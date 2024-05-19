import { Column, Entity, Index } from 'typeorm';
import { BaseEntity } from '@cool-midway/core';

/**
 * 互印空间云上设备
 */
@Entity('content_cloud_device')
export class ContentCloudDeviceEntity extends BaseEntity {
  @Column({ comment: '用户ID' })
  userId: number;
  @Index({ unique: true })
  @Column({ comment: '设备名称' })
  deviceName: string;
  @Column({ comment: '标题' })
  title: string;
}
