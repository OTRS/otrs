package Sys::Hostname::Long;
use strict;
use Carp;

require Exporter;
use Sys::Hostname;

# Use perl < 5.6 compatible methods for now, change to 'use base' soon
@Sys::Hostname::Long::ISA     = qw/ Exporter Sys::Hostname /;

# Use perl < 5.6 compatible methods for now, change to 'our' soon.
use vars qw(@EXPORT $VERSION $hostlong %dispatch $lastdispatch);
@EXPORT  = qw/ hostname_long /;
$VERSION = '1.5';

%dispatch = (

    'gethostbyname' => {
        'title' => 'Get Host by Name',
        'description' => '',
        'exec' => sub {
            return gethostbyname('localhost');
        },
    },

    'exec_hostname' => {
        'title' => 'Execute "hostname"',
        'description' => '',
        'exec' => sub {
            my $tmp = `hostname`;
            $tmp =~ tr/\0\r\n//d;
            return $tmp;
        },
    },

    'win32_registry1' => {
        'title' => 'WIN32 Registry',
        'description' => 'LMachine/System/CurrentControlSet/Service/VxD/MSTCP/Domain',
        'exec' => sub {
            return eval q{
                use Win32::TieRegistry ( TiedHash => '%RegistryHash' );
                $RegistryHash{'LMachine'}{'System'}{'CurrentControlSet'}{'Services'}{'VxD'}{'MSTCP'}{'Domain'};
            };
        },
    },

    'uname' => {
        'title' => 'POSIX::uname',
        'description' => '',
        'exec' => sub {
            return eval {
                local $SIG{__DIE__};
                require POSIX;
                (POSIX::uname())[1];
            };
        },
    },

    # XXX This is the same as above - what happened to the other one !!!
    'win32_registry2' => {
        'title' => 'WIN32 Registry',
        'description' => 'LMachine/System/CurrentControlSet/Services/VxD/MSTCP/Domain',
        'exec' => sub {
            return eval q{
                use Win32::TieRegistry ( TiedHash => '%RegistryHash' );
                $RegistryHash{'LMachine'}{'System'}{'CurrentControlSet'}{'Services'}{'VxD'}{'MSTCP'}{'Domain'};
            };
        },
    },

    'exec_hostname_fqdn' => {
        'title' => 'Execute "hostname --fqdn"',
        'description' => '',
        'exec' => sub {
            # Skip for Solaris, and only run as non-root
            # Skip for darwin (Mac OS X), RT#28894
            my $tmp;
            if ( $^O ne 'darwin' ) {
                if ($< == 0) {
                    $tmp = `su nobody -c "hostname --fqdn"`;
                } else {
                    $tmp = `hostname --fqdn`;
                }
                $tmp =~ tr/\0\r\n//d;
            }
            return $tmp;
        },
    },

    'exec_hostname_domainname' => {
        'title' => 'Execute "hostname" and "domainname"',
        'description' => '',
        'exec' => sub {
            my $tmp = `hostname` . '.' . `domainname`;
            $tmp =~ tr/\0\r\n//d;
            return $tmp;
        },
    },


    'network' => {
        'title' => 'Network Socket hostname (not DNS)',
        'description' => '',
        'exec' => sub {
            return eval q{
                use IO::Socket;
                my $s = IO::Socket::INET->new(
                    # m.root-servers.net (a remote IP number)
                    PeerAddr => '202.12.27.33',
                    # random safe port
                    PeerPort => 2000,
                    # We don't actually want to connect
                    Proto => 'udp',
                ) or die "Faile socket - $!";
                gethostbyaddr($s->sockaddr(), AF_INET);
            };
        },
    },

    'ip' => {
        'title' => 'Network Socket IP then Hostname via DNS',
        'description' => '',
        'exec' => sub {
            return eval q{
                use IO::Socket;
                my $s = IO::Socket::INET->new(
                    # m.root-servers.net (a remote IP number)
                    PeerAddr => '202.12.27.33',
                    # random safe port
                    PeerPort => 2000,
                    # We don't actually want to connect
                    Proto => 'udp',
                ) or die "Faile socket - $!";
                $s->sockhost;
            };
        },
    },

);

