resource "aws_s3_bucket" "terraform-state" {
    bucket = "terraform-state-heri4"
    acl = "private"

    tags {
        Name = "Terraform state"
    }
}
