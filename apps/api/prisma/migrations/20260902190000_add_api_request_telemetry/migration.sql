-- Sprint 44.2.14.4.7
-- Add API request telemetry aggregation.
-- Additive only: no existing XaaSGrid tables are modified.

CREATE TABLE "api_request_telemetry" (
    "id" SERIAL NOT NULL,
    "bucket_start" TIMESTAMP(3) NOT NULL,
    "bucket_minutes" INTEGER NOT NULL DEFAULT 1,
    "method" VARCHAR(16) NOT NULL,
    "path" VARCHAR(500) NOT NULL,
    "total_requests" INTEGER NOT NULL DEFAULT 0,
    "successful_requests" INTEGER NOT NULL DEFAULT 0,
    "client_errors" INTEGER NOT NULL DEFAULT 0,
    "server_errors" INTEGER NOT NULL DEFAULT 0,
    "total_duration_ms" BIGINT NOT NULL DEFAULT 0,
    "max_duration_ms" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "api_request_telemetry_pkey"
        PRIMARY KEY ("id")
);

CREATE INDEX "api_request_telemetry_bucket_start_idx"
    ON "api_request_telemetry"("bucket_start");

CREATE INDEX "api_request_telemetry_path_idx"
    ON "api_request_telemetry"("path");

CREATE UNIQUE INDEX "api_request_telemetry_bucket_start_method_path_key"
    ON "api_request_telemetry"("bucket_start", "method", "path");
