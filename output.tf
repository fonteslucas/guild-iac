output "publicip" {
  value = aws_eip.web_ip.public_ip
}