cd $HOME/Apps/spm
git reset --hard HEAD
git pull
cd ..
./FlowQuality/sonar-scanner/bin/sonar-scanner -Dproject.settings=$HOME/Apps/FlowQuality/sonar-scanner/conf/sonar-scanner.spm365.properties