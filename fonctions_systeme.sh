#fonction de vérification de paquets
check_paquet() {
if [[ "$1" -eq "0" ]]
then 
    echo ""
    echo "$2" "est deja installe"
    echo ""
else
    echo "$2" "n'est pas encore installe ou ne possede pas la bonne version"
    echo "$2" "va etre installe"
    sudo apt install "$3" -y
    echo ""
fi
}

