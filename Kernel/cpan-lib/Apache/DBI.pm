# $Id: DBI.pm 1490648 2013-06-07 13:46:30Z perrin $
package Apache::DBI;
use strict;

use constant MP2 => (exists $ENV{MOD_PERL_API_VERSION} &&
                     $ENV{MOD_PERL_API_VERSION} == 2) ? 1 : 0;

BEGIN {
    if (MP2) {
        require mod_perl2;
        require Apache2::Module;
        require Apache2::RequestUtil;
        require Apache2::ServerUtil;
        require ModPerl::Util;
    }
    elsif (defined $modperl::VERSION && $modperl::VERSION > 1 &&
             $modperl::VERSION < 1.99) {
        require Apache;
    }
}
use DBI ();
use Carp ();

require_version DBI 1.00;

$Apache::DBI::VERSION = '1.12';

# 1: report about new connect
# 2: full debug output
$Apache::DBI::DEBUG = 0;
#DBI->trace(2);

my %Connected;                  # cache for database handles
my @ChildConnect;               # connections to be established when a new
                                #   httpd child is created
my %Rollback;                   # keeps track of pushed PerlCleanupHandler
                                #   which can do a rollback after the request
                                #   has finished
my %PingTimeOut;                # stores the timeout values per data_source,
                                #   a negative value de-activates ping,
                                #   default = 0
my %LastPingTime;               # keeps track of last ping per data_source
my $ChildExitHandlerInstalled;  # set to true on installation of
                                # PerlChildExitHandler
my $InChild;

# Check to see if we need to reset TaintIn and TaintOut
my $TaintInOut = ($DBI::VERSION >= 1.31) ? 1 : 0;

sub debug {
  print STDERR "$_[1]\n" if $Apache::DBI::DEBUG >= $_[0];
}

# supposed to be called in a startup script.
# stores the data_source of all connections, which are supposed to be created
# upon server startup, and creates a PerlChildInitHandler, which initiates
# the connections.  Provide a handler which creates all connections during
# server startup
sub connect_on_init {

    if (MP2) {
        if (!@ChildConnect) {
            my $s = Apache2::ServerUtil->server;
            $s->push_handlers(PerlChildInitHandler => \&childinit);
        }
    }
    else {
        Carp::carp("Apache.pm was not loaded\n")
              and return unless $INC{'Apache.pm'};

        if (!@ChildConnect and Apache->can('push_handlers')) {
            Apache->push_handlers(PerlChildInitHandler => \&childinit);
        }
    }

    # store connections
    push @ChildConnect, [@_];
}

# supposed to be called in a startup script.
# stores the timeout per data_source for the ping function.
# use a DSN without attribute settings specified within !
sub setPingTimeOut {
    my $class       = shift;
    my $data_source = shift;
    my $timeout     = shift;

    # sanity check
    if ($data_source =~ /dbi:\w+:.*/ and $timeout =~ /\-*\d+/) {
        $PingTimeOut{$data_source} = $timeout;
    }
}

