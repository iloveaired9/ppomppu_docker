# ppomppu Docker 설치 가이드

## 📋 개요

이 문서는 ppomppu 프로젝트를 Docker 컨테이너로 실행하기 위한 전체 설치 및 사용 방법을 설명합니다.

## ✅ 필수 요구사항

### 시스템 요구사항
- **OS**: Windows 11, macOS, 또는 Linux
- **Docker Desktop**: 최신 버전 설치
  - Windows/Mac: [Docker Desktop 다운로드](https://www.docker.com/products/docker-desktop)
  - Linux: Docker Engine 설치

### 최소 사양
- **CPU**: 2 코어 이상
- **RAM**: 2GB 이상 (권장 4GB)
- **디스크**: 2GB 이상 (이미지 크기 약 1.77GB)

## 🚀 빠른 시작

### 1단계: Docker Desktop 실행
Docker Desktop 앱을 시작하세요. Windows/Mac에서는 시스템 트레이에서 실행할 수 있습니다.

### 2단계: 이미지 빌드
```bash
cd ppomppu_docker
docker build -t ppomppu:latest .
```

### 3단계: 컨테이너 실행
```bash
docker run -d -p 80:80 -p 443:443 --name ppomppu ppomppu:latest
```

### 4단계: 서비스 확인
```bash
# 컨테이너 상태 확인
docker ps

# 웹 서버 응답 확인
curl http://localhost
```

## 📦 설치된 구성 요소

### 기본 환경
| 컴포넌트 | 버전 | 설명 |
|---------|------|------|
| **OS** | CentOS 7 | 안정적인 서버용 운영체제 |
| **Apache** | 2.4.6 | HTTP/HTTPS 웹 서버 |
| **PHP** | 5.5.38 | PHP 스크립트 언어 |

### 데이터베이스 & 캐시
| 컴포넌트 | 설명 |
|---------|------|
| **Nutcracker (twemproxy)** | Redis 프록시 서버 |
| **Redis PHP Extension** | Redis 연결 (55-php-pecl-redis) |
| **Memcache** | 캐시 메모리 (memcache, memcached) |

### 멀티미디어 처리
| 라이브러리 | 버전 | 설명 |
|-----------|------|------|
| **libwebp** | 1.3.2 | WebP 이미지 포맷 지원 |
| **libjpeg-turbo** | 1.2.90 | JPEG 최적화 (고속 압축) |
| **libheif** | 1.12.0 | HEIF/HEIC 이미지 포맷 지원 |
| **x265** | 3.4 | HEVC/H.265 비디오 인코더 |
| **libde265** | 1.0.8 | HEVC 비디오 디코더 |
| **FFmpeg** | 4.4.2 | 멀티미디어 처리 및 변환 |
| **GD Library** | - | 이미지 생성/조작 |

### PHP 확장 모듈
| 모듈 | 설명 |
|-----|------|
| **mcrypt** | 암호화 (MD5, AES 등) |
| **encrypt_keys_php** | AES-128 암호화 모듈 |
| **gearman** | 비동기 작업 큐 (job server) |
| **opcache** | PHP 바이트코드 캐싱 |
| **mbstring** | 멀티바이트 문자열 처리 |
| **mysql/mysqli** | MySQL 데이터베이스 |
| **pdo** | 데이터베이스 추상화 레이어 |
| **xml/xsl** | XML/XSLT 처리 |

### 개발/운영 도구
| 도구 | 설명 |
|-----|------|
| **gcc/make** | C 컴파일러 및 빌드 도구 |
| **autoconf/automake** | 자동 빌드 시스템 |
| **wget** | 파일 다운로드 |
| **curl** | HTTP 클라이언트 |
| **openssl** | SSL/TLS 암호화 |

## 🔧 컨테이너 사용법

### 로그 확인
```bash
# 실시간 로그 확인
docker logs -f ppomppu

# 에러 로그 확인
docker exec ppomppu tail -f /var/log/httpd/error_log
```

### 컨테이너 내부 접속
```bash
# bash 쉘 접속
docker exec -it ppomppu bash

# 컨테이너 내부에서 PHP 실행
docker exec ppomppu php -v

# PHP 로드된 모듈 확인
docker exec ppomppu php -m
```

### 파일 복사
```bash
# 호스트에서 컨테이너로 파일 복사
docker cp myfile.php ppomppu:/var/www/html/

# 컨테이너에서 호스트로 파일 복사
docker cp ppomppu:/var/www/html/index.php ./
```

### 포트 매핑 변경
다른 포트로 실행하려면:
```bash
docker run -d -p 8080:80 -p 8443:443 --name ppomppu ppomppu:latest
# 접속: http://localhost:8080
```

## 🌐 웹 서비스 테스트

### phpinfo 확인
1. 컨테이너 내에서 info.php 생성:
```bash
docker exec ppomppu bash -c 'echo "<?php phpinfo(); ?>" > /var/www/html/info.php'
```

2. 브라우저에서 접속:
```
http://localhost/info.php
```

### Apache 상태 확인
```bash
# 실행 중인 프로세스 확인
docker exec ppomppu ps aux | grep -E "httpd|nutcracker"

# 열린 포트 확인
docker exec ppomppu ss -tlnp
```

## 📝 PHP 설정

### PHP 설정 파일 위치
- **메인 설정**: `/etc/php.ini`
- **추가 설정**: `/etc/php.d/*.ini`
- **Apache 모듈 설정**: `/etc/httpd/conf/httpd.conf`

### 모듈 활성화/비활성화
```bash
# encrypt 모듈 설정 파일
docker exec ppomppu cat /etc/php.d/encrypt_keys_php.ini

# 모듈 비활성화 (파일명 변경)
docker exec ppomppu mv /etc/php.d/encrypt_keys_php.ini /etc/php.d/encrypt_keys_php.ini.disabled
```

## 🔐 보안 설정

### Apache 사용자
- **사용자**: `web_user`
- **그룹**: `web_user`
- **설정 파일**: `/etc/httpd/conf/httpd.conf`

### SSL/TLS
- **포트**: 443 (HTTPS)
- **인증서 위치**: `/home/webadmin/ssl/` (기본값)
- **설정**: `/etc/httpd/conf/httpd.conf`에서 수정 필요

## 📂 디렉토리 구조

### 주요 경로
```
/var/www/html/              - 웹 문서 루트
/home/webadmin/             - 애플리케이션 디렉토리
/home/webadmin/logs/        - 애플리케이션 로그
/home/logs/apache/          - Apache 로그
/home/session/              - 세션 데이터
/etc/nutcracker/            - Nutcracker 설정
/usr/local/bin/             - 커스텀 바이너리 (libwebp 도구)
```

### 권한 설정
```bash
# 웹 루트 권한 확인
docker exec ppomppu ls -la /var/www/html/

# 웹 페이지 업로드/수정
docker exec ppomppu chown -R web_user:web_user /var/www/html/
docker exec ppomppu chmod 755 /var/www/html/
```

## 🛠 문제 해결

### 1. Docker 데몬이 실행되지 않음
```
Error: Cannot connect to Docker daemon
```
**해결**: Docker Desktop 애플리케이션 실행

### 2. 포트 이미 사용 중
```
Error: bind: address already in use
```
**해결**:
```bash
# 충돌 확인
docker ps -a | grep ppomppu

# 기존 컨테이너 제거
docker rm ppomppu

# 다른 포트로 실행
docker run -d -p 8080:80 ppomppu:latest
```

### 3. Apache 서비스 시작 실패
```
Failed to get D-Bus connection
```
**해결**: 정상 동작입니다. Docker 컨테이너에서는 systemd 사용 불가. start.sh에서 foreground로 실행됨.

### 4. 파일 권한 오류
```bash
# web_user 권한으로 변경
docker exec ppomppu chown -R web_user:web_user /var/www/html/
docker exec ppomppu chmod -R 755 /var/www/html/
```

### 5. PHP 모듈 로드 실패
```bash
# 모듈 확인
docker exec ppomppu php -m | grep encrypt_keys_php

# 설정 파일 확인
docker exec ppomppu cat /etc/php.d/encrypt_keys_php.ini

# PHP 에러 로그 확인
docker exec ppomppu tail -50 /var/log/httpd/error_log
```

## 🔄 컨테이너 관리

### 컨테이너 중지/시작
```bash
# 중지
docker stop ppomppu

# 시작
docker start ppomppu

# 재시작
docker restart ppomppu
```

### 컨테이너 제거
```bash
# 중지 후 제거
docker stop ppomppu
docker rm ppomppu
```

### 이미지 관리
```bash
# 빌드된 이미지 확인
docker images | grep ppomppu

# 이미지 제거
docker rmi ppomppu:latest
```

## 📊 성능 모니터링

### 리소스 사용량 확인
```bash
# CPU, 메모리 사용량
docker stats ppomppu

# 프로세스 확인
docker exec ppomppu top -b -n 1
```

### 네트워크 확인
```bash
# 포트 상태
docker exec ppomppu netstat -tlnp

# 프로세스별 포트 사용
docker exec ppomppu ss -tlnp
```

## 📚 추가 참고자료

### 기존 설치 문서
- `docs/centos7_install/5.5 웹서버 설치` - CentOS 7 수동 설치 가이드
- `docs/centos7_install/로컬세팅용 Docker 설치` - 로컬 개발 환경 설정

### 외부 문서
- [Docker 공식 문서](https://docs.docker.com/)
- [PHP 5.5 문서](https://www.php.net/manual/en/index.php)
- [Apache 2.4 문서](https://httpd.apache.org/docs/2.4/)
- [CentOS 7 문서](https://wiki.centos.org/FrontPage)

## 🤝 지원

문제 발생 시:
1. 로그 확인: `docker logs ppomppu`
2. 컨테이너 상태 확인: `docker ps -a`
3. GitHub Issues에 보고

## 📝 버전 정보

- **Dockerfile 버전**: Latest
- **CentOS 버전**: 7
- **PHP 버전**: 5.5.38
- **Apache 버전**: 2.4.6
- **마지막 업데이트**: 2026-04-02

---

**Happy Coding! 🎉**
