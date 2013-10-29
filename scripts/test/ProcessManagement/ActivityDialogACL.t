# --
# ActivityDialogACL.t - ActivityDialog ACL testscript
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use Kernel::Config;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::CustomerUser;
use Kernel::System::Queue;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::State;
use Kernel::System::ProcessManagement::Activity;
use Kernel::System::ProcessManagement::ActivityDialog;
use Kernel::System::ProcessManagement::Process;
use Kernel::System::ProcessManagement::TransitionAction;
use Kernel::System::ProcessManagement::Transition;
use Kernel::System::Ticket;
use Kernel::System::UnitTest::Helper;
use Kernel::System::User;
use Kernel::System::VariableCheck qw(:all);

use vars qw($Self);

# create objects
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    UnitTestObject => $Self,
    %{$Self},
    RestoreSystemConfiguration => 1,
);

# To be uncommented if finished (creates a new TestUser to do ACL Testings)
my $UserLogin = $HelperObject->TestUserCreate(
    Groups => [ 'admin', 'users' ],
);
my $CustomerUserLogin = $HelperObject->TestCustomerUserCreate();

my $ConfigObject = Kernel::Config->new();
my $UserObject   = Kernel::System::User->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $CustomerUserObject = Kernel::System::CustomerUser->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $ServiceObject = Kernel::System::Service->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $SLAObject = Kernel::System::SLA->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $StateObject = Kernel::System::State->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $ActivityObject = Kernel::System::ProcessManagement::Activity->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $ActivityDialogObject = Kernel::System::ProcessManagement::ActivityDialog->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $TransitionObject = Kernel::System::ProcessManagement::Transition->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $TransitionActionObject = Kernel::System::ProcessManagement::TransitionAction->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $ProcessObject = Kernel::System::ProcessManagement::Process->new(
    %{$Self},
    ConfigObject           => $ConfigObject,
    TicketObject           => $TicketObject,
    ActivityObject         => $ActivityObject,
    ActivityDialogObject   => $ActivityDialogObject,
    TransitionObject       => $TransitionObject,
    TransitionActionObject => $TransitionActionObject,
);
my $DynamicFieldObject = Kernel::System::DynamicField->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $BackendObject = Kernel::System::DynamicField::Backend->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $QueueObject = Kernel::System::Queue->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# We'd need a CustomerUser and an User configured as Agent
# in the hashes the ID's and all additional userdata are stored
my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
    User => $CustomerUserLogin,
);

my %User = $UserObject->GetUserData(
    User => $UserLogin,
);

my $RandomID = $HelperObject->GetRandomID();

# create some queues in the system
my %QueueData1 = (
    Name            => 'Queue1' . $RandomID,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);

my %QueueData2 = (
    Name            => 'Queue2' . $RandomID,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);

my $QueueID1 = $QueueObject->QueueAdd(%QueueData1);

# sanity check
$Self->IsNot(
    $QueueID1,
    undef,
    "QueueAdd() - Added queue '$QueueData1{Name}' for ACL check - should not be undef"
);

my $QueueID2 = $QueueObject->QueueAdd(%QueueData2);

# sanity check
$Self->IsNot(
    $QueueID2,
    undef,
    "QueueAdd() - Added queue '$QueueData2{Name}' for ACL check - should not be undef"
);

my %UTConfig;

my $TestData = {
    Title                                    => 'test',
    QueueID                                  => $QueueID1,
    Lock                                     => 'unlock',
    Priority                                 => '3 normal',
    StateID                                  => 1,
    TypeID                                   => 1,
    OwnerID                                  => 1,
    ResponsibleID                            => 1,
    ArchiveFlag                              => 'n',
    DynamicField_ProcessManagementActivityID => 'A3',
    DynamicField_ProcessManagementProcessID  => 'P1',
};

