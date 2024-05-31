#!/bin/bash

UTILIZATORI_CSV="/home/dragos/proiect/utilizatori.csv" 

verifica_existenta_utilizator() {
    nume_utilizator=$1
    if grep -q "^$nume_utilizator," $UTILIZATORI_CSV; then
        echo "Utilizatorul $nume_utilizator există deja."
        return 1
    else
        return 0
    fi
}

verifica_existenta_email() {
    email=$1
    if grep -q ",$email," $UTILIZATORI_CSV; then
        echo "Adresa de email $email este deja folosită. Te rog să introduci o altă adresă de email."
        return 1
    else
        return 0
    fi
}

adauga_utilizator_csv() {
    nume_utilizator=$1
    email=$2
    parola=$3
    id=$4
    echo "$nume_utilizator,$email,$parola,$id,"$(date '+%Y-%m-%d %H:%M:%S')"" >> $UTILIZATORI_CSV
}

creaza_director_home() {
    nume_utilizator=$1
    cale_home="/home/$nume_utilizator"
    sudo mkdir -p "$cale_home"
}

creaza_id_unic() {
    echo $(uuidgen)
}

preia_date_utilizator() {
    echo "Introdu numele utilizatorului:"
    read nume_utilizator

    if verifica_existenta_utilizator "$nume_utilizator"; then
        while true; do
            echo "Introdu adresa de email a utilizatorului:"
             read email
             if verifica_existenta_email "$email"; then
                 break
            fi
         done

        if ! [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
            echo "Adresa de email nu este validă."
            exit 1
        fi

        echo "Introdu parola utilizatorului:"
        read -s parola
        if (( ${#parola} < 8 )) || ! [[ "$parola" =~ [[:punct:]] ]] || ! [[ "$parola" =~ [0-9] ]]; then
            echo "Parola trebuie să aibă cel puțin 8 caractere, un caracter special și un număr."
            exit 1
        fi
    fi
}


preia_nota() {
    while true; do
        echo "Introdu nota pentru materia 'Sisteme de Operare' (1-10):"
        read nota
        if [[ "$nota" =~ ^[1-9]$|^10$ ]]; then
            case $nota in
                10) echo "bravo bobita";;
                9)  echo "cat de aproape...";;
                8)  echo "плохой результат";;
                7)  echo "merge, da mai uita-te pe mihai-gheorghe.gitbook.io";;
                6)  echo "trece, da puteai mai bine sefule";;
                5)  echo "la mustață! mai vezi un tutorial";;
                4)  echo "ne vedem la vara";;
                3)  echo "nici cu chatgpt nu te descurci?";;
                2)  echo "nu ti-e rusine?";;
                1)  echo "mai bine te apuci de pescuit";;
            esac
            break
        else
            echo "Te rog să introduci o notă validă între 1 și 10."
        fi
    done
}

preia_date_utilizator
id=$(creaza_id_unic)
adauga_utilizator_csv "$nume_utilizator" "$email" "$parola" "$id"
creaza_director_home "$nume_utilizator"
preia_nota

echo "Utilizatorul a fost înregistrat cu succes."
