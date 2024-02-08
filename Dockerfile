FROM alpine:3.19 AS ruby_base

RUN addgroup -Sg 1000 jekyll

RUN adduser  -Su 1000 -G jekyll jekyll

RUN mkdir /opt/build /opt/src /opt/_site /opt/bundle

RUN chown -R jekyll:jekyll /opt

ENV GEM_HOME="/opt/bundle"

ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

WORKDIR /opt/src

RUN apk --no-cache add \
ruby \
ruby-bundler \
icu-data-full \
libffi \
libressl \
libxml2 \
libxslt \
less \
readline \
sassc \
shadow \
su-exec \
tzdata \
yarn \
zlib

FROM ruby_base AS build_base

RUN apk --no-cache add \
ruby-dev \
build-base \
cmake \
git \
imagemagick-dev \
libffi-dev \
libxml2-dev \
libxslt-dev \
linux-headers \
nodejs \
npm \
readline-dev \
sqlite-dev \
vips-dev \
vips-tools \
yaml-dev \
zlib-dev

FROM build_base AS build_gems

USER jekyll:jekyll

COPY Gemfile .

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc

RUN unset BUNDLE_PATH && unset BUNDLE_BIN && bundle install --no-cache

FROM ruby_base AS final_image

COPY --from=build_gems --chown=jekyll:jekyll /opt /opt

USER jekyll:jekyll
