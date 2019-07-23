cd $HOME/Apps/crm
git pull
cd ..
./FlowQuality/sonar-scanner/bin/sonar-scanner -Dproject.settings=$HOME/Apps/FlowQuality/sonar-scanner/conf/sonar-scanner.crm.properties
