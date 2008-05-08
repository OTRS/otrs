# --
# Kernel/Modules/AgentInfo.pm - to show an agent an login/changes info
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentInfo.pm,v 1.10 2008-05-08 09:36:36 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentInfo;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{InfoKey}  = $Self->{ConfigObject}->Get('InfoKey');
    $Self->{InfoFile} = $Self->{ConfigObject}->Get('InfoFile');

    return $Self;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $Output;
    if ( !$Self->{RequestedURL} ) {
        $Self->{RequestedURL} = 'Action=';
    }

    # redirect if no primary group is selected
    if ( !$Self->{ $Self->{InfoKey} } && $Self->{Action} ne 'AgentInfo' ) {

        # remove requested url from sesseion storage
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserRequestedURL',
            Value     => $Self->{RequestedURL},
        );
        return $Self->{LayoutObject}->Redirect( OP => "Action=AgentInfo" );
    }
    else {
        return;
    }
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;
    if ( !$Self->{RequestedURL} ) {
        $Self->{RequestedURL} = 'Action=';
    }
    my $Accept = $Self->{ParamObject}->GetParam( Param => 'Accept' ) || '';
    if ( $Self->{ $Self->{InfoKey} } ) {

        # remove requested url from sesseion storage
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserRequestedURL',
            Value     => '',
        );

        # redirect
        return $Self->{LayoutObject}->Redirect( OP => "$Self->{UserRequestedURL}" );
    }
    elsif ($Accept) {

        # set session
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => $Self->{InfoKey},
            Value     => 1,
        );

        # set preferences
        $Self->{UserObject}->SetPreferences(
            UserID => $Self->{UserID},
            Key    => $Self->{InfoKey},
            Value  => 1,
        );

        # remove requested url from sesseion storage
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserRequestedURL',
            Value     => '',
        );

        # redirect
        return $Self->{LayoutObject}->Redirect( OP => "$Self->{UserRequestedURL}" );
    }
    else {

        # show info
        $Output = $Self->{LayoutObject}->Header();
        $Output
            .= $Self->{LayoutObject}->Output( TemplateFile => $Self->{InfoFile}, Data => \%Param );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

1;
