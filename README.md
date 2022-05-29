# CS:GO Docker Deployment

This is a simple docker deployment to setup a CS:GO server.

## Why?

All CS:GO docker deployments online are a pain to setup as you can't easily mount the server as a volume making it terrible to modify config files.

## How To

Rename `.env.example` to `.env`.

Fill in the following details:

|Label|Default|Required|Description|
|--|--|--|--|
|GAME_SERVER_LICENSE|` `|`true`|Get your game server license [here](https://steamcommunity.com/dev/managegameservers). Once on the website fill in `730` for the AppId, keep in mind that your account needs to meet the requirements to host a server.|
|WORKSHOP_API_KEY|` `|`false`|Get your Steam Web API key [here](https://steamcommunity.com/dev/apikey). This is used to download items from the steam workshop, if you don't have a domain you can just fill in `localhost`, this is not required to do though.|
|SRV_PORT|`27015`|`true`|This is the port of your server, make sure to adjust the `docker-compose.yml` to reflect any ports you change.|
|SRV_TICKRATE|`64`|`true`|The server tickrate, higher is better, try to use a number between `64-128`. Add `-tickrate 128` to your local CS:GO installation to notice the change in tickrate.|
|SRV_ARGS|` `|`false`|Any additional commands that you need to pass to srcds_linux can be passed here.|
