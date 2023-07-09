## image size 1.36GB
FROM alpine AS nginx-builder

ARG NGINX_VERSION=1.25.1
ARG NGINX_OPENSSL_VERSION=3.1.1
ARG NGINX_ZLIB_VERSION=1.2.13
ARG NGINX_DIR=/usr/local/nginx

ARG USER_ID=0
ARG GROUP_ID=1000

RUN apk --update add bash curl perl vim pcre-dev build-base linux-headers \
    && mkdir -p /usr/local/src && cd /usr/local/src \
    && curl -sL https://github.com/openssl/openssl/archive/refs/tags/openssl-${NGINX_OPENSSL_VERSION}.tar.gz | tar xvz -C . \
    && curl -sL https://github.com/madler/zlib/releases/download/v${NGINX_ZLIB_VERSION}/zlib-${NGINX_ZLIB_VERSION}.tar.gz | tar xvz -C . \
    && curl -sL https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar xvz -C . \
    && cd nginx-${NGINX_VERSION} \
    && ./configure \
        # --with-http_addition_module \
        --with-http_mp4_module \
        --with-http_realip_module \
        --with-http_ssl_module \
        --with-http_sub_module \
        --with-http_v2_module \
        --with-stream \
        --modules-path=/etc/nginx/modules \
        --with-pcre \
        --with-openssl=../openssl-openssl-${NGINX_OPENSSL_VERSION} \
        --with-zlib=../zlib-${NGINX_ZLIB_VERSION} \
        --with-cc-opt="-static" \
        --with-ld-opt="-static" \
        --http-client-body-temp-path=/tmp/client_body_temp \
        --http-proxy-temp-path=/tmp/proxy_temp \
        --http-fastcgi-temp-path=/tmp/fastcgi_temp \
        --http-uwsgi-temp-path=/tmp/uwsgi_temp \
        --http-scgi-temp-path=/tmp/scgi_temp \
    && make \
    && make install \
    && chmod g+srwX -R /usr/local


## image size 18.8MB
FROM alpine AS nginx

ARG USER_ID
ARG GROUP_ID
ARG NGINX_DIR=/usr/local/nginx

COPY --chown=${USER_ID}:${GROUP_ID} --from=nginx-builder ${NGINX_DIR} ${NGINX_DIR}

## fails with failed to solve: executor failed running, put it in /tmp for now
# RUN    addgroup --system --gid ${GROUP_ID} www \
#     &&  if [[ ${USER_ID} -gt 0 ]] ; then \
#             adduser  --system --uid ${USER_ID} www www \
#         ; fi

EXPOSE 80 443

USER ${USER_ID}:${GROUP_ID}

ENV NGINX_DIR=${NGINX_DIR}

## make it easy to run nginx without the full path
ENV PATH="${PATH}:/usr/local/nginx/sbin"

CMD ["nginx", "-g", "daemon off;"]

