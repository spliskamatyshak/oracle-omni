#
# Cookbook Name:: oracle-omni
# Recipe:: patchhomes
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

execute 'generate_ocm_rsp' do
  command 'echo Y > echo; $ORACLE_HOME/OPatch/ocm/bin/emocmrsp \
    -no_banner < echo \'^M\'; chmod 775 ocm.rsp'
  environment(
    'ORACLE_HOME' => node['oracle-omni']['grid']['oracle_home']
  )
  user node['oracle-omni']['grid']['user']
  group node['oracle-omni']['grid']['groups'].keys.first
  cwd node['oracle-omni']['oracle']['patch_dir']
end
