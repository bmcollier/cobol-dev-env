FROM httpd:latest

LABEL maintainer="bencollier@fastmail.com"

RUN apt-get update
RUN apt-get -y install apt-utils
RUN apt-get -y install curl
RUN apt-get -y install jq
RUN apt-get -y install open-cobol
RUN apt-get -y install sqlite

COPY httpd.conf /usr/local/apache2/conf/httpd.conf
COPY forward_env_start_httpd /usr/local/apache2/
COPY scripts/api.cob /usr/local/apache2/cgi-bin/
COPY scripts/root.cob /usr/local/apache2/cgi-bin/
COPY scripts/towns.cob /usr/local/apache2/cgi-bin/
COPY scripts/db.cob /usr/local/apache2/cgi-bin/

RUN cobc -x /usr/local/apache2/cgi-bin/db.cob

RUN cobc -x -free /usr/local/apache2/cgi-bin/api.cob /usr/local/apache2/cgi-bin/root.cob /usr/local/apache2/cgi-bin/towns.cob -o /usr/local/apache2/cgi-bin/api

ENTRYPOINT ["/usr/local/apache2/forward_env_start_httpd"]
CMD ls
