import { Inject, Provide } from '@midwayjs/decorator';
import { BaseService } from '@cool-midway/core';
import { InjectEntityModel } from '@midwayjs/typeorm';
import { Brackets, In, LessThan, Repository } from 'typeorm';
import * as _ from 'lodash';
import * as moment from 'moment';
import {
  BehaviorType,
  ContentUserBehaviorEntity,
} from '../entity/user_behavior';
import { BaseSysConfService } from '../../base/service/sys/conf';
import { ContentDataService } from './data';
import { UserInfoEntity } from '../../user/entity/info';
import { ContentDataEntity } from '../entity/data';
import { UserInfoService } from '../../user/service/info';

/**
 * 用户行为
 */
@Provide()
export class ContentUserBehaviorService extends BaseService {
  @Inject()
  ctx;

  @InjectEntityModel(ContentUserBehaviorEntity)
  contentUserBehaviorEntity: Repository<ContentUserBehaviorEntity>;

  @InjectEntityModel(ContentDataEntity)
  contentDataEntity: Repository<ContentDataEntity>;

  @Inject()
  baseSysConfService: BaseSysConfService;

  @Inject()
  contentDataService: ContentDataService;

  @Inject()
  userInfoService: UserInfoService;

  /**
   * 加入常看或者取消常看
   */
  async watching(body) {
    const { dataId } = body;
    const userId = this.ctx.user.id;
    const data = await this.contentUserBehaviorEntity.findOne({
      where: { dataId, userId, behaviorType: BehaviorType.WATCHING },
    });
    if (data) {
      await this.contentUserBehaviorEntity.remove(data);
      return false;
    } else {
      await this.contentUserBehaviorEntity.save({
        dataId,
        userId,
        behaviorType: BehaviorType.WATCHING,
      });
      return true;
    }
  }

  /**
   * 收藏或者取消收藏
   */
  async like(body) {
    const { dataId } = body;
    const userId = this.ctx.user.id;
    const data = await this.contentUserBehaviorEntity.findOne({
      where: { dataId, userId, behaviorType: BehaviorType.FAVORITE },
    });
    if (data) {
      await this.contentUserBehaviorEntity.remove(data);
      return false;
    } else {
      await this.contentUserBehaviorEntity.save({
        dataId,
        userId,
        behaviorType: BehaviorType.FAVORITE,
      });
      return true;
    }
  }

  /**
   * 关注或者取消关注
   */
  async follow(body) {
    const { author } = body;
    const userId = this.ctx.user.id;
    const data = await this.contentUserBehaviorEntity.findOne({
      where: { author, userId, behaviorType: BehaviorType.FOLLOW },
    });
    if (data) {
      await this.contentUserBehaviorEntity.remove(data);
      return false;
    } else {
      await this.contentUserBehaviorEntity.save({
        author,
        userId,
        behaviorType: BehaviorType.FOLLOW,
      });
      return true;
    }
  }

  /**
   * 获取我的关注列表分页
   */

  async getMyFollowList(body) {
    const { page, size, keyWord } = body;
    const userId = this.ctx.user.id;

    const find = this.contentUserBehaviorEntity.createQueryBuilder('a');

    find
      .select('a.author as author')
      .leftJoin(UserInfoEntity, 'user', 'a.author = user.id')
      .addSelect('MAX(a.createTime)', 'maxCreateTime')
      .where('a.userId = :userId', { userId })
      .andWhere('a.behaviorType = :behaviorType', {
        behaviorType: BehaviorType.FOLLOW,
      })
      .groupBy('a.author')
      .orderBy('maxCreateTime', 'DESC');

    if (keyWord) {
      find.andWhere('user.nickName LIKE :keyWord', {
        keyWord: `%${keyWord}%`,
      });
    }

    const rawSql = find.getQuery();

    const [list, total] = await Promise.all([
      find
        .clone()
        .offset((page - 1) * size)
        .limit(size)
        .getRawMany(),
      this.contentUserBehaviorEntity.query(
        `SELECT COUNT(*) as count FROM (${rawSql
          .replace(':userId', `"${userId}"`)
          .replace(
            ':behaviorType',
            `"${BehaviorType.FOLLOW}"`
          )}) as distinctResultSet`
      ),
    ]);

    const totalCount = total[0].count;
    const ids = list.map(item => item.author);
    return {
      list: ids.length ? await this.userInfoService.listByAuthorIds(ids) : [],
      pagination: {
        page: parseInt(page),
        size: parseInt(size),
        total: parseInt(totalCount),
      },
    };
  }

