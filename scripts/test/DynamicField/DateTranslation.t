# --
# DateTranslation.t - DynamicField Date Transaltion backend tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use CGI qw(:cgi);
use vars (qw($Self));

use Kernel::Config;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::Output::HTML::Layout;
use Kernel::System::Ticket;
use Kernel::System::UnitTest::Helper;
use Kernel::System::Web::Request;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $RandomID = int rand 1_000_000_000;

# create a new config object
my $ConfigObject = Kernel::Config->new();

# set timezone variables
$ConfigObject->Set(
    Key   => 'TimeZone',
    Value => '+0',
);
$ConfigObject->Set(
    Key   => 'TimeZoneUser',
    Value => 1,
);
$ConfigObject->Set(
    Key   => 'TimeZoneUserBrowserAutoOffset',
    Value => 0,
);

# create other objects
my $DynamicFieldObject = Kernel::System::DynamicField->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $ParamObject = Kernel::System::Web::Request->new(
    %{$Self},
    ConfigObject => $ConfigObject,
    WebRequest   => 0,
);
my $BackendObject = Kernel::System::DynamicField::Backend->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# create a ticket
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketID,
    "TicketCreate() successful for Ticket ID $TicketID",
);

# create dynamic fields
my @DynamicFields = (
    {
        Name       => "DFDate$RandomID",
        Label      => 'a description',
        FieldOrder => 9991,
        FieldType  => 'Date',
        ObjectType => 'Ticket',
        Config     => {
            DefaultValue  => 0,
            YearsInFuture => 5,
            YearsInPast   => 5,
            YearsPeriod   => 0,
        },
        ValidID => 1,
        UserID  => 1,
    },
    {
        Name       => "DFDateTime$RandomID",
        Label      => 'a description',
        FieldOrder => 9991,
        FieldType  => 'DateTime',
        ObjectType => 'Ticket',
        Config     => {
            DefaultValue  => 0,
            YearsInFuture => 5,
            YearsInPast   => 5,
            YearsPeriod   => 0,
        },
        ValidID => 1,
        UserID  => 1,
    },
);
my %DynamicFieldConfigsByType;
for my $DynamicField (@DynamicFields) {

    my $FieldID = $DynamicFieldObject->DynamicFieldAdd( %{$DynamicField} );

    # sanity check
    $Self->True(
        $FieldID,
        "DynamicFieldAdd() successful for Field ID $FieldID",
    );

    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        ID => $FieldID,
    );

    # add the DF config by type to the DynamicFieldConfigsByType hash
    $DynamicFieldConfigsByType{ $DynamicField->{FieldType} } = $DynamicFieldConfig;
}

# create different layout objects for diffefrent time zones
my $LayoutObjectM6 = Kernel::Output::HTML::Layout->new(
    %{$Self},
    ConfigObject => $ConfigObject,
    ParamObject  => $ParamObject,
    Lang         => 'en',
    UserTimeZone => '-6',
);
my $LayoutObject = Kernel::Output::HTML::Layout->new(
    %{$Self},
    ConfigObject => $ConfigObject,
    ParamObject  => $ParamObject,
    Lang         => 'en',
    UserTimeZone => '+0',
);
my $LayoutObjectP6 = Kernel::Output::HTML::Layout->new(
    %{$Self},
    ConfigObject => $ConfigObject,
    ParamObject  => $ParamObject,
    Lang         => 'en',
    UserTimeZone => '+6',
);

