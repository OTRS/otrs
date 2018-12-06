# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Email::Sendmail;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Encode',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # debug
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

sub Send {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Header Body ToArray)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
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
        $Arg      .= ' ' . quotemeta($To);
    }

    # check availability
    my %Result = $Self->Check();
    if ( !$Result{Successful} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $Result{Message},
        );
        return;
    }

    # set sendmail binary
    my $Sendmail = $Result{Sendmail};

    # restore the child signal to the original value, in a daemon environment, child signal is set
    # to ignore causing problems with file handler pipe close
    local $SIG{'CHLD'} = 'DEFAULT';

    # invoke sendmail in order to send off mail, catching errors in a temporary file
    my $FH;
    ## no critic
    if ( !open( $FH, '|-', "$Sendmail $Arg " ) ) {
        ## use critic
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't send message: $!!",
        );
        return;
    }

    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # encode utf8 header strings (of course, there should only be 7 bit in there!)
    $EncodeObject->EncodeOutput( $Param{Header} );

    # encode utf8 body strings
    $EncodeObject->EncodeOutput( $Param{Body} );

    print $FH ${ $Param{Header} };
    print $FH "\n";
    print $FH ${ $Param{Body} };

    # Check if the filehandle was already closed because of an error
    #   (e. g. mail too large). See bug#9251.
    if ( !close($FH) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't send message: $!!",
        );
        return;
    }

    # debug
    if ( $Self->{Debug} > 2 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Sent email to '$ToString' from '$Param{From}'.",
        );
    }

    return 1;
}

sub Check {
    my ( $Self, %Param ) = @_;

    # get config data
    my $Sendmail = $Kernel::OM->Get('Kernel::Config')->Get('SendmailModule::CMD');

    # check if sendmail binary is there (strip all args and check if file exists)
    my $SendmailBinary = $Sendmail;
    $SendmailBinary =~ s/^(.+?)\s.+?$/$1/;
    if ( !-f $SendmailBinary ) {
        return (
            Successful => 0,
            Message    => "No such binary: $SendmailBinary!"
        );
    }
    else {
        return (
            Successful => 1,
            Sendmail   => $Sendmail
        );
    }
}

1;
