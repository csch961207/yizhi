import { Provide, Inject, Get, Post, Body, ALL } from '@midwayjs/decorator';
import { CoolController, BaseController } from '@cool-midway/core';
import { Context } from '@midwayjs/koa';
import { CoolFile } from '@cool-midway/file';
import { ContentUserBehaviorService } from '../../service/user_behavior';
import { BehaviorType } from '../../entity/user_behavior';

/**
 * 用户行为
 */
@Provide()
@CoolController()
export class AppContentUserBehaviorController extends BaseController {
  @Inject()
  contentUserBehaviorService: ContentUserBehaviorService;

  @Inject()
  ctx: Context;

  /**
   * 获得我最近看过的标签
   */
  @Get('/getMyRecentTag', { summary: '我最近看过的标签' })
  async getMyRecentTag() {
    return this.ok(await this.contentUserBehaviorService.getMyRecentTag());
  }

  /**
   * 获得我看过的所有标签
   */
  @Get('/getMyAllTag', { summary: '我最近看过的标签' })
  async getMyAllTag() {
    return this.ok(await this.contentUserBehaviorService.getMyAllTag());
  }

  /**
   * 获得我看过的所有内容
   */
  @Post('/getMyViewContent', { summary: '我看过的所有内容' })
  async getMyViewContent(@Body() body) {
    return this.ok(
      await this.contentUserBehaviorService.getMyAllContent({
        ...body,
        behaviorType: BehaviorType.VIEW,
      })
    );
  }

  /**
   * 获得我收藏的所有内容
   */
  @Post('/getMyFavoriteContent', { summary: '我收藏的所有内容' })
  async getMyFavoriteContent(@Body() body) {
    return this.ok(
      await this.contentUserBehaviorService.getMyAllContent({
        ...body,
        behaviorType: BehaviorType.FAVORITE,
      })
    );
  }

  /**
   * 获得我的收藏、关注、粉丝的数量
   */
  @Get('/getMyCount', { summary: '我的收藏、关注、粉丝的数量' })
  async getMyCount() {
    return this.ok(await this.contentUserBehaviorService.getMyCount());
  }

  /**
   * 收藏或者取消收藏
   */
  @Post('/like', { summary: '收藏或者取消收藏' })
  async like(@Body(ALL) body) {
    return this.ok(await this.contentUserBehaviorService.like(body));
  }

  /**
   * 关注或者取消关注
   */
  @Post('/follow', { summary: '关注或者取消关注' })
  async follow(@Body(ALL) body) {
    // 不能关注自己
    if (body.author === this.ctx.user.id) {
      return this.fail('不能关注自己');
    }
    return this.ok(await this.contentUserBehaviorService.follow(body));
  }

  /**
   * 获取我的关注列表分页
   */
  @Post('/getMyFollowList', { summary: '获取我的关注列表分页' })
  async getMyFollowList(@Body(ALL) body) {
    return this.ok(await this.contentUserBehaviorService.getMyFollowList(body));
  }

  /**
   * 获取关注我的列表分页
   */
  @Post('/getFollowMeList', { summary: '获取关注我的列表分页' })
  async getFollowMeList(@Body(ALL) body) {
    return this.ok(await this.contentUserBehaviorService.getFollowMeList(body));
  }

  /**
   * 举报
   */
  @Post('/report', { summary: '举报' })
  async report(@Body(ALL) body) {
    return this.ok(await this.contentUserBehaviorService.report(body));
  }

  /**
   * 加入常看或者取消常看
   */
  @Post('/watching', { summary: '加入常看或者取消常看' })
  async watching(@Body(ALL) body) {
    return this.ok(await this.contentUserBehaviorService.watching(body));
  }

  /**
   * 删除自己查看过的内容
   */
  @Post('/deleteView', { summary: '删除自己查看过的内容' })
  async deleteView(@Body(ALL) body) {
    return this.ok(await this.contentUserBehaviorService.deleteView(body));
  }

  /**
   * 删除自己查看过的所有内容
   */
  @Post('/deleteAllView', { summary: '删除自己查看过的所有内容' })
  async deleteAllView() {
    return this.ok(await this.contentUserBehaviorService.deleteAllView());
  }
}
