terraform {
  required_providers {
    tunnel = {
      source  = "Ezzahhh/tunnel"
      version = ">= 1.1.2"
    }
  }
}

ephemeral "tunnel_ssm" "eks" {
  target_host  = "https://eks-cluster.region.eks.amazonaws.com"
  target_port  = 443
  ssm_instance = "i-instanceid"
  ssm_region   = "us-east-1"
}

provider "kubernetes" {
  host = "https://${ephemeral.tunnel_ssm.eks.local_host}:${ephemeral.tunnel_ssm.eks.local_port}"

  tls_server_name = "eks-cluster.region.eks.amazonaws.com"

  client_certificate     = file("~/.kube/client-cert.pem")
  client_key             = file("~/.kube/client-key.pem")
  cluster_ca_certificate = file("~/.kube/cluster-ca-cert.pem")
}
