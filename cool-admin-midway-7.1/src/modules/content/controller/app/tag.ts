import { Body, Inject, Post, Provide } from '@midwayjs/decorator';
import { CoolController, BaseController } from '@cool-midway/core';
import { ContentTagEntity } from '../../entity/tag';

/**
 * 一枝分享内容标签
 */
@Provide()
@CoolController({
  api: ['add', 'delete', 'update', 'info', 'list', 'page'],
  entity: ContentTagEntity,
  pageQueryOp: {
    keyWordLikeFields: ['label'],
    //根据关联内容数count排序
    addOrderBy: {
      count: 'DESC',
    },
  },
})
export class AppContentTagController extends BaseController {}
