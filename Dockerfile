FROM archlinux:latest

# To prevent abusing the arch servers
RUN --mount=type=cache,target=/var/cache/pacman/pkg pacman --noconfirm -Sy \
    base \
    base-devel \
    bat \
    bc \
    bind \
    cmake \
    coreutils \
    docker \
    fd \
    fzf \
    gcc \
    git \
    glibc \
    go \
    linux-api-headers \
    linux-docs \
    linux-headers \
    lsd \
    meson \
    ninja \
    nodejs \
    npm \
    openssh \
    pyenv \
    reflector \
    ripgrep \
    rsync \
    tmux \
    tree-sitter-cli \
    unzip \
    zsh

# Get us some neovim
RUN git clone https://github.com/neovim/neovim /tmp/neovim-git
RUN --mount=type=cache,target=/root cd /tmp/neovim-git; \
        git checkout 3a876bd; \
        make distclean; \
        make; \
        make install

RUN ln -s /usr/local/bin/nvim /usr/local/bin/vim

# 3.11.* upported until Oct. 2027
RUN pyenv install 3.11.4
RUN pyenv global 3.11.4
# JUST DO IT IN THE CONTAINER AND COMMIT THE IMAGE JESUS FUCKING CHRIST

ARG DEV_USER=user
ENV DEV_USER=${DEV_USER}

RUN useradd -ms /bin/zsh $DEV_USER
RUN usermod -aG wheel,docker $DEV_USER
RUN echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

USER $DEV_USER

WORKDIR /home/$DEV_USER

RUN git clone https://github.com/distek/config.nvim.git ~/.config/nvim
RUN git clone https://github.com/distek/config.tmux.git ~/.config/tmux
RUN git clone https://github.com/distek/config.shell.git ~/.config/shell
RUN touch ~/.config/shell/tokens

RUN rm ~/.bashrc && echo || echo
RUN rm ~/.zshrc && echo || echo

RUN ln -s ~/.config/tmux/tmux.conf ~/.tmux.conf
RUN ln -s ~/.config/shell/.zshrc ~/.zshrc
RUN ln -s ~/.config/shell/.bashrc ~/.bashrc

RUN mkdir -p ~/.local/bin
RUN mkdir ~/.local/share

ENV TERM=xterm-256color
ENV SHELL=/bin/zsh

# Install plugins
RUN DEVTAINER_BUILD=1 nvim -V4 --headless +"Lazy! restore | sleep 100" +qa

ENTRYPOINT ["/bin/zsh"]
