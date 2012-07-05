# --
# Kernel/System/ProcessManagement/Activity.pm - Process Management DB Activity backend
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: Activity.pm,v 1.1 2012-07-05 14:54:30 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::DB::Activity;

use strict;
use warnings;

use YAML;

use Kernel::System::Cache;
use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::System::ProcessManagement::DB::Activity.pm

=head1 SYNOPSIS

Process Management DB Activity backend

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an Activity object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::ProcessManagement::DB::Activity;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
    );
    my $ActivityObject = Kernel::System::ProcessManagement::DB::Activity->new(
        ConfigObject        => $ConfigObject,
        EncodeObject        => $EncodeObject,
        LogObject           => $LogObject,
        MainObject          => $MainObject,
        DBObject            => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(ConfigObject EncodeObject LogObject TimeObject MainObject DBObject)) {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    # create additional objects
    $Self->{CacheObject} = Kernel::System::Cache->new( %{$Self} );

    # get the cache TTL (in seconds)
    $Self->{CacheTTL}
        = int( $Self->{ConfigObject}->Get('Process::CacheTTL') || 3600 );

    # set lower if database is case sensitive
    $Self->{Lower} = '';
    if ( !$Self->{DBObject}->GetDatabaseFunction('CaseInsensitive') ) {
        $Self->{Lower} = 'LOWER';
    }

    return $Self;
}

#TODO add tests

=item ActivityAdd()

add new Activity

returns the id of the created activity if success or undef otherwise

    my $ID = $ActivityObject->ActivityAdd(
        EntityID    => 'A1'              # mandatory, exportable unique identifier
        Name        => 'NameOfActivity', # mandatory
        Config      => $ConfigHashRef,   # mandatory, activity configuration to be stored in YAML
                                         #   format
        UserID      => 123,              # mandatory
    );

Returns:

    $ID = 567;

=cut

sub ActivityAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(EntityID Name Config UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    # check if EntityID already exists
    return if !$Self->{DBObject}->Prepare(
        SQL => "
            SELECT id
            FROM pm_activity
            WHERE $Self->{Lower}(entity_id) = $Self->{Lower}(?)",
        Bind  => [ \$Param{EntityID} ],
        Limit => 1,
    );

    my $EntityExists;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $EntityExists = 1;
    }

    if ($EntityExists) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The EntityID:$Param{EntityID} already exists for an activity!"
        );
        return;
    }

    # check config valid format
    if ( ref $Param{Config} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Config needs to be a valid Hash reference!",
        );
        return;
    }

    # dump config as string
    my $Config = YAML::Dump( $Param{Config} );

    # Make sure the resulting string has the UTF-8 flag. YAML only sets it if
    #   part of the data already had it.
    utf8::upgrade($Config);

    # md5 of content
    my $MD5 = $Self->{MainObject}->MD5sum(
        String => $Self->{TimeObject}->SystemTime() . int( rand(1000000) ),
    );

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => '
            INSERT INTO pm_activity (entity_id, name, config, create_time, create_by, change_time,
                change_by)
            VALUES (?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{EntityID}, \$Param{Name}, \$Config, \$Param{EntityID}, \$Param{EntityID},
        ],
    );

    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT id FROM pm_activity WHERE entity_id = ?',
        Bind => [ \$Param{EntityID} ],
    );

    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ProcessManagement_Activity',
    );

    return if !$ID;

    return $ID;
}

#TODO add tests

=item ActivityDelete()

delete an Activity

returns 1 if success or undef otherwise

    my $Success = $ActivityObject->ActivityDelete(
        ID      => 123,
        UserID  => 123,
    );

=cut

sub ActivityDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Key!"
            );
            return;
        }
    }

    # TODO re-enable
    #    # check if exists
    #    my $Activity = $Self->ActivityGet(
    #        ID     => $Param{ID},
    #        UserID => 1,
    #    );
    #    return if !IsHashRefWithData($Activity);

    # delete activity
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM pm_activity WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ProcessManagement_Activity',
    );

    return 1;
}

# TODO add tests

=item ActivityList()

get an Activity list

    my $List = $ActivityObject->ActivityList(
        UseEntities => 0,                       # default 0, 1 || 0. if 0 the return hash keys are
                                                #    the activity IDs otherwise keys are the
                                                #    activity entity IDs
        UserID      => 1,
    );

    Returns:

    $List = {
        1 => 'Activity1',
    }

    or

    $List = {
        'A1' => 'Activity1',
    }
=cut

sub ActivityList {
    my ( $Self, %Param ) = @_;

    # check needed
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!"
        );
        return;
    }

    # check cache
    my $UseEntities = 0;
    if ( defined $Param{UseEntities} && $Param{UseEntities} ) {
        $UseEntities = 1;
    }
    my $CacheKey = 'ActivityList::UseEntities::' . $UseEntities;
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'ProcessManagement_Activity',
        Key  => $CacheKey,
    );
    return $Cache if ref $Cache;

    return if !$Self->{DBObject}->Prepare(
        SQL => '
            SELECT id, entity_id, name
            FROM pm_activity',
    );

    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        if ( !$UseEntities ) {
            $Data{ $Row[0] } = $Row[2];
        }
        else {
            $Data{ $Row[1] } = $Row[2];
        }
    }

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'ProcessManagement_Activity',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.1 $ $Date: 2012-07-05 14:54:30 $

=cut