# add two services, one that will be used for a positive
# one for a negative acl check
for my $Type (qw(Positive Negative)) {
    $UTConfig{$Type}{Service}{ID} = $ServiceObject->ServiceAdd(
        Name    => 'ProcessACLService' . $HelperObject->GetRandomID(),
        Comment => 'ProcessACLService' . $HelperObject->GetRandomID(),
        ValidID => 1,
        UserID  => $User{UserID},
    );
    $Self->True(
        $UTConfig{$Type}{Service}{ID},
        "ServiceAdd() - Added service for $Type ACL check."
    );
    my %ServiceData = $ServiceObject->ServiceGet(
        UserID    => $User{UserID},
        ServiceID => $UTConfig{$Type}{Service}{ID}
    );
    $Self->True(
        IsHashRefWithData( \%ServiceData ),
        "ServiceGet() - Got service " . $ServiceData{Name} . " for $Type ACL check."
    );
    $UTConfig{$Type}{Service}{Name}    = $ServiceData{Name};
    $UTConfig{$Type}{Service}{Comment} = $ServiceData{Comment};

    # Add the service to our testcustomer
    $ServiceObject->CustomerUserServiceMemberAdd(
        CustomerUserLogin => $CustomerUserLogin,
        ServiceID         => $UTConfig{$Type}{Service}{ID},
        Active            => 1,
        UserID            => $User{UserID},
    );
}

# add two SLAs, one that will be used for a positive
# one for a negative acl check
for my $Type (qw(Positive Negative)) {
    $UTConfig{$Type}{SLA}{ID} = $SLAObject->SLAAdd(
        Name       => 'ProcessACLSLA' . $HelperObject->GetRandomID(),
        ServiceIDs => [ $UTConfig{Positive}{Service}{ID}, $UTConfig{Negative}{Service}{ID} ],
        Comment    => 'ProcessACLSLA' . $HelperObject->GetRandomID(),
        ValidID    => 1,
        UserID     => $User{UserID},
    );
    $Self->True(
        $UTConfig{$Type}{SLA}{ID},
        "SLAAdd() - Added SLA for $Type ACL check."
    );

    my %SLAData = $SLAObject->SLAGet(
        UserID => $User{UserID},
        SLAID  => $UTConfig{$Type}{SLA}{ID},
    );
    $UTConfig{$Type}{SLA}{Name}    = $SLAData{Name};
    $UTConfig{$Type}{SLA}{Comment} = $SLAData{Comment};

    $Self->True(
        IsHashRefWithData( \%SLAData ),
        "SLAGet() - Got SLA " . $SLAData{Name} . " for $Type ACL check."
    );
}

# Configuration for DynamicFields to do DynamicFieldTestings
my %NewDynamicFields = (
    'OrderStatus' . int rand 1_000_000 => {
        Label      => 'OrderStatus',
        FieldType  => 'Dropdown',
        ObjectType => 'Ticket',
        Config     => {
            TranslatableValues => 0,
            PossibleValues     => {
                1 => 'A',
                2 => 'B',
                3 => 'C',
            },
            DefaultValue => 1,
            PossibleNone => 0,
            Link         => '',
        },
    },
    'Provider' . int rand 1_000_000 => {
        Label      => 'Provider',
        FieldType  => 'Dropdown',
        ObjectType => 'Ticket',
        Config     => {
            TranslatableValues => 0,
            PossibleValues     => {
                1 => 'DB AG',
                2 => 'f-i',
            },
            DefaultValue => 1,
            PossibleNone => 0,
            Link         => '',
        },
    },
    'OrderNumberProvider' . int rand 1_000_000 => {
        Label      => 'OrderNumber Provider',
        FieldType  => 'Text',
        ObjectType => 'Ticket',
        Config     => {
            DefaultValue => '',
        },
    },
    'System' . int rand 1_000_000 => {
        Label      => 'System',
        FieldType  => 'Dropdown',
        ObjectType => 'Ticket',
        Config     => {
            TranslatableValues => 0,
            PossibleValues     => {
                1 => 'Test',
                2 => 'Prod'
            },
            DefaultValue => 1,
            PossibleNone => 0,
            Link         => '',
        },
    },
);

# Set names to the name + random id as used in the DynamicFields hash keys
for my $DynamicFieldConfig ( sort keys %NewDynamicFields ) {
    $NewDynamicFields{$DynamicFieldConfig}{Name} = $DynamicFieldConfig;
}

# remember added dynamic fields
my @AddedDynamicFields;

