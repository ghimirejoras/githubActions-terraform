output "public_ip" {
  value = aws_instance.nginx_instance.public_ip

}

output "instace_id" {
  value = aws_instance.nginx_instance.id
}

output "eip" {
  value = aws_eip.nginx_eip.public_ip
}

output "volume_id" {
  value = aws_ebs_volume.nginx_data_volume.id
}