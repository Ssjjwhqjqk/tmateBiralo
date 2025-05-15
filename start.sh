#!/bin/bash

service ssh start

tmate -S /tmp/tmate.sock new-session -d

# Wait for the tmate session to be ready
while ! tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}' > /dev/null 2>&1; do
  sleep 1
done

# Write the SSH and web links to the file served by nginx
echo "🧑‍💻 Your VPS is ready!" > /var/www/html/index.html
echo "" >> /var/www/html/index.html
echo "SSH: $(tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}')" >> /var/www/html/index.html
echo "Web: $(tmate -S /tmp/tmate.sock display -p '#{tmate_web}')" >> /var/www/html/index.html

# Start nginx in the foreground
nginx -g 'daemon off;'
