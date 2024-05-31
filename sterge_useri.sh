#!/bin/bash

UTILIZATORI_CSV="/home/dragos/proiect/utilizatori.csv"


verifica_existenta_utilizator() {
    nume_utilizator=$1
    if grep -q "^$nume_utilizator," "$UTILIZATORI_CSV"; then
        return 0
    else
        return 1
    fi
}

sterge_utilizator() {
    echo "Introdu numele de utilizator pe care dorești să-l ștergi:"
    read nume_utilizator

    if ! verifica_existenta_utilizator "$nume_utilizator"; then
        echo "Utilizatorul $nume_utilizator nu există în baza de date."
        return
    fi

    cale_home="/home/$nume_utilizator"

    sudo rm -rf $cale_home
    if [ $? -eq 0 ]; then
        echo "/home/$nume_utilizator a fost șters cu succes."
    else
        echo "A apărut o eroare în timpul ștergerii directorului /home/$nume_utilizator."
    fi

    grep -v "^$nume_utilizator," "$UTILIZATORI_CSV" > "$UTILIZATORI_CSV.tmp" && mv "$UTILIZATORI_CSV.tmp" "$UTILIZATORI_CSV"

    if [ $? -eq 0 ]; then
        echo "Utilizatorul $nume_utilizator a fost șters cu succes din baza de date."
    else
        echo "A apărut o eroare în timpul ștergerii utilizatorului $nume_utilizator."
    fi
}

main() {
    if [ "$PWD" == "/home/admin" ]; then
        echo "Admin-ul s-a autentificat, alegeti userul pentru a-l sterge."
        cat /home/dragos/proiect/utilizatori.csv | cut -d ',' -f 1 | grep -v '^admin$'
        sterge_utilizator
    else
        echo "Doar utilizatorul admin are dreptul să folosească acest script."
        exit 1
    fi
}

main