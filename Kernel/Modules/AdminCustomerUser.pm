# --
# Kernel/Modules/AdminCustomerUser.pm - to add/update/delete customer user and preferences
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AdminCustomerUser.pm,v 1.54 2008-05-15 09:36:39 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AdminCustomerUser;

use strict;
use warnings;

use Kernel::System::CustomerUser;
use Kernel::System::CustomerCompany;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.54 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject LayoutObject ConfigObject LogObject UserObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }
    $Self->{CustomerUserObject}    = Kernel::System::CustomerUser->new(%Param);
    $Self->{CustomerCompanyObject} = Kernel::System::CustomerCompany->new(%Param);
    $Self->{ValidObject}           = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $NavBar = '';
    my $Nav    = $Self->{ParamObject}->GetParam( Param => 'Nav' ) || 0;
    my $Source = $Self->{ParamObject}->GetParam( Param => 'Source' ) || 'CustomerUser';
    my $Search = $Self->{ParamObject}->GetParam( Param => 'Search' );
    my $Screen = $Self->{ParamObject}->GetParam( Param => 'Screen' ) || '';
    if ( $Screen eq 'Remember' && $Self->{LastScreenEdit} ) {
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'CustomerEditReturn',
            Value     => $Self->{LastScreenEdit},
        );
        $Self->{LayoutObject}->SetEnv(
            Key   => 'CustomerEditReturn',
            Value => $Self->{LastScreenEdit},
        );
    }
    elsif ( $Screen eq 'Return' ) {

        # redirect
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'CustomerEditReturn',
            Value     => '',
        );
        return $Self->{LayoutObject}->Redirect( OP => $Self->{CustomerEditReturn}, );
    }

    # check nav bar
    if ( !$Nav ) {
        if ( $ENV{HTTP_REFERER} && $ENV{HTTP_REFERER} !~ /Admin/ ) {
            $Nav = 'Agent';
        }
        else {
            $Nav = 'Admin';
        }
    }
    if ( $Nav eq 'Admin' ) {
        $NavBar = $Self->{LayoutObject}->Header();
        $NavBar .= $Self->{LayoutObject}->NavigationBar();
    }
    elsif ( $Nav eq 'None' ) {
        $NavBar = $Self->{LayoutObject}->Header( Type => 'Small' );
    }
    else {
        $NavBar = $Self->{LayoutObject}->Header();
        $NavBar .= $Self->{LayoutObject}->NavigationBar( Type => $Self->{LastNavBarName} );
    }

    # search user list
    if ( $Self->{Subaction} eq 'Search' ) {
        $Self->_Overview(
            Nav    => $Nav,
            Search => $Search,
        );
        my $Output = $NavBar;
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminCustomerUserForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # download file preferences
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Download' ) {
        my $Group = $Self->{ParamObject}->GetParam( Param => 'Group' ) || '';
        my $User  = $Self->{ParamObject}->GetParam( Param => 'ID' )    || '';
        my $File  = $Self->{ParamObject}->GetParam( Param => 'File' )  || '';

        # get user data
        my %UserData    = $Self->{CustomerUserObject}->CustomerUserDataGet( User => $User );
        my %Preferences = %{ $Self->{ConfigObject}->Get('CustomerPreferencesGroups') };
        my $Module      = $Preferences{$Group}->{Module};
        if ( $Self->{MainObject}->Require($Module) ) {
            my $Object = $Module->new(
                %{$Self},
                ConfigItem => $Preferences{$Group},
                UserObject => $Self->{CustomerUserObject},
                Debug      => $Self->{Debug},
            );
            my %File = $Object->Download( UserData => \%UserData );

            return $Self->{LayoutObject}->Attachment(%File);
        }
        else {
            return $Self->{LayoutObject}->FatalError();
        }
    }

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Change' ) {
        my $User = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';

        # get user data
        my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet( User => $User );
        my $Output = $NavBar
            . $Self->_Edit(
            Nav    => $Nav,
            Action => "Change",
            Source => $Source,
            Nav    => $Nav,
            Search => $Search,
            ID     => $User,
            %UserData,
            );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {
        my $Note = '';
        my %GetParam;
        for my $Entry ( @{ $Self->{ConfigObject}->Get($Source)->{Map} } ) {
            $GetParam{ $Entry->[0] } = $Self->{ParamObject}->GetParam( Param => $Entry->[0] ) || '';
        }
        for (qw(ID)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }

        # update user
        if (
            $Self->{CustomerUserObject}->CustomerUserUpdate( %GetParam, UserID => $Self->{UserID} )
            )
        {

            # update preferences
            my %Preferences = %{ $Self->{ConfigObject}->Get('CustomerPreferencesGroups') };
            for my $Group ( keys %Preferences ) {
                if ( $Group eq 'Password' ) {
                    next;
                }

                # get user data
                my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $GetParam{UserLogin}
                );
                my $Module = $Preferences{$Group}->{Module};
                if ( $Self->{MainObject}->Require($Module) ) {
                    my $Object = $Module->new(
                        %{$Self},
                        ConfigItem => $Preferences{$Group},
                        UserObject => $Self->{CustomerUserObject},
                        Debug      => $Self->{Debug},
                    );
                    my @Params = $Object->Param( UserData => \%UserData );
                    if (@Params) {
                        my %GetParam = ();
                        for my $ParamItem (@Params) {
                            my @Array
                                = $Self->{ParamObject}->GetArray( Param => $ParamItem->{Name} );
                            $GetParam{ $ParamItem->{Name} } = \@Array;
                        }
                        if ( !$Object->Run( GetParam => \%GetParam, UserData => \%UserData ) ) {
                            $Note .= $Self->{LayoutObject}->Notify( Info => $Object->Error() );
                        }
                    }
                }
                else {
                    return $Self->{LayoutObject}->FatalError();
                }
            }

            # get user data and show screen again
            if ( !$Note ) {
                $Self->_Overview(
                    Nav    => $Nav,
                    Search => $Search,
                );
                my $Output = $NavBar . $Note;
                $Output .= $Self->{LayoutObject}->Notify( Info => 'Customer updated!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminCustomerUserForm',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }

        # something has gone wrong
        my $Output = $NavBar;
        $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
        $Output .= $Note;
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => "Change",
            Nav    => $Nav,
            Source => $Source,
            Search => $Search,
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam;
        for (qw(UserLogin)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }
        my $Output = $NavBar
            . $Self->_Edit(
            Nav    => $Nav,
            Action => "Add",
            Source => $Source,
            Search => $Search,
            %GetParam,
            );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {
        my $Note = '';
        my %GetParam;
        for my $Entry ( @{ $Self->{ConfigObject}->Get($Source)->{Map} } ) {
            $GetParam{ $Entry->[0] } = $Self->{ParamObject}->GetParam( Param => $Entry->[0] ) || '';
        }

        # add user
        if (
            my $User
            = $Self->{CustomerUserObject}->CustomerUserAdd(
                %GetParam,
                UserID => $Self->{UserID},
                Source => $Source
            )
            )
        {

            # update preferences
            my %Preferences = %{ $Self->{ConfigObject}->Get('CustomerPreferencesGroups') };
            for my $Group ( keys %Preferences ) {
                if ( $Group eq 'Password' ) {
                    next;
                }

                # get user data
                my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $GetParam{UserLogin}
                );
                my $Module = $Preferences{$Group}->{Module};
                if ( $Self->{MainObject}->Require($Module) ) {
                    my $Object = $Module->new(
                        %{$Self},
                        ConfigItem => $Preferences{$Group},
                        UserObject => $Self->{CustomerUserObject},
                        Debug      => $Self->{Debug},
                    );
                    my @Params
                        = $Object->Param( %{ $Preferences{$Group} }, UserData => \%UserData );
                    if (@Params) {
                        my %GetParam = ();
                        for my $ParamItem (@Params) {
                            my @Array
                                = $Self->{ParamObject}->GetArray( Param => $ParamItem->{Name} );
                            $GetParam{ $ParamItem->{Name} } = \@Array;
                        }
                        if ( !$Object->Run( GetParam => \%GetParam, UserData => \%UserData ) ) {
                            $Note .= $Self->{LayoutObject}->Notify( Info => $Object->Error() );
                        }
                    }
                }
                else {
                    return $Self->{LayoutObject}->FatalError();
                }
            }

            # get user data and show screen again
            if ( !$Note ) {
                $Self->_Overview(
                    Nav    => $Nav,
                    Search => $Search,
                );
                my $Output  = $NavBar . $Note;
                my $OnClick = '';
                if ( $Nav eq 'None' ) {
                    $OnClick = " onclick=\"updateMessage('$User')\"";
                }
                my $URL = '';
                if ( $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketPhone} ) {
                    $URL
                        .= "<a href=\"\$Env{\"CGIHandle\"}?Action=AgentTicketPhone&Subaction=StoreNew&ExpandCustomerName=2&CustomerUser=$User\"$OnClick>"
                        . $Self->{LayoutObject}->{LanguageObject}->Get('PhoneView') . "</a>";
                }
                if ( $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketEmail} ) {
                    if ($URL) {
                        $URL .= " - ";
                    }
                    $URL
                        .= "<a href=\"\$Env{\"CGIHandle\"}?Action=AgentTicketEmail&Subaction=StoreNew&ExpandCustomerName=2&CustomerUser=$User\"$OnClick>"
                        . $Self->{LayoutObject}->{LanguageObject}->Get('Compose Email') . "</a>";
                }
                if ($URL) {
                    $Output
                        .= $Self->{LayoutObject}->Notify(
                        Data => $Self->{LayoutObject}->{LanguageObject}->Get(
                            'Added User "%s"", "' . $User
                            )
                            . " ( $URL )!",
                        );
                }
                else {
                    $Output
                        .= $Self->{LayoutObject}->Notify(
                        Data => $Self->{LayoutObject}->{LanguageObject}->Get(
                            'Added User "%s"", "' . $User
                            )
                            . "!",
                        );
                }
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminCustomerUserForm',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }

        # something has gone wrong
        my $Output = $NavBar;
        $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
        $Output .= $Note;
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => "Add",
            Nav    => $Nav,
            Source => $Source,
            Search => $Search,
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {
        $Self->_Overview(
            Nav    => $Nav,
            Search => $Search,
        );
        my $Output = $NavBar;
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminCustomerUserForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $Output = '';

    # build source string
    $Param{'SourceOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => { $Self->{CustomerUserObject}->CustomerSourceList() },
        Name       => 'Source',
        SelectedID => $Param{Source} || '',
    );
    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );
    $Self->{LayoutObject}->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );
    if ( $Param{Search} ) {
        my %List = $Self->{CustomerUserObject}->CustomerSearch(
            Search => $Param{Search},
            Valid  => 0,
        );
        if (%List) {

            # get valid list
            my %ValidList = $Self->{ValidObject}->ValidList();
            my $CssClass  = '';
            for ( sort keys %List ) {

                # set output class
                if ( $CssClass && $CssClass eq 'searchactive' ) {
                    $CssClass = 'searchpassive';
                }
                else {
                    $CssClass = 'searchactive';
                }
                my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet( User => $_ );
                $Self->{LayoutObject}->Block(
                    Name => 'OverviewResultRow',
                    Data => {
                        Valid => $ValidList{ $UserData{ValidID} || '' } || '-',
                        CssClass => $CssClass,
                        Search   => $Param{Search},
                        %UserData,
                    },
                );
                if ( $Param{Nav} eq 'None' ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewResultRowLinkNone',
                        Data => {
                            CssClass => $CssClass,
                            Search   => $Param{Search},
                            %UserData,
                        },
                    );
                }
                else {
                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewResultRowLink',
                        Data => {
                            CssClass => $CssClass,
                            Search   => $Param{Search},
                            %UserData,
                        },
                    );
                }
            }
        }
    }
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    my $Output = '';

    # build source string
    $Param{'CompanyOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => { $Self->{CustomerCompanyObject}->CustomerCompanyList() },
        Name       => 'CustomerID',
        SelectedID => $Param{CustomerID},
    );

    # build source string
    $Param{'SourceOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => { $Self->{CustomerUserObject}->CustomerSourceList() },
        Name       => 'Source',
        SelectedID => $Param{Source},
    );
    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );
    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
    );
    for my $Entry ( @{ $Self->{ConfigObject}->Get( $Param{Source} )->{Map} } ) {
        if ( $Entry->[0] ) {
            my $Block = 'Input';

            # check input type
            if ( $Entry->[0] =~ /^UserPasswor/i ) {
                $Block = 'Password';
            }

            # check if login auto creation
            if (
                $Self->{ConfigObject}->Get( $Param{Source} )->{AutoLoginCreation}
                && $Entry->[0] =~ /^UserLogin$/
                )
            {
                $Block = 'InputHidden';
            }
            if ( $Entry->[7] ) {
                $Param{ReadOnlyType} = 'readonly';
                $Param{ReadOnly}     = '*';
            }
            else {
                $Param{ReadOnlyType} = '';
                $Param{ReadOnly}     = '';
            }

            # build selections or input fields
            if ( $Self->{ConfigObject}->Get( $Param{Source} )->{Selections}->{ $Entry->[0] } ) {
                $Block = 'Option';
                $Param{Option} = $Self->{LayoutObject}->OptionStrgHashRef(
                    Data =>
                        $Self->{ConfigObject}->Get( $Param{Source} )->{Selections}->{ $Entry->[0] },
                    Name                => $Entry->[0],
                    LanguageTranslation => 0,
                    SelectedID          => $Param{ $Entry->[0] },
                );

            }
            elsif ( $Entry->[0] =~ /^ValidID/i ) {

                # build ValidID string
                $Block = 'Option';
                $Param{Option} = $Self->{LayoutObject}->OptionStrgHashRef(
                    Data       => { $Self->{ValidObject}->ValidList(), },
                    Name       => $Entry->[0],
                    SelectedID => defined( $Param{ $Entry->[0] } ) ? $Param{ $Entry->[0] } : 1,
                );
            }
            elsif (
                $Entry->[0] =~ /^UserCustomerID$/i
                && $Self->{ConfigObject}->Get( $Param{Source} )->{CustomerCompanySupport}
                )
            {
                my %Company = ();
                my %CompanyList = (
                    $Self->{CustomerCompanyObject}->CustomerCompanyList(),
                    '' => '-',
                );
                if ( $Param{ $Entry->[0] } ) {
                    %Company = $Self->{CustomerCompanyObject}->CustomerCompanyGet(
                        CustomerID => $Param{ $Entry->[0] },
                    );
                    if ( !%Company ) {
                        $CompanyList{ $Param{ $Entry->[0] } } = $Param{ $Entry->[0] } . ' (-)';
                    }
                }
                $Block = 'Option';
                $Param{Option} = $Self->{LayoutObject}->OptionStrgHashRef(
                    Data       => \%CompanyList,
                    Name       => $Entry->[0],
                    Max        => 80,
                    SelectedID => $Param{ $Entry->[0] },
                );
            }
            else {
                $Param{Value} = $Param{ $Entry->[0] } || '';
            }

            # show required flag
            if ( $Entry->[4] ) {
                $Param{Required} = '*';
            }
            else {
                $Param{Required} = '';
            }

            # add form option
            if ( $Param{Type} && $Param{Type} eq 'hidden' ) {
                $Param{Preferences} .= $Param{Value};
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'PreferencesGeneric',
                    Data => { Item => $Entry->[1], %Param },
                );
                $Self->{LayoutObject}->Block(
                    Name => "PreferencesGeneric$Block",
                    Data => {
                        Item => $Entry->[1],
                        Name => $Entry->[0],
                        %Param,
                    },
                );
            }
        }
    }
    my $PreferencesUsed = $Self->{ConfigObject}->Get( $Param{Source} )->{AdminSetPreferences};
    if ( ( defined($PreferencesUsed) && $PreferencesUsed != 0 ) || !defined($PreferencesUsed) ) {
        my @Groups = @{ $Self->{ConfigObject}->Get('CustomerPreferencesView') };
        for my $Colum (@Groups) {
            my %Data        = ();
            my %Preferences = %{ $Self->{ConfigObject}->Get('CustomerPreferencesGroups') };
            for my $Group ( keys %Preferences ) {
                if ( $Preferences{$Group}->{Colum} eq $Colum ) {
                    if ( $Data{ $Preferences{$Group}->{Prio} } ) {
                        for ( 1 .. 151 ) {
                            $Preferences{$Group}->{Prio}++;
                            if ( !$Data{ $Preferences{$Group}->{Prio} } ) {
                                $Data{ $Preferences{$Group}->{Prio} } = $Group;
                                last;
                            }
                        }
                    }
                    $Data{ $Preferences{$Group}->{Prio} } = $Group;
                }
            }

            # sort
            for my $Key ( keys %Data ) {
                $Data{ sprintf( "%07d", $Key ) } = $Data{$Key};
                delete $Data{$Key};
            }

            # show each preferences setting
            for my $Prio ( sort keys %Data ) {
                my $Group = $Data{$Prio};
                if ( !$Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group} ) {
                    next;
                }
                my %Preference = %{ $Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group} };
                if ( $Group eq 'Password' ) {
                    next;
                }
                my $Module = $Preference{Module}
                    || 'Kernel::Output::HTML::CustomerPreferencesGeneric';

                # load module
                if ( $Self->{MainObject}->Require($Module) ) {
                    my $Object = $Module->new(
                        %{$Self},
                        ConfigItem => \%Preference,
                        UserObject => $Self->{CustomerUserObject},
                        Debug      => $Self->{Debug},
                    );
                    my @Params = $Object->Param( UserData => \%Param );
                    if (@Params) {
                        for my $ParamItem (@Params) {
                            $Self->{LayoutObject}->Block(
                                Name => 'Item',
                                Data => {%Param},
                            );
                            if (
                                ref( $ParamItem->{Data} )   eq 'HASH'
                                || ref( $Preference{Data} ) eq 'HASH'
                                )
                            {
                                $ParamItem->{'Option'} = $Self->{LayoutObject}->OptionStrgHashRef(
                                    %Preference, %{$ParamItem},
                                );
                            }
                            $Self->{LayoutObject}->Block(
                                Name => $ParamItem->{Block} || $Preference{Block} || 'Option',
                                Data => {
                                    Group => $Group,
                                    %Param,
                                    %Data,
                                    %Preference,
                                    %{$ParamItem},
                                },
                            );
                        }
                    }
                }
                else {
                    return $Self->{LayoutObject}->FatalError();
                }
            }
        }

    }
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminCustomerUserForm',
        Data         => \%Param
    );
}

1;
