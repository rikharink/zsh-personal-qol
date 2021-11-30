repo() {
    case "$1" in
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

