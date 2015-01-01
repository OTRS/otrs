# --
# Kernel/Modules/PublicSupportDataCollector.pm - support data collector
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::PublicSupportDataCollector;

use strict;
use warnings;

use HTTP::Response;

use Kernel::System::SystemData;
use Kernel::System::SupportDataCollector;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject LayoutObject LogObject ConfigObject MainObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{SystemDataObject}           = Kernel::System::SystemData->new( %{$Self} );
    $Self->{SupportDataCollectorObject} = Kernel::System::SupportDataCollector->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # The request must be authenticated with the correct ChallengeToken
    my $ChallengeToken = $Self->{ParamObject}->GetParam( Param => 'ChallengeToken' );
    my $StoredChallengeToken
        = $Self->{SystemDataObject}->SystemDataGet( Key => 'SupportDataCollector::ChallengeToken' );

    # Immediately discard the token (only useable once).
    $Self->{SystemDataObject}->SystemDataDelete(
        Key    => 'SupportDataCollector::ChallengeToken',
        UserID => 1,
    );

    my %Result;

    if ( !$ChallengeToken || $ChallengeToken ne $StoredChallengeToken ) {
        %Result = (
            Success      => 0,
            ErrorMessage => 'Forbidden',
        );
    }
    else {
        %Result = $Self->{SupportDataCollectorObject}->Collect();
    }

    my $JSON = $Self->{LayoutObject}->JSONEncode(
        Data => \%Result,
    );

    # send JSON response
    return $Self->{LayoutObject}->Attachment(
        ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
        Content     => $JSON || '',
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
