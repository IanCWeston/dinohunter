output "elk-dns" {
    value       = aws_eip.elk_ip.public_dns
    description = "Public DNS of Elk-VR-Server"
}

output "server-key-file" {
    value       = tls_private_key.elk-server-key.private_key_pem
    description = "SSH key file for ELK server"
}
