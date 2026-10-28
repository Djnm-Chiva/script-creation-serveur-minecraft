#fonction mod_plugin_datapack
add_mod_plugin_datapack() { 
while true ;
do
    echo "Voulez-vous ajouter des $1 ? (oui/non) :"
    read -p "" add_mods_plugins_datapacks
    case "$add_mods_plugins_datapacks" in 
        oui)
            echo ""
            echo "Vous pouvez coller un lien de telechargement :" 
            read plugins_mods_datapacks_url
            if wget -q -P "$server_here"/"$2""$1" "$plugins_mods_datapacks_url"
            then 
                echo "Telechargement termine"             
            else
                echo "Une erreur est survenue veuillez recommencer"
            fi
            ;;
        non) 
            echo ""
            echo "Vous ne souhaitez pas ajouter de $1"
            echo ""
            break
            ;;
        *)
            echo "Veuillez repondre par oui ou non"
            echo ""
            ;;
    esac
done
}
