######################################################################
#
# File functions
#
######################################################################

file_backup() {
    local FILE_PATH
    FILE_PATH=$1

    operation "Backup file $FILE_PATH"
    if [[ -f $FILE_PATH ]]; then
        if [[ ! -f "$FILE_PATH.orig" ]]; then
            mv $FILE_PATH $FILE_PATH.orig
            operation_check_exit $?
        else
            ok "File already backed up"
        fi
    else
        ok "File does not exist"
    fi
}

file_link() {
    local SOURCE_PATH
    local TARGET_PATH
    SOURCE_PATH=$1
    TARGET_PATH=$2

    operation "Link file $TARGET_PATH → $SOURCE_PATH"
    if [[ ! -f $TARGET_PATH ]]; then
        ln -s $SOURCE_PATH $TARGET_PATH
        operation_check_exit $?
    else
        ok "File already linked"
    fi
}
