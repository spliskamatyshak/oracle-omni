oracle-omni Cookbook
====================
This cookbook is for installing all things Oracle database related. Options include ASM for storage, a variety of versions (as well as client install and EMagent installation in the plans).

Requirements
------------
This cookbook is intended to be used on hosts running Oracle's Linux version 6 or higher with the Unbreakable Kernel.  Base CentOS is also be a choice. However, this cookbook includes a recipe to convert it to OEL w/ UEK.

#### packages
- parted

Recipes
----------
### oracle-omni::default
This recipe installs and configures grid infrastructure (or not) and rdbms software based on the setting of the attributes listed below including those recipes indicated below.

| Key | Type | Description | Default |
|---|---|---|---|
| ['oracle-omni']['rdbms']['version'] | String | The version of the RDBMS to install | 12.1.0.2 |
| ['oracle-omni']['rdbms']['edition'] | String | The edition of the RDBMS to install | EE |
| ['oracle-omni']['oracle']['files_url'] | String | URL where media is stored (must be set unless using snapshot disks for cloning homes or locally mounted media for installing or cloning) | nil |
| ['oracle-omni']['oracle']['clone_homes'] | String | Whether to clone homes rather than install | false |
| ['oracle-omni']['oracle']['opatch_loc'] | String | (Base) Path to patch files for local media installations | nil |
| ['oracle-omni']['oracle']['opatch'] | String | Zip file for OPatch software (used during install method) | p6880880_112000_Linux-x86-64.zip or p6880880_121010_Linux-x86-64.zip (set based on version) |
| ['oracle-omni']['oracle']['patch_file'] | String | Zip file for GI PSU OCT2015 (used during install method) | p21523375_112040_Linux-x86-64.zip, p21744328_121010_Linux-x86-64.zip or p21523234_121020_Linux-x86-64.zip (set based on version) |

#### oracle-omni::prephost
This recipe prepares a host for the installation of Oracle software.

_This recipe is included in **default**._

##### oracle-omni::installrpms
This recipe installs all necessary rpms on host for the installation of Oracle software.

_This recipe is included in **prephost**._

| Key | Type | Description | Default |
|---|---|---|---|
| ['oracle-omni']['grid']['asmlib_rpm_url'] | String | URL to latest asmlib rpm | http://download.oracle.com/otn_software/asmlib |
| ['oracle-omni']['grid']['asmlib_rpm'] | String | Latest asmlib rpm | oracleasmlib-2.0.4-1.el6.x86_64.rpm or oracleasmlib-2.0.8-2.el7.x86_64.rpm |

##### oracle-omni::createusers
This recipe creates users and groups on host for the installation of Oracle software.

_This recipe is included in **prephost**._

| Key | Type | Description | Default |
|---|---|---|---|
| ['oracle-omni']['oracle']['home_dir'] | String | User home base directory | /home |
| ['oracle-omni']['rdbms']['user'] | String | User name for RDBMS home owner (Setting to something else is strongly discouraged) | oracle |
| ['oracle-omni']['rdbms']['uid'] | Integer | User ID for RDBMS home owner (Set as necessary) | 54321 |
| ['oracle-omni']['rdbms']['groups'] | Array | Groups to be created for use by oracle user (Set uids as necessary [example below]) | {'oinstall' => 54_321, 'dba' => 54_322, 'oper' => 54_323, 'backupdba' => 54_324, 'dgdba' => 54_325, 'kmdba' => 54_326, 'asmdba' => 54_329 } |
| ['oracle-omni']['grid']['user'] | String | User name for GI/ASM home owner (Setting to something else is strongly discouraged) | grid |
| ['oracle-omni']['grid']['uid'] | Integer | User ID for RDBMS home owner (Set as necessary) | 55322 |
| ['oracle-omni']['grid']['groups'] | Array | Groups to be created for use by grid user (Set uids as necessary [example below]) | {'oinstall' => 54_321, 'dba' => 54_322, 'asmoper' => 54_327, 'asmadmin' => 54_328, 'asmdba' => 54_329 } |

##### oracle-omni::createdirs
This recipe creates base directories on host for the installation of Oracle software.

_This recipe is included in **prephost**._

| Key | Type | Description | Default |
|---|---|---|---|
| ['oracle-omni']['oracle']['home_mount'] | String | Mount point of OFA software | /u01 |
| ['oracle-omni']['oracle']['ofa_base'] | String | Base directory of OFA software | #{node['oracle-omni']['oracle']['home_mount']}/app |
| ['oracle-omni']['oracle']['oracle_inventory'] | String | Inventory directory for Oracle software | #{node['oracle-omni']['oracle']['ofa_base']}/oraInventory |
| ['oracle-omni']['oracle']['install_dir'] | String | Directory for Oracle install media | #{node['oracle-omni']['oracle']['ofa_base']}/install |
| ['oracle-omni']['grid']['oracle_home'] | String | Home directory for GI software | #{node['oracle-omni']['oracle']['ofa_base']}/#{node['oracle-omni']['rdbms']['version']}/grid |
| ['oracle-omni']['rdbms']['oracle_base'] | String | Base directory for RDBMS software | #{node['oracle-omni']['oracle']['ofa_base']}/#{node['oracle-omni']['rdbms']['user']} |
| ['oracle-omni']['rdbms']['oracle_home'] | String | Home directory for RDBMS software | #{node['oracle-omni']['rdbms']['oracle_base']}/product/#{node['oracle-omni']['rdbms']['version']}/db<lowercase edition>_1 |

#### oracle-omni::clonegi or oracle-omni::installgi
These recipes are to clone grid infrastructure home or install one on a host. Only executed if ['oracle-omni']['rdbms']['storage_type'] is 'ASM'

_These recipes are included in **default**._

| Key | Type | Description | Default |
|---|---|---|---|
| ['oracle-omni']['grid']['clone_file'] | String | tar file of pre-created GI home for cloning (may include partial path) | nil |

#### oracle-omni::patchgi 
This recipe is used to patch Grid Infrastructure home after it is installed.

_These recipes are included in **default**._

| Key | Type | Description | Default |
|---|---|---|---|

#### oracle-omni::clonerdbms or oracle-omni::installrdbms
These recipes to clone a rdbms home or install one on a host.

_These recipes are included in **default**._

| Key | Type | Description | Default |
|---|---|---|---|
| ['oracle-omni']['rdbms']['clone_file'] | String | tar file of pre-created RDBMS home for cloning (may include partial path) | nil |

#### oracle-omni::patchrdbms 
This recipe is used to patch RDBMS home after it is installed.

_These recipes are included in **default**._

| Key | Type | Description | Default |
|---|---|---|---|

### oracle-omni::makeuek
This recipe is intended to be run prior to the default recipe in the case you have CentOS 6 (requires 2 reboots) or Oracle Linux 6 (requires 1 reboot) that is not UEK and wish to convert it to Oracle Linux UEK.

Usage
-----
### oracle-omni::default
TODO: Write usage instructions for each recipe.

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[oracle-omni]"
  ]
}
```

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Stephen Pliska-Matyshak
