import {
  WSController,
  OnWSConnection,
  Inject,
  OnWSMessage,
} from '@midwayjs/decorator';
import { Context } from '@midwayjs/socketio';
import { SocketMiddleware } from './socket.middleware';
import { ContentMessageService } from '../modules/content/service/message';
import { InjectEntityModel } from '@midwayjs/typeorm';
import { UserInfoEntity } from '../modules/user/entity/info';
import { Repository } from 'typeorm';
/**
 * 一枝聊天室
 */
@WSController('/chat')
export class YizhiController {
  @InjectEntityModel(UserInfoEntity)
  userInfoEntity: Repository<UserInfoEntity>;

  @Inject()
  contentMessageService: ContentMessageService;

  @Inject()
  ctx: Context & { user: any };

  // 客户端连接
  @OnWSConnection({ middleware: [SocketMiddleware] })
  async onConnectionMethod() {
    console.log('on client connect', this.ctx.id);
    const roomId = this.ctx.handshake.headers['room-id'];
    if (!roomId) return;
    const sockets = await this.ctx.in(roomId).fetchSockets();
    // 这里在线人数有问题
    this.ctx.join(roomId);
    this.ctx.emit('users', sockets.length + 1);
    this.ctx.to(roomId).emit('users', sockets.length + 1);
  }

  // 消息事件
  @OnWSMessage('message')
  async gotMessage(data) {
    // 获取当前用户id
    console.log('user', this.ctx.user);
    console.log('on data got', data);
    const roomId = this.ctx.handshake.headers['room-id'];
    const clientType = this.ctx.handshake.headers['client-type'];
    if ('app' === clientType) {
      if (roomId === 'mutual_printing_space') {
        this.ctx.broadcast.to(roomId).emit('message', {
          ...data,
        });
        this.ctx.emit('message', {
          ...data,
        });
      } else {
        const message = await this.contentMessageService.add({
          // 转换为数字
          dataId: Number(roomId),
          message: data.message,
          userId: this.ctx.user.userId,
        });
        const user = await this.userInfoEntity.findOneBy({
          id: this.ctx.user.userId,
        });
        this.ctx.broadcast.to(roomId).emit('message', {
          ...message,
          nickName: user.nickName,
          avatarUrl: user.avatarUrl,
        });
        this.ctx.emit('message', {
          ...message,
          nickName: user.nickName,
          avatarUrl: user.avatarUrl,
        });
      }
    } else {
      this.ctx.broadcast.to(roomId).emit('message', data);
    }
  }
}
