# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::Output::HTML::Layout;

use Kernel::System::VariableCheck qw(:all);

# get needed objects
# my $HelperObject    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $DFBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

# my $ParamObject     = $Kernel::OM->Get('Kernel::System::Web::Request');
# my $TimeObject      = $Kernel::OM->Get('Kernel::System::Time');

# # use a fixed year to compare the time selection results
# $HelperObject->FixedTimeSet(
#     $TimeObject->TimeStamp2SystemTime( String => '2013-12-12 00:00:00' ),
# );

my $LayoutObject = Kernel::Output::HTML::Layout->new(
    Lang         => 'en',
    UserTimeZone => 'UTC',
);

my $UserID = 1;

# theres is not really needed to add the dynamic fields for this test, we can define a static
# set of configurations
my %DynamicFieldConfigs = (
    Text => {
        ID            => 123,
        InternalField => 0,
        Name          => 'TextField',
        Label         => 'TextField <special chars="äüø">',
        LabelEscaped  => 'TextField &lt;special chars=&quot;äüø&quot;&gt;',
        FieldOrder    => 123,
        FieldType     => 'Text',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue => 'Default',
            Link         => '',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    TextArea => {
        ID            => 123,
        InternalField => 0,
        Name          => 'TextAreaField',
        Label         => 'TextAreaField <special chars="äüø">',
        LabelEscaped  => 'TextAreaField &lt;special chars=&quot;äüø&quot;&gt;',
        FieldOrder    => 123,
        FieldType     => 'TextArea',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue => "Multi\nLine",
            Rows         => '',
            Cols         => '',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    Checkbox => {
        ID            => 123,
        InternalField => 0,
        Name          => 'CheckboxField',
        Label         => 'CheckboxField <special chars="äüø">',
        LabelEscaped  => 'CheckboxField &lt;special chars=&quot;äüø&quot;&gt;',
        FieldOrder    => 123,
        FieldType     => 'Checkbox',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue => '1',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    Dropdown => {
        ID            => 123,
        InternalField => 0,
        Name          => 'DropdownField',
        Label         => 'DropdownField <special chars="äüø">',
        LabelEscaped  => 'DropdownField &lt;special chars=&quot;äüø&quot;&gt;',
        FieldOrder    => 123,
        FieldType     => 'Dropdown',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue       => 2,
            Link               => '',
            PossibleNone       => 1,
            TranslatableValues => '',
            PossibleValues     => {
                1 => 'A',
                2 => 'B',
            },
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    Multiselect => {
        ID            => 123,
        InternalField => 0,
        Name          => 'MultiselectField',
        Label         => 'MultiselectField <special chars="äüø">',
        LabelEscaped  => 'MultiselectField &lt;special chars=&quot;äüø&quot;&gt;',
        FieldOrder    => 123,
        FieldType     => 'Multiselect',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue       => 2,
            PossibleNone       => 1,
            TranslatableValues => '',
            PossibleValues     => {
                1 => 'A',
                2 => 'B',
            },
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    DateTime => {
        ID            => 123,
        InternalField => 0,
        Name          => 'DateTimeField',
        Label         => 'DateTimeField <special chars="äüø">',
        LabelEscaped  => 'DateTimeField &lt;special chars=&quot;äüø&quot;&gt;',
        FieldOrder    => 123,
        FieldType     => 'DateTime',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue  => '2013-08-21 16:45:00',
            Link          => '',
            YearsPeriod   => '1',
            YearsInFuture => '5',
            YearsInPast   => '5',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    Date => {
        ID            => 123,
        InternalField => 0,
        Name          => 'DateField',
        Label         => 'DateField <special chars="äüø">',
        LabelEscaped  => 'DateField &lt;special chars=&quot;äüø&quot;&gt;',
        FieldOrder    => 123,
        FieldType     => 'Date',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue  => '2013-08-21 00:00:00',
            Link          => '',
            YearsPeriod   => '1',
            YearsInFuture => '5',
            YearsInPast   => '5',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
);

# execute tests
for my $DynamicField ( sort keys %DynamicFieldConfigs ) {

    # Right now we at least call the function to make sure it works (no perl error) and
    #   returns something.
    $Self->True(
        $DFBackendObject->SearchFieldRender(
            DynamicFieldConfig => $DynamicFieldConfigs{$DynamicField},
            LayoutObject       => $LayoutObject,
            Profile            => {},
        ),
        "$DynamicField - SearchFieldRender",
    );
}

# we don't need any cleanup
1;
