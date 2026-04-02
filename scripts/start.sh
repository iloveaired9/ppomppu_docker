#!/bin/bash

# Create log directories if they don't exist
mkdir -p /home/logs/apache/error
mkdir -p /home/logs/apache/access
mkdir -p /var/run/nutcracker

# Start httpd in foreground
/usr/sbin/httpd -DFOREGROUND &
HTTPD_PID=$!

# Start nutcracker in foreground
/usr/sbin/nutcracker -c /etc/nutcracker/nutcracker.yml -d &
NUTCRACKER_PID=$!

# Keep the container running
wait $HTTPD_PID
