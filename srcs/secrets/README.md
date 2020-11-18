# SECRETS

Kubernetes Secrets let you store and manage sensitive information, such as
passwords, OAuth tokens, and ssh keys.

## OVERVIEW

Normally you would keep all your yaml files with your code in your code base,
except for the secrets.

The secrets are referenced by pods in on our deployments.
Therefore they should be created beforethe deployments are, so that the
deployments can reference them while they already exist.

## IMPLEMENTATION

I used _datastring_ instead of data so that we can see the data clearly in the
files.
note: this technique also has the advantage of allowing us to put a clear label
name and replace it with values in production pipelines (CICD).

## DOCUMENTATION

[https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-files-from-a-pod]
