# ppomppu Docker

CentOS 7 기반 완전한 PHP 5.5 웹 개발 환경을 Docker로 제공합니다.

[![GitHub](https://img.shields.io/badge/GitHub-iloveaired9/ppomppu_docker-blue?style=flat-square&logo=github)](https://github.com/iloveaired9/ppomppu_docker)
[![Docker](https://img.shields.io/badge/Docker-Ready-brightgreen?style=flat-square&logo=docker)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

---

## 🎯 특징

- ✅ **Apache 2.4.6** - 프로덕션급 웹 서버
- ✅ **PHP 5.5.38** - 안정적인 PHP 런타임 (30+ 확장 모듈)
- ✅ **Nutcracker** - Redis 프록시 및 캐시 관리
- ✅ **암호화 모듈** - AES-128 (encrypt_keys_php)
- ✅ **이미지 처리** - libwebp 1.3.2, libjpeg-turbo 1.2.90
- ✅ **데이터베이스** - MySQL, SQLite, PDO 지원
- ✅ **캐싱** - Redis, Memcache, opcache
- ✅ **비동기 작업** - Gearman job server

---

## 🚀 빠른 시작

### 1단계: Docker 설치
[Docker Desktop 다운로드](https://www.docker.com/products/docker-desktop)

### 2단계: 이미지 빌드
```bash
git clone https://github.com/iloveaired9/ppomppu_docker.git
cd ppomppu_docker
docker build -t ppomppu:latest .
```

### 3단계: 컨테이너 실행
```bash
docker run -d -p 80:80 -p 443:443 --name ppomppu ppomppu:latest
```

### 4단계: 서비스 확인
```bash
# 웹 서버 응답 확인
curl http://localhost

# PHP 확인
docker exec ppomppu php -v
```

---

## 📚 문서

| 문서 | 설명 |
|------|------|
| **[QUICKSTART.md](docs/QUICKSTART.md)** | 5분 안에 시작하기 |
| **[INSTALLATION.md](docs/INSTALLATION.md)** | 전체 설치 및 사용 가이드 |
| **[COMPONENTS.md](docs/COMPONENTS.md)** | 모든 구성 요소 상세 설명 |

---

## 📦 설치된 구성 요소

### 웹 서버 & PHP
| 컴포넌트 | 버전 | 상태 |
|---------|------|------|
| CentOS | 7 | ✅ |
| Apache | 2.4.6 | ✅ |
| PHP | 5.5.38 | ✅ |

### 캐시 & 데이터베이스
| 컴포넌트 | 역할 | 상태 |
|---------|------|------|
| Nutcracker | Redis 프록시 | ✅ |
| Redis | 캐시 저장소 | ✅ (ext) |
| Memcache | 메모리 캐시 | ✅ (ext) |
| MySQL/PDO | 데이터베이스 | ✅ (ext) |

### 이미지 & 암호화
| 라이브러리 | 버전 | 상태 |
|-----------|------|------|
| libwebp | 1.3.2 | ✅ |
| libjpeg-turbo | 1.2.90 | ✅ |
| encrypt_keys_php | Custom | ✅ |
| GD Library | PHP ext | ✅ |

### PHP 확장 (30+)
```
mcrypt, gd, gearman, curl, json, xml, zip, bz2, zlib,
mysql, mysqli, pdo, sqlite3, redis, memcache, memcached,
mbstring, gettext, sockets, ftp, fileinfo, exif, ...
```

전체 목록은 [COMPONENTS.md](docs/COMPONENTS.md) 참조

---

## 🎬 자주 사용하는 명령어

### 컨테이너 관리
```bash
# 컨테이너 상태 확인
docker ps

# 로그 보기
docker logs ppomppu

# 실시간 로그
docker logs -f ppomppu

# 컨테이너 중지
docker stop ppomppu

# 컨테이너 시작
docker start ppomppu

# 컨테이너 제거
docker rm -f ppomppu
```

### 내부 접속
```bash
# bash 쉘 접속
docker exec -it ppomppu bash

# PHP 버전 확인
docker exec ppomppu php -v

# 로드된 모듈 확인
docker exec ppomppu php -m

# phpinfo 확인
docker exec ppomppu php -i
```

### 파일 관리
```bash
# 호스트 → 컨테이너
docker cp ./file.php ppomppu:/var/www/html/

# 컨테이너 → 호스트
docker cp ppomppu:/var/www/html/file.php ./

# 권한 변경
docker exec ppomppu chown -R web_user:web_user /var/www/html/
```

### 포트 변경
```bash
# 다른 포트로 실행
docker run -d -p 8080:80 -p 8443:443 --name ppomppu ppomppu:latest

# 접속: http://localhost:8080
```

---

## 🔧 설정

### Apache 설정
```bash
# 설정 파일
docker exec ppomppu cat /etc/httpd/conf/httpd.conf

# 수정 및 재시작
docker exec ppomppu nano /etc/httpd/conf/httpd.conf
docker exec ppomppu /usr/sbin/httpd -k graceful
```

### PHP 설정
```bash
# 설정 파일
docker exec ppomppu cat /etc/php.ini

# PHP 확장 설정
docker exec ppomppu ls -la /etc/php.d/
```

### 웹 루트
```bash
# 기본 웹 루트: /var/www/html/
docker exec ppomppu ls -la /var/www/html/

# 파일 업로드
docker cp ./index.html ppomppu:/var/www/html/
```

---

## 🧪 테스트

### PHP 테스트
```bash
# phpinfo 페이지 생성
docker exec ppomppu bash -c 'echo "<?php phpinfo(); ?>" > /var/www/html/info.php'

# 브라우저에서 접속
# http://localhost/info.php
```

### Apache 테스트
```bash
# 접속 확인
curl http://localhost

# HTTPS 확인
curl -k https://localhost

# 상태 코드 확인
curl -I http://localhost
```

### 암호화 모듈 테스트
```bash
docker exec ppomppu php -r "
if (extension_loaded('encrypt_keys_php')) {
    echo 'encrypt_keys_php: OK\n';
}
"
```

---

## 🆘 문제 해결

### Docker가 실행되지 않음
**해결**: Docker Desktop을 시작하세요.

### 포트 이미 사용 중
```bash
# 기존 컨테이너 확인
docker ps -a | grep ppomppu

# 제거
docker rm -f ppomppu

# 다른 포트로 실행
docker run -d -p 8080:80 ppomppu:latest
```

### Apache 시작 실패
```bash
# 로그 확인
docker logs ppomppu

# foreground 실행은 정상입니다
# systemctl 사용 불가 (Docker 특성)
```

### PHP 모듈 로드 실패
```bash
# 모듈 확인
docker exec ppomppu php -m | grep [모듈명]

# 설정 파일 확인
docker exec ppomppu cat /etc/php.d/[모듈].ini

# 에러 로그 확인
docker exec ppomppu tail -50 /var/log/httpd/error_log
```

더 자세한 문제 해결: [INSTALLATION.md#문제-해결](docs/INSTALLATION.md#문제-해결)

---

## 📊 성능 모니터링

### 리소스 사용량
```bash
# CPU, 메모리 확인
docker stats ppomppu

# 프로세스 확인
docker exec ppomppu top -b -n 1

# 포트 확인
docker exec ppomppu ss -tlnp
```

---

## 🛠 개발 환경 설정

### 소스 코드 연동
```bash
# 호스트의 소스를 컨테이너로 마운트 (권장)
docker run -d \
  -p 80:80 \
  -p 443:443 \
  -v /path/to/source:/var/www/html \
  --name ppomppu \
  ppomppu:latest
```

### 데이터베이스 연결
```bash
# 컨테이너 내 MySQL 클라이언트 테스트
docker exec ppomppu mysql -h [host] -u [user] -p[pass] -D [db]
```

### 로그 모니터링
```bash
# Apache 에러 로그
docker exec ppomppu tail -f /var/log/httpd/error_log

# Apache 접속 로그
docker exec ppomppu tail -f /var/log/httpd/access_log
```

---

## 📖 기존 문서

원본 CentOS 7 수동 설치 가이드:
- `docs/centos7_install/5.5 웹서버 설치` - 수동 설치 절차
- `docs/centos7_install/로컬세팅용 Docker 설치` - 로컬 환경 설정

---

## 🤝 기여

버그 리포트 및 기능 제안은 GitHub Issues에서 해주세요.

---

## 📝 라이선스

MIT License

---

## 📞 지원

- **GitHub Issues**: [이슈 보고](https://github.com/iloveaired9/ppomppu_docker/issues)
- **문제 해결**: [INSTALLATION.md](docs/INSTALLATION.md#문제-해결) 참조

---

## 🎓 학습 자료

- [Docker 공식 문서](https://docs.docker.com/)
- [PHP 5.5 매뉴얼](https://www.php.net/manual/en/index.php)
- [Apache 2.4 가이드](https://httpd.apache.org/docs/2.4/)
- [CentOS 7 문서](https://wiki.centos.org/FrontPage)

---

## 📋 체크리스트

Docker 환경 구축 완료 확인:

- [ ] Docker Desktop 설치 및 실행
- [ ] 이미지 빌드 완료 (`docker build -t ppomppu:latest .`)
- [ ] 컨테이너 실행 (`docker run -d ...`)
- [ ] 웹 서버 응답 확인 (`curl http://localhost`)
- [ ] PHP 동작 확인 (`docker exec ppomppu php -v`)
- [ ] phpinfo 페이지 확인 (`http://localhost/info.php`)
- [ ] encrypt 모듈 확인 (`docker exec ppomppu php -m | grep encrypt`)

---

**최종 업데이트**: 2026-04-02

**Happy Coding! 🎉**
