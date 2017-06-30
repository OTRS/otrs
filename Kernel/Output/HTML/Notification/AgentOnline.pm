# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Notification::AgentOnline;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::AuthSession',
    'Kernel::System::DateTime',
    'Kernel::Output::HTML::Layout',
);

sub Run {
    my ( $Self, %Param ) = @_;

    # get session object
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

    # get session info
    my %Online      = ();
    my @Sessions    = $SessionObject->GetAllSessionIDs();
    my $IdleMinutes = $Param{Config}->{IdleMinutes} || 60 * 2;
    for (@Sessions) {
        my %Data = $SessionObject->GetSessionIDData(
            SessionID => $_,
        );
        if (
            $Self->{UserID} ne $Data{UserID}
            && $Data{UserType} eq 'User'
            && $Data{UserLastRequest}
            && $Data{UserLastRequest} + ( $IdleMinutes * 60 )
            > $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch()
            && $Data{UserFirstname}
            && $Data{UserLastname}
            )
        {
            $Online{ $Data{UserID} } = "$Data{UserFullname}";
            if ( $Param{Config}->{ShowEmail} ) {
                $Online{ $Data{UserID} } .= " ($Data{UserEmail})";
            }
        }
    }
    for ( sort { $Online{$a} cmp $Online{$b} } keys %Online ) {
        if ( $Param{Message} ) {
            $Param{Message} .= ', ';
        }
        $Param{Message} .= "$Online{$_}";
    }
    if ( $Param{Message} ) {

        # get layout object
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        return $LayoutObject->Notify(
            Info => $LayoutObject->{LanguageObject}->Translate(
                'Online Agent: %s',
                $Param{Message},
            ),
        );
    }
    else {
        return '';
    }
}

1;
