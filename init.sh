#!/bin/bash

function init () {
    #Check permission
    checkPermission="$(cat /etc/group | grep docker)"
    if echo "$checkPermission" | grep -q "$USER"; then
        echo "$USER permissions ok!!"
    else
        sudo gpasswd -a $USER docker
    fi
#Run zabbix server
    result="$(docker images zabbix/zabbix-appliance)";
    if [[ $result == *"zabbix/zabbix-appliance"* ]]; then
        checkStatus="$(docker ps -a | grep zabbix/zabbix-appliance)";
        if echo "$checkStatus" | grep -q 'Up'; then
            echo "zabbix in port 83";
        else
            docker start zabbix-appliance;
        fi   
    else
        docker run --name zabbix-appliance -t \
            -e PHP_TZ="America/Sao_Paulo" \
            -p 10051:10051 \
            -p 83:80 \
            -d zabbix/zabbix-appliance:latest ;
    fi
# Run SonarQube
    checkComposerDb="$(docker-compose ps --filter name=db)"
    checkComposerSonar="$(docker-compose ps --filter name=sonarqube | grep  'sonarqube_1')"
    if echo "$checkComposerSonar" | grep -q "Exit"; then
        docker-compose up -d --remove-orphans sonarqube 
    fi

    if echo "$checkComposerDb" | grep -q "Exit"; then
        docker-compose up -d --remove-orphans db 
    fi
}

function status () {
    checkPermission="$(cat /etc/group | grep docker)"
    if echo "$checkPermission" | grep -q "$USER"; then
        echo "$USER permissions ok!!"
    else
        echo "Please check your permissions"
    fi  
    
    checkStatus="$(docker ps -a | grep zabbix/zabbix-appliance)";
    if echo "$checkStatus" | grep -q 'Up'; then
        echo "zabbix run in port 83";
    else
        echo "zabbix stoped\n";
    fi

    checkComposerDb="$(docker-compose ps --filter name=db)"
    checkComposerSonar="$(docker-compose ps --filter name=sonarqube | grep  'sonarqube_1')"
    if echo "$checkComposerSonar" | grep -q "Exit"; then
        echo "sonarqube stoped"
    else
        echo "sonarqube run in port 9000"
    fi

    if echo "$checkComposerDb" | grep -q "Exit"; then
        echo "db stoped"
    else
        echo "db is running"
    fi    
}

function serviceAction () {
    docker "$(echo $1)" zabbix-appliance;
    docker-compose "$(echo $1)" sonarqube;
    docker-compose "$(echo $1)" db
}





#init;


show_menu(){
    clear
    NORMAL=`echo "\033[m"`
    MENU=`echo "\033[36m"` #Blue
    NUMBER=`echo "\033[33m"` #yellow
    FGRED=`echo "\033[41m"`
    RED_TEXT=`echo "\033[31m"`
    ENTER_LINE=`echo "\033[33m"`
    UNDERLINE=`echo -e "\x1b[4m"`
    echo -e "${UNDERLINE}${MENU}Quality Apps\n${NORMAL}"
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "${MENU}**${NUMBER} 1)${MENU} init services ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 2)${MENU} restart services ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 3)${MENU} stop services ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 4)${MENU} show status ${NORMAL}"
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "${ENTER_LINE}Please enter a menu option and enter or ${RED_TEXT}enter to exit. ${NORMAL}"
    read opt

}
function option_picked() {
    COLOR='\033[01;31m' # bold red
    RESET='\033[00;00m' # normal white
    MESSAGE=${@:-"${RESET}Error: No message passed"}
    echo -e "${COLOR}${MESSAGE}${RESET}"
}


show_menu
while [ opt != '' ]
    do
    if [[ $opt = "" ]]; then 
            exit;
    else
        case $opt in
        1) clear;
            option_picked "Option 1 Picked";
            init; 
            show_menu;
        ;;

        2) clear;
            option_picked "Option 2 Picked";
            echo -e "wait please\n\n";
            serviceAction "restart";
            echo -e "\n\npress enter";
            read key
            show_menu;
            ;;

        3) clear;
            option_picked "Option 3 Picked";
            echo -e "wait please\n\n";
            serviceAction "kill";
            echo -e "\n\npress enter";
            read key
            show_menu;
            ;;

        4) clear;
            option_picked "Option 4 Picked";
            status
            echo -e "\n\npress enter";
            read key
            show_menu;
            ;;

        x)exit;
        ;;

        \n)exit;
        ;;

        *)clear;
        option_picked "Pick an option from the menu";
        show_menu;
        ;;
    esac
fi
done