# Dispatch from table
sub dispatcher {
    my ($method, @rest) = @_;
    $lastdispatch = $method;
    return $dispatch{$method}{exec}(@rest);
}

sub dispatch_keys {
    return sort keys %dispatch;
}

sub dispatch_title {
    return $dispatch{$_[0]}{title};
}

sub dispatch_description {
    return $dispatch{$_[0]}{description};
}

sub hostname_long {
    return $hostlong if defined $hostlong;  # Cached copy (takes a while to lookup sometimes)
    my ($ip, $debug) = @_;

    $hostlong = dispatcher('uname');

    unless ($hostlong =~ m|.*\..*|) {
        if ($^O eq 'MacOS') {
            # http://bumppo.net/lists/macperl/1999/03/msg00282.html
            #   suggests that it will work (checking localhost) on both
            #   Mac and Windows.
            #   Personally this makes no sense what so ever as
            $hostlong = dispatcher('gethostbyname');

        } elsif ($^O eq 'IRIX') {   # XXX Patter match string !
            $hostlong = dispatcher('exec_hostname');

        } elsif ($^O eq 'cygwin') {
            $hostlong = dispatcher('win32_registry1');

        } elsif ($^O eq 'MSWin32') {
            $hostlong = dispatcher('win32_registry2');

        } elsif ($^O =~ m/(bsd|nto)/i) {
            $hostlong = dispatcher('exec_hostname');

        # (covered above) } elsif ($^O eq "darwin") {
        #   $hostlong = dispatcher('uname');

        } elsif ($^O eq 'solaris') {
            $hostlong = dispatcher('exec_hostname_domainname');

        } else {
            $hostlong = dispatcher('exec_hostname_fqdn');
        }

        if (!defined($hostlong) || $hostlong eq "") {
            # FALL BACK - Requires working internet and DNS and reverse
            # lookups of your IP number.
            $hostlong = dispatcher('network');
        }

        if ($ip && !defined($hostlong) || $hostlong eq "") {
            $hostlong = dispatcher('ip');
        }
    }
    warn "Sys::Hostname::Long - Last Dispatch method = $lastdispatch" if ($debug);
    return $hostlong;
}

1;

__END__

=head1 NAME

Sys::Hostname::Long - Try every conceivable way to get full hostname

=head1 SYNOPSIS

    use Sys::Hostname::Long;
    $host_long = hostname_long;

=head1 DESCRIPTION

How to get the host full name in perl on multiple operating systems (mac,
windows, unix* etc)

=head1 DISCUSSION

This is the SECOND release of this code. It has an improved set of tests and
improved interfaces - but it is still often failing to get a full host name.
This of course is the reason I wrote the module, it is difficult to get full
host names accurately on each system. On some systems (eg: Linux) it is
dependent on the order of the entries in /etc/hosts.

To make it easier to test I have testall.pl to generate an output list of all
methods. Thus even if the logic is incorrect, it may be possible to get the
full name.

Attempt via many methods to get the systems full name. The L<Sys::Hostname>
class is the best and standard way to get the system hostname. However it is
missing the long hostname.

Special thanks to B<David Sundstrom> and B<Greg Bacon> for the original
L<Sys::Hostname>

=head1 SUPPORT

This is the original list of platforms tested.

    MacOS       Macintosh Classic       OK
    Win32       MS Windows (95,98,nt,2000...)
            98              OK
    MacOS X     Macintosh 10            OK
            (other darwin)          Probably OK (not tested)
    Linux       Linux UNIX OS           OK
            Sparc               OK
    HPUX        H.P. Unix 10?           Not Tested
    Solaris     SUN Solaris 7?          OK (now)
    Irix        SGI Irix 5?         Not Tested
    FreeBSD     FreeBSD             OK

A new list has now been compiled of all the operating systems so that I can
individually keep information on their success.

THIS IS IN NEED OF AN UPDATE AFTER NEXT RELEASE.

=over 4

=item Acorn - Not yet tested

=item AIX - Not yet tested

=item Amiga - Not yet tested

=item Atari - Not yet tested

=item AtheOS - Not yet tested

=item BeOS - Not yet tested

=item BSD - Not yet tested

=item BSD/OS - Not yet tested

=item Compaq - Not yet tested

=item Cygwin - Not yet tested

=item Concurrent - Not yet tested

=item DG/UX - Not yet tested

