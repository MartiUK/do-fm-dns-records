resource "digitalocean_record" "root_mx" {
  for_each = var.mx_records
  domain   = var.domain
  type     = "MX"
  name     = "@"
  value    = each.value
  priority = each.key
}

resource "digitalocean_record" "splat_mx" {
  for_each = var.enable_subdomain_addresses ? var.mx_records : {}
  domain   = var.domain
  type     = "MX"
  name     = "*"
  value    = each.value
  priority = each.key
}

resource "digitalocean_record" "hosting_a" {
  for_each = var.enable_fm_file_storage_hosting ? var.hosting_a_records : []
  domain   = var.domain
  name     = "@"
  type     = "A"
  value    = each.key
}

resource "digitalocean_record" "subdomain_hosting_a" {
  for_each = var.enable_subdomain_fm_file_storage_hosting ? var.hosting_a_records : []
  domain   = var.domain
  name     = "*"
  type     = "A"
  value    = each.key
}

resource "digitalocean_record" "mail_a" {
  for_each = var.enable_mail_login ? var.mail_a_records : []
  domain   = var.domain
  name     = "mail"
  type     = "A"
  value    = each.key
}

// If mail A record is enabled to allow logging in from mail.example.com we must add a specific MX record to allow mail
// to be sent to an address like: foo@mail.example.com

resource "digitalocean_record" "mail_mx" {
  for_each = var.enable_mail_login ? var.mx_records : {}
  domain   = var.domain
  type     = "MX"
  name     = "mail"
  value    = each.value
  priority = each.key
}

resource "digitalocean_record" "dkim_cname" {
  for_each = var.enable_dkim_records ? var.dkim_records : []
  domain   = var.domain
  name     = "${each.key}._domainkey.${var.domain}"
  type     = "CNAME"
  value    = "${each.key}.${var.domain}.dkim.fmhosted.com."
}

resource "digitalocean_record" "spf_txt" {
  for_each = var.enable_spf_records ? var.spf_records : []
  domain   = var.domain
  name     = "@"
  type     = "TXT"
  value    = each.key
}

resource "digitalocean_record" "autodiscover_srv" {
  for_each = var.enable_email_autodiscovery ? var.autodiscovery_records : {}
  domain   = var.domain
  name     = "${each.key}._tcp.${var.domain}"
  type     = "SRV"
  value    = each.value["value"]
  priority = each.value["priority"]
  weight   = each.value["weight"]
  port     = each.value["port"]
}

resource "digitalocean_record" "carddav_srv" {
  for_each = var.enable_carddav_autodiscovery ? var.carddav_records : {}
  domain   = var.domain
  name     = "${each.key}._tcp.${var.domain}"
  type     = "SRV"
  value    = each.value["value"]
  priority = each.value["priority"]
  weight   = each.value["weight"]
  port     = each.value["port"]
}

resource "digitalocean_record" "caldav_srv" {
  for_each = var.enable_caldav_autodiscovery ? var.caldav_records : {}
  domain   = var.domain
  name     = "${each.key}._tcp.${var.domain}"
  type     = "SRV"
  value    = each.value["value"]
  priority = each.value["priority"]
  weight   = each.value["weight"]
  port     = each.value["port"]
}
