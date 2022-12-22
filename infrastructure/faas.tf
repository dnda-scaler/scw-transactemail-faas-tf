locals {
  email_faas_archive_location ="../email_sender_faas/dist/email_sender_faas.zip"
}
resource "scaleway_iam_application" "email_sender" {
  name="email_sender_faas"
}
resource "scaleway_iam_api_key" "email_sender_faas_key" {
  application_id = scaleway_iam_application.email_sender.id
  description = "API Key for Faas email sended"
}

resource "scaleway_iam_policy" "iam_email_sender_policy" {
  name = "email_sender_policy"
  application_id = scaleway_iam_application.email_sender.id
  rule {
    project_ids          = [data.scaleway_account_project.current.id]
    permission_set_names = ["TransactionalEmailFullAccess"]
  }
}


resource "scaleway_function_namespace" "email_sender_faas_namespace" {
  name        = "email-sender"
  description = "Namespace for Tem Management"
}

resource "scaleway_function" "email_sender_faas" {
  namespace_id = scaleway_function_namespace.email_sender_faas_namespace.id
  name         = "email-sender-faas"
  runtime      = "node16"
  handler      = "index.handle"
  privacy      = "private"
  zip_file     = local.email_faas_archive_location
  zip_hash     = filesha256(local.email_faas_archive_location)
  deploy       = true
  min_scale    = 0
  max_scale    = 2
  environment_variables = {
    "SMTP_SERVER" = "smtp.tem.scw.cloud"
    #"SMTP_PORT" ="465" //Blocked on faas side
    "SMTP_PORT" ="2465" // This one is open on faas
    "SMTP_SECURE" = "true"
    "SCALEWAY_REGION"="fr-par"
  }
  secret_environment_variables = {
    "SCALEWAY_PROJECT_ID":data.scaleway_account_project.current.id
    "SCALEWAY_SECRET_KEY":scaleway_iam_api_key.email_sender_faas_key.secret_key
  }
}
output "faas_url" {
  value="https://${scaleway_function.email_sender_faas.domain_name}"
}