# --
# Kernel/System/Scheduler/TaskManager.pm - Scheduler TaskManager backend
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Scheduler::TaskManager;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Time',
    'Kernel::System::YAML',
);
our $ObjectManagerAware = 1;

=head1 NAME

Kernel::System::Scheduler::TaskManager - TaskManager backend for Scheduler

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TaskManagerObject = $Kernel::OM->Get('Kernel::System::Scheduler::TaskManager');

=cut

sub new {
    my ( $TaskManager, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $TaskManager );

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
            $Kernel::OM->Get('Kernel::System::Log')
                ->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # check if DueTime parameter is a valid date
    if ( $Param{DueTime} ) {
        my $SystemTime = $TimeObject->TimeStamp2SystemTime(
            String => $Param{DueTime},
        );
        if ( !$SystemTime ) {
            return;
        }
    }

    # check if DueTime parameter is present, otherwise set to current time
    if ( !$Param{DueTime} ) {

        # set current time stamp to DueTime parameter
        $Param{DueTime} = $TimeObject->CurrentTimestamp();
    }

    # dump data as string
    my $Data = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $Param{Data} );

    # check if Data fits in the database
    my $MaxDataLength
        = $Kernel::OM->Get('Kernel::Config')->Get('Scheduler::TaskDataLength') || 8_000;

    if ( length $Data > $MaxDataLength ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Task data is too large for the current Database.',
        );
        return;
    }

    # md5 of content
    my $MD5 = $Kernel::OM->Get('Kernel::System::Main')->MD5sum(
        String => $TimeObject->SystemTime() . int( rand(1000000) ),
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Do(
        SQL =>
            'INSERT INTO scheduler_task_list '
            . '(task_data, task_data_md5, task_type, due_time, create_time)'
            . ' VALUES (?, ?, ?, ?, current_timestamp)',
        Bind => [
            \$Data, \$MD5, \$Param{Type}, \$Param{DueTime},
        ],
    );

    return if !$DBObject->Prepare(
        SQL  => 'SELECT id FROM scheduler_task_list WHERE task_data_md5 = ?',
        Bind => [ \$MD5 ],
    );

    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
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
        $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Prepare(
        SQL => 'SELECT task_data, task_type, due_time, create_time '
            . 'FROM scheduler_task_list WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # get yaml object
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    my %Data;
    while ( my @Data = $DBObject->FetchrowArray() ) {

        my $DataParam = $YAMLObject->Load( Data => $Data[0] );

        if ( !$DataParam ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    # check if exists
    my %Task = $Self->TaskGet(
        ID => $Param{ID},
    );
    return if !%Task;

    # sql
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
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

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => 'SELECT id, task_type, due_time '
            . 'FROM scheduler_task_list ORDER BY create_time, id ASC',
    );

    my @List;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @List, {
            ID      => $Row[0],
            Type    => $Row[1],
            DueTime => $Row[2],
        };
    }

    return @List;
}

=item TaskUpdate()

update an existring Task

    my $Success = $TaskObject->TaskUpdate(
        ID      => 123m
        Type    => 'GenericInterface',     # optional, e. g. GenericInterface, Test
        DueTime => '2006-01-19 23:59:59',  # optional
        Data    => {                       # optional
            ...
        },
    );

=cut

sub TaskUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')
                ->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # check if task exists and get its data to use it as a basis
    my %Task = $Self->TaskGet(
        ID => $Param{ID},
    );
    if ( !%Task ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Task with ID:'$Param{ID}' is invalid",
        );
        return;
    }

    # convert Task Data to a YAML string
    $Task{Data} = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $Task{Data} );

    # return success if there is nothing to do
    if ( !$Param{Type} && !$Param{DueTime} && !$Param{Data} ) {
        return 1;
    }

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # check if DueTime parameter is a valid date
    if ( $Param{DueTime} ) {
        my $SystemTime = $TimeObject->TimeStamp2SystemTime(
            String => $Param{DueTime},
        );
        if ( !$SystemTime ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "DueTime is invalid",
            );
            return;
        }
    }

    my $Data;
    if ( $Param{Data} ) {

        # dump data as string
        $Data = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $Param{Data} );

        # check if Data fits in the database
        my $MaxDataLength
            = $Kernel::OM->Get('Kernel::Config')->Get('Scheduler::TaskDataLength') || 8_000;

        if ( length $Data > $MaxDataLength ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Task data is too large for the current Database.',
            );
            return;
        }
    }

    # md5 of system time
    my $MD5 = $Kernel::OM->Get('Kernel::System::Main')->MD5sum(
        String => $TimeObject->SystemTime() . int( rand(1000000) ),
    );

    # update task definition
    $Task{Type}    = $Param{Type}    // $Task{Type};
    $Task{DueTime} = $Param{DueTime} // $Task{DueTime};
    $Task{Data}    = $Data           // $Task{Data};

    # sql
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            UPDATE scheduler_task_list
            SET  task_data = ?, task_data_md5 = ?, task_type = ?, due_time = ?
            WHERE id = ?',
        Bind => [
            \$Task{Data}, \$MD5, \$Task{Type}, \$Task{DueTime}, \$Param{ID},
        ],
    );

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
