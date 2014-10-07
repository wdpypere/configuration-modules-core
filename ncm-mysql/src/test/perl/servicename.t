# # -*- mode: cperl -*-
# ${license-info}
# ${author-info}
# ${build-info}

=pod

=head1 DESCRIPTION

Test the servicename option

=cut


use strict;
use warnings;
use Test::More;
use Test::Deep;
use Test::Quattor qw(basic_service);
use NCM::Component::mysql;
use CAF::Object;

my $cfg = get_config_for_profile('basic_service');
my $cmp = NCM::Component::mysql->new('mysql');

my $t = $cfg->getElement($cmp->prefix())->getTree();
my $gcmd = "/sbin/chkconfig --list mysqld";

$cmp->Configure($cfg);

my $cmd = get_command($gcmd);
ok(!defined($cmd), "chkconfig has not been run");

done_testing();
