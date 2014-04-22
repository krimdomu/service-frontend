# Building services out of blocks with Rex

If you have a large environment with multiple services and a complex architecture it is important to design your code in a way that you can reuse most parts of it.
To achieve this you need to follow some simple rules.

* Use a source control system like git.
* Build modules for every part of your architecture. A module should be generic and should not contain any project specific logic or configuration. For example a module to manage apache or ntp.
* Build services to tie the modules together. Services should hold all the project specific information need to build it.
* The code of every module and every service should be in a seperate code repository. With this it is easier to manage your infrastructure. You can create dependencies between services and modules on a branch level.
* Use a CMDB to seperate configuration from code.

## Source Control System

Currently Rex supports only *git* for module and service repositories. So in this example i will use git.

## Modules

As mentioned above, you should separate your code. For better readability, usability and maintainability of your code this is important.

Modules must be generic. The modules are a bit like lego blocks. You can use lego blocks to build houses, ships, airplanes and much more. But the blocks are always the same.

## Services

Services are a collection of modules. A service describe the system you want to build out of your module blocks.

## CMDB

Rex has a default CMDB build upon YAML files. Store all the service relevant configuration options inside your YAML file. If you do this you can be sure that your code will work even if you change something in the CMDB.

# Example frontend service

This is an example rex service.

## meta.yml - Define dependencies

In the *meta.yml* file you can define some service information. The most important ones are the dependencies.

You can define dependencies to Rex modules and to Perl modules.

```yaml
Name: Frontend Service
Description: The frontend service
Author: jan gehring <jan.gehring@gmail.com>
License: Apache 2.0
Requires:
  Rex::Ext::ParamLookup:
    git: https://bitbucket.org/jfried/rex-ext-paramlookup.git
    branch: master
  Rex::NTP::Base:
    git: https://bitbucket.org/jfried/rex-ntp-base.git
    branch: master
  Rex::OS::Base:
    git: https://bitbucket.org/jfried/rex-os-base.git
    branch: master
```

In this file you see that we define some dependencies to custom Rex modules located in git repositories.
The ```rexify --resolve-deps``` command will read the *meta.yml* file and download all these dependencies into the "lib" directory.

With this in mind it is easy to have multiple environments with the same service but with different development branches.


## Rexfile - The code

Every service has its own *Rexfile*.

```perl
use Rex -feature => ['0.45'];
use Rex::CMDB;
use Rex::Test;
use Rex::Group::Lookup::INI;
```

These lines loads all required modules.

* Line *1* Load the basic Rex functions and enable all features from version 0.45 and above.
* Line *2* Load the CMDB functions.
* Line *3* Load the Rex::Test suite. With this you can test your Rex code with local virtual box virtual machines.
* Line *4* Load the function to read Rex groups from ini files.


```perl
groups_file "server.ini";
```
Load all server groups from the file *server.ini*.



```perl
set cmdb => {
  type => "YAML",
  path => [
    "cmdb/{operatingsystem}/{hostname}.yml",
    "cmdb/{operatingsystem}/default.yml",
    "cmdb/{environment}/{hostname}.yml",
    "cmdb/{environment}/default.yml",
    "cmdb/{hostname}.yml",
    "cmdb/default.yml",
  ],
};
```

Configure the CMDB. Here we define a custom search path. This will tell the CMDB to lookup the keys in the following order:

* cmdb/{operatingsystem}/{hostname}.yml
* cmdb/{operatingsystem}/default.yml
* cmdb/{environment}/{hostname}.yml
* cmdb/{environment}/default.yml
* cmdb/{hostname}.yml
* cmdb/default.yml

It is possible to use every **Rex::Hardware** variable inside the path.

* environment (the environment defined by cli parameter *-E*)
* server (the server name used to connect to the server)
* kernelversion
* memory_cached
* memory_total
* kernelrelease
* hostname
* operatingsystem
* operatingsystemrelease
* architecture
* domain
* eth0_mac
* kernel
* swap_free
* memory_shared
* memory_used
* kernelname
* swap_total
* memory_buffers
* eth0_ip
* swap_used
* memory_free
* manufacturer
* eth0_broadcast
* eth0_netmask


```perl
include qw/
  Rex::OS::Base
  Rex::NTP::Base
  /;
```

Include all needed Rex modules. With **include** all the tasks inside these modules won't get displayed with *rex -T*.


```perl
task setup => make {
```

The main task.  If you don't define the servers (or groups) in the task definition you can use the cli paramter *-G* or *-H*.


```perl
task "setup", group => "frontend",  make {
```

It is also possible to define the server or group to connect to.


```perl
  # run setup() task of Rex::OS::Base module
  Rex::OS::Base::setup();

  # run setup() task of Rex::NTP::Base module
  Rex::NTP::Base::setup();
};

```

Inside the task we just call the tasks from the modules we have included above. All tasks can be called as a normal perl function, as long as the taskname doesn't conflict with other perl functions.



```perl
# the last line of a Rexfile
1;
```
The last line of a Rexfile is normaly a true value. This is not always needed, but it is safer to include it.


## Test before ship
