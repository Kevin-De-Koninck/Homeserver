# Find the rows and columns will default to 80x24 is it can not be detected
screen_size=$(stty size 2>/dev/null || echo 24 80)
rows=$(echo "${screen_size}" | awk '{print $1}')
columns=$(echo "${screen_size}" | awk '{print $2}')

# Divide by two so the dialogs take up half of the screen, which looks nice.
r_whiptail=$(( rows / 2 ))
c_whiptail=$(( columns / 2 ))
# Unless the screen is tiny
r_whiptail=$(( r_whiptail < 20 ? 20 : r_whiptail ))
c_whiptail=$(( c_whiptail < 70 ? 70 : c_whiptail ))

# $1: title
# $2: text
function w_show_message {
  whiptail --title "${1}" --msgbox "${2}" ${r_whiptail} ${c_whiptail}
}

# $1: title
# $2: text
# $3: placeholder
# $4: Allow empty
function w_get_string {
  text=$(whiptail --inputbox "${2}" ${r_whiptail} ${c_whiptail} "${3}" --title "${1}" 3>&1 1>&2 2>&3)

  if ! [ -z $4 ]; then
    if [ $? -ne 0 ]; then
        echo "Empty strings are not allowed... Exiting..."
         exit 1
    fi
    user_len=$(echo ${#user})
    if [ ${user_len} -le 0 ]; then
        echo "Empty strings are not allowed... Exiting..."
        exit 1
    fi
  fi

  echo $text
}

# $1: title
# $2: text
# $3: percent
function w_show_gauge {
  read percent
  whiptail --title "${1}" --gauge "${2}" 8 ${c_whiptail} ${percent}
}

# $1: title
# $2: text
# $3: Yes text (optional)
# $4: text (optional)
function w_ask_yesno {
  if ! [ -z "${3}" ]; then w_yes=${3}; else w_yes="Yes"; fi
  if ! [ -z "${4}" ]; then w_no=${4}; else w_no="No"; fi

  if ( whiptail --title "${1}" --yesno "${2}" --yes-button "${w_yes}" --no-button "${w_no}" ${r_whiptail} ${c_whiptail} )
  then # no
    return 0
  else # yes
    return 1
  fi
}
