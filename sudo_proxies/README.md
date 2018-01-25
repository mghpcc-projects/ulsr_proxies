Directory of proxt scripts for accessing privileged IB commands
along with examples of a sudoers file for setting sudo access
to those scripts.

Contents

 ib/ibendis.sh        - script that carries out IB enable and disable command
                        using /usr/sbin/ibportstate. The script can restrict
                        actions to a list of GUID and port combinations given
                        in a config file "ulsr_ibproxy.conf". This provides
                        some protection against programming bugs in upper layers
                        that muddle GUIDs or port numbers etc...
           

 ib/iblinkinfo_me.sh  - /usr/sbin/iblinkinfo wrapper that queries just the
                        remote end(s) for the local host but does not allow
                        other options.

 ib/ulsr_ibproxy.conf - configuration file that can restrict the GUID and port
                        number pairs that ibendis.sh is allowed to work on.
                        
 sudoers_template/    - example of a sudoers config file that can be used to
                        allows access to these proxies to a certain user/group
                        without allowing access to other provileged commands. 
                        This assumes proxies are installed in their own separate
                        directory path - since sudoers manages access that way.
