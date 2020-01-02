# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentInfo;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    $Self->{InfoKey}  = $ConfigObject->Get('InfoKey');
    $Self->{InfoFile} = $ConfigObject->Get('InfoFile');

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

        # remove requested url from session storage
        $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserRequestedURL',
            Value     => $Self->{RequestedURL},
        );
        return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Redirect( OP => "Action=AgentInfo" );
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

    my $Accept        = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'Accept' ) || '';
    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

    if ( $Self->{ $Self->{InfoKey} } ) {

        # remove requested url from session storage
        $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserRequestedURL',
            Value     => '',
        );

        # redirect
        return $LayoutObject->Redirect( OP => "$Self->{UserRequestedURL}" );
    }
    elsif ($Accept) {

        # set session
        $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => $Self->{InfoKey},
            Value     => 1,
        );

        # set preferences
        $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
            UserID => $Self->{UserID},
            Key    => $Self->{InfoKey},
            Value  => 1,
        );

        # remove requested url from session storage
        $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserRequestedURL',
            Value     => '',
        );

        # redirect
        return $LayoutObject->Redirect( OP => "$Self->{RequestedURL}" );
    }
    else {

        # show info
        $Output = $LayoutObject->Header();
        $Output
            .= $LayoutObject->Output(
            TemplateFile => $Self->{InfoFile},
            Data         => \%Param
            );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }
}

1;
