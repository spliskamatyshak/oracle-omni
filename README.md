oracle-omni Cookbook
====================
This cookbook installs and configures all things Oracle database related.

Requirements
------------
TODO: List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.

e.g.
#### packages
- `parted` - oracle-omni needs for partitioning disks.

Attributes
----------
TODO: List your cookbook attributes here.

e.g.
#### oracle-omni::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['oracle-omni']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### oracle-omni::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `oracle-omni` in your node's `run_list`:

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
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Stephen Pliska-Matyshak (spliskamatyshak@almebezbik.com)
