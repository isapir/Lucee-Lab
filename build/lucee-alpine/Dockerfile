ARG LUCEE_VERSION=5.3.10.97

ARG LUCEE_JAR_FILE="lucee-${LUCEE_VERSION}.jar"

ARG USER_ID=1000
ARG GROUP_ID=1000

ARG SERVER_WEBROOT=/srv/www/catalina-base/webapps/ROOT

# Allow to specify the Lucee Admin Password at build time with --build-arg LUCEE_ADMIN_PASSWORD=changeit
ARG LUCEE_ADMIN_PASSWORD=

# Install optional Lucee extensions in the comma separated format {extension-uuid};name=X;label=XY;version=m.n
#   e.g. "3F9DFF32-B555-449D-B0EB5DB723044045;name=WebSocket"
ARG LUCEE_EXTENSIONS=

# Pass JVM options when Tomcat starts, e.g. --build-arg CATALINA_OPTS="-Xmx2g"
ARG CATALINA_OPTS=


## downloads utils and creates /usr/local/src
FROM ghcr.io/isapir/alpine-builder AS builder
# FROM lucee-lab_alpine-builder AS builder

ARG LUCEE_VERSION
ARG LUCEE_JAR_FILE
ARG LUCEE_DOWNLOAD=http://release.lucee.org/rest/update/provider/loader/

RUN curl -sSL -o ${LUCEE_JAR_FILE} --create-dirs "${LUCEE_DOWNLOAD}${LUCEE_VERSION}" 

## This will always use the ghcr.io/isapir/tomcat-alpine:latest on GitHub. See README on how to update it.

FROM ghcr.io/isapir/tomcat-alpine AS tomcat-builder

ARG LUCEE_JAR_FILE
ARG LUCEE_ADMIN_PASSWORD
ARG LUCEE_EXTENSIONS
ARG CATALINA_OPTS
ARG SERVER_WEBROOT
ARG USER_ID
ARG GROUP_ID

ARG LUCEE_SERVER_DIR=${CATALINA_BASE}/lucee-server
ARG DIRS_TO_REMOVE=/srv/www/catalina-base/lucee-server/context/extensions/available/* /srv/www/catalina-home/apache-tomcat-9.0.70/webapps/*

ENV SERVER_WEBROOT=${SERVER_WEBROOT}
ENV LUCEE_EXTENSIONS=${LUCEE_EXTENSIONS}

COPY --chown=${USER_ID}:${GROUP_ID} ./resources/catalina-base ${CATALINA_BASE}

COPY --chown=${USER_ID}:${GROUP_ID} --from=builder /usr/local/src/${LUCEE_JAR_FILE} ${CATALINA_BASE}/lib

RUN echo "<cfoutput>Hello Lucee #Server.lucee.version# at #dateTimeFormat(now(), 'ISO8601')#</cfoutput>" > ${CATALINA_BASE}/webapps/ROOT/index.cfm \
    && echo "Enabled LUCEE_ENABLE_WARMUP" \
    && export LUCEE_ENABLE_WARMUP=true \
    &&  if [ -n "${LUCEE_EXTENSIONS}" ] ; then \
            echo "Adding LUCEE_EXTENSIONS: ${LUCEE_EXTENSIONS}" \
        ; fi \
    && export LUCEE_EXTENSIONS=${LUCEE_EXTENSIONS} \
    && ${CATALINA_HOME}/bin/catalina.sh run \
    && rm -rf ${DIRS_TO_REMOVE} \
    ## create password.txt file if password is set
    &&  if [ "$LUCEE_ADMIN_PASSWORD" != "" ] ; then \
            echo "Creating password file at ${LUCEE_SERVER_DIR}/context/password.txt" \
            && echo $LUCEE_ADMIN_PASSWORD > "${LUCEE_SERVER_DIR}/context/password.txt" \
        ; else \
            echo "You can set the Lucee Admin password at ${LUCEE_SERVER_DIR}/context/password.txt" \
        ; fi \
    && chmod g+srwX -R /srv/www


FROM ghcr.io/isapir/tomcat-alpine AS lucee

ARG SERVER_WEBROOT
ARG USER_ID
ARG GROUP_ID

## extensions were added in previous stage, but this lets us see it in stdout when Lucee starts
ARG LUCEE_EXTENSIONS
ENV LUCEE_EXTENSIONS=${LUCEE_EXTENSIONS}


ENV SERVER_WEBROOT=${SERVER_WEBROOT}

COPY --chown=${USER_ID}:${GROUP_ID} --from=tomcat-builder /srv/www /srv/www

USER ${USER_ID}:${GROUP_ID}
