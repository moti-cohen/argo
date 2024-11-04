apiVersion: tf.galleybytes.com/v1beta1
kind: Terraform
metadata:
  name: example-terraform-resource
  namespace: tf-system
spec:
  terraformModule:
    source: "https://github.com/moti-cohen/argo.git"
    version: "v1.0.0"
  backend: |
    terraform {
      backend "kubernetes" {
        secret_suffix = "example-terraform"
        namespace     = "tf-system"
        in_cluster_config = true
      }
    }
  terraformVersion: "1.3.5"
