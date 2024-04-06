import {
  CoolController,
  BaseController,
  CoolUrlTag,
  CoolTag,
  TagTypes,
} from '@cool-midway/core';
import { Get, Inject, Query } from '@midwayjs/core';
import { AppVersionService } from '../../service/version';
import { AppVersionEntity } from '../../entity/version';

/**
 * 版本
 */
@CoolUrlTag()
@CoolController({
  api: [],
  entity: AppVersionEntity,
})
export class AppAppVersionController extends BaseController {
  @Inject()
  appVersionService: AppVersionService;

  @CoolTag(TagTypes.IGNORE_TOKEN)
  @Get('/check', { summary: '检查版本' })
  async check(@Query('version') version: string, @Query('type') type = 0) {
    const result = await this.appVersionService.check(version, type);
    return this.ok(result);
  }
}
