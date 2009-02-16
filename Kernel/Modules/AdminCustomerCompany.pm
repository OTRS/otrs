# --
# Kernel/Modules/AdminCustomerCompany.pm - to add/update/delete system addresses
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AdminCustomerCompany.pm,v 1.7 2009-02-16 11:20:52 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminCustomerCompany;

use strict;
use warnings;

use Kernel::System::CustomerCompany;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }
    $Self->{CustomerCompanyObject} = Kernel::System::CustomerCompany->new(%Param);
    $Self->{ValidObject}           = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $CustomerID = $Self->{ParamObject}->GetParam( Param => 'CustomerID' ) || '';
        my %Data = $Self->{CustomerCompanyObject}->CustomerCompanyGet( CustomerID => $CustomerID, );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => "Change",
            %Data,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminCustomerCompanyForm',
            Data         => \%Param,
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
        for my $Entry ( @{ $Self->{ConfigObject}->Get('CustomerCompany')->{Map} } ) {
            $GetParam{ $Entry->[0] } = $Self->{ParamObject}->GetParam( Param => $Entry->[0] ) || '';
        }
        for (qw(CustomerID)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }

        # update group
        if (
            $Self->{CustomerCompanyObject}->CustomerCompanyUpdate(
                %GetParam, UserID => $Self->{UserID}
            )
            )
        {
            $Self->_Overview();
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify( Info => 'Updated!' );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminCustomerCompanyForm',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
            $Self->_Edit(
                Action => "Change",
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminCustomerCompanyForm',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam = ();
        for (qw(Name)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => "Add",
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminCustomerCompanyForm',
            Data         => \%Param,
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
        for my $Entry ( @{ $Self->{ConfigObject}->Get('CustomerCompany')->{Map} } ) {
            $GetParam{ $Entry->[0] } = $Self->{ParamObject}->GetParam( Param => $Entry->[0] ) || '';
        }

        # add user
        if (
            my $AddressID
            = $Self->{CustomerCompanyObject}->CustomerCompanyAdd(
                %GetParam, UserID => $Self->{UserID}
            )
            )
        {
            $Self->_Overview();
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify( Info => 'Added!' );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminCustomerCompanyForm',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
            $Self->_Edit(
                Action => "Add",
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminCustomerCompanyForm',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview();
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminCustomerCompanyForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

}

sub _Edit {
    my ( $Self, %Param ) = @_;
    my $Search = $Self->{ParamObject}->GetParam( Param => 'Search' ) || '';

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => {
            %Param,
            Search => $Search,
        },
    );
    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
            Search => $Search,
        },
    );
    $Param{'ValidOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => { $Self->{ValidObject}->ValidList(), },
        Name       => 'ValidID',
        SelectedID => $Param{ValidID},
    );
    $Param{'QueueOption'} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => {
            $Self->{DBObject}->GetTableData(
                What  => 'id, name',
                Table => 'queue',
                Valid => 1,
                )
        },
        Name           => 'QueueID',
        SelectedID     => $Param{QueueID},
        OnChangeSubmit => 0,
    );
    for my $Entry ( @{ $Self->{ConfigObject}->Get('CustomerCompany')->{Map} } ) {
        if ( $Entry->[0] ) {
            my $Block = 'Input';

            # build selections or input fields
            if ( $Self->{ConfigObject}->Get('CustomerCompany')->{Selections}->{ $Entry->[0] } ) {

                # build ValidID string
                $Block = 'Option';
                $Param{Option} = $Self->{LayoutObject}->OptionStrgHashRef(
                    Data => $Self->{ConfigObject}->Get('CustomerCompany')->{Selections}
                        ->{ $Entry->[0] },
                    Name                => $Entry->[0],
                    LanguageTranslation => 0,
                    SelectedID          => $Param{ $Entry->[0] },
                    Max                 => 35,
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
                        %Param,
                        Item  => $Entry->[1],
                        Name  => $Entry->[0],
                        Value => $Param{ $Entry->[0] },
                    },
                );
            }
        }
    }
    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;
    my $Search = $Self->{ParamObject}->GetParam( Param => 'Search' ) || '';
    my $Output = '';

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => {
            %Param,
            Search => $Search,
        },
    );
    $Self->{LayoutObject}->Block(
        Name => 'OverviewResult',
        Data => {
            %Param,
            Search => $Search,
        },
    );
    my %List = ();
    if ($Search) {
        %List = $Self->{CustomerCompanyObject}->CustomerCompanyList(
            Search => $Search,
            Valid  => 0,
        );
    }

    # get valid list
    my %ValidList = $Self->{ValidObject}->ValidList();
    my $CssClass  = '';
    for ( sort { $List{$a} cmp $List{$b} } keys %List ) {

        # set output class
        if ( $CssClass && $CssClass eq 'searchactive' ) {
            $CssClass = 'searchpassive';
        }
        else {
            $CssClass = 'searchactive';
        }
        my %Data = $Self->{CustomerCompanyObject}->CustomerCompanyGet( CustomerID => $_, );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewResultRow',
            Data => {
                Valid    => $ValidList{ $Data{ValidID} },
                CssClass => $CssClass,
                %Data,
                Search => $Search,
            },
        );
    }
    return 1;
}

1;
