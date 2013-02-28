# --
# Kernel/System/Email/Sendmail.pm - the global email send module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Email::Sendmail;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.35 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # debug
    $Self->{Debug} = $Param{Debug} || 0;

    # check all needed objects
    for (qw(ConfigObject LogObject)) {
        die "Got no $_" if ( !$Self->{$_} );
    }

    return $Self;
}

sub Send {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Header Body ToArray)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # from for arg
    my $Arg = quotemeta( $Param{From} );
    if ( !$Param{From} ) {
        $Arg = "''";
    }

    # get recipients
    my $ToString = '';
    for my $To ( @{ $Param{ToArray} } ) {
        if ($ToString) {
            $ToString .= ', ';
        }
        $ToString .= $To;
        $Arg .= ' ' . quotemeta($To);
    }

    # check availability
    my %Result = $Self->Check();
    if ( !$Result{Successful} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $Result{Message},
        );
        return;
    }

    # set sendmail binary
    my $Sendmail = $Result{Sendmail};

    # invoke sendmail in order to send off mail, catching errors in a temporary file
    my $FH;
    ## no critic
    if ( !open( $FH, '|-', "$Sendmail $Arg " ) ) {
        ## use critic
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't send message: $!!",
        );
        return;
    }

    # switch filehandle to utf8 mode if utf-8 is used
    binmode $FH, ':utf8';    ## no critic

    print $FH ${ $Param{Header} };
    print $FH "\n";
    print $FH ${ $Param{Body} };
    close($FH);

    # debug
    if ( $Self->{Debug} > 2 ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Sent email to '$ToString' from '$Param{From}'.",
        );
    }

    return 1;
}

sub Check {
    my ( $Self, %Param ) = @_;

    # get config data
    my $Sendmail = $Self->{ConfigObject}->Get('SendmailModule::CMD');

    # check if sendmail binary is there (strip all args and check if file exists)
    my $SendmailBinary = $Sendmail;
    $SendmailBinary =~ s/^(.+?)\s.+?$/$1/;
    if ( !-f $SendmailBinary ) {
        return ( Successful => 0, Message => "No such binary: $SendmailBinary!" );
    }
    else {
        return ( Successful => 1, Sendmail => $Sendmail );
    }
}

1;
