# --
# Kernel/Modules/AdminResponseAttachment.pm - to add/update/delete groups <-> users
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AdminResponseAttachment.pm,v 1.32 2010-01-21 01:16:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminResponseAttachment;

use strict;
use warnings;

use Kernel::System::StdAttachment;
use Kernel::System::StdResponse;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.32 $) [1];

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

    # lib object
    $Self->{StdResponseObject}   = Kernel::System::StdResponse->new(%Param);
    $Self->{StdAttachmentObject} = Kernel::System::StdAttachment->new(%Param);

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
        my %StdResponseData = $Self->{StdResponseObject}->StdResponseGet(
            ID => $ID,
        );

        # get group data
        my %StdAttachmentData = $Self->{StdAttachmentObject}->StdAttachmentList( Valid => 1 );

        # get role member
        my %Member = $Self->{DBObject}->GetTableData(
            Table => 'standard_response_attachment',
            What  => 'standard_attachment_id, standard_response_id',
            Where => "standard_response_id = $ID",
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%StdAttachmentData,
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
    elsif ( $Self->{Subaction} eq 'StdAttachment' ) {

        # get group data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %StdAttachmentData = $Self->{StdAttachmentObject}->StdAttachmentGet( ID => $ID );

        # get user list
        my %StdResponseData = $Self->{StdResponseObject}->StdResponseList( Valid => 1 );

        # get role member
        my %Member = $Self->{DBObject}->GetTableData(
            Table => 'standard_response_attachment',
            What  => 'standard_response_id, standard_attachment_id',
            Where => "standard_attachment_id = $ID"
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%StdResponseData,
            ID       => $StdAttachmentData{ID},
            Name     => $StdAttachmentData{Name},
            Type     => 'StdAttachment',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add user to groups
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeStdAttachment' ) {

        # get new role member
        my @IDs = $Self->{ParamObject}->GetArray( Param => 'Active' );

        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        # get user list
        my %StdResponseData = $Self->{StdResponseObject}->StdResponseList( Valid => 1 );
        for my $StdResponseID ( keys %StdResponseData ) {
            my $Active = 0;
            for my $StdAttachmentID (@IDs) {
                next if $StdAttachmentID ne $StdResponseID;
                $Active = 1;
                last;
            }

            $Self->{DBObject}->Do(
                SQL  => 'DELETE FROM standard_response_attachment WHERE standard_attachment_id = ?',
                Bind => [ \$ID ],
            );
            for my $NewID (@IDs) {
                $Self->{DBObject}->Do(
                    SQL => 'INSERT INTO standard_response_attachment (standard_attachment_id, '
                        . 'standard_response_id, create_time, create_by, change_time, change_by)'
                        . ' VALUES (?, ?, current_timestamp, ?, current_timestamp, ?)',
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

        $Self->{StdAttachmentObject}->StdAttachmentSetResponses(
            AttachmentIDsRef => \@IDs,
            ID               => $ID,
            UserID           => $Self->{UserID},
        );

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
    my $NeType = $Type eq 'StdAttachment' ? 'StdResponse' : 'StdAttachment';

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
        TemplateFile => 'AdminResponseAttachmentForm',
        Data         => \%Param,
    );
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => {},
    );

    # get StdResponse data
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

    # get queue data
    my %StdAttachmentData = $Self->{StdAttachmentObject}->StdAttachmentList( Valid => 1 );
    $CssClass = 'searchpassive';
    for my $StdAttachmentID (
        sort { uc( $StdAttachmentData{$a} ) cmp uc( $StdAttachmentData{$b} ) }
        keys %StdAttachmentData
        )
    {

        # set output class
        $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive';
        $Self->{LayoutObject}->Block(
            Name => 'Listn1',
            Data => {
                Name      => $StdAttachmentData{$StdAttachmentID},
                Subaction => 'StdAttachment',
                ID        => $StdAttachmentID,
                CssClass  => $CssClass,
            },
        );
    }

    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminResponseAttachmentForm',
        Data         => \%Param,
    );
}

1;
