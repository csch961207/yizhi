import { Column, Entity, Index } from 'typeorm';
import { BaseEntity } from '@cool-midway/core';

/**
 * 用户关联设备
 */
@Entity('content_device')
export class ContentDeviceEntity extends BaseEntity {
  @Index({ unique: true })
  @Column({ comment: '设备名称' })
  deviceName: string;
  @Column({ comment: '用户ID' })
  userId: number;
}
