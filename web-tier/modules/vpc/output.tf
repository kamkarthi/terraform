output "mainvpc_id" {
  value = aws_vpc.mainvpc.id
}




output "private_subnet_ids" {
  value = aws_subnet.private-subnet.*.id
}

output "public_subnet_ids" {
  value = aws_subnet.public-subnet.*.id
}
