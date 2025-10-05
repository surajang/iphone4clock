#!/bin/bash

# iPhone 4 Clock 서버 중지 스크립트
# 사용법: ./stop.sh

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 로그 함수
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_info "iPhone 4 Clock 서버 중지 중..."

# PID 파일에서 프로세스 ID 읽기
if [ -f "server.pid" ]; then
    PID=$(cat server.pid)
    log_info "PID 파일에서 프로세스 ID 읽음: $PID"
    
    if ps -p $PID > /dev/null 2>&1; then
        log_info "프로세스 $PID 종료 중..."
        kill $PID
        sleep 2
        
        # 프로세스가 여전히 실행 중인지 확인
        if ps -p $PID > /dev/null 2>&1; then
            log_warning "프로세스가 종료되지 않음. 강제 종료 중..."
            kill -9 $PID
            sleep 1
        fi
        
        if ! ps -p $PID > /dev/null 2>&1; then
            log_success "서버가 성공적으로 종료되었습니다"
            rm -f server.pid
        else
            log_error "서버 종료 실패"
            exit 1
        fi
    else
        log_warning "PID $PID에 해당하는 프로세스가 실행 중이지 않습니다"
        rm -f server.pid
    fi
else
    log_warning "PID 파일이 없습니다. 프로세스 이름으로 검색 중..."
    
    # 프로세스 이름으로 검색하여 종료
    if pgrep -f "node server.js" > /dev/null; then
        log_info "node server.js 프로세스 발견. 종료 중..."
        pkill -f "node server.js"
        sleep 2
        
        if ! pgrep -f "node server.js" > /dev/null; then
            log_success "서버가 성공적으로 종료되었습니다"
        else
            log_error "서버 종료 실패"
            exit 1
        fi
    else
        log_warning "실행 중인 서버 프로세스가 없습니다"
    fi
fi

log_success "✅ 서버 중지 완료"
