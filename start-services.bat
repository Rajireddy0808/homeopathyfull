@echo off
echo Starting HIMS Microservices...

echo Starting Settings Service on port 3002...
start "Settings Service" cmd /k "cd /d backend\settings-service && npm run start:dev"

timeout /t 3

echo Starting Front Office Service on port 3003...
start "Front Office Service" cmd /k "cd /d backend\front-office-service && npm run start:dev"

timeout /t 3

echo Starting Frontend on port 3000...
start "Frontend" cmd /k "cd /d frontend && npm run dev"

echo All services started!
pause