export interface DataResponse {
    result: "OK";
    statusCode: 200 | 302;
    data: unknown,
}

export interface ErrorResponse {
    result: "NG";
    statusCode: 401 | 500 | number;
    error: unknown & { message: string },
}

export type OnCallResponse = DataResponse | ErrorResponse;
