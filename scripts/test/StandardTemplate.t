# --
# StandardTemplate.t - StandardTemplate tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::StandardTemplate;
use Kernel::System::UnitTest::Helper;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 0,
);
my $StandardTemplateObject = Kernel::System::StandardTemplate->new( %{$Self} );

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
