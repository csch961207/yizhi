import { BaseService } from '@cool-midway/core';
import { Inject, Provide } from '@midwayjs/decorator';
import { InjectEntityModel } from '@midwayjs/typeorm';
import * as _ from 'lodash';
import { Repository } from 'typeorm';
import { BaseSysConfService } from '../../base/service/sys/conf';
import { ContentMessageEntity } from '../entity/message';

/**
 * 实时聊天
 */
@Provide()
export class ContentMessageService extends BaseService {
  @InjectEntityModel(ContentMessageEntity)
  contentMessageEntity: Repository<ContentMessageEntity>;

  @Inject()
  baseSysConfService: BaseSysConfService;

  @Inject()
  ctx;

  /**
   * 添加消息
   * @param param
   */
  async add(param) {
    // 通过dataId查询是否超过最大消息数
    const count = await this.contentMessageEntity.count({
      where: {
        dataId: param.dataId,
      },
    });
    const maxCount = await this.baseSysConfService.getValue(
      'contentMessageLimit'
    );
    if (count >= Number(maxCount)) {
      // 获取最早的消息更新为最新消息
      const oldMessage = await this.contentMessageEntity.findOne({
        where: {
          dataId: param.dataId,
        },
        order: {
          createTime: 'ASC',
        },
      });
      oldMessage.message = param.message;
      await this.contentMessageEntity.save(oldMessage);
    } else {
      await this.contentMessageEntity.save(param);
    }
    return param;
  }
}