# ----------------------------------------
# Create the dynamic fields for testing
# ----------------------------------------
for my $NewFieldName ( sort keys %NewDynamicFields ) {

    my $ID = $DynamicFieldObject->DynamicFieldAdd(
        %{ $NewDynamicFields{$NewFieldName} },
        FieldOrder => 99999,
        ValidID    => 1,
        UserID     => $User{UserID},
    );

    push @AddedDynamicFields, $ID;

    $Self->True(
        $ID,
        "DynamicFieldAdd() - Add DynamicField $NewFieldName for acl checks."
    );

    # Store values for positive and negative testcases.
    # if we have "PossibleValues" e.g. the dynamic field is a select
    # use 1 as positive and 2 as negative values
    if ( IsHashRefWithData( $NewDynamicFields{$NewFieldName}{Config}{PossibleValues} ) ) {
        $UTConfig{Positive}{Ticket}{ "DynamicField_" . $NewFieldName }       = 1;
        $UTConfig{Negative}{Ticket}{ "DynamicField_" . $NewFieldName }       = 2;
        $UTConfig{Positive}{DynamicField}{ "DynamicField_" . $NewFieldName } = 1;
        $UTConfig{Negative}{DynamicField}{ "DynamicField_" . $NewFieldName } = 2;
    }

    # if it isn't a select field, use strings 'positive' and 'negative'
    else {
        $UTConfig{Positive}{Ticket}{ "DynamicField_" . $NewFieldName }       = 'positive';
        $UTConfig{Negative}{Ticket}{ "DynamicField_" . $NewFieldName }       = 'negative';
        $UTConfig{Positive}{DynamicField}{ "DynamicField_" . $NewFieldName } = 'positive';
        $UTConfig{Negative}{DynamicField}{ "DynamicField_" . $NewFieldName } = 'negative';
    }
}

# Reread the dynamicField Config
my $DynamicFieldsList = $DynamicFieldObject->DynamicFieldListGet(
    Valid      => 0,
    ObjectType => ['Ticket'],
);

my %DynamicFieldLookup = ();

# if creation failed we may have no fields
if ( !IsArrayRefWithData($DynamicFieldsList) ) {
    $DynamicFieldsList = [];
}
else {
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicFieldsList} ) {
        $DynamicFieldLookup{ $DynamicFieldConfig->{Name} } = $DynamicFieldConfig;
    }
}

# ----------------------------------------

# CheckDataWithoutTicket is a hash containing all necessary information
# ACL's can check on but no TicketID
# This is used for ACL tests on just values
my %CheckDataWithoutTicket;

# ----------------------------------------
# ACL Setup
# ----------------------------------------

my %TestACLs;
my $ACLCounter = 1;

# Includes a test on "PossibleNot"
# Configured Activity Dialogs are: 'AD3', 'AD5', 'AD6'
# 'AD5' and 'AD6' will be returned by the Possible test
# and will be reduced to 'AD5' by the PossibleNot statement in the State ACL

$TestACLs{"00$ACLCounter-ACL-State"} = {
    Properties => {
        Ticket => {
            State => ['new'],
        },
    },
    Possible => {
        Ticket => {
            State => ['closed successful'],
        },
        ActivityDialog => [ 'AD5', 'AD6', 'AD14' ],
    },
    PossibleNot => {
        ActivityDialog => [ 'AD6', 'AD12' ],
    },
};
$ACLCounter++;
$TestACLs{"00$ACLCounter-ACL-Service"} = {
    Properties => {
        Ticket => {
            Service => [ $UTConfig{Positive}{Service}{Name} ],
        },
    },
    Possible => {
        Ticket => {
            Service => [ $UTConfig{Negative}{Service}{Name} ],
        },
        ActivityDialog => [ 'AD5', 'AD6' ],
    },
};
$ACLCounter++;
$TestACLs{"00$ACLCounter-ACL-SLA"} = {
    Properties => {
        Ticket => {
            SLAID => [ $UTConfig{Positive}{SLA}{ID} ],
        },
    },
    Possible => {
        Ticket => {
            SLA => [ $UTConfig{Negative}{SLA}{Name} ],
        },
        ActivityDialog => [ 'AD5', 'AD6' ],
    },
};
$ACLCounter++;
$TestACLs{"00$ACLCounter-ACL-Queue"} = {
    Properties => {
        Ticket => {
            Queue => [ $QueueData1{Name} ],
        },
    },
    Possible => {
        Ticket => {
            Queue => [ $QueueData2{Name} ],
        },
        ActivityDialog => [ 'AD5', 'AD6' ],
    },
};
$ACLCounter++;
DYNAMICFIELDLOOP:
for my $Fieldname ( sort keys %NewDynamicFields ) {
    next DYNAMICFIELDLOOP
        if (
        $NewDynamicFields{$Fieldname}{FieldType}    ne 'Dropdown'
        && $NewDynamicFields{$Fieldname}{FieldType} ne 'Multiselect'
        && $NewDynamicFields{$Fieldname}{FieldType} ne 'Checkbox'
        );
    next DYNAMICFIELDLOOP
        if ( !IsHashRefWithData( $NewDynamicFields{$Fieldname}{Config}{PossibleValues} ) );
    $TestACLs{"00$ACLCounter-ACL-$Fieldname"} = {
        Properties => {
            Ticket => {
                "DynamicField_$Fieldname" =>
                    [ $UTConfig{Positive}{DynamicField}{"DynamicField_$Fieldname"} ],
            },
        },
        Possible => {
            Ticket => {
                "DynamicField_$Fieldname" => [
                    $NewDynamicFields{$Fieldname}{Config}{PossibleValues}
                        { $UTConfig{Negative}{DynamicField}{"DynamicField_$Fieldname"} }
                ],
            },
            ActivityDialog => [ 'AD5', 'AD6' ],
        },
    };
    $ACLCounter++;
}

