#!/usr/bin/env bash
sudo useradd --uid 2000 --gid 1050 --comment "host user for scottstanfield/rlang docker user rlang" --groups docker,campfire --no-create-home --no-user-group rlang
