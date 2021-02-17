#!/bin/sh
# curl -Lks https://raw.github.com/gist/3889839/jenkins.sh | sudo sh -s
# from http://mattonrails.wordpress.com/2011/06/08/jenkins-homebrew-mac-daemo/
# open http://localhost:8080
brew list jenkins || brew install jenkins
mkdir /var/jenkins
/usr/sbin/dseditgroup -o create -r 'Jenkins CI Group' -i 600 _jenkins
dscl . -append /Groups/_jenkins passwd "*"
dscl . -create /Users/_jenkins
dscl . -append /Users/_jenkins RecordName jenkins
dscl . -append /Users/_jenkins RealName "Jenkins CI Server"
dscl . -append /Users/_jenkins uid 600
dscl . -append /Users/_jenkins gid 600
dscl . -append /Users/_jenkins shell /usr/bin/false
dscl . -append /Users/_jenkins home /var/jenkins
dscl . -append /Users/_jenkins passwd "*"
dscl . -append /Groups/_jenkins GroupMembership _jenkins
chown -R jenkins /var/jenkins
(
  cd /Library/LaunchDaemons/
  curl -Lks -o org.jenkins-ci.plist https://raw.github.com/gist/3889839/org.jenkins-ci.plist
  WAR_PATH=$(brew list jenkins | grep '[.]war')
  perl -pi -e "s|WAR_PATH|${WAR_PATH}|" org.jenkins-ci.plist
  chown -R root org.jenkins-ci.plist
  launchctl load /Library/LaunchDaemons/org.jenkins-ci.plist
)
sudo -u jenkins ssh-keygen </dev/null
