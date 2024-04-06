import { Config, Middleware } from '@midwayjs/core';
import { Context, NextFunction } from '@midwayjs/socketio';
import * as jwt from 'jsonwebtoken';

@Middleware()
export class SocketMiddleware {
  @Config('module.base.jwt')
  jwtConfig;

  @Config('module.user.jwt')
  userJwtConfig;

  resolve() {
    return async (ctx: Context & { user: any }, next: NextFunction) => {
      const clientType = ctx.handshake.headers['client-type'];
      const token = ctx.handshake.auth.token;
      if (token) {
        console.log('token', token);
        console.log('userJwtConfig', this.userJwtConfig.secret);
        console.log('jwtConfig', this.jwtConfig.secret);

        const user =
          clientType === 'app'
            ? jwt.verify(token, this.userJwtConfig.secret)
            : jwt.verify(token, this.jwtConfig.secret);
        if (user) {
          // 存储用户信息
          console.log('user', user);
          ctx.user = clientType === 'app' ? { ...user, userId: user.id } : user;
          return await next();
        } else {
          // 如果身份验证失败，则拒绝连接
          ctx.disconnect();
        }
      } else {
        // 如果没有提供令牌，则拒绝连接
        ctx.disconnect();
      }
    };
  }
}
