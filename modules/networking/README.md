# Module: networking

Creates a VPC with public and private subnets across multiple AZs, routing, an
Internet Gateway, and optional NAT Gateway(s) and VPC Flow Logs.

## Usage

```hcl
module "networking" {
  source = "../../modules/networking"

  name_prefix        = "acme-dev"
  vpc_cidr           = "10.0.0.0/16"
  az_count           = 2
  enable_nat_gateway = false   # paid; off by default
  enable_flow_logs   = false   # paid; off by default
  tags               = { Project = "acme" }
}
```

## Key inputs

| Name | Default | Description |
|------|---------|-------------|
| `name_prefix` | _(required)_ | Prefix for resource names |
| `vpc_cidr` | `10.0.0.0/16` | VPC CIDR |
| `az_count` | `2` | AZs to use when `availability_zones` is empty |
| `availability_zones` | `[]` | Explicit AZ list (overrides `az_count`) |
| `public_subnet_cidrs` / `private_subnet_cidrs` | `[]` | One per AZ; empty = auto-derive |
| `enable_nat_gateway` | `false` | NAT for private egress (**paid**) |
| `single_nat_gateway` | `true` | One shared NAT vs one per AZ |
| `enable_flow_logs` | `false` | VPC Flow Logs to CloudWatch (**paid**) |

## Key outputs

`vpc_id`, `vpc_cidr`, `public_subnet_ids`, `private_subnet_ids`,
`nat_gateway_ids`, `private_route_table_ids`, `internet_gateway_id`.

## Cost

VPC/subnets/IGW/route tables are free. **NAT Gateways and Flow Logs are paid** —
see [docs/costs.md](../../docs/costs.md).