# Set the process config
my $ProcessConfigSub = sub {
    my $ConfigObject  = shift;
    my $DynamicFields = shift;

    my %DynamicFieldsLookup = map {

        # Assign the hashkey (e.g. dynamic field name)
        # to $Key
        my $Key = $_;

        # remove the nummeric part that is generated
        # for the testing
        $Key =~ s/(\D+)\d+/$1/;

        # form it as hashkey and value in order to
        # get a translation hash
        # DynamicField_Fieldname => DynamicField_Fieldname839391ß,
        "DynamicField_$Key" => "DynamicField_$_"
    } ( sort keys %{$DynamicFields} );

    # OrderStatus Provider OrderNumberProvider System
    my $Config = {
        'Process' =>
            {
            'P1' => {
                Name                => 'Process 1',
                State               => 'Active',
                StartActivity       => 'A1',
                StartActivityDialog => 'AD1',
                Path                => {
                    'A1' => {
                        'T1' => {
                            ActivityEntityID => 'A2',
                        },
                    },
                    'A2' => {
                        'T2' => {
                            ActivityEntityID => 'A3',
                        },
                    },
                },
            },
            'P2' => {
                Name                => 'Process 2',
                State               => 'Active',
                StartActivity       => 'A2',
                StartActivityDialog => 'AD2',
                Path                => {
                    'A2' => {
                        'T3' => {
                            ActivityEntityID => 'A4',
                        },
                    },
                },
                }
            },
        'Process::Transition' => {
            'T1' => {
                Name      => 'Transition 1',
                Condition => {
                    Cond1 => {
                        Fields => {
                            DynamicField_OrderStatus => {
                                Type  => 'String',
                                Match => '2',
                            },
                        },
                    },
                },
            },
            'T2' => {
                Name      => 'Transition 2',
                Condition => {
                    Cond1 => {
                        Fields => {
                            DynamicField_OrderStatus => {
                                Type  => 'String',
                                Match => '4',
                            },
                        },
                    },
                },
            },
        },
        'Process::Activity' =>
            {
            'A1' => {
                Name           => 'Activity 1',
                ActivityDialog => {
                    1 => 'AD1',
                },
            },
            'A2' => {
                Name           => 'Activity 2',
                ActivityDialog => {
                    1 => 'AD2',
                    2 => 'AD3',
                },
            },
            'A3' => {
                Name           => 'Activity 3',
                ActivityDialog => {
                    1 => 'AD4',
                    2 => 'AD5',
                    3 => 'AD6',
                },
            },
            'A4' => {
                Name           => 'Activity 4',
                ActivityDialog => {
                    1 => 'AD1',
                },
                }
            },
        'Process::ActivityDialog' => {
            'AD1' => {
                Name             => 'Activity Dialog 1',
                DescriptionShort => '',
                DescriptionLong  => '',
                Interface        => [ 'AgentInterface', 'CustomerInterface' ],
                Fields           => {

                    # OrderStatus Provider OrderNumberProvider System

                    DynamicField_OrderStatus => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        DefaultValue     => 1,
                        Display          => 2,
                    },
                    Queue => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        DefaultValue     => $QueueData1{Name},
                        Display          => 2,
                    },
                    CustomerID => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        Display          => 2,
                    },
                    ResponsibleID => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        DefaultValue     => 1,
                        Display          => 2,
                    },
                    OwnerID => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        DefaultValue     => 1,
                        Display          => 2,
                    },
                    SLAID => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        DefaultValue     => 1,
                        Display          => 2,
                    },
                    ServiceID => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        DefaultValue     => 1,
                        Display          => 2,
                    },
                    LockID => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        DefaultValue     => 1,
                        Display          => 2,
                    },
                    PriorityID => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        DefaultValue     => 3,
                        Display          => 2,
                    },
                    StateID => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        DefaultValue     => 1,
                        Display          => 2,
                    },
                    DynamicField_Provider => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        DefaultValue     => 1,
                        Display          => 2,
                    },
                    DynamicField_OrderNumberProvider => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        Display          => 1,
                    },
                    DynamicField_System => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        Display          => 1,
                    },
                    Title => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        Display          => 2,
                    },
                },
                FieldOrder => [
                    'DynamicField_OrderStatus',
                    'Queue',   'CustomerID', 'ResponsibleID',
                    'OwnerID', 'SLAID',      'ServiceID',
                    'LockID',  'PriorityID', 'StateID',
                    'DynamicField_Provider',
                    'DynamicField_OrderNumberProvider',
                    'DynamicField_System',
                ],
            },
            'AD2' => {
                Name             => 'Activity Dialog 2',
                DescriptionShort => '',
                DescriptionLong  => '',
                Interface        => [ 'AgentInterface', 'CustomerInterface' ],
                Fields           => {
                    DynamicField_OrderStatus => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        DefaultValue     => 4,
                        Display          => 2,
                    },
                },
                FieldOrder =>
                    [ 'DynamicField_OrderStatus', ],
            },
            'AD3' => {
                Name             => 'Activity Dialog 3',
                DescriptionShort => '',
                DescriptionLong  => '',
                Interface        => [ 'AgentInterface', 'CustomerInterface' ],
                Fields           => {
                    DynamicField_OrderStatus => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        DefaultValue     => 4,
                        Display          => 2,
                    },
                },
                FieldOrder =>
                    [ 'DynamicField_OrderStatus', ],
            },
            'AD4' => {
                Name             => 'Activity Dialog 4',
                DescriptionShort => '',
                DescriptionLong  => '',
                Interface        => [ 'AgentInterface', 'CustomerInterface' ],
                Fields           => {
                    DynamicField_OrderStatus => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        DefaultValue     => 4,
                        Display          => 2,
                    },
                },
                FieldOrder => [ 'DynamicField_OrderStatus', ],
            },
            'AD5' => {
                Name             => 'Activity Dialog 5',
                DescriptionShort => '',
                DescriptionLong  => '',
                Interface        => [ 'AgentInterface', 'CustomerInterface' ],
                Fields           => {
                    DynamicField_OrderStatus => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        DefaultValue     => 4,
                        Display          => 2,
                    },
                },
                FieldOrder => [ 'DynamicField_OrderStatus', ],
            },
            'AD6' => {
                Name             => 'Activity Dialog 6',
                DescriptionShort => '',
                DescriptionLong  => '',
                Interface        => [ 'AgentInterface', 'CustomerInterface' ],
                Fields           => {
                    DynamicField_OrderStatus => {
                        DescriptionShort => '',
                        DescriptionLong  => '',
                        DefaultValue     => 4,
                        Display          => 2,
                    },
                },
                FieldOrder => [ 'DynamicField_OrderStatus', ],
            },
        },
    };

    # and now we have to replace the config's dynamicfield names
    # with our  generated dynamicfield names
    ACTIVITYLOOP:
    for my $ActivityDialog ( sort keys %{ $Config->{'Process::ActivityDialog'} } ) {
        @{ $Config->{'Process::ActivityDialog'}{$ActivityDialog}{FieldOrder} } =
            map { (/^DynamicField_/) ? $DynamicFieldsLookup{$_} : $_ }
            @{ $Config->{'Process::ActivityDialog'}{$ActivityDialog}{FieldOrder} };
        FIELDLOOP:
        for my $Field (
            sort keys %{ $Config->{'Process::ActivityDialog'}{$ActivityDialog}{Fields} }
            )
        {
            next FIELDLOOP if ( $Field !~ /^DynamicField/ );

            # Example:
            # Original $Field Key: DynamicField_OrderStatus
            # Put the Config of the Original Key into
            # Key DynamicField_OrderStatus389230238
            $Config->{'Process::ActivityDialog'}{$ActivityDialog}{Fields}
                { $DynamicFieldsLookup{$Field} }
                =
                $Config->{'Process::ActivityDialog'}{$ActivityDialog}{Fields}{$Field};

            # Delete the old key
            delete $Config->{'Process::ActivityDialog'}{$ActivityDialog}{Fields}{$Field};
        }
    }

    for my $Key ( sort keys %{$Config} ) {
        $ConfigObject->Set(
            Key   => $Key,
            Value => {},
        );
        $ConfigObject->Set(
            Key   => $Key,
            Value => $Config->{$Key},
        );
    }
};

