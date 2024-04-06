import { Inject, Provide } from '@midwayjs/decorator';
import { BaseService, CoolCommException } from '@cool-midway/core';
import { InjectEntityModel } from '@midwayjs/typeorm';
import { Brackets, In, Repository } from 'typeorm';
import * as _ from 'lodash';
import { ContentTagService } from './tag';
import { ContentDataEntity } from '../entity/data';
import { UserInfoEntity } from '../../user/entity/info';
import {
  BehaviorType,
  ContentUserBehaviorEntity,
} from '../entity/user_behavior';
import { ContentUserBehaviorService } from './user_behavior';
import { ContentDeviceEntity } from '../entity/device';

/**
 * 分享内容
 */
@Provide()
export class ContentDataService extends BaseService {
  @InjectEntityModel(ContentDataEntity)
  contentDataEntity: Repository<ContentDataEntity>;

  @InjectEntityModel(UserInfoEntity)
  userInfoEntity: Repository<UserInfoEntity>;

  @InjectEntityModel(ContentUserBehaviorEntity)
  contentUserBehaviorEntity: Repository<ContentUserBehaviorEntity>;

  @InjectEntityModel(ContentDeviceEntity)
  contentDeviceEntity: Repository<ContentDeviceEntity>;

  @Inject()
  contentTagService: ContentTagService;

  @Inject()
  contentUserBehaviorService: ContentUserBehaviorService;

  @Inject()
  ctx;

  /**
   * 分页查询
   * @param query
   */
  async page(query) {
    const { keyWord, page, size, userId, mode, sort } = query;
    if (mode === 2) {
      return this.contentUserBehaviorService.getMyAllContent({
        ...query,
        behaviorType: BehaviorType.WATCHING,
      });
    }
    let find = this.contentDataEntity.createQueryBuilder('a');
    find
      .leftJoinAndSelect(UserInfoEntity, 'b', 'a.userId = b.id')
      .leftJoinAndSelect(
        ContentUserBehaviorEntity,
        'c',
        'a.id = c.dataId and c.behaviorType = :behaviorType',
        { behaviorType: BehaviorType.FAVORITE }
      )
      .select([
        'a.id as id',
        'a.title as title',
        'a.tagList as tagList',
        'a.url as url',
        'COUNT(c.id) as likedCount',
        'a.userId as userId',
        'a.createTime as createTime',
        'a.updateTime as updateTime',
        'a.visible as visible',
        'b.nickName as userName',
        'b.avatarUrl as avatarUrl',
      ])
      .groupBy('a.id');
    // 过滤掉隐藏内容
    find.where('a.visible = 1');
    if (userId) {
      if (keyWord) {
        find.andWhere(
          new Brackets(qb => {
            qb.where('a.title like :keyword', { keyword: `%${keyWord}%` });
            qb.orWhere('b.nickName like :keyword', { keyword: `%${keyWord}%` });
          })
        );
      }
      find.andWhere('a.userId = :userId', { userId });
    } else {
      if (keyWord) {
        find.andWhere(
          new Brackets(qb => {
            qb.where('a.title like :keyword', { keyword: `%${keyWord}%` });
            qb.orWhere('b.nickName like :keyword', { keyword: `%${keyWord}%` });
          })
        );
      } else {
        if (mode === 0) {
          // 根据标签推荐
          const myRecentTag =
            await this.contentUserBehaviorService.getMyRecentTag();
          if (myRecentTag.length > 0) {
            find.andWhere(
              new Brackets(qb => {
                qb.where('JSON_CONTAINS(a.tagList, :tag0)', {
                  tag0: JSON.stringify(myRecentTag[0]),
                });
                for (let i = 1; i < myRecentTag.length; i++) {
                  qb.orWhere('JSON_CONTAINS(a.tagList, :tag' + i + ')', {
                    ['tag' + i]: JSON.stringify(myRecentTag[i]),
                  });
                }
              })
            );
          }
        } else if (mode === 1) {
          // 推荐未看过的标签的内容
          const myAllTag = await this.contentUserBehaviorService.getMyAllTag();
          if (myAllTag.length > 0) {
            find.andWhere('NOT JSON_CONTAINS(a.tagList, :tag0)', {
              tag0: JSON.stringify(myAllTag[0]),
            });
            for (let i = 1; i < myAllTag.length; i++) {
              find.andWhere('NOT JSON_CONTAINS(a.tagList, :tag' + i + ')', {
                ['tag' + i]: JSON.stringify(myAllTag[i]),
              });
            }
          }
        }
      }
    }
    if (sort === 0) {
      // 按热度排序
      find.orderBy('likedCount', 'DESC');
    } else {
      // 按时间排序
      find.orderBy('a.createTime', 'DESC');
    }
    const [list, total] = await Promise.all([
      find
        .clone() // 克隆查询以避免修改原始查询
        .offset((page - 1) * size)
        .limit(size)
        .getRawMany(),
      find.getCount(),
    ]);
    return {
      list,
      pagination: {
        page: parseInt(page),
        size: parseInt(size),
        total,
      },
    };
  }

