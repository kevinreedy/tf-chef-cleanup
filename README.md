tf-chef-cleanup
===============

When using Terraform with the Chef provisioner, you may end up with leftover Node and Client objects on the Chef Server. By default, the Terraform Chef provisioner does not clean up these objects on destroy. This can be done by adding an additional provisioner with the property `when = "destroy"` to clean up.

## Testing

This can be tested quickly with these four commands:
```
terraform apply -auto-approve
terraform destroy -auto-approve
knife node list | grep kreedy_terraform_test
knife client list | grep kreedy_terraform_test
```

`test.sh` in this repo automates the above steps, but doesn't have a lot error checking, so use at your own risk.
