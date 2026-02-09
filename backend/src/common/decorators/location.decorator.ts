import { createParamDecorator, ExecutionContext } from '@nestjs/common';

export const CurrentLocation = createParamDecorator(
  (data: unknown, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    return request.headers['x-location-id'] || request.query.locationId;
  },
);