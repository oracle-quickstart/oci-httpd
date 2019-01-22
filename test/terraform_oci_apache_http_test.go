package test

import (
        "os"
        "fmt"
	"testing"
        "strings"
	
        "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
        "github.com/stretchr/testify/assert"
	terraform_module "terraform-module-test-lib"
)

func TestModuleApacheHttpQuickStart(t *testing.T) {
	terraformDir := "../../examples/quick_start"

	terraformOptions := configureTerraformOptions(t, terraformDir)

	test_structure.RunTestStage(t, "init", func() {
		logger.Log(t, "terraform init ...")
		terraform.Init(t, terraformOptions)
	})
	defer test_structure.RunTestStage(t, "destroy", func() {
		logger.Log(t, "terraform destroy  ...")
		terraform.Destroy(t, terraformOptions)
	})
	test_structure.RunTestStage(t, "apply", func() {
		logger.Log(t, "terraform apply ...")
		terraform.Apply(t, terraformOptions)
	})
	test_structure.RunTestStage(t, "validate http", func() {
		logger.Log(t, "Verfiying  ...")
		validateByHTTP(t, terraformOptions)
	})

}

func TestModuleApacheHttpsQuickStart(t *testing.T) {
	terraformDir := "../../examples/quick_start"

	terraformOptions := configureTerraformOptions(t, terraformDir)

	test_structure.RunTestStage(t, "init", func() {
		logger.Log(t, "terraform init ...")
		terraform.Init(t, terraformOptions)
	})
	defer test_structure.RunTestStage(t, "destroy", func() {
		logger.Log(t, "terraform destroy  ...")
		terraform.Destroy(t, terraformOptions)
	})
	test_structure.RunTestStage(t, "apply", func() {
		logger.Log(t, "terraform apply ...")
		terraform.Apply(t, terraformOptions)
	})
	test_structure.RunTestStage(t, "validate http", func() {
		logger.Log(t, "Verfiying  ...")
		validateByHTTPs(t, terraformOptions)
	})

}

func TestModuleApacheHttpExistingInfra(t *testing.T) {
	terraformDir := "../../examples/existing_infra"

        logger.Log(t, "Set Environment variables ...")
	setEnvironmentvariables(t, terraformOptions)

	terraformOptions := configureTerraformOptions(t, terraformDir)

	test_structure.RunTestStage(t, "init", func() {
		logger.Log(t, "terraform init ...")
		terraform.Init(t, terraformOptions)
	})
	defer test_structure.RunTestStage(t, "destroy", func() {
		logger.Log(t, "terraform destroy  ...")
		terraform.Destroy(t, terraformOptions)
	})
	test_structure.RunTestStage(t, "apply", func() {
		logger.Log(t, "terraform apply ...")
		terraform.Apply(t, terraformOptions)
	})
	test_structure.RunTestStage(t, "validate http", func() {
		logger.Log(t, "Verfiying  ...")
		validateByHTTP(t, terraformOptions)
	})

}

func TestModuleApacheHttpsExistingInfra(t *testing.T) {
	terraformDir := "../../examples/existing_infra"

	terraformOptions := configureTerraformOptions(t, terraformDir)

	test_structure.RunTestStage(t, "init", func() {
		logger.Log(t, "terraform init ...")
		terraform.Init(t, terraformOptions)
	})
	defer test_structure.RunTestStage(t, "destroy", func() {
		logger.Log(t, "terraform destroy  ...")
		terraform.Destroy(t, terraformOptions)
	})
	test_structure.RunTestStage(t, "apply", func() {
		logger.Log(t, "terraform apply ...")
		terraform.Apply(t, terraformOptions)
	})
	test_structure.RunTestStage(t, "validate http", func() {
		logger.Log(t, "Verfiying  ...")
		validateByHTTPs(t, terraformOptions)
	})

}

func configureTerraformOptions(t *testing.T, terraformDir string) *terraform.Options {
        var vars Inputs
	err := terraform_module.GetConfig("inputs_config.json", &vars)
	if err != nil {
		logger.Logf(t, err.Error())
		t.Fail()
	}
	terraformOptions := &terraform.Options{
		TerraformDir: terraformDir,
		Vars: map[string]interface{}{
			"tenancy_ocid":        vars.Tenancy_ocid,
			"user_ocid":           vars.User_ocid,
			"fingerprint":         vars.Fingerprint,
			"region":              vars.Region,
			"compartment_ocid":    vars.Compartment_ocid,
			"private_key_path":    vars.Private_key_path,
			"ssh_public_key":      vars.Ssh_public_key,
			"ssh_private_key":     vars.Ssh_private_key,
		},
	}
	return terraformOptions
}

func validateByHTTP(t *testing.T, terraformOptions *terraform.Options) {
	t.Parallel()

        //txt := "It works"
        ip := terraform.Output(t, terraformOptions, "loadbalancer_ip")
        //port := terraformOptions.Vars["loadbalancer_port"].(string)
        port := "2018"
	url := fmt.Sprintf("http://%s:%s", ip, port)

	terraform_module.HTTPGetWithStatusValidation(t, url, 200)
	//terraform_module.HTTPGetWithBodyValidation(t, url, txt)
}

func validateByHTTPs(t *testing.T, terraformOptions *terraform.Options) {
	t.Parallel()

	// build key pair for ssh connections
	ssh_public_key_path := terraformOptions.Vars["ssh_public_key"].(string)
	ssh_private_key_path := terraformOptions.Vars["ssh_private_key"].(string)
	key_pair, err := terraform_module.GetKeyPairFromFiles(ssh_public_key_path, ssh_private_key_path)
	if err != nil {
                logger.Logf(t, err.Error())
		assert.NotNil(t, key_pair)
	}

        // Validate url
        pfile := "/tmp/pub_key.txt"
        ip := terraform.Output(t, terraformOptions, "loadbalancer_ip")
        port := "443"
        cert := terraform.Output(t, terraformOptions, "ca_certificate")
	command := fmt.Sprintf("echo \"%s\" > %s; wget https://%s:%s --ca-certificate=%s", cert, pfile, ip, port, pfile) 
	bastion_public_ip := terraform.Output(t, terraformOptions, "bastion_public_ip")
	result := terraform_module.SSHToHost(t, bastion_public_ip, "opc", key_pair, command)
        logger.Log(t, result)
	assert.True(t, strings.Contains(result, "index.html"))
}

func setEnvironmentVariables(t *testing.T, terraformOptions *terraform.Options) {
}
