ARG IMAGE=containers.intersystems.com/intersystems/iris-community:latest-cd
FROM $IMAGE

USER ${ISC_PACKAGE_MGRUSER}

ENV ISC_TEMP_DIR=/intersystems/iris/global

COPY FAQ/ $ISC_TEMP_DIR/
COPY TopicD.xml $ISC_TEMP_DIR
COPY iris.script /tmp
COPY $ISC_TEMP_DIR/python/embedding.py
USER root

RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} $ISC_TEMP_DIR/

USER ${ISC_PACKAGE_MGRUSER}

RUN python3 -m pip install --upgrade --target /usr/irissys/mgr/python flask
RUN python3 -m pip install --upgrade --target /usr/irissys/mgr/python　sentence_transformers
RUN python3 -m pip install --upgrade --target /usr/irissys/mgr/python langchain_text_splitters
RUN python3 /usr/irissys/mgr/python/embedding.py &

RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris.script \
    && iris stop IRIS quietly
