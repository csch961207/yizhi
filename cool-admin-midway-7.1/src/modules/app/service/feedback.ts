import { Inject, Provide } from '@midwayjs/decorator';
import { BaseService } from '@cool-midway/core';
import { InjectEntityModel } from '@midwayjs/typeorm';
import { Repository } from 'typeorm';
import { AppFeedbackEntity } from '../entity/feedback';

/**
 * 意见反馈
 */
@Provide()
export class AppFeedbackService extends BaseService {
  @InjectEntityModel(AppFeedbackEntity)
  appFeedbackEntity: Repository<AppFeedbackEntity>;

  @Inject()
  ctx;

  /**
   * 提交
   * @param info
   */
  async submit(info: AppFeedbackEntity) {
    await this.appFeedbackEntity.insert(info);
  }

  /**
   * 更新
   * @param param
   */
  async update(param: AppFeedbackEntity) {
    if (param.status == 1) {
      param.handlerId = this.ctx.admin.userId;
    }
    await super.update(param);
  }
}
