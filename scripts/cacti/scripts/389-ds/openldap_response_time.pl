#! /usr/bin/perl -w

#====================================================================
# What's this ?
#====================================================================
# Script designed for cacti [ http://www.cacti.net ]
# Gives the time to do these LDAP operations :
# - bind (anonymous or not)
# - RootDSE base search
# - suffix (found in RootDSE) sub search (20 entries max) 
#
# Copyright (C) 2005 Clement OUDOT
# Copyright (C) 2005 LINAGORA
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#====================================================================

#====================================================================
# Modules
#====================================================================
use strict;
use Net::LDAP;
use Getopt::Std;
use Time::HiRes qw(gettimeofday);

#====================================================================
# Configuration
#====================================================================
# Command line parameters
my ($host, $port, $binddn, $bindpw, $timeout, $ldap_version) = &options;

# Name of the Operations branch in monitor
my $branch = "cn=Operations,cn=Monitor";

#====================================================================
# options() subroutine
#====================================================================
sub options {
	# Init Options Hash Table
	my %opts;
	getopt('hpDWtv',\%opts);
	&usage unless exists $opts{"h"};
	$opts{"p"} = 389 unless exists $opts{"p"};
	$opts{"t"} = 5 unless exists $opts{"t"};
	$opts{"v"} = 3 unless exists $opts{"v"};

	return ($opts{"h"}, $opts{"p"}, $opts{"D"}, $opts{"W"}, $opts{"t"}, $opts{"v"});
}

#====================================================================
# usage() subroutine
#====================================================================
sub usage {
	print STDERR "Usage: $0 -h host [-p port] [-D binddn -W bindpw] [-t timeout] [-v ldap_version]\n";
	print STDERR "Default values are :\n";
	print STDERR "\tport: 389\n\tbinddn/bindpw: without (anonymous connection)\n\ttimeout: 5\n\tldap_version: 3\n";
	exit 1;
}

#====================================================================
# Connection to OpenLDAP monitor
#====================================================================
# Create LDAP connection
my $ldap = Net::LDAP->new(	$host, 
				port => $port,
				version => $ldap_version,
				timeout => $timeout) or die "Unable to connect to $host on port $port\n";

# Bind (anonymous or no)
my $bind_time = gettimeofday();
my $bind;

if ($binddn && $bindpw) {
	$bind = $ldap->bind($binddn, password => $bindpw);
} else {
	$bind = $ldap->bind;
}

if ($bind->code) {
	print "bind:U rootdsesearch:U suffixsearch:U\n";
	print STDERR "Bind : ".$bind->error."\n";
	exit 1;
}
$bind_time = gettimeofday() - $bind_time;

# RootDSE Search
my $rootdsesearch_time = gettimeofday();
my $search = $ldap->search( 	base => '',
				scope => 'base',
				filter => 'objectClass=*',
				attrs => ['namingContexts'],
				timelimit => "$timeout");

if ($search->code) {
	print "bind:$bind_time rootdsesearch:U suffixsearch:U\n";
	$ldap->unbind;
	print STDERR "Root DSE search : ".$search->error." (code ".$search->code.")\n";
	exit 1 ;
}
$rootdsesearch_time = gettimeofday() - $rootdsesearch_time,

# Suffix search
my $suffix = ($search->shift_entry())->get_value('namingContexts');
my $suffix_time = gettimeofday();
my $suffix_search = $ldap->search(	base => "$suffix",
					scope => 'sub',
					filter => 'objectClass=*',
					attrs => ['1.1'],
					sizelimit => '20',
					timelimit => "$timeout");

if ($suffix_search->code && $suffix_search->code != 4) {
	print "bind:$bind_time rootdsesearch:$rootdsesearch_time suffixsearch:U\n";
	$ldap->unbind;
	print STDERR "Suffix search : ".$suffix_search->error." (code ".$suffix_search->code.")\n";
	exit 1 ;
}
$suffix_time = gettimeofday() - $suffix_time,

# Unbind
$ldap->unbind;

#====================================================================
# Print results
#====================================================================
print "bind:$bind_time rootdsesearch:$rootdsesearch_time suffixsearch:$suffix_time\n";

#====================================================================
# Exit
#====================================================================
exit 0;
