#!/usr/bin/env bash
docker run -d --name docker-node-express -e DEPLOY_ENV=stage -p 5000:5000 -v /var/log:/var/log/supervisor/ jonathanhle/docker-node-express
