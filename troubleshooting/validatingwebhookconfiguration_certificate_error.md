Troubleshooting validatingwebhookconfiguration
====================

> Rodolfo Rebelato de Almeida | February 25th, 2025

--------------------------

> Harvester documentation
    https://docs.harvesterhci.io/
   
---------------
# Table of Contents

1. [Problem Description](#problem-description)
2. [Environment](#environment)
3. [Solution](#solution)


Problem Description
====================
When trying to take volume snapshots, Harvester's UI shows the following error.

`Internal error occurred: failed calling webhook "snapshot-validation-webhook.csi.kubernetes.io": failed to call webhook: Post "https://harvester-snapshot-validation-webhook.kube-system.svc:443/volumesnapshot?timeout=10s": tls: failed to verify certificate: x509: certificate signed by unknown authority (possibly because of "x509: invalid signature: parent certificate cannot sign this kind of certificate" while trying to verify candidate authority certificate "harvester-snapshot-validation-webhook.kube-system.svc")`

The problem is related to a certificate mismatch configuration between secret `snapshot-validation-webhook-tls` and the `validatingwebhookconfiguration`.
To manually check the certificate configured for each component, please run the following commands.
```yaml
kubectl -n kube-system get secret snapshot-validation-webhook-tls -o jsonpath='{.data.ca\.crt}'
```

```yaml
kubectl get validatingwebhookconfiguration harvester-snapshot-validation-webhook -o jsonpath='{.webhooks[0].clientConfig.caBundle}
```

You can also run the following script to compare and check if the certificates are equal or different.

```bash
#!/bin/bash

# Capture the output of both commands into variables (without base64 decoding)
ca_crt=$(kubectl -n kube-system get secret snapshot-validation-webhook-tls -o jsonpath='{.data.ca\.crt}')
webhook_crt=$(kubectl get validatingwebhookconfiguration harvester-snapshot-validation-webhook -o jsonpath='{.webhooks[0].clientConfig.caBundle}')

# Compare the outputs
if [ "$ca_crt" == "$webhook_crt" ]; then
  echo "The outputs are equal."
else
  echo "The outputs are different."
fi
```

ENVIRONMENT
===
Harvester 1.3.2
- It looks like there are multiple clusters in the same condition

SOLUTION
========

## Tentative #01
We have tried to manually copy the `ca.crt` content from the secret `snapshot-validation-webhook-tls` and paste it into the `caBundle` variable inside the `validatingwebhookconfiguration` called `harvester-snapshot-validation-webhook`.

#### Steps
1. `kubectl -n kube-system get secret snapshot-validation-webhook-tls -o jsonpath='{.data.ca\.crt}'`
2. `kubectl edit validatingwebhookconfiguration harvester-snapshot-validation-webhook`
3. Paste the certificate collected from the firts step into the caBundle field.

After editing the validatingwebhookconfiguration harvester-snapshot-validation-webhook we noticed that the content of caBundle has been modified automatically. We couldn't identify what is changing it automaticalle but we couldn't make it work.

## Tentative #02
Delete the secret and validatingwebhookconfiguration and run helm rollback.

1. Delete the secret and the validating webhook configuration
```
kubectl delete secret snapshot-validation-webhook-tls -n kube-system
kubectl delete validatingwebhookconfigurations.admissionregistration.k8s.io harvester-snapshot-validation-webhook
```
2. there should be only one version here
```
helm history harvester -n harvester-system
```

3. rollback it
```
helm rollback harvester 1 -n harvester-system
```

This action resolved the customer problem, but if the customer modify the standard settings, like the standard storage class, the helm rollback may fail.


## Tentative #03
Manually create a new secret and validatingwebhookconfiguration. If step #02 fail, you can use this option. 

1. Backup the secret/snapshot-validation-webhook-tls and validatingwebhookconfiguration/harvester-snapshot-validation-webhook
```
kubectl get secret snapshot-validation-webhook-tls -n kube-system -o yaml > snapshot-validation-webhook-tls-backup.yaml
kubectl get validatingwebhookconfiguration harvester-snapshot-validation-webhook -o yaml > harvester-snapshot-validation-webhook-backup.yaml
```

2. Follow this yaml (https://github.com/harvester/harvester/blob/master/deploy/charts/harvester/dependency_charts/snapshot-validation-webhook/templates/webhook.yaml) to use helm to create a new secret and validatingwebhookconfiguration

3. Please make sure the service name {{- $serviceName := (printf "%s.%s.svc" (include "snapshot-validation-webhook.fullname" .) (include "snapshot-validation-webhook.namespace" .))  }} should follow current service domain name

4. Sync all labels and annotations
5. Apply this new yaml