# terraform-azure
Provision azure resources using Terraform

1) Provision 2 Linux VM in the same resource group, subnet and use same nsg

<pre><code>```mermaid graph TD A[Resource Group] --> B[VNet] B --> C[Subnet] C --> D[Linux VM] ```</code></pre>