  /**
   * 获取关注我的列表分页
   */
  async getFollowMeList(body) {
    const { page, size, keyWord } = body;
    const userId = this.ctx.user.id;

    const find = this.contentUserBehaviorEntity.createQueryBuilder('a');

    find
      .select('a.userId as userId')
      .leftJoin(UserInfoEntity, 'user', 'a.userId = user.id')
      .addSelect('MAX(a.createTime)', 'maxCreateTime')
      .where('a.author = :author', { author: userId })
      .andWhere('a.behaviorType = :behaviorType', {
        behaviorType: BehaviorType.FOLLOW,
      })
      .groupBy('a.userId')
      .orderBy('maxCreateTime', 'DESC');

    if (keyWord) {
      find.andWhere('user.nickName LIKE :keyWord', {
        keyWord: `%${keyWord}%`,
      });
    }

    const rawSql = find.getQuery();

    const [list, total] = await Promise.all([
      find
        .clone()
        .offset((page - 1) * size)
        .limit(size)
        .getRawMany(),
      this.contentUserBehaviorEntity.query(
        `SELECT COUNT(*) as count FROM (${rawSql
          .replace(':author', `"${userId}"`)
          .replace(
            ':behaviorType',
            `"${BehaviorType.FOLLOW}"`
          )}) as distinctResultSet`
      ),
    ]);

    const totalCount = total[0].count;
    const ids = list.map(item => item.userId);
    return {
      list: ids.length ? await this.userInfoService.listByAuthorIds(ids) : [],
      pagination: {
        page: parseInt(page),
        size: parseInt(size),
        total: parseInt(totalCount),
      },
    };
  }

  /**
   * 举报
   */
  async report(body) {
    const { dataId, description } = body;
    const userId = this.ctx.user.id;
    // 查询dataId内容做备份
    const data = await this.contentDataEntity.findOneBy({ id: dataId });
    // 查询举报内容是否存在
    const reportData = await this.contentUserBehaviorEntity.findOne({
      where: { dataId, userId, behaviorType: BehaviorType.REPORT },
    });
    if (reportData) {
      // 更新举报内容
      await this.contentUserBehaviorEntity.update(reportData.id, {
        description,
        extra: data,
      });
    } else {
      await this.contentUserBehaviorEntity.save({
        dataId,
        userId,
        behaviorType: BehaviorType.REPORT,
        description,
        extra: data,
      });
    }
  }

  /**
   * 查询我最近看的标签
   */
  async getMyRecentTag() {
    const userId = this.ctx.user.id;
    const data = await this.contentUserBehaviorEntity.find({
      where: { userId, behaviorType: BehaviorType.VIEW },
      order: { createTime: 'DESC' },
      take: 30,
    });
    return _.uniq(data.flatMap(item => item.tags)).slice(0, 30);
  }

  /**
   * 查询我看过的所有标签
   */
  async getMyAllTag() {
    const userId = this.ctx.user.id;
    const data = await this.contentUserBehaviorEntity.find({
      where: { userId, behaviorType: BehaviorType.VIEW },
    });
    return _.uniq(data.map(item => item.tags).flatMap(tag => tag));
  }

  /**
   * 清除用户行为类型为view的数据
   */
  async clear() {
    const keepDay = await this.baseSysConfService.getValue('userBehaviorKeep');
    if (keepDay) {
      const beforeDate = moment().add(-keepDay, 'days').startOf('day').toDate();
      await this.contentUserBehaviorEntity.delete({
        createTime: LessThan(beforeDate),
        behaviorType: BehaviorType.VIEW,
      });
    } else {
      await this.contentUserBehaviorEntity.clear();
    }
  }
  /**
   * 查询浏览记录behaviorType为view的分页
   */
  async getMyAllContent(body) {
    const { page, size, keyWord, behaviorType } = body;
    const userId = this.ctx.user.id;

    const find = this.contentUserBehaviorEntity.createQueryBuilder('a');

    find
      .select('a.dataId as dataId')
      .leftJoin(ContentDataEntity, 'data', 'a.dataId')
      .leftJoin(UserInfoEntity, 'user', 'a.userId')
      .addSelect('MAX(a.updateTime)', 'maxUpdateTime')
      .where('a.userId = :userId', { userId })
      .andWhere('a.behaviorType = :behaviorType', { behaviorType })
      .groupBy('a.dataId')
      .orderBy('maxUpdateTime', 'DESC');

    if (keyWord) {
      find.andWhere(
        new Brackets(qb => {
          qb.where('data.title LIKE :keyWord', {
            keyWord: `%${keyWord}%`,
          }).orWhere('user.nickName LIKE :keyWord', {
            keyWord: `%${keyWord}%`,
          });
        })
      );
    }

    const rawSql = find.getQuery();

    const [list, total] = await Promise.all([
      find
        .clone()
        .offset((page - 1) * size)
        .limit(size)
        .getRawMany(),
      this.contentUserBehaviorEntity.query(
        `SELECT COUNT(*) as count FROM (${rawSql
          .replace(':userId', `"${userId}"`)
          .replace(':behaviorType', `"${behaviorType}"`)}) as distinctResultSet`
      ),
    ]);

    const totalCount = total[0].count;
    const ids = list.map(item => item.dataId);
    return {
      list: ids.length ? await this.contentDataService.listByIds(ids) : [],
      pagination: {
        page: parseInt(page),
        size: parseInt(size),
        total: parseInt(totalCount),
      },
    };
  }

