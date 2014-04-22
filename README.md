# Building services out of blocks with Rex

If you have a large environment with multiple services and a complex architecture it is important to design your code in a way that you can reuse most parts of it.
To achieve this you need to follow some simple rules.

* Use a source control system like git.
* Build modules for every part of your architecture. Module should be generic and should not contain any project specific logic or configuration. For example a module to manage apache or ntp.
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
