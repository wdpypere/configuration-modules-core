use strict;
use warnings;

use Test::More;
use Test::Quattor qw(simple);
use NCM::Component::altlogrotate;
use Test::MockModule;

my $mock = Test::MockModule->new('NCM::Component::altlogrotate');

my $comp = NCM::Component::altlogrotate->new('altlogrotate');

is_deeply([$comp->_glob('src/test/perl/simpl*t')], ['src/test/perl/simple.t']);

my $glob;
my $globargs;
$mock->mock('_glob', sub {shift; $globargs = \@_; return @$glob;});

$CAF::Object::NoAction = 1;

my $header = "\n#\n# Generated by ncm-altlogrotate.\n#\n";

# w/o header
my $test1 = <<EOF;
a/b/c/*-2???-??-??.log {
compress
ifempty
missingok
rotate 1
daily
create 0751 someuser agroup
mailfirst
nomail
tabooext a,b
su foouser bargroup
lastaction

/run/this

endscript
}
EOF

my $config = get_config_for_profile("simple");

$glob = [map {"/etc/logrotate.d/$_.ncm-altlogrotate"} qw(test1 deleteme)];

# This also creates the mocked file, actual content is irrelevant
set_file_contents("/etc/logrotate.d/test3_overwrite_with_file", "something");

ok($comp->Configure($config), 'Configure ran succesful');

is_deeply($globargs, ['/etc/logrotate.d/*.ncm-altlogrotate'], "glob was called with correct file pattern");

my $fh = get_file("/etc/logrotate.conf");
is("$fh", "${header}include some_file\nsomething {\nnotifempty\ntabooext + a,b\n}\n",
   "correct global config entry");

$fh = get_file("/etc/logrotate.d/test1.ncm-altlogrotate");
is("$fh", "$header$test1", "correct test1 config entry");
unlike("$fh", qr{frequency}, "no frequency keyword in frequency (daily value) entry");

$fh = get_file("/etc/logrotate.d/test3_overwrite_with_file");
is("$fh", "${header}test3 {\ncompress\n}\n", "correct test3 overwrite with file config entry");

# no file, gets file suffix
$fh = get_file("/etc/logrotate.d/test4_overwrite_no_file.ncm-altlogrotate");
is("$fh", "${header}test4 {\ncompress\n}\n", "correct test4 overwrite no file config entry");

# only one file was deleted
diag explain $Test::Quattor::caf_path->{cleanup};
is_deeply($Test::Quattor::caf_path->{cleanup},
          [[['/etc/logrotate.d/deleteme.ncm-altlogrotate', undef], {}]], # one file, no opts
          "correct files cleaned up");

done_testing();
