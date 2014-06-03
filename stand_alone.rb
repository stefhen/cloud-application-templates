# encoding: utf-8

name 'stefhen-standalone'
rs_ca_ver '20131202'
short_description 'Simple standalone CAT'

parameter 'cloud' do
  type 'string'
  label 'Cloud'
  description 'Which cloud do you wish to use?'
  allowed_values 'us-west-2', 'us-east-1'
end
