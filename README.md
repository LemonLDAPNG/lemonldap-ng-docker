# LemonLDAP::NG in Docker

![LL::NG+Docker](http://lemonldap-ng.org/_media/documentation/lemonldap-ng-docker.png)

## Build the image

Use the docker build command:

    docker build --rm -t yourname/lemonldap-ng:version .

You can change the SSO domain by editing the ENV SSODOMAIN in the Dockerfile. By default the domain is "example.com"

## Run the image

The image will run LemonLDAP::NG in demo mode (see http://lemonldap-ng.org/documentation/latest/authdemo).

Prerequisites:
* Map the container port 80 to host port 80 (option -p)
* Add reload.example.com to /etc/hosts in the container (option --add-host)
* Add auth.example.com/manager.example.com/test1.example.com/test2.example.com to /etc/hosts on the host


    sudo echo "127.0.0.1 auth.example.com manager.example.com test1.example.com test2.example.com" >> /etc/hosts


    docker run -d --add-host reload.example.com:127.0.0.1 -p 80:80 yourname/lemonldap-ng:version

Then connect to http://auth.example.com with your browser and log in with dwho/dwho.

## Docker hub

See also https://hub.docker.com/r/coudot/lemonldap-ng/
