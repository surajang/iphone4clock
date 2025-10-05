#!/bin/bash

# iPhone 4 Clock 배포 스크립트
# 사용법: ./deploy.sh

set -e  # 에러 발생 시 스크립트 중단

echo "🚀 iPhone 4 Clock 배포 시작..."

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

# 기존 프로세스 종료
log_info "기존 서버 프로세스 확인 중..."
if pgrep -f "node server.js" > /dev/null; then
    log_warning "기존 서버 프로세스 발견. 종료 중..."
    pkill -f "node server.js" || true
    sleep 2
    log_success "기존 서버 프로세스 종료 완료"
else
    log_info "실행 중인 서버 프로세스 없음"
fi

# Git 업데이트
log_info "Git 저장소에서 최신 코드 가져오는 중..."
if git pull origin main; then
    log_success "Git 업데이트 완료"
else
    log_error "Git 업데이트 실패"
    exit 1
fi

# 의존성 설치
log_info "npm 의존성 설치 중..."
if npm install; then
    log_success "의존성 설치 완료"
else
    log_error "의존성 설치 실패"
    exit 1
fi

# public 디렉토리 및 파일 확인/생성
if [ ! -d "public" ]; then
    log_info "public 디렉토리 생성 중..."
    mkdir -p public
    log_success "public 디렉토리 생성 완료"
fi

# index.html 파일 확인
if [ ! -f "public/index.html" ]; then
    log_error "public/index.html 파일이 없습니다!"
    log_error "Git에 public 디렉토리가 제대로 추가되지 않았을 수 있습니다."
    log_error "다음 명령어로 확인하세요: git add public/ && git commit -m 'Add public directory'"
    exit 1
fi

log_success "public/index.html 파일 확인 완료"

# 서버 백그라운드 실행
log_info "서버를 백그라운드에서 시작 중..."
nohup npm start > server.log 2>&1 &
SERVER_PID=$!

# 서버 시작 확인
sleep 3
if ps -p $SERVER_PID > /dev/null; then
    log_success "서버가 성공적으로 시작되었습니다 (PID: $SERVER_PID)"
    log_info "서버 로그: tail -f server.log"
    log_info "서버 중지: kill $SERVER_PID"
    
    # 네트워크 정보 출력
    log_info "네트워크 접속 정보:"
    echo "  - 로컬: http://localhost:3000"
    echo "  - 네트워크: http://$(hostname -I | awk '{print $1}'):3000"
    echo "  - iPhone 4에서 접속: http://$(hostname -I | awk '{print $1}'):3000"
    
    # PID 저장
    echo $SERVER_PID > server.pid
    log_success "PID가 server.pid 파일에 저장되었습니다"
    
else
    log_error "서버 시작 실패"
    log_error "로그 확인: cat server.log"
    exit 1
fi

log_success "🎉 배포 완료!"
