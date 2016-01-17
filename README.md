# Plivo Framework Container

The image is designed to be used against a [Freeswitch](https://hub.docker.com/r/bettervoice/freeswitch-container/) and [Redis](https://hub.docker.com/_/redis/) containers. Freesiwtch is where the actual magic happens and Redis as [Plivo](https://github.com/plivo/plivoframework)'s cache.

When the container runs, it starts `plivo-rest`, `plivo-outbound` and `plivo-cache` automatically. And you can pass the following envars which will be set with their corresponding config:

- `AUTH_ID`
- `AUTH_TOKEN`
- `REDIS_PASSWORD`

If you need more control over configuration, its recommended to just mount your whole config folder from your host to the container like:

```
docker run -v /path/to/conf:/usr/local/plivo/etc/plivo ...
```

The base configuration that the container uses can be found on this repo as well.

### Usage

1. Create a docker network:

	```
	docker network create --driver bridge voice_nw
	```

2. Run Freeswitch:

	```
	docker run \
		--name=freeswitch \
		--net=voice_nw \
		-p 5060:5060/tcp \
		-p 5060:5060/udp \
		-p 5080:5080/tcp \
		-p 5080:5080/udp \
		-p 8021:8021/tcp \
		-p 7443:7443/tcp \
		-p 60535-65535:60535-65535/udp \
		-v "$(pwd)/conf:/usr/local/freeswitch/conf" bettervoice/freeswitch-container:1.6.5
	```

3. Run Redis:

	```
	docker run -d \
		--name=redis \
		--net=voice_nw \
		redis:2.8.23
	```

4. Finally, run Plivo:

	```
	docker run \
		--name=plivoframework \
		--net=voice_nw \
		-p 8084:8084 \
		-p 8088:8088 \
		-p 8089:8089 \
		marconi/plivoframework:0.1.0
	```
