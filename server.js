const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// 정적 파일 서빙 (HTML, CSS, JS)
app.use(express.static(path.join(__dirname, 'public')));

// 메인 페이지 라우트
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`시계 서버가 포트 ${PORT}에서 실행 중입니다.`);
  console.log(`로컬 네트워크에서 접속: http://[서버IP]:${PORT}`);
});
