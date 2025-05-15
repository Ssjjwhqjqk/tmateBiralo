#!/bin/bash

service ssh start

# Start tmate session in detached mode with socket
tmate -S /tmp/tmate.sock new-session -d

echo "Waiting for tmate session..."

# Wait up to 30 seconds for tmate SSH socket to be available
for i in {1..30}; do
  tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}' && break
  sleep 1
done

echo "tmate session info:"

# Capture the info
SSH_LINK=$(tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}')
WEB_LINK=$(tmate -S /tmp/tmate.sock display -p '#{tmate_web}')

echo "SSH_LINK=$SSH_LINK"
echo "WEB_LINK=$WEB_LINK"

# Write HTML page with the links
cat <<EOF > /var/www/html/index.html
<h2>Your VPS is ready!</h2>
<p>SSH connection:</p>
<pre>$SSH_LINK</pre>
<p>Web connection:</p>
<pre>$WEB_LINK</pre>
EOF

# Start nginx
nginx -g 'daemon off;'
