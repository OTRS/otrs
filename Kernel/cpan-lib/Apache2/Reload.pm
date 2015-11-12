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
#
package Apache2::Reload;

use strict;
use warnings FATAL => 'all';

our $VERSION = '0.12';

use Apache2::Const -compile => qw(OK);

use Apache2::Connection;
use Apache2::ServerUtil;
use Apache2::RequestUtil;

use ModPerl::Util ();

use vars qw(%INCS %Stat $TouchTime);

%Stat = ($INC{"Apache2/Reload.pm"} => time);

$TouchTime = time;

sub import {
    my $class = shift;
    my ($package, $file) = (caller)[0,1];

    $class->register_module($package, $file);
}

sub package_to_module {
    my $package = shift;
    $package =~ s/::/\//g;
    $package .= ".pm";
    return $package;
}

sub module_to_package {
    my $module = shift;
    $module =~ s/\//::/g;
    $module =~ s/\.pm$//g;
    return $module;
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
}

sub unregister_module {
    my ($class, $package) = @_;
    my $module = package_to_module($package);
    delete $INCS{$module};
}

# the first argument is:
# $c if invoked as 'PerlPreConnectionHandler'
# $r if invoked as 'PerlInitHandler'
sub handler {
    my $o = shift;
    $o = $o->base_server if ref($o) eq 'Apache2::Connection';

    my $DEBUG = ref($o) && (lc($o->dir_config("ReloadDebug") || '') eq 'on');

    my $ReloadByModuleName = ref($o) && (lc($o->dir_config("ReloadByModuleName") || '') eq 'on');

    my $TouchFile = ref($o) && $o->dir_config("ReloadTouchFile");

    my $ConstantRedefineWarnings = ref($o) && 
        (lc($o->dir_config("ReloadConstantRedefineWarnings") || '') eq 'off') 
            ? 0 : 1;

    my $TouchModules;

    if ($TouchFile) {
        warn "Checking mtime of $TouchFile\n" if $DEBUG;
        my $touch_mtime = (stat $TouchFile)[9] || return Apache2::Const::OK;
        return Apache2::Const::OK unless $touch_mtime > $TouchTime;
        $TouchTime = $touch_mtime;
        open my $fh, $TouchFile or die "Can't open '$TouchFile': $!";
        $TouchModules = <$fh>;
        chomp $TouchModules if $TouchModules;
    }

    if (ref($o) && (lc($o->dir_config("ReloadAll") || 'on') eq 'on')) {
        *Apache2::Reload::INCS = \%INC;
    }
    else {
        *Apache2::Reload::INCS = \%INCS;
        my $ExtraList = 
                $TouchModules || 
                (ref($o) && $o->dir_config("ReloadModules")) || 
                '';
        my @extra = split /\s+/, $ExtraList;
        foreach (@extra) {
            if (/(.*)::\*$/) {
                my $prefix = $1;
                $prefix =~ s/::/\//g;
                foreach my $match (keys %INC) {
                    if ($match =~ /^\Q$prefix\E/) {
                        $Apache2::Reload::INCS{$match} = $INC{$match};
                    }
                }
            }
            else {
                Apache2::Reload->register_module($_);
            }
        }
    }

    my $ReloadDirs = ref($o) && $o->dir_config("ReloadDirectories");
    my @watch_dirs = split(/\s+/, $ReloadDirs||'');
    
    my @changed;
    foreach my $key (sort { $a cmp $b } keys %Apache2::Reload::INCS) {
        my $file = $Apache2::Reload::INCS{$key};

        next unless defined $file;
        next if ref $file;
        next if @watch_dirs && !grep { $file =~ /^$_/ } @watch_dirs;
        warn "Apache2::Reload: Checking mtime of $key\n" if $DEBUG;

        my $mtime = (stat $file)[9];

        unless (defined($mtime) && $mtime) {
            for (@INC) {
                $mtime = (stat "$_/$file")[9];
                last if defined($mtime) && $mtime;
            }
        }

        warn("Apache2::Reload: Can't locate $file\n"), next
            unless defined $mtime and $mtime;

        unless (defined $Stat{$file}) {
            $Stat{$file} = $^T;
        }

        if ($mtime > $Stat{$file}) {
            push @changed, [$key, $file];
        }
        $Stat{$file} = $mtime;
    }
    
    #First, let's unload all changed modules
    foreach my $change (@changed) {
        my ($module, $file) = @$change;
        my $package = module_to_package($module);
        ModPerl::Util::unload_package($package);
    }

    #Then, let's reload them all, so that module dependencies can satisfy
    #themselves in the correct order.
    foreach my $change (@changed) {
        my ($module, $file) = @$change;
        my $name = $ReloadByModuleName ? $module : $file;
        require $name;
        if ($DEBUG) {
          my $package = module_to_package($module);
          warn sprintf("Apache2::Reload: process %d reloading %s from %s\n",
            $$, $package, $name);
        }
    }

    return Apache2::Const::OK;
}

