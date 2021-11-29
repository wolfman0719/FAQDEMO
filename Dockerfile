ARG IMAGE=store/intersystems/iris-community-arm64:2020.4.0.547.0
ARG IMAGE=store/intersystems/iris-community-arm64:2021.1.0.215.3
ARG IMAGE=intersystemsdc/iris-community:2020.3.0.221.0-zpm
ARG IMAGE=intersystemsdc/iris-community:2020.4.0.547.0-zpm
ARG IMAGE=store/intersystems/iris-community:2020.4.0.547.0
ARG IMAGE=store/intersystems/iris-community:2021.1.0.215.3
FROM $IMAGE

USER ${ISC_PACKAGE_MGRUSER}

ENV ISC_TEMP_DIR=/intersystems/iris/global
COPY FAQ/ $ISC_TEMP_DIR/
COPY TopicD.xml $ISC_TEMP_DIR
COPY iris.script /tmp

RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris.script \
    && iris stop IRIS quietly

USER root

RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} $ISC_TEMP_DIR/
