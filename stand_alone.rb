# encoding: utf-8

name "stefhen-standalone"
rs_ca_ver "20131202"
short_description "Simple standalone CAT"
long_description "This is a simple single server deployment"

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

resource "standalone_server", type: "server" do
  name "Standalone Basic Server"
  cloud_href map($clouds, $cloud, "cloud_href")
  datacenter_href map($clouds, $cloud, $datacenter)
  instance_type_href map($clouds, $cloud, $instance_type) 
  security_groups_href map($clouds, $cloud, "security_group")
  ssh_keys_href map($clouds, $cloud, "ssh_key")
  server_template find("stefhen - Base ServerTemplate for Linux Alpha (v14.0.0)", revision: 0)
end
