# linux-media-server
Configuration for a Linux-based media server with Plex.
Making use of Docker Compose.
Tested with Ubuntu Server LTS.

## Architecture

```
                                                       Trackers
                                                           ▲
                                                           │
                                ┌──────────────┐           │
                                │              │      ┌────┴────┐
                                │ ┌──────────┐ ├─────►│ Jackett │
                                │ │  Sonarr  │ │      └─────────┘
                                │ └──────────┘ │
              ┌────────┐        │              │
      ┌──────►│  Ombi  ├───────►│ ┌──────────┐ │      ┌──────────┐
      │       └────────┘        │ │  Radarr  │ ├─────►│  Deluge  │
      │                         │ └──────────┘ │      └──────────┘
      │                         │              │
      │                   ┌────►│ ┌──────────┐ │
      │                   │     │ │  Lidarr  │ │      ┌──────────┐
      │                   │     │ └──────────┘ │      │  Plex    │
      │                   │     │              ├─────►│  Media   │
      │                   │     └──────────────┘      │  Server  │
Less-technical /      Technical                       └────┬─────┘
   External             Users                              │
    Users                 │                                │
      │                   │                                │
      └───────────────────┴────────────────────────────────┘
```

### Components:
| Service | Purpose |
| ------- | ------- |
| [gluetun](https://hub.docker.com/r/qmcgaw/gluetun) | VPN client & network gateway |
| [jackett](https://hub.docker.com/r/linuxserver/jackett) | A single repository of maintained indexer scraping & translation logic - removing the burden from other apps |
| [lidarr](https://hub.docker.com/r/linuxserver/lidarr) | Music collection manager for BitTorrent |
| [radarr](https://hub.docker.com/r/linuxserver/radarr) | Movie collection manager for BitTorrent |
| [sonarr](https://hub.docker.com/r/linuxserver/sonarr) | TV Show collection manager for BitTorrent |
| [deluge](https://hub.docker.com/r/linuxserver/deluge) | Server-based BitTorrent client with a web UI|
| [plex](https://hub.docker.com/r/linuxserver/plex) | Plex Media Server (PMS) is the main media server |
| [ombi](https://hub.docker.com/r/linuxserver/ombi) | Self-hosted media request & user management portal for Plex |

## Installation

### Docker
Based on latest documentation available [here](https://docs.docker.com/engine/install/ubuntu/).
```bash
# Clean-up & install pre-reqs
sudo apt-get -y remove docker docker-engine docker.io containerd runc && \
sudo apt-get -y update && \
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Fetch GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install docker
sudo apt-get -y update && \
sudo apt-get -y install docker-ce docker-ce-cli containerd.io

# Enable non-root user to utilize docker
sudo usermod -aG docker $USER
```

### Install Docker Compose
Based on latest documentation available [here](https://docs.docker.com/compose/install/).
```bash
get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

REL=$(get_latest_release "docker/compose") && \
sudo curl -L "https://github.com/docker/compose/releases/download/${REL}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
sudo chmod +x /usr/local/bin/docker-compose
```

### Setup filesystem layout
* Mount external storage.  I mounted an ext4 filesystem to `/mnt/media01`.
* Create operational folder (where to clone this repo into).  I created `/opt/mediaserver`.

IMPORTANT:  The `.env` and `docker-compose.yml` files make use of these folder structure choices.  Make your own changes if you wish.

Here is a high level idea of my filesystem layouts
```
/
├── mnt
│   ├── media01
|   │   ├── media
|   |   │   ├── music
|   |   │   ├── photos
|   |   │   ├── videos
|   |   |   │   ├── movies
|   |   |   │   ├── other
|   |   |   │   ├── tv_shows
|   │   ├── server_data
|   |   │   ├── downloads
├── opt
│   ├── mediaserver
|   │   ├── server_data
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

## Plex Media Server (PMS)
* Claim the server by getting a token from https://plex.tv/claim and then adding to the PLEX_CLAIM container variable, and restart the container
* Enable hardware transcoding
* Setup libraries
