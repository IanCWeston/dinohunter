output "dh-dns" {
    value       = aws_eip.dh_ip.public_dns
    description = "Public DNS of DinoHunter-Server"
}
