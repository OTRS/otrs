# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package Apache::Reload;

use strict;

$Apache::Reload::VERSION = '0.10';

use vars qw(%INCS %Stat $TouchTime %UndefFields);

%Stat = ($INC{"Apache/Reload.pm"} => time);

$TouchTime = time;

sub import {
    my $class = shift;
    my ($package,$file) = (caller)[0,1];
    
    $class->register_module($package, $file);
}

sub package_to_module {
    my $package = shift;
    $package =~ s/::/\//g;
    $package .= ".pm";
    return $package;
}

sub register_module {
    my ($class, $package, $file) = @_;
    my $module = package_to_module($package);
    
    if ($file) {
        $INCS{$module} = $file;
    }
    else {
        $file = $INC{$module};
        return unless $file;
        $INCS{$module} = $file;
    }
    
    no strict 'refs';
    if (%{"${package}::FIELDS"}) {
        $UndefFields{$module} = "${package}::FIELDS";
    }
}

sub handler {
    my $r = shift;
    
    my $DEBUG = ref($r) && (lc($r->dir_config("ReloadDebug") || '') eq 'on');
    
    my $TouchFile = ref($r) && $r->dir_config("ReloadTouchFile");
    
    my $TouchModules;
    
    if ($TouchFile) {
        warn "Checking mtime of $TouchFile\n" if $DEBUG;
        my $touch_mtime = (stat($TouchFile))[9] || return 1;
        return 1 unless $touch_mtime > $TouchTime;
        $TouchTime = $touch_mtime;
        my $sym = Apache->gensym;
        open($sym, $TouchFile) || die "Can't open '$TouchFile': $!";
        $TouchModules = <$sym>;
        chomp $TouchModules;
    }
    
    if (ref($r) && (lc($r->dir_config("ReloadAll") || 'on') eq 'on')) {
        *Apache::Reload::INCS = \%INC;
    }
    else {
        *Apache::Reload::INCS = \%INCS;
        my $ExtraList = 
                $TouchModules || 
                (ref($r) && $r->dir_config("ReloadModules")) || 
                '';
        my @extra = split(/\s+/, $ExtraList);
        foreach (@extra) {
            if (/(.*)::\*$/) {
                my $prefix = $1;
                $prefix =~ s/::/\//g;
                foreach my $match (keys %INC) {
                    if ($match =~ /^\Q$prefix\E/) {
                        $Apache::Reload::INCS{$match} = $INC{$match};
                        my $package = $match;
                        $package =~ s/\//::/g;
                        $package =~ s/\.pm$//;
                        no strict 'refs';
#                        warn "checking for FIELDS on $package\n";
                        if (%{"${package}::FIELDS"}) {
#                            warn "found fields in $package\n";
                            $UndefFields{$match} = "${package}::FIELDS";
                        }
                    }
                }
            }
            else {
                Apache::Reload->register_module($_);
            }
        }
    }
    
    my @changed;
    while (my($key, $file) = each %Apache::Reload::INCS) {
        local $^W;
        warn "Apache::Reload: Checking mtime of $key\n" if $DEBUG;
        
        my $mtime = (stat $file)[9];

        unless (defined($mtime) && $mtime) {
            for (@INC) {
                $mtime = (stat "$_/$file")[9];
                last if defined($mtime) && $mtime;
            }
        }

        warn("Apache::Reload: Can't locate $file\n"),next 
                unless defined $mtime and $mtime;
        
        unless (defined $Stat{$file}) {
            $Stat{$file} = $^T;
        }
		# remove the modules
        if ($mtime > $Stat{$file}) {
            delete $INC{$key};
            push @changed, $key;
	 	}
        $Stat{$file} = $mtime;
    }

	# reload the modules
	foreach my $key (@changed) {
        warn("Reloading $key\n") if $DEBUG;
        if (my $symref = $UndefFields{$key}) {
            warn("undeffing fields\n") if $DEBUG;
            no strict 'refs';
            undef %{$symref};
        }
        require $key;
        warn("Apache::Reload: process $$ reloading $key\n")
            if $DEBUG;
    }

    return 1;
}

1;
__END__

=head1 NAME

Apache::Reload - Reload changed modules

=head1 SYNOPSIS

In httpd.conf:

  PerlInitHandler Apache::Reload
  PerlSetVar ReloadAll Off

Then your module:

  package My::Apache::Module;

  use Apache::Reload;
  
  sub handler { ... }
  
  1;

=head1 DESCRIPTION

This module is two things. First it is an adaptation of Randal
Schwartz's Stonehenge::Reload module that attempts to be a little 
more intuitive and makes the usage easier. Stonehenge::Reload was
written by Randal to make specific modules reload themselves when
they changed. Unlike Apache::StatINC, Stonehenge::Reload only checked
the change time of modules that registered themselves with 
Stonehenge::Reload, thus reducing stat() calls. Apache::Reload also
offers the exact same functionality as Apache::StatINC, and is thus
designed to be a drop-in replacement. Apache::Reload only checks modules
that register themselves with Apache::Reload if you explicitly turn off
the StatINC emulation method (see below). Like Apache::StatINC,
Apache::Reload must be installed as an Init Handler.

=head2 StatINC Replacement

To use as a StatINC replacement, simply add the following configuration
to your httpd.conf:

  PerlInitHandler Apache::Reload

=head2 Register Modules Implicitly

To only reload modules that have registered with Apache::Reload,
add the following to the httpd.conf:

  PerlInitHandler Apache::Reload
  PerlSetVar ReloadAll Off
  # ReloadAll defaults to On

Then any modules with the line:

  use Apache::Reload;

Will be reloaded when they change.

=head2 Register Modules Explicitly

You can also register modules explicitly in your httpd.conf file that
you want to be reloaded on change:

  PerlInitHandler Apache::Reload
  PerlSetVar ReloadAll Off
  PerlSetVar ReloadModules "My::Foo My::Bar Foo::Bar::Test"

Note that these are split on whitespace, but the module list B<must>
be in quotes, otherwise Apache tries to parse the parameter list.

=head2 Special "Touch" File

You can also set a file that you can touch() that causes the reloads to be
performed. If you set this, and don't touch() the file, the reloads don't
happen. This can be a great boon in a live environment:

  PerlSetVar ReloadTouchFile /tmp/reload_modules

Now when you're happy with your changes, simply go to the command line and
type:

  touch /tmp/reload_modules

And your modules will be magically reloaded on the next request. This option
works in both StatINC emulation mode and the registered modules mode.

=head1 PSUEDOHASHES

The short summary of this is: Don't use psuedohashes. Use an array with
constant indexes. Its faster in the general case, its more guaranteed, and
generally, it works.

The long summary is that I've done some work to get this working with
modules that use psuedo hashes, but its still broken in the case of a
single module that contains multiple packages that all use psuedohashes.

So don't do that.

=head1 AUTHOR

Matt Sergeant, matt@sergeant.org

=head1 MAINTAINERS

the mod_perl developers, dev@perl.apache.org

=head1 SEE ALSO

Apache::StatINC, Stonehenge::Reload

=cut
