# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete mise)

# Mise
eval "$($HOME/.local/bin/mise activate zsh)"

# Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# Lunar Vim
export PATH=$HOME/.local/bin:$PATH

# opencode
export PATH=$HOME/.opencode/bin:$PATH

# custom aliases
alias bls="eza"
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" | ( read -r; printf "%s\n" "$REPLY"; sort -k1 ) | sed -E "s/([0-9]{1,3}\.){3}[0-9]{1,3}://g; s/\[::\]:[0-9]+->[0-9]+\/(tcp|udp),? ?//g; s#/tcp|/udp##g"'

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh