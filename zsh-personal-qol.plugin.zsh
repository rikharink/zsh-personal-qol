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

