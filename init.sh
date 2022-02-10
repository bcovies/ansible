#!/bin/bash

PROJECTS_TEMPLATES=( "ansible" "named" "netplan" "nginx" "ssl")
CONFD_BIN_FILE=confd-0.16.0-linux-amd64
PATH_TMP_FILES=/tmp/confd

get_local_pwd(){
    CURRENT_PATH=$(pwd)
    echo "----------------------------------------------------------------------------"
    echo "Your current path is: ${CURRENT_PATH}"
}

create_templates_path_tmp(){
    echo "----------------------------------------------------------------------------"
    echo "Creating all /tmp/ folders to confd templates..."
    for local_folder_name in ${PROJECTS_TEMPLATES[@]}; do
        mkdir -p ${PATH_TMP_FILES}/${local_folder_name}
        if [[ -d ${PATH_TMP_FILES}/${local_folder_name} ]]; then
            echo "----------------------------------------------------------------------------"
            echo "OK ${PATH_TMP_FILES}/${local_folder_name}"
        else
            echo "----------------------------------------------------------------------------"
            echo "ERROR: cloud not create ${PATH_TMP_FILES}/${local_folder_name}"
            exit 1
        fi
    done
}

create_templates_confd(){
    if [[ ! -z ${CURRENT_PATH} ]]; then
        chmod +x ${CURRENT_PATH}/${CONFD_BIN_FILE}
        echo "----------------------------------------------------------------------------"
        for local_folder_name in ${PROJECTS_TEMPLATES[@]}; do
            echo "CURRENT TEMPLATE: ${local_folder_name}"
            echo
            env $(cat .env | grep ^[A-Z] | xargs) \
                ${CURRENT_PATH}/${CONFD_BIN_FILE} -onetime \
                    -confdir ${CURRENT_PATH}/templates/${local_folder_name} -backend env
            echo "----------------------------------------------------------------------------"
        done
    else
        echo "----------------------------------------------------------------------------"
        echo "ERROR: Var CURRENT_PATH is empty, checkout this script!"
    fi
}

rename_named_files(){
    source .env

    if [[ -f ${PATH_TMP_FILES}/named/forward.domain.sufix ]]; then
        mv ${PATH_TMP_FILES}/named/forward.domain.sufix \
            ${PATH_TMP_FILES}/named/forward.${DOMAIN_SUFIX}
    else
        echo "----------------------------------------------------------------------------"
        echo "ERROR: ${PATH_TMP_FILES}/named/forward.domain.sufix DO NOT EXISTS!"
        exit 1
    fi

    if [[ -f ${PATH_TMP_FILES}/named/reverse.domain.sufix ]]; then
        mv ${PATH_TMP_FILES}/named/reverse.domain.sufix \
            ${PATH_TMP_FILES}/named/reverse.${DOMAIN_SUFIX}
    else
        echo "----------------------------------------------------------------------------"
        echo "ERROR: ${PATH_TMP_FILES}/named/reverse.domain.sufix DO NOT EXISTS!"
        exit 1
    fi
}

create_local_foldes(){
    echo "Creating folder: ${CURRENT_PATH}/ubuntu/group_vars/"
    mkdir -p ${CURRENT_PATH}/ubuntu/group_vars/
    for local_folder_name in ${PROJECTS_TEMPLATES[@]}; do
        echo "Creating folder: ${CURRENT_PATH}/ubuntu/roles/${local_folder_name}/files/"
        mkdir -p ${CURRENT_PATH}/ubuntu/roles/${local_folder_name}/files/
    done
    echo "----------------------------------------------------------------------------"

}


copy_files_tmp_folder(){
    for local_folder_name in ${PROJECTS_TEMPLATES[@]}; do
        echo "COPYING CURRENT TEMPLATE: ${local_folder_name}"
        echo
        if [[ ${local_folder_name} == 'ansible' ]]; then    
            echo "${PATH_TMP_FILES}/${local_folder_name} --> ${CURRENT_PATH}/ubuntu/group_vars/"
            cp -a ${PATH_TMP_FILES}/${local_folder_name}/* ${CURRENT_PATH}/ubuntu/group_vars/
        else
            echo "${PATH_TMP_FILES}/${local_folder_name} --> ${CURRENT_PATH}/ubuntu/roles/${local_folder_name}/files/"
            cp -a ${PATH_TMP_FILES}/${local_folder_name}/* ${CURRENT_PATH}/ubuntu/roles/${local_folder_name}/files/
        fi
        echo "----------------------------------------------------------------------------"
    done
}




init(){
    create_templates_path_tmp
    get_local_pwd
    create_templates_confd
    rename_named_files
    create_local_foldes
    copy_files_tmp_folder
}

init