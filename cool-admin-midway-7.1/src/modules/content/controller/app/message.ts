import { Provide } from '@midwayjs/decorator';
import { CoolController, BaseController } from '@cool-midway/core';
import { UserInfoEntity } from '../../../user/entity/info';
import { ContentMessageEntity } from '../../entity/message';

/**
 * 一枝分享内容实时消息
 */
@Provide()
@CoolController({
  api: ['list'],
  entity: ContentMessageEntity,
  listQueryOp: {
    fieldEq: ['dataId'],
    select: ['a.*', 'b.nickName', 'b.avatarUrl'],
    join: [
      {
        entity: UserInfoEntity,
        alias: 'b',
        condition: 'a.userId = b.id',
        type: 'leftJoin',
      },
    ],
    addOrderBy: {
      updateTime: 'DESC',
    },
  },
})
export class AppContentMessageController extends BaseController {}
