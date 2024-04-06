import { CoolController, BaseController } from '@cool-midway/core';
import { AppComplainEntity } from '../../entity/complain';
import { BaseSysUserEntity } from '../../../base/entity/sys/user';
import { AppComplainService } from '../../service/complain';
import { UserInfoEntity } from '../../../user/entity/info';

/**
 * 意见反馈
 */
@CoolController({
  api: ['add', 'delete', 'update', 'info', 'list', 'page'],
  entity: AppComplainEntity,
  service: AppComplainService,
  pageQueryOp: {
    keyWordLikeFields: ['a.contact', 'b.nickName', 'c.name'],
    select: ['a.*', 'b.nickName', 'b.avatarUrl', 'c.name as handlerName'],
    fieldEq: ['a.status', 'a.type'],
    join: [
      {
        entity: UserInfoEntity,
        alias: 'b',
        condition: 'a.userId = b.id',
      },
      {
        entity: BaseSysUserEntity,
        alias: 'c',
        condition: 'a.handlerId = c.id',
      },
    ],
  },
})
export class AdminAppComplainController extends BaseController {}