# the connect method called from DBI::connect
sub connect {
    my $class = shift;
    unshift @_, $class if ref $class;
    my $drh    = shift;

    my @args   = map { defined $_ ? $_ : "" } @_;
    my $dsn    = "dbi:$drh->{Name}:$args[0]";
    my $prefix = "$$ Apache::DBI            ";

    # key of %Connected and %Rollback.
    my $Idx = join $;, $args[0], $args[1], $args[2];

    # the hash-reference differs between calls even in the same
    # process, so de-reference the hash-reference
    if (3 == $#args and ref $args[3] eq "HASH") {
        # should we default to '__undef__' or something for undef values?
        map {
            $Idx .= "$;$_=" .
                (defined $args[3]->{$_}
                 ? $args[3]->{$_}
                 : '')
            } sort keys %{$args[3]};
    }
    elsif (3 == $#args) {
        pop @args;
    }

    # don't cache connections created during server initialization; they
    # won't be useful after ChildInit, since multiple processes trying to
    # work over the same database connection simultaneously will receive
    # unpredictable query results.
    # See: http://perl.apache.org/docs/2.0/user/porting/compat.html#C__Apache__Server__Starting__and_C__Apache__Server__ReStarting_
    if (MP2) {
        require ModPerl::Util;
        my $callback = ModPerl::Util::current_callback();
        if ($callback !~ m/Handler$/ or
            $callback =~ m/(PostConfig|OpenLogs)/) {
            debug(2, "$prefix skipping connection during server startup, read the docu !!");
            return $drh->connect(@args);
        }
    }
    else {
        if ($Apache::ServerStarting and $Apache::ServerStarting == 1) {
            debug(2, "$prefix skipping connection during server startup, read the docu !!");
            return $drh->connect(@args);
        }
    }

    # this PerlChildExitHandler is supposed to disconnect all open
    # connections to the database
    if (!$ChildExitHandlerInstalled) {
        $ChildExitHandlerInstalled = 1;
        my $s;
        if (MP2) {
            $s = Apache2::ServerUtil->server;
        }
        elsif (Apache->can('push_handlers')) {
            $s = 'Apache';
        }
        if ($s) {
            debug(2, "$prefix push PerlChildExitHandler");
            $s->push_handlers(PerlChildExitHandler => \&childexit);
        }
    }

    # this PerlCleanupHandler is supposed to initiate a rollback after the
    # script has finished if AutoCommit is off.  however, cleanup can only
    # be determined at end of handle life as begin_work may have been called
    # to temporarily turn off AutoCommit.
    if (!$Rollback{$Idx}) {
        my $r;
        if (MP2) {
            # We may not actually be in a request, but in <Perl> (or
            # equivalent such as startup.pl), in which case this would die.
            eval { $r = Apache2::RequestUtil->request };
        }
        elsif (Apache->can('push_handlers')) {
            $r = 'Apache';
        }
        if ($r) {
            debug(2, "$prefix push PerlCleanupHandler");
            $r->push_handlers("PerlCleanupHandler", sub { cleanup($Idx) });
            # make sure, that the rollback is called only once for every
            # request, even if the script calls connect more than once
            $Rollback{$Idx} = 1;
        }
    }

    # do we need to ping the database ?
    $PingTimeOut{$dsn}  = 0 unless $PingTimeOut{$dsn};
    $LastPingTime{$dsn} = 0 unless $LastPingTime{$dsn};
    my $now = time;
    # Must ping if TimeOut = 0 else base on time
    my $needping = ($PingTimeOut{$dsn} == 0 or
                    ($PingTimeOut{$dsn} > 0 and
                     $now - $LastPingTime{$dsn} > $PingTimeOut{$dsn})
                   ) ? 1 : 0;
    debug(2, "$prefix need ping: " . ($needping == 1 ? "yes" : "no"));
    $LastPingTime{$dsn} = $now;

    # check first if there is already a database-handle cached
    # if this is the case, possibly verify the database-handle
    # using the ping-method. Use eval for checking the connection
    # handle in order to avoid problems (dying inside ping) when
    # RaiseError being on and the handle is invalid.
    if ($Connected{$Idx} and (!$needping or eval{$Connected{$Idx}->ping})) {
        debug(2, "$prefix already connected to '$Idx'");

        # Force clean up of handle in case previous transaction failed to
        # clean up the handle
        &reset_startup_state($Idx);

        return (bless $Connected{$Idx}, 'Apache::DBI::db');
    }

    # either there is no database handle-cached or it is not valid,
    # so get a new database-handle and store it in the cache
    delete $Connected{$Idx};
    $Connected{$Idx} = $drh->connect(@args);
    return undef if !$Connected{$Idx};

    # store the parameters of the initial connection in the handle
    set_startup_state($Idx);

    # return the new database handle
    debug(1, "$prefix new connect to '$Idx'");
    return (bless $Connected{$Idx}, 'Apache::DBI::db');
}

