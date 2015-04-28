# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject           = $Kernel::OM->Get('Kernel::Config');
my $HelperObject           = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $MainObject             = $Kernel::OM->Get('Kernel::System::Main');
my $StdAttachmentObject    = $Kernel::OM->Get('Kernel::System::StdAttachment');
my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');

# file checks
for my $File (qw(xls txt doc png pdf)) {
    my $Location = $ConfigObject->Get('Home')
        . "/scripts/test/sample/StdAttachment/StdAttachment-Test1.$File";

    my $ContentRef = $MainObject->FileRead(
        Location => $Location,
        Mode     => 'binmode',
    );

    my $Content = ${$ContentRef};

    my $MD5 = $MainObject->MD5sum( String => \$Content );

    my $Add = $StdAttachmentObject->StdAttachmentAdd(
        Name        => 'Some Name 123456798',
        ValidID     => 1,
        Content     => $Content,
        ContentType => 'text/xml',
        Filename    => 'StdAttachment Test1äöüß.' . $File,
        Comment     => 'Some Comment',
        UserID      => 1,
    );

    $Self->True(
        $Add || '',
        "StdAttachmentAdd() - ." . $File,
    );

    my %Data = $StdAttachmentObject->StdAttachmentGet( ID => $Add );
    my $MD5Add = $MainObject->MD5sum( String => \$Data{Content} );

    $Self->Is(
        $MD5    || '',
        $MD5Add || '',
        "StdAttachmentGet() - MD5 ." . $File,
    );
    $Self->Is(
        $Data{Name} || '',
        'Some Name 123456798',
        "StdAttachmentGet() - Name ." . $File,
    );
    $Self->Is(
        $Data{ContentType} || '',
        'text/xml',
        "StdAttachmentGet() - ContentType ." . $File,
    );
    $Self->Is(
        $Data{Comment} || '',
        'Some Comment',
        "StdAttachmentGet() - Comment ." . $File,
    );
    $Self->Is(
        $Data{Filename} || '',
        'StdAttachment Test1äöüß.' . $File,
        "StdAttachmentGet() - Filename ." . $File,
    );

    my $ID = $StdAttachmentObject->StdAttachmentLookup( StdAttachment => 'Some Name 123456798' );
    $Self->Is(
        $ID || '',
        $Add,
        "StdAttachmentLookup() - ID ." . $File,
    );

    my $Name = $StdAttachmentObject->StdAttachmentLookup( StdAttachmentID => $ID );
    $Self->Is(
        $Name || '',
        $Data{Name} || '',
        "StdAttachmentLookup() - Name ." . $File,
    );

    my $Update = $StdAttachmentObject->StdAttachmentUpdate(
        ID          => $ID,
        Name        => 'Some Name',
        ValidID     => 1,
        Content     => $Data{Content},
        ContentType => 'text/html',
        Filename    => 'SomeFile.' . $File,
        Comment     => 'Lala123öäüß',
        UserID      => 1,
    );
    $Self->True(
        $Update || '',
        "StdAttachmentUpdate() - ." . $File,
    );

    %Data = $StdAttachmentObject->StdAttachmentGet( ID => $ID );
    my $MD5Update = $MainObject->MD5sum( String => \$Data{Content} );

    $Self->Is(
        $MD5       || '',
        $MD5Update || '',
        "StdAttachmentGet() - MD5 ." . $File,
    );
    $Self->Is(
        $Data{Name} || '',
        'Some Name',
        "StdAttachmentGet() - Name ." . $File,
    );
    $Self->Is(
        $Data{ContentType} || '',
        'text/html',
        "StdAttachmentGet() - ContentType ." . $File,
    );
    $Self->Is(
        $Data{Comment} || '',
        'Lala123öäüß',
        "StdAttachmentGet() - Comment ." . $File,
    );
    $Self->Is(
        $Data{Filename} || '',
        'SomeFile.' . $File,
        "StdAttachmentGet() - Filename ." . $File,
    );

    $ID = $StdAttachmentObject->StdAttachmentLookup( StdAttachment => 'Some Name' );
    $Self->Is(
        $ID || '',
        $Add,
        "StdAttachmentLookup() - ID ." . $File,
    );

    $Name = $StdAttachmentObject->StdAttachmentLookup( StdAttachmentID => $ID );
    $Self->Is(
        $Name || '',
        $Data{Name} || '',
        "StdAttachmentLookup() - Name ." . $File,
    );

    my $Delete = $StdAttachmentObject->StdAttachmentDelete( ID => $Add );
    $Self->True(
        $Delete || '',
        "StdAttachmentDelete() - ." . $File,
    );
}

# attachment -> templates tests
my $UserID   = 1;
my $RandomID = $HelperObject->GetRandomID();

# create a new attachment
my $Location = $ConfigObject->Get('Home')
    . "/scripts/test/sample/StdAttachment/StdAttachment-Test1.png";

my $ContentRef = $MainObject->FileRead(
    Location => $Location,
    Mode     => 'binmode',
);

my $Content = ${$ContentRef};

my $AttachmentID = $StdAttachmentObject->StdAttachmentAdd(
    Name        => 'Standard Attachment' . $RandomID,
    ValidID     => 1,
    Content     => $Content,
    ContentType => 'text/xml',
    Filename    => 'StdAttachment-Test1.xml',
    Comment     => 'Some Comment',
    UserID      => $UserID,
);

$Self->IsNot(
    $AttachmentID,
    undef,
    "StdAttachmentAdd() - for Attachment -> Template tests | Attachment ID should not be undef",
);

