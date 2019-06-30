# =============================================================================
# ZSH Config
# =============================================================================
echo -ne "\e[2K\r"; echo -ne "Antibody init"\\r
source <(antibody init)

echo -ne "\e[2K\r"; echo -ne "Exporting vars"\\r
# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="gharper"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
#HIST_STAMPS="yyyy-mm-dd"
HISTSIZE=100000
SAVEHIST=100000

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(git)
echo -ne "\e[2K\r"; echo -ne "Antibody bundle plugins"\\r
antibody bundle < ~/.zsh_plugins.txt

# User configuration

# =============================================================================
# Exports
# =============================================================================

# Add homebrew binaries to path
# PATH is set via path_helper in /private/etc/paths.d/*

export CHEATCOLORS=true

# Fixes Ansible fork issue on MacOS High Sierra
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# Force python packages to go in virtualenvs for dev sanity
export PIP_REQUIRE_VIRTUALENV=true
export WORKON_HOME=~/venv

# Flags for M2Crypto install via pip
export LDFLAGS="-L/usr/local/opt/openssl/lib:/usr/local/opt/curl/lib:/usr/local/opt/binutils/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include:/usr/local/opt/curl/include:/usr/local/opt/binutils/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig:/usr/local/opt/curl/lib/pkgconfig"
if [[ "$(uname 2> /dev/null)" == "Darwin" ]]; then
  export SWIG_FEATURES="-cpperraswarn -includeall -I$(brew --prefix openssl)/include"
fi


export PERL5LIB="/Users/gharper/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
export PERL_LOCAL_LIB_ROOT="/Users/gharper/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_MB_OPT="--install_base \"/Usexers/gharper/perl5\""
export PERL_MM_OPT="INSTALL_BASE=/Users/gharper/perl5"

export EMAIL="gharper@skytap.com"
export SKYTAP_API_TOKEN="1da285d771f74d85d77fd256faef7e32e28e88ce"
export PASSWORD=$(cat ~/.ssh/passwd)
# =============================================================================
# Oh My Zsh
# =============================================================================
#echo -ne "\e[2K\r"; echo -ne "Configuring oh-my-zsh"\\r
#source $ZSH/oh-my-zsh.sh

#if [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
#    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#elif [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
#    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#fi
if [[ -f ~/.profile ]]; then
    echo -ne "\e[2K\r"; echo -ne "Sourcing .profile"\\r
    source ~/.profile
fi
export VIRTUALENVWRAPPER_PATH="$(which virtualenvwrapper.sh)"
if [[ -f ${VIRTUALENVWRAPPER_PATH} ]]; then
    echo -ne "\e[2K\r"; echo -ne "Sourcing virtualenvwrapper"\\r
    source ${VIRTUALENVWRAPPER_PATH}
    workon default
fi

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# =============================================================================
# Aliases
# =============================================================================
echo -ne "\e[2K\r"; echo -ne "Setting aliases"\\r
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias cd..='cd ..'
alias cd~='cd ~'
alias ..='cd ..'
alias ...='cd ../../../'
alias mkdir='mkdir -pv'
alias mount='mount |column -t'
alias hist='history'
alias wtf='wtf -o'

# Use ansible to effectively ssh-copy-id to a group of servers
alias push_sshkey='ansible $1 -m authorized_key -a "user=gharper key=\"{{ lookup('\''file'\'', '\''.ssh/id_rsa.pub'\'') }}\" path=/home/users/gharper/.ssh/authorized_keys"'

# Check for orphan processes
alias orphan_procs_on='ansible $1 -m shell -a "ps -elf | head -1; ps -elf | awk '\''{if (\$5 == 1 && \$3 != "root") {print \$0}}'\'' | head" -b -K'

# Flush DNS in OS X
alias flushdns='sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;scutil --dns|grep -A20 "scoped queries"|egrep "resolver|domain|nameserver"'

# Play a quick game of Russian Roulette
alias shootme='[ $[ $RANDOM % 6 ] = 0 ] && echo "*BANG!*" || echo "*Click*"'

# Typo the last command?  fuckit guesses what you meant and immediately runs it
eval "$(thefuck --alias)"
alias fuckit='export THEFUCK_REQUIRE_CONFIRMATION=False; fuck; export THEFUCK_REQUIRE_CONFIRMATION=True'

# Shortcuts for commonly used pip commands
alias pipup='pip list --outdated | cut -d" " -f1 | egrep -v "Package|---" | xargs sudo -H pip install -U '
alias pipls='pip list --outdated'

# Copies the contents of a secure note from LastPass into clipboard buffer.
alias lpwd='lpass show -c --notes '

# Mount various remote servers to local dirs
alias ssh_mount='sshfs gharper@odv4linjump1.gharper.dev.skytap.com:/home/gharper/ /Users/gharper/mnt/odv4linjump1/ ;
sshfs gharper@tuk1linjump4.prod.skytap.com:/home/gharper/ /Users/gharper/mnt/tuk1linjump4/ ;
sshfs gharper@tuk8linjump4.qa.skytap.com:/home/gharper/ /Users/gharper/mnt/tuk8linjump4/ ;
sshfs root@odv4opspuppetmaster1.gharper.dev.skytap.com:/etc/puppet /Users/gharper/mnt/odv4puppetmaster1 ;
'
alias ssh_umount='umount /Users/gharper/mnt/*'

# Use if `brew update python` borks the venvs
alias fixvenvs='find ~/venv/* -type l -delete ;
  virtualenv ~/venv/default ;
  virtualenv ~/venv/ansible-2.3 ;
  virtualenv ~/venv/ansible-2.4 ;
  virtualenv ~/venv/ansible-2.5 ;
  virtualenv ~/venv/ansible-2.7 ;
  virtualenv ~/venv/operations_tools ;
  workon default'

alias gitup='find ./ -name .git -execdir pwd \; -execdir git pull --all \;'
alias top="sudo htop"
alias jenkinsfile-lint="ssh jenkins.corp.skytap.com declarative-linter < "
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"

# =============================================================================
# Functions
# =============================================================================
echo -ne "\e[2K\r"; echo -ne "Setting functions"\\r
echo -ne "\e[2K\r"
