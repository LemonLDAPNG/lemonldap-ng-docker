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
* `PROXY_RANGE`: if LLNG is running behind a reverse proxy, change the nginx configurations for `set_real_ip_from`. `PROXY_RANGE` will be the IP range of your proxy. ex: `172.0.0.0/8`
* `PRESERVEFILES`: define folders for llng configuration that would need to be preserved, if empty folders are mounted they will be populated with original default configurations

You can also finely set the hostnames for each site

* `PORTAL_HOSTNAME`: change the default `auth.example.com` domain with something else
* `MANAGER_HOSTNAME`: change the default `manager.example.com` domain with something else
* `HANDLER_HOSTNAME`: change the default `reload.example.com` domain with something else
* `TEST1_HOSTNAME`: change the default `test1.example.com` domain with something else
* `TEST2_HOSTNAME`: change the default `test2.example.com` domain with something else

Customisations to the themes such as logos, templates etc. can be listed in the following folders. The name of the custom theme folder in `htdocs/static` or `templates` are shared. You can use the following command to configure the variable `portalSkin` or modify `lmConfX.json`: `/usr/share/lemonldap-ng/bin/lemonldap-ng-cli set portalSkin CustomTheme`

* /usr/share/lemonldap-ng/portal/htdocs/static/CustomTheme
* /usr/share/lemonldap-ng/portal/htdocs/static/CustomTheme/css
* /usr/share/lemonldap-ng/portal/htdocs/static/CustomTheme/js
* /usr/share/lemonldap-ng/portal/htdocs/static/CustomTheme/images
* /usr/share/lemonldap-ng/portal/templates/CustomTheme

The custom Perl plugins can be provided in the following locations with the code inserting the following `Package Lemonldap::NG::Portal:Plugins:CustomFolder` for plugins for examples:

* /usr/share/perl5/Lemonldap/NG/Portal/Plugins/CustomPlugin
* /usr/share/perl5/Lemonldap/NG/Portal/Register/CustomRegister
* /usr/share/perl5/Lemonldap/NG/Portal/UserDB/CustomUserdb
* /usr/share/perl5/Lemonldap/NG/Portal/Auth/CustomAuth
* /usr/share/perl5/Lemonldap/NG/Portal/Captcha/CustomCaptcha
* /usr/share/perl5/Lemonldap/NG/Portal/MenuTab/CustomMenuTab

Example:

    docker run -d -e SSODOMAIN=example.com -e LOGLEVEL=debug -p 80:80 yourname/lemonldap-ng:version

Or

    docker run -d \
        -e SSODOMAIN=example.com \
        -e PORTAL_HOSTNAME=myportal.example.com \
        -e MANAGER_HOSTNAME=mymanager.example.com \
        -e HANDLER_HOSTNAME=myhandler.example.com \
        -e TEST1_HOSTNAME=mytest1.example.com \
        -e TEST2_HOSTNAME=mytest2.example.com \
        -e PRESERVEFILES=/etc/lemonldap-ng /var/lib/lemonldap-ng/conf /var/lib/lemonldap-ng/sessions /var/lib/lemonldap-ng/psessions \
        -e LOGLEVEL=debug \
        -e FASTCGI_LISTEN_PORT=9000 \
        -p 80:80 \
        -p 9000:9000 \
        -v ./llng/etc:/etc/lemonldap-ng \
        -v ./llng/var-conf:/var/lib/lemonldap-ng/conf \
        -v ./llng/var-sessions:/var/lib/lemonldap-ng/sessions \
        -v ./llng/var-psessions:/var/lib/lemonldap-ng/psessions \
        -v ./llng/theme:/usr/share/lemonldap-ng/portal/htdocs/static/CustomTheme \
        -v ./llng/template:/usr/share/lemonldap-ng/portal/templates/CustomTheme \
        -v ./llng/plugins:/usr/share/perl5/Lemonldap/NG/Portal/Plugins/CustomPlugin \
        -v ./llng/register:/usr/share/perl5/Lemonldap/NG/Portal/Register/CustomRegister \
        -v ./llng/userdb:/usr/share/perl5/Lemonldap/NG/Portal/UserDB/CustomUserdb \
        -v ./llng/auth:/usr/share/perl5/Lemonldap/NG/Portal/Auth/CustomAuth \
        -v ./llng/captcha:/usr/share/perl5/Lemonldap/NG/Portal/Captcha/CustomCaptcha \
        -v ./llng/menutab:/usr/share/perl5/Lemonldap/NG/Portal/MenuTab/CustomMenuTab \
        yourname/lemonldap-ng:version

Don't forget to modify your `/etc/hosts` accordingly

## Docker hub

See also https://hub.docker.com/r/coudot/lemonldap-ng/
