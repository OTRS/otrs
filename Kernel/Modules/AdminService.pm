# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminService;

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

    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
    my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

    # ------------------------------------------------------------ #
    # service edit
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'ServiceEdit' ) {

        # header
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        # html output
        $Output .= $Self->_MaskNew(
            %Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # service save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ServiceSave' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

        # get params
        my %GetParam;
        for (qw(ServiceID ParentID Name ValidID Comment)) {
            $GetParam{$_} = $ParamObject->GetParam( Param => $_ ) || '';
        }

        my %Error;

        if ( !$GetParam{Name} ) {
            $Error{'NameInvalid'} = 'ServerError';
        }

        if ( !%Error ) {

            my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

            # save to database
            if ( $GetParam{ServiceID} eq 'NEW' ) {
                $GetParam{ServiceID} = $ServiceObject->ServiceAdd(
                    %GetParam,
                    UserID => $Self->{UserID},
                );
                if ( !$GetParam{ServiceID} ) {
                    $Error{Message} = $LogObject->GetLogEntry(
                        Type => 'Error',
                        What => 'Message',
                    );
                }
            }
            else {
                my $Success = $ServiceObject->ServiceUpdate(
                    %GetParam,
                    UserID => $Self->{UserID},
                );
                if ( !$Success ) {
                    $Error{Message} = $LogObject->GetLogEntry(
                        Type => 'Error',
                        What => 'Message',
                    );
                }
            }

            if ( !%Error ) {

                # update preferences
                my %ServiceData = $ServiceObject->ServiceGet(
                    ServiceID => $GetParam{ServiceID},
                    UserID    => $Self->{UserID},
                );
                my %Preferences = ();
                if ( $ConfigObject->Get('ServicePreferences') ) {
                    %Preferences = %{ $ConfigObject->Get('ServicePreferences') };
                }
                for my $Item ( sort keys %Preferences ) {
                    my $Module = $Preferences{$Item}->{Module}
                        || 'Kernel::Output::HTML::ServicePreferences::Generic';

                    # load module
                    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($Module) ) {
                        return $LayoutObject->FatalError();
                    }

                    my $Object = $Module->new(
                        %{$Self},
                        ConfigItem => $Preferences{$Item},
                        Debug      => $Self->{Debug},
                    );
                    my $Note;
                    my @Params = $Object->Param( ServiceData => \%ServiceData );
                    if (@Params) {
                        my %GetParam = ();
                        for my $ParamItem (@Params) {
                            my @Array = $ParamObject->GetArray( Param => $ParamItem->{Name} );
                            $GetParam{ $ParamItem->{Name} } = \@Array;
                        }
                        if (
                            !$Object->Run(
                                GetParam    => \%GetParam,
                                ServiceData => \%ServiceData
                            )
                            )
                        {
                            $Note .= $LayoutObject->Notify( Info => $Object->Error() );
                        }
                    }
                }

                # redirect to overview
                return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
            }
        }

        # something went wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Error{Message}
            ? $LayoutObject->Notify(
            Priority => 'Error',
            Info     => $Error{Message},
            )
            : '';

        # html output
        $Output .= $Self->_MaskNew(
            %Error,
            %GetParam,
            %Param,
        );
        $Output .= $LayoutObject->Footer();

    }

    # ------------------------------------------------------------ #
    # service overview
    # ------------------------------------------------------------ #
    else {

        # output header
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        # check if service is enabled to use it here
        if ( !$ConfigObject->Get('Ticket::Service') ) {
            $Output .= $LayoutObject->Notify(
                Priority => 'Error',
                Data     => $LayoutObject->{LanguageObject}->Translate( "Please activate %s first!", "Service" ),
                Link =>
                    $LayoutObject->{Baselink}
                    . 'Action=AdminSysConfig;Subaction=Edit;SysConfigGroup=Ticket;SysConfigSubGroup=Core::Ticket#Ticket::Service',
            );
        }

        # output overview
        $LayoutObject->Block(
            Name => 'Overview',
            Data => { %Param, },
        );

        $LayoutObject->Block( Name => 'ActionList' );
        $LayoutObject->Block( Name => 'ActionAdd' );

        # output overview result
        $LayoutObject->Block(
            Name => 'OverviewList',
            Data => { %Param, },
        );

        # get service list
        my $ServiceList = $ServiceObject->ServiceListGet(
            Valid  => 0,
            UserID => $Self->{UserID},
        );

        # if there are any services defined, they are shown
        if ( @{$ServiceList} ) {

            # get valid list
            my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

            # sort the service list by long service name
            @{$ServiceList} = sort { $a->{Name} . '::' cmp $b->{Name} . '::' } @{$ServiceList};

            for my $ServiceData ( @{$ServiceList} ) {

                # output row
                $LayoutObject->Block(
                    Name => 'OverviewListRow',
                    Data => {
                        %{$ServiceData},
                        Valid => $ValidList{ $ServiceData->{ValidID} },
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

        # generate output
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminService',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }
}

sub _MaskNew {
    my ( $Self, %Param ) = @_;

    my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');
    my %ServiceData;

    # get params
    $ServiceData{ServiceID} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => "ServiceID" );
    if ( $ServiceData{ServiceID} ne 'NEW' ) {
        %ServiceData = $ServiceObject->ServiceGet(
            ServiceID => $ServiceData{ServiceID},
            UserID    => $Self->{UserID},
        );
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # output overview
    $LayoutObject->Block(
        Name => 'Overview',
        Data => { %Param, },
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get list type
    my $ListType = $ConfigObject->Get('Ticket::Frontend::ListType');

    # generate ParentOptionStrg
    my %ServiceList = $ServiceObject->ServiceList(
        Valid  => 0,
        UserID => $Self->{UserID},
    );
    $ServiceData{ParentOptionStrg} = $LayoutObject->BuildSelection(
        Data           => \%ServiceList,
        Name           => 'ParentID',
        SelectedID     => $Param{ParentID} || $ServiceData{ParentID},
        PossibleNone   => 1,
        TreeView       => ( $ListType eq 'tree' ) ? 1 : 0,
        DisabledBranch => $ServiceData{Name},
        Translation    => 0,
        Class          => 'Modernize',
    );

    # get valid list
    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $ServiceData{ValidOptionStrg} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $ServiceData{ValidID} || $ValidListReverse{valid},
        Class      => 'Modernize',
    );

    # output service edit
    $LayoutObject->Block(
        Name => 'ServiceEdit',
        Data => { %Param, %ServiceData, },
    );

    # shows header
    if ( $ServiceData{ServiceID} ne 'NEW' ) {
        $LayoutObject->Block(
            Name => 'HeaderEdit',
            Data => {%ServiceData},
        );
    }
    else {
        $LayoutObject->Block( Name => 'HeaderAdd' );
    }

    # show each preferences setting
    my %Preferences = ();
    if ( $ConfigObject->Get('ServicePreferences') ) {
        %Preferences = %{ $ConfigObject->Get('ServicePreferences') };
    }
    for my $Item ( sort keys %Preferences ) {
        my $Module = $Preferences{$Item}->{Module}
            || 'Kernel::Output::HTML::ServicePreferences::Generic';

        # load module
        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($Module) ) {
            return $LayoutObject->FatalError();
        }
        my $Object = $Module->new(
            %{$Self},
            ConfigItem => $Preferences{$Item},
            Debug      => $Self->{Debug},
        );
        my @Params = $Object->Param( ServiceData => \%ServiceData );
        if (@Params) {
            for my $ParamItem (@Params) {
                $LayoutObject->Block(
                    Name => 'Item',
                    Data => { %Param, },
                );
                if (
                    ref( $ParamItem->{Data} ) eq 'HASH'
                    || ref( $Preferences{$Item}->{Data} ) eq 'HASH'
                    )
                {
                    my %BuildSelectionParams = (
                        %{ $Preferences{$Item} },
                        %{$ParamItem},
                    );
                    $BuildSelectionParams{Class} = join( ' ', $BuildSelectionParams{Class} // '', 'Modernize' );

                    $ParamItem->{'Option'} = $LayoutObject->BuildSelection(
                        %BuildSelectionParams,
                    );
                }
                $LayoutObject->Block(
                    Name => $ParamItem->{Block} || $Preferences{$Item}->{Block} || 'Option',
                    Data => {
                        %{ $Preferences{$Item} },
                        %{$ParamItem},
                    },
                );
            }
        }
    }

    # generate output
    return $LayoutObject->Output(
        TemplateFile => 'AdminService',
        Data         => \%Param
    );
}

1;
