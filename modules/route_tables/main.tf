resource "aws_route_table" "web" {
  vpc_id = var.vpc_id

  tags = {
    Name = "A4L-vpc1-rt-web"
  }
}

resource "aws_route" "web_ipv4_default" {
  route_table_id         = aws_route_table.web.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

resource "aws_route" "web_ipv6_default" {
  route_table_id              = aws_route_table.web.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = var.internet_gateway_id
}

resource "aws_route_table_association" "web_a" {
  subnet_id      = var.web_subnet_ids[0]
  route_table_id = aws_route_table.web.id
}

resource "aws_route_table_association" "web_b" {
  subnet_id      = var.web_subnet_ids[1]
  route_table_id = aws_route_table.web.id
}

resource "aws_route_table_association" "web_c" {
  subnet_id      = var.web_subnet_ids[2]
  route_table_id = aws_route_table.web.id
}