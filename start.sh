#!/bin/bash

# Start SSH service
service ssh start

# Start tmate session in the background using a socket
tmate -S /tmp/tmate.sock new-session -d

# Wait for tmate session to be ready
while ! tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}' > /dev/null 2>&1; do
  sleep 1
done

# Write connection info to web directory
echo "🧑‍💻 Your VPS is ready!" > /var/www/html/index.html
echo "" >> /var/www/html/index.html
tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}' >> /var/www/html/index.html
tmate -S /tmp/tmate.sock display -p '#{tmate_web}' >> /var/www/html/index.html

# Start nginx in foreground (to keep container alive)
nginx -g 'daemon off;'
