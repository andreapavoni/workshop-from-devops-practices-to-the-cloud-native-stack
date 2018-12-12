
build-logic:
	docker build -t sentiment logic
run-logic:
	docker run -d --name sentiment -p 5000:5000 sentiment
test-logic:
	http localhost:5000/analyse/sentiment sentence="ok"
build:
	docker-compose build
run:
	docker-compose -d run
