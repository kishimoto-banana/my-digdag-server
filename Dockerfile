FROM amazonlinux:2

RUN yum update -y \
    && yum install -y aws-cli \
    shadow-utils \
    gettext \
    java-1.8.0-openjdk \
    jq \
    tar \
    gzip \
    && rm -rf /var/cache/yum/* \
    && yum clean all

ENV APP_NAME digdag-server
ENV APP_HOME /usr/app/$APP_NAME
ENV APP_BIN_DIR $APP_HOME/bin
ENV PATH=$APP_BIN_DIR:$PATH
ENV TZ=Asia/Tokyo

RUN echo -e "ZONE=$TZ\nUTC=true" > /etc/sysconfig/clock \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && mkdir -p /usr/app \
    && groupadd -r -g 65432 $APP_NAME \
    && useradd -r -m -N \
    -d $APP_HOME \
    -g $APP_NAME \
    -s /sbin/nologin \
    -u 65432 \
    $APP_NAME \
    && mkdir -p $APP_BIN_DIR \
    && chown ${APP_NAME}:${APP_NAME} $APP_BIN_DIR

WORKDIR $APP_HOME

USER ${APP_NAME}

ENV DIGDAG_VERSION 0.9.41
ENV DIGDAG_BIN $APP_BIN_DIR/digdag

RUN curl --create-dirs -o $DIGDAG_BIN -L "https://dl.digdag.io/digdag-${DIGDAG_VERSION}" \
    && chmod +x $DIGDAG_BIN

COPY --chown=digdag-server:digdag-server entrypoint.sh $APP_HOME/
COPY --chown=digdag-server:digdag-server server/config/server.properties $APP_HOME/
COPY --chown=digdag-server:digdag-server workflow $APP_HOME/workflow

CMD ["./entrypoint.sh", "serve"]
