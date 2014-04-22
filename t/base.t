use Rex::Test::Base;
use Data::Dumper;

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

  $t->finish;
};

1;
