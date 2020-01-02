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

# get StandardTemplate object
my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

# tests
my @Tests = (
    {
        Name => 'text',
        Add  => {
            Name         => 'text' . $RandomID,
            ValidID      => 1,
            Template     => 'Template text',
            ContentType  => 'text/plain; charset=iso-8859-1',
            TemplateType => 'Answer',
            Comment      => 'some comment',
            UserID       => 1,
        },
        AddSecond => {
            Name         => 'text_second_' . $RandomID,
            ValidID      => 1,
            Template     => 'Template text',
            ContentType  => 'text/plain; charset=iso-8859-1',
            TemplateType => 'Answer',
            Comment      => 'some comment',
            UserID       => 1,
        },
        AddGet => {
            Name         => 'text' . $RandomID,
            ValidID      => 1,
            Template     => 'Template text',
            ContentType  => 'text/plain; charset=iso-8859-1',
            TemplateType => 'Answer',
            Comment      => 'some comment',
        },
        Update => {
            Name         => 'text2' . $RandomID,
            ValidID      => 1,
            Template     => 'Template text\'2',
            ContentType  => 'text/plain; charset=utf-8',
            TemplateType => 'Forward',
            Comment      => 'some comment2',
            UserID       => 1,
        },
        UpdateGet => {
            Name         => 'text2' . $RandomID,
            ValidID      => 1,
            Template     => 'Template text\'2',
            ContentType  => 'text/plain; charset=utf-8',
            TemplateType => 'Forward',
            Comment      => 'some comment2',
        },
    },
);
my @IDs;

