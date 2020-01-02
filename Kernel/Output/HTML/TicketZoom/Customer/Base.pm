# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::TicketZoom::Customer::Base;

use strict;
use warnings;

use Digest::MD5 qw(md5_hex);

use Kernel::System::VariableCheck qw(IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
    'Kernel::System::Ticket::Article',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 ArticleRender()

Returns article html.

    my $HTML = $ArticleBaseObject->ArticleRender(
        TicketID               => 123,         # (required)
        ArticleID              => 123,         # (required)
        ShowBrowserLinkMessage => 1,           # (optional) Default: 0.
        ArticleActions         => [],          # (optional)
    );

Result:
    $HTML = "<div>...</div>";

=cut

sub ArticleRender {
    die 'Virtual method in base class must not be called.';
}

=head2 ArticleMetaFields()

Returns common fields for any article.

    my %ArticleMetaFields = $ArticleBaseObject->ArticleMetaFields(
        TicketID  => 123,   # (required)
        ArticleID => 123,   # (required)
    );

Returns:

    %ArticleMetaFields = (
        DynamicField_Item => {
            Label => 'Item',            # mandatory
            Value => 'Value',           # mandatory
            Link => 'http://...',       # optional
        },
        AccountedTime => {
            ...
        },
    );

=cut

sub ArticleMetaFields {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my %Result;

    # show accounted article time
    if ( $ConfigObject->Get('Ticket::Frontend::CustomerTicketZoom')->{ZoomTimeDisplay} ) {
        my $ArticleTime = $ArticleObject->ArticleAccountedTimeGet(
            ArticleID => $Param{ArticleID},
        );
        if ($ArticleTime) {
            $Result{Time} = {
                Label => "Time",
                Value => $ArticleTime,
            };
        }
    }

    # get dynamic field config for frontend module
    my $DynamicFieldFilter = {
        %{ $ConfigObject->Get("Ticket::Frontend::CustomerTicketZoom")->{DynamicField} || {} },

        # TODO: Check if there are process dynamic fields for customer interface
        # %{
        #     $ConfigObject->Get("Ticket::Frontend::CustomerTicketZoom")->{ProcessWidgetDynamicField}
        #         || {}
        # },
    };

    # get the dynamic fields for article object
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Article'],
        FieldFilter => $DynamicFieldFilter || {},
    );
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # cycle trough the activated Dynamic Fields
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # skip the dynamic field if is not desinged for customer interface
        my $IsCustomerInterfaceCapable = $BackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsCustomerInterfaceCapable',
        );
        next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

        my $Value = $DynamicFieldBackendObject->ValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $Param{ArticleID},
        );

        next DYNAMICFIELD if !$Value;
        next DYNAMICFIELD if $Value eq '';

        # get print string for this dynamic field
        my $ValueStrg = $DynamicFieldBackendObject->DisplayValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $Value,
            ValueMaxChars      => 160,
            LayoutObject       => $LayoutObject,
        );

        my $Label = $DynamicFieldConfig->{Label};

        $Result{ $DynamicFieldConfig->{Name} } = {
            Label => $Label,
            Value => $ValueStrg->{Value},
            Title => $ValueStrg->{Title},
        };

        if ( $ValueStrg->{Link} ) {
            $Result{ $DynamicFieldConfig->{Name} }->{Link} = $ValueStrg->{Link};
        }

        if ( $ValueStrg->{LinkPreview} ) {
            $Result{ $DynamicFieldConfig->{Name} }->{LinkPreview} = $ValueStrg->{LinkPreview};
        }
    }

    return %Result;
}

1;
