apiVersion: tf.galleybytes.com/v1alpha1
kind: Terraform
metadata:
  name: example-terraform-resource
  namespace: tf-system
spec:
  terraformModule:
    source: "git::https://github.com/moti-cohen/argo.git//lambda-rds"
    version: "v1.0.0"
  variables:
    - name: AWS_REGION
      value: "eu-west-1"

