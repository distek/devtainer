FROM archlinux:latest

RUN pacman --noconfirm -Sy base-devel neovim ripgrep fd go nodejs pyenv npm tmux nnn git zsh fzf lsd bat reflector rsync unzip bc

# 3.11.* upported until Oct. 2027
RUN pyenv install 3.11.4 && pyenv global 3.11.4

WORKDIR /root/

RUN git clone https://github.com/distek/config.nvim.git ~/.config/nvim
RUN git clone https://github.com/distek/config.tmux.git ~/.config/tmux
RUN git clone https://github.com/distek/config.shell.git ~/.config/shell
RUN touch ~/.config/shell/tokens

RUN ln -s ~/.config/tmux/tmux.conf ~/.tmux.conf
RUN ln -s ~/.config/shell/.zshrc ~/.zshrc
RUN ln -s ~/.config/shell/.bashrc ~/.bashrc

RUN mkdir -p ~/.local/bin

RUN ln -s /usr/bin/nvim /usr/bin/vim

ENV TERM=xterm-256color

ENTRYPOINT ["/bin/zsh"]
