#!/bin/sh

# Space-separated list of packages
pkgs="zsh git curl tmux stow"

# Detect distro and install packages (i usually just use ubuntu or arch)
if [ -f /etc/debian_version ]; then
    echo "Detected Debian-based system."
    sudo apt-get update
    sudo apt install build-essential
    sudo apt-get -y --ignore-missing install $pkgs
elif [ -f /etc/arch-release ]; then
    echo "Detected Arch-based system."
    sudo pacman -Syu --noconfirm
    sudo pacman -Syu --noconfirm $pkgs base-devel
else
    echo "Unsupported Linux distribution."
    exit 1
fi


# Change default shell to zsh
printf "Changing default shell to zsh"
chsh -s /bin/zsh

# Install oh-my-zsh and some plugins
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete


# Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# Install Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Delete default files created by the installations above
rm $HOME/.zshrc
rm $HOME/.p10k.zsh

# Use stow for symlinking the dotfiles
for dir in */; do
    dir=${dir%/}  # Remove trailing slash

    case "$dir" in
        vscode|windows)
        continue
        ;;
    esac

    printf "Do you want to symlink %s using stow? (y/n) " "$dir"
    read choice

    case "$choice" in
        y|Y)
        stow -v -t "$HOME" -S "$dir"
        echo " - $dir installed."
        ;;
    *)
        echo " - skipping $dir."
        ;;
    esac
done

# Install and configure some languages with mise
# Docs: https://mise.jdx.dev/
# The mise activate is already in the zshrc
curl https://mise.run | sh
$HOME/.local/bin/mise use --global node@22.14.0
$HOME/.local/bin/mise use --global java@temurin-21.0.3+9.0.LTS
$HOME/.local/bin/mise use --global rust@1.85.1
$HOME/.local/bin/mise use --global maven@3.9.9
$HOME/.local/bin/mise use --global go@1.24.2
$HOME/.local/bin/mise use --global python@3.13.2
$HOME/.local/bin/mise use --global usage

# Rewritten in Rust: Modern Alternatives of Command-Line Tools
# https://zaiste.net/posts/shell-commands-rust/
# Yazi for browsing files in the terminal
/home/jope/.cargo/bin/cargo install bat du-dust eza fd-find ripgrep yazi-cli yazi-fm