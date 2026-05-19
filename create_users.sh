#!/bin/bash

#skapar användare och mappar åt dom

# måste vara root annars funkar det inte
if [ "$EUID" -ne 0 ]; then
    echo "kör som root"
    exit 1
fi

#loopar igenom namnen man skriver in
for username in "$@"; do

    # om användaren finns redan hoppar vi över
    if id "$username" &>/dev/null; then
        echo "$username finns redan"
        continue
    fi

    #skapar själva användaren
    useradd -m "$username"
    echo "skapade $username"

    homedir="/home/$username"

    #skapar mapparna i hemkatalogen
    mkdir -p "$homedir/Documents"
    mkdir -p "$homedir/Downloads"
    mkdir -p "$homedir/Work"

    # bara ägaren ska komma åt mapparna
    chmod 700 "$homedir/Documents"
    chmod 700 "$homedir/Downloads"
    chmod 700 "$homedir/Work"

    #välkomstfilen
    echo "Välkommen $username" > "$homedir/welcome.txt"
    echo "" >> "$homedir/welcome.txt"

    # lägger till vilka andra användare som finns
    echo "Andra användare i systemet:" >> "$homedir/welcome.txt"
    cut -d: -f1 /etc/passwd >> "$homedir/welcome.txt"

    # ger användaren äganderätt till sin mapp
    chown -R "$username":"$username" "$homedir"

done

echo "klart"
