variable "vpc_cidr" {
  type        = string
  description = "CIDR for VPC"
  default     = "10.0.0.0/16"
}

variable "subnets" {
  description = "Map of subnet objects"
  type = map(object({
    cidr = string
    az   = string
    public = bool
    no = number
  }))

  default = {
    subnet-1 = {
      cidr   = "10.0.1.0/24"
      az     = "us-east-1a"
      public = true
      no = 1
    }
    subnet-2 = {
      cidr   = "10.0.2.0/24"
      az     = "us-east-1a"
      public = true
      no = 2
    }
    subnet-3 = {
      cidr   = "10.0.3.0/24"
      az     = "us-east-1a"
      public = false
      no = 3
    }
  }
}

variable "spy_ec2s" {
  description = "Map of ec2s objects"
  type = map(object({
    keypair           = string
    instance_type = string
    public        = bool
    ami = string
    no = number
  }))

  default = {
    "spy_ec2s-01" = {
        no = 1
      keypair           = "spy-docker-key"
      instance_type = "t2.micro"
      public        = true
      ami = "ami-0ecb62995f68bb549"
    }
    "spy_ec2s-02" = {
      no = 2
      keypair           = "spy-docker-key"
      instance_type = "t2.micro"
      public        = true
      ami = "ami-0ecb62995f68bb549"
    }
    "spy_ec2s-03" = {
      no = 3
      keypair           = "spy-docker-key"
      instance_type = "t2.micro"
      public        = true
      ami = "ami-0ecb62995f68bb549"
    }
  }
}