# The PerlChildInitHandler creates all connections during server startup.
# Note: this handler runs in every child server, but not in the main server.
sub childinit {

    my $prefix = "$$ Apache::DBI            ";
    debug(2, "$prefix PerlChildInitHandler");

    %Connected = () if MP2;

    if (@ChildConnect) {
        for my $aref (@ChildConnect) {
            shift @$aref;
            DBI->connect(@$aref);
            $LastPingTime{@$aref[0]} = time;
        }
    }

    1;
}

# The PerlChildExitHandler disconnects all open connections
sub childexit {

    my $prefix = "$$ Apache::DBI            ";
    debug(2, "$prefix PerlChildExitHandler");

    foreach my $dbh (values(%Connected)) {
        eval { DBI::db::disconnect($dbh) };
        if ($@) {
            debug(2, "$prefix DBI::db::disconnect failed - $@");
        }
    }

    1;
}

# The PerlCleanupHandler is supposed to initiate a rollback after the script
# has finished if AutoCommit is off.
# Note: the PerlCleanupHandler runs after the response has been sent to
# the client
sub cleanup {
    my $Idx = shift;

    my $prefix = "$$ Apache::DBI            ";
    debug(2, "$prefix PerlCleanupHandler");

    my $dbh = $Connected{$Idx};
    if ($Rollback{$Idx}
        and $dbh 
        and $dbh->{Active}
        and !$dbh->{AutoCommit}
        and eval {$dbh->rollback}) {
        debug (2, "$prefix PerlCleanupHandler rollback for '$Idx'");
    }

    delete $Rollback{$Idx};

    1;
}

# Store the default start state of each dbh in the handle
# Note: This uses private_Apache_DBI hash ref to store it in the handle itself
my @attrs = qw(
               AutoCommit Warn CompatMode InactiveDestroy
               PrintError RaiseError HandleError
               ShowErrorStatement TraceLevel FetchHashKeyName
               ChopBlanks LongReadLen LongTruncOk
               Taint Profile
);

sub set_startup_state {
    my $Idx = shift;

    foreach my $key (@attrs) {
        $Connected{$Idx}->{private_Apache_DBI}{$key} =
            $Connected{$Idx}->{$key};
    }

    if ($TaintInOut) {
        foreach my $key ( qw{ TaintIn TaintOut } ) {
            $Connected{$Idx}->{private_Apache_DBI}{$key} = 
                $Connected{$Idx}->{$key};
        }
    }

    1;
}

# Restore the default start state of each dbh
sub reset_startup_state {
    my $Idx = shift;

    # Rollback current transaction if currently in one
    $Connected{$Idx}->{Active}
      and !$Connected{$Idx}->{AutoCommit}
      and eval {$Connected{$Idx}->rollback};

    foreach my $key (@attrs) {
        $Connected{$Idx}->{$key} =
            $Connected{$Idx}->{private_Apache_DBI}{$key};
    }

    if ($TaintInOut) {
        foreach my $key ( qw{ TaintIn TaintOut } ) {
            $Connected{$Idx}->{$key} =
                $Connected{$Idx}->{private_Apache_DBI}{$key};
        }
    }

    1;
}


# This function can be called from other handlers to perform tasks on all
# cached database handles.
sub all_handlers { return \%Connected }

# patch from Tim Bunce: Apache::DBI will not return a DBD ref cursor
@Apache::DBI::st::ISA = ('DBI::st');

# overload disconnect
{
  package Apache::DBI::db;
  no strict;
  @ISA=qw(DBI::db);
  use strict;
  sub disconnect {
      my $prefix = "$$ Apache::DBI            ";
      Apache::DBI::debug(2, "$prefix disconnect (overloaded)");
      1;
  }
  ;
}

# prepare menu item for Apache::Status
sub status_function {
    my($r, $q) = @_;

    my(@s) = qw(<TABLE><TR><TD>Datasource</TD><TD>Username</TD></TR>);
    for (keys %Connected) {
        push @s, '<TR><TD>',
            join('</TD><TD>',
                 (split($;, $_))[0,1]), "</TD></TR>\n";
    }
    push @s, '</TABLE>';

    \@s;
}

