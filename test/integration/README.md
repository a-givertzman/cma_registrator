# How to launch all services
From the root directory of the project run:
```sh
sh -c "test/integration && docker compose up"
```
This command starts PostgreSQL database and https://github.com/a-givertzman/api-server as a group of docker containers.
