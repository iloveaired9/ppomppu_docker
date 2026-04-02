# ppomppu Docker 빠른 시작 가이드

## 5분 안에 시작하기

### 필수 조건
- Docker Desktop 설치 및 실행 중
- 터미널/Command Prompt 접근 가능

---

## 🚀 Step 1: 저장소 클론

```bash
git clone https://github.com/iloveaired9/ppomppu_docker.git
cd ppomppu_docker
```

---

## 🐳 Step 2: Docker 이미지 빌드

```bash
docker build -t ppomppu:latest .
```

**소요 시간**: 약 1-2분

---

## ▶️ Step 3: 컨테이너 실행

```bash
docker run -d -p 80:80 -p 443:443 --name ppomppu ppomppu:latest
```

**옵션 설명**:
- `-d`: 백그라운드 실행
- `-p 80:80`: HTTP 포트 매핑
- `-p 443:443`: HTTPS 포트 매핑
- `--name ppomppu`: 컨테이너 이름

---

## ✅ Step 4: 서비스 확인

### 웹 서버 확인
```bash
curl http://localhost
```

**예상 응답**: Apache 기본 테스트 페이지 또는 403 Forbidden

### PHP 확인
```bash
docker exec ppomppu php -v
```

**예상 응답**:
```
PHP 5.5.38 (cli) (built: Jun 23 2022 08:00:53)
Copyright (c) 1997-2015 The PHP Group
```

### 설치된 모듈 확인
```bash
docker exec ppomppu php -m | grep encrypt
```

**예상 응답**:
```
encrypt_keys_php
```

---

## 🌐 브라우저에서 접속

### phpinfo 페이지 보기
1. 테스트 페이지 생성:
```bash
docker exec ppomppu bash -c 'echo "<?php phpinfo(); ?>" > /var/www/html/test.php'
```

2. 브라우저 열기:
```
http://localhost/test.php
```

---

## 📝 PHP 파일 생성 및 테스트

### 간단한 PHP 파일 생성
```bash
docker exec ppomppu bash -c 'cat > /var/www/html/hello.php << "EOF"
<?php
echo "Hello from ppomppu Docker!<br>";
echo "PHP Version: " . phpversion() . "<br>";
echo "Apache User: " . get_current_user() . "<br>";
?>
EOF'
```

### 브라우저에서 확인
```
http://localhost/hello.php
```

---

## 🔐 encrypt 모듈 테스트

```bash
docker exec ppomppu php -r "
echo 'Testing encrypt module...<br>';
if (extension_loaded('encrypt_keys_php')) {
    echo 'encrypt_keys_php module loaded: YES<br>';
} else {
    echo 'encrypt_keys_php module loaded: NO<br>';
}
"
```

---

## 📋 자주 사용하는 명령어

### 컨테이너 상태 확인
```bash
docker ps
```

### 로그 보기
```bash
docker logs ppomppu
```

### 실시간 로그 모니터링
```bash
docker logs -f ppomppu
```

### 컨테이너 내부 접속
```bash
docker exec -it ppomppu bash
```

### 컨테이너 중지
```bash
docker stop ppomppu
```

### 컨테이너 시작
```bash
docker start ppomppu
```

### 컨테이너 제거
```bash
docker rm -f ppomppu
```

---

## 🗂️ 파일 관리

### 호스트에서 파일을 컨테이너로 복사
```bash
docker cp ./myfile.php ppomppu:/var/www/html/
```

### 컨테이너의 파일을 호스트로 복사
```bash
docker cp ppomppu:/var/www/html/index.php ./
```

### 컨테이너의 파일 권한 변경
```bash
docker exec ppomppu chown -R web_user:web_user /var/www/html/
docker exec ppomppu chmod -R 755 /var/www/html/
```

---

## 🆘 문제 해결

### "Docker daemon is not running"
**해결**: Docker Desktop을 실행하세요.

### "Port 80 is already in use"
**해결**: 다른 포트를 사용하세요:
```bash
docker run -d -p 8080:80 -p 8443:443 --name ppomppu ppomppu:latest
# 접속: http://localhost:8080
```

### "Cannot connect to Docker daemon"
**해결**: Docker Desktop을 재시작하세요.

### 컨테이너가 시작되지 않음
```bash
# 로그 확인
docker logs ppomppu

# 컨테이너 상태 확인
docker ps -a

# 기존 컨테이너 제거
docker rm -f ppomppu

# 다시 실행
docker run -d -p 80:80 -p 443:443 --name ppomppu ppomppu:latest
```

---

## 📊 설치된 구성 요소 요약

| 항목 | 버전 | 상태 |
|-----|------|------|
| **Apache** | 2.4.6 | ✅ |
| **PHP** | 5.5.38 | ✅ |
| **Nutcracker (Redis Proxy)** | 0.4.1 | ✅ |
| **libwebp** | 1.3.2 | ✅ |
| **libjpeg-turbo** | 1.2.90 | ✅ |
| **libheif** | 1.12.0 | ✅ |
| **x265** | 3.4 | ✅ |
| **libde265** | 1.0.8 | ✅ |
| **encrypt_keys_php** | Custom | ✅ |
| **Memcache** | PHP Module | ✅ |
| **MySQL Support** | PHP Module | ✅ |

---

## 📚 다음 단계

자세한 정보는 다음 문서를 참조하세요:

- **전체 설치 가이드**: [INSTALLATION.md](./INSTALLATION.md)
- **개발 가이드**: [DEVELOPMENT.md](./DEVELOPMENT.md) (준비 중)
- **원본 CentOS 설치 가이드**: `docs/centos7_install/`

---

## 💡 팁

### 개발 중 자주 하는 작업
```bash
# 1. PHP 파일 수정 후 Apache 재시작
docker exec ppomppu /usr/sbin/httpd -k graceful

# 2. PHP 로그 실시간 모니터링
docker exec ppomppu tail -f /var/log/httpd/error_log

# 3. 데이터베이스 연결 테스트
docker exec ppomppu php -r "
\$conn = new mysqli('localhost', 'user', 'password', 'database');
if (\$conn->connect_error) {
    echo 'Connection failed: ' . \$conn->connect_error;
} else {
    echo 'Connected successfully';
}
"
```

---

**Happy Coding! 🎉**

질문이나 문제가 있으면 GitHub Issues에서 보고해주세요.
