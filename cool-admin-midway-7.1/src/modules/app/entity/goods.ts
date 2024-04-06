import { BaseEntity } from '@cool-midway/core';
import { Column, Entity } from 'typeorm';

/**
 * 套餐
 */
@Entity('app_goods')
export class AppGoodsEntity extends BaseEntity {
  @Column({ comment: '标题' })
  title: string;

  @Column({
    comment: '价格',
    type: 'decimal',
    precision: 12,
    scale: 2,
  })
  price: number;

  @Column({
    comment: '原价',
    type: 'decimal',
    precision: 12,
    scale: 2,
  })
  originalPrice: number;

  @Column({ comment: '描述', type: 'text', nullable: true })
  description: string;

  @Column({ comment: '状态 0-禁用 1-启用', default: 1 })
  status: number;

  @Column({ comment: '排序', default: 0 })
  sort: number;

  @Column({ comment: '类型 0-天 1-月 2-年 3-永久', default: 0 })
  type: number;

  @Column({ comment: '时长', default: 1 })
  duration: number;

  @Column({ comment: '标签', nullable: true })
  tag: string;

  @Column({ comment: '标签颜色', default: '#26A7FD' })
  tagColor: string;
}
