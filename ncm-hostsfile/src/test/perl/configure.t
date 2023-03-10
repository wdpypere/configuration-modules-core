#!/usr/bin/perl
use strict;
use warnings;
use Readonly;

use Test::More tests => 5;
use Test::NoWarnings;
use Test::Quattor qw(ipv4 ms_localhost);
use NCM::Component::hostsfile;
use Test::MockModule;

Test::NoWarnings::clear_warnings();

Readonly my $HOSTSFILE => '/tmp/hosts.local';

Readonly my $HOSTSFILE_INITIAL_IPV4 =>
'127.0.0.1		localhost.localdomain localhost
';

# The expected format of each line is:
# - the IP address
# - a single tab
# - the hostnames and aliases (padded up to 40 characters with spaces)
# - a single space
# - "# NCM"
# - the comment (if present) prepended with a space

Readonly my $HOSTSFILE_EXPECTED_IPV4 =>
'# Generated by Quattor component hostsfile 2.0.0
127.0.0.1		localhost.localdomain localhost
192.168.42.1	priv_1                      # NCM Private One
192.168.42.2	priv_2                      # NCM Private Two
192.168.42.3	priv_3                      # NCM Private Three
';

Readonly my $HOSTSFILE_EXPECTED_MS_LOCALHOST =>
'# Generated by Quattor component hostsfile 2.0.0
127.0.0.1	localhost                      # NCM
192.0.2.42	ms_localhost.example.org ms_localhost # NCM
';

# Mock LC::File methods
our $LCFile = Test::MockModule->new("LC::File");
$LCFile->mock(file_contents => sub ($;$) {return $HOSTSFILE_INITIAL_IPV4});

# Mock LC::Check methods
our $LCCheck = Test::MockModule->new("LC::Check");
our $file_contents = '';
$LCCheck->mock(file => sub ($;%) {
    my ( $self, $filename, $contents, $owner, $mode) = @_;
    $file_contents = $contents;
    return 1;
});

my $cmp = NCM::Component::hostsfile->new('hostsfile');
my $config = undef;


$config = get_config_for_profile('ipv4');
$file_contents = '';
is($cmp->Configure($config), 1, 'Component runs correctly with profile (ipv4)');
is($file_contents, $HOSTSFILE_EXPECTED_IPV4, 'Hostsfile updated with correct contents (ipv4)');


$config = get_config_for_profile('ms_localhost');
$file_contents = '';
is($cmp->Configure($config), 1, 'Component runs correctly with profile (ms_localhost)');
is($file_contents, $HOSTSFILE_EXPECTED_MS_LOCALHOST, 'Hostsfile updated with correct contents (ms_localhost)');