output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = [for k, v in aws_subnet.subnets : v.id]
}

output "subnets_outputs" {
  value = {
    for k, v in aws_subnet.subnets : k => {
      id  = v.id
      arn = v.arn
    }
  }
}

output "spy_ec2s" {
  value = [for k, v in aws_instance.spy_ec2s : v.id]
}

output "spy_ec2s_outputs" {
  value = {
    for k, v in aws_instance.spy_ec2s : k => {
      id  = v.id
      ami = v.ami
    }
  }
}
