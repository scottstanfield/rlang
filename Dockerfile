FROM clearlinux/r-base
LABEL maintainer="Scott Stanfield <scott.stanfield@gmail.com>"

# https://nickjanetakis.com/blog/best-practices-when-it-comes-to-writing-docker-related-files
# USER root
# Essential libraries for R: https://cran.r-project.org/doc/manuals/r-release/R-admin.html

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
RUN swupd bundle-add rust-basic
RUN cargo install --root /usr/local scrubcsv xsv

RUN swupd clean
RUN swupd bundle-add R-extras

# The UID 2000 and GID of 1050 requires host account with identical settings
RUN groupadd --gid 1050 -o campfire && \
        useradd --uid 2000 --gid 1050 --create-home rlang --shell /usr/bin/zsh && \
        usermod -G wheel rlang
USER 2000:1050
WORKDIR /home/rlang

RUN echo "will cite" | parallel --citation 2&> /dev/null; exit 0

RUN mkdir -p /home/rlang/rlibs
COPY --chown=2000:1050 Renviron .Renviron
COPY --chown=2000:1050 Rprofile .profile
COPY --chown=2000:1050 install.r .
RUN R --quiet -f install.r

RUN touch v1.6.2.txt      # improved prompt
RUN git clone https://github.com/scottstanfield/dmz && dmz/install.sh

RUN pip install -U numpy click radian

RUN echo "path=(/app/bin \$path)" >> .zshrc


WORKDIR /app
CMD ["R", "--no-save"]