$ProcessConfigSub->( $ConfigObject, \%NewDynamicFields );

$ConfigObject->Set(
    Key   => 'TicketAcl',
    Value => \%TestACLs,
);

# ----------------------------------------

# ----------------------------------------
# Create a test ticket for positive and one for negative testing
# ----------------------------------------
for my $Type (qw(Positive Negative)) {
    $UTConfig{$Type}{Ticket}{ID} = $TicketObject->TicketCreate(

        # test data
        %{$TestData},

        # dynamicly created SLA and Service for positive/negative tests
        ServiceID => $UTConfig{$Type}{Service}{ID},
        SLAID     => $UTConfig{$Type}{SLA}{ID},

        # default data
        Title        => "ProcessACLTest-$Type",
        CustomerUser => $CustomerUserLogin,
        UserID       => $User{UserID},
    );
    $Self->True(
        $UTConfig{$Type}{Ticket}{ID},
        "TicketCreate() - $Type",
    );

    for my $DynamicFieldConfig ( sort keys %NewDynamicFields ) {
        my $Success = $BackendObject->ValueSet(
            DynamicFieldConfig => $DynamicFieldLookup{$DynamicFieldConfig},
            ObjectID           => $UTConfig{$Type}{Ticket}{ID},
            Value              => $UTConfig{$Type}{Ticket}{ "DynamicField_" . $DynamicFieldConfig },
            UserID             => $User{UserID},
        );

        $Self->True(
            $Success,
            "DynamicFieldValueSet() - Ticket value set for $Type DynamicField $DynamicFieldConfig.",
        );
    }

    # Set Process ID on the stored Ticket
    # Value is used of the $TestData
    my $Success = $ProcessObject->ProcessTicketProcessSet(
        ProcessEntityID => $TestData->{DynamicField_ProcessManagementProcessID},
        TicketID        => $UTConfig{$Type}{Ticket}{ID},
        UserID          => $User{UserID},
    );
    $Self->True(
        $Success,
        'Process Set() - ProcessEntityID set on Ticket with ID '
            . $UTConfig{$Type}{Ticket}{ID} . '.',
    );
    $Success = undef;

    # Set Activity ID on the stored Ticket
    # Value is used of TestData
    $Success = $ProcessObject->ProcessTicketActivitySet(
        ProcessEntityID  => $TestData->{DynamicField_ProcessManagementProcessID},
        ActivityEntityID => $TestData->{DynamicField_ProcessManagementActivityID},
        TicketID         => $UTConfig{$Type}{Ticket}{ID},
        UserID           => $User{UserID},
    );
    $Self->True(
        $Success,
        'Activity Set() - ActivityEntityID set on Ticket with ID '
            . $UTConfig{$Type}{Ticket}{ID} . '.',
    );

    # Use the created tickets to get the necessary data for
    # checking without TicketID
    %{ $CheckDataWithoutTicket{$Type} } = $TicketObject->TicketGet(
        TicketID      => $UTConfig{$Type}{Ticket}{ID},
        DynamicFields => 1,
        UserID        => $User{UserID},
    );

    # remove the TicketID
    delete $CheckDataWithoutTicket{$Type}{TicketID};
    delete $CheckDataWithoutTicket{$Type}{Type};
}

