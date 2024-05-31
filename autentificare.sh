#!/bin/bash

UTILIZATORI_CSV="/home/dragos/proiect/utilizatori.csv"
utilizatori_logati="/home/dragos/proiect/utilizatori_logati"

verifica_existenta_utilizator() {
    nume_utilizator=$1
    if grep -q "^$nume_utilizator," "$UTILIZATORI_CSV"; then
        return 0
    else
        echo "Utilizatorul $nume_utilizator nu există."
        return 1
    fi
}

actualizeaza_last_login() {
    nume_utilizator=$1
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    sed -i "/^$nume_utilizator,/s/\(.*,\)\([^,]*\)$/\1$timestamp/" "$UTILIZATORI_CSV"
}

autentificare_utilizator() {
    echo "Introdu numele de utilizator pentru autentificare:"
    read nume_utilizator
    if ! verifica_existenta_utilizator "$nume_utilizator"; then
        echo "Nume de utilizator inexistent. Te rog să introduci un nume de utilizator valid."
        autentificare_utilizator
        return
    fi

    echo "Introdu parola:"
    read -s parola
    linie_utilizator=$(grep "^$nume_utilizator," $UTILIZATORI_CSV)
    if [ -z "$linie_utilizator" ]; then
        echo "Eroare la citirea informațiilor utilizatorului. Te rog să încerci din nou."
        autentificare_utilizator
        return
    fi
    parola_salvata=$(echo "$linie_utilizator" | cut -d ',' -f 3)
    if [ "$parola" == "$parola_salvata" ]; then
        echo "Autentificare reușită."
        cale_home="/home/$nume_utilizator"
        cd "$cale_home" || { echo "Eroare"; return; }
        actualizeaza_last_login "$nume_utilizator"

        if ! grep -q "^$nume_utilizator$" "$utilizatori_logati"; then
            echo "$nume_utilizator" >> "$utilizatori_logati"
        fi

        echo "Utilizatorul $nume_utilizator s-a autentificat și a fost mutat în $cale_home."
    else
        echo "Parola incorectă."
        return
    fi
}


autentificare_utilizator

if [ $? -eq 0 ]; then
    exec bash -l 
fi
