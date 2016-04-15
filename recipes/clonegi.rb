#
# Cookbook Name:: oracle-omni
# Recipe:: clonegi
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

dir = node['oracle-omni']['oracle']['install_dir']
url = node['oracle-omni']['oracle']['files_url']
file = if url.nil?
         node['oracle-omni']['grid']['clone_file']
       else
         File.basename(node['oracle-omni']['grid']['clone_file'])
       end
oh = node['oracle-omni']['grid']['oracle_home']
ob = node['oracle-omni']['rdbms']['oracle_base']
inv = node['oracle-omni']['oracle']['oracle_inventory']
usr = node['oracle-omni']['grid']['user']
grp = node['oracle-omni']['grid']['groups'].keys.first

# Download GI tarball
unless url.nil?
  remote_file "#{dir}/#{file}" do
    owner usr
    group grp
    mode '0644'
    source "#{url}/#{node['oracle-omni']['grid']['clone_file']}"
    not_if { File.directory?("#{oh}/bin") }
  end
end

# Unpack tarball
execute 'untar_grid' do
  command "tar -zxf #{dir}/#{file}"
  cwd oh
  not_if { File.directory?("#{oh}/bin") }
  only_if { File.exist?("#{dir}/#{file}") }
end

# Remove tarball
file "#{dir}/#{file}" do
  action :delete
  owner usr
  group grp
  only_if { File.exist?("#{dir}/#{file}") }
  only_if { File.directory?("#{oh}/bin") }
  not_if { url.nil? }
end

execute 'clean_home' do
  command 'rm -rf cfgtoollogs/* cdata/* crs/install/crsconfig_params \
    inventory/backup/*'
  cwd oh
  not_if "grep -q \"#{oh}\" #{inv}/ContentsXML/inventory.xml"
end

execute 'clone_home' do
  command "#{oh}/perl/bin/perl #{oh}/clone/bin/clone.pl -silent \
    ORACLE_BASE=#{ob} ORACLE_HOME=#{oh} INVENTORY_LOCATION=#{inv} \
    ORACLE_HOME_NAME=OraGIHome OSDBA_GROUP=asmdba OSASM_GROUP=asmadmin \
    OSOPER_GROUP=asmoper LOCAL_NODE=#{node['hostname']}"
  user usr
  group grp
  not_if "grep -q \"#{oh}\" #{inv}/ContentsXML/inventory.xml"
end

execute 'run_roothas' do
  command "#{oh}/perl/bin/perl -I#{oh}/perl/lib -I#{oh}/crs/install \
    #{oh}/crs/install/roothas.pl"
  not_if 'ps -ef | grep ohasd | grep -v grep'
end

execute 'run_orainstRoot' do
  command "#{inv}/orainstRoot.sh"
  user 'root'
  group 'root'
  only_if { File.exist?("#{inv}/orainstRoot.sh") }
end

execute 'run_root' do
  command "#{oh}/root.sh"
  user 'root'
  group 'root'
end
