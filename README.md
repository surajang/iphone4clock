# iPhone 4 Clock

구형 iPhone 4를 테이블탑 시계로 활용하는 간단한 웹앱입니다.

## 특징

- iPhone 4 Safari 브라우저 최적화
- 검정 배경에 흰색 텍스트로 24시간 형식 시:분:초 표시
- 실시간 시간 업데이트
- 홈 네트워크 내부 서버에서 서빙
- 경량화된 기술 스택 (Node.js + 순수 HTML/CSS/JS)

## 설치 및 실행

1. 의존성 설치:
```bash
npm install
```

2. 서버 실행:
```bash
npm start
```

3. iPhone 4 Safari에서 접속:
```
http://[서버IP]:3000
```

## 기술 스택

- **백엔드**: Node.js + Express
- **프론트엔드**: 순수 HTML5, CSS3, JavaScript (ES5)
- **호환성**: iPhone 4 Safari (iOS 7.1.2까지 지원)

## 주요 기능

- 24시간 형식 시간 표시 (HH:MM:SS)
- 1초마다 자동 업데이트
- 서버 시간 동기화 (폴백: 로컬 시간)
- 터치 스크롤 및 줌 방지
- 반응형 디자인 (iPhone 4 화면 크기 최적화)
