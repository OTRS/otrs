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

my $StandardTemplateObject = Kernel::System::StandardTemplate->new( %{$Self} );

# tests
my @Tests = (
    {
        Name => 'text',
        Add  => {
            Name         => 'text',
            ValidID      => 1,
            Template     => 'Template text',
            ContentType  => 'text/plain; charset=iso-8859-1',
            TemplateType => 'Answer',
            Comment      => 'some comment',
            UserID       => 1,
        },
        AddGet => {
            Name         => 'text',
            ValidID      => 1,
            Template     => 'Template text',
            ContentType  => 'text/plain; charset=iso-8859-1',
            TemplateType => 'Answer',
            Comment      => 'some comment',
        },
        Update => {
            Name         => 'text2',
            ValidID      => 1,
            Template     => 'Template text\'2',
            ContentType  => 'text/plain; charset=utf-8',
            TemplateType => 'Forward',
            Comment      => 'some comment2',
            UserID       => 1,
        },
        UpdateGet => {
            Name         => 'text2',
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
        $Test->{Name},
        "StandardTemplateLookup()",
    );

    # lookup by Name
    my $LookupID = $StandardTemplateObject->StandardTemplateLookup(
        StandardTemplate => $Test->{Name},
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

    my %StandardTemplates          = $StandardTemplateObject->StandardTemplateList();
    my %StandardTemplatesWithTypes = $StandardTemplateObject->StandardTemplateList(
        TemplateTypes => 1,
    );

    $Self->IsNotDeeply(
        \%StandardTemplates,
        \%StandardTemplatesWithTypes,
        "StandardTemplateList() Normal and TemplateTypes"
    );

    for my $TemplateID ( keys %StandardTemplatesWithTypes ) {
        my $Match = 0;
        if (
            $StandardTemplatesWithTypes{$TemplateID}
            =~ m{\A (?: Answer|Forward|Create ) [ ] - [ ] .+ \z}msx
            )
        {
            $Match = 1;
        }
        $Self->True(
            $Match,
            "StandardTemplateList() - TemplateTypes '$StandardTemplatesWithTypes{$TemplateID}' has"
                . " correct format with true"
        );
    }

    # test StandardTemplateList()
    %StandardTemplates = $StandardTemplateObject->StandardTemplateList();
    my %AnswerStandardTemplates = $StandardTemplateObject->StandardTemplateList( Type => 'Answer' );
    my %ForwardStandardTemplates
        = $StandardTemplateObject->StandardTemplateList( Type => 'Forward' );

    $Self->IsNotDeeply(
        \%StandardTemplates,
        \%AnswerStandardTemplates,
        'StandardTemplateList() Full vs just Answer type should be different',
    );
    $Self->IsNotDeeply(
        \%StandardTemplates,
        \%ForwardStandardTemplates,
        'StandardTemplateList() Full vs just Forward type should be different',
    );
    $Self->IsNotDeeply(
        \%AnswerStandardTemplates,
        \%ForwardStandardTemplates,
        'StandardTemplateList() Answer vs Forward type should be different',
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
