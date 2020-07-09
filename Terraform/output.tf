output "elk-dns" {
    value       = aws_instance.elk_vr-server.public_dns
    description = "Public DNS of Elk-Server"
}
