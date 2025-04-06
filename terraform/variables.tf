# variables.tf 

/*
variable "bucket" {}
variable "key" {}
variable "region" {}
variable "encrypt" {}
*/


variable "aws_region" {
  sensitive = true
}


/*

variable "aws_access_key_id" {
  sensitive = true
}

variable "aws_secret_access_key" {
  sensitive = true
}

*/

variable "bucketname" {
  sensitive = "true"
}
variable "ami_id" {
  sensitive = "true"
}
variable "instance_type" {
  sensitive = "true"
}
variable "vpc_cidr_block" {
  sensitive = "true"
}
variable "subnet_cidr_block" {
  sensitive = "true"
}
variable "availability_zone" {
  sensitive = "true"
}
variable "key_name" {
  sensitive = "true"
}
variable "ebs_volume_size" {
  sensitive = true
}
variable "ebs_volume_type" {

  sensitive = true
}
variable "public_key_path" {
  sensitive = true
}
variable "filelocation_prtkey" {}

variable "destination" {
  sensitive = true

}



variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}