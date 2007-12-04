# --
# Kernel/System/Email/Sendmail.pm - the global email send module
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Sendmail.pm,v 1.22 2007-12-04 13:12:27 ot Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Email::Sendmail;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.22 $) [1];

use Kernel::System::FileTemp;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get common objects
    for ( keys %Param ) {
        $Self->{$_} = $Param{$_};
    }

    # debug
    $Self->{Debug} = $Param{Debug} || 0;

    # check all needed objects
    for (qw(ConfigObject LogObject)) {
        die "Got no $_" if ( !$Self->{$_} );
    }

    # get config data
    $Self->{Sendmail} = $Self->{ConfigObject}->Get('SendmailModule::CMD');

    $Self->{FileTempObject} = Kernel::System::FileTemp->new(%Param);

    return $Self;
}

sub Send {
    my ( $Self, %Param ) = @_;

    my $ToString = '';
    my $FH;

    # check needed stuff
    for (qw(Header Body ToArray)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # from
    my $Arg = quotemeta( $Param{From} );
    if ( !$Param{From} ) {
        $Arg = "''";
    }

    # recipient
    for ( @{ $Param{ToArray} } ) {
        $ToString .= "$_,";
        $Arg      .= ' ' . quotemeta($_);
    }

    # invoke sendmail in order to send off mail, catching errors in a temporary file
    my ( $ErrFH, $ErrFilename ) = $Self->{FileTempObject}->TempFile();
    open( $FH, '|-', "$Self->{Sendmail} $Arg 2>$ErrFilename" ) or goto ERROR;

    # switch filehandle to utf8 mode if utf-8 is used
    if ( $Self->{ConfigObject}->Get('DefaultCharset') =~ m{^utf-?8$}i ) {
        binmode $FH, ":utf8";
    }
    print $FH ${ $Param{Header} };
    print $FH "\n";
    print $FH ${ $Param{Body} };
    close($FH) or goto ERROR;

    # debug
    if ( $Self->{Debug} > 2 ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Sent email to '$ToString' from '$Param{From}'.",
        );
    }

    return 1;

ERROR:
    # fetch error text from temporary file and log it
    my $ErrorText;
    {
        local $/;
        $ErrorText = <$ErrFH>;
    }
    $Self->{LogObject}->Log(
        Priority => 'error',
        Message  => "Can't send message!\nError: $ErrorText",
    );
    return;
}

1;
