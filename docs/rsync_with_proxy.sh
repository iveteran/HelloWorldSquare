ssh -N -L 2222:proxy_host:22 ruishi@remote_host &
rsync -auve "ssh -p 2222" path/to remote_user@localhost:~/path/to
