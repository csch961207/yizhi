import { Provide, Get, Post, Body, Inject } from '@midwayjs/decorator';
import { CoolController, BaseController } from '@cool-midway/core';
import { ContentUserBehaviorService } from '../../service/user_behavior';
import { ContentUserBehaviorEntity } from '../../entity/user_behavior';

/**
 * 内容举报
 */
@Provide()
@CoolController({
  api: ['add', 'delete', 'update', 'info', 'list', 'page'],
  entity: ContentUserBehaviorEntity,
  service: ContentUserBehaviorService,
})
export class AdminContentReportController extends BaseController {
  @Inject()
  contentUserBehaviorService: ContentUserBehaviorService;

  @Post('/ban', { summary: '封禁内容' })
  async ban(@Body() body) {
    return this.ok(await this.contentUserBehaviorService.ban(body));
  }
}
