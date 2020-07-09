output "elk-dns" {
    value       = aws_eip.elk_ip.public_dns
    description = "Public DNS of Elk-VR-Server"
}
