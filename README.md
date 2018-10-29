# Rancher Kubernetes (V2) plugin for drone.io [![Docker Repository](https://hub.docker.com/r/victorhbfernandes/drone-kubernetes-rancher/status "Docker Repository")](https://hub.docker.com/r/victorhbfernandes/drone-kubernetes-rancher)

This plugin allows to update a Kubernetes deployment using Rancher config files.

## Usage  

This pipeline will update the `my-deployment` deployment with the image tagged `DRONE_COMMIT_SHA:0:8` using `kubeconfig_file_dev` as its config file 

```yaml
    pipeline:
        deploy:
            image: victorhbfernandes/drone-kubernetes-rancher
            deployment: my-deployment
            secrets: [ kubeconfig_file_dev ]
            configfile_name: KUBECONFIG_FILE_DEV
            repo: myorg/myrepo
            container: my-container
            tag: 
                - mytag
                - latest
```

Deploying containers across several deployments, eg in a scheduler-worker setup. Make sure your container `name` in your manifest is the same for each pod.
    
```yaml
    pipeline:
        deploy:
            image: victorhbfernandes/drone-kubernetes-rancher
            deployment: [server-deploy, worker-deploy]
            secrets: [ kubeconfig_file ]
            repo: myorg/myrepo
            container: my-container
            tag:                 
                - mytag
                - latest
```

Deploying multiple containers within the same deployment.

```yaml
    pipeline:
        deploy:
            image: victorhbfernandes/drone-kubernetes-rancher
            deployment: my-deployment
            secrets: [ kubeconfig_file ]
            repo: myorg/myrepo
            container: [container1, container2]
            tag:                 
                - mytag
                - latest
```

**NOTE**: Combining multi container deployments across multiple deployments is not recommended

This more complex example demonstrates how to deploy to several environments based on the branch, in a `app` namespace 

```yaml
    pipeline:
        deploy-staging:
            image: victorhbfernandes/drone-kubernetes-rancher
            secrets: [ kubeconfig_file ]
            deployment: my-deployment
            repo: myorg/myrepo
            container: my-container
            namespace: app
            tag:                 
                - mytag
                - latest
            when:
                branch: [ staging ]

        deploy-prod:
            image: victorhbfernandes/drone-kubernetes-rancher
            secrets: [ kubeconfig_file_prod ]
            configfile_name: KUBECONFIG_FILE_PROD
            deployment: my-deployment
            repo: myorg/myrepo
            container: my-container
            namespace: app
            tag:                 
                - mytag
                - latest
            when:
                branch: [ master ]
```

## Required secrets

```bash
    drone secret add --image=victorhbfernandes/drone-kubernetes-rancher \
        your-user/your-repo KUBECONFIG_FILE <base64 encoded kubeconfig file from Rancher>
```

You can add multiple configfiles as secrets and switch between them using the configfile_name parameter

### Special thanks

Inspired by [drone-helm](https://github.com/ipedrazas/drone-helm) and [drone-kubernetes](https://github.com/honestbee/drone-kubernetes)
