import { Inject, Provide } from '@midwayjs/decorator';
import { BaseService } from '@cool-midway/core';
import { In, Repository } from 'typeorm';
import { InjectEntityModel } from '@midwayjs/typeorm';
import { ContentTagEntity } from '../entity/tag';

/**
 * 标签
 */
@Provide()
export class ContentTagService extends BaseService {
  @InjectEntityModel(ContentTagEntity)
  contentTagEntity: Repository<ContentTagEntity>;

  /**
   * 批量添加标签
   * @param tagList
   * @return 标签名称
   */
  async batchAdd(tagList) {
    const data = await this.contentTagEntity.findBy({ label: In(tagList) });
    const existingLabelSet = new Set(data.map(item => item.label));
    const newTags = tagList
      .filter(tag => !existingLabelSet.has(tag))
      .map(tag => ({ label: tag }));
    await this.contentTagEntity.save(newTags);
  }

  /**
   * 批量增加标签count
   */
  async batchAddCount(tagList) {
    await this.contentTagEntity.increment({ label: In(tagList) }, 'count', 1);
  }

  /**
   * 批量减少count
   */
  async batchSubCount(tagList) {
    await this.contentTagEntity.decrement({ label: In(tagList) }, 'count', 1);
  }
}
