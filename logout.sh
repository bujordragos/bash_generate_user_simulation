#!/bin/bash

utilizatori_logati="/home/dragos/proiect/utilizatori_logati"

logout_utilizator() {
    echo "Utilizatori autentificați în prezent:"
    if [ -s "$utilizatori_logati" ]; then  
        cat "$utilizatori_logati"
    else
        echo "Nu există utilizatori autentificați."
    fi

    echo "Introdu numele de utilizator pentru delogare:"
    read nume_utilizator

    if grep -q "^$nume_utilizator$" "$utilizatori_logati"; then
        sed -i "/^$nume_utilizator$/d" "$utilizatori_logati"
        echo "Utilizatorul $nume_utilizator a fost deconectat."
    else
        echo "Utilizatorul $nume_utilizator nu este autentificat."
    fi
}

logout_utilizator
