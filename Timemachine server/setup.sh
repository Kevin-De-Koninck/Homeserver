#!/bin/bash
# With special thanks to: http://dae.me/blog/1660/concisest-guide-to-setting-up-time-machine-server-on-ubuntu-server-12-04/

INSTALL=true
tm_user="MacBookPro15"
tm_pass="MacBookPro15"

# Find the rows and columns will default to 80x24 is it can not be detected
screen_size=$(stty size 2>/dev/null || echo 24 80)
rows=$(echo "${screen_size}" | awk '{print $1}')
columns=$(echo "${screen_size}" | awk '{print $2}')

# Divide by two so the dialogs take up half of the screen, which looks nice.
r=$(( rows / 2 ))
c=$(( columns / 2 ))
# Unless the screen is tiny
r=$(( r < 20 ? 20 : r ))
c=$(( c < 70 ? 70 : c ))

# ------------------------------------------------------------------------------

function display_help() {
  if [ $1 = true ]
  then
    echo -e "\nThis installer will setup a clean Ubuntu Server as a TimeMachine backup server.\n"
  fi
  echo "The following arguments are allowed:"
  echo -e "\t-h | --help \t\tDisplay this help message."
  echo -e "\t--install \t\tStart the installer (optional, default argument)."
  echo -e "\t--add-user \t\tAdd another user/timemachine drive."
  echo -e "\t--remove-user \t\tRemove a user/timemachine drive completely (not undo-able). (CAUTION)"
  echo -e "\t--uninstall \t\tRemove everything, including all backups! (CAUTION)"
}

