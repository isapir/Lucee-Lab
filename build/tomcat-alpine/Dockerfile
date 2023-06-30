ARG BASE_JAVA_IMAGE=azul/zulu-openjdk-alpine:11-jre-latest
ARG TOMCAT_VERSION=9.0.70

ARG TOMCAT_FILENAME="apache-tomcat-${TOMCAT_VERSION}"
ARG CATALINA_HOME_DIR=/srv/www/catalina-home
ARG CATALINA_HOME=${CATALINA_HOME_DIR}/${TOMCAT_FILENAME}
ARG CATALINA_BASE=/srv/www/catalina-base

ARG USER_ID=0
ARG GROUP_ID=1000


## 238MB
FROM ${BASE_JAVA_IMAGE} AS builder

## Inherit global args
ARG TOMCAT_VERSION
ARG TOMCAT_FILENAME
ARG CATALINA_HOME_DIR

ARG CATALINA_HOME
ARG CATALINA_BASE

ENV TOMCAT_FILENAME=${TOMCAT_FILENAME}
ENV CATALINA_HOME_DIR=${CATALINA_HOME_DIR}
ENV CATALINA_HOME=${CATALINA_HOME}
ENV CATALINA_BASE=${CATALINA_BASE}

RUN apk --update add bash curl vim \
    && env \
    && mkdir -p /usr/local/src ${CATALINA_HOME_DIR} \
    && cd /usr/local/src \
    && echo Downloading https://dlcdn.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/${TOMCAT_FILENAME}.tar.gz \
    && curl -sL https://dlcdn.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/${TOMCAT_FILENAME}.tar.gz | tar xz -C . \
    && mv /usr/local/src/${TOMCAT_FILENAME} ${CATALINA_HOME_DIR} \
    && ${CATALINA_HOME}/bin/makebase.sh ${CATALINA_BASE} \
    && echo "Hello Tomcat!" > ${CATALINA_BASE}/webapps/ROOT/index.html \
    && chmod g+srwX -R /srv/www


## 205MB
FROM ${BASE_JAVA_IMAGE} AS tomcat

## Inherit global args
ARG CATALINA_HOME
ARG CATALINA_BASE
ARG USER_ID
ARG GROUP_ID

ENV CATALINA_HOME=${CATALINA_HOME}
ENV CATALINA_BASE=${CATALINA_BASE}

COPY --chown=${USER_ID}:${GROUP_ID} --from=builder /srv/www /srv/www

RUN    addgroup --system --gid ${GROUP_ID} www \
    &&  if [[ ${USER_ID} -gt 0 ]] ; then \
            adduser  --system --uid ${USER_ID} www www \
        ; fi

## better to run the container with -u 1000:1000 ?
USER ${USER_ID}:${GROUP_ID}

EXPOSE 8080

## Use 'sh -c' so that env variables are resolved
CMD [ "sh", "-c", "${CATALINA_HOME}/bin/catalina.sh run" ]
