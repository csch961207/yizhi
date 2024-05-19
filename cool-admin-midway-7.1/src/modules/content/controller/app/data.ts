import { ALL, Body, Inject, Post, Provide } from '@midwayjs/decorator';
import { CoolController, BaseController } from '@cool-midway/core';
import { UserInfoEntity } from '../../../user/entity/info';
import { ContentDataEntity } from '../../entity/data';
import { ContentDataService } from '../../service/data';
import { Context } from '@midwayjs/koa';

/**
 * 一枝分享内容
 */
@Provide()
@CoolController({
  api: ['add', 'delete', 'update', 'info', 'list', 'page'],
  entity: ContentDataEntity,
  service: ContentDataService,
  insertParam: async (ctx: Context) => {
    return {
      userId: ctx.user.id,
    };
  },
})
export class AppContentDataController extends BaseController {
  @Inject()
  contentDataService: ContentDataService;

  @Inject()
  ctx;

  @Post('/myPage', { summary: '获取我创建的内容' })
  async myPage(@Body() query) {
    return this.ok(
      await this.contentDataService.page({ ...query, userId: this.ctx.user.id })
    );
  }

  @Post('/tagPage', { summary: '获取相关标签的内容' })
  async tagPage(@Body() query) {
    return this.ok(await this.contentDataService.pageByTag(query));
  }

  @Post('/explore', { summary: '探知-查询隐藏内容' })
  async explore(@Body(ALL) query) {
    return this.ok(await this.contentDataService.explore(query));
  }
}
