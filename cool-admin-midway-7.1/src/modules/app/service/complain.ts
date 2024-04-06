import { Inject, Provide } from '@midwayjs/decorator';
import { BaseService } from '@cool-midway/core';
import { InjectEntityModel } from '@midwayjs/typeorm';
import { Repository } from 'typeorm';
import { AppComplainEntity } from '../entity/complain';

/**
 * 意见反馈
 */
@Provide()
export class AppComplainService extends BaseService {
  @InjectEntityModel(AppComplainEntity)
  appComplainEntity: Repository<AppComplainEntity>;

  @Inject()
  ctx;

  /**
   * 提交
   * @param info
   */
  async submit(info: AppComplainEntity) {
    await this.appComplainEntity.insert(info);
  }

  /**
   * 更新
   * @param param
   */
  async update(param: AppComplainEntity) {
    if (param.status == 1) {
      param.handlerId = this.ctx.admin.userId;
    }
    await super.update(param);
  }
}
