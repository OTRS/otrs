package Module::Find;

use 5.006001;
use strict;
use warnings;

use File::Spec;
use File::Find;

our $VERSION = '0.15';

our $basedir = undef;
our @results = ();
our $prune = 0;
our $followMode = 1;

our @ISA = qw(Exporter);

our @EXPORT = qw(findsubmod findallmod usesub useall setmoduledirs);

our @EXPORT_OK = qw(followsymlinks ignoresymlinks);

=encoding utf-8

=head1 NAME

Module::Find - Find and use installed modules in a (sub)category

=head1 SYNOPSIS

  use Module::Find;

  # use all modules in the Plugins/ directory
  @found = usesub Mysoft::Plugins;

  # use modules in all subdirectories
  @found = useall Mysoft::Plugins;

  # find all DBI::... modules
  @found = findsubmod DBI;

  # find anything in the CGI/ directory
  @found = findallmod CGI;
  
  # set your own search dirs (uses @INC otherwise)
  setmoduledirs(@INC, @plugindirs, $appdir);
  
  # not exported by default
  use Module::Find qw(ignoresymlinks followsymlinks);
  
  # ignore symlinks
  ignoresymlinks();
  
  # follow symlinks (default)
  followsymlinks();

=head1 DESCRIPTION

Module::Find lets you find and use modules in categories. This can be very 
useful for auto-detecting driver or plugin modules. You can differentiate
between looking in the category itself or in all subcategories.

If you want Module::Find to search in a certain directory on your 
harddisk (such as the plugins directory of your software installation),
make sure you modify C<@INC> before you call the Module::Find functions.

=head1 FUNCTIONS

=over

=item C<setmoduledirs(@directories)>

Sets the directories to be searched for modules. If not set, Module::Find
will use @INC. If you use this function, @INC will I<not> be included
automatically, so add it if you want it. Set to undef to revert to
default behaviour.

=cut

sub setmoduledirs {
    return @Module::Find::ModuleDirs = grep { defined } @_;
}

=item C<@found = findsubmod Module::Category>

Returns modules found in the Module/Category subdirectories of your perl 
installation. E.g. C<findsubmod CGI> will return C<CGI::Session>, but 
not C<CGI::Session::File> .

=cut

sub findsubmod(*) {
	$prune = 1;
		
	return _find($_[0]);
}

=item C<@found = findallmod Module::Category>

Returns modules found in the Module/Category subdirectories of your perl 
installation. E.g. C<findallmod CGI> will return C<CGI::Session> and also 
C<CGI::Session::File> .

=cut

sub findallmod(*) {
	$prune = 0;
	
	return _find($_[0]);
}

=item C<@found = usesub Module::Category>

Uses and returns modules found in the Module/Category subdirectories of your perl 
installation. E.g. C<usesub CGI> will return C<CGI::Session>, but 
not C<CGI::Session::File> .

If any module dies during loading, usesub will also die at this point.

=cut

sub usesub(*) {
	$prune = 1;
	
	my @r = _find($_[0]);

    local @INC = @Module::Find::ModuleDirs
        if (@Module::Find::ModuleDirs);
	
	foreach my $m (@r) {
		eval " require $m; import $m ; ";
		die $@ if $@;
	}
	
	return @r;
}

=item C<@found = useall Module::Category>

Uses and returns modules found in the Module/Category subdirectories of your perl installation. E.g. C<useall CGI> will return C<CGI::Session> and also 
C<CGI::Session::File> .

If any module dies during loading, useall will also die at this point.

=cut

sub useall(*) {
	$prune = 0;
	
	my @r = _find($_[0]);
	
    local @INC = @Module::Find::ModuleDirs
        if (@Module::Find::ModuleDirs);
        
	foreach my $m (@r) {
		eval " require $m; import $m; ";
		die $@ if $@;
	}
	
	return @r;
}

# 'wanted' functions for find()
# you know, this would be a nice application for currying...
sub _wanted {
    my $name = File::Spec->abs2rel($_, $basedir);
    return unless $name && $name ne File::Spec->curdir() && substr($name, 0, 1) ne '.';

    if (-d && $prune) {
        $File::Find::prune = 1;
        return;
    }

    return unless /\.pm$/;

    $name =~ s|\.pm$||;
    $name = join('::', File::Spec->splitdir($name));

    push @results, $name;
}


# helper functions for finding files

