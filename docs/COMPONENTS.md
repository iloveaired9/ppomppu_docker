# ppomppu Docker - 구성 요소 상세 가이드

## 📦 설치된 모든 구성 요소

---

## 🖥️ 운영체제 및 기본 서비스

### CentOS 7
- **버전**: 7 (최종 지원 버전)
- **특징**: 안정적이고 신뢰할 수 있는 서버 운영체제
- **리포지토리**: Vault 리포지토리 (EOL 지원)

**사용 이유**: 프로덕션 안정성과 장기 지원

---

## 🌐 웹 서버

### Apache HTTP Server 2.4.6
```bash
# 버전 확인
docker exec ppomppu httpd -v

# 설정 파일
/etc/httpd/conf/httpd.conf

# 시작 방법
docker exec ppomppu /usr/sbin/httpd -DFOREGROUND

# 포트
- HTTP: 80
- HTTPS: 443
```

**주요 모듈**:
- `mod_ssl`: SSL/TLS 암호화
- `mod_security`: WAF (Web Application Firewall)
- `mod_php5`: PHP 실행

**설정**:
```bash
# Apache 사용자 확인
docker exec ppomppu grep -E "^User|^Group" /etc/httpd/conf/httpd.conf
```

---

## 🐘 PHP 5.5.38

### 기본 정보
```bash
# 버전 확인
docker exec ppomppu php -v

# 설정 파일 위치
/etc/php.ini
/etc/php.d/

# 모듈 확인
docker exec ppomppu php -m
```

### 로드된 주요 확장 모듈

#### 1. 암호화 & 보안
```
- mcrypt          : MD5, DES, AES 암호화
- encrypt_keys_php: AES-128 고급 암호화
- openssl         : SSL/TLS 지원
```

#### 2. 이미지 처리
```
- gd              : 이미지 생성, 조작, 포맷 변환
- exif            : EXIF 메타데이터 읽기
```

#### 3. 데이터베이스
```
- mysql           : MySQL 라이브러리
- mysqli          : MySQL Improved (개선된 드라이버)
- pdo             : PDO (PHP Data Objects)
- pdo_mysql       : PDO MySQL 드라이버
- pdo_sqlite      : PDO SQLite 드라이버
```

#### 4. 캐싱
```
- redis           : Redis 클라이언트 (pecl-redis)
- memcache        : Memcache 프로토콜
- memcached       : Memcached 클라이언트
- opcache         : PHP 바이트코드 캐싱
```

#### 5. 문자열 & XML 처리
```
- mbstring        : 멀티바이트 문자열 (UTF-8 등)
- xml             : XML 파싱
- xmlreader       : XML 판독기
- xmlwriter       : XML 작성기
- xsl             : XSLT 변환
- wddx            : WDDX 직렬화
```

#### 6. 기타 모듈
```
- json            : JSON 인코딩/디코딩
- curl            : HTTP 클라이언트
- ftp             : FTP 클라이언트
- sockets         : 소켓 통신
- phar            : PHP Archive 지원
- zip             : ZIP 아카이브
- bz2             : Bzip2 압축
- zlib            : Gzip 압축
- fileinfo        : 파일 타입 감지
- gettext         : 국제화 (i18n)
```

### 비동기 작업

#### Gearman (Job Server)
```bash
# Gearman PHP 확장 로드 상태 확인
docker exec ppomppu php -m | grep gearman

# 포트: 내부 통신
```

**용도**:
- 백그라운드 작업 처리
- 대용량 데이터 처리
- 비동기 작업 큐

---

## 💾 캐시 & 메모리 서버

### Nutcracker (twemproxy) v0.4.1

**개요**: Redis 프록시 및 일관성 해싱(Consistent Hashing) 지원