  /**
   * 获得我的收藏、关注、粉丝的数量
   */
  async getMyCount() {
    const userId = this.ctx.user.id;
    const [favoriteCount, followCount, fansCount] = await Promise.all([
      this.contentUserBehaviorEntity.count({
        where: { userId, behaviorType: BehaviorType.FAVORITE },
      }),
      this.contentUserBehaviorEntity.count({
        where: { userId, behaviorType: BehaviorType.FOLLOW },
      }),
      this.contentUserBehaviorEntity.count({
        where: { author: userId, behaviorType: BehaviorType.FOLLOW },
      }),
    ]);
    return {
      favoriteCount,
      followCount,
      fansCount,
    };
  }

  /**
   * 删除自己查看过的内容
   */
  async deleteView(body) {
    const { dataId } = body;
    const userId = this.ctx.user.id;
    await this.contentUserBehaviorEntity.delete({
      dataId,
      userId,
      behaviorType: BehaviorType.VIEW,
    });
  }

  /**
   * 删除自己查看过的所有内容
   */
  async deleteAllView() {
    const userId = this.ctx.user.id;
    await this.contentUserBehaviorEntity.delete({
      userId,
      behaviorType: BehaviorType.VIEW,
    });
  }

  /**
   * 所有举报的分页
   */
  async page(body) {
    const { page, size, keyWord } = body;

    const find = this.contentUserBehaviorEntity.createQueryBuilder('a');

    find
      .leftJoinAndSelect(UserInfoEntity, 'b', 'a.userId = b.id')
      .select([
        'a.id as id',
        'a.dataId as dataId',
        'a.userId as userId',
        'a.createTime as createTime',
        'a.updateTime as updateTime',
        'a.behaviorType as behaviorType',
        'a.author as author',
        'a.extra as extra',
        'b.nickName as userName',
        'a.description as description',
        'MAX(a.createTime) as maxCreateTime',
      ])
      .where('a.behaviorType = :behaviorType', {
        behaviorType: BehaviorType.REPORT,
      })
      .groupBy('a.dataId')
      .orderBy('maxCreateTime', 'DESC');

    if (keyWord) {
      find.andWhere('a.description LIKE :keyWord', {
        keyWord: `%${keyWord}%`,
      });
    }

    const rawSql = find.getQuery();

    const [list, total] = await Promise.all([
      find
        .clone()
        .offset((page - 1) * size)
        .limit(size)
        .getRawMany(),
      this.contentUserBehaviorEntity.query(
        `SELECT COUNT(*) as count FROM (${rawSql.replace(
          ':behaviorType',
          `"${BehaviorType.REPORT}"`
        )}) as distinctResultSet`
      ),
    ]);

    const totalCount = total[0].count;
    const ids = list.map(item => item.dataId);
    const contentDatas = await this.contentDataService.listByIds(ids);
    return {
      list: list.map(item => {
        const contentData = contentDatas.find(
          contentData => contentData.id === item.dataId
        );
        return {
          ...item,
          data: contentData,
        };
      }),
      pagination: {
        page: parseInt(page),
        size: parseInt(size),
        total: parseInt(totalCount),
      },
    };
  }

  /**
   * 封禁内容
   */
  async ban(body) {
    const { ids } = body;
    // 查询举报内容是否存在
    const reportData = await this.contentUserBehaviorEntity.find({
      where: { id: In(ids), behaviorType: BehaviorType.REPORT },
    });
    console.log(reportData.map(item => item.dataId));
    await this.contentDataEntity.update(
      { id: In(reportData.map(item => item.dataId)) },
      {
        visible: false,
      }
    );
  }
}
