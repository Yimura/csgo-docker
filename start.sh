#!/bin/bash
APP_ID=740
SERVER_DIR=/srv/

function update_steamcmd()
{
    echo "Updating steamcmd..."
    steamcmd.sh +quit
    echo "Finished updating steamcmd."
}

function download_steam_app()
{
    app_id=$1
    install_dir=$2

    echo "Installing AppId:$app_id to $install_dir"
    steamcmd.sh \
        +force_install_dir "$install_dir" \
        +login anonymous \
        +app_update "$app_id" \
        +quit
    echo "Finished installing AppId:$app_id"
}

function start_server()
{
    if [ "$EUID" == 0 ]
    then
        echo "Script running as root; starting server as unprivileged user."
    fi

    server_directory=$1
    server_license=$2

    echo "Starting server with license '$server_license'"

    cd $server_directory
    ./srcds_run +sv_setsteamaccount $server_license -port 27015 -game csgo -console -usercon +game_mode 0 +mapgroup mg_active +map de_dust2
}

update_steamcmd
download_steam_app $APP_ID $SERVER_DIR

start_server $SERVER_DIR $GAME_SERVER_LICENSE
