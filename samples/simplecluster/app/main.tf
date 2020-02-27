provider "kubernetes" {}


resource "kubernetes_pod" "redis" {
  metadata {
    name = "azure-vote-back"
    labels {
      name = "azure-vote-back"
    }
  }
  spec {
    container {
      image = "redis"
      name  = "azure-vote-back"
    }
  }
}

resource "kubernetes_service" "redis" {
  metadata {
    name      = "azure-vote-back"
    labels {
      name = "azure-vote-back"
    }
  }
  spec {
    selector {
      name = "${kubernetes_pod.web.metadata.0.labels.name}"
    }
    port {
      port        = 6379
      target_port = 6379
    }
  }
}

resource "kubernetes_pod" "web" {
  metadata {
    name = "azure-vote-front"
    labels {
      name = "azure-vote-front"
    }
  }
  spec {
    container {
      image = "microsoft/azure-vote-front:v1"
      name  = "azure-vote-front"
      port {
        container_port = 80
      }
      env {
        name = "REDIS"
        value = "azure-vote-back"
      }
    }
  }
}

resource "kubernetes_service" "web" {
  metadata {
    name      = "azure-vote-front"
  }
  spec {
    selector {
      name = "${kubernetes_pod.web.metadata.0.labels.name}"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}


output "lb_ip" {
  value = "${kubernetes_service.web.load_balancer_ingress.0.ip}"
}