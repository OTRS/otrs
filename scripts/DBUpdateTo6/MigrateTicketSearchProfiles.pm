# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::MigrateTicketSearchProfiles;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
    'Kernel::System::SysConfig::DB'
);

=head1 NAME

scripts::DBUpdateTo6::MigrateTicketSearchProfiles - Migrate ticket search profiles article field keys and values.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Rename old-style article fields in search profile key.
    my %KeyMap = (
        Body           => 'MIMEBase_Body',
        Cc             => 'MIMEBase_Cc',
        Bcc            => 'MIMEBase_Bcc',
        From           => 'MIMEBase_From',
        Subject        => 'MIMEBase_Subject',
        To             => 'MIMEBase_To',
        AttachmentName => 'MIMEBase_AttachmentName',
    );

    KEY:
    for my $OldKey ( sort keys %KeyMap ) {
        next KEY if !$DBObject->Prepare(
            SQL => 'UPDATE search_profile
                SET profile_key = ?
                WHERE profile_key = ?
            ',
            Bind => [ \$KeyMap{$OldKey}, \$OldKey ],
        );
    }

    # Rename old-style article fields in search profile value for 'ShownAttributes' profile key.
    my %ValueMap = (
        LabelBody           => 'LabelMIMEBase_Body',
        LabelCc             => 'LabelMIMEBase_Cc',
        LabelBcc            => 'LabelMIMEBase_Bcc',
        LabelFrom           => 'LabelMIMEBase_From',
        LabelSubject        => 'LabelMIMEBase_Subject',
        LabelTo             => 'LabelMIMEBase_To',
        LabelAttachmentName => 'LabelMIMEBase_AttachmentName',
    );

    my $ProfileKey = "ShownAttributes";
    KEY:
    for my $OldValue ( sort keys %ValueMap ) {
        next KEY if !$DBObject->Prepare(
            SQL => 'UPDATE search_profile
                SET profile_value = ?
                WHERE profile_key = ?
                AND profile_value = ?
            ',
            Bind => [ \$ValueMap{$OldValue}, \$ProfileKey, \$OldValue ],
        );
    }

    my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    KEY:
    for my $OldKey ( sort keys %KeyMap ) {

        next KEY if $OldKey eq 'Bcc';
        next KEY if $OldKey eq 'AttachmentName';

        my $NewName = 'Ticket::Frontend::AgentTicketSearch###Defaults###' . $KeyMap{$OldKey};
        my $OldName = 'Ticket::Frontend::AgentTicketSearch###Defaults###' . $OldKey;

        my %Setting = $SysConfigObject->SettingGet(
            Name    => $OldName,
            NoLog   => 1,
            Default => 1,
        );
        next KEY if !IsHashRefWithData( \%Setting );

        $SysConfigObject->SettingLock(
            Name   => $OldName,
            UserID => 1,
        );

        # Delete item with new name from 'sysconfig_default_version'.
        next KEY if !$DBObject->Do(
            SQL  => 'DELETE FROM sysconfig_default_version WHERE name = ?',
            Bind => [ \$NewName ],
        );

        # Delete item with new name from 'sysconfig_default'.
        next KEY if !$DBObject->Do(
            SQL  => 'DELETE FROM sysconfig_default WHERE name = ?',
            Bind => [ \$NewName ],
        );

        # Update item name from 'sysconfig_default_version'.
        next KEY if !$DBObject->Do(
            SQL => 'UPDATE sysconfig_default_version
                SET name = ?
                WHERE name = ?
            ',
            Bind => [ \$NewName, \$OldName ],
        );

        # Update item name from 'sysconfig_default'.
        next KEY if !$DBObject->Do(
            SQL => 'UPDATE sysconfig_default
                SET name = ?
                WHERE name = ?
            ',
            Bind => [ \$NewName, \$OldName ],
        );

        # Check if old setting value needs to be migrated.
        my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
            Name => $OldName,
        );
        next KEY if !IsHashRefWithData( \%ModifiedSetting );

        # Update item name from 'sysconfig_modified_version'.
        next KEY if !$DBObject->Do(
            SQL => 'UPDATE sysconfig_modified_version
                SET name = ?
                WHERE name = ?
            ',
            Bind => [ \$NewName, \$OldName ],
        );

        # Update item name from 'sysconfig_modified'.
        next KEY if !$DBObject->Do(
            SQL => 'UPDATE sysconfig_modified
                SET name = ?
                WHERE name = ?
            ',
            Bind => [ \$NewName, \$OldName ],
        );

        # Unlock setting.
        $SysConfigDBObject->DefaultSettingUnlock(
            DefaultID => $Setting{DefaultID},
        );
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
