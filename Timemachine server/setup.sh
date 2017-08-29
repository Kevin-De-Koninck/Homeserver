#!/bin/bash
# With special thanks to: http://dae.me/blog/1660/concisest-guide-to-setting-up-time-machine-server-on-ubuntu-server-12-04/

# todo
# enable multi user support again --> in finder we must do: afp://<username>@server
# change host name (default = ubuntu) (what you'll see in finder left side balk)

source ./whiptail.sh
INSTALL=true
user="MacBookPro15"
pass="MacBookPro15"
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
  # echo -e "\t--add-user \t\tAdd another user/timemachine drive."
  # echo -e "\t--remove-user \t\tRemove a user/timemachine drive completely (not undo-able). (CAUTION)"
  echo -e "\t--uninstall \t\tRemove everything, including all backups! (CAUTION)"
}

function ask_username() {
  if $1 = true
  then
    user=$(w_get_string "${title_of_installer}" "\n\nWhat's the username that you want to assign?\nSpaces will be truncated.\n" "${user}")
  else
    user=$(w_get_string "${title_of_installer} - delete" "\n\nWhat's the username that you want to remove?\nSpaces will be truncated.\n" "${user}")
  fi

  # Remove spaces
  user=$(echo ${user} | tr -d ' ')
}

function ask_password() {
  pass=$(w_get_string "${title_of_installer}" "\n\nWhat's the password that you want to use?\n" "${pass}")
}

function install() {
  w_show_message "${title_of_installer}" "\n\nThis installer will setup a clean Ubuntu Server as a AFP server (NAS and/or TimeMachine server).\n\nBefore you continue, make sure that you've set a static IP address."
  w_show_message "${title_of_installer}" "\n\nNext we will ask for a username and a password. You will need to use these credentials to add the AFP Server to your mac. So choose something logic."
  ask_username true
  ask_password

  {
    echo 0 # Start progress bar at 10% after showing 0% for half a second
    sleep 0.5
    echo 10

    # Install packages
    apt-get -y install netatalk > /dev/null
    echo 34
    apt-get -y install avahi-daemon > /dev/null
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

  if ( w_ask_yesno "${title_of_installer}" "\n\nDo you want to use this AFP Server as a TimeMachine backup server?" "Only as NAS" "As TimeMachine server" )
  then
    # Create timemachine folder inside user timemachine
    mkdir "/home/${user}/timemachine/" &> /dev/null
    chown -R ${user} "/home/${user}/timemachine/" &> /dev/null
    echo "/home/${user}/timemachine \"${user} - Time Machine\" options:tm allow:${user}" >> /etc/netatalk/AppleVolumes.default
  else
    echo "/home/${user} \"${user}\" allow:${user}" >> /etc/netatalk/AppleVolumes.default
  fi
  {
    echo 78
    sleep 0.6
    echo 92

    # Restart netatalk and avahi
    sudo service netatalk restart &> /dev/null
    service avahi-daemon restart &> /dev/null
    echo 100
    sleep 1
  } | w_show_gauge "${title_of_installer}" "\n\nPlease wait while we are installing everything..."

  # Get IP-address of server
  ip_address=$(hostname -I)


  #todo display everything
  w_show_message "${title_of_installer}" "\n\nEverything has been installed succesfully. Below you can find the credentials that you'll need:\n\n \
    Location:    afp://${user}@${ip_address}\n \
    Username:    ${user}\n \
    Password:    ${pass}\n\n\
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
    apt-get -y purge netatalk &> /dev/null
    echo 43
    apt-get -y purge avahi-daemon &> /dev/null
    echo 88
    rm -rf /etc/netatalk
    echo 90

    # Remove user + backups
    cat /var/log/custom_user | while read line
    do
      userdel -r "${line}" &> /dev/null
    done
    rm -f /var/log/custom_user &> /dev/null

    echo 100
    sleep 1
  } | w_show_gauge "${title_of_installer}" "\n\nPlease wait while we are removing everything..."

  w_show_message "${title_of_installer}" "\n\nEverything has been removed succesfully..."
}

function add_user() {
  # First check if the install has already run.
  if ! service --status-all | grep 'netatalk' &> /dev/null
  then
    w_show_message "${title_of_installer}" "\n\nPlease install everything before adding a second or more users.\nTo install, use the following command:\n\n     sudo ./setup.sh"
    exit 1
  fi

  w_show_message "${title_of_installer}" "\n\nThis installer will create a new user/AFP drive."
  w_show_message "${title_of_installer}" "\n\nNext we will ask for a username and a password. You will need to use these credentials to add the AFP Server to your mac. So choose something logic."
  ask_username true
  ask_password

  {
    echo 0 # Start progress bar at 10% after showing 0% for half a second
    sleep 0.5
    echo 10

    # Add user
    echo "${user}" >> /var/log/custom_user # save the chosen custom user
    useradd -c ${user} -m ${user} &> /dev/null
    echo "${user}:${pass}" | chpasswd &> /dev/null
    echo 70
  } | w_show_gauge "${title_of_installer}" "\n\nPlease wait while we are installing everything..."

  if ( w_ask_yesno "${title_of_installer}" "\n\nDo you want to use this AFP Server as a TimeMachine backup server?" "Only as NAS" "As TimeMachine server" )
  then
    # Create timemachine folder inside user timemachine
    mkdir "/home/${user}/timemachine/" &> /dev/null
    chown -R ${user} "/home/${user}/timemachine/" &> /dev/null
    echo "/home/${user}/timemachine \"${user} - Time Machine\" options:tm allow:${user}" >> /etc/netatalk/AppleVolumes.default
  else
    echo "/home/${user} \"${user}\" allow:${user}" >> /etc/netatalk/AppleVolumes.default
  fi

  {
    # Restart netatalk
    sudo service netatalk restart &> /dev/null
    echo 100
    sleep 1
  } | w_show_gauge "${title_of_installer}" "\n\nPlease wait while we are installing everything..."

  # Get IP-address of server
  ip_address=$(hostname -I)


  #todo display everything
  w_show_message "${title_of_installer}" "\n\nEverything has been installed succesfully. Below you can find the credentials that you'll need to configure TimeMachine backups:\n\n \
    Location:    afp://${user}@${ip_address}\n \
    Username:    ${user}\n \
    Password:    ${pass}\n\n\
To connect your server, use Finder on your Mac: 'Go' -> 'Connect to server...' (or ⌘+K).\n\
A window will appear where you can enter the information that you can find above.\n\n\
Once connected, open 'System Preferences' -> 'Time Machine', click 'Select Disk...' and select your server under 'Available Disks'."
}

function remove_user() {
  if ! service --status-all | grep 'netatalk' &> /dev/null
  then
    w_show_message "${title_of_installer}" w_show_message "\n\nNothing to remove, everything has been unstalled."
    exit 1
  fi
  ask_username false

  sed -i "/${user}/d" /var/log/custom_user &> /dev/null
  userdel -r "${user}" &> /dev/null
  sed -i "/${user}/d" /etc/netatalk/AppleVolumes.default &> /dev/null

  # Restart netatalk
  sudo service netatalk restart &> /dev/null

  w_show_message "${title_of_installer}" "\n\nUser and the files/backups have been unstalled."
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
      --add-user)
      add_user
      exit 0
      ;;
      --remove-user)
      remove_user
      exit 0
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
