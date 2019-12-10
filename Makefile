docker-build:
	docker build \
		-t spark \
		--rm \
		--force-rm=true \
		--build-arg SPARK_PORT=8080 \
		--build-arg SPARK_MONGO_CONNECTION_STRING=mongodb://mongo:27017 \
		--build-arg SPARK_MONGO_USE_SSL=false \
		.

docker-run: docker-start
docker-start:
	docker-compose up --detach
	# docker run -d \
	# 	-p 8080:8080 \
	# 	--network=spark_default  \
	# 	--name=spark_main \
	# 	spark

docker-stop:
	# docker stop spark_main || true
	# docker rm spark_main || true
	docker-compose down --volume