#!/bin/bash
APP_ID=740
SERVER_DIR=/srv

# steamcmd wrapper
function steamcmd() { bash $(which steamcmd.sh) "$@"; }

function update_steamcmd()
{
    echo "Updating steamcmd..."
    steamcmd +quit
    echo "Finished updating steamcmd."
}

function download_steam_app()
{
    app_id=$1
    install_dir=$2

    echo "Installing AppId:$app_id to $install_dir"
    steamcmd \
        +force_install_dir "$install_dir" \
        +login anonymous \
        +app_update "$app_id" \
        +quit
    echo "Finished installing AppId:$app_id"
}

function install_sourcemod()
{
    server_directory=$1

    METAMOD_VERSION=1.11
    SOURCEMOD_VERSION=1.11

    if [ ! -f "$server_directory/addons/metamod.vdf" ]; then
        echo "Metamod isn't installed, installing..."
        mkdir -p "$server_directory/addons/metamod"

        LATEST_METAMOD=$(wget -qO- https://mms.alliedmods.net/mmsdrop/"$METAMOD_VERSION"/mmsource-latest-linux)
        wget -qO- https://mms.alliedmods.net/mmsdrop/"$METAMOD_VERSION"/"$LATEST_METAMOD" | tar zxf - -C "$server_directory"

        echo "Installed MetaMod"
    fi

    if [ ! -f "$server_directory/addons/metamod/sourcemod.vdf" ]; then
        echo "SourceMod isn't installed, installing..."
        mkdir -p "$server_directory/addons/sourcemod"

        LATEST_SOURCEMOD=$(wget -qO- https://sm.alliedmods.net/smdrop/"$SOURCEMOD_VERSION"/sourcemod-latest-linux)
        wget -qO- https://sm.alliedmods.net/smdrop/"$SOURCEMOD_VERSION"/"$LATEST_SOURCEMOD" | tar zxf - -C "$server_directory"

        echo "Installed SourceMod"
    fi
}

function start_server()
{
    server_directory=$1
    server_license=$2
    workshop_api_key=$3

    echo "Starting server on 0.0.0.0:$SRV_PORT [tickrate:$SRV_TICKRATE] with xargs \"$SRV_ARGS\""

    cd $server_directory

    export LD_LIBRARY_PATH="$server_directory":"$server_directory/bin":{$LD_LIBRARY_PATH}
    ./srcds_linux \
        -authkey $workshop_api_key \
        -tickrate $SRV_TICKRATE \
        -port $SRV_PORT \
        -game csgo \
        -console \
        -nobots \
        +sv_setsteamaccount $server_license \
        $SRV_ARGS
}

echo "Script starting as '$(whoami)'"

update_steamcmd
download_steam_app $APP_ID $SERVER_DIR
install_sourcemod "$SERVER_DIR/csgo"

start_server $SERVER_DIR $GAME_SERVER_LICENSE $WORKSHOP_API_KEY