# ----------------------------------------

# ----------------------------------------
# ACL Tests
# ----------------------------------------
my %StateResult = $StateObject->StateList(
    UserID => 1,
    Valid  => 1,
);

# Check if Rootuser doesn't get reduced
my %State = $TicketObject->TicketStateList(
    UserID => 1,
    %{ $CheckDataWithoutTicket{Positive} },
);
$Self->IsDeeply(
    \%State,
    \%StateResult,
    "ACL Check TicketStateList for root() - TicketState",
);

# Check if Rootuser gets all Activity Dialogs delivered for checking
my $ActivityDialogsArray = [ 'AD3', 'AD5', 'AD6' ];
my @ActivityDialogs
    = $TicketObject->TicketAclActivityDialogData( ActivityDialogs => $ActivityDialogsArray );

$Self->IsDeeply(
    \@ActivityDialogs,
    [ 'AD3', 'AD5', 'AD6' ],
    "Activity Dialogs Check for root() - Acl based reduced possible activity dialogs",
);

$ActivityDialogsArray = undef;
@ActivityDialogs      = ();
%State                = ();
%StateResult          = (
    '2' => 'closed successful'
);

%State = $TicketObject->TicketStateList(
    UserID => $User{UserID},
    %{ $CheckDataWithoutTicket{Positive} },
);
$Self->IsDeeply(
    \%State,
    \%StateResult,
    "ACL Check TicketStateList() - State",
);

