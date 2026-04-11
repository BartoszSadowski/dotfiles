# Tmux Config

## Setup

Install tmux plugin management to your system

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Install theme
```
mkdir -p ~/.config/tmux/plugins/catppuccin
git clone -b v2.3.0 https://github.com/catppuccin/tmux.git ~/.tmux/plugins/catppuccin/tmux
```

Run below command in this directory to make the config available

```
ln -s "$(realpath ./.tmux.conf)" ~/.tmux.conf
```

