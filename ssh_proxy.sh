ssh -f -N -D 0.0.0.0:1080 yourname@host

ssh-copy-id yourname@host
autossh -M 4444 -C -N -D 0.0.0.0:1080 host
autossh -M 4444 -C -N -R 2222:localhost:22 host
