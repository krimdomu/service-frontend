# load Rex modules with a featureset for version 0.45
use Rex -feature => ['0.45'];

# load the Rex CMDB
use Rex::CMDB;

# load Rex integration tests
use Rex::Test;

# load the function to read server groups from an ini file
use Rex::Group::Lookup::INI;

# read the server.ini file and create the server groups
groups_file "server.ini";

# configure the CMDB
# we're using the default YAML CMDB
# but we're defining some special lookup rules
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

# include some Rex module
# when we use the *include* function the tasks inside these modules
# won't get displayed by *rex -T*
include qw/
  Rex::OS::Base
  Rex::NTP::Base
  /;

# create the default *setup* task.
# this task just calls all the modules we want to use.
task setup => make {

  # run setup() task of Rex::OS::Base module
  Rex::OS::Base::setup();

  # run setup() task of Rex::NTP::Base module
  Rex::NTP::Base::setup();
};

# the last line of a Rexfile
1;
