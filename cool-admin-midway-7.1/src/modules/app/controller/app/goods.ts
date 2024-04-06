import { CoolController, BaseController } from '@cool-midway/core';
import { AppGoodsEntity } from '../../entity/goods';

/**
 * 套餐
 */
@CoolController({
  api: ['list'],
  entity: AppGoodsEntity,
  listQueryOp: {
    addOrderBy: {
      sort: 'ASC',
    },
    where: () => {
      return [['a.status = :status', { status: 1 }]];
    },
  },
})
export class AppAppGoodsController extends BaseController {}
