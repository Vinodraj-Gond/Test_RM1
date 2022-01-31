resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl", {
    ip_addr = aws_instance.aquila.private_ip,
    efs_id   = aws_efs_file_system.aquila_efs.id
    }
  )
  filename = "./hosts"
}

resource "local_file" "IPOutput" {
  content = templatefile("ip.tmpl", {
    ip_addr = aws_instance.aquila.private_ip,
    }
  )
  filename = "./ouput-ip.txt"
}