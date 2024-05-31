#!/bin/bash

nume_utilizator="$1"
cale_home="/home/$nume_utilizator"

if [ -z "$nume_utilizator" ]; then
  echo "Error: Parameter is empty."
  exit 1
fi

if [ ! -d "$cale_home" ]; then
  echo "Error: Directory $cale_home does not exist."
  exit
fi

chmod u+w "$cale_home"

genereaza_raport() {
    echo "Raport pentru utilizatorul $nume_utilizator:" > "$cale_home/raport_utilizator.txt"

    numar_fisiere=$(find "$cale_home" -type f | wc -l)
    echo "Număr de fișiere: $numar_fisiere" >> "$cale_home/raport_utilizator.txt"

    numar_directoare=$(find "$cale_home" -mindepth 1 -type d | wc -l)
    echo "Număr de directoare: $numar_directoare" >> "$cale_home/raport_utilizator.txt"

    dimensiune_totala=$(du -sh "$cale_home" | awk '{print $1}')
    echo "Dimensiune totală: $dimensiune_totala" >> "$cale_home/raport_utilizator.txt"
}

genereaza_raport &

echo "Generarea raportului pentru $nume_utilizator a fost inițiată în fundal."
