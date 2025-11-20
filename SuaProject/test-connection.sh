#!/bin/bash

# ========================================
# MariaDB 연결 테스트 스크립트
# ========================================

echo "🔍 MariaDB 연결 테스트 (포트: 13306)"
echo "=================================="
echo ""

# 변수 설정
HOST="localhost"
PORT="13306"
DB="BP1901153"
USER="root"
PASS="1234"

# 1. MariaDB 포트 확인
echo "1️⃣  포트 13306 리스닝 확인..."
if lsof -i :13306 > /dev/null 2>&1; then
    echo "✅ 포트 13306이 열려있습니다."
else
    echo "❌ 포트 13306이 열려있지 않습니다."
    echo "   MariaDB가 실행 중인지 확인하세요."
    exit 1
fi
echo ""

# 2. MariaDB 연결 테스트
echo "2️⃣  MariaDB 연결 테스트..."
mysql -h $HOST -P $PORT -u $USER -p$PASS -e "SELECT VERSION();" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ MariaDB 연결 성공!"
else
    echo "❌ MariaDB 연결 실패!"
    echo "   - Host: $HOST"
    echo "   - Port: $PORT"
    echo "   - User: $USER"
    exit 1
fi
echo ""

# 3. 데이터베이스 존재 확인
echo "3️⃣  데이터베이스 '$DB' 확인..."
DB_EXISTS=$(mysql -h $HOST -P $PORT -u $USER -p$PASS -e "SHOW DATABASES LIKE '$DB';" 2>/dev/null | grep $DB)
if [ -n "$DB_EXISTS" ]; then
    echo "✅ 데이터베이스 '$DB' 존재합니다."
else
    echo "⚠️  데이터베이스 '$DB'가 없습니다."
    echo "   init.sql을 실행하여 생성하세요:"
    echo "   mysql -h $HOST -P $PORT -u $USER -p < database/init.sql"
    exit 1
fi
echo ""

# 4. 테이블 목록 확인
echo "4️⃣  테이블 목록..."
mysql -h $HOST -P $PORT -u $USER -p$PASS -D $DB -e "SHOW TABLES;" 2>/dev/null
echo ""

# 5. Java 프로젝트 빌드 (옵션)
read -p "Maven 빌드를 실행하시겠습니까? (y/n): " BUILD_CHOICE
if [ "$BUILD_CHOICE" = "y" ]; then
    echo ""
    echo "5️⃣  Maven 빌드 실행..."
    cd "$(dirname "$0")" || exit
    mvn clean package
    
    if [ $? -eq 0 ]; then
        echo "✅ 빌드 성공!"
        echo "   WAR 파일: target/SuaProject-0.0.1-SNAPSHOT.war"
    else
        echo "❌ 빌드 실패!"
        exit 1
    fi
fi

echo ""
echo "=================================="
echo "✅ 모든 테스트 완료!"
echo "=================================="
