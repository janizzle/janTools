#!/bin/bash
echo 'Welcome to janTools v0.1'
echo 'Checking for yum'

declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt-get

# Functions
install() {
  clear
  echo 'What would you like to install?'
  echo '[1] - Nginx'
  echo '[2] - Apache'
  echo '[3] - PHP'
  echo '[4] - MySQL'
  echo '[5] - phpMyAdmin'
  echo '[6] - MongoDB'
  echo "[7] - certbot (Let's Encrypt)"
  echo '[0] - Cancel'
  printf '\nSelect any number shown above and hit return\n> '
  read install

  update

  case "$install" in
    0) ;;

    1) yum -y install nginx
      openFirewall
      ;;

    2) yum -y install httpd
      openFirewall
      ;;

    *) printf 'Please enter a valid option from above!\nPress any key to continue...'
      read
      ;;
  esac
}

configure() {
  clear
  echo 'What would you like to configure?'

  read configure
}

update() {
  printf '\nWould you like top update all packages first?\n[y/n]> '
  read updateYN

  if [[ "$updateYN" == 'y' ]]; then
    yum -y update
  fi
}

openFirewall() {
  printf '\nWould you like top open port 80 & 443 of your firewall?\n[y/n]> '
  read firewallYN

  if [[ "$firewallYN" == 'y' ]]; then
    yum -y install firewall-cmd
    firewall-cmd --permanent --add-port=80/tcp
    firewall-cmd --permanent --add-port=443/tcp
  fi
}

# Checking if OS uses yum package manager
for f in ${!osInfo[@]}
do
    if [[ -f $f ]]; then
      if [[ ${osInfo[$f]} == 'yum' ]]; then
        echo 'OS uses yum ==> continue'

        # Main loop
        while [ "$action" != "0" ]; do
          clear
          echo 'What would you like to do?'
          echo '[1] - Perform installation'
          echo '[2] - Perform configuration'
          echo '[3] - Update all packages'
          echo '[4] - Perform uninstallation'
          echo '[0] - Exit'
          printf '\nSelect any number shown above and hit return\n> '

          read action

          case "$action" in
            0) echo 'Exiting janTools'
              ;;

            1) install
              ;;

            2) configure
              ;;

            3) yum -y update
              ;;

            4) uninstall
              ;;

            *) printf 'Please enter a valid option from above!\nPress any key to continue...'
              read
              ;;
          esac
        done

      else
        echo 'This is a non yum OS ==> exiting'
      fi
    fi
done
