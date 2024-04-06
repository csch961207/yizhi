import {
  Provide,
  Inject,
  CommonSchedule,
  TaskLocal,
  FORMAT,
} from '@midwayjs/decorator';
import { ILogger } from '@midwayjs/logger';
import { ContentUserBehaviorService } from '../service/user_behavior';

/**
 * 数据定时清除定时任务
 */
@Provide()
export class ContentUserBehaviorSchedule implements CommonSchedule {
  @Inject()
  contentUserBehaviorService: ContentUserBehaviorService;

  @Inject()
  logger: ILogger;

  // 定时执行的具体任务
  @TaskLocal(FORMAT.CRONTAB.EVERY_DAY)
  async exec() {
    this.logger.info('清除一枝用户行为数据定时任务开始执行');
    const startTime = Date.now();
    await this.contentUserBehaviorService.clear();
    this.logger.info(
      `清除一枝用户行为数据定时任务结束，耗时:${Date.now() - startTime}ms`
    );
  }
}
