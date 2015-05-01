#!/usr/bin/env bash
#Remove any existing files previously distributed, if any
service supervisor stop; true
rm -rf /app; true
rm -rf /etc/supervisor/conf.d/app.conf; true
deluser deploy --remove-home

# Grab the latest code then deploy the changes into the server
/usr/bin/git clone -b develop --single-branch https://jonathanhle:<<changethis>>@github.com/SomeRepo/SomeApp.git /app

#Setup the environment depending on if Prod or Stage
if [ "$DEPLOY_ENV" == "PROD" ]
then

echo "SOME_ENV_VAR01=1234567879
NODE_ENV=development
NODE_PATH=client

RIAK_SERVERS=10.100.123.123:8098
PORT=5000

SOME_ENV_VAR02=random_something01
SOME_ENV_VAR03=random_something02" >> /app/.env

elif [ "$DEPLOY_ENV" == "STAGE" ]
then

echo "SOME_ENV_VAR01=111222212123
NODE_ENV=development
NODE_PATH=client

RIAK_SERVERS=10.100.123.111:8098
PORT=5000

SOME_ENV_VAR02=random_something01
SOME_ENV_VAR03=random_something02" >> /app/.env

else
  echo "Something went wrong with writing the ENV file."
fi

#Link app supervisord program conf
/bin/ln -s /app/supervisord.conf /etc/supervisor/conf.d/app.conf

#create Deploy user, change file permissions, disable deploy user (do something different if you're app needs nobody:deploy ownership)
adduser --disabled-password --disabled-login --gecos "" deploy
chown -R deploy.deploy /app

#Load node dependencies and adjust file permissions
sudo su  - deploy <<'EOF'
cd /app
npm install
EOF