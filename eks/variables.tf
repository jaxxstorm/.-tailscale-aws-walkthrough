variable "tailscale_oauth_clientid" {
    sensitive = false
}

variable "tailscale_oauth_clientsecret" {
    sensitive = true
}

variable "cluster_name" {
    description = "The name of the EKS cluster"
    type        = string
}