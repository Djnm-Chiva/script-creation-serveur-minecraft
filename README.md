# script-creation-serveur-minecraft

## Présentation

Ce script bash sous Debian est un script de création automatique de serveur Minecraft.

L'utilisateur est guidé et choisit les options voulues. Une fois la création terminée, l'utilisateur peut démarrer son serveur automatiquement ou le faire plus tard (start.sh). Lors de la création, plusieurs options sont possibles (type de serveur, options avancées (exemple : adresse IP, numéro de port, white-list)).

## Ce que fait le script

1. Le script vérifie les versions et installe au besoin les paquets nécessaires.
2. L'utilisateur choisit le type de serveur et de la version de Minecraft.
3. L'utilisateur peut ajouter des plugins ou des mods, facultativement.
4. Choix pour l'utilisateur d'ajout optionnel de datapacks.
5. Choix de l'allocation de la mémoire RAM et création du script de démarrage (start.sh).
6. Configuration avancée, facultative.
7. Démarrage du serveur, immédiat ou plus tard.

## Prérequis

- Il faut un système d'exploitation sous Debian 13 (trixie).
- Le script installe uniquement les paquets requis.
- Les permissions sudo sont nécessaires.
- Être connecté à Internet.
- Git doit être installé sur la machine

## Mode d'emploi sur Debian

1. Ouvrir le terminal de commande sous Linux.
2. Se rendre à l'endroit voulu pour cloner le dépôt GitHub.
3. Taper la commande : `git clone https://github.com/Djnm-Chiva/script-creation-serveur-minecraft.git`
4. Se rendre dans le dossier créé.
5. Lancer la commande `./V4creationserveur.sh`
6. Suivre les étapes de création du serveur.

## Limites connues

- Minecraft 26.1 et plus récent requiert Java 25 minimum (cela peut évoluer dans le futur).
- Le script n'accepte pas les espaces dans le nom du serveur, alors que le menu le demande.

## Licences

Licence : MIT, voir le fichier LICENSE
