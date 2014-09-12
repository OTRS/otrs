# --
# StandardTemplate.t - StandardTemplate tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $HelperObject           = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');

my $RandomID = $HelperObject->GetRandomID();

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

for my $Test (@Tests) {

    # add
    my $ID = $StandardTemplateObject->StandardTemplateAdd(
        %{ $Test->{Add} },
    );
    $Self->True(
        $ID,
        "StandardTemplateAdd()",
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

    # test StandardTemplateList()
    my %StandardTemplates = $StandardTemplateObject->StandardTemplateList();
    my %AnswerStandardTemplates = $StandardTemplateObject->StandardTemplateList( Type => 'Answer' );
    my %ForwardStandardTemplates
        = $StandardTemplateObject->StandardTemplateList( Type => 'Forward' );

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

    # delete
    my $Delete = $StandardTemplateObject->StandardTemplateDelete(
        ID => $ID,
    );
    $Self->True(
        $ID,
        "StandardTemplateDelete()",
    );
}

1;
