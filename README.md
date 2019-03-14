# LemonLDAP::NG in Docker

![LL::NG+Docker](http://lemonldap-ng.org/_media/documentation/lemonldap-ng-docker.png)

## Build the image

Use the docker build command:

    docker build --rm -t yourname/lemonldap-ng:version .

## Run the image

The image will run LemonLDAP::NG in demo mode (see http://lemonldap-ng.org/documentation/latest/authdemo).

Add auth.example.com/manager.example.com/test1.example.com/test2.example.com to /etc/hosts on the host

    echo "127.0.0.1 auth.example.com manager.example.com test1.example.com test2.example.com" | sudo tee -a /etc/hosts

Map the container port 80 to host port 80 (option -p) when you run the container to be able to access it

    docker run -d -p 80:80 yourname/lemonldap-ng:version

Then connect to http://auth.example.com with your browser and log in with dwho/dwho.

## Configuration

You may use the following environment variables to configure the container

* `SSODOMAIN`: change the default `example.com` domain with something else
* `LOGLEVEL`: Set LLNG verbosity (for `docker logs`). Possible values: `error`, `warn`, `notice`, `info`, `debug`
* `FASTCGI_LISTEN_PORT`: Listen on a port instead of using a UNIX socket. If you use this variable, you will probably want to map this port on your host.

You can also finely set the hostnames for each site

* `PORTAL_HOSTNAME`: change the default `auth.example.com` domain with something else
* `MANAGER_HOSTNAME`: change the default `manager.example.com` domain with something else
* `HANDLER_HOSTNAME`: change the default `reload.example.com` domain with something else
* `TEST1_HOSTNAME`: change the default `test1.example.com` domain with something else
* `TEST2_HOSTNAME`: change the default `test2.example.com` domain with something else

Example:

    docker run -d -e SSODOMAIN=test.local -e LOGLEVEL=debug -p 80:80 yourname/lemonldap-ng:version

Or

    docker run -d \
        -e SSODOMAIN=test.local \
        -e PORTAL_HOSTNAME=myportal.test.local \
        -e MANAGER_HOSTNAME=mymanager.test.local \
        -e HANDLER_HOSTNAME=myhandler.test.local \
        -e TEST1_HOSTNAME=mytest1.test.local \
        -e TEST2_HOSTNAME=mytest2.test.local \
        -e LOGLEVEL=debug \
        -e FASTCGI_LISTEN_PORT=9000 \
        -p 80:80 \
        -p 9000:9000 \
        yourname/lemonldap-ng:version

Don't forget to modify your `/etc/hosts` accordingly

## Docker hub

See also https://hub.docker.com/r/coudot/lemonldap-ng/
