######################################################################
#
# env setup
#
######################################################################

# ARCH (x86_64, arm)
if [[ ! -z $(which uname) ]]; then
    MACHINE=$(uname -m)
    case $MACHINE in
        arm*)
            ARCH=arm
            ;;
        *)
            ARCH=$MACHINE
            ;;
    esac
fi

#echo "ENV: detected ARCH $ARCH"