```bash
# 포트
- 22222 (외부 인터페이스)
- 22121 (로컬 인터페이스, 127.0.0.1:22121)

# 설정 파일
/etc/nutcracker/nutcracker.yml

# 프로세스 확인
docker exec ppomppu ps aux | grep nutcracker

# 포트 확인
docker exec ppomppu ss -tlnp | grep 22
```

**기능**:
- Redis 클러스터링
- 자동 분산 (consistent hashing)
- 다중 Redis 인스턴스 관리
- 커넥션 풀링

**사용 사례**:
```bash
# Nutcracker를 통한 Redis 접속
# PHP 코드에서:
# $redis = new Redis();
# $redis->connect('127.0.0.1', 22121);
```

---

## 🖼️ 이미지 처리 라이브러리

### libwebp 1.3.2

**설명**: Google WebP 이미지 포맷 지원

```bash
# 설치 위치
/usr/local/bin/
/usr/lib64/libwebp.so.7

# 포함된 도구
- cwebp      : 이미지 → WebP 변환
- dwebp      : WebP → 이미지 변환
- webpmux    : WebP 메타데이터 조작
- webpinfo   : WebP 정보 확인
```

**사용 예**:
```bash
# PNG를 WebP로 변환
docker exec ppomppu cwebp input.png -o output.webp

# WebP 정보 확인
docker exec ppomppu webpinfo image.webp
```

**PHP에서 사용**:
```php
<?php
// GD 라이브러리를 통한 WebP 지원
$img = imagecreatefrompng('input.png');
imagewebp($img, 'output.webp', 80);
?>
```

### libjpeg-turbo 1.2.90

**설명**: JPEG 인코딩/디코딩 최적화 (고속 처리)

```bash
# 라이브러리 위치
/lib64/libjpeg.so.62
/lib64/libjpeg.so
```

**특징**:
- 기존 libjpeg보다 2-6배 빠름
- SIMD 최적화 (SSE2, AVX2)
- 호환성 유지

**PHP에서 사용**:
```php
<?php
// GD 라이브러리가 libjpeg-turbo 사용
$img = imagecreatefromjpeg('input.jpg');
imagejpeg($img, 'output.jpg', 90);
?>
```

### GD Library

**설명**: PHP 이미지 처리 라이브러리

```bash
# PHP 설정에서 확인
docker exec ppomppu php -i | grep -A 5 "GD Support"
```

**지원 포맷**:
- JPEG
- PNG
- GIF
- WebP (libwebp 연동)
- WBMP
- XBM

### libheif 1.12.0

**설명**: HEIF/HEIC 이미지 포맷 지원 (Apple, Google 최신 표준)

```bash
# 설치 위치
/usr/local/lib/libheif.so.1.12.0
/usr/local/lib/libx265.so.192 (의존성)

# 포함된 유틸리티
/usr/local/bin/heif-convert    # HEIF ↔ 다른 포맷 변환
/usr/local/bin/heif-enc        # HEIF 인코더
/usr/local/bin/heif-info       # HEIF 정보 조회
/usr/local/bin/heif-thumbnailer # 썸네일 생성
```

**사용 예**:
```bash
# JPEG를 HEIF로 변환
heif-convert input.jpg output.heic

# HEIF 정보 확인
heif-info image.heic

# HEIF를 PNG로 변환
heif-convert image.heic output.png
```

**특징**:
- Apple iOS/macOS 표준 포맷
- 높은 압축률 (JPEG 대비 50% 용량 감소)
- 메타데이터 지원

### x265 3.4

**설명**: HEVC/H.265 비디오 코덱 (차세대 비디오 표준)

```bash
# 바이너리 위치
/usr/local/bin/x265

# 라이브러리
/usr/local/lib/libx265.so.192
```

**용도**:
- 고효율 비디오 인코딩
- 4K 비디오 처리
- 스트리밍 최적화

**명령어**:
```bash
# 비디오 인코딩
x265 input.yuv -o output.h265

# 품질 설정 (0-51, 낮을수록 높은 품질)
x265 input.yuv -o output.h265 -q 28
```