sub _find(*) {
    my ($category) = @_;
    return undef unless defined $category;

    my $dir = File::Spec->catdir(split(/::|'/, $category));

    @results = ();

    foreach my $inc (@Module::Find::ModuleDirs ? @Module::Find::ModuleDirs : @INC) {
        if (ref $inc) {
            if (my @files = eval { $inc->files }) {
                push @results,
                    map { s/^\Q$category\E::// ? $_ : () }
                    map { s{/}{::}g; s{\.pm$}{}; $_ }
                    grep { /\.pm$/ }
                    @files;
            }
        }
        else {
            our $basedir = File::Spec->catdir($inc, $dir);

            next unless -d $basedir;
            find({wanted   => \&_wanted,
                  no_chdir => 1,
                  follow   => $followMode}, $basedir);
        }
    }

    # filter duplicate modules
    my %seen = ();
    @results = grep { not $seen{$_}++ } @results;

    @results = map "$category\::$_", @results;

    @results = map {
         ($_ =~ m{^(\w+(?:(?:::|')\w+)*)$})[0] || die "$_ does not look like a package name"
    } @results;

    return @results;
}

=item C<ignoresymlinks()>

Do not follow symlinks. This function is not exported by default.

=cut

sub ignoresymlinks {
    $followMode = 0;
}

=item C<followsymlinks()>

Follow symlinks (default behaviour). This function is not exported by default.

=cut

sub followsymlinks {
    $followMode = 1;
}

=back

=head1 HISTORY

=over 8

=item 0.01, 2004-04-22

Original version; created by h2xs 1.22

=item 0.02, 2004-05-25

Added test modules that were left out in the first version. Thanks to
Stuart Johnston for alerting me to this.

=item 0.03, 2004-06-18

Fixed a bug (non-localized $_) by declaring a loop variable in use functions.
Thanks to Stuart Johnston for alerting me to this and providing a fix.

Fixed non-platform compatibility by using File::Spec.
Thanks to brian d foy.

Added setmoduledirs and updated tests. Idea shamelessly stolen from
...errm... inspired by brian d foy.

=item 0.04, 2005-05-20

Added POD tests.

=item 0.05, 2005-11-30

Fixed issue with bugfix in PathTools-3.14.

=item 0.06, 2008-01-26

Module::Find now won't report duplicate modules several times anymore (thanks to Uwe Völker for the report and the patch)

=item 0.07, 2009-09-08

Fixed RT#38302: Module::Find now follows symlinks by default (can be disabled).

=item 0.08, 2009-09-08

Fixed RT#49511: Removed Mac OS X extended attributes from distribution

=item 0.09, 2010-02-26

Fixed RT#38302: Fixed META.yml generation (thanks very much to cpanservice for the help).

=item 0.10, 2010-02-26

Fixed RT#55010: Removed Unicode BOM from Find.pm.

=item 0.11, 2012-05-22

Fixed RT#74251: defined(@array) is deprecated under Perl 5.15.7.
Thanks to Roman F, who contributed the implementation.

=item 0.12, 2014-02-08

Fixed RT#81077: useall fails in taint mode
Thanks to Aran Deltac, who contributed the implementation and test.

Fixed RT#83596: Documentation doesn't describe behaviour if a module fails to load
Clarified documentation for useall and usesub.

Fixed RT#62923: setmoduledirs(undef) doesn't reset to searching @INC
Added more explicit tests.
Thanks to Colin Robertson for his input.

=item 0.13, 2015-03-09

This release contains two contributions from Moritz Lenz:

Link to Module::Pluggable and Class::Factory::Util in "SEE ALSO"

Align package name parsing with how perl does it (allowing single quotes as module separator)

Also, added a test for meta.yml

=item 0.14, 2019-12-25

A long overdue update. Thank you for the many contributions!

Fixed RT#99055: Removed file readability check (pull request contributed by Moritz Lenz)

Now supports @INC hooks (pull request contributed by Graham Knop)

Now filters out filenames starting with a dot (pull request contributed by Desmond Daignault)

Now uses strict (pull request contributed by Shlomi Fish)

Fixed RT#122016: test/ files show up in metacpan (bug report contributed by Karen Etheridge)

=item 0.15, 2019-12-26

Fixed RT#127657 (bug report contributed by Karen Etheridge): Module::Find now uses @ModuleDirs
(if specified) for loading modules. Previously, when using setmoduledirs() to set an array of
directories that did not contain @INC, Module::Find would find the modules correctly, but load
them from @INC.

=back

=head1 DEVELOPMENT NOTES

Please report any bugs using the CPAN RT system. The development repository for this module is hosted on GitHub: L<http://github.com/crenz/Module-Find/>.

=head1 SEE ALSO

L<perl>, L<Module::Pluggable>, L<Class::Factory::Util>

=head1 AUTHOR

Christian Renz, E<lt>crenz@web42.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2004-2019 by Christian Renz <crenz@web42.com>. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut

1;
