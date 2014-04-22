# load Rex modules with a featureset for version 0.45
use Rex -feature => '0.45';

# load the Rex CMDB
use Rex::CMDB;

# load the function to read server groups from an ini file
use Rex::Group::Lookup::INI;

# read the server.ini file and create the server groups
groups_file "server.ini";

# configure the CMDB
# we're using the default YAML CMDB
set cmdb => {
  type => "YAML",
  path => "./cmdb",
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

1;    # the last line of a Rexfile
