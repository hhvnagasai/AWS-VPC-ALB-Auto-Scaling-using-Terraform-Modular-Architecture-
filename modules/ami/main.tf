resource "aws_ami_from_instance" "custom_ami" {
  name = "custom-ami-${replace(timestamp(), ":", "-")}"
  source_instance_id = var.instance_id

  lifecycle {
    create_before_destroy = true
  }
}