my @Tests = (

    # date field type
    {
        Name   => 'Date field -6 hours',
        Config => {
            Type   => 'Date',
            Common => {
                DynamicFieldConfig => $DynamicFieldConfigsByType{Date},
                LayoutObject       => $LayoutObjectM6,
            },
            EditFieldRender => {
                Value => {
                    Value       => '2013-10-01 00:00:00',
                    ParamObject => $ParamObject,
                },
                WebRequest => {
                    CGIParam => {
                        'DynamicField_DFDate' . $RandomID . 'Used'  => 1,
                        'DynamicField_DFDate' . $RandomID . 'Day'   => '01',
                        'DynamicField_DFDate' . $RandomID . 'Month' => '10',
                        'DynamicField_DFDate' . $RandomID . 'Year'  => '2013',
                    },
                },
            },
            EditFieldValueGet => {
                CGIParam => {
                    'DynamicField_DFDate' . $RandomID . 'Used'  => 1,
                    'DynamicField_DFDate' . $RandomID . 'Day'   => '01',
                    'DynamicField_DFDate' . $RandomID . 'Month' => '10',
                    'DynamicField_DFDate' . $RandomID . 'Year'  => '2013',
                },
            },
            ValueSetGet => {
                Value    => '2013-10-01 00:00:00',
                ObjectID => $TicketID,
                UserID   => 1,
            },
        },
        ExpectedResults => {
            EditFieldRender => {
                Value => {
                    Day   => '01',
                    Month => '10',
                    Year  => '2013',
                },
                WebRequest => {
                    Day   => '01',
                    Month => '10',
                    Year  => '2013',
                },
            },
            EditFieldValueGet => '2013-10-01 00:00:00',
            ValueSetGet       => '2013-10-01 00:00:00',
        },
    },
    {
        Name   => 'Date field +0 hours',
        Config => {
            Type   => 'Date',
            Common => {
                DynamicFieldConfig => $DynamicFieldConfigsByType{Date},
                LayoutObject       => $LayoutObject,
            },
            EditFieldRender => {
                Value => {
                    Value       => '2013-10-01 00:00:00',
                    ParamObject => $ParamObject,
                },
                WebRequest => {
                    CGIParam => {
                        'DynamicField_DFDate' . $RandomID . 'Used'  => 1,
                        'DynamicField_DFDate' . $RandomID . 'Day'   => '01',
                        'DynamicField_DFDate' . $RandomID . 'Month' => '10',
                        'DynamicField_DFDate' . $RandomID . 'Year'  => '2013',
                    },
                },
            },
            EditFieldValueGet => {
                CGIParam => {
                    'DynamicField_DFDate' . $RandomID . 'Used'  => 1,
                    'DynamicField_DFDate' . $RandomID . 'Day'   => '01',
                    'DynamicField_DFDate' . $RandomID . 'Month' => '10',
                    'DynamicField_DFDate' . $RandomID . 'Year'  => '2013',
                },
            },
            ValueSetGet => {
                Value    => '2013-10-01 00:00:00',
                ObjectID => $TicketID,
                UserID   => 1,
            },
        },
        ExpectedResults => {
            EditFieldRender => {
                Value => {
                    Day   => '01',
                    Month => '10',
                    Year  => '2013',
                },
                WebRequest => {
                    Day   => '01',
                    Month => '10',
                    Year  => '2013',
                },
            },
            EditFieldValueGet => '2013-10-01 00:00:00',
            ValueSetGet       => '2013-10-01 00:00:00',
        },
    },
    {
        Name   => 'Date field +6 hours',
        Config => {
            Type   => 'Date',
            Common => {
                DynamicFieldConfig => $DynamicFieldConfigsByType{Date},
                LayoutObject       => $LayoutObjectP6,
            },
            EditFieldRender => {
                Value => {
                    Value       => '2013-10-01 00:00:00',
                    ParamObject => $ParamObject,
                },
                WebRequest => {
                    CGIParam => {
                        'DynamicField_DFDate' . $RandomID . 'Used'  => 1,
                        'DynamicField_DFDate' . $RandomID . 'Day'   => '01',
                        'DynamicField_DFDate' . $RandomID . 'Month' => '10',
                        'DynamicField_DFDate' . $RandomID . 'Year'  => '2013',
                    },
                },
            },
            EditFieldValueGet => {
                CGIParam => {
                    'DynamicField_DFDate' . $RandomID . 'Used'  => 1,
                    'DynamicField_DFDate' . $RandomID . 'Day'   => '01',
                    'DynamicField_DFDate' . $RandomID . 'Month' => '10',
                    'DynamicField_DFDate' . $RandomID . 'Year'  => '2013',
                },
            },
            ValueSetGet => {
                Value    => '2013-10-01 00:00:00',
                ObjectID => $TicketID,
                UserID   => 1,
            },
        },
        ExpectedResults => {
            EditFieldRender => {
                Value => {
                    Day   => '01',
                    Month => '10',
                    Year  => '2013',
                },
                WebRequest => {
                    Day   => '01',
                    Month => '10',
                    Year  => '2013',
                },
            },
            EditFieldValueGet => '2013-10-01 00:00:00',
            ValueSetGet       => '2013-10-01 00:00:00',
        },
    },

    # date time field type
    {
        Name   => 'DateTime field -6 hours',
        Config => {
            Type   => 'DateTime',
            Common => {
                DynamicFieldConfig => $DynamicFieldConfigsByType{DateTime},
                LayoutObject       => $LayoutObjectM6,
            },
            EditFieldRender => {
                Value => {
                    Value       => '2013-10-01 01:01:00',
                    ParamObject => $ParamObject,
                },
                WebRequest => {
                    CGIParam => {
                        'DynamicField_DFDateTime' . $RandomID . 'Used'   => 1,
                        'DynamicField_DFDateTime' . $RandomID . 'Day'    => '01',
                        'DynamicField_DFDateTime' . $RandomID . 'Month'  => '10',
                        'DynamicField_DFDateTime' . $RandomID . 'Year'   => '2013',
                        'DynamicField_DFDateTime' . $RandomID . 'Hour'   => '01',
                        'DynamicField_DFDateTime' . $RandomID . 'Minute' => '01',
                    },
                },
            },
            EditFieldValueGet => {
                CGIParam => {
                    'DynamicField_DFDateTime' . $RandomID . 'Used'   => 1,
                    'DynamicField_DFDateTime' . $RandomID . 'Day'    => '01',
                    'DynamicField_DFDateTime' . $RandomID . 'Month'  => '10',
                    'DynamicField_DFDateTime' . $RandomID . 'Year'   => '2013',
                    'DynamicField_DFDateTime' . $RandomID . 'Hour'   => '01',
                    'DynamicField_DFDateTime' . $RandomID . 'Minute' => '01',
                },
            },
            ValueSetGet => {
                Value    => '2013-10-01 01:01:00',
                ObjectID => $TicketID,
                UserID   => 1,
            },
        },
        ExpectedResults => {
            EditFieldRender => {
                Value => {
                    Day    => '30',
                    Month  => '09',
                    Year   => '2013',
                    Hour   => '19',
                    Minute => '01',
                },
                WebRequest => {
                    Day    => '01',
                    Month  => '10',
                    Year   => '2013',
                    Hour   => '01',
                    Minute => '01',
                },
            },
            EditFieldValueGet => '2013-10-01 07:01:00',
            ValueSetGet       => '2013-10-01 01:01:00',
        },
    },
    {
        Name   => 'DateTime field +0 hours',
        Config => {
            Type   => 'DateTime',
            Common => {
                DynamicFieldConfig => $DynamicFieldConfigsByType{DateTime},
                LayoutObject       => $LayoutObject,
            },
            EditFieldRender => {
                Value => {
                    Value       => '2013-10-01 01:01:00',
                    ParamObject => $ParamObject,
                },
                WebRequest => {
                    CGIParam => {
                        'DynamicField_DFDateTime' . $RandomID . 'Used'   => 1,
                        'DynamicField_DFDateTime' . $RandomID . 'Day'    => '01',
                        'DynamicField_DFDateTime' . $RandomID . 'Month'  => '10',
                        'DynamicField_DFDateTime' . $RandomID . 'Year'   => '2013',
                        'DynamicField_DFDateTime' . $RandomID . 'Hour'   => '01',
                        'DynamicField_DFDateTime' . $RandomID . 'Minute' => '01',
                    },
                },
            },
            EditFieldValueGet => {
                CGIParam => {
                    'DynamicField_DFDateTime' . $RandomID . 'Used'   => 1,
                    'DynamicField_DFDateTime' . $RandomID . 'Day'    => '01',
                    'DynamicField_DFDateTime' . $RandomID . 'Month'  => '10',
                    'DynamicField_DFDateTime' . $RandomID . 'Year'   => '2013',
                    'DynamicField_DFDateTime' . $RandomID . 'Hour'   => '01',
                    'DynamicField_DFDateTime' . $RandomID . 'Minute' => '01',
                },
            },
            ValueSetGet => {
                Value    => '2013-10-01 01:01:00',
                ObjectID => $TicketID,
                UserID   => 1,
            },
        },
        ExpectedResults => {
            EditFieldRender => {
                Value => {
                    Day    => '01',
                    Month  => '10',
                    Year   => '2013',
                    Hour   => '01',
                    Minute => '01',
                },
                WebRequest => {
                    Day    => '01',
                    Month  => '10',
                    Year   => '2013',
                    Hour   => '01',
                    Minute => '01',
                },
            },
            EditFieldValueGet => '2013-10-01 01:01:00',
            ValueSetGet       => '2013-10-01 01:01:00',
        },
    },
    {
        Name   => 'DateTime field +6 hours',
        Config => {
            Type   => 'DateTime',
            Common => {
                DynamicFieldConfig => $DynamicFieldConfigsByType{DateTime},
                LayoutObject       => $LayoutObjectP6,
            },
            EditFieldRender => {
                Value => {
                    Value       => '2013-10-01 01:01:00',
                    ParamObject => $ParamObject,
                },
                WebRequest => {
                    CGIParam => {
                        'DynamicField_DFDateTime' . $RandomID . 'Used'   => 1,
                        'DynamicField_DFDateTime' . $RandomID . 'Day'    => '01',
                        'DynamicField_DFDateTime' . $RandomID . 'Month'  => '10',
                        'DynamicField_DFDateTime' . $RandomID . 'Year'   => '2013',
                        'DynamicField_DFDateTime' . $RandomID . 'Hour'   => '01',
                        'DynamicField_DFDateTime' . $RandomID . 'Minute' => '01',
                    },
                },
            },
            EditFieldValueGet => {
                CGIParam => {
                    'DynamicField_DFDateTime' . $RandomID . 'Used'   => 1,
                    'DynamicField_DFDateTime' . $RandomID . 'Day'    => '01',
                    'DynamicField_DFDateTime' . $RandomID . 'Month'  => '10',
                    'DynamicField_DFDateTime' . $RandomID . 'Year'   => '2013',
                    'DynamicField_DFDateTime' . $RandomID . 'Hour'   => '01',
                    'DynamicField_DFDateTime' . $RandomID . 'Minute' => '01',
                },
            },
            ValueSetGet => {
                Value    => '2013-10-01 01:01:00',
                ObjectID => $TicketID,
                UserID   => 1,
            },
        },
        ExpectedResults => {
            EditFieldRender => {
                Value => {
                    Day    => '01',
                    Month  => '10',
                    Year   => '2013',
                    Hour   => '07',
                    Minute => '01',
                },
                WebRequest => {
                    Day    => '01',
                    Month  => '10',
                    Year   => '2013',
                    Hour   => '01',
                    Minute => '01',
                },
            },
            EditFieldValueGet => '2013-09-30 19:01:00',
            ValueSetGet       => '2013-10-01 01:01:00',
        },
    },
);

