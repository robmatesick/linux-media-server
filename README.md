# pi-media-server
Configuration for a RPI media server
with Plex
Dockerized for RPI

## Pre-install Docker
```bash
curl -sSL https://get.docker.com | sh && \
sudo usermod -aG docker pi && \
sudo apt -y install libffi-dev libssl-dev python3 python3-pip && \
sudo apt -y remove python-configparser && \
sudo pip3 install docker-compose
```

# Post-install Configs

## Nginx reverse proxy
* Copy `deluge.conf` to configuration directory subdir `/nginx/site-confs/`
* Restart the nginx container

## Deluge
* Change download directory to `/downloads`

## Jackett
* Add several indexers

## Lidarr/Radarr/Sonarr
* Add download client
* Add each indexer as custom Torznab from Jackett list

## Ombi
* Sign-in with Plex account
* Complete setup on Plex media server
* Add setups for Lidarr, Radarr, and Sonarr

# Fix for Radarr ELF error
Install `libseccomp2_2.4.4-1~bpo10+1_armhf.deb`
