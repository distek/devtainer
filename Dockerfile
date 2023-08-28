FROM archlinux:latest

# To prevent abusing the arch servers
RUN --mount=type=cache,target=/var/cache/pacman/pkg pacman --noconfirm -Sy base base-devel ripgrep fd go nodejs pyenv npm tmux git zsh fzf lsd bat reflector rsync unzip bc gcc glibc docker ninja meson cmake coreutils bind tree-sitter-cli

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

RUN useradd -ms /bin/zsh user
RUN usermod -aG wheel,docker user
RUN echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

USER user

WORKDIR /home/user

RUN CASHBUST=5 git clone https://github.com/distek/config.nvim.git ~/.config/nvim
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

# Give mason a chance
RUN DEVTAINER_BUILD=1 nvim -V4 --headless +"sleep 100" +qa

ENTRYPOINT ["/bin/zsh"]
