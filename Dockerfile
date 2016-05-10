FROM ubuntu:16.04
MAINTAINER Mike Scalora <mike@scalora.org>

ENV HOME /root

# Ignore APT warnings about not having a TTY
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        git \
        zsh screen \
        wget curl nano \
        texinfo groff \
        autoconf automake autopoint pkg-config make \
        libncursesw5-dev gettext

# - autoconf (version >= 2.61)
# - automake (version >= 1.7)
# - gettext  (version >= 0.11.5)
# - groff    (version >= 1.12)
# - texinfo  (version >= 4.0)
# - git      (version >= 2.7.4)
# - glib 2.x (if your system doesn't have vsnprintf(), which the configure
#   script will check for)
# - make, gcc and the normal development libraries (curses or slang, etc.)
        
# setting up zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && chsh -s /bin/zsh

RUN git clone https://github.com/mscalora/custom-zsh.git ~/.oh-my-zsh/custom/my-custom ; \
    perl -pi -w -e 's/ZSH_THEME=.*/ZSH_THEME="scalora"\nZSH_CUSTOM=\$ZSH\/custom\/my-custom/g;' ~/.zshrc ; \
    perl -pi -w -e 's/plugins=.*/plugins=(git ssh zsh-navigation-tools)/g;' ~/.zshrc

# set locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/cache/* && \
    rm -rf /var/lib/log/*

WORKDIR /root
CMD ["zsh"]