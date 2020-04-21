FROM clearlinux/r-base
LABEL maintainer="Scott Stanfield <scott.stanfield@gmail.com>"

# https://nickjanetakis.com/blog/best-practices-when-it-comes-to-writing-docker-related-files
# USER root
# Essential libraries for R: https://cran.r-project.org/doc/manuals/r-release/R-admin.html
#

RUN swupd bundle-add git \
    neovim \
    tmux \
    zsh \
    sysadmin-basic \
    devpkg-zlib \
    devpkg-bzip2 \
    devpkg-curl \
    devpkg-pcre \
    xz \
    plzip \
    wget 

RUN swupd clean

RUN echo "will cite" | parallel --citation 2&> /dev/null; exit 0

WORKDIR /app

CMD ["R", "--no-save"]