1;

__END__

=head1 NAME

Apache2::Reload - Reload Perl Modules when Changed on Disk

=head1 Synopsis

  # Monitor and reload all modules in %INC:
  # httpd.conf:
  PerlModule Apache2::Reload
  PerlInitHandler Apache2::Reload

  # when working with protocols and connection filters
  # PerlPreConnectionHandler Apache2::Reload

  # Reload groups of modules:
  # httpd.conf:
  PerlModule Apache2::Reload
  PerlInitHandler Apache2::Reload
  PerlSetVar ReloadAll Off
  PerlSetVar ReloadModules "ModPerl::* Apache2::*"
  #PerlSetVar ReloadDebug On
  #PerlSetVar ReloadByModuleName On
  
  # Reload a single module from within itself:
  package My::Apache2::Module;
  use Apache2::Reload;
  sub handler { ... }
  1;

=head1 Description

C<Apache2::Reload> reloads modules that change on the disk.

When Perl pulls a file via C<require>, it stores the filename in the
global hash C<%INC>.  The next time Perl tries to C<require> the same
file, it sees the file in C<%INC> and does not reload from disk.  This
module's handler can be configured to iterate over the modules in
C<%INC> and reload those that have changed on disk or only specific
modules that have registered themselves with C<Apache2::Reload>. It can
also do the check for modified modules, when a special touch-file has
been modified.

Require-hooks, i.e., entries in %INC which are references, are ignored.  The 
hook should modify %INC itself, adding the path to the module file, for it to 
be reloaded.

C<Apache2::Reload> inspects and reloads the B<file> associated with a given 
module.  Changes to @INC are not recognized, as it is the file which is 
being re-required, not the module name.

In version 0.10 and earlier the B<module name>, not the file, is re-required.  
Meaning it operated on the the current context of @INC.  If you still want this 
behavior set this environment variable in I<httpd.conf>:

  PerlSetVar ReloadByModuleName On

This means, when called as a C<Perl*Handler>, C<Apache2::Reload> will not see 
C<@INC> paths added or removed by C<ModPerl::Registry> scripts, as the value of 
C<@INC> is saved on server startup and restored to that value after each 
request.  In other words, if you want C<Apache2::Reload> to work with modules 
that live in custom C<@INC> paths, you should modify C<@INC> when the server is 
started.  Besides, C<'use lib'> in the startup script, you can also set the 
C<PERL5LIB> variable in the httpd's environment to include any non-standard 
'lib' directories that you choose.  For example, to accomplish that you can 
include a line:

  PERL5LIB=/home/httpd/perl/extra; export PERL5LIB

in the script that starts Apache. Alternatively, you can set this
environment variable in I<httpd.conf>:

  PerlSetEnv PERL5LIB /home/httpd/perl/extra

=head2 Monitor All Modules in C<%INC>

To monitor and reload all modules in C<%INC> at the beginning of
request's processing, simply add the following configuration to your
I<httpd.conf>:

  PerlModule Apache2::Reload
  PerlInitHandler Apache2::Reload

When working with connection filters and protocol modules
C<Apache2::Reload> should be invoked in the pre_connection stage:

  PerlPreConnectionHandler Apache2::Reload

See also the discussion on
C<L<PerlPreConnectionHandler|docs::2.0::user::handlers::protocols/PerlPreConnectionHandler>>.

=head2 Register Modules Implicitly

To only reload modules that have registered with C<Apache2::Reload>,
add the following to the I<httpd.conf>:

  PerlModule Apache2::Reload
  PerlInitHandler Apache2::Reload
  PerlSetVar ReloadAll Off
  # ReloadAll defaults to On

Then any modules with the line:

  use Apache2::Reload;

Will be reloaded when they change.

=head2 Register Modules Explicitly

