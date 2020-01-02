# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::GenericInterface::WebserviceHistory;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::YAML',
);

=head1 NAME

Kernel::System::GenericInterface::WebserviceHistory

=head1 DESCRIPTION

WebserviceHistory configuration history backend.
It holds older versions of web service configuration data.

=head1 PUBLIC INTERFACE

=head2 new()

create a debug log object. Do not use it directly, instead use:

    my $WebserviceHistoryObject = $Kernel::OM->Get('Kernel::System::GenericInterface::WebserviceHistory');

=cut

sub new {
    my ( $WebserviceHistory, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $WebserviceHistory );

    return $Self;
}

=head2 WebserviceHistoryAdd()

add new WebserviceHistory entry

    my $ID = $WebserviceHistoryObject->WebserviceHistoryAdd(
        WebserviceID => 2134,
        Config       => {
            ...
        },
        UserID  => 123,
    );

=cut

sub WebserviceHistoryAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(WebserviceID Config UserID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!"
            );
            return;
        }
    }

    # dump config as string
    my $Config = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $Param{Config} );

    # md5 of content
    my $MD5 = $Kernel::OM->Get('Kernel::System::Main')->MD5sum(
        String => $Param{WebserviceID}
            . $Param{Config}
            . $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString( Length => 32 )
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Do(
        SQL =>
            'INSERT INTO gi_webservice_config_history
                (config_id, config, config_md5, create_time, create_by, change_time, change_by)
            VALUES (?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{WebserviceID}, \$Config, \$MD5, \$Param{UserID}, \$Param{UserID},
        ],
    );

    return if !$DBObject->Prepare(
        SQL   => 'SELECT id FROM gi_webservice_config_history WHERE config_md5 = ?',
        Bind  => [ \$MD5 ],
        Limit => 1,
    );

    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ID = $Row[0];
    }

    return $ID;
}

=head2 WebserviceHistoryGet()

get WebserviceHistory attributes

    my $WebserviceHistory = $WebserviceHistoryObject->WebserviceHistoryGet(
        ID => 123,
    );

Returns:

    $WebserviceHistory = {
        Config       => $ConfigRef,
        WebserviceID => 123,
        CreateTime   => '2011-02-08 15:08:00',
        ChangeTime   => '2011-02-08 15:08:00',
    };

=cut

sub WebserviceHistoryGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ID!'
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Prepare(
        SQL => 'SELECT config_id, config, create_time, change_time
                FROM gi_webservice_config_history
                WHERE id = ?',
        Bind  => [ \$Param{ID} ],
        Limit => 1,
    );

    # get yaml object
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    my %Data;
    while ( my @Data = $DBObject->FetchrowArray() ) {

        my $Config = $YAMLObject->Load( Data => $Data[1] );

        %Data = (
            ID           => $Param{ID},
            WebserviceID => $Data[0],
            Config       => $Config,
            CreateTime   => $Data[3],
            ChangeTime   => $Data[4],
        );
    }

    return \%Data;
}

=head2 WebserviceHistoryUpdate()

update WebserviceHistory attributes

    my $Success = $WebserviceHistoryObject->WebserviceHistoryUpdate(
        ID           => 123,
        WebserviceID => 123
        Config       => $ConfigHashRef,
        UserID       => 123,
    );

=cut

sub WebserviceHistoryUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID WebserviceID Config UserID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!"
            );
            return;
        }
    }

    # dump config as string
    my $Config = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $Param{Config} );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Do(
        SQL => 'UPDATE gi_webservice_config_history
                SET config_id = ?, config = ?, change_time = current_timestamp, change_by = ?
                WHERE id = ?',
        Bind => [
            \$Param{WebserviceID}, \$Config, \$Param{UserID}, \$Param{ID},
        ],
    );

    return 1;
}

=head2 WebserviceHistoryDelete()

delete WebserviceHistory

    my $Success = $WebserviceHistoryObject->WebserviceHistoryDelete(
        WebserviceID => 123,
        UserID       => 123,
    );

=cut

sub WebserviceHistoryDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(WebserviceID UserID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!"
            );
            return;
        }
    }

    # sql
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => 'DELETE FROM gi_webservice_config_history
                WHERE config_id = ?',
        Bind => [ \$Param{WebserviceID} ],
    );

    return 1;
}

=head2 WebserviceHistoryList()

get WebserviceHistory list for a GenericInterface web service

    my @List = $WebserviceHistoryObject->WebserviceHistoryList(
        WebserviceID => 1243,
    );

=cut

sub WebserviceHistoryList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(WebserviceID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL =>
            'SELECT id FROM gi_webservice_config_history
            WHERE config_id = ? ORDER BY id DESC',
        Bind => [ \$Param{WebserviceID} ],
    );

    my @List;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @List, $Row[0];
    }

    return @List;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
