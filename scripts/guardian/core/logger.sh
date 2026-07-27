#!/usr/bin/env bash

GUARDIAN_LOG_DIR="$(dirname "$(dirname "$BASH_SOURCE")")/logs"

mkdir -p "$GUARDIAN_LOG_DIR"

GUARDIAN_LOG_FILE="$GUARDIAN_LOG_DIR/guardian.log"


guardian_timestamp(){

    date +"%Y-%m-%d %H:%M:%S"

}


log_info(){

    echo "$(guardian_timestamp) [INFO] $1" | tee -a "$GUARDIAN_LOG_FILE"

}


log_success(){

    echo "$(guardian_timestamp) [SUCCESS] $1" | tee -a "$GUARDIAN_LOG_FILE"

}


log_warn(){

    echo "$(guardian_timestamp) [WARN] $1" | tee -a "$GUARDIAN_LOG_FILE"

}


log_error(){

    echo "$(guardian_timestamp) [ERROR] $1" | tee -a "$GUARDIAN_LOG_FILE"

}
