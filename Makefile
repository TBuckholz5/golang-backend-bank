postgres:
	docker run --name bankpostgres --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:alpine
createdb:
	docker exec -it bankpostgres createdb --username=root --owner=root bankpostgres

dropdb:
	docker exec -it bankpostgres dropdb bankpostgres

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/bankpostgres?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/bankpostgres?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/bankpostgres?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/bankpostgres?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go  github.com/TBuckholz5/golang-backend-bank/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server mock migrateup1 migrateup2
