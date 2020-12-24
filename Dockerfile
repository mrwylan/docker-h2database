FROM alpine as downloader

ARG RELEASE_DATE
ENV RELEASE_DATE=${RELEASE_DATE:-2019-10-14}

WORKDIR /tmp

RUN wget -O ./h2.zip https://www.h2database.com/h2-$RELEASE_DATE.zip  \
    && unzip h2.zip -d ./

FROM adoptopenjdk/openjdk11:alpine-jre

ENV H2_DATA /h2-data
ENV H2_USER h2
ENV H2_GID 5000
ENV H2_UID 5000
ENV JAVA_OPTS "-Xms512m -Xmx1G"
ENV JAVA_OPTS_JMX "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.rmi.port=9010 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=host.docker.internal"


RUN addgroup -g ${H2_GID} ${H2_USER} \
    && adduser --disabled-password \
            --home /home/${H2_USER} \
            --gecos "" \
            --uid ${H2_UID} \
            --ingroup ${H2_USER} \
            --shell /bin/sh \
            --no-create-home \
              ${H2_USER}

WORKDIR /h2
COPY --from=downloader  /tmp/h2/bin ./bin
RUN ln -s $(ls /h2/bin/*jar) /h2/bin/h2.jar \
    && chown -R ${H2_USER}:${H2_USER} ./* \
    && mkdir -p ${H2_DATA} \
    && chown -R ${H2_USER}:${H2_USER} ${H2_DATA}

USER h2

VOLUME ${H2_DATA}

EXPOSE 8082 9010 9092 

CMD java ${JAVA_OPTS} ${JAVA_OPTS_JMX} \
  -cp /h2/bin/h2.jar org.h2.tools.Server \
  -web -webAllowOthers -tcp -tcpAllowOthers -ifNotExists -baseDir ${H2_DATA}