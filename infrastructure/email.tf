variable "mail_domain_prefix" {
  type=string
  default = "mail"
}
locals {
  mail_record="${var.mail_domain_prefix}.${var.dns_zone}"
  domain_id=trim(scaleway_tem_domain.mail_domain.id,format("%s/%s",scaleway_tem_domain.mail_domain.region,"/"))
}
resource "scaleway_tem_domain" "mail_domain" {
  name = local.mail_record
}

output "domain_validation_url" {
  value="https://api.scaleway.com/transactional-email/v1alpha1/regions/${scaleway_tem_domain.mail_domain.region}/domains/${local.domain_id}/check"
}
