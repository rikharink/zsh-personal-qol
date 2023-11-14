bwu() {
    BW_STATUS=$(bw status | jq -r .status)
    case "$BW_STATUS" in
    "unauthenticated")
        echo "Logging into BitWarden"
        export BW_SESSION=$(bw login --raw)
        ;;
    "locked")
        echo "Unlocking Vault"
        export BW_SESSION=$(bw unlock --raw)
        ;;
    "unlocked")
        echo "Vault is unlocked"
        ;;
    *)
        echo "Unknown Login Status: $BW_STATUS"
        return 1
        ;;
    esac
    bw sync
}

repo() {
    case "$1" in
        dg)
            pushd $HOME/repos/topicus/fs/declaratiegeneratie
            ;;
        fs)
            pushd $HOME/repos/topicus/fs/
            ;;
        toi)
            pushd $HOME/repos/topicus
            ;;
        cloud)
            pushd $HOME/repos/topicus/cloud
            ;;
        personal)
            pushd $HOME/repos/personal
            ;;
        tools)
            pushd $HOME/repos/tools
            ;;
        websites)
            pushd $HOME/repos/websites
            ;;
        sandbox)
            pushd $HOME/repos/topicus/cloud/aws-sandbox
            ;;
        modules)
            pushd $HOME/repos/topicus/cloud/aws-modules
            ;;
        landingzone)
            pushd $HOME/repos/topicus/cloud/aws-landing-zone
            ;;
        *)
            pushd $HOME/repos/$1
            ;;
    esac
}

switch-aws() {
    case "$1" in
        work)
            export AWS_PROFILE=keyhub
            ;;
        default)
            export AWS_PROFILE=default
            ;;
        *)
            export AWS_PROFILE=$1
            ;;
    esac
}

killport() {
  kill $(lsof -t -i:$1)
}

if ! (( $+commands[eza] )); then
  print "zsh-personal-qol: Warning, eza was not found. Please install eza to use this plugin.." >&2
  return 1
fi

alias ls='eza --group-directories-first --icons --color-scale=all --time-style=iso' # --time-style=iso
alias lt='eza --tree --level=2 --icons' # Show in tree view
alias l='ls -a'                         # Short, all files
alias ld='l -D'                         # Short, only directories
alias ll='ls -lbG --git'                # Long, file size prefixes, grid, git status
alias la='ll -a'                        # Long, all files
alias lC='la --sort=changed'            # Long, sort changed
alias lM='la --sort=modified'           # Long, sort modified
alias lS='la --sort=size'               # Long, sort size
alias lX='la --sort=extension'          # Long, sort extension

