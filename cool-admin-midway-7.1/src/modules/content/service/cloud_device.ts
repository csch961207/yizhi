import { Inject, Provide } from '@midwayjs/decorator';
import { BaseService, CoolCommException } from '@cool-midway/core';
import { In, Repository } from 'typeorm';
import { InjectEntityModel } from '@midwayjs/typeorm';
import { ContentCloudDeviceEntity } from '../entity/cloud_device';

/**
 * 标签
 */
@Provide()
export class ContentCloudDeviceService extends BaseService {
  @InjectEntityModel(ContentCloudDeviceEntity)
  contentCloudDeviceEntity: Repository<ContentCloudDeviceEntity>;

  @Inject()
  ctx;

  /**
   * 获取我的设备
   */
  async myCloudDevice() {
    // 查询我的云上设备
    const userId = this.ctx.user.id;
    const device = await this.contentCloudDeviceEntity.findOne({
      where: { userId },
    });
    if (device) {
      return device;
    } else {
      throw new CoolCommException('用户设备未上云');
    }
  }
}