You can also register modules explicitly in your I<httpd.conf> file
that you want to be reloaded on change:

  PerlModule Apache2::Reload
  PerlInitHandler Apache2::Reload
  PerlSetVar ReloadAll Off
  PerlSetVar ReloadModules "My::Foo My::Bar Foo::Bar::Test"

Note that these are split on whitespace, but the module list B<must>
be in quotes, otherwise Apache tries to parse the parameter list.

The C<*> wild character can be used to register groups of files under
the same namespace. For example the setting:

  PerlSetVar ReloadModules "ModPerl::* Apache2::*"

will monitor all modules under the namespaces C<ModPerl::> and
C<Apache2::>.

=head2 Monitor Only Certain Sub Directories

To reload modules only in certain directories (and their
subdirectories) add the following to the I<httpd.conf>:

  PerlModule Apache2::Reload
  PerlInitHandler Apache2::Reload
  PerlSetVar ReloadDirectories "/tmp/project1 /tmp/project2"

You can further narrow the list of modules to be reloaded from the
chosen directories with C<ReloadModules> as in:

  PerlModule Apache2::Reload
  PerlInitHandler Apache2::Reload
  PerlSetVar ReloadDirectories "/tmp/project1 /tmp/project2"
  PerlSetVar ReloadAll Off
  PerlSetVar ReloadModules "MyApache2::*"

In this configuration example only modules from the namespace
C<MyApache2::> found in the directories I</tmp/project1/> and
I</tmp/project2/> (and their subdirectories) will be reloaded.

=head2 Special "Touch" File

You can also declare a file, which when gets C<touch(1)>ed, causes the
reloads to be performed. For example if you set:

  PerlSetVar ReloadTouchFile /tmp/reload_modules

and don't C<touch(1)> the file I</tmp/reload_modules>, the reloads
won't happen until you go to the command line and type:

  % touch /tmp/reload_modules

When you do that, the modules that have been changed, will be
magically reloaded on the next request. This option works with any
mode described before.

=head2 Unregistering a module

In some cases, it might be necessary to explicitly stop reloading
a module.

  Apache2::Reload->unregister_module('Some::Module');

But be carefull, since unregistering a module in this way will only
do so for the current interpreter. This feature should be used with
care.

=head1 Performance Issues

This module is perfectly suited for a development environment. Though
it's possible that you would like to use it in a production
environment, since with C<Apache2::Reload> you don't have to restart
the server in order to reload changed modules during software
updates. Though this convenience comes at a price:

=over

=item *

If the "touch" file feature is used, C<Apache2::Reload> has to stat(2)
the touch file on each request, which adds a slight but most likely
insignificant overhead to response times. Otherwise C<Apache2::Reload>
will stat(2) each registered module or even worse--all modules in
C<%INC>, which will significantly slow everything down.

=item *

Once the child process reloads the modules, the memory used by these
modules is not shared with the parent process anymore. Therefore the
memory consumption may grow significantly.

=back

Therefore doing a full server stop and restart is probably a better
solution.

=head1 Debug

If you aren't sure whether the modules that are supposed to be
reloaded, are actually getting reloaded, turn the debug mode on:

  PerlSetVar ReloadDebug On

=head1 Caveats

=head2 Problems With Reloading Modules Which Do Not Declare Their Package Name

If you modify modules, which don't declare their C<package>, and rely on
C<Apache2::Reload> to reload them, you may encounter problems: i.e.,
it'll appear as if the module wasn't reloaded when in fact it
was. This happens because when C<Apache2::Reload> C<require()>s such a
module all the global symbols end up in the C<Apache2::Reload>
namespace!  So the module does get reloaded and you see the compile
time errors if there are any, but the symbols don't get imported to
the right namespace. Therefore the old version of the code is running.


=head2 Failing to Find a File to Reload

C<Apache2::Reload> uses C<%INC> to find the files on the filesystem. If
an entry for a certain filepath in C<%INC> is relative,
C<Apache2::Reload> will use C<@INC> to try to resolve that relative
path. Now remember that mod_perl freezes the value of C<@INC> at the
server startup, and you can modify it only for the duration of one
request when you need to load some module which is not in on of the
C<@INC> directories. So a module gets loaded, and registered in
C<%INC> with a relative path. Now when C<Apache2::Reload> tries to find
that module to check whether it has been modified, it can't find since
its directory is not in C<@INC>. So C<Apache2::Reload> will silently
skip that module.

