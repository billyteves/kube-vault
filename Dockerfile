FROM vault:0.7.3

LABEL maintainer "Billy Ray Teves <billyteves@gmail.com>"

ENV TINI_VERSION 0.14.0
ENV TINI_SHA 6c41ec7d33e857d4779f14d9c74924cab0c7973485d2972419a3b7c7620ff5fd

# Replace docker-entrypoint with one that doesn't rewrite args for dev version!
COPY vault.sh /usr/local/bin/vault.sh

RUN apk add --no-cache \
    && apk add --no-cache ca-certificates \
    # Provide for envsubst from gettext

    gettext \
    curl \

    # This additional packages won't be necessary after dev stage

    bash \

    # CHMOD

    && chmod +x /usr/local/bin/vault.sh \

    # Use tini as subreaper in Docker container to adopt zombie processes

    && curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 -o /bin/tini \
    && chmod +x /bin/tini \
    && echo "$TINI_SHA  /bin/tini" | sha256sum -c - \

    # Cleanup
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

EXPOSE 8201

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/vault.sh"]

CMD ["vault", "server", "-config", "/vault/config"]
