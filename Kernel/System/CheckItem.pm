# --
# Kernel/System/CheckItem.pm - the global spelling module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CheckItem;

use strict;
use warnings;

use vars qw($VERSION);

=head1 NAME

Kernel::System::CheckItem - check items

=head1 SYNOPSIS

All item check functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::CheckItem;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $CheckItemObject = Kernel::System::CheckItem->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject LogObject MainObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

=item CheckError()

get the error of check item back

    my $Error = $CheckItemObject->CheckError();

=cut

sub CheckError {
    my $Self = shift;

    return $Self->{Error};
}

=item CheckErrorType()

get the error's type of check item back

    my $ErrorType = $CheckItemObject->CheckErrorType();

=cut

sub CheckErrorType {
    my $Self = shift;

    return $Self->{ErrorType};
}

=item CheckEmail()

returns true if check was successful, if it's false, get the error message
from CheckError()

    my $Valid = $CheckItemObject->CheckEmail(
        Address => 'info@example.com',
    );

=cut

sub CheckEmail {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Address} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Address!' );
        return;
    }

    # check if it's to do
    return 1 if !$Self->{ConfigObject}->Get('CheckEmailAddresses');

    # check valid email addresses
    my $RegExp = $Self->{ConfigObject}->Get('CheckEmailValidAddress');
    if ( $RegExp && $Param{Address} =~ /$RegExp/i ) {
        return 1;
    }
    my $Error = '';

    # email address syntax check
    if (
        $Param{Address}
        !~ m{
            ^
            [a-zA-Z0-9_#]+
            (?:
                [a-zA-Z0-9_+\.&%-/=]*
                [a-zA-Z0-9_'\.-]+
            )?
            @
            (?:
                (?:
                    [a-zA-Z0-9]+
                    ([a-zA-Z0-9\.-]*[a-zA-Z0-9]+)?
                    \.+
                    [a-zA-Z]{2,8}
                )
                |
                (?:
                    \d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}
                )
            )
            $
        }x
        )
    {
        $Error = "Invalid syntax";
        $Self->{ErrorType} = 'InvalidSyntax';
    }

    # email address syntax check
    # period (".") may not be used to end the local part,
    # nor may two or more consecutive periods appear
    if ( $Param{Address} =~ /(\.\.)|(\.@)/ ) {
        $Error = "Invalid syntax";
        $Self->{ErrorType} = 'InvalidSyntax';
    }

    # mx check
    elsif (
        $Self->{ConfigObject}->Get('CheckMXRecord')
        && eval { require Net::DNS }    ## no critic
        )
    {

        # get host
        my $Host = $Param{Address};
        $Host =~ s/^.*@(.*)$/$1/;
        $Host =~ s/\s+//g;
        $Host =~ s/(^\[)|(\]$)//g;

        # do dns query
        my $Resolver = Net::DNS::Resolver->new();
        if ($Resolver) {

            # check if extra nameserver need to be used
            my $Nameserver = $Self->{ConfigObject}->Get('CheckMXRecord::Nameserver');
            if ($Nameserver) {
                $Resolver->nameservers($Nameserver);
            }

            # A recorde lookup
            my $Packet = $Resolver->send( $Host, 'A' );
            if ( !$Packet ) {
                $Self->{ErrorType} = 'InvalidDNS';
                $Error = "DNS problem: " . $Resolver->errorstring();
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "DNS problem: " . $Resolver->errorstring(),
                );
            }
            elsif ( $Packet->header()->ancount() ) {

                # OK
                # print STDERR "OK A $Host ".$Packet->header->ancount()."\n";
            }

            # mx recorde lookup
            else {
                my $Packet = $Resolver->send( $Host, 'MX' );
                if ( !$Packet ) {
                    $Self->{ErrorType} = 'InvalidDNS';
                    $Error = "DNS problem: " . $Resolver->errorstring();
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => "DNS problem: " . $Resolver->errorstring(),
                    );
                }
                elsif ( $Packet->header()->ancount() ) {

                    # OK
                    # print STDERR "OK MX $Host ".$Packet->header->ancount()."\n";
                }
                else {
                    $Error = "no mail exchanger (mx) found!";
                    $Self->{ErrorType} = 'InvalidMX';
                }
            }
        }
    }
    elsif ( $Self->{ConfigObject}->Get('CheckMXRecord') ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't load Net::DNS, no mx lookups possible",
        );
    }

    # check address
    if ( !$Error ) {

        # check special stuff
        my $RegExp = $Self->{ConfigObject}->Get('CheckEmailInvalidAddress');
        if ( $RegExp && $Param{Address} =~ /$RegExp/i ) {
            $Self->{Error}     = "invalid $Param{Address} (config)!";
            $Self->{ErrorType} = 'InvalidConfig';
            return;
        }
        return 1;
    }
    else {

        # remember error
        $Self->{Error} = "invalid $Param{Address} ($Error)! ";
        return;
    }
}

=item StringClean()

clean a given string

    my $StringRef = $CheckItemObject->StringClean(
        StringRef         => \'String',
        TrimLeft          => 0,  # (optional) default 1
        TrimRight         => 0,  # (optional) default 1
        RemoveAllNewlines => 1,  # (optional) default 0
        RemoveAllTabs     => 1,  # (optional) default 0
        RemoveAllSpaces   => 1,  # (optional) default 0
    );

=cut

sub StringClean {
    my ( $Self, %Param ) = @_;

    if ( !$Param{StringRef} || ref $Param{StringRef} ne 'SCALAR' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need a scalar reference!'
        );
        return;
    }

    return $Param{StringRef} if !defined ${ $Param{StringRef} };
    return $Param{StringRef} if ${ $Param{StringRef} } eq '';

    # set default values
    $Param{TrimLeft}  = defined $Param{TrimLeft}  ? $Param{TrimLeft}  : 1;
    $Param{TrimRight} = defined $Param{TrimRight} ? $Param{TrimRight} : 1;

    my %TrimAction = (
        RemoveAllNewlines => qr{ [\n\r\f] }xms,
        RemoveAllTabs     => qr{ \t       }xms,
        RemoveAllSpaces   => qr{ [ ]      }xms,
        TrimLeft          => qr{ \A \s+   }xms,
        TrimRight         => qr{ \s+ \z   }xms,
    );

    ACTION:
    for my $Action ( sort keys %TrimAction ) {
        next ACTION if !$Param{$Action};

        ${ $Param{StringRef} } =~ s{ $TrimAction{$Action} }{}xmsg;
    }

    return $Param{StringRef};
}

=item CreditCardClean()

clean a given string and remove credit card

    my ($StringRef, $Found) = $CheckItemObject->CreditCardClean(
        StringRef => \'String',
    );

=cut

sub CreditCardClean {
    my ( $Self, %Param ) = @_;

    if ( !$Param{StringRef} || ref $Param{StringRef} ne 'SCALAR' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need a scalar reference!'
        );
        return;
    }

    return ( $Param{StringRef}, 0 ) if ${ $Param{StringRef} } eq '';
    return ( $Param{StringRef}, 0 ) if !defined ${ $Param{StringRef} };

    # strip credit card numbers
    my $Count = 0;
    ${ $Param{StringRef} } =~ s{
        \b(\d{4})(\s|\.|\+|_|-|\\|/)(\d{4})(\s|\.|\+|_|-|\\|/|)(\d{4})(\s|\.|\+|_|-|\\|/)(\d{3,4})\b
    }
    {
        $Count++;
        "$1$2XXXX$4XXXX$6$7";
    }egx;

    return $Param{StringRef}, $Count;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=cut
