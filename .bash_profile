# Add `~/bin` to the `$PATH`
#export PATH="$HOME/bin:$PATH";
# Depends on which version of gcc you want:
#export PATH="/Developer/usr/bin:$PATH"
#export PATH="/usr/local/bin:$PATH";

##To Get TelFit to Install (and maybe work??):
## Uncomment below
## See https://github.com/kgullikson88/Telluric-Fitter/issues/12
#------------------------
#alias gcc="gcc-5"
#------------------------

export HOMEBREW_CASK_OPTS="--appdir=/Applications"
source ~/.profile

#source .todo_completion
#complete -F _todo t

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

###############################################################################
# Gully's aliases                                                             #
###############################################################################

# List the 10 most recently changed files
alias lsh="ls -t | head"

# List the disk usage of files, sorted by their size
alias duf='du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'

# Launch a Chrome browser from command line
alias ogc='open -a Google\ Chrome'


###############################################################################
# Deprecated                                                                  #
###############################################################################

#Set Homebrew packages as default
#export PATH=/usr/local/bin:$PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
. /Users/obsidian/anaconda3/etc/profile.d/conda.sh

show_virtual_env() {
  if [ -n "$CONDA_DEFAULT_ENV" ]; then
    echo "($(basename $CONDA_DEFAULT_ENV))"
  fi
}
export -f show_virtual_env
PS1='$(show_virtual_env)'$PS1

export DIRENV_LOG_FORMAT=

eval "$(direnv hook bash)"
