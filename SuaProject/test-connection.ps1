# MariaDB 연결 테스트 스크립트 (Windows)

Write-Host "🔍 MariaDB 연결 테스트 (포트: 13306)" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# 변수 설정
$HOST = "localhost"
$PORT = "13306"
$DB = "BP1901153"
$USER = "root"
$PASS = "1234"

# 1. 포트 확인
Write-Host "1️⃣  포트 13306 리스닝 확인..." -ForegroundColor Yellow
$portCheck = Get-NetTCPConnection -LocalPort 13306 -ErrorAction SilentlyContinue
if ($portCheck) {
    Write-Host "✅ 포트 13306이 열려있습니다." -ForegroundColor Green
} else {
    Write-Host "❌ 포트 13306이 열려있지 않습니다." -ForegroundColor Red
    Write-Host "   MariaDB가 실행 중인지 확인하세요." -ForegroundColor Red
    exit 1
}
Write-Host ""

# 2. MySQL 클라이언트 확인
Write-Host "2️⃣  MySQL 클라이언트 확인..." -ForegroundColor Yellow
$mysqlPath = (Get-Command mysql -ErrorAction SilentlyContinue).Source
if ($mysqlPath) {
    Write-Host "✅ MySQL 클라이언트 발견: $mysqlPath" -ForegroundColor Green
} else {
    Write-Host "⚠️  MySQL 클라이언트를 찾을 수 없습니다." -ForegroundColor Yellow
    Write-Host "   MariaDB/MySQL이 PATH에 등록되어 있는지 확인하세요." -ForegroundColor Yellow
}
Write-Host ""

# 3. Java 프로젝트 빌드 테스트
Write-Host "3️⃣  Maven 빌드 테스트..." -ForegroundColor Yellow
$choice = Read-Host "Maven 빌드를 실행하시겠습니까? (y/n)"
if ($choice -eq "y") {
    Set-Location $PSScriptRoot
    mvn clean package
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ 빌드 성공!" -ForegroundColor Green
        Write-Host "   WAR 파일: target\SuaProject-0.0.1-SNAPSHOT.war" -ForegroundColor Green
    } else {
        Write-Host "❌ 빌드 실패!" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "✅ 테스트 완료!" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Cyan
