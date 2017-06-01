# LemonLDAP::NG in Kubernetes

## Build your docker
It is the same with classic build :
    docker build --rm -t yourname/lemonldap-ng:version .

## Customize your deployment

To deploy your ll::ng on kubernetes, you can modify the namespace(in all yaml) and SSODOMAIN(in k8s-llng-configmap.yaml and k8s-llng-ingress.yaml).

## Choose your container image

You must edit k8s-llng-nginx.yaml or k8s-llng-apache2.yaml with a correct image registry.

## Deploy on kubernetes
You need to create your namespace first and make choice between nginx and apache2 :
    kubectl create -f k8s-llng-namespace.yaml
    kubectl create -f k8s-llng-configmap.yaml
    kubectl create -f k8s-llng-svc.yaml
    kubectl create -f k8s-llng-nginx.yaml # or kubectl create -f k8s-llng-apache2.yaml
    kubectl create -f k8s-llng-ingress.yaml

If you want to execute with only one command :
    kubectl create -f k8s-llng-namespace.yaml -f k8s-llng-configmap.yaml -f k8s-llng-svc.yaml f k8s-llng-{nginx|apache2}.yaml -f k8s-llng-ingress.yaml

Now you can connect on the url, you have in k8s-llng-ingress.yaml.

