import { CoolController, BaseController } from '@cool-midway/core';
import { AppGoodsEntity } from '../../entity/goods';

/**
 * 套餐
 */
@CoolController({
  api: ['add', 'delete', 'update', 'info', 'list', 'page'],
  entity: AppGoodsEntity,
  pageQueryOp: {
    keyWordLikeFields: ['a.title'],
    fieldEq: ['a.status', 'a.type'],
  },
})
export class AdminAppGoodsController extends BaseController {}
