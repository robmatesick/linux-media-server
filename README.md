# linux-media-server
Configuration for a Linux-based media server with Plex.
Making use of Docker Compose.
Tested with Ubuntu Server LTS.

## Pre-install Docker
Based on latest documentation available [here](https://docs.docker.com/engine/install/ubuntu/).
```bash
sudo apt-get -y remove docker docker-engine docker.io containerd runc && \
sudo apt-get -y update && \
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get -y update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
```

## Pre-install Docker Compose
Based on latest documentation available [here](https://docs.docker.com/compose/install/).
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
sudo chmod +x /usr/local/bin/docker-compose
sudo usermod -aG docker $USER
```

# Post-install Configs

## Deluge
* Change download directory to `/downloads`
* Enable labels plug-in
* Modify Bandwidth & Queue settings as you see fit

## Jackett
* Add several indexers

## Lidarr/Radarr/Sonarr
* Add download client
* Add each indexer as custom Torznab from Jackett list

## Ombi
* Sign-in with Plex account
* Complete setup on Plex media server
* Add setups for Lidarr, Radarr, and Sonarr
* Enabe plex sign-in for other users

