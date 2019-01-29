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
  echo '[0] - Cancel'
  printf '\nSelect any number shown above and hit return\n>'

  read install
}

configure() {
  clear
  echo 'What would you like to configure?'

  read configure
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
          echo '[3] - Perform update'
          echo '[0] - Exit'
          printf '\nSelect any number shown above and hit return\n>'

          read action

          case "$action" in
            0) echo 'Exiting janTools'
              ;;

            1) install
              ;;

            2) configure
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
