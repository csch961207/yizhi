import { Provide, Inject, Get, Post, Body, ALL } from '@midwayjs/decorator';
import { CoolController, BaseController } from '@cool-midway/core';
import { ContentDeviceService } from '../../service/device';

/**
 * 用户设备
 */
@Provide()
@CoolController()
export class AppContentDeviceController extends BaseController {
  @Inject()
  contentDeviceService: ContentDeviceService;
  /**
   * 获得个人设备
   */
  @Get('/myDevice', { summary: '个人设备' })
  async myDevice() {
    return this.ok(await this.contentDeviceService.myDevice());
  }
}
