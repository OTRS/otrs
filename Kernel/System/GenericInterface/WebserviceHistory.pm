# --
# Kernel/System/GenericInterface/WebserviceHistory.pm - GenericInterface WebserviceHistory config backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::GenericInterface::WebserviceHistory;

use strict;
use warnings;

use Kernel::System::YAML;

use vars qw(@ISA $VERSION);

=head1 NAME

Kernel::System::WebserviceHistory

=head1 SYNOPSIS

WebserviceHistory configuration history backend.
It holds older versions of web service configuration data.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::GenericInterface::WebserviceHistory;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $WebserviceHistoryObject = Kernel::System::GenericInterface::WebserviceHistory->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
        TimeObject   => $TimeObject,
    );

=cut

sub new {
    my ( $WebserviceHistory, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $WebserviceHistory );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject LogObject MainObject EncodeObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{YAMLObject} = Kernel::System::YAML->new( %{$Self} );
    return $Self;
}

=item WebserviceHistoryAdd()

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # dump config as string
    my $Config = $Self->{YAMLObject}->Dump( Data => $Param{Config} );

    # md5 of content
    my $MD5 = $Self->{MainObject}->MD5sum(
        String => $Self->{TimeObject}->SystemTime() . int( rand(1000000) ),
    );

    # sql
    return if !$Self->{DBObject}->Do(
        SQL =>
            'INSERT INTO gi_webservice_config_history
                (config_id, config, config_md5, create_time, create_by, change_time, change_by)
            VALUES (?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{WebserviceID}, \$Config, \$MD5, \$Param{UserID}, \$Param{UserID},
        ],
    );

    return if !$Self->{DBObject}->Prepare(
        SQL   => 'SELECT id FROM gi_webservice_config_history WHERE config_md5 = ?',
        Bind  => [ \$MD5 ],
        Limit => 1,
    );
    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    return $ID;
}

=item WebserviceHistoryGet()

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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT config_id, config, create_time, change_time
                FROM gi_webservice_config_history
                WHERE id = ?',
        Bind  => [ \$Param{ID} ],
        Limit => 1,
    );
    my %Data;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {

        my $Config = $Self->{YAMLObject}->Load( Data => $Data[1] );

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

=item WebserviceHistoryUpdate()

update WebserviceHistory attributes

    my $Success = $WebserviceObject->WebserviceHistoryUpdate(
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # dump config as string
    my $Config = $Self->{YAMLObject}->Dump( Data => $Param{Config} );

    # md5 of content
    my $MD5 = $Self->{MainObject}->MD5sum(
        String => $Self->{TimeObject}->SystemTime() . int( rand(1000000) ),
    );

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE gi_webservice_config_history
                SET config_id = ?, config = ?, config_md5 = ?, hange_time = current_timestamp, change_by = ?
                WHERE id = ?',
        Bind => [
            \$Param{WebserviceID}, \$Config, \$MD5, \$Param{UserID}, \$Param{ID},
        ],
    );
    return 1;
}

=item WebserviceHistoryDelete()

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'DELETE FROM gi_webservice_config_history
                WHERE config_id = ?',
        Bind => [ \$Param{WebserviceID} ],
    );

    return 1;
}

=item WebserviceHistoryList()

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Prepare(
        SQL =>
            'SELECT id FROM gi_webservice_config_history
            WHERE config_id = ? ORDER BY id DESC',
        Bind => [ \$Param{WebserviceID} ],
    );

    my @List;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @List, $Row[0];
    }
    return @List;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=cut
