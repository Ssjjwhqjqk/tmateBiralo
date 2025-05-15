#!/bin/bash

service ssh start

tmate -S /tmp/tmate.sock new-session -d

# Wait for tmate session ready
for i in {1..30}; do
    SSH_LINK=$(tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}' 2>/dev/null)
    WEB_LINK=$(tmate -S /tmp/tmate.sock display -p '#{tmate_web}' 2>/dev/null)
    if [[ -n "$SSH_LINK" && -n "$WEB_LINK" ]]; then
        break
    fi
    sleep 1
done

if [[ -z "$SSH_LINK" || -z "$WEB_LINK" ]]; then
    echo "Failed to get tmate session links" > /var/www/html/index.html
else
    cat <<EOF > /var/www/html/index.html
<h2>Your VPS is ready!</h2>
<p>SSH connection:</p>
<pre>$SSH_LINK</pre>
<p>Web connection:</p>
<pre>$WEB_LINK</pre>
EOF
fi

nginx -g 'daemon off;'