for my $Test (@Tests) {

    # add
    my $ID = $StandardTemplateObject->StandardTemplateAdd(
        %{ $Test->{Add} },
    );
    $Self->True(
        $ID,
        "StandardTemplateAdd() - $ID",
    );

    push( @IDs, $ID );

    # add with existing name
    my $IDWrong = $StandardTemplateObject->StandardTemplateAdd(
        %{ $Test->{Add} },
    );
    $Self->False(
        $IDWrong,
        "StandardTemplateAdd() - Try to add the standard template with existing name",
    );

    my %Data = $StandardTemplateObject->StandardTemplateGet(
        ID => $ID,
    );
    for my $Key ( sort keys %{ $Test->{AddGet} } ) {
        $Self->Is(
            $Test->{AddGet}->{$Key},
            $Data{$Key},
            "StandardTemplateGet() - $Key",
        );
    }

    # lookup by ID
    my $Name = $StandardTemplateObject->StandardTemplateLookup(
        StandardTemplateID => $ID
    );
    $Self->Is(
        $Name,
        $Test->{Add}->{Name},
        "StandardTemplateLookup()",
    );

    # lookup by Name
    my $LookupID = $StandardTemplateObject->StandardTemplateLookup(
        StandardTemplate => $Test->{Add}->{Name},
    );
    $Self->Is(
        $ID,
        $LookupID,
        "StandardTemplateLookup()",
    );

    # update
    my $Update = $StandardTemplateObject->StandardTemplateUpdate(
        ID => $ID,
        %{ $Test->{Update} },
    );
    $Self->True(
        $ID,
        "StandardTemplateUpdate()",
    );

    %Data = $StandardTemplateObject->StandardTemplateGet(
        ID => $ID,
    );
    for my $Key ( sort keys %{ $Test->{UpdateGet} } ) {
        $Self->Is(
            $Test->{UpdateGet}->{$Key},
            $Data{$Key},
            "StandardTemplateGet() - $Key",
        );
    }

    # add another standard template
    my $IDSecond = $StandardTemplateObject->StandardTemplateAdd(
        %{ $Test->{AddSecond} },
    );

    push( @IDs, $IDSecond );

    $Self->True(
        $IDSecond,
        "StandardTemplateAdd() - $IDSecond",
    );

    # update with existing name
    my $UpdateWrong = $StandardTemplateObject->StandardTemplateUpdate(
        ID => $IDSecond,
        %{ $Test->{Update} },
    );
    $Self->False(
        $UpdateWrong,
        "StandardTemplateUpdate() - Try to update the standard template with existing name",
    );

    # check function NameExistsCheck()
    # check does it exist a standard template with certain Name or
    # check is it possible to set Name for standard template with certain ID
    my $Exist = $StandardTemplateObject->NameExistsCheck(
        Name => $Test->{AddSecond}->{Name},
    );

    $Self->True(
        $Exist,
        "NameExistsCheck() - A standard template with \'$Test->{AddSecond}->{Name}\' already exists!",
    );

    # there is a standard template with certain name, now check if there is another one
    $Exist = $StandardTemplateObject->NameExistsCheck(
        Name => "$Test->{AddSecond}->{Name}",
        ID   => $IDSecond,
    );

    $Self->False(
        $Exist,
        "NameExistsCheck() - Another standard template \'$Test->{AddSecond}->{Name}\' for ID=$IDSecond does not exist!",
    );

    $Exist = $StandardTemplateObject->NameExistsCheck(
        Name => $Test->{AddSecond}->{Name},
        ID   => $ID,
    );

    $Self->True(
        $Exist,
        "NameExistsCheck() - Another standard template \'$Test->{AddSecond}->{Name}\' for ID=$ID already exists!",
    );

    # check is there a standard template whose name has been updated in the meantime
    $Exist = $StandardTemplateObject->NameExistsCheck(
        Name => "$Test->{Add}->{Name}",
    );

    $Self->False(
        $Exist,
        "NameExistsCheck() - A standard template with \'$Test->{Add}->{Name}\' does not exist!",
    );

    $Exist = $StandardTemplateObject->NameExistsCheck(
        Name => "$Test->{Add}->{Name}",
        ID   => $ID,
    );

    $Self->False(
        $Exist,
        "NameExistsCheck() - Another standard template \'$Test->{Add}->{Name}\' for ID=$ID does not exist!",
    );

    # test StandardTemplateList()
    my %StandardTemplates        = $StandardTemplateObject->StandardTemplateList();
    my %AnswerStandardTemplates  = $StandardTemplateObject->StandardTemplateList( Type => 'Answer' );
    my %ForwardStandardTemplates = $StandardTemplateObject->StandardTemplateList( Type => 'Forward' );

    $Self->IsNotDeeply(
        \%StandardTemplates,
        \%AnswerStandardTemplates,
        'StandardTemplateList() - Full vs just Answer type should be different',
    );
    $Self->IsNotDeeply(
        \%StandardTemplates,
        \%ForwardStandardTemplates,
        'StandardTemplateList() - Full vs just Forward type should be different',
    );
    $Self->IsNotDeeply(
        \%AnswerStandardTemplates,
        \%ForwardStandardTemplates,
        'StandardTemplateList() - Answer vs Forward type should be different',
    );

    # test with not only valid templates
    my %AllStandardTemplates = $StandardTemplateObject->StandardTemplateList( Valid => 0 );
    $Self->IsNotDeeply(
        \%AllStandardTemplates,
        {},
        'StandardTemplateList() - All templates is not an empty hash',
    );
    my %AllAnswerStandardTemplatess = $StandardTemplateObject->StandardTemplateList(
        Valid => 0,
        Type  => 'Answer',
    );
    $Self->IsNotDeeply(
        \%AllAnswerStandardTemplatess,
        {},
        'StandardTemplateList() - All Answer is not an empty hash',
    );

    # delete created standard template
    for my $ID (@IDs) {
        my $Delete = $StandardTemplateObject->StandardTemplateDelete(
            ID => $ID,
        );
        $Self->True(
            $Delete,
            "StandardTemplateDelete() -  $ID ",
        );
    }
}

# cleanup is done by RestoreDatabase

1;
