import { BaseController, CoolController } from '@cool-midway/core';
import { Get, Inject, Provide } from '@midwayjs/decorator';
import { Context } from '@midwayjs/koa';
import { UserInfoEntity } from '../../../user/entity/info';
import { ContentCloudDeviceEntity } from '../../entity/cloud_device';
import { ContentCloudDeviceService } from '../../service/cloud_device';

/**
 * 一枝互印空间云上设备
 */
@Provide()
@CoolController({
  api: ['add', 'update', 'page'],
  entity: ContentCloudDeviceEntity,
  insertParam: async (ctx: Context) => {
    return {
      userId: ctx.user.id,
    };
  },
  pageQueryOp: {
    keyWordLikeFields: ['nickName', 'title'],
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
export class AppContentCloudDeviceController extends BaseController {
  @Inject()
  contentCloudDeviceService: ContentCloudDeviceService;

  @Inject()
  ctx;
  @Get('/myCloudDevice', { summary: '获取我的云上设备' })
  async myCloudDevice() {
    return this.ok(await this.contentCloudDeviceService.myCloudDevice());
  }
}
