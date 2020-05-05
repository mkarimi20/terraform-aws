
resource "aws_launch_configuration" "as_conf" {
  name = "web_conf"
  image_id = "${data.aws_ami.image.id}"
  instance_type = "t2.micro"
  provisioner "remote-exec" {
    connection {
      host        = "${file(~/.ssh/id_rsa.pub)}"
      type        = "ssh"
      user        = "centos" 
private_key = "${file(~/.ssh/id_rsa)}"
}
inline = [
  "sudo yum install -y epel-release",]
  } 
}


resource "aws_autoscaling_group" "someone" {
    name = "terraform_asg"
    launch_configuration = "${aws_launch_configuration.as_conf.name}"

    availability_zones = [
      "${var.region}a",
      "${var.region}b",
      "${var.region}c",
    ] 
    min_size = "${var.min_size}"
    max_size = "${var.max_size}"
    desired_capacity = "${var.desired_capacity}"
      
lifecycle {
  create_before_destroy = true
}
  
}
