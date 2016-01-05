#
# Cookbook Name:: oracle-omni
# Recipe:: prephost
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

include_recipe 'oracle-omni::installrpms'
include_recipe 'oracle-omni::setlimits'
include_recipe 'oracle-omni::createusers'
include_recipe 'oracle-omni::createdirs'
include_recipe 'oracle-omni::partitiondisks'
include_recipe 'oracle-omni::setupasm' if node['oracle-omni']['rdbms']['storage_type'] == 'ASM'
