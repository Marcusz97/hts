#!/bin/bash -
#title          :hts.sh
#description    :Hybrid multipurpose (console/container) terminal server.
#author         :Stefano Stagnaro
#date           :20151118
#version        :0.1
#usage          :./hts.sh
#notes          :visit https://github.com/ninth9ste/hts for more help.
#bash_version   :4.2.46(1)-release
#============================================================================

# Variabili globali
hts_companyname="eForHum"
hts_podname="POD1CCNA" #Potrebbe essere uguale a "$USERNAME"
hts_dialog_height=20
hts_dialog_width=70
hts_dialog_menuheight=20

hts_mainmenu () {

	hts_mainmenu_loop=0
	while [ $hts_mainmenu_loop -eq 0 ]; do

		# Duplico il file descriptor 1 sul descriptor 3 per gestire l'output di dialog
		exec 3>&1

		hts_dialog_result=$(dialog --title "$hts_companyname Terminal Server" \
	 	--menu "		Scegliere a quale apparato connettersi: \n
		Per uscire da un apparato premere CTRL+a seguito da x" \
	 	$hts_dialog_height $hts_dialog_width $hts_dialog_menuheight \
	 	1 "$hts_podname S1" \
	 	2 "$hts_podname S2" \
	 	3 "$hts_podname S3" \
	 	4 "$hts_podname R1" \
	 	5 "$hts_podname R2" \
	 	6 "$hts_podname R3" \
	 	7 "$hts_podname PC1" \
	 	8 "$hts_podname PC2" \
	 	9 "$hts_podname PC3" 2>&1 1>&3)

		# Recupero l'exit status di dialog
		hts_dialog_return=$?

		# Chiudo il file descriptor 3
		exec 3>&-

		if [ $hts_dialog_return -eq 0 ]; then
			case $hts_dialog_result in
				[1-6])
					hts_console $hts_dialog_result
					hts_mainmenu_loop=$?
					;;
				[7-9])
					hts_container $hts_dialog_result
					hts_mainmenu_loop=$?
					;;
			esac
		else
			hts_mainmenu_loop=1
		fi

	done
}

hts_console () {
	clear
	echo -e "Connessione all'apparato $1\n"
	# TODO inserire il codice per minicom
	sleep 2
	return 0
}

hts_container () {
	clear
	echo -e "Creazione del container $1\n"
	# TODO inerrire il codice per LXC
	sleep 2
	return 0
}

# TODO test software: dipendenze, LXC, ssh, minicom...
# TODO test hardware: schede seriali...

hts_mainmenu

exit 0
