# IP REPO
---

This folder contains custom IP blocks created for Xilinx FPGAs using the Vivado tool suite.

Custom IPs can be added to a Vivado block design by adding this repo to your list of repositories. Either through the GUI:

- Tools -> Settings
- IP -> Repository

Or by running this command in the TCL console:

     set_property  ip_repo_paths  {<path to repo>/ip_repo {<exisiting IP repo paths}} [current_project]
     update_ip_catalog