### libde265 1.0.8

**설명**: HEVC/H.265 비디오 디코더

```bash
# 설치 위치
/usr/local/lib/pkgconfig/libde265.pc
```

**역할**:
- HEIF/HEIC 이미지 디코딩 (libheif의 의존성)
- HEVC 비디오 재생

---

## 🎬 멀티미디어 처리

### FFmpeg 4.4.2

**설명**: 비디오/오디오 인코딩, 디코딩, 스트리밍 도구

```bash
# 실행 경로
/usr/local/sbin/ffmpeg

# 버전 확인
docker exec ppomppu /usr/local/sbin/ffmpeg -version

# 지원 코덱 확인
docker exec ppomppu /usr/local/sbin/ffmpeg -codecs | head -30
```

**포함된 기능**:
- 비디오 인코딩/디코딩
- 오디오 처리
- 형식 변환 (MP4, WebM, MKV 등)
- 스트림 처리
- GPL 코덱 지원

**사용 예**:
```bash
# 비디오 형식 변환
ffmpeg -i input.mp4 -c:v libx264 output.mp4

# 영상 추출
ffmpeg -i video.mp4 -vf fps=1 frame_%04d.jpg

# 오디오 추출
ffmpeg -i video.mp4 -q:a 0 -map a audio.mp3
```

---

## 🔐 암호화 모듈

### mcrypt (PHP 내장)

**설명**: 암호화 라이브러리

```bash
# 지원 알고리즘
docker exec ppomppu php -r "
echo 'Supported Ciphers: ' . count(mcrypt_list_algorithms()) . '\n';
print_r(mcrypt_list_algorithms());
"
```

**지원 암호화**:
- DES, 3DES
- Rijndael (AES)
- Twofish
- Blowfish
등 30+ 알고리즘

### encrypt_keys_php (커스텀 모듈)

**설명**: AES-128 암호화 PHP 확장

```bash
# 모듈 확인
docker exec ppomppu php -m | grep encrypt_keys_php

# 설정 파일
/etc/php.d/encrypt_keys_php.ini

# 모듈 위치
/usr/lib64/php/modules/encrypt_keys_php.so
```

**기능**:
- AES-128 암호화/복호화
- 높은 성능 (C 구현)
- 안전한 암호 운영

**사용 예**:
```php
<?php
// encrypt_keys_php 사용
$encrypted = encrypt_key($data, $key);
$decrypted = decrypt_key($encrypted, $key);
?>
```

---

## 🛠️ 개발 도구

### 빌드 시스템
```
- gcc           : C 컴파일러
- make          : 빌드 자동화
- automake      : Makefile 생성기
- autoconf      : 설정 스크립트 생성
- libtool       : 라이브러리 빌드
```

### 다운로드/네트워크
```
- wget          : 파일 다운로드
- curl          : HTTP 클라이언트
- openssh       : SSH (설치는 제거됨)
```

### 시스템 도구
```
- tar           : 아카이브 생성/추출
- rsync         : 파일 동기화
- net-snmp      : SNMP 모니터링
```

---

## 📊 모니터링 도구

### MRTG (Multi Router Traffic Grapher)
```bash
# 네트워크 트래픽 모니터링
docker exec ppomppu which mrtg
```

### 시스템 도구
```bash
# 프로세스 확인
docker exec ppomppu ps aux

# 메모리 사용
docker exec ppomppu free -h

# 디스크 사용
docker exec ppomppu df -h

# 네트워크 상태
docker exec ppomppu ss -tlnp
```

---

## 📂 설정 및 로그 위치

### 주요 설정 파일
```
Apache
  /etc/httpd/conf/httpd.conf          - Apache 메인 설정
  /etc/httpd/conf.d/                  - 추가 설정 파일

PHP
  /etc/php.ini                        - PHP 메인 설정
  /etc/php.d/                         - PHP 확장 설정

Nutcracker
  /etc/nutcracker/nutcracker.yml      - Nutcracker 설정
```

