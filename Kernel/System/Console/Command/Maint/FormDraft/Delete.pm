# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::FormDraft::Delete;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsArrayRefWithData);
use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::FormDraft',
    'Kernel::System::DateTime',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Delete draft entries.');
    $Self->AddOption(
        Name        => 'expired',
        Description => 'Delete only drafts which are expired by TTL.',
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'object-type',
        Description => 'Define the object type of draft which should be deleted (e.g. Ticket).',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %Options;
    $Options{Expired}    = $Self->GetOption('expired');
    $Options{ObjectType} = $Self->GetOption('object-type');

    my $FormDraftObject = $Kernel::OM->Get('Kernel::System::FormDraft');
    my $FormDraftList   = $FormDraftObject->FormDraftListGet(
        ObjectType => $Options{ObjectType},
        UserID     => 1,
    );

    $Self->Print("<yellow>Deleting drafts...</yellow>\n");
    if ( IsArrayRefWithData($FormDraftList) ) {
        my %ExpiryTargetTimeByObjectType;
        if ( $Options{Expired} ) {

            my $DateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime'
            );
            my $SystemTime   = $DateTimeObject->ToEpoch();
            my $FormDraftTTL = $Kernel::OM->Get('Kernel::Config')->Get('FormDraftTTL');
            for my $ObjectType ( sort keys %{$FormDraftTTL} ) {
                $ExpiryTargetTimeByObjectType{$ObjectType} = $SystemTime - $FormDraftTTL->{$ObjectType} * 60;
            }
        }
        DRAFT:
        for my $FormDraft ( @{$FormDraftList} ) {
            if ( $Options{Expired} && $ExpiryTargetTimeByObjectType{ $FormDraft->{ObjectType} } ) {

              # FormDrafts are considered expired if their change time is smaller than target time (current time - ttl).
                my $FormDraftSystemTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $FormDraft->{ChangeTime},
                    }
                );
                my $FormDraftSystemTime = $FormDraftSystemTimeObject->ToEpoch();
                next DRAFT if $FormDraftSystemTime > $ExpiryTargetTimeByObjectType{ $FormDraft->{ObjectType} };
            }
            return $Self->ExitCodeError() if !$FormDraftObject->FormDraftDelete(
                FormDraftID => $FormDraft->{FormDraftID},
                UserID      => 1,
            );
        }
    }
    $Self->Print("<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

1;