  /**
   * 标签相关分页查询
   * @param query
   */
  async pageByTag(query) {
    const { tag, page, size, sort } = query;
    let find = this.contentDataEntity.createQueryBuilder('a');
    find
      .leftJoinAndSelect(UserInfoEntity, 'b', 'a.userId = b.id')
      .leftJoinAndSelect(
        ContentUserBehaviorEntity,
        'c',
        'a.id = c.dataId and c.behaviorType = :behaviorType',
        { behaviorType: BehaviorType.FAVORITE }
      )
      .select([
        'a.id as id',
        'a.title as title',
        'a.tagList as tagList',
        'a.url as url',
        'COUNT(c.id) as likedCount',
        'a.userId as userId',
        'a.createTime as createTime',
        'a.updateTime as updateTime',
        'b.nickName as userName',
        'b.avatarUrl as avatarUrl',
      ])
      .groupBy('a.id')
      .where('JSON_CONTAINS(a.tagList, :tag)', { tag: JSON.stringify(tag) });
    // 过滤掉隐藏内容
    find.andWhere('a.visible = 1');
    if (sort === 0) {
      // 按热度排序
      find.orderBy('likedCount', 'DESC');
    } else {
      // 按时间排序
      find.orderBy('a.createTime', 'DESC');
    }
    const [list, total] = await Promise.all([
      find
        .clone() // 克隆查询以避免修改原始查询
        .offset((page - 1) * size)
        .limit(size)
        .getRawMany(),
      find.getCount(),
    ]);
    return {
      list,
      pagination: {
        page: parseInt(page),
        size: parseInt(size),
        total,
      },
    };
  }

  /**
   * 新增
   * @param param
   */
  async add({ tagList, ...restParam }) {
    // 过滤掉空标签
    const newTagList = _.compact(tagList);
    // 标签最多5个
    if (newTagList.length > 5) throw new CoolCommException('标签最多5个');
    const saveContentData = this.contentDataEntity.save({
      tagList: newTagList as string[],
      ...restParam,
    });
    const addNewTags = this.contentTagService.batchAdd(newTagList);
    const updateTagCount = this.contentTagService.batchAddCount(newTagList);

    await Promise.all([saveContentData, addNewTags, updateTagCount]);

    return restParam.id;
  }

  /**
   * 根据ID获得信息
   * @param id
   */
  public async info(id) {
    const info = await this.contentDataEntity.findOneBy({ id });
    // 如果内容被隐藏，不可查看
    if (!info.visible) {
      throw new CoolCommException('内容不可查看');
    }
    const user = await this.userInfoEntity.findOneBy({ id: info.userId });
    // 查询用户行为是否存在
    const userBehavior = await this.contentUserBehaviorEntity.findOneBy({
      userId: this.ctx.user.id,
      dataId: id,
      behaviorType: BehaviorType.VIEW,
    });
    if (userBehavior) {
      // 更新用户行为
      await this.contentUserBehaviorEntity.update(userBehavior.id, {
        tags: info.tagList,
      });
    } else {
      // 记录用户行为
      await this.contentUserBehaviorEntity.save({
        userId: this.ctx.user.id,
        dataId: id,
        tags: info.tagList,
      });
    }
    if (info.userId !== this.ctx.user.id) {
      // 删除隐藏内容
      delete info.hiddenContent;
    }
    // 查询likedCount
    const likedCount = await this.contentUserBehaviorEntity.count({
      where: { dataId: id, behaviorType: BehaviorType.FAVORITE },
    });
    // 查询当前用户是否喜欢
    const isLiked = await this.contentUserBehaviorEntity.findOneBy({
      userId: this.ctx.user.id,
      dataId: id,
      behaviorType: BehaviorType.FAVORITE,
    });
    // 查询当前用户是否加入常看
    const isWatching = await this.contentUserBehaviorEntity.findOneBy({
      userId: this.ctx.user.id,
      dataId: id,
      behaviorType: BehaviorType.WATCHING,
    });
    // 查询当前用户是否关注此内容作者
    const isFollow = await this.contentUserBehaviorEntity.findOneBy({
      userId: this.ctx.user.id,
      author: info.userId,
      behaviorType: BehaviorType.FOLLOW,
    });
    return {
      ...info,
      likedCount: String(likedCount),
      userName: user.nickName,
      avatarUrl: user.avatarUrl,
      isLiked: !!isLiked,
      isWatching: !!isWatching,
      isFollow: !!isFollow,
    };
  }