### 로그 위치
```
Apache
  /var/log/httpd/access_log           - 접속 로그
  /var/log/httpd/error_log            - 에러 로그
  /home/logs/apache/                  - 추가 로그 (커스텀)

Application
  /home/webadmin/logs/                - 애플리케이션 로그
  /home/session/                      - 세션 데이터
```

---

## 👤 사용자 및 권한

### 시스템 사용자
```
web_user        - 웹 서버 및 PHP 실행 사용자
webadmin        - 애플리케이션 소유자
root            - 관리자 (시작 시에만)
```

### 디렉토리 권한
```
/var/www/html/                  755 (webadmin:webadmin)
/home/webadmin/                 755 (webadmin:webadmin)
/home/logs/apache/              web_user:web_user
/home/session/                  web_user:web_user
```

---

## 🔗 의존성 관계

```
Apache 2.4.6
  ├── mod_ssl (SSL/TLS)
  ├── mod_security (WAF)
  └── mod_php5
      └── PHP 5.5.38
          ├── libwebp 1.3.2
          ├── libjpeg-turbo 1.2.90
          ├── libheif 1.12.0
          │   ├── libde265 1.0.8
          │   └── x265 3.4
          ├── mcrypt
          ├── encrypt_keys_php
          ├── mysqli (MySQL)
          ├── redis (pecl)
          ├── memcache(d)
          ├── gearman (pecl)
          └── ... [기타 30+ 모듈]

Nutcracker 0.4.1
  └── [Redis 클러스터 관리]

FFmpeg 4.4.2
  ├── libx265 (HEVC 인코딩)
  ├── libvpx (VP8/VP9)
  ├── libwebp (WebP)
  └── ... [GPL 코덱]

GD Library
  ├── libpng
  ├── libjpeg-turbo
  ├── libwebp
  ├── freetype
  └── ... [이미지 포맷 지원]

멀티미디어 처리
  ├── libheif 1.12.0 (HEIF/HEIC)
  │   ├── x265 3.4 (HEVC 인코더)
  │   └── libde265 1.0.8 (HEVC 디코더)
  ├── libwebp 1.3.2 (WebP)
  └── FFmpeg 4.4.2 (멀티미디어 변환)
```

---

## 💡 버전 선택 이유

### PHP 5.5 (레거시)
- ✅ 안정성 입증된 버전
- ✅ 기존 코드베이스와 호환
- ✅ 필요한 모든 확장 라이브러리 지원
- ⚠️ 2016년 EOL (보안 업데이트 중단)

### CentOS 7
- ✅ 2024년 6월까지 지원
- ✅ RHEL 호환 (프로덕션 환경)
- ✅ Vault 리포지토리로 계속 사용 가능

### Apache 2.4.6
- ✅ CentOS 7 표준 버전
- ✅ 충분한 성능
- ✅ 모든 필요한 모듈 지원

---

## 🚀 성능 최적화

### 캐싱
```
- opcache: PHP 바이트코드 캐싱
- Redis + Nutcracker: 분산 캐시
- Memcache: 추가 캐시 계층
```

### 이미지 처리
```
- libjpeg-turbo: JPEG 고속 처리
- libwebp: 최신 포맷 지원
- GD: 동적 이미지 생성
```

### 비동기 처리
```
- Gearman: 백그라운드 작업
- Redis: 작업 큐
```

---

## 📖 추가 정보

각 구성 요소의 공식 문서:
- [Apache 2.4](https://httpd.apache.org/docs/2.4/)
- [PHP 5.5](https://www.php.net/manual/en/index.php)
- [Nutcracker](https://github.com/twitter/twemproxy)
- [libwebp](https://developers.google.com/speed/webp/)

---

**업데이트**: 2026-04-02