# create a new template
my $TemplateID = $StandardTemplateObject->StandardTemplateAdd(
    Name         => 'New Standard Template' . $RandomID,
    Template     => 'Thank you for your email.',
    ContentType  => 'text/plain; charset=utf-8',
    TemplateType => 'Answer',
    ValidID      => 1,
    UserID       => $UserID,
);

$Self->IsNot(
    $TemplateID,
    undef,
    "StandardTemplateAdd() for Attachment -> Template tests | TemplatID should not be undef",
);

my @Tests = (
    {
        Name    => 'No Params',
        Config  => undef,
        Success => 0,
    },
    {
        Name    => 'Empty Config',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing AttachmentID',
        Config => {
            AttachmentID       => undef,
            StandardTemplateID => $TemplateID,
            Active             => 1,
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Missing StandardTemplateID',
        Config => {
            AttachmentID       => $AttachmentID,
            StandardTemplateID => undef,
            Active             => 1,
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Missing UserID',
        Config => {
            AttachmentID       => $AttachmentID,
            StandardTemplateID => $TemplateID,
            Active             => 1,
            UserID             => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Correct AttachmentID and TemplateID',
        Config => {
            AttachmentID       => $AttachmentID,
            StandardTemplateID => $TemplateID,
            Active             => 1,
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Correct AttachmentID and TemplateID (removal)',
        Config => {
            AttachmentID       => $AttachmentID,
            StandardTemplateID => $TemplateID,
            Active             => 0,
            UserID             => $UserID,
        },
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $Success = $StdAttachmentObject->StdAttachmentStandardTemplateMemberAdd( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->True(
            $Success,
            "$Test->{Name} StdAttachmentStandardTemplateMemberAdd() with true",
        );

        # get assigned templates
        my %Templates = $StdAttachmentObject->StdAttachmentStandardTemplateMemberList(
            AttachmentID => $Test->{Config}->{AttachmentID},
        );

        if ( $Test->{Config}->{Active} ) {
            $Self->IsNot(
                $Templates{$TemplateID} || '',
                '',
                "$Test->{Name} StdAttachmentStandardTemplateMemberList() | $TemplateID should be"
                    . " assingned and must  have a value",
            );
        }
        else {
            $Self->Is(
                $Templates{$TemplateID} || '',
                '',
                "$Test->{Name} StdAttachmentStandardTemplateMemberList() | $TemplateID should not"
                    . " be assingned and must not have a value",
            );
        }
    }
    else {
        $Self->False(
            $Success,
            "$Test->{Name} StdAttachmentStandardTemplateMemberAdd() with false",
        );
    }
}

# add relation to list after wards
my $Success = $StdAttachmentObject->StdAttachmentStandardTemplateMemberAdd(
    AttachmentID       => $AttachmentID,
    StandardTemplateID => $TemplateID,
    Active             => 1,
    UserID             => $UserID
);
$Self->True(
    $Success,
    "StdAttachmentStandardTemplateMemberAdd() for Attachment -> Template tests | with True",
);

@Tests = (
    {
        Name    => 'No Params',
        Config  => undef,
        Success => 0,
    },
    {
        Name    => 'Empty Config',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing AttachmentID and TemplateID',
        Config => {
            AttachmentID       => undef,
            StandardTemplateID => undef,
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'both AttachmentID and TemplateID',
        Config => {
            AttachmentID       => $AttachmentID,
            StandardTemplateID => $TemplateID,
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Correct AttachmentID',
        Config => {
            AttachmentID       => $AttachmentID,
            StandardTemplateID => undef,
            UserID             => $UserID,
        },
        ExpectedResults => {
            $TemplateID => 'New Standard Template' . $RandomID,
        },
        Success => 1,
    },
    {
        Name   => 'Correct TemplateID',
        Config => {
            AttachmentID       => undef,
            StandardTemplateID => $TemplateID,
            UserID             => $UserID,
        },
        ExpectedResults => {
            $AttachmentID => 'Standard Attachment' . $RandomID,
        },
        Success => 1,
    },
);

for my $Test (@Tests) {
    my %List              = $StdAttachmentObject->StdAttachmentStandardTemplateMemberList( %{ $Test->{Config} } );
    my $IsHashRefWithData = IsHashRefWithData( \%List );

    if ( $Test->{Success} ) {
        $Self->True(
            $IsHashRefWithData,
            "$Test->{Name} StdAttachmentStandardTemplateMemberList() | Result sould be a hash"
                . " wiith data",
        );
        $Self->IsDeeply(
            \%List,
            $Test->{ExpectedResults},
            "$Test->{Name} StdAttachmentStandardTemplateMemberList() | Expected results",
        );
    }
    else {
        $Self->False(
            $IsHashRefWithData,
            "$Test->{Name} StdAttachmentStandardTemplateMemberList() | Result sould not be hash"
                . " wiith data",
        );
    }
}

# cleanup

# delete relation
$Success = $StdAttachmentObject->StdAttachmentStandardTemplateMemberAdd(
    AttachmentID       => $AttachmentID,
    StandardTemplateID => $TemplateID,
    Active             => 0,
    UserID             => $UserID
);
$Self->True(
    $Success,
    "StdAttachmentStandardTemplateMemberAdd() removal for Attachment -> Template tests | with True",
);

$Success = $StdAttachmentObject->StdAttachmentDelete( ID => $AttachmentID );
$Self->True(
    $Success,
    "StdAttachemntDelete() for Attachment -> Template tests | with True",
);

$Success = $StandardTemplateObject->StandardTemplateDelete(
    ID => $TemplateID,
);

$Self->True(
    $Success,
    "StandardTemplateDelete() for Attachment -> Template tests | with True",
);

1;
