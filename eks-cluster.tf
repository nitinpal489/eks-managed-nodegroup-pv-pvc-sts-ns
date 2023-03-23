module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  cluster_name    = local.cluster_name
  cluster_version = "1.25"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

    attach_cluster_primary_security_group = true

    # Disabling and using externally provided security groups
    create_security_group = false
  }

  eks_managed_node_groups = {
    one = {
      name = "frontend"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
      desired_size = 1

      vpc_security_group_ids = [
        aws_security_group.node_group_one.id
      ]
    }
    tags = {
      Name = "Frontend"
    }

    two = {
      name = "backend"

      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 1

      vpc_security_group_ids = [
        aws_security_group.node_group_two.id
      ]
    }
    tags = {
      Name = "Backend"
    }

    three = {
      name = "Monitoring"

      instance_types = ["t2.micro"]

      min_size     = 1
      max_size     = 2
      desired_size = 1

      vpc_security_group_ids = [
        aws_security_group.node_group_two.id
      ]
    }
    tags = {
      Name = "Monitoring"
    }
  }
}