my %TicketState = $TicketObject->TicketStateList(
    UserID   => $User{UserID},
    TicketID => $UTConfig{Positive}{Ticket}{ID},
);
$Self->IsDeeply(
    \%TicketState,
    \%StateResult,
    "ACL Check TicketStateList() - TicketState",
);

my %ServiceResult = (
    $UTConfig{Negative}{Service}{ID} => $UTConfig{Negative}{Service}{Name},
);

my %Service = $TicketObject->TicketServiceList(
    %{ $CheckDataWithoutTicket{Positive} },
    UserID => $User{UserID},
);
$Self->IsDeeply(
    \%Service,
    \%ServiceResult,
    "ACL Check TicketServiceList() - Service",
);

my %TicketService = $TicketObject->TicketServiceList(
    TicketID => $UTConfig{Positive}{Ticket}{ID},
    UserID   => $User{UserID},
);
$Self->IsDeeply(
    \%TicketService,
    \%ServiceResult,
    "ACL Check TicketServiceList() - TicketService",
);

my %SLAResult = (
    $UTConfig{Negative}{SLA}{ID} => $UTConfig{Negative}{SLA}{Name},
);

my %SLA = $TicketObject->TicketSLAList(
    %{ $CheckDataWithoutTicket{Positive} },
    UserID => $User{UserID},
);
$Self->IsDeeply(
    \%SLA,
    \%SLAResult,
    "ACL Check TicketSLAList() - SLA",
);

my %TicketSLA = $TicketObject->TicketSLAList(
    TicketID  => $UTConfig{Positive}{Ticket}{ID},
    ServiceID => $UTConfig{Positive}{Service}{ID},
    UserID    => $User{UserID},
);
$Self->IsDeeply(
    \%TicketSLA,
    \%SLAResult,
    "ACL Check TicketSLAList() - TicketSLA",
);

my %QueueResult = (
    $QueueID2 => $QueueData2{Name},
);

my %Queue = $TicketObject->TicketMoveList(
    %{ $CheckDataWithoutTicket{Positive} },
    UserID => $User{UserID},
);
$Self->IsDeeply(
    \%Queue,
    \%QueueResult,
    "ACL Check TicketMoveList() - Queue",
);

my %TicketQueue = $TicketObject->TicketMoveList(
    TicketID => $UTConfig{Positive}{Ticket}{ID},
    UserID   => $User{UserID},
);
$Self->IsDeeply(
    \%TicketQueue,
    \%QueueResult,
    "ACL Check TicketMoveList() - TicketQueue",
);

DYNAMICFIELDLOOP:
for my $Fieldname ( sort keys %NewDynamicFields ) {

    # skip the loop if we have no fields with defaultvalues
    next DYNAMICFIELDLOOP
        if (
        $NewDynamicFields{$Fieldname}{FieldType}    ne 'Dropdown'
        && $NewDynamicFields{$Fieldname}{FieldType} ne 'Multiselect'
        && $NewDynamicFields{$Fieldname}{FieldType} ne 'Checkbox'
        );
    next DYNAMICFIELDLOOP
        if ( !IsHashRefWithData( $NewDynamicFields{$Fieldname}{Config}{PossibleValues} ) );
    my %DynamicFieldData = map { $_ => $CheckDataWithoutTicket{Positive}{$_} }
        grep { $_ =~ /DynamicField/ } ( sort keys %{ $CheckDataWithoutTicket{Positive} } );

    my $ACL = $TicketObject->TicketAcl(
        %{ $CheckDataWithoutTicket{Positive} },
        DynamicField  => \%DynamicFieldData,
        ReturnType    => 'Ticket',
        ReturnSubType => 'DynamicField_' . $Fieldname,
        Data          => $NewDynamicFields{$Fieldname}{Config}{PossibleValues},
        UserID        => $User{UserID},
    );
    if ($ACL) {
        my %DynamicFieldResult    = $TicketObject->TicketAclData();
        my %DynamicFieldPossibles = (
            $CheckDataWithoutTicket{Negative}{"DynamicField_$Fieldname"} =>
                $NewDynamicFields{$Fieldname}{Config}{PossibleValues}{
                $UTConfig{Negative}{DynamicField}{"DynamicField_$Fieldname"}
                }
        );

        $Self->IsDeeply(
            \%DynamicFieldPossibles,
            \%DynamicFieldResult,
            "ACL Check $Fieldname() -  $Fieldname",
        );
    }

    $ACL = undef;
    $ACL = $TicketObject->TicketAcl(
        TicketID      => $UTConfig{Positive}{Ticket}{ID},
        ReturnType    => 'Ticket',
        ReturnSubType => 'DynamicField_' . $Fieldname,
        Data          => $NewDynamicFields{$Fieldname}{Config}{PossibleValues},
        UserID        => $User{UserID},
    );

    if ($ACL) {
        my %DynamicFieldResult    = $TicketObject->TicketAclData();
        my %DynamicFieldPossibles = (
            $CheckDataWithoutTicket{Negative}{"DynamicField_$Fieldname"} =>
                $NewDynamicFields{$Fieldname}{Config}{PossibleValues}{
                $UTConfig{Negative}{DynamicField}{"DynamicField_$Fieldname"}
                }
        );

        $Self->IsDeeply(
            \%DynamicFieldPossibles,
            \%DynamicFieldResult,
            "ACL Check $Fieldname() - Ticket $Fieldname",
        );
    }
}

