# ebs.tf 

resource "aws_ebs_volume" "nginx_data_volume" {
  availability_zone = aws_instance.nginx_instance.availability_zone
  size              = var.ebs_volume_size
  type              = var.ebs_volume_type
  encrypted         = true

  tags = {
    Name = "nginx-data-volume"
  }
}


resource "aws_volume_attachment" "nginx_volume_attachment" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.nginx_data_volume.id
  instance_id = aws_instance.nginx_instance.id
}

