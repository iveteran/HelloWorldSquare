curl -v https://dav.matrix.works/.well-known/caldav 2>&1 | grep -E 'HTTP|Location'
curl -v https://dav.matrix.works/.well-known/carddav 2>&1 | grep -E 'HTTP|Location'
