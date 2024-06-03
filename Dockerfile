FROM ethereum/client-go:v1.10.7-arm64

ARG CHAIN_ID
ARG ACCOUNT_PASSWORD
ARG ACCOUNT_BALANCE
ARG GAS_LIMIT

RUN apk update && \
    apk add --no-cache bash && \
    apk add --no-cache python3

COPY update_genesis_json.sh /
COPY start.sh /
COPY genesis.json /

RUN chmod +x start.sh

RUN /bin/bash ./update_genesis_json.sh ${CHAIN_ID} ${ACCOUNT_PASSWORD} ${ACCOUNT_BALANCE} ${GAS_LIMIT} && \
    geth init genesis.json && \
    rm -f ~/.ethereum/geth/nodekey

ENTRYPOINT ["/bin/bash", "./start.sh"]
