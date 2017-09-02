#!/bin/bash
# With special thanks to: http://dae.me/blog/1660/concisest-guide-to-setting-up-time-machine-server-on-ubuntu-server-12-04/

# todo
# enable multi user support again --> in finder we must do: afp://<username>@server
# change host name (default = ubuntu) (what you'll see in finder left side balk)

source ./whiptail.sh
INSTALL=true
user="nas"
pass="nas"
title_of_installer="AFP File Server"

# ------------------------------------------------------------------------------

function display_help() {
  if [ $1 = true ]
  then
    echo -e "\nThis installer will setup a clean Ubuntu Server as a TimeMachine backup server.\n"
  fi
  echo "The following arguments are allowed:"
  echo -e "\t-h | --help \t\tDisplay this help message."
  echo -e "\t--install \t\tStart the installer (optional, default argument)."
  echo -e "\t--uninstall \t\tRemove everything, including all backups! (CAUTION)"
}

function ask_username() {
  user=$(w_get_string "${title_of_installer}" "\n\nWhat's the name that you want to assign to your NAS/timemachine server?\nSpaces will be truncated.\n" "${user}")

  # Remove spaces
  user=$(echo ${user} | tr -d ' ')
}

function ask_password() {
  pass=$(w_get_string "${title_of_installer}" "\n\nWhat's the password that you want to use?\n" "${pass}")
}

function install() {
  echo 'Dpkg::Progress-Fancy "1";' > /etc/apt/apt.conf.d/99progressbar # enable pretty progress bar
  w_show_message "${title_of_installer}" "\n\nThis installer will setup a clean Ubuntu Server as a AFP server (NAS and/or TimeMachine server).\n\nBefore you continue, make sure that you've set a static IP address."
  w_show_message "${title_of_installer}" "\n\nNext we will ask for a name and a password. You will need to use these credentials to add the AFP Server to your mac. So choose something logic."
  ask_username true
  ask_password

  {
    echo 0 # Start progress bar at 10% after showing 0% for half a second
    sleep 0.5
    echo 10

    # Install packages
    apt -y install netatalk > /dev/null
    echo 34
    apt -y install avahi-daemon > /dev/null
    echo 62

    # Add user
    echo "${user}" >> /var/log/custom_user # save the chosen custom user
    useradd -c ${user} -m ${user} &> /dev/null
    echo "${user}:${pass}" | chpasswd &> /dev/null
    echo 70
  } | w_show_gauge "${title_of_installer}" "\n\nPlease wait while we are installing everything..."

  # Backup configuration
  mv /etc/netatalk/AppleVolumes.default /etc/netatalk/AppleVolumes.default.old &> /dev/null
  echo ":DEFAULT: options:upriv,usedots" > /etc/netatalk/AppleVolumes.default

  if ! ( w_ask_yesno "${title_of_installer}" "\n\nDo you want to use this AFP Server as a TimeMachine backup server?" "Only as NAS" "Include TimeMachine" )
  then
    # Create timemachine folder inside user timemachine
    mkdir "/home/${user}/timemachine/" &> /dev/null
    chown -R ${user} "/home/${user}/timemachine/" &> /dev/null
    echo "/home/${user}/timemachine \"${user} - Time Machine\" options:tm allow:${user}" >> /etc/netatalk/AppleVolumes.default
  fi
  echo "/home/${user} \"${user}\" allow:${user}" >> /etc/netatalk/AppleVolumes.default

  {
    echo 78
    sleep 0.6

    # change hostname of .local
    sed -i "/host-name=/c\host-name=${user}" /etc/avahi/avahi-daemon.conf
    echo 86
    /etc/init.d/avahi-daemon stop &> /dev/null
    echo 89
    /etc/init.d/avahi-daemon start &> /dev/null
    echo 92

    # Restart netatalk and avahi
    service netatalk restart &> /dev/null
    service avahi-daemon restart &> /dev/null
    echo 100
    sleep 1
  } | w_show_gauge "${title_of_installer}" "\n\nPlease wait while we are installing everything..."

  #todo display everything
  w_show_message "${title_of_installer}" "\n\nEverything has been installed succesfully. Below you can find the credentials that you'll need:\n\n \
    Location:    afp://${user}:${pass}@${user}.local\n\n\
To connect your server, use Finder on your Mac: 'Go' -> 'Connect to server...' (or ⌘+K).\n\
A window will appear where you can enter the information that you can find above.\n\n\
Once connected, open 'System Preferences' -> 'Time Machine', click 'Select Disk...' and select your server under 'Available Disks' if you have selected to install the AFP as TimeMachine backup." ${r} ${c}
}


function uninstall() {
  if ( w_ask_yesno "${title_of_installer}" "\n\nThis installer will REMOVE all AFP data and users.\n\nare you sure you want to REMOVE EVERYTHING?" )
  then
    exit 0
  fi

  {
    echo 0 # Start progress bar at 10% after showing 0% for half a second
    sleep 0.5
    echo 10

    # Remove packages
    sudo service netatalk stop &> /dev/null
    sudo service avahi-daemon stop &> /dev/null
    apt-get -y purge netatalk avahi-daemon &> /dev/null
    echo 43
    rm -rf /etc/netatalk
    echo 90

    # Remove user + backups
    if [ -e /var/log/custom_user ]
    then
      cat /var/log/custom_user | while read line
      do
        userdel -r "${line}" &> /dev/null
      done
    fi
    rm -f /var/log/custom_user &> /dev/null

    echo 100
    sleep 1
  } | w_show_gauge "${title_of_installer}" "\n\nPlease wait while we are removing everything..."

  w_show_message "${title_of_installer}" "\n\nEverything has been removed succesfully..."
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
