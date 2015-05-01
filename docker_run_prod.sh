#!/usr/bin/env bash
docker run -d --name docker-node-express -e DEPLOY_ENV=production -p 5000:5000 -v /var/log:/var/log/supervisor/ jonathanhle/docker-node-express
