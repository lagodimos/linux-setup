#!/usr/bin/env bash

echo "Configuring firewall..."

ufw default deny incoming  # Default Rules
ufw default allow outgoing

ufw allow http
ufw allow https

ufw limit ssh

ufw allow 53317    # LocalSend

ufw enable
