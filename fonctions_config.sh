# fonction de configuration
config() {
echo "Quelle $1 voulez-vous ? $3"
read -p "" reponse 
while ! [[ "$reponse" =~ ^[A-Za-z0-9_.:-]+$ ]]
do
    echo ""
    echo "Veuillez utiliser uniquement des lettres, chiffres, et les caracteres _ - . :"
    read -p "Quelle $1 voulez-vous ? $3" reponse
done
if cat server.properties | grep "$2"
then 
    sed -i "s/$2=.*/$2=$reponse/" server.properties
else
    echo "$2="$reponse"" >> server.properties
fi
}
#fonction du nombre de ram
fonction_ram() {
    local type_ram="$1"
    read -p "Combien de ram $type_ram souhaitez-vous allouer ? " ram
    while ! [[ "$ram" =~ ^[1-9][0-9]*$ ]]
    do
        echo ""
        echo "Veuillez rentrer un nombre valide"
        read -p "Combien de ram $type_ram souhaitez-vous allouer ? " ram
        echo ""
    done
}