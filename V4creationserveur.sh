#!/bin/bash
###########################################
# Creator : Djnm-Chiva                      #
# Object  : Creation de serveur automatise  #
# Creation Date : 04/10/2026                #
# Last Modification : 21/10/2026            #
###########################################

#variable
USER_AGENT="V4creationserveur.sh (https://github.com/Djnm-Chiva)"
req_java=25
here=$(dirname "$0")
status_curl=$(curl --version > /dev/null 2>&1; echo $?)
status_wget=$(wget --version > /dev/null 2>&1; echo $?)
status_jq=$(jq --version > /dev/null 2>&1; echo $?)
status_screen=$(screen --version > /dev/null 2>&1; echo $?)
version_java=$(java -version 2>&1 | head -n 1 | cut -d '"' -f 2 | cut -d '.' -f 1)
#endvariable
#
source "$here/fonctions_systeme.sh"
source "$here/fonctions_api.sh"
source "$here/fonctions_config.sh"
source "$here/fonctions_plugins.sh"
#
#########################################################################################################################################
#
echo "Lancement de la creation du serveur"
echo ""
echo "1/7 - Verification des paquets necessaire"
echo ""
sudo apt update
sudo apt upgrade -y
check_paquet "$status_curl"   "curl"   "curl"
check_paquet "$status_wget"   "wget"   "wget"
check_paquet "$status_jq"     "jq"     "jq"
check_paquet "$status_screen" "screen" "screen"
if [[ "$version_java" -ge $req_java ]]
then 
    echo "Java est deja installe"
else 
    sudo apt install openjdk-$req_java-jre -y
    echo "Java a ete installe"
fi

until [[ -n "$how" && ! -d "$how" ]]; 
do
    echo "Dans quel dossier souhaitez-vous cree le serveur ?"
    read -p "" how
    if [[ -d "$how" ]]; 
    then
        echo "Le dossier "$how" existe deja. Etes-vous sur de vouloir continuer ? (oui/non)"
        read -p "" confirm_how
        if [[ ! "$confirm_how" == oui ]]; 
        then
            continue
        else
        break
        fi
    fi
done
mkdir -p "$how"
cd "$how"
server_here=$(pwd)
until [[ "$eula" == "oui" || "$eula" == "non" ]]
do
    echo "Acceptez-vous le contrat de licence utilisateur final (EULA) ? (oui/non)"
    read -p "" eula
done
if [[ "$eula" == "oui" ]]
then
    echo eula=true > eula.txt
else
    echo "Vous n'acceptez pas le contrat de licence d'utilisateur final"
    echo "Le script ne peut continuer sans cet accord" 
    exit
fi

echo "2/7 - Selection d'API et selection de version"
echo ""
until select_api
do
echo ""
done
echo "3/7 - Plugins/mods"
echo ""
if [[ "$api" == "purpur" || "$api" == "paper" ]]
then
    add_mod_plugin_datapack "plugins"
elif [[ "$api" == "fabric" ]]
then
    add_mod_plugin_datapack "mods"
else
    echo "Minecraft server vanilla ne peut pas faire tourner des mods ou plugins"
    echo ""
fi

echo "4/7 - Datapack"
echo ""
add_mod_plugin_datapack "datapacks" "world/"
    
echo "5/7 - Le script de lancement du serveur va etre cree"
echo ""
fonction_ram "min" 
ram_min="$ram"
fonction_ram "max"
ram_max="$ram"
while [ "$ram_max" -lt "$ram_min" ] ; 
do 
    echo "La valeur maximal ne peut etre inferieure a la valeur minimale"
    fonction_ram "min"
    ram_min="$ram"
    fonction_ram "max"
    ram_max="$ram"
done
echo "Vous venez d'allouer ${ram_min}Go minimum et ${ram_max}Go maximum de ram"
echo ""
echo '#!/bin/bash' > start.sh
echo 'here=$(dirname "$0")' >> start.sh
echo 'cd "$here"' >> start.sh
echo "screen -S server_minecraft -d -m java -Xmx"$ram_max"G -Xms"$ram_min"G -jar server.jar nogui" >> start.sh
chmod +x start.sh
echo "Creation termine"
echo ""

echo 6/7 - Configuration avancee
echo "Voulez-vous entree dans la configuration avancer ? (oui/non)"
read -p "" advanced_configuration 
if [[ $advanced_configuration == oui ]]
then
    touch "server.properties"
    PS3="Quel option voulez-vous modifier ? (1-8)"
    select configuration in "nom du serveur" "ip" "port" "difficulte" "seed" "whitelist" "texturepack" "retour";
    do 
    case "$configuration" in
        "nom du serveur")
            config "nom" "motd"
            REPLY=''
            ;;
        "ip")
            config "ip" "server-ip"
            REPLY=''
            ;;
        "port")
            config "port" "server-port"
            REPLY=''
            ;;
        "difficulte")
            config "difficulte" "difficulty"
            REPLY=''
            ;;
        "seed")
            config "seed" "level-seed"
            REPLY=''
            ;;
        "whitelist")
            config "whitelist" "white-list" "(true/false)"
            REPLY=''
            ;;
        "texturepack")
            echo "Veuillez entrer le lien du texture pack"
            read -p "" ressource_pack
            echo "resource-pack-id="$ressource_pack"" >> server.properties
            echo "veuillez entrer le sha1 du texture pack"
            read -p "" ressource_pack_sha
            echo "resource-pack-sha1="$ressource_pack_sha"" >> server.properties
            REPLY=''
            ;;
        "retour")
            break
            ;;
        esac
    done
fi

echo "7/7 - Demarage du serveur"
echo ""
read -p "Voulez-vous demarrer le serveur ? (oui/non) :" start
if [ "$start" == "oui" ]
then    
    echo "Le serveur va demarrer"
    echo ""
    "$server_here"/start.sh
else 
    echo "Le serveur est pret, vous pouvez lancer le script avec ./start.sh"
    echo "Il se trouve dans $server_here"
    echo ""
fi