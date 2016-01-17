FROM ubuntu:14.04
MAINTAINER Marconi Moreto Jr. <me@marconijr.com>

RUN apt-get update && \
	apt-get install -y wget && \
	wget --no-check-certificate https://github.com/plivo/plivoframework/raw/master/scripts/plivo_install.sh && \
	bash plivo_install.sh /usr/local/plivo

EXPOSE 8084 8088 8089

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

CMD /usr/local/plivo/bin/plivo start && \
	/usr/local/plivo/bin/plivo-cache -d -c /usr/local/plivo/etc/plivo/cache/cache.conf && \
	tail -f /usr/local/plivo/tmp/plivo-rest.log \
		 -f /usr/local/plivo/tmp/plivo-outbound.log
