build-push:
	docker buildx build --platform linux/amd64,linux/arm64 -t zefhemel/postgresql-backup-s3 --push .
