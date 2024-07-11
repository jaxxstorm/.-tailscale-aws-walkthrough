# Define local variables for reuse throughout the configuration
locals {
  cluster_endpoint    = module.eks.cluster_endpoint
  cluster_ca_cert     = base64decode(module.eks.cluster_certificate_authority_data)
  exec_api_version    = "client.authentication.k8s.io/v1beta1"
  exec_command        = "aws"
  exec_args           = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  labels = {
    "owner"       = "lbriggs"
    "deployed_by" = "terraform"
    "org"         = "lbrlabs"
  }
}

# Configure the Helm provider for interacting with Kubernetes
provider "helm" {
  kubernetes {
    host                   = local.cluster_endpoint
    cluster_ca_certificate = local.cluster_ca_cert

    # Use AWS CLI for authentication
    exec {
      api_version = local.exec_api_version
      command     = local.exec_command
      args        = local.exec_args
    }
  }
}

# Configure the Kubernetes provider
provider "kubernetes" {
  host                   = local.cluster_endpoint
  cluster_ca_certificate = local.cluster_ca_cert

  # Use AWS CLI for authentication
  exec {
    api_version = local.exec_api_version
    command     = local.exec_command
    args        = local.exec_args
  }
}

# Create a Kubernetes namespace for Tailscale
resource "kubernetes_namespace" "tailscale" {
  metadata {
    name = "tailscale"
  }
}

# Create a Kubernetes namespace for demo applications
resource "kubernetes_namespace" "demo" {
  metadata {
    name = "demo"
  }
}

# Deploy the Tailscale operator using Helm
resource "helm_release" "tailscale_operator" {
  name       = "tailscale-operator"
  repository = "https://pkgs.tailscale.com/helmcharts"
  chart      = "tailscale-operator"
  namespace  = kubernetes_namespace.tailscale.metadata[0].name

  # Set Tailscale OAuth credentials
  set {
    name  = "oauth.clientId"
    value = var.tailscale_oauth_clientid
  }
  set {
    name  = "oauth.clientSecret"
    value = var.tailscale_oauth_clientsecret
  }

  # Set the hostname for the Tailscale operator
  set {
    name  = "operatorConfig.hostname"
    value = format("tailscale-operator-eks")
  }
}

# Deploy a demo application
resource "kubernetes_deployment" "demo_streamer" {
  metadata {
    name      = "demo-streamer"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels = local.labels
      }

      spec {
        container {
          name  = "demo-streamer"
          image = "jaxxstorm/demo-streamer:k8s-identity-headers-monitoring"

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

# Create a Kubernetes service for the demo application
resource "kubernetes_service" "demo_streamer" {
  metadata {
    name      = "demo-streamer"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }

  spec {
    selector = local.labels

    port {
      port        = 8080
      target_port = 8080
    }

    type = "ClusterIP"
  }
}

# Create an Ingress resource for the demo application using Tailscale
resource "kubernetes_ingress_v1" "demo_streamer" {
  metadata {
    name      = "demo-streamer"
    namespace = kubernetes_namespace.demo.metadata[0].name
    annotations = {
      "tailscale.com/tags" = "tag:demo"
    }
  }

  spec {
    ingress_class_name = "tailscale"

    default_backend {
      service {
        name = kubernetes_service.demo_streamer.metadata[0].name
        port {
          number = 8080
        }
      }
    }

    rule {
      host = "demo"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.demo_streamer.metadata[0].name
              port {
                number = 8080
              }
            }
          }
        }
      }
    }

    tls {
      hosts = ["demo"]
    }
  }
}