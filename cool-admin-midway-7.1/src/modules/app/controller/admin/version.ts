import { CoolController, BaseController } from '@cool-midway/core';
import { AppVersionEntity } from '../../entity/version';
import { AppVersionService } from '../../service/version';

/**
 * 版本
 */
@CoolController({
  api: ['add', 'delete', 'update', 'info', 'list', 'page'],
  entity: AppVersionEntity,
  service: AppVersionService,
  pageQueryOp: {
    keyWordLikeFields: ['a.name', 'a.version'],
    fieldEq: ['a.status', 'a.type'],
  },
})
export class AdminAppVersionController extends BaseController {}
