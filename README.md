![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/JamesJJ/jekyll) ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/JamesJJ/jekyll/build-and-publish.yml?branch=main)

# A docker image for building Jekyll websites

```
# Replace "/home/user/jekyll" with the location of your Jekyll site source files

chmod -R o+rwX /home/user/jekyll/_site

docker run \
    -v /home/user/jekyll:/opt/build \
    -v /home/user/jekyll/_site:/opt/_site \
    ghcr.io/jamesjj/jekyll:main \
    /bin/sh -c "bundle exec jekyll build -s /opt/build -d /opt/_site --disable-disk-cache --strict_front_matter --trace"
```