=item Digital - Not yet tested

=item DEC OSF/1 - Not yet tested

=item Digital UNIX - Not yet tested

=item DYNIX/ptx - Not yet tested

=item EPOC - Not yet tested

=item FreeBSD - Not yet tested

=item Fujitsu-Siemens - Not yet tested

=item Guardian - Not yet tested

=item HP - Not yet tested

=item HP-UX - Not yet tested

=item IBM - Not yet tested

=item IRIX - Not yet tested - 3rd hand information might be ok.

=item Japanese - Not yet tested

=item JPerl - Not yet tested

=item Linux

=over 8

=item Debian - Not yet tested

=item Gentoo - Not yet tested

=item Mandrake - Not yet tested

=item Red Hat- Not yet tested

=item Slackware - Not yet tested

=item SuSe - Not yet tested

=item Yellowdog - Not yet tested

=back

=item LynxOS - Not yet tested

=item Mac OS - Not yet tested

=item Mac OS X - OK 20040315 (v1.1)

=item MachTen - Not yet tested

=item Minix - Not yet tested

=item MinGW - Not yet tested

=item MiNT - Not yet tested

=item MPE/iX - Not yet tested

=item MS-DOS - Not yet tested

=item MVS - Not yet tested

=item NetBSD - Not yet tested

=item NetWare - Not yet tested

=item NEWS-OS - Not yet tested

=item NextStep - Not yet tested

=item Novell - Not yet tested

=item NonStop - Not yet tested

=item NonStop-UX - Not yet tested

=item OpenBSD - Not yet tested

=item ODT - Not yet tested

=item OpenVMS - Not yet tested

=item Open UNIX - Not yet tested

=item OS/2 - Not yet tested

=item OS/390 - Not yet tested

=item OS/400 - Not yet tested

=item OSF/1 - Not yet tested

=item OSR - Not yet tested

=item Plan 9 - Not yet tested

=item Pocket PC - Not yet tested

=item PowerMAX - Not yet tested

=item Psion - Not yet tested

=item QNX

=over 8

=item 4 - Not yet tested

=item 6 (Neutrino) - Not yet tested

=back

=item Reliant UNIX - Not yet tested

=item RISCOS - Not yet tested

=item SCO - Not yet tested

=item SGI - Not yet tested

=item Symbian - Not yet tested

=item Sequent - Not yet tested

=item Siemens - Not yet tested

=item SINIX - Not yet tested

=item Solaris - Not yet tested

=item SONY - Not yet tested

=item Sun - Not yet tested

=item Stratus - Not yet tested

=item Tandem - Not yet tested

=item Tru64 - Not yet tested

=item Ultrix - Not yet tested

=item UNIX - Not yet tested

=item U/WIN - Not yet tested

=item Unixware - Not yet tested

=item VMS - Not yet tested

=item VOS - Not yet tested

=item Windows

=over 8

=item CE - Not yet tested

=item 3.1 - Not yet tested

=item 95 - Not yet tested

=item 98 - Not yet tested

=item Me - Not yet tested

=item NT - Not yet tested

=item 2000 - Not yet tested

=item XP - Not yet tested

=back

=item z/OS - Not yet tested

=back

=head1 KNOWN LIMITATIONS

=head2 Unix

Most unix systems have trouble working out the fully qualified domain name as
it to be configured somewhere in the system correctly. For example in most
linux systems (debian, ?) the fully qualified name should be the first entry
next to the ip number in /etc/hosts

    192.168.0.1 fred.somwhere.special   fred

If it is the other way around, it will fail.

=head2 Mac

=head1 TODO

Contributions

    David Dick
    Graeme Hart
    Piotr Klaban

    * Extra code from G
    * Dispatch table
    * List of all operating systems.

Solaris
    * Fall back 2 - TCP with DNS works ok
    * Also can read /etc/defaultdomain file

=head1 SEE ALSO

    L<Sys::Hostname>

=head1 AUTHOR

Originally by Scott Penrose E<lt>F<scottp@dd.com.au>E<gt>

Contributions: Michiel Beijen E<lt>F<michiel.beijen@gmail.com>E<gt>


=head1 COPYRIGHT

Copyright (c) 2001,2004,2005,2015 Scott Penrose. All rights reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