$ActivityDialogsArray = [ 'AD3', 'AD5', 'AD6' ];
@ActivityDialogs = $TicketObject->TicketAclActivityDialogData(
    ActivityDialogs => $ActivityDialogsArray,
);

$Self->IsDeeply(
    \@ActivityDialogs,
    ['AD5'],
    "ActivityDialogs Check() - Acl based reduced possible activity dialogs",
);

# ----------------------------------------

# ----------------------------------------
# Destructors to remove our Testitems
# ----------------------------------------

# SLA
for my $Type (qw(Positive Negative)) {
    my $Success = $SLAObject->SLAUpdate(
        ServiceIDs => [],
        SLAID      => $UTConfig{$Type}{SLA}{ID},
        Name       => $UTConfig{$Type}{SLA}{Name},
        Comment    => $UTConfig{$Type}{SLA}{Comment},
        ValidID    => 2,
        UserID     => $User{UserID},
    );

    $Self->True(
        $Success,
        "SLAUpdate() - Invalidate SLA for $Type ACL check."
    );
}

# Service
for my $Type (qw(Positive Negative)) {

    $ServiceObject->CustomerUserServiceMemberAdd(
        CustomerUserLogin => $CustomerUserLogin,
        ServiceID         => $UTConfig{$Type}{Service}{ID},
        Active            => 0,
        UserID            => $User{UserID},
    );

    my $Success = $ServiceObject->ServiceUpdate(
        ServiceID => $UTConfig{$Type}{Service}{ID},
        Name      => $UTConfig{$Type}{Service}{Name},
        Comment   => $UTConfig{$Type}{Service}{Comment},
        ParentID  => 0,
        ValidID   => 2,
        UserID    => $User{UserID},
    );

    $Self->True(
        $Success,
        "ServiceUpdate() - Invalidate service for $Type ACL check."
    );
}

# queue
my $Success = $QueueObject->QueueUpdate(
    %QueueData1,
    QueueID    => $QueueID1,
    FollowUpID => 1,
    ValidID    => 2,
);

$Self->True(
    $Success,
    "QueueUpdate() - Invalidate queue '$QueueData1{Name}' for ACL check."
);

$Success = $QueueObject->QueueUpdate(
    %QueueData2,
    QueueID    => $QueueID2,
    FollowUpID => 1,
    ValidID    => 2,
);

$Self->True(
    $Success,
    "QueueUpdate() - Invalidate queue '$QueueData2{Name}' for ACL check."
);

# ticket
for my $Type (qw(Positive Negative)) {
    my $Delete = $TicketObject->TicketDelete(
        TicketID => $UTConfig{$Type}{Ticket}{ID},
        UserID   => $User{UserID},
    );
    $Self->True(
        $Delete,
        "TicketDelete() - $Type",
    );
}

# dynamic fields
for my $ID (@AddedDynamicFields) {
    my $Success = $DynamicFieldObject->DynamicFieldDelete(
        ID      => $ID,
        UserID  => 1,
        Reorder => 1,
    );

    $Self->True(
        $Success,
        "DynamicFieldDelete() - Remove DynamicField $ID from the system."
    );
}

# ----------------------------------------

1;
