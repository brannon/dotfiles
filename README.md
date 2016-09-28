
Clone the repo

```
git clone https://github.com/brannon/dotfiles $HOME/.dotfiles
```

For most files, just create a symbolic link to the corresponding file in `$HOME/.dotfiles`

```
ln -s $HOME/.dotfiles/.bashrc $HOME/.bashrc
```

The `.gitconfig` is a special case, because there are some machine / os specific settings (like the credential helper, etc). Just add the following to `$HOME/.gitconfig`

```
[include]
    path = .dotfiles/.gitconfig
```

Linux credential helper

```
git config --global credential.helper /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring
```

OS X credential helper

```
git config --global credential.helper osxkeychain
```

The `.vimrc` assumes that vim-plug is installed (https://github.com/junegunn/vim-plug). Use the command `:PlugInstall` to install the plugins defined in `.vimrc`

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

