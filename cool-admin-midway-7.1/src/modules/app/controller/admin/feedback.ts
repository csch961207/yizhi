import { CoolController, BaseController } from '@cool-midway/core';
import { AppFeedbackEntity } from '../../entity/feedback';
import { UserInfoEntity } from '../../../user/entity/info';
import { BaseSysUserEntity } from '../../../base/entity/sys/user';
import { AppFeedbackService } from '../../service/feedback';

/**
 * 意见反馈
 */
@CoolController({
  api: ['add', 'delete', 'update', 'info', 'list', 'page'],
  entity: AppFeedbackEntity,
  service: AppFeedbackService,
  pageQueryOp: {
    keyWordLikeFields: ['a.contact', 'b.nickName', 'c.name'],
    select: ['a.*', 'b.nickName', 'b.avatarUrl', 'c.name as handlerName'],
    fieldEq: ['a.status'],
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
export class AdminAppFeedbackController extends BaseController {}