if (MP2) {
    if (Apache2::Module::loaded('Apache2::Status')) {
	    Apache2::Status->menu_item(
                                   'DBI' => 'DBI connections',
                                    \&status_function
                                  );
    }
}
else {
   if ($INC{'Apache.pm'}                       # is Apache.pm loaded?
       and Apache->can('module')               # really?
       and Apache->module('Apache::Status')) { # Apache::Status too?
       Apache::Status->menu_item(
                                'DBI' => 'DBI connections',
                                \&status_function
                                );
   }
}

1;

__END__


=head1 NAME

Apache::DBI - Initiate a persistent database connection


=head1 SYNOPSIS

 # Configuration in httpd.conf or startup.pl:

 PerlModule Apache::DBI  # this comes before all other modules using DBI

Do NOT change anything in your scripts. The usage of this module is
absolutely transparent !


=head1 DESCRIPTION

This module initiates a persistent database connection.

The database access uses Perl's DBI. For supported DBI drivers see:

 http://dbi.perl.org/

When loading the DBI module (do not confuse this with the Apache::DBI module)
it checks if the environment variable 'MOD_PERL' has been set
and if the module Apache::DBI has been loaded. In this case every connect
request will be forwarded to the Apache::DBI module. This checks if a database
handle from a previous connect request is already stored and if this handle is
still valid using the ping method. If these two conditions are fulfilled it
just returns the database handle. The parameters defining the connection have
to be exactly the same, including the connect attributes! If there is no
appropriate database handle or if the ping method fails, a new connection is
established and the handle is stored for later re-use. There is no need to
remove the disconnect statements from your code. They won't do anything
because the Apache::DBI module overloads the disconnect method.

The Apache::DBI module still has a limitation: it keeps database connections
persistent on a per process basis. The problem is, if a user accesses a database
several times, the http requests will be handled very likely by different
processes. Every process needs to do its own connect. It would be nice if all
servers could share the database handles, but currently this is not possible
because of the distinct memory-space of each process. Also it is not possible
to create a database handle upon startup of the httpd and then inherit this
handle to every subsequent server. This will cause clashes when the handle is
used by two processes at the same time.  Apache::DBI has built-in protection
against this.  It will not make a connection persistent if it sees that it is
being opened during the server startup.  This allows you to safely open a connection
for grabbing data needed at startup and disconnect it normally before the end of
startup.

With this limitation in mind, there are scenarios, where the usage of
Apache::DBI is depreciated. Think about a heavy loaded Web-site where every
user connects to the database with a unique userid. Every server would create
many database handles each of which spawning a new backend process. In a short
time this would kill the web server.

Another problem are timeouts: some databases disconnect the client after a
certain period of inactivity. The module tries to validate the database handle
using the C<ping()> method of the DBI-module. This method returns true by default.
Most DBI drivers have a working C<ping()> method, but if the driver you're using
doesn't have one and the database handle is no longer valid, you will get an error
when accessing the database. As a work-around you can try to add your own C<ping()>
method using any database command which is cheap and safe, or you can deactivate the
usage of the ping method (see CONFIGURATION below).

Here is a generalized ping method, which can be added to the driver module:

   package DBD::xxx::db; # ====== DATABASE ======
   use strict;

   sub ping {
     my ($dbh) = @_;
     my $ret = 0;
     eval {
       local $SIG{__DIE__}  = sub { return (0); };
       local $SIG{__WARN__} = sub { return (0); };
       # adapt the select statement to your database:
       $ret = $dbh->do('select 1');
     };
     return ($@) ? 0 : $ret;
   }

Transactions: a standard DBI script will automatically perform a rollback
whenever the script exits. In the case of persistent database connections,
the database handle will not be destroyed and hence no automatic rollback
will occur. At a first glance it even seems possible to handle a transaction
over multiple requests. But this should be avoided, because different
requests are handled by different processes and a process does not know the state
of a specific transaction which has been started by another process. In general,
it is good practice to perform an explicit commit or rollback at the end of
every request. In order to avoid inconsistencies in the database in case
AutoCommit is off and the script finishes without an explicit rollback, the
Apache::DBI module uses a PerlCleanupHandler to issue a rollback at the
end of every request. Note, that this CleanupHandler will only be used, if
the initial data_source sets AutoCommit = 0 or AutoCommit is turned off, after
the connect has been done (ie begin_work). However, because a connection may
have set other parameters, the handle is reset to its initial connection state
before it is returned for a second time.

