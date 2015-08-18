# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminType;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $TypeObject   = $Kernel::OM->Get('Kernel::System::Type');

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $ID = $ParamObject->GetParam( Param => 'ID' ) || '';
        my %Data = $TypeObject->TypeGet( ID => $ID );
        if ( !%Data ) {
            return $LayoutObject->ErrorScreen(
                Message => 'Need Type!',
            );
        }
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Change',
            %Data,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminType',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );
        for my $Parameter (qw(ID Name Text Comment ValidID)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        # check needed data
        for my $Needed (qw(Name ValidID)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        my %Data = $TypeObject->TypeGet( ID => $GetParam{ID} );
        if ( !%Data ) {
            return $LayoutObject->ErrorScreen(
                Message => 'Need Type!',
            );
        }

        # check if a type exists with this name
        my $NameExists = $TypeObject->NameExistsCheck(
            Name => $GetParam{Name},
            ID   => $GetParam{ID}
        );

        if ($NameExists) {
            $Errors{NameExists} = 1;
            $Errors{'NameInvalid'} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # update type
            my $Update = $TypeObject->TypeUpdate(
                %GetParam,
                UserID => $Self->{UserID}
            );
            if ($Update) {
                $Self->_Overview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Notify( Info => 'Type updated!' );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminType',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }
        }

        # something has gone wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify( Priority => 'Error' );
        $Self->_Edit(
            Action => 'Change',
            Errors => \%Errors,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminType',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam = ();
        $GetParam{Name} = $ParamObject->GetParam( Param => 'Name' );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminType',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );
        for my $Parameter (qw(ID Name Text Comment ValidID)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        # check needed data
        for my $Needed (qw(Name ValidID)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # check if a type exists with this name
        my $NameExists = $TypeObject->NameExistsCheck( Name => $GetParam{Name} );
        if ($NameExists) {
            $Errors{NameExists} = 1;
            $Errors{'NameInvalid'} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add type
            my $NewType = $TypeObject->TypeAdd(
                %GetParam,
                UserID => $Self->{UserID}
            );
            if ($NewType) {
                $Self->_Overview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Notify( Info => 'Type added!' );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminType',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }
        }

        # something has gone wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify( Priority => 'Error' );
        $Self->_Edit(
            Action => 'Add',
            Errors => \%Errors,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminType',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        # check if ticket type is enabled to use it here
        if ( !$Kernel::OM->Get('Kernel::Config')->Get('Ticket::Type') ) {
            $Output .= $LayoutObject->Notify(
                Priority => 'Error',
                Data     => $LayoutObject->{LanguageObject}->Translate( "Please activate %s first!", "Type" ),
                Link =>
                    $LayoutObject->{Baselink}
                    . 'Action=AdminSysConfig;Subaction=Edit;SysConfigGroup=Ticket;SysConfigSubGroup=Core::Ticket#Ticket::Type',
            );
        }

        $Self->_Overview();

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminType',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

}

sub _Edit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    # get valid list
    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'ValidIDInvalid'} || '' ),
    );

    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
            %{ $Param{Errors} },
        },
    );

    # shows header
    if ( $Param{Action} eq 'Change' ) {
        $LayoutObject->Block( Name => 'HeaderEdit' );
    }
    else {
        $LayoutObject->Block( Name => 'HeaderAdd' );
    }

    # show appropriate messages for ServerError
    if ( defined $Param{Errors}->{NameExists} && $Param{Errors}->{NameExists} == 1 ) {
        $LayoutObject->Block( Name => 'ExistNameServerError' );
    }
    else {
        $LayoutObject->Block( Name => 'NameServerError' );
    }
    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionAdd' );

    $LayoutObject->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );

    my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');
    my %List = $TypeObject->TypeList( Valid => 0 );

    # if there are any types, they are shown
    if (%List) {

        # get valid list
        my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

        for my $TypeID ( sort { $List{$a} cmp $List{$b} } keys %List ) {

            my %Data = $TypeObject->TypeGet(
                ID => $TypeID,
            );
            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => {
                    Valid => $ValidList{ $Data{ValidID} },
                    %Data,
                },
            );
        }
    }

    # otherwise a no data found msg is displayed
    else {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }
    return 1;
}

1;
