import { report } from "./slack";

export class RequestContext {
  requestID: string;
  functionName: string;
  constructor(requestID: string, functionName: string) {
    this.requestID = requestID;

    this.functionName = functionName;
  }

  logJsonPayload(object?: { [key: string]: unknown }): {
    [key: string]: unknown;
  } {
    return { object, requestID: this.requestID };
  }
}

export function requestContext(args: {
  requestID: string;
  functionName: string;
}): RequestContext {
  const { requestID, functionName } = args;
  return new RequestContext(requestID, functionName);
}

export function reject(
  context: RequestContext,
  error: Error | string | unknown,
  callback: (error: Error | string | unknown) => void
): Promise<never> {
  report(context.requestID, context.functionName, error);
  callback(error);
  return Promise.reject();
}

// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
export function reportWithError(
  context: RequestContext,
  error: Error | string | unknown,
  callback: (error: Error | string | unknown) => void
) {
  report(context.requestID, context.functionName, error);
  callback(error);
}
