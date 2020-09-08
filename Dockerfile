FROM alpine/git AS git

RUN mkdir -p /nmap/scripts/vulscan/ && \
    mkdir -p /nmap/nselib/data/

WORKDIR /repo

RUN git clone --depth=1 https://github.com/vulnersCom/nmap-vulners.git
RUN cp /repo/nmap-vulners/*.nse /nmap/scripts/
RUN cp /repo/nmap-vulners/*.json /repo/nmap-vulners/*.txt /nmap/nselib/data/

RUN git clone --depth=1 https://github.com/scipag/vulscan.git
RUN cp /repo/vulscan/*.nse /repo/vulscan/*.csv /nmap/scripts/vulscan/


FROM alpine:latest

RUN apk add --quiet --no-cache exim nmap nmap-scripts

COPY --from=git /nmap/ /usr/share/nmap/

RUN nmap --script-updatedb
