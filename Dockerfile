FROM alpine:3.21 AS ruby_base

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
gcompat \
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

#BUILDING
COPY Gemfile .

RUN echo "gem: --platform ruby --no-ri --no-rdoc" > ~/.gemrc

RUN bundle config set --local force_ruby_platform true

RUN unset BUNDLE_PATH && unset BUNDLE_BIN && bundle install --no-cache

# VERIFYING
RUN mkdir -p /opt/test /opt/_test_site && chown jekyll /opt/test /opt/_test_site

COPY --chown=jekyll:jekyll test /opt/test

RUN bundle exec jekyll build -s /opt/test -d /opt/_test_site --disable-disk-cache --strict_front_matter --trace

RUN rm -rf /opt/test /opt/_test_site

# FINAL
FROM ruby_base AS final

COPY --from=build_gems --chown=jekyll:jekyll /opt /opt

USER jekyll:jekyll

# DONE
######
