output "ipv4_address" {
  value      = hcloud_server.server.ipv4_address
  depends_on = [terraform_data.initial_readiness, terraform_data.os_upgrade_timer]
}

output "ipv6_address" {
  value      = hcloud_server.server.ipv6_address
  depends_on = [terraform_data.initial_readiness, terraform_data.os_upgrade_timer]
}

output "private_ipv4_address" {
  value      = try(one(hcloud_server.server.network).ip, "")
  depends_on = [terraform_data.initial_readiness, terraform_data.os_upgrade_timer]
}

output "name" {
  value      = hcloud_server.server.name
  depends_on = [terraform_data.initial_readiness, terraform_data.os_upgrade_timer]
}

output "id" {
  value      = hcloud_server.server.id
  depends_on = [terraform_data.initial_readiness, terraform_data.os_upgrade_timer]
}

output "rebuild_artifact" {
  description = "Sensitive object-preserving rebuild input. Extract only from a reviewed saved plan and store with mode 0600."
  sensitive   = true
  value = {
    server_id           = hcloud_server.server.id
    desired_server_name = local.name
    image_id            = var.os_snapshot_id
    os                  = var.os
    rebuild_generation  = var.rebuild_generation
    user_data_format    = "plain-mime"
    user_data_bytes     = length(data.cloudinit_config.rebuild_config.rendered)
    user_data_sha256    = sha256(data.cloudinit_config.rebuild_config.rendered)
    user_data           = data.cloudinit_config.rebuild_config.rendered
  }
}

output "domain_assignments" {
  description = "Assignment of domain to the primary IP of the server"
  value = [
    for rdns in hcloud_rdns.server : {
      domain = rdns.dns_ptr
      ips    = [rdns.ip_address]
    }
  ]
}
