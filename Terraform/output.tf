output "elk-dns" {
    value       = aws_instance.elk-server.public_dns
    description = "Public DNS of Elk-Server"
}
