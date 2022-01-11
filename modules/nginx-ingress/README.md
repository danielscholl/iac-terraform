# Kubernetes NGINX ingress Module

## Introduction

This module will install an NGINX ingress module into an AKS cluster.  This is largely to bridge the gap between AzureDNS/Azure Static IP/AKS.
<br />

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.11 |
| helm | >=2.4.1 |
| kubernetes | ~>2.7.1 |

## Providers

| Name | Version |
|------|---------|
| helm | >=2.4.1 |
| kubernetes | ~>2.7.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_yaml\_config | yaml config for helm chart to be processed last | `string` | `""` | no |
| chart\_version | HELM Chart Version for nginx controller | `string` | `"4.0.6"` | no |
| enable\_default\_tls | enable default tls (requires tls\_default\_secret) | `string` | `"false"` | no |
| ingress\_class | name of the ingress class to route through this controller | `string` | `"nginx"` | no |
| ingress\_type | Internal or Public. | `string` | `"Public"` | no |
| kubernetes\_create\_namespace | create kubernetes namespace | `bool` | `true` | no |
| load\_balancer\_ip | loadBalancerIP | `string` | `null` | no |
| name | Name of helm release | `string` | `"ingress-nginx"` | no |
| namespace | Name of namespace where nginx controller should be deployed | `string` | `"kube-system"` | no |
| replica\_count | The number of replicas of the Ingress controller deployment. | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| ingress\_class | Name of the ingress class to route through this controller |
| load\_balancer\_ip | n/a |
| nginx\_url | n/a |

<!--- END_TF_DOCS --->