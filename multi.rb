# encoding: utf-8

name "stefhen-multi-tier"
rs_ca_ver "20131202"
short_description "3 Tier App"
long_description "Basic 3-Tier stack"

mapping "clouds" do {
  "EC2 us-west-2" => {
    "cloud_href"     => "/api/clouds/6",
    "us-west-2a"     => "/api/clouds/6/datacenters/BAJJAFGMFRO5G",
    "c1.medium"      => "/api/clouds/6/instance_types/1GFPQQ2KVKM",
    "m1.small"       => "/api/clouds/6/instance_types/1BH7SA9LMLFSV",
    "security_group" => "/api/clouds/6/security_groups/A68GO1Q5B9GJF",
    "ssh_key"        => "/api/clouds/6/ssh_keys/EDTM9LCHDNBBL" },
  "EC2 us-east-1" => {
    "cloud_href"     => "/api/clouds/1",
    "us-east-1a"     => "/api/clouds/1/datacenters/ATV0391A7LPF5",
    "c1.medium"      => "/api/clouds/1/instance_types/6U7NRRI3I0UM",
    "m1.small"       => "/api/clouds/1/instance_types/CQQV62T389R32",
    "security_group" => "/api/clouds/1/security_groups/FJK0P7V5JIJ12",
    "ssh_key"        => "/api/clouds/1/ssh_keys/13FIKG64LL5SG" }
  }
end

parameter "cloud" do
  type "string"
  label "Cloud"
  description "Which cloud do you wish to use?"
  allowed_values "EC2 us-west-2", "EC2 us-east-1"
end

parameter "datacenter" do
  type "string"
  label "Datacenter"
  description "Datacenter to use"
  allowed_values "us-west-2a", "us-east-1a"
end

parameter "instance_type" do
  type "string"
  label "Instance type"
  description "Instance size to use"
  allowed_values "m1.small", "c1.medium"
end

parameter "branch" do
  type "string"
  label "git branch"
  description "Git branch to clone"
  allowed_values "master", "PSST-60-GlusterMC"
end

resource "load_balancer", type: "server" do
  name "Load Balancer"
  cloud_href map($clouds, $cloud, "cloud_href")
  datacenter_href map($clouds, $cloud, $datacenter)
  instance_type_href map($clouds, $cloud, $instance_type) 
  security_groups_href map($clouds, $cloud, "security_group")
  ssh_key_href map($clouds, $cloud, "ssh_key")
  server_template_href("/api/server_templates/336538003")
end

resource "app_array", type: "server_array" do
  name "stefhen_application_array"
  array_type "alert"
  state "enabled"
  elasticity_params do {
    "bounds" => {
      "max_count" => 3,
      "min_count" => 2
    },
    "pacing" => {
      "resize_calm_time" => 5,
      "resize_down_by"   => 1,
      "resize_up_by"     => 1
    },
    "alert_specific_params" => {
      "decision_threshold"   => 51,
      "voters_tag_predicate" => "app_array"
    }
  } end
  cloud_href map($clouds, $cloud, "cloud_href")
  datacenter_href map($clouds, $cloud, $datacenter)
  instance_type_href map($clouds, $cloud, $instance_type) 
  security_groups_href map($clouds, $cloud, "security_group")
  ssh_key_href map($clouds, $cloud, "ssh_key")
  server_template_href("/api/server_templates/336642003")
  inputs do {
    "repo/default/repository" => "text:https://github.com/rs-services/cookbooks_internal",
    "repo/default/revision" => join(["text:",$branch])
  } end
end

operation "provision" do
  definition "provision"
  description "Launch hosts"
end

define provision(@load_balancer,@app_array) return @load_balancer,@app_array do
  concurrent do
    provision(@load_balancer)
    provision(@app_array)
  end
end

output do
  label "IP Address"
  category "Networking"
  value @load_balancer.public_ip_address
  description "Load Balancer Public IP"
end
