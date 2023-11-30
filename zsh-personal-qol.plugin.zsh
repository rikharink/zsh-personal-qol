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

check-aws-session() {
    caller_identity=$(aws sts get-caller-identity --profile ${1})
    return_code=$?
    if [[ $return_code -ne 0 ]]; then
      print "Sessie verlopen.."
      return $return_code
    fi
    actual_account=$(echo "$caller_identity" | jq -r '.Account')

    if [[ "$actual_account" == "${2}" ]]; then
      return 0
    else
      print "Opnieuw inloggen; profiel ${1} is gekoppeld aan account ${actual_account} i.p.v. ${2}"
      return 255
    fi
}

switch-aws() {
  #set -x
  export AWS_DEFAULT_REGION=eu-west-1
  iam_role_arn="arn:aws:iam::${2}:role/${3}"
  if ! check-aws-session ${1} ${2}; then
     aws-keyhub login --role-arn $iam_role_arn --profile ${1}
  fi
  export AWS_PROFILE=${1}
  echo -e "\e[32m\u2713\e[0m Switched AWS_PROFILE to \e[32m\"${1}\"\e[0m."
  if [ -n "${4}" ]; then
    available_kubectx=$(kubectx)
    cluster_arn="arn:aws:eks:$AWS_DEFAULT_REGION:${2}:cluster/${4}"
    if [[ $available_kubectx == *"$cluster_arn"* ]]; then
      kubectx $cluster_arn
    else
      aws eks update-kubeconfig --name ${4}
    fi
  fi
  #set +x
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