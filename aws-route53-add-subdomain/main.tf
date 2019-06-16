provider "aws" {
    region     = "${var.AWS_REGION}"
}

data "aws_route53_zone" "primary_zone" {
    name = "${var.DNS_ZONE_NAME}" # "test.com."
    private_zone="${var.IS_PRIVATE_ZONE}"
}

resource "aws_route53_record" "sub_domain" {
    zone_id = "${data.aws_route53_zone.primary_zone.zone_id}" # Replace with your zone ID
    name    = "${var.SUBDOMAIN}" # "sub.example.com" # Replace with your name/domain/subdomain
    type    = "A"
    alias {
        name                   = "${var.SANDBOX_DNS}"
        zone_id                = "${data.aws_route53_zone.primary_zone.zone_id}"
        evaluate_target_health = true
    }
}
