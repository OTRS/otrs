# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Dashboard::CustomerUserInformation;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed parameters
    for my $Needed (qw(Config Name UserID)) {
        die "Got no $Needed!" if ( !$Self->{$Needed} );
    }

    $Self->{PrefKey} = 'UserDashboardPref' . $Self->{Name} . '-Shown';

    $Self->{CacheKey} = $Self->{Name};

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    return;
}

sub Config {
    my ( $Self, %Param ) = @_;

    return (
        %{ $Self->{Config} },

        # caching not needed
        CacheKey => undef,
        CacheTTL => undef,
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    return if !$Param{CustomerUserID};

    my %CustomerUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
        User => $Param{CustomerUserID},
    );

    my $CustomerUserConfig = $Kernel::OM->Get('Kernel::Config')->Get( $CustomerUser{Source} || '' );
    return if ref $CustomerUserConfig ne 'HASH';
    return if ref $CustomerUserConfig->{Map} ne 'ARRAY';

    return if !%CustomerUser;

    # Get needed objects
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ValidObject  = $Kernel::OM->Get('Kernel::System::Valid');
    my $CustomerUserIsValid;

    # make ValidID readable
    if ( $CustomerUser{ValidID} ) {
        my @ValidIDs = $ValidObject->ValidIDsGet();
        $CustomerUserIsValid = grep { $CustomerUser{ValidID} == $_ } @ValidIDs;

        $CustomerUser{ValidID} = $ValidObject->ValidLookup(
            ValidID => $CustomerUser{ValidID},
        );

        $CustomerUser{ValidID} = $LayoutObject->{LanguageObject}->Translate( $CustomerUser{ValidID} );
    }

    if ( $CustomerUser{UserTitle} ) {
        $CustomerUser{UserTitle} = $LayoutObject->{LanguageObject}->Translate( $CustomerUser{UserTitle} );
    }

    my $DynamicFieldConfigs = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        ObjectType => 'CustomerUser',
    );

    my %DynamicFieldLookup = map { $_->{Name} => $_ } @{$DynamicFieldConfigs};

    # Get dynamic field backend object.
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    ENTRY:
    for my $Entry ( @{ $CustomerUserConfig->{Map} } ) {
        my $Key = $Entry->[0];

        # do not show items if they're not marked as visible
        next ENTRY if !$Entry->[3];

        my $Label = $Entry->[1];
        my $Value = $CustomerUser{$Key};

        # render dynamic field values
        if ( $Entry->[5] eq 'dynamic_field' ) {
            if ( !IsArrayRefWithData($Value) ) {
                $Value = [$Value];
            }

            my $DynamicFieldConfig = $DynamicFieldLookup{ $Entry->[2] };

            next ENTRY if !$DynamicFieldConfig;

            my @RenderedValues;
            VALUE:
            for my $Value ( @{$Value} ) {
                my $RenderedValue = $DynamicFieldBackendObject->DisplayValueRender(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Value              => $Value,
                    HTMLOutput         => 0,
                    LayoutObject       => $LayoutObject,
                );

                next VALUE if !IsHashRefWithData($RenderedValue) || !defined $RenderedValue->{Value};

                push @RenderedValues, $RenderedValue->{Value};
            }

            $Value = join ', ', @RenderedValues;
            $Label = $DynamicFieldConfig->{Label};
        }

        # do not show empty entries
        next ENTRY if !length($Value);

        $LayoutObject->Block( Name => "ContentSmallCustomerUserInformationRow" );

        if ( $Key eq 'UserCustomerID' ) {
            $LayoutObject->Block(
                Name => "ContentSmallCustomerUserInformationRowLink",
                Data => {
                    %CustomerUser,
                    Label => $Label,
                    Value => $Value,
                    URL =>
                        '[% Env("Baselink") %]Action=AdminCustomerCompany;Subaction=Change;CustomerID=[% Data.UserCustomerID | uri %];Nav=Agent',
                    Target => '',
                },
            );

            next ENTRY;
        }

        if ( $Key eq 'UserLogin' ) {
            $LayoutObject->Block(
                Name => "ContentSmallCustomerUserInformationRowLink",
                Data => {
                    %CustomerUser,
                    Label => $Label,
                    Value => $Value,
                    URL =>
                        '[% Env("Baselink") %]Action=AdminCustomerUser;Subaction=Change;ID=[% Data.UserLogin | uri %];Nav=Agent',
                    Target => '',
                },
            );

            next ENTRY;
        }

        # check if a link must be placed
        if ( $Entry->[6] ) {
            $LayoutObject->Block(
                Name => "ContentSmallCustomerUserInformationRowLink",
                Data => {
                    %CustomerUser,
                    Label  => $Label,
                    Value  => $Value,
                    URL    => $Entry->[6],
                    Target => '_blank',
                },
            );

            next ENTRY;

        }

        $LayoutObject->Block(
            Name => "ContentSmallCustomerUserInformationRowText",
            Data => {
                %CustomerUser,
                Label => $Label,
                Value => $Value,
            },
        );

        if ( $Key eq 'UserLogin' && defined $CustomerUserIsValid && !$CustomerUserIsValid ) {
            $LayoutObject->Block(
                Name => 'ContentSmallCustomerUserInvalid',
            );
        }
    }

    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardCustomerUserInformation',
        Data         => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %CustomerUser,
        },
        AJAX => $Param{AJAX},
    );

    return $Content;
}

1;