  /**
   * 修改
   * @param param 数据
   */
  async update(param) {
    const { tagList, id } = param;

    const oldData = await this.contentDataEntity.findOneBy({ id });
    // 仅可修改自己创建的
    if (oldData.userId !== this.ctx.user.id) {
      throw new CoolCommException('无法修改他人的内容');
    }
    // 过滤掉空标签
    const newTagList = _.compact(tagList);
    const oldTagList = oldData.tagList;

    // 提取差集的函数
    const difference = (arr1, arr2) => {
      const set1 = new Set(arr1);
      const set2 = new Set(arr2);
      return arr1.filter(x => !set2.has(x));
    };

    const addTags = difference(newTagList, oldTagList);
    const delTags = difference(oldTagList, newTagList);

    await Promise.all([
      this.contentTagService.batchAdd(newTagList),
      this.contentTagService.batchAddCount(addTags),
      this.contentTagService.batchSubCount(delTags),
    ]);

    // 更新数据
    await this.contentDataEntity.save({ ...param, tagList: newTagList });
  }

  /**
   * 删除
   */
  async delete(ids: number[]) {
    // 仅可删除自己创建的
    const userId = this.ctx.user.id;
    const count = await this.contentDataEntity.count({
      where: { id: In(ids), userId },
    });
    if (count !== ids.length) {
      throw new CoolCommException('无法删除他人的内容');
    }
    await super.delete(ids);
  }

  /**
   * 根据ids查询列表
   * @param query
   */
  async listByIds(ids) {
    let find = this.contentDataEntity.createQueryBuilder('a');
    find
      .leftJoinAndSelect(UserInfoEntity, 'b', 'a.userId = b.id')
      .leftJoinAndSelect(
        ContentUserBehaviorEntity,
        'c',
        'a.id = c.dataId and c.behaviorType = :behaviorType',
        { behaviorType: BehaviorType.FAVORITE }
      )
      .select([
        'a.id as id',
        'a.title as title',
        'a.tagList as tagList',
        'a.url as url',
        'COUNT(c.id) as likedCount',
        'a.userId as userId',
        'a.createTime as createTime',
        'a.updateTime as updateTime',
        'b.nickName as userName',
        'b.avatarUrl as avatarUrl',
      ])
      .groupBy('a.id')
      .where('a.id in (:...ids)', { ids });
    // 过滤掉隐藏内容
    find.andWhere('a.visible = 1');
    const results = await find.getRawMany();
    // 根据查询结果和传入的ids构建最终结果
    return ids.map(id => {
      const result = results.find(item => item.id === id);
      if (result) {
        return result;
      } else {
        return {
          id,
          title: '该内容已不存在',
          tagList: [],
          url: '',
          likedCount: '0',
          userId: 0,
          createTime: new Date(),
          updateTime: new Date(),
          userName: '',
          avatarUrl: '',
          isDeleted: true,
        };
      }
    });
  }

  /**
   * 探知
   * @param query
   */
  async explore(query) {
    const { dataId } = query;
    const userId = this.ctx.user.id;
    const device = await this.contentDeviceEntity.findOne({
      where: { userId },
    });
    if (device) {
      const info = await this.contentDataEntity.findOneBy({ id: dataId });
      if (info) {
        // 记录用户行为
        await this.contentUserBehaviorEntity.save({
          userId,
          dataId,
          behaviorType: BehaviorType.EXPLORE,
        });
        return info;
      } else {
        throw new CoolCommException('内容不存在');
      }
    } else {
      throw new CoolCommException('用户设备不存在');
    }
  }

  /**
   * 将用户所有内容的visible设置为
   * @param query
   */
  async hideAll(query) {
    const { visible, userId } = query;
    await this.contentDataEntity.update({ userId }, { visible });
  }
}
