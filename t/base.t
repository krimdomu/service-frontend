use Rex::Test::Base;
use Data::Dumper;
use Rex -base;

test {
  my $t = shift;

  $t->name("ubuntu test");

  $t->base_vm("http://box.rexify.org/box/ubuntu-server-12.10-amd64.ova");
  $t->vm_auth(user => "root", password => "box");

  $t->run_task("setup");

  $t->has_package("vim");
  $t->has_package("ntp");
  $t->has_package("unzip");

  $t->has_file("/etc/ntp.conf");

  $t->has_service_running("ntp");

  $t->has_content("/etc/passwd", qr{root:x:0:}ms);

  run "ls -l";
  $t->test_ok($? == 0, "ls -l returns success.");

  $t->finish;
};

1;
