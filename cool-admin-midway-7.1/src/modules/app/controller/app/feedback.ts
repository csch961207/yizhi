import { CoolController, BaseController } from '@cool-midway/core';
import { Body, Inject, Post } from '@midwayjs/core';
import { AppFeedbackService } from '../../service/feedback';
import { AppFeedbackEntity } from '../../entity/feedback';

/**
 * 意见反馈
 */
@CoolController({
  api: ['page', 'info'],
  entity: AppFeedbackEntity,
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
export class AppAppFeedbackController extends BaseController {
  @Inject()
  appFeedbackService: AppFeedbackService;

  @Inject()
  ctx;

  @Post('/submit', { summary: '提交意见反馈' })
  async submit(@Body() info) {
    info.userId = this.ctx.user.id;
    await this.appFeedbackService.submit(info);
    return this.ok();
  }
}
