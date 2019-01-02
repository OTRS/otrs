# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Notification::AgentOnline;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::AuthSession',
    'Kernel::System::Time',
    'Kernel::Output::HTML::Layout',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get UserID param
    $Self->{UserID} = $Param{UserID} || die "Got no UserID!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get session object
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

    my $SessionMaxIdleTime = $Kernel::OM->Get('Kernel::Config')->Get('SessionMaxIdleTime');

    # get session info
    my %Online   = ();
    my @Sessions = $SessionObject->GetAllSessionIDs();

    for (@Sessions) {
        my %Data = $SessionObject->GetSessionIDData(
            SessionID => $_,
        );
        if (
            $Self->{UserID} ne $Data{UserID}
            && $Data{UserType} eq 'User'
            && $Data{UserLastRequest}
            && $Data{UserLastRequest} + $SessionMaxIdleTime > $Kernel::OM->Get('Kernel::System::Time')->SystemTime()
            && $Data{UserFirstname}
            && $Data{UserLastname}
            )
        {
            $Online{ $Data{UserID} } = "$Data{UserFirstname} $Data{UserLastname}";
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