This module plugs in a menu item for Apache::Status or Apache2::Status.
The menu lists the current database connections. It should be considered
incomplete because of the limitations explained above. It shows the current
database connections for one specific process, the one which happens to serve
the current request.  Other processes might have other database connections.
The Apache::Status/Apache2::Status module has to be loaded before the
Apache::DBI module !

=head1 CONFIGURATION

The module should be loaded upon startup of the Apache daemon.
Add the following line to your httpd.conf or startup.pl:

 PerlModule Apache::DBI

It is important, to load this module before any other modules using DBI !

A common usage is to load the module in a startup file called via the PerlRequire
directive. See eg/startup.pl and eg/startup2.pl for examples.

There are two configurations which are server-specific and which can be done
upon server startup:

 Apache::DBI->connect_on_init($data_source, $username, $auth, \%attr)

This can be used as a simple way to have apache servers establish connections
on process startup.

 Apache::DBI->setPingTimeOut($data_source, $timeout)

This configures the usage of the ping method, to validate a connection.
Setting the timeout to 0 will always validate the database connection
using the ping method (default). Setting the timeout < 0 will de-activate
the validation of the database handle. This can be used for drivers, which
do not implement the ping-method. Setting the timeout > 0 will ping the
database only if the last access was more than timeout seconds before.

For the menu item 'DBI connections' you need to call
Apache::Status/Apache2::Status BEFORE Apache::DBI ! For an example of the
configuration order see startup.pl.

To enable debugging the variable $Apache::DBI::DEBUG must be set. This
can either be done in startup.pl or in the user script. Setting the variable
to 1, just reports about a new connect. Setting the variable to 2 enables full
debug output.

=head1 PREREQUISITES

=head2 MOD_PERL 2.0

Apache::DBI version 0.96 and later should work under mod_perl 2.0 RC5 and later
with httpd 2.0.49 and later.

Apache::DBI versions less than 1.00 are NO longer supported.  Additionally, 
mod_perl versions less then 2.0.0 are NO longer supported.

=head2 MOD_PERL 1.0
Note that this module needs mod_perl-1.08 or higher, apache_1.3.0 or higher
and that mod_perl needs to be configured with the appropriate call-back hooks:
  
  PERL_CHILD_INIT=1 PERL_STACKED_HANDLERS=1

Apache::DBI v0.94 was the last version before dual mod_perl 2.x support was begun.
It still recommended that you use the latest version of Apache::DBI because Apache::DBI
versions less than 1.00 are NO longer supported.

=head1 DO YOU NEED THIS MODULE?

Note that this module is intended for use in porting existing DBI code to mod_perl,
or writing code that can run under both mod_perl and CGI.  If you are using a
database abstraction layer such as Class::DBI or DBIx::Class that already manages persistent connections for you, there is no need to use this module
in addition.  (Another popular choice, Rose::DB::Object, can cooperate with
Apache::DBI or use your own custom connection handling.)  If you are developing
new code that is strictly for use in mod_perl, you may choose to use
C<< DBI->connect_cached() >> instead, but consider adding an automatic rollback
after each request, as described above.

=head1 SEE ALSO

L<Apache>, L<mod_perl>, L<DBI>

=head1 AUTHORS

=over

=item *
Philip M. Gollucci <pgollucci@p6m7g8.com> is currently packaging new releases.

Ask Bjoern Hansen <ask@develooper.com> packaged a large number of releases.

=item *
Edmund Mergl was the original author of Apache::DBI.  It is now
supported and maintained by the modperl mailinglist, see the mod_perl
documentation for instructions on how to subscribe.

=item *
mod_perl by Doug MacEachern.

=item *
DBI by Tim Bunce <dbi-users-subscribe@perl.org>

=back

=head1 COPYRIGHT

The Apache::DBI module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
