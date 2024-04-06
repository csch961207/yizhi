import { Inject, Provide } from '@midwayjs/decorator';
import { BaseService } from '@cool-midway/core';
import { In, Repository } from 'typeorm';
import { InjectEntityModel } from '@midwayjs/typeorm';
import { ContentDeviceEntity } from '../entity/device';
import { v1 as uuid } from 'uuid';

/**
 * 标签
 */
@Provide()
export class ContentDeviceService extends BaseService {
  @InjectEntityModel(ContentDeviceEntity)
  contentDeviceEntity: Repository<ContentDeviceEntity>;

  @Inject()
  ctx;

  /**
   * 获取我的设备
   */
  async myDevice() {
    // 查询我的设备是否存在，存在返回，不存在创建返回
    const userId = this.ctx.user.id;
    const device = await this.contentDeviceEntity.findOne({
      where: { userId },
    });
    if (device) {
      return device;
    } else {
      return await this.contentDeviceEntity.save({
        userId,
        // 生成16位的设备号不包含-，避免部分设备不支持
        deviceName: uuid().replace(/-/g, '').slice(0, 16),
      });
    }
  }
}
