FROM ruby:2.4.1
MAINTAINER AKIKO TAKANO / (Twitter: @akiko_pusu)

### get Redmine source
ARG redmine_version="3.4-stable"
ARG redmine_lang="en"
ARG redmine_database="sqlite3"

### Replace shell with bash so we can source files ###
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

### install default sys packeges ###
RUN apt-get update
RUN apt-get install -qq -y \
    git vim              \
    sqlite3

WORKDIR /tmp
RUN echo "REDMINE_VERSION:" ${redmine_version}
RUN git clone --depth 1 -b ${redmine_version} https://github.com/redmine/redmine redmine
WORKDIR /tmp/redmine

RUN echo $'test:\n\
  adapter: sqlite3\n\
  database: redmine_test\n\
\n\
development:\n\
  adapter: sqlite3\n\
  database: redmine_development\n'\
>> config/database.yml.sqlite3

RUN echo $'test:\n\
  adapter: mysql2\n\
  database: redmine_test\n\
  host: db\n\
  username: root\n\
  password: redmine\n\
  encoding: utf8mb4\n\
\n\
development:\n\
  adapter: mysql2\n\
  database: redmine_development\n\
  host: db\n\
  username: root\n\
  password: redmine\n\
  encoding: utf8mb4\n'\
>> config/database.yml.mysql

RUN gem update bundler
ADD . /tmp/redmine/plugins/redmine_issue_badge
RUN cp config/database.yml.${redmine_database} config/database.yml
EXPOSE 3000

