const prisma = require("../database/prisma");

const getBucketStart = (date) => {
    const bucket = new Date(date);
    bucket.setSeconds(0, 0);
    return bucket;
};

const recordTelemetry = async ({
    bucketStart,
    method,
    path,
    status,
    durationMs
}) => {
    const successful = status >= 200 && status < 400;
    const clientError = status >= 400 && status < 500;
    const serverError = status >= 500;

    try {
        await prisma.$executeRaw`
            INSERT INTO "api_request_telemetry" (
                "bucket_start",
                "bucket_minutes",
                "method",
                "path",
                "total_requests",
                "successful_requests",
                "client_errors",
                "server_errors",
                "total_duration_ms",
                "max_duration_ms"
            )
            VALUES (
                ${bucketStart},
                1,
                ${method},
                ${path},
                1,
                ${successful ? 1 : 0},
                ${clientError ? 1 : 0},
                ${serverError ? 1 : 0},
                ${BigInt(durationMs)},
                ${durationMs}
            )
            ON CONFLICT ("bucket_start", "method", "path")
            DO UPDATE SET
                "total_requests" =
                    "api_request_telemetry"."total_requests" + 1,

                "successful_requests" =
                    "api_request_telemetry"."successful_requests"
                    + ${successful ? 1 : 0},

                "client_errors" =
                    "api_request_telemetry"."client_errors"
                    + ${clientError ? 1 : 0},

                "server_errors" =
                    "api_request_telemetry"."server_errors"
                    + ${serverError ? 1 : 0},

                "total_duration_ms" =
                    "api_request_telemetry"."total_duration_ms"
                    + ${BigInt(durationMs)},

                "max_duration_ms" =
                    GREATEST(
                        "api_request_telemetry"."max_duration_ms",
                        ${durationMs}
                    );
        `;
    } catch (error) {
        /*
         * Telemetry must never become an API availability dependency.
         */
        console.error(
            JSON.stringify({
                timestamp: new Date().toISOString(),
                telemetry: "write_failed",
                error: error.message
            })
        );
    }
};

const logger = (req, res, next) => {
    const start = Date.now();

    res.on("finish", () => {
        const duration = Date.now() - start;
        const path = req.path || req.originalUrl || req.url;
        const bucketStart = getBucketStart(new Date());

        console.log(
            JSON.stringify({
                timestamp: new Date().toISOString(),
                method: req.method,
                path: req.originalUrl,
                status: res.statusCode,
                duration: `${duration}ms`
            })
        );

        void recordTelemetry({
            bucketStart,
            method: req.method,
            path,
            status: res.statusCode,
            durationMs: duration
        });
    });

    next();
};

module.exports = logger;
