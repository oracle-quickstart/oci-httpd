package test

type Inputs struct {
	Tenancy_ocid        string `json:"tenancy_ocid"`
	Compartment_ocid    string `json:"compartment_ocid"`
	User_ocid           string `json:"user_ocid"`
	Region              string `json:"region"`
	Fingerprint         string `json:"fingerprint"`
	Private_key_path    string `json:"private_key_path"`
	Ssh_public_key      string `json:"ssh_public_key"`
	Ssh_private_key     string `json:"ssh_private_key"`
	Loadbalancer_port   string `json:"loadbalancer_port"`
}
