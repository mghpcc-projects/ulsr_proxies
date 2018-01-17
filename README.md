# ulsr_proxies
Proxy commands for user level slurm privileged actions.

The scripts in this directory are proxy scripts to
be called for privileged IB network actions that the User 
Level Slurm Researvations (ULSR) tool executes. The proxies
provide certain limits and checking that help ensure
the ULSR deployments for either development or production
do not mistakenly impact IB networks. 

ULSR needs to query local hosts for port and GUID information
of the switch port they are attched to. ULSR also needs
to disabel and enable switch ports for certain hosts.
These are privileged actions. The proxies in this project 
can be installed with sudo access to a limited group so 
that the privileged actions can be exposed with the
minimal set of options and with some safety checks.


