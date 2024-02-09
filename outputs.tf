

output "calculated_aws_ami" {
  value = data.aws_ami.ubuntu.id
}

output "ubuntu_server_name" {
  value = data.aws_ami.ubuntu.name
}


