#fonction de sélection d'API
select_api () { 
PS3="Quel API souhaitez-vous utiliser ? (1,2,3,4)"
options=("vanilla" "purpur" "paper" "fabric")
select api in "${options[@]}"; 
do
    case $api in
    vanilla)
        while true;
        do
            echo "Quel version de minecraft souhaiez-vous utiliser ? (exemple 1.21.5 / 26.3)" 
            read -p "" version_minecraft
            vanilla_version_check=$(curl -s -H "User-Agent: $USER_AGENT" https://piston-meta.mojang.com/mc/game/version_manifest_v2.json | jq -r '.versions[] | select(.id== "'"$version_minecraft"'") | .url')
        if [[ "$vanilla_version_check" == "null" || -z "$vanilla_version_check" ]]
        then
            echo "La version $version_minecraft n'est pas disponible pour $api."
        else
            api_url_vanilla=$(curl -s -H "User-Agent: $USER_AGENT" $vanilla_version_check | jq -r '.downloads.server.url')
            wget --user-agent="$USER_AGENT" -O server.jar "$api_url_vanilla"
            code_erreur=$?
            if [[ "$code_erreur" -eq 0 ]]
            then
                succes_dl_api
                return 0
            else 
                echec_dl_api
                return 1
            fi
        fi
        done
    ;;
    purpur)
        while true;
        do 
            echo "Quel version de minecraft souhaiez-vous utiliser ? (exemple 1.21.5 / 26.3)" 
            read -p "" version_minecraft 
            purpur_version_check=$(curl -s -H "User-Agent: $USER_AGENT" https://api.purpurmc.org/v2/purpur/$version_minecraft | jq -r '.builds.latest') 
        if [[ "$purpur_version_check" == "null" || -z "$purpur_version_check" ]]
        then 
            echo "La version "$version_minecraft" n'est pas disponible pour $api." 
        else
            wget --user-agent="$USER_AGENT" -O server.jar https://api.purpurmc.org/v2/purpur/"$version_minecraft"/latest/download
            code_erreur=$?
            if [[ "$code_erreur" -eq 0 ]]
            then
                succes_dl_api
                return 0
            else 
                echec_dl_api
                return 1
            fi
        fi
        done    
    ;;
    paper)
        while true; 
        do
            echo "Quel version de minecraft souhaiez-vous utiliser ? (exemple 1.21.5 / 26.3)"
            read -p "" version_minecraft
            paper_version_check=$(curl -s -H "User-Agent: $USER_AGENT" https://fill.papermc.io/v3/projects/paper/versions/"$version_minecraft"/builds | jq -r 'first(.[] | select(.channel == "STABLE") | .downloads."server:default".url) // "null"' 2>/dev/null)
        if [[ "$paper_version_check" == "null" || -z "$paper_version_check" ]]; 
        then
            echo "La version $version_minecraft n'est pas disponible pour $api." 
        else
            wget --user-agent="$USER_AGENT" -O server.jar "$paper_version_check"
            code_erreur=$?
            if [[ "$code_erreur" -eq 0 ]]
            then
                succes_dl_api
                return 0
            else 
                echec_dl_api
                return 1
            fi
        fi
        done
    ;;
    fabric) 
        while true;
        do
            echo "Quel version de minecraft souhaiez-vous utiliser ? (exemple 1.21.5 / 26.3)"
            read -p "" version_minecraft         
            fabric_version_check=$(curl -s -H "User-Agent: $USER_AGENT" https://meta.fabricmc.net/v2/versions/game/intermediary | jq -r '.[] | select(.version == "'"$version_minecraft"'") | .version')
        if [[ "$fabric_version_check" == "null" || -z "$fabric_version_check" ]]
        then
            echo "La version "$version_minecraft" n'est pas disponible pour $api." 
        else
            echo "La derniere version "$version_minecraft" de fabric va etre installee"
            echo ""
            api_fabric_version_loader=$(curl -s -H "User-Agent: $USER_AGENT" "https://meta.fabricmc.net/v2/versions/loader/$version_minecraft" | jq -r '[ .[] | select(.loader.stable == true) ][0].loader.version')
            api_fabric_version_installer=$(curl -s -H "User-Agent: $USER_AGENT" https://meta.fabricmc.net/v2/versions/installer| jq -r '[ .[] | select(.stable == true) ][0].version')
            wget --user-agent="$USER_AGENT" -O server.jar "https://meta.fabricmc.net/v2/versions/loader/$fabric_version_check/$api_fabric_version_loader/$api_fabric_version_installer/server/jar"
            code_erreur=$?
            if [[ "$code_erreur" -eq 0 ]]
            then
                succes_dl_api
                return 0
            else 
                echec_dl_api
                return 1
            fi
        fi
        done 
    ;;
    *)
        echo "Selection invalide veuillez reessayer !"
    ;;
    esac
done   
}
#fonction de réussite de dl d'API
succes_dl_api() {
echo "La version minecraft $api serveur a ete telechargee pour la version $version_minecraft de minecraft"
echo ""
}
#fonction d'échec de dl d'API
echec_dl_api() {
if [[ "$code_erreur" == 4 ]]
then
    echo "Erreur de reseau est survenue veuillez verifier votre connexion internet"
    echo ""
elif [[ "$code_erreur" == 8 ]]
then
    echo "Erreur de communication a eu lieu avec les serveur de l'api $api veuillez reessayer plus tard"
    echo ""
else 
    echo "Une erreur inconnue a ete rencontre lors du telechargement de l'api $api merci de reessayer"
    echo ""
fi
echo "Voulez-vous recommencer ou choisir une autre api ? (oui/non)"
read -p "" again
if [[ "$again" == "oui" ]]
then 
    echo "La demande d'API va recommencer"
else
    echo "La creation du serveur a echoue"
    echo "Le dossier cree ce trouve dans $server_here"
    exit
fi
}