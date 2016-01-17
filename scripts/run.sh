docker stop redis && docker rm redis
docker run -d \
	--name=redis \
	--net=voice_nw \
	redis:2.8.23

docker stop plivoframework && docker rm plivoframework
docker run \
	--name=plivoframework \
	--net=voice_nw \
	-p 8084:8084 \
	-p 8088:8088 \
	-p 8089:8089 \
	marconi/plivoframework:0.1.0
