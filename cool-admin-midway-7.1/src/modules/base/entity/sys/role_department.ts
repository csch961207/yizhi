import { BaseEntity } from '@cool-midway/core';
import { Column, Entity } from 'typeorm';

/**
 * 角色部门
 */
@Entity('base_sys_role_department')
export class BaseSysRoleDepartmentEntity extends BaseEntity {
  @Column({ comment: '角色ID' })
  roleId: number;

  @Column({ comment: '部门ID' })
  departmentId: number;
}
