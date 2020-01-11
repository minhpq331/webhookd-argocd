# Webhookd Argocd
Simple webhook update git config repo to intergrate ArgoCD with CI tool

## Example repo

Application: [https://gitlab.com/minhpq331/helloworld](https://gitlab.com/minhpq331/helloworld)
Config repo: [https://gitlab.com/minhpq331/argocd-config](https://gitlab.com/minhpq331/argocd-config)

## Environment Variables

|      Variable      |                                                       Description                                                       |
|--------------------|-------------------------------------------------------------------------------------------------------------------------|
| GIT_KEYFILE        | SSH private key path to commit to config repo                                                                           |
| APP_PASSWD_FILE    | `.htpasswd` path to setup Basic authen. Follow instruction [here] (https://github.com/ncarlier/webhookd#authentication) |
| APP_HOOK_TIMEOUT   | Timeout in seconds for webhook                                                                                          |
| GIT_CONFIG_URI     | Config git uri (eg: `git@gitlab.com:minhpq331/argocd-config.git`)                                                       |
| MANAGED_CHARTS_DIR | Charts dir in config repo (eg: `helm/managed-chart`)                                                                    |

Other environment variables can be found here: [https://github.com/ncarlier/webhookd#setting-environment-variables](https://github.com/ncarlier/webhookd#setting-environment-variables)