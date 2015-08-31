

## Flecha tmux theme

A tmux theme.

![](screenshot.png)

Inspiration:

- tmux powerline: https://github.com/erikw/tmux-powerline
- maglev theme: https://github.com/caiogondim/maglev
- zanshin tmux.conf: https://github.com/zanshin/dotfiles/blob/master/tmux/tmux.conf

## Requirements

- Tmux: http://tmux.github.io/
- Powerline patched fonts: https://github.com/powerline/fonts
- Tmux Plugin Manager (recommended): https://github.com/tmux-plugins/tpm
- tmux-mem-cpu-load (optional): https://github.com/thewtex/tmux-mem-cpu-load

## Installation with Tmux Plugin Manager (recommended)

Add the plugin to the list of TPM plugins in .tmux.conf:

```sh
set -g @plugin 'labianchin/tmux-flecha'
```

## Manual Installation

Clone the repo:

$ git clone https://github.com/labianchin/tmux-flecha ~/.tmux-flecha
Add this line to the bottom of .tmux.conf:

```
run-shell ~/tmux-flecha/flecha.tmux
```

Reload TMUX environment with: `$ tmux source-file ~/.tmux.conf`. You should now be able to see the theme.

## License

MIT
