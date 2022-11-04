ARG IMAGE=containers.intersystems.com/intersystems/iris-community-arm64:2022.1.0.209.0
ARG IMAGE=containers.intersystems.com/intersystems/iris-community-arm64:2022.2.0.368.0
ARG IMAGE=containers.intersystems.com/intersystems/iris-community:2022.1.0.209.0
ARG IMAGE=containers.intersystems.com/intersystems/iris-community:2022.2.0.368.0
FROM $IMAGE

USER ${ISC_PACKAGE_MGRUSER}

ENV ISC_TEMP_DIR=/intersystems/iris/global

COPY FAQ/ $ISC_TEMP_DIR/
COPY TopicD.xml $ISC_TEMP_DIR
COPY iris.script /tmp

USER root

RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} $ISC_TEMP_DIR/

USER ${ISC_PACKAGE_MGRUSER}

RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris.script \
    && iris stop IRIS quietly
