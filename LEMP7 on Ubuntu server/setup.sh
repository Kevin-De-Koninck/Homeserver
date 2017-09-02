#!/bin/bash

# todo
# change host name (default = ubuntu)

source ./whiptail.sh
INSTALL=true
title_of_installer="LEMP"

# ------------------------------------------------------------------------------

function display_help() {
  if [ $1 = true ]
  then
    echo -e "\nThis installer will setup a clean LEMP Server (Linux, NginX, MySQL, PHP).\n"
  fi
  echo "The following arguments are allowed:"
  echo -e "\t-h | --help \t\tDisplay this help message."
  echo -e "\t--install \t\tStart the installer (optional, default argument)."
  echo -e "\t--uninstall \t\tRemove everything! (CAUTION)"
  echo -e "\t--change-host-name \t\tChange the hostname."
}

function ask_hostname {
  hostname=$(w_get_string "${title_of_installer}" "\n\nWhat's the name that you want to assign to your server? This will allow you to connect to it using '*.local'.\nSpaces will be truncated.\n" "${user}")

  # Remove spaces
  hostname=$(echo ${hostname} | tr -d ' ')
}

function change_host_name {
  ask_hostname
  apt -y install avahi-daemon
  sed -i "/host-name=/c\host-name=${hostname}" /etc/avahi/avahi-daemon.conf
  /etc/init.d/avahi-daemon stop
  /etc/init.d/avahi-daemon start
}

function automate_mysql_secure_installation {
  # Instead of running /usr/bin/mysql_secure_installation

  DATABASE_PASS=$(w_get_string "${title_of_installer}" "\n\nPlease enter the root password again that you've just assigned. We'll need his to continue the MySQL secure installation." "")

  apt install -y expect

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter password for user root:\"
send \"$DATABASE_PASS\r\"
expect \"Press y|Y for Yes, any other key for No:\"
send \"n\r\"
expect \"Change the password for root ?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

  echo "$SECURE_MYSQL"
  apt purge -y expect

}

function install() {
  echo 'Dpkg::Progress-Fancy "1";' > /etc/apt/apt.conf.d/99progressbar # enable pretty progress bar

  w_show_message "${title_of_installer}" "\n\nThis installer will setup a clean LEMP Server (Linux, NginX, MySQL, PHP)."

  if ( w_ask_yesno "${title_of_installer}" "\n\nDo you want to apt-get update and upgrade your machine first?" )
  then
    w_show_message "${title_of_installer}" "\n\nThis will take some time, please be patient. The progress will start as soon you press 'OK'."
    sudo apt update -y && sudo apt upgrade -y
  fi

  # Ask and configure .local address
  change_host_name

  # Install MySQL
  w_show_message "${title_of_installer}" "\n\nNext we will install MySQL. You'll be asked to enter a password for the root user. Please do not leave this empty.\nAlso, please remember this password. You'll need it to log in to your MySQL database."
  sudo apt install -y mysql-server php-mysql libmysqlclient-dev
  automate_mysql_secure_installation

  # Install NginX
  w_show_message "${title_of_installer}" "\n\nNow, we will continue the installation by installing NginX PHP and phpMySQL."
  apt install -y nginx
  sudo service nginx start

  # Install PHP
  apt install -y php-fpm
  mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup
  mv ./default /etc/nginx/sites-available/default
  port=$(w_get_string "${title_of_installer}" "\n\nOn what port do you want to connect to PHPMyAdmin?" "12345")
  sed -i "/listen 6969;/c\  listen ${port};" /etc/nginx/sites-available/default


  adduser $(who | awk '{print $1;}') www-data
  chown $(who | awk '{print $1;}'):www-data -R /usr/share/nginx/
  chmod 755 /usr/share/nginx/html
  service nginx reload
  service nginx restart

  echo "<?php phpinfo(); ?>" > /usr/share/nginx/html/info.php

  # Install PHPMyAdmin
  w_show_message "${title_of_installer}" "\n\nNext we will install PHPMyAdmin. The installer will first ask you to choose between apache2 or lighttpd but we select NOTHING and press OK. Then we enter the password again for our root user."
  sudo apt install -y phpmyadmin

  service nginx reload
  service php7.0-fpm restart

  w_show_message "${title_of_installer}" "\n\nEverything has been installed succesfully. Below you can find all the info:\n\n\
    Address:           http://${hostname}.local\n\
    Location:          /usr/share/nginx/html/\n\
    PHP test page:     http://${hostname}.local/info.php\n\
    PHPMyAdmin:        http://${hostname}.local:${port}\n\
    PHPMyAdmin user:   root\n\
    PHPMyAdmin pass:   ${DATABASE_PASS}\n\n"
}


function uninstall() {
  if ( w_ask_yesno "${title_of_installer}" "\n\nAre you sure you want to remove MySQL, NginX and PHP from your machine? this includes all data and configurations!" )
  then
    sudo service nginx stop &> /dev/null
    sudo service avahi-daemon stop &> /dev/null
    apt purge -y mysql-server php-mysql libmysqlclient-dev nginx phpmyadmin avahi-daemon &> /dev/null
    rm -rf /usr/share/nginx /etc/nginx /etc/netatalk
  fi
}

# ------------------------------------------------------------------------------

while [[ $# -ge 1 ]]
do
  key="$1"

  case $key in
      -h|--help)
      display_help true
      exit 0
      ;;
      --uninstall)
      INSTALL=false
      shift
      ;;
      --install)
      INSTALL=false
      shift
      ;;
      --change-host-name)
      change_host_name
      exit O
      ;;
      *)
      echo -e "\nUnknown argument...\n"
      display_help false
      exit 1
      ;;
  esac
done

# Check if root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root or use sudo..."
  exit 1
fi

if [ ${INSTALL} = true ]
then
  install
else
  uninstall
fi

exit 0
