# --
# Kernel/Modules/AdminCustomerCompany.pm - to add/update/delete customer companies
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminCustomerCompany;

use strict;
use warnings;

use Kernel::System::CustomerCompany;
use Kernel::System::ReferenceData;
use Kernel::System::Valid;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Needed (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }
    $Self->{CustomerCompanyObject} = Kernel::System::CustomerCompany->new(%Param);
    $Self->{ReferenceDataObject}   = Kernel::System::ReferenceData->new(%Param);
    $Self->{ValidObject}           = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Nav = $Self->{ParamObject}->GetParam( Param => 'Nav' ) || 0;
    my $NavigationBarType = $Nav eq 'Agent' ? 'Companies' : 'Admin';

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $CustomerID = $Self->{ParamObject}->GetParam( Param => 'CustomerID' ) || '';
        my %Data = $Self->{CustomerCompanyObject}->CustomerCompanyGet( CustomerID => $CustomerID, );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar(
            Type => $NavigationBarType,
        );
        $Self->_Edit(
            Action => 'Change',
            Nav    => $Nav,
            %Data,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminCustomerCompany',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );

        $GetParam{CustomerCompanyID} = $Self->{ParamObject}->GetParam(
            Param => 'CustomerCompanyID'
        );

        for my $Entry ( @{ $Self->{ConfigObject}->Get('CustomerCompany')->{Map} } ) {
            $GetParam{ $Entry->[0] } = $Self->{ParamObject}->GetParam( Param => $Entry->[0] ) || '';

            # check mandatory fields
            if ( !$GetParam{ $Entry->[0] } && $Entry->[4] ) {
                $Errors{ $Entry->[0] . 'Invalid' } = 'ServerError';
            }
        }

        if ( !defined $GetParam{CustomerID} ) {
            $GetParam{CustomerID} = $Self->{ParamObject}->GetParam( Param => 'CustomerID' ) || '';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # update group
            if (
                $Self->{CustomerCompanyObject}->CustomerCompanyUpdate(
                    %GetParam,
                    UserID => $Self->{UserID},
                )
                )
            {
                $Self->_Overview(
                    Nav => $Nav,
                );
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar(
                    Type => $NavigationBarType,
                );
                $Output .= $Self->{LayoutObject}->Notify( Info => 'Customer company updated!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminCustomerCompany',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }

        # something went wrong
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar(
            Type => $NavigationBarType,
        );
        $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
        $Self->_Edit(
            Action => 'Change',
            Nav    => $Nav,
            Errors => \%Errors,
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminCustomerCompany',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam = ();
        $GetParam{Name} = $Self->{ParamObject}->GetParam( Param => 'Name' );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar(
            Type => $NavigationBarType,
        );
        $Self->_Edit(
            Action => 'Add',
            Nav    => $Nav,
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminCustomerCompany',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );
        for my $Entry ( @{ $Self->{ConfigObject}->Get('CustomerCompany')->{Map} } ) {
            $GetParam{ $Entry->[0] } = $Self->{ParamObject}->GetParam( Param => $Entry->[0] ) || '';

            # check mandatory fields
            if ( !$GetParam{ $Entry->[0] } && $Entry->[4] ) {
                $Errors{ $Entry->[0] . 'Invalid' } = 'ServerError';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add company
            if (
                $Self->{CustomerCompanyObject}->CustomerCompanyAdd(
                    %GetParam,
                    UserID => $Self->{UserID},
                )
                )
            {
                $Self->_Overview(
                    Nav => $Nav,
                );
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar(
                    Type => $NavigationBarType,
                );
                $Output .= $Self->{LayoutObject}->Notify( Info => 'Customer company added!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminCustomerCompany',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }

        # something went wrong
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar(
            Type => $NavigationBarType,
        );
        $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
        $Self->_Edit(
            Action => 'Add',
            Nav    => $Nav,
            Errors => \%Errors,
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminCustomerCompany',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview(
            Nav => $Nav,
        );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar(
            Type => $NavigationBarType,
        );

        if ( !$Self->{ConfigObject}->Get('CustomerCompany')->{Params}->{ForeignDB} ) {
            $Self->{LayoutObject}->Block( Name => 'LocalDB' );
        }

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminCustomerCompany',
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

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
            Search => $Search,
        },
    );

    # shows header
    if ( $Param{Action} eq 'Change' ) {
        $Self->{LayoutObject}->Block( Name => 'HeaderEdit' );
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'HeaderAdd' );
    }

    $Param{'ValidOption'} = $Self->{LayoutObject}->BuildSelection(
        Data       => { $Self->{ValidObject}->ValidList(), },
        Name       => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    for my $Entry ( @{ $Self->{ConfigObject}->Get('CustomerCompany')->{Map} } ) {
        if ( $Entry->[0] ) {
            my $Block = 'Input';

            # build selections or input fields
            if ( $Self->{ConfigObject}->Get('CustomerCompany')->{Selections}->{ $Entry->[0] } ) {
                my $OptionRequired = '';
                if ( $Entry->[4] ) {
                    $OptionRequired = 'Validate_Required';
                }

                # build ValidID string
                $Block = 'Option';
                $Param{Option} = $Self->{LayoutObject}->BuildSelection(
                    Data =>
                        $Self->{ConfigObject}->Get('CustomerCompany')->{Selections}
                        ->{ $Entry->[0] },
                    Name  => $Entry->[0],
                    Class => $OptionRequired . ' ' .
                        ( $Param{Errors}->{ $Entry->[0] . 'Invalid' } || '' ),
                    Translation => 0,
                    SelectedID  => $Param{ $Entry->[0] },
                    Max         => 35,
                );

            }
            elsif ( $Entry->[0] =~ /^CustomerCompanyCountry/i ) {
                my $OptionRequired = '';
                if ( $Entry->[4] ) {
                    $OptionRequired = 'Validate_Required';
                }

                # build Country string
                my $CountryList = $Self->{ReferenceDataObject}->CountryList();

                $Block = 'Option';
                $Param{Option} = $Self->{LayoutObject}->BuildSelection(
                    Data         => $CountryList,
                    PossibleNone => 1,
                    Sort         => 'AlphanumericValue',
                    Name         => $Entry->[0],
                    Class        => $OptionRequired . ' ' .
                        ( $Param{Errors}->{ $Entry->[0] . 'Invalid' } || '' ),
                    SelectedID => defined( $Param{ $Entry->[0] } ) ? $Param{ $Entry->[0] } : 1,
                );
            }
            elsif ( $Entry->[0] =~ /^ValidID/i ) {
                my $OptionRequired = '';
                if ( $Entry->[4] ) {
                    $OptionRequired = 'Validate_Required';
                }

                # build ValidID string
                $Block = 'Option';
                $Param{Option} = $Self->{LayoutObject}->BuildSelection(
                    Data  => { $Self->{ValidObject}->ValidList(), },
                    Name  => $Entry->[0],
                    Class => $OptionRequired . ' ' .
                        ( $Param{Errors}->{ $Entry->[0] . 'Invalid' } || '' ),
                    SelectedID => defined( $Param{ $Entry->[0] } ) ? $Param{ $Entry->[0] } : 1,
                );
            }
            else {
                $Param{Value} = $Param{ $Entry->[0] } || '';
            }

            # show required flag
            if ( $Entry->[4] ) {
                $Param{MandatoryClass} = 'class="Mandatory"';
                $Param{StarLabel}      = '<span class="Marker">*</span>';
                $Param{RequiredClass}  = 'Validate_Required';
            }
            else {
                $Param{MandatoryClass} = '';
                $Param{StarLabel}      = '';
                $Param{RequiredClass}  = '';
            }

            # show required flag
            if ( $Entry->[7] ) {
                $Param{ReadOnlyType} = 'readonly="readonly"';
            }
            else {
                $Param{ReadOnlyType} = '';
            }

            # add form option
            if ( $Param{Type} && $Param{Type} eq 'hidden' ) {
                $Param{Preferences} .= $Param{Value};
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'PreferencesGeneric',
                    Data => {
                        Item => $Entry->[1],
                        %Param
                    },
                );
                $Self->{LayoutObject}->Block(
                    Name => "PreferencesGeneric$Block",
                    Data => {
                        %Param,
                        Item         => $Entry->[1],
                        Name         => $Entry->[0],
                        Value        => $Param{ $Entry->[0] },
                        InvalidField => $Param{Errors}->{ $Entry->[0] . 'Invalid' } || '',
                    },
                );
                if ( $Entry->[4] ) {
                    $Self->{LayoutObject}->Block(
                        Name => "PreferencesGeneric${Block}Required",
                        Data => {
                            Name => $Entry->[0],
                        },
                    );
                }
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

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block(
        Name => 'ActionSearch',
        Data => {
            Nav => $Param{Nav},
            }
    );

    # get writable data sources
    my %CustomerCompanySource = $Self->{CustomerCompanyObject}->CustomerCompanySourceList(
        ReadOnly => 0,
    );

    # only show Add option if we have at least one writable backend
    if ( scalar keys %CustomerCompanySource ) {
        $Param{SourceOption} = $Self->{LayoutObject}->BuildSelection(
            Data       => { %CustomerCompanySource, },
            Name       => 'Source',
            SelectedID => $Param{Source} || '',
        );

        $Self->{LayoutObject}->Block(
            Name => 'ActionAdd',
            Data => \%Param,
        );
    }

    $Self->{LayoutObject}->Block(
        Name => 'OverviewHeader',
        Data => {},
    );

    my %List = ();

    # if there are any registries to search, the table is filled and shown
    if ($Search) {
        $Self->{LayoutObject}->Block(
            Name => 'OverviewResult',
            Data => {
                %Param,
                Search => $Search,
            },
        );
        %List = $Self->{CustomerCompanyObject}->CustomerCompanyList(
            Search => $Search,
            Valid  => 0,
        );

        # get valid list
        my %ValidList = $Self->{ValidObject}->ValidList();

        # if there are results to show
        if (%List) {
            for my $ListKey ( sort { $List{$a} cmp $List{$b} } keys %List ) {

                my %Data
                    = $Self->{CustomerCompanyObject}->CustomerCompanyGet( CustomerID => $ListKey );
                $Self->{LayoutObject}->Block(
                    Name => 'OverviewResultRow',
                    Data => {
                        %Data,
                        Search => $Search,
                        Nav    => $Param{Nav},
                    },
                );

                if ( !$Self->{ConfigObject}->Get('CustomerCompany')->{Params}->{ForeignDB} ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'LocalDBRow',
                        Data => {
                            Valid => $ValidList{ $Data{ValidID} },
                            %Data,
                        },
                    );
                }

            }
        }

        # otherwise it displays a no data found message
        else {
            $Self->{LayoutObject}->Block(
                Name => 'NoDataFoundMsg',
                Data => {},
            );
        }
    }

    # if there is nothing to search it shows a message
    else
    {
        $Self->{LayoutObject}->Block(
            Name => 'NoSearchTerms',
            Data => {},
        );
    }
    return 1;
}

1;
