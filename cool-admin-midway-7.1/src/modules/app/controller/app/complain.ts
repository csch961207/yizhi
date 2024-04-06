import { CoolController, BaseController } from '@cool-midway/core';
import { Body, Inject, Post } from '@midwayjs/core';
import { AppComplainService } from '../../service/complain';
import { AppComplainEntity } from '../../entity/complain';

/**
 * 意见反馈
 */
@CoolController({
  api: ['page', 'info'],
  entity: AppComplainEntity,
  insertParam: ctx => {
    return {
      userId: ctx.user.id,
    };
  },
  pageQueryOp: {
    fieldEq: ['a.type'],
    where: ctx => {
      const userId = ctx.user.id;
      return [['a.userId = :userId', { userId }]];
    },
  },
})
export class AppAppComplainController extends BaseController {
  @Inject()
  appComplainService: AppComplainService;

  @Inject()
  ctx;

  @Post('/submit', { summary: '提交投诉举报' })
  async submit(@Body() info) {
    info.userId = this.ctx.user.id;
    await this.appComplainService.submit(info);
    return this.ok();
  }
}
