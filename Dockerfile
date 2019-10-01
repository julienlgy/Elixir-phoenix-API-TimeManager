#
# ./Dockefile
# EPITECH 2019 - TimeManager - Project
#

#ELIXIR IMAGE
FROM elixir:1.8-otp-22
# POSTGRES INSTALL
RUN apt-get update && \ 
  apt-get install -y inotify-tools && \
  apt-get install -y postgresql-client
# NODEJS INSTALL
#RUN apt-get install -y curl
#RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
#RUN apt-get install -y nodejs

# COPYING THE FILE
RUN mkdir /api
COPY . /api
WORKDIR /api

RUN mix local.hex --force
#RUN npm install

RUN mix deps.get
RUN mix local.rebar --force
RUN mix do compile

CMD ["/api/entrypoint.sh"]