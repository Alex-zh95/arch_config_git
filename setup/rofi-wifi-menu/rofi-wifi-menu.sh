#!/usr/bin/env bash

# Starts a scan of available broadcasting SSIDs
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

FIELDS=SSID,BARS,SIGNAL,SECURITY
THEME="$HOME/.config/rofi/wifi-menu-theme.rasi"

# While waiting for refresh, give a loading screen
echo -e "Auf WLAN suchen..." | rofi -dmenu -theme "$THEME" &

LIST=$(nmcli --fields "$FIELDS" device wifi list)
killall rofi

# For some reason rofi always approximates character width 2 short... hmmm
RWIDTH=$(($(echo "$LIST" | head -n 1 | awk '{print length($0); }')+2))
# Dynamically change the height of the rofi menu
LINENUM=$(echo "$LIST" | wc -l)
# Gives a list of known connections so we can parse it later
KNOWNCON=$(nmcli connection show)
# Really janky way of telling if there is currently a connection
CONSTATE=$(nmcli -fields WIFI g)

CURRSSID=$(LANGUAGE=C nmcli -t -f active,ssid dev wifi | awk -F: '$1 ~ /^yes/ {print $2}')

if [[ ! -z $CURRSSID ]]; then
	HIGHLINE=$(echo  "$(echo "$LIST" | awk -F "[  ]{2,}" '{print $1}' | grep -Fxn -m 1 "$CURRSSID" | awk -F ":" '{print $1}') + 1" | bc )
fi

# HOPEFULLY you won't need this as often as I do
# If there are more than 8 SSIDs, the menu will still only have 8 lines
if [ "$LINENUM" -gt 8 ] && [[ ! "$CONSTATE" =~ "de" ]]; then
	LINENUM=8
elif [[ "$CONSTATE" =~ "de" ]]; then
	LINENUM=1
fi

if [[ "$CONSTATE" =~ "de" ]]; then
	TOGGLE="WLAN einschalten"
else
	TOGGLE="WLAN ausschalten"
fi

CHENTRY=$(echo -e "$TOGGLE\nmanual\n\n$LIST" | uniq -u | rofi -dmenu -p "Wi-Fi SSID: " -lines "$LINENUM" -a "$HIGHLINE" -config $THEME)
#echo "$CHENTRY"
CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $1}')
#echo "$CHSSID"

# If the user inputs "manual" as their SSID in the start window, it will bring them to this screen
if [ "$CHENTRY" = "manual" ] ; then
	# Manual entry of the SSID and password (if appplicable)
	MSSID=$(echo "SSID eingeben (SSID,Passwort)" | rofi -dmenu -p "> " -lines 1 -config "$THEME")
	# Separating the password from the entered string
	MPASS=$(echo "$MSSID" | awk -F "," '{print $2}')

	#echo "$MSSID"
	#echo "$MPASS"

	# If the user entered a manual password, then use the password nmcli command
	if [ "$MPASS" = "" ]; then
		nmcli dev wifi con "$MSSID"
	else
		nmcli dev wifi con "$MSSID" password "$MPASS"
	fi

elif [ "$CHENTRY" = "WLAN einschalten" ]; then
	nmcli radio wifi on

elif [ "$CHENTRY" = "WLAN ausschalten" ]; then
	nmcli radio wifi off

else
    echo $CHSSID

	# If the connection is already in use, then this will still be able to get the SSID
	if [ "$CHSSID" = "*" ]; then
		CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $3}')
	fi

	# Parses the list of preconfigured connections to see if it already contains the chosen SSID. This speeds up the connection process
	if [[ $(echo "$KNOWNCON" | grep -o "$CHSSID") =~ "$CHSSID" ]]; then
		nmcli con up "$CHSSID"
	else
		if [[ "$CHENTRY" =~ "WPA2" ]] || [[ "$CHENTRY" =~ "WEP" ]]; then
			WIFIPASS=$(echo "Verbindung hinzufügen" | rofi -dmenu -p "password: " -lines 1 -config "$THEME")
		fi

        # Select the ssid via the command `nmcli dev wifi con`
		nmcli dev wifi con "$CHSSID" password "$WIFIPASS"
	fi

fi
