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
        *)
            pushd $HOME/repos/$1
            ;;
    esac
}

check_aws_session() {
    aws sts get-caller-identity > /dev/null 2>&1
    return $?
}

switch-aws() {
    case "$1" in
        fc)
            export AWS_PROFILE=fc
            if ! check_aws_session; then
              aws-keyhub login --role-arn arn:aws:iam::271413448748:role/topicus-operator --profile fc
            fi
            aws eks update-kubeconfig --name fincontrol-test-cluster
            ;;
        fc-acc)
            export AWS_PROFILE=fcacc
            if ! check_aws_session; then
              aws-keyhub login --role-arn arn:aws:iam::301199922953:role/topicus-operator --profile fcacc
              #aws eks update-kubeconfig --name fincontrol-acc-cluster
            fi
            ;;
        fc-prod)
            export AWS_PROFILE=fcprod
            if ! check_aws_session; then
              aws-keyhub login --role-arn arn:aws:iam::870206891775:role/topicus-operator --profile fcprod
              #aws eks update-kubeconfig --name fincontrol-prod-cluster
            fi
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
