## Bugzilla in Docker
Example `docker-compose.yml` file:
```
version: '2'
services:
  bugzilla:
    restart: unless-stopped
    image: neonorb/bugzilla
    volumes:
      - <localconfig>:/var/www/html/localconfig:rw # configuration including database keys
      - <datadir>/:/var/www/html/data/:rw # assets, attachments, extensions, templates, parameters (config, email & database keys)
    ports:
      - "80:80"
```
