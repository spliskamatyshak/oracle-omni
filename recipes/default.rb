#
# Cookbook Name:: oracle-omni
# Recipe:: default
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

include_recipe 'oracle-omni::prephost'

if node['oracle-omni']['rdbms']['storage_type'] == 'ASM'
  if node['oracle-omni']['oracle']['clone_homes']
    include_recipe 'oracle-omni::clonegi'
    include_recipe 'oracle-omni::configureasm'
  else
    include_recipe 'oracle-omni::installgi'
    include_recipe 'oracle-omni::configureasm'
    include_recipe 'oracle-omni::patchgi'
  end
end

if node['oracle-omni']['oracle']['clone_homes']
  include_recipe 'oracle-omni::clonerdbms'
else
  include_recipe 'oracle-omni::installrdbms'
  include_recipe 'oracle-omni::patchrdbms'
end

if node['oracle-omni']['rdbms']['storage_type'] == 'ASM'
  include_recipe 'oracle-omni::createdbdgs'
else
  include_recipe 'oracle-omni::createmtpts'
end

include_recipe 'oracle-omni::createdb'
