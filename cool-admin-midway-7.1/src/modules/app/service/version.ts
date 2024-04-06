import { Provide } from '@midwayjs/decorator';
import { BaseService } from '@cool-midway/core';
import { InjectEntityModel } from '@midwayjs/typeorm';
import { Not, Repository } from 'typeorm';
import { AppVersionEntity } from '../entity/version';
import * as semver from 'semver';

/**
 * 应用版本
 */
@Provide()
export class AppVersionService extends BaseService {
  @InjectEntityModel(AppVersionEntity)
  appVersionEntity: Repository<AppVersionEntity>;

  /**
   * 检查更新
   * @param version
   */
  async check(version: string, type = 0) {
    const info = await this.appVersionEntity.findOneBy({ type, status: 1 });
    if (info && semver.gt(info.version, version)) {
      return info;
    }
    return;
  }

  /**
   * 修改之后
   * @param data
   * @param type
   */
  async modifyAfter(data: any, type: 'add' | 'update' | 'delete') {
    if (type == 'add' || type == 'update') {
      const info = await this.appVersionEntity.findOneBy({ id: data.id });
      if (info.status == 1) {
        // 将其他的版本设置为禁用
        await this.appVersionEntity.update(
          { type: info.type, id: Not(info.id) },
          { status: 0 }
        );
      }
    }
  }
}
