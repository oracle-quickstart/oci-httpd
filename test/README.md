# Oracle Cloud Infrastructure Apache HTTP Server Terraform Module Unit Tests

## How to run tests?
Quick_start 
 * go test -v -run TestModuleApacheHttpQuickStart -timeout=60m
 * go test -v -run TestModuleApacheHttpsQuickStart -timeout=60m
Existing_infra
	Prepare terraform.tfvars and place in the examples/existing_infra directory before starting the below. Sample is available in env-vars in the same directory.
 * go test -v -run TestModuleApacheHttpExistingInfra -timeout=60m
 * go test -v -run TestModuleApacheHttpsExistingInfra -timeout=60m



