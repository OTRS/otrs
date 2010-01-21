# --
# Kernel/Modules/AdminQueueResponses.pm - to add/update/delete groups <-> users
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AdminQueueResponses.pm,v 1.35 2010-01-21 00:44:49 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminQueueResponses;

use strict;
use warnings;

use Kernel::System::Queue;
use Kernel::System::StdResponse;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.35 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{QueueObject}       = Kernel::System::Queue->new(%Param);
    $Self->{StdResponseObject} = Kernel::System::StdResponse->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # user <-> group 1:n
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'StdResponse' ) {

        # get user data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %StdResponseData = $Self->{StdResponseObject}->StdResponseGet( ID => $ID );

        # get queue data
        my %QueueData = $Self->{QueueObject}->QueueList( Valid => 1 );

        # get role member
        my %Member = $Self->{QueueObject}->GetStdResponses(
            StdResponseID => $ID,
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%QueueData,
            ID       => $StdResponseData{ID},
            Name     => $StdResponseData{Name},
            Type     => 'StdResponse',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # group <-> user n:1
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Queue' ) {

        # get group data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %QueueData = $Self->{QueueObject}->QueueGet( ID => $ID );

        # get user list
        my %StdResponseData = $Self->{StdResponseObject}->StdResponseList( Valid => 1 );

        # get role member
        my %Member = $Self->{QueueObject}->GetStdResponses(
            QueueID => $ID,
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%StdResponseData,
            ID       => $QueueData{QueueID},
            Name     => $QueueData{Name},
            Type     => 'Queue',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add user to groups
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeQueue' ) {

        # get new role member
        my @IDs = $Self->{ParamObject}->GetArray( Param => 'Active' );

        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        # get user list
        my %StdResponseData = $Self->{StdResponseObject}->StdResponseList( Valid => 1 );
        for my $StdResponseID ( keys %StdResponseData ) {
            my $Active = 0;
            for my $QueueID (@IDs) {
                next if $QueueID ne $StdResponseID;
                $Active = 1;
                last;
            }

            # update db
            $Self->{DBObject}->Do(
                SQL  => 'DELETE FROM queue_standard_response WHERE queue_id = ?',
                Bind => [ \$ID ],
            );
            for my $NewID (@IDs) {
                $Self->{DBObject}->Do(
                    SQL => 'INSERT INTO queue_standard_response (queue_id, standard_response_id, '
                        . 'create_time, create_by, change_time, change_by) VALUES '
                        . ' (?, ?, current_timestamp, ?, current_timestamp, ?)',
                    Bind => [ \$ID, \$NewID, \$Self->{UserID}, \$Self->{UserID} ],
                );
            }
        }

        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # groups to user
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeStdResponse' ) {

        # get new role member
        my @IDs = $Self->{ParamObject}->GetArray( Param => 'Active' );

        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        # get user list
        my %QueueData = $Self->{QueueObject}->QueueList( Valid => 1 );
        for my $QueueID ( keys %QueueData ) {
            my $Active = 0;
            for my $StdResponseID (@IDs) {
                next if $StdResponseID ne $QueueID;
                $Active = 1;
                last;
            }

            # update db
            $Self->{DBObject}->Do(
                SQL  => 'DELETE FROM queue_standard_response WHERE standard_response_id = ?',
                Bind => [ \$ID ],
            );
            for my $NewID (@IDs) {
                $Self->{DBObject}->Do(
                    SQL => 'INSERT INTO queue_standard_response (queue_id, standard_response_id, '
                        . 'create_time, create_by, change_time, change_by) VALUES '
                        . ' (?, ?, current_timestamp, ?, current_timestamp, ?)',
                    Bind => [ \$NewID, \$ID, \$Self->{UserID}, \$Self->{UserID} ],
                );
            }
        }

        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->_Overview();
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my %Data   = %{ $Param{Data} };
    my $Type   = $Param{Type} || 'StdResponse';
    my $NeType = $Type eq 'Queue' ? 'StdResponse' : 'Queue';

    $Self->{LayoutObject}->Block(
        Name => 'Change',
        Data => {
            %Param,
            ActionHome => 'Admin' . $Type,
            NeType     => $NeType,
        },
    );
    $Self->{LayoutObject}->Block(
        Name => 'ChangeHeader',
        Data => {
            %Param,
            Type => $Type,
        },
    );

    my $CssClass = 'searchpassive';
    for my $ID ( sort { uc( $Data{$a} ) cmp uc( $Data{$b} ) } keys %Data ) {

        # set output class
        $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive';
        my $Selected = $Param{Selected}->{$ID} ? ' checked="checked"' : '';

        $Self->{LayoutObject}->Block(
            Name => 'ChangeRow',
            Data => {
                %Param,
                CssClass => $CssClass,
                Name     => $Param{Data}->{$ID},
                NeType   => $NeType,
                Type     => $Type,
                ID       => $ID,
                Selected => $Selected,
            },
        );
    }

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminQueueResponsesForm',
        Data         => \%Param,
    );
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => {},
    );

    # get std response list
    my %StdResponseData = $Self->{StdResponseObject}->StdResponseList( Valid => 1 );
    my $CssClass = 'searchpassive';
    for my $StdResponseID (
        sort { uc( $StdResponseData{$a} ) cmp uc( $StdResponseData{$b} ) }
        keys %StdResponseData
        )
    {

        # set output class
        $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive';
        $Self->{LayoutObject}->Block(
            Name => 'List1n',
            Data => {
                Name      => $StdResponseData{$StdResponseID},
                Subaction => 'StdResponse',
                ID        => $StdResponseID,
                CssClass  => $CssClass,
            },
        );
    }

    $CssClass = 'searchpassive';

    # get queue data
    my %QueueData = $Self->{QueueObject}->QueueList( Valid => 1 );
    for my $QueueID ( sort { uc( $QueueData{$a} ) cmp uc( $QueueData{$b} ) } keys %QueueData ) {

        # set output class
        $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive';
        $Self->{LayoutObject}->Block(
            Name => 'Listn1',
            Data => {
                Name      => $QueueData{$QueueID},
                Subaction => 'Queue',
                ID        => $QueueID,
                CssClass  => $CssClass,
            },
        );
    }

    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminQueueResponsesForm',
        Data         => \%Param,
    );
}

1;
