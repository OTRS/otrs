# --
# Kernel/System/Scheduler/TaskManager.pm - Scheduler TaskManager backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Scheduler::TaskManager;

use strict;
use warnings;

use Kernel::System::YAML;

use vars qw(@ISA);

=head1 NAME

Kernel::Systrem::Scheduler::TaskManager - TaskManager backend for Scheduler

=head1 SYNOPSIS

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
    use Kernel::System::Scheduler::TaskManager;

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
    my $TaskManagerObject = Kernel::System::Scheduler::TaskManager->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $TaskManager, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $TaskManager );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject LogObject MainObject EncodeObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{YAMLObject} = Kernel::System::YAML->new( %{$Self} );

    return $Self;
}

=item TaskAdd()

add new Tasks

    my $ID = $TaskObject->TaskAdd(
        Type    => 'GenericInterface',     # e. g. GenericInterface, Test
        DueTime => '2006-01-19 23:59:59',  # optional (default current time)
        Data    => {
            ...
        },
    );

=cut

sub TaskAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(Type Data)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # check if DueTime parameter is a valid date
    if ( $Param{DueTime} ) {
        my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Param{DueTime},
        );
        if ( !$SystemTime ) {
            return;
        }
    }

    # check if DueTime parameter is present, otherwise set to current time
    if ( !$Param{DueTime} ) {

        # set current time stamp to DueTime parameter
        $Param{DueTime} = $Self->{TimeObject}->CurrentTimestamp();
    }

    # dump data as string
    my $Data = $Self->{YAMLObject}->Dump( Data => $Param{Data} );

    # check if Data fits in the database
    my $MaxDataLength = $Self->{ConfigObject}->Get('Scheduler::TaskDataLength') || 8_000;

    if ( length $Data > $MaxDataLength ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Task data is too large for the current Database.',
        );
        return;
    }

    # md5 of content
    my $MD5 = $Self->{MainObject}->MD5sum(
        String => $Self->{TimeObject}->SystemTime() . int( rand(1000000) ),
    );

    # sql
    return if !$Self->{DBObject}->Do(
        SQL =>
            'INSERT INTO scheduler_task_list '
            . '(task_data, task_data_md5, task_type, due_time, create_time)'
            . ' VALUES (?, ?, ?, ?, current_timestamp)',
        Bind => [
            \$Data, \$MD5, \$Param{Type}, \$Param{DueTime},
        ],
    );

    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT id FROM scheduler_task_list WHERE task_data_md5 = ?',
        Bind => [ \$MD5 ],
    );
    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    return $ID;
}

=item TaskGet()

get Tasks attributes

    my %Task = $TaskObject->TaskGet(
        ID => 123,
    );

Returns:

    %Task = (
        Data         => $DataRef,
        Type         => 'GenericInterface',
        DueTime      => '2011-02-08 15:10:00'
        CreateTime   => '2011-02-08 15:08:00',
    );

=cut

sub TaskGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT task_data, task_type, due_time, create_time '
            . 'FROM scheduler_task_list WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    my %Data;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {

        my $DataParam = $Self->{YAMLObject}->Load( Data => $Data[0] );

        if ( !$DataParam ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Task data is not in a correct YAML format! ' . $Data[0],
            );
        }

        %Data = (
            ID         => $Param{ID},
            Data       => $DataParam || '',
            Type       => $Data[1],
            DueTime    => $Data[2],
            CreateTime => $Data[3],
        );
    }

    # cleanup time stamps (some databases are using e. g. 2008-02-25 22:03:00.000000
    # and 0000-00-00 00:00:00 time stamps)
    if ( $Data{DueTime} ) {
        $Data{DueTime} =~ s/^(\d\d\d\d-\d\d-\d\d\s\d\d:\d\d:\d\d)\..+?$/$1/;
    }
    return %Data;
}

=item TaskDelete()

delete Task

    $TaskObject->TaskDelete(
        ID     => 123,
    );

=cut

sub TaskDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # check if exists
    my %Task = $Self->TaskGet(
        ID => $Param{ID},
    );
    return if !%Task;

    # sql
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM scheduler_task_list WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    return 1;
}

=item TaskList()

get Task list for a Scheduler

    my @List = $TaskObject->TaskList();

Returns:

    @List = (
        {
            ID      => 123,
            Type    => 'GenericInterface',
            DueTime => '2006-01-19 23:59:59',
        }
    );

=cut

sub TaskList {
    my ( $Self, %Param ) = @_;

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id, task_type, due_time '
            . 'FROM scheduler_task_list ORDER BY create_time, id ASC',
    );

    my @List;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @List,
            {
            ID      => $Row[0],
            Type    => $Row[1],
            DueTime => $Row[2],
            };
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
