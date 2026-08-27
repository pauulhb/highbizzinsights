# Run Local / UAT

## 1. Start backend and PostgreSQL
Install Docker Desktop, then from the project root run:

docker compose up

API:
http://localhost:8080

Health check:
GET http://localhost:8080/health

## 2. Demo login
Employee Code: KAM001
Password: demo123

The seed account is intended only for local/UAT testing.

## 3. Android emulator
The mobile default API URL is:
http://10.0.2.2:8080/v1

For a physical Android/iPhone device, run with your computer's LAN IP:

flutter run --dart-define=API_BASE_URL=http://192.168.x.x:8080/v1

## 4. Production
Before production:
- replace JWT secret
- use managed PostgreSQL
- use HTTPS
- disable demo seed
- configure secrets manager
- configure iOS/Android location permissions
- add refresh tokens / session revocation
- add rate limits
- add structured logs
- add backup and monitoring