function ask_username() {
  if $1 = true
  then
    tm_user=$(whiptail --inputbox "\n\nWhat's the username that you want to assign?\nSpaces will be truncated.\n" ${r} ${c} "${tm_user}" --title "TimeMachine server installer" 3>&1 1>&2 2>&3)
  else
    tm_user=$(whiptail --inputbox "\n\nWhat's the username that you want to remove?\nSpaces will be truncated.\n" ${r} ${c} "${tm_user}" --title "TimeMachine server installer - delete" 3>&1 1>&2 2>&3)
  fi

  if [ $? -ne 0 ]; then
      echo "You must provide a name... Exiting..."
      exit 1
  fi
  tm_user_len=$(echo ${#tm_user})
  if [ ${tm_user_len} -le 0 ]; then
      echo "The name can't be empty... Exiting..."
      exit 1
  fi

  # Remove spaces
  tm_user=$(echo ${tm_user} | tr -d ' ')
}

function ask_password() {
  tm_pass=$(whiptail --inputbox "\n\nWhat's the password that you want to use?\n" ${r} ${c} "${tm_pass}" --title "TimeMachine server installer" 3>&1 1>&2 2>&3)
  if [ $? -ne 0 ]; then
      echo "You must provide a password... Exiting..."
      exit 1
  fi
  tm_pass_len=$(echo ${#tm_user})
  if [ ${tm_pass_len} -le 0 ]; then
      echo "The password can't be empty... Exiting..."
      exit 1
  fi
}

function install() {
  whiptail --title "TimeMachine server installer" --msgbox "\n\nThis installer will setup a clean Ubuntu Server as a TimeMachine backup server.\n\nBefore you continue, make sure that you've set a static IP address." ${r} ${c}
  whiptail --title "TimeMachine server installer" --msgbox "\n\nNext we will ask for a username and a password. You will need to use these credentials to add the TimeMachine Server to your mac. So choose something logic." ${r} ${c}
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

    # make it appear as Xserve in Finder
    code='<?xml version="1.0" standalone="no"?><!DOCTYPE service-group SYSTEM "avahi-service.dtd"><service-group><name replace-wildcards="yes">%h</name><service><type>_device-info._tcp</type><port>0</port><txt-record>model=Xserve</txt-record></service></service-group>'
    echo ${code} >> /etc/avahi/services/afpd.service

    # Add user
    echo "${tm_user}" >> /var/log/custom_tm_user # save the chosen custom user
    useradd -c ${tm_user} -m ${tm_user} &> /dev/null
    echo "${tm_user}:${tm_pass}" | chpasswd &> /dev/null
    echo 70

    # Create timemachine folder inside user timemachine
    mkdir "/home/${tm_user}/timemachine/" &> /dev/null
    chown -R ${tm_user} "/home/${tm_user}/timemachine/" &> /dev/null
    echo 78

    # Backup configuration
    mv /etc/netatalk/AppleVolumes.default /etc/netatalk/AppleVolumes.default.old &> /dev/null

    # Create new config file
    echo ":DEFAULT: options:upriv,usedots" > /etc/netatalk/AppleVolumes.default
    echo "/home/${tm_user}/timemachine \"${tm_user} - Time Machine\" options:tm allow:${tm_user}" >> /etc/netatalk/AppleVolumes.default
    echo 92

    # Restart netatalk and avahi
    sudo service netatalk restart &> /dev/null
    service avahi-daemon restart &> /dev/null
    echo 100
    sleep 1
  } | whiptail --title "TimeMachine server installer" --gauge "\n\nPlease wait while we are installing everything..." 8 ${c} 0

  # Get IP-address of server
  ip_address=$(hostname -I)


  #todo display everything
  whiptail --title "TimeMachine server installer" --msgbox "\n\nEverything has been installed succesfully. Below you can find the credentials that you'll need to configure TimeMachine backups:\n\n \
    Location:    afp://${ip_address}\n \
    Username:    ${tm_user}\n \
    Password:    ${tm_pass}\n\n\
To connect your server, use Finder on your Mac: 'Go' -> 'Connect to server...' (or ⌘+K).\n\
A window will appear where you can enter the information that you can find above.\n\n\
Once connected, open 'System Preferences' -> 'Time Machine', click 'Select Disk...' and select your server under 'Available Disks'." ${r} ${c}
}


function uninstall() {
  if ! ( whiptail --title "TimeMachine server installer" --yesno "\n\nThis installer will REMOVE all TimeMachine data and users.\n\nare you sure you want to REMOVE EVERYTHING?" ${r} ${c} )
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
    cat /var/log/custom_tm_user | while read line
    do
      userdel -r "${line}" &> /dev/null
    done
    rm -f /var/log/custom_tm_user &> /dev/null

    echo 100
    sleep 1
  } | whiptail --title "TimeMachine server installer" --gauge "\n\nPlease wait while we are removing everything..." 8 ${c} 0

  whiptail --title "TimeMachine server installer" --msgbox "\n\nEverything has been removed succesfully..." ${r} ${c}
}

function add_user() {
  # First check if the install has already run.
  if ! service --status-all | grep 'netatalk' &> /dev/null
  then
    whiptail --title "TimeMachine server installer" --msgbox "\n\nPlease install everything before adding a second or more users.\nTo install, use the following command:\n\n     sudo ./setup.sh" ${r} ${c}
    exit 1
  fi

  whiptail --title "TimeMachine server installer" --msgbox "\n\nThis installer will create a new user/timemachine drive." ${r} ${c}
  whiptail --title "TimeMachine server installer" --msgbox "\n\nNext we will ask for a username and a password. You will need to use these credentials to add the TimeMachine Server to your mac. So choose something logic." ${r} ${c}
  ask_username true
  ask_password

  {
    echo 0 # Start progress bar at 10% after showing 0% for half a second
    sleep 0.5
    echo 10

    # Add user
    echo "${tm_user}" >> /var/log/custom_tm_user # save the chosen custom user
    useradd -c ${tm_user} -m ${tm_user} &> /dev/null
    echo "${tm_user}:${tm_pass}" | chpasswd &> /dev/null
    echo 70

    # Create timemachine folder for each user
    mkdir "/home/${tm_user}/timemachine/" &> /dev/null
    chown -R ${tm_user} "/home/${tm_user}/timemachine/" &> /dev/null
    echo 78

    # Create new config file
    echo ":DEFAULT: options:upriv,usedots" >> /etc/netatalk/AppleVolumes.default
    echo "/home/${tm_user}/timemachine \"${tm_user} - Time Machine\" options:tm allow:${tm_user}" >> /etc/netatalk/AppleVolumes.default
    echo 92

    # Restart netatalk
    sudo service netatalk restart &> /dev/null
    echo 100
    sleep 1
  } | whiptail --title "TimeMachine server installer" --gauge "\n\nPlease wait while we are installing everything..." 8 ${c} 0

  # Get IP-address of server
  ip_address=$(hostname -I)


  #todo display everything
  whiptail --title "TimeMachine server installer" --msgbox "\n\nEverything has been installed succesfully. Below you can find the credentials that you'll need to configure TimeMachine backups:\n\n \
    Location:    afp://${ip_address}\n \
    Username:    ${tm_user}\n \
    Password:    ${tm_pass}\n\n\
To connect your server, use Finder on your Mac: 'Go' -> 'Connect to server...' (or ⌘+K).\n\
A window will appear where you can enter the information that you can find above.\n\n\
Once connected, open 'System Preferences' -> 'Time Machine', click 'Select Disk...' and select your server under 'Available Disks'." ${r} ${c}
}

function remove_user() {
  if ! service --status-all | grep 'netatalk' &> /dev/null
  then
    whiptail --title "TimeMachine server installer" --msgbox "\n\nNothing to remove, everything has been unstalled." ${r} ${c}
    exit 1
  fi
  ask_username false

  sed -i "/${tm_user}/d" /var/log/custom_tm_user &> /dev/null
  userdel -r "${tm_user}" &> /dev/null
  sed -i "/${tm_user}/d" /etc/netatalk/AppleVolumes.default &> /dev/null

  # Restart netatalk
  sudo service netatalk restart &> /dev/null

  whiptail --title "TimeMachine server - remove user" --msgbox "\n\nUser and the files/backups have been unstalled." ${r} ${c}
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