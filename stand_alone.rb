# encoding: utf-8

name 'stefhen-standalone'
rs_ca_ver '20131202'
short_description 'Simple standalone CAT'
long_description 'This is a simple single server deployment'

parameter 'cloud' do
  type 'string'
  label 'Cloud'
  description 'Which cloud do you wish to use?'
  allowed_values 'EC2 us-west-2', 'EC2 us-east-1'
end

parameter 'datacenter' do
  type 'string'
  label 'Datacenter'
  description 'Datacenter to use'
  allowed_values 'us-west-2a', 'us-east-1a'
end

resource 'server', type: 'server' do
  name 'Standalone Basic Server'
  cloud $cloud
  datacenter $datacenter
  instance_type 'm1.small'
  security_groups find('stefhen-sg')
  server_template_href '/api/server_templates/336642003'
end
