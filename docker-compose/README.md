# LemonLDAP::NG in docker-compose

## Build your docker
It is the same with classic build :
    docker build --rm -t yourname/lemonldap-ng:version .

## Verify your docker-compose
To check your docker-compose :
    docker-composer config --service

## Deploy with docker-compose
Start your docker-compose :
    docker-compose start # or docker-compose up

Stop your docker-compose :
    docker-compose stop
