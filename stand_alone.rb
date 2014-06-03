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

resource 'server', type: 'server' do
  name 'Standalone Basic Server'
  cloud $cloud
  instance_type 'm1.small'
  securty_groups find('stefhen-sg')
  server_template_href '/api/server_templates/336642003'
end
