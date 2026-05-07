locals {
  shield_advanced_accounts              = [for account in flatten([for ou in data.aws_organizations_organizational_unit_descendant_accounts.shield_advanced_accounts : ou.accounts]) : account.id]
  shield_advanced_is_enabled_via_policy = contains(local.shield_advanced_accounts, data.aws_caller_identity.current.id)

  proactive_engagement_contact_defaults = {
    "aws-srt-alerts@powise.eu.opsgenie.net" = {
      contact_notes = "Please use this first to raise an alert with the appropriate team in our on-call system."
    },
    "ops@powise.com" = {
      contact_notes = "Operations Team. Please include on any correspondance."
    }
    "security@powise.com" = {
      contact_notes = "Security Team. Please include on any correspondance."
      phone_number  = "+34930000000"
    }
  }

  combined_proactive_engagement_contacts = merge(
    length(keys(var.override_proactive_engagement_contacts)) > 0 ? var.override_proactive_engagement_contacts : local.proactive_engagement_contact_defaults,
  var.additional_proactive_engagement_contacts)
}