for my $Test (@Tests) {

    # for EditFieldRender test both cases, a values passed and value in a web request as they might
    # be different
    for my $Type ( sort keys %{ $Test->{Config}->{EditFieldRender} } ) {

        # set the appropiate configuration
        my %Config;
        if ( $Type eq 'Value' ) {
            %Config = (
                %{ $Test->{Config}->{Common} },
                %{ $Test->{Config}->{EditFieldRender}->{$Type} }
            );
        }
        else {

            # creatate a new CGI object to simulate a web request
            my $WebRequest = new CGI( $Test->{Config}->{EditFieldRender}->{$Type}->{CGIParam} );

            my $LocalParamObject = Kernel::System::Web::Request->new(
                %{$Self},
                ConfigObject => $ConfigObject,
                WebRequest   => $WebRequest,
            );
            %Config = (
                %{ $Test->{Config}->{Common} },
                %{ $Test->{Config}->{EditFieldRender}->{$Type} },
                ParamObject => $LocalParamObject,
            );
        }

        # get EditValueRender HTML
        my $FieldHTML = $BackendObject->EditFieldRender(%Config);

        my %HTMLResult;

        #get day from HTML
        $FieldHTML->{Field} =~ m{title="Day" [^s]+ selected="selected">([^<]+)</option>}msx;
        $HTMLResult{Day} = $1;

        #reset capturing groups
        "OTRS" =~ m{OTRS};

        # get month from HTML
        $FieldHTML->{Field} =~ m{title="Month" [^s]+ selected="selected">([^<]+)</option>}msx;
        $HTMLResult{Month} = $1;

        #reset capturing groups
        "OTRS" =~ m{OTRS};

        # get year from HTML
        $FieldHTML->{Field} =~ m{title="Year" [^s]+ selected="selected">([^<]+)</option>}msx;
        $HTMLResult{Year} = $1;

        #reset capturing groups
        "OTRS" =~ m{OTRS};

        # also get Hour and Munute for DateTime fields
        if ( $Test->{Config}->{Type} eq 'DateTime' ) {

            #get hour from HTML
            $FieldHTML->{Field} =~ m{title="Hours" [^s]+ selected="selected">([^<]+)</option>}msx;
            $HTMLResult{Hour} = $1;

            #reset capturing groups
            "OTRS" =~ m{OTRS};

            # get minute from HTML
            $FieldHTML->{Field} =~ m{title="Minutes" [^s]+ selected="selected">([^<]+)</option>}msx;
            $HTMLResult{Minute} = $1;

            #reset capturing groups
            "OTRS" =~ m{OTRS};
        }

        $Self->IsDeeply(
            \%HTMLResult,
            $Test->{ExpectedResults}->{EditFieldRender}->{$Type},
            "$Test->{Name}: EditFieldRender() $Type Expected results",
        );

    }

    # creatate a new CGI object to simulate a web request
    my $WebRequest = new CGI( $Test->{Config}->{EditFieldValueGet}->{CGIParam} );

    my $LocalParamObject = Kernel::System::Web::Request->new(
        %{$Self},
        ConfigObject => $ConfigObject,
        WebRequest   => $WebRequest,
    );

    # get the value form the web request
    my $Value = $BackendObject->EditFieldValueGet(
        %{ $Test->{Config}->{Common} },
        %{ $Test->{Config}->{EditFieldValueGet} },
        ParamObject => $LocalParamObject,
    );

    $Self->Is(
        $Value,
        $Test->{ExpectedResults}->{EditFieldValueGet},
        "$Test->{Name}: EditFieldValueGet() Expected results"
    );

    # set a value in the DB and get it
    my $Success = $BackendObject->ValueSet(
        %{ $Test->{Config}->{Common} },
        %{ $Test->{Config}->{ValueSetGet} },
    );
    $Value = $BackendObject->ValueGet(
        %{ $Test->{Config}->{Common} },
        %{ $Test->{Config}->{ValueSetGet} }
    );

    $Self->Is(
        $Value,
        $Test->{ExpectedResults}->{ValueSetGet},
        "$Test->{Name}: ValueGet() Expected results"
    );
}

# cleanup the system
# delete the ticket
my $TicketDelete = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

# sanity check
$Self->True(
    $TicketDelete,
    "TicketDelete() successful for Ticket ID $TicketID",
);

for my $FieldType ( sort keys %DynamicFieldConfigsByType ) {

    my $DynamicFieldConfig = $DynamicFieldConfigsByType{$FieldType};
    my $FieldID            = $DynamicFieldConfig->{ID};

    my $ValuesDelete = $BackendObject->AllValuesDelete(
        DynamicFieldConfig => $DynamicFieldConfig,
        UserID             => 1,
    );

    # sanity check
    $Self->True(
        $ValuesDelete,
        "AllValuesDelete() successful for Field ID $FieldID",
    );

    # delete the dynamic field
    my $FieldDelete = $DynamicFieldObject->DynamicFieldDelete(
        ID     => $FieldID,
        UserID => 1,
    );

    # sanity check
    $Self->True(
        $FieldDelete,
        "DynamicFieldDelete() successful for Field ID $FieldID",
    );
}

1;
