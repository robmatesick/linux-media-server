#!/bin/bash
cd /mnt/appdata
./stop_containers.sh
./update_pulled_docker_images.sh
./start_containers.sh
