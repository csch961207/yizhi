import { Config, Get, Provide } from '@midwayjs/decorator';
import { CoolController, BaseController } from '@cool-midway/core';
import { SpaceInfoEntity } from '../../entity/info';
import { SpaceInfoService } from '../../service/info';

/**
 * 图片空间信息
 */
@Provide()
@CoolController({
  api: ['add', 'delete', 'update', 'info', 'list', 'page'],
  entity: SpaceInfoEntity,
  service: SpaceInfoService,
  pageQueryOp: {
    fieldEq: ['type', 'classifyId'],
  },
})
export class BaseAppSpaceInfoController extends BaseController {}
