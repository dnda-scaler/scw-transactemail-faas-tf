variable "dns_zone" {
  type=string
}
resource "scaleway_domain_record" "mx_record" {
  dns_zone = var.dns_zone
  name = var.mail_domain_prefix
  type = "MX"
  data = var.mail_domain_prefix
  ttl = 3600
  priority = 0
}

resource "scaleway_domain_record" "spf_record" {
  dns_zone = var.dns_zone
  type = "TXT"
  name = var.mail_domain_prefix
  data = "v=spf1 ${scaleway_tem_domain.mail_domain.spf_config} -all"
}

resource "scaleway_domain_record" "dkim_record" {
  dns_zone = var.dns_zone
  type = "TXT"
  //name = "8b836bb3-0ffb-4bb7-90bb-8dc01656ccc8._domainkey.mail" //How to get this value , it seems to be coming from project id
  name= "${data.scaleway_account_project.current.id}._domainkey.${var.mail_domain_prefix}"
  data = scaleway_tem_domain.mail_domain.dkim_config
}
