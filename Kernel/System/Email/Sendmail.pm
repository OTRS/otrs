# --
# Kernel/System/Email/Sendmail.pm - the global email send module
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: Sendmail.pm,v 1.29 2009-02-16 11:48:19 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Email::Sendmail;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.29 $) [1];

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

    # get config data
    my $Sendmail = $Self->{ConfigObject}->Get('SendmailModule::CMD');

    # invoke sendmail in order to send off mail, catching errors in a temporary file
    my $FH;
    if ( open( $FH, '|-', "$Sendmail $Arg " ) ) {

        # switch filehandle to utf8 mode if utf-8 is used
        if ( $Self->{ConfigObject}->Get('DefaultCharset') =~ /^utf(-8|8)$/i ) {
            binmode $FH, ":utf8";
        }
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
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't send message: $!!",
        );
        return;
    }
}

1;
