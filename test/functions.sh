# --- Functions ---

welcome_msg(){
    echo -e "${YELLOW}"
    figlet "RunnSSH"
    echo -e "${NO_COLOR}"
    echo -e "Welcome to ${YELLOW}RunSSH${NO_COLOR} please select the host you want to access\n"
}

err_msg(){
    echo -e "${ERROR_COLOR}$1${NO_COLOR}"
} 

succ_msg(){
    echo -e "${SUCCESS_COLOR}$1${NO_COLOR}"
} 

create_array(){
    local -a tmp_array=()
    if [[ "$2" == "Host" ]]
    then 
        tmp_array=$(grep -w "^Host" $1 | cut -d " " -f2)
    elif [[ "$2" == "Hostname" ]]
    then
        tmp_array=$(grep -w Hostname $1 | cut -d " " -f3)
    fi

    echo ${tmp_array[@]}
}

largest_string(){
    local len=0
    for n in $@
    do
        if [ $len -lt ${#n} ]
        then
            len=${#n}
        fi
    done
    echo $len
}

install_figma(){
    os_release="/etc/os-release"
    insystem=$(which figlet)
    echo $insystem | grep -o "no figlet"
    #sudo dnf install figlet

}