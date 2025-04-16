#!/bin/bash
echo "Adoptium OpenJDK 설치 시작..."

# 사용자 홈 디렉토리에 Java 설치
JAVA_DIR="$HOME/java"
mkdir -p $JAVA_DIR

# Adoptium OpenJDK 11 다운로드 및 설치
ADOPTIUM_URL="https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.18%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.18_10.tar.gz"
echo "OpenJDK 다운로드 중..."
wget -q $ADOPTIUM_URL -O /tmp/openjdk.tar.gz

echo "OpenJDK 압축 해제 중..."
tar -xzf /tmp/openjdk.tar.gz -C $JAVA_DIR
JAVA_HOME=$(find $JAVA_DIR -type d -name "jdk-11*" | head -n 1)

# 환경 변수 설정
echo "환경 변수 설정 중..."
if [ -n "$JAVA_HOME" ]; then
    export JAVA_HOME=$JAVA_HOME
    export PATH=$JAVA_HOME/bin:$PATH
    export LD_LIBRARY_PATH=$JAVA_HOME/lib:$JAVA_HOME/lib/server:$LD_LIBRARY_PATH

    # Java 설치 확인
    echo "Java 버전 확인:"
    java -version

    # JVM 라이브러리 찾기
    echo "libjvm.so 경로 확인:"
    LIBJVM_PATH=$(find $JAVA_HOME -name "libjvm.so" | head -n 1)
    echo "Found libjvm.so at: $LIBJVM_PATH"
else
    echo "Java 설치 실패: JAVA_HOME을 찾을 수 없습니다."
fi

# 애플리케이션 실행
echo "애플리케이션 시작..."
exec gunicorn app:app --timeout 120 --workers 1 --threads 2