You can enable the C<Debug|/Debug> mode to see what C<Apache2::Reload>
does behind the scenes.



=head2 Problems with Scripts Running with Registry Handlers that Cache the Code

The following problem is relevant only to registry handlers that cache
the compiled script. For example it concerns
C<L<ModPerl::Registry|docs::2.0::api::ModPerl::Registry>> but not
C<L<ModPerl::PerlRun|docs::2.0::api::ModPerl::PerlRun>>.

=head3 The Problem

Let's say that there is a module C<My::Utils>:

  #file:My/Utils.pm
  #----------------
  package My::Utils;
  BEGIN { warn __PACKAGE__ , " was reloaded\n" }
  use base qw(Exporter);
  @EXPORT = qw(colour);
  sub colour { "white" }
  1;

And a registry script F<test.pl>:

  #file:test.pl
  #------------
  use My::Utils;
  print "Content-type: text/plain\n\n";
  print "the color is " . colour();

Assuming that the server is running in a single mode, we request the
script for the first time and we get the response:

  the color is white

Now we change F<My/Utils.pm>:

  -  sub colour { "white" }
  +  sub colour { "red" }

And issue the request again. C<Apache2::Reload> does its job and we can
see that C<My::Utils> was reloaded (look in the I<error_log>
file). However the script still returns:

  the color is white

=head3 The Explanation

Even though F<My/Utils.pm> was reloaded, C<ModPerl::Registry>'s cached
code won't run 'C<use My::Utils;>' again (since it happens only once,
i.e. during the compile time). Therefore the script doesn't know that
the subroutine reference has been changed.

This is easy to verify. Let's change the script to be:

  #file:test.pl
  #------------
  use My::Utils;
  print "Content-type: text/plain\n\n";
  my $sub_int = \&colour;
  my $sub_ext = \&My::Utils::colour;
  print "int $sub_int\n";
  print "ext $sub_ext\n";

Issue a request, you will see something similar to:

  int CODE(0x8510af8)
  ext CODE(0x8510af8)

As you can see both point to the same CODE reference (meaning that
it's the same symbol). After modifying F<My/Utils.pm> again:

  -  sub colour { "red" }
  +  sub colour { "blue" }

and calling the script on the secondnd time, we get:

  int CODE(0x8510af8)
  ext CODE(0x851112c)

You can see that the internal CODE reference is not the same as the
external one.

=head3 The Solution

There are two solutions to this problem:

Solution 1: replace C<use()> with an explicit C<require()> +
C<import()>.

 - use My::Utils;
 + require My::Utils; My::Utils->import();

now the changed functions will be reimported on every request.

Solution 2: remember to touch the script itself every time you change
the module that it requires.

=head1 Threaded MPM and Multiple Perl Interpreters

If you use C<Apache2::Reload> with a threaded MPM and multiple Perl
interpreters, the modules will be reloaded by each interpreter as they
are used, not every interpreters at once.  Similar to mod_perl 1.0
where each child has its own Perl interpreter, the modules are
reloaded as each child is hit with a request.

If a module is loaded at startup, the syntax tree of each subroutine
is shared between interpreters (big win), but each subroutine has its
own padlist (where lexical my variables are stored).  Once
C<Apache2::Reload> reloads a module, this sharing goes away and each
Perl interpreter will have its own copy of the syntax tree for the
reloaded subroutines.


=head1 Pseudo-hashes

The short summary of this is: Don't use pseudo-hashes. They are
deprecated since Perl 5.8 and are removed in 5.9.

Use an array with constant indexes. Its faster in the general case,
its more guaranteed, and generally, it works.

The long summary is that some work has been done to get this module
working with modules that use pseudo-hashes, but it's still broken in
the case of a single module that contains multiple packages that all
use pseudo-hashes.

So don't do that.




=head1 Copyright

mod_perl 2.0 and its core modules are copyrighted under
The Apache Software License, Version 2.0.


=head1 Authors

Matt Sergeant, matt@sergeant.org

Stas Bekman (porting to mod_perl 2.0)

A few concepts borrowed from C<Stonehenge::Reload> by Randal Schwartz
and C<Apache::StatINC> (mod_perl 1.x) by Doug MacEachern and Ask
Bjoern Hansen.

=head1 MAINTAINERS

the mod_perl developers, dev@perl.apache.org


=cut

