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

use vars (qw($Self %Param));

use Kernel::System::ObjectManager;

# get needed objects
my $ProviderObject = $Kernel::OM->Get('Kernel::Output::Template::Provider');

my @Tests = (
    {
        Name => '$Data',
        DTL  => '$Data{"Name"}',
        TT   => '[% Data.Name %]',
    },
    {
        Name => '$QData',
        DTL  => '$QData{"Name"}',
        TT   => '[% Data.Name | html %]',
    },
    {
        Name => '$QData with complex name',
        DTL  => '$QData{"Name::Sub"}',
        TT   => '[% Data.item("Name::Sub") | html %]',
    },
    {
        Name => '$QData with length',
        DTL  => '$QData{"Name", "33"}',
        TT   => '[% Data.Name | truncate(33) | html %]',
    },
    {
        Name => '$LQData',
        DTL  => '$LQData{"Name"}',
        TT   => '[% Data.Name | uri %]',
    },
    {
        Name => '$Config',
        DTL  => '$Config{"Complex::Name"}',
        TT   => '[% Config("Complex::Name") %]',
    },
    {
        Name => '$Env',
        DTL  => '$Env{"Name"}',
        TT   => '[% Env("Name") %]',
    },
    {
        Name => '$QEnv',
        DTL  => '$QEnv{"Name"}',
        TT   => '[% Env("Name") | html %]',
    },
    {
        Name => '$TimeLong',
        DTL  => '$TimeLong{"$Data{"CreateTime"}"}',
        TT   => '[% Data.CreateTime | Localize("TimeLong") %]',
    },
    {
        Name => '$TimeLong with $QData',
        DTL  => '$TimeLong{"$QData{"CreateTime"}"}',
        TT   => '[% Data.CreateTime | Localize("TimeLong") %]',
    },
    {
        Name => '$TimeShort',
        DTL  => '$TimeShort{"$Data{"CreateTime"}"}',
        TT   => '[% Data.CreateTime | Localize("TimeShort") %]',
    },
    {
        Name => '$Date',
        DTL  => '$Date{"$Data{"CreateTime"}"}',
        TT   => '[% Data.CreateTime | Localize("Date") %]',
    },
    {
        Name => '$Quote $Config',
        DTL  => '$Quote{"$Config{"Name"}"}',
        TT   => '[% Config("Name") | html %]',
    },
    {
        Name => '$Quote $Env',
        DTL  => '$Quote{"$Env{"Name"}"}',
        TT   => '[% Env("Name") | html %]',
    },
    {
        Name => '$Quote $Data',
        DTL  => '$Quote{"$Data{"Name"}"}',
        TT   => '[% Data.Name | html %]',
    },
    {
        Name => '$Quote $Data with length',
        DTL  => '$Quote{"$Data{"Name"}", "33"}',
        TT   => '[% Data.Name | truncate(33) | html %]',
    },
    {
        Name => '$Quote $Data with dynamic length',
        DTL  => '$Quote{"$Data{"Name"}", "$QData{"MaxLength"}"}',
        TT   => '[% Data.Name | truncate(Data.MaxLength) | html %]',
    },
    {
        Name => '$Quote $Text with fixed length',
        DTL  => '$Quote{"$Text{"$Data{"Name"}"}", "20"}',
        TT   => '[% Data.Name | Translate | truncate(20) | html %]',
    },
    {
        Name => '$Quote $Text with dynamic length',
        DTL  => '$Quote{"$Text{"$Data{"Name"}"}", "$QData{"MaxLength"}"}',
        TT   => '[% Data.Name | Translate | truncate(Data.MaxLength) | html %]',
    },
    {
        Name => 'dtl:js_on_document_complete',
        DTL  => '
<!-- dtl:js_on_document_complete -->
<script type="text/javascript">
console.log(123);
console.log(123);
</script>
<!-- dtl:js_on_document_complete -->',
        TT => '
[% WRAPPER JSOnDocumentComplete %]
<script type="text/javascript">
console.log(123);
console.log(123);
</script>
[% END %]',
    },
    {
        Name => 'dtl:js_on_document_complete_placeholder',
        DTL  => '<!-- dtl:js_on_document_complete_placeholder -->',
        TT   => '[% PROCESS JSOnDocumentCompleteInsert %]',
    },
    {
        Name => 'empty $Text',
        DTL  => '$Text{""}',
        TT   => '',
    },
    {
        Name => 'simple $Text',
        DTL  => '$Text{"Name"}',
        TT   => '[% Translate("Name") | html %]',
    },
    {
        Name => 'simple $Text with wrong delimiters',
        DTL  => '$Text{\'Name\'}',
        TT   => '[% Translate("Name") | html %]',
    },
    {
        Name => 'simple $Text with special chars',
        DTL  => '$Text{"Name " \'"}',
        TT   => '[% Translate("Name \\" \'") | html %]',
    },
    {
        Name => '$Text with placeholders',
        DTL  => '$Text{"Name"}',
        TT   => '[% Translate("Name") | html %]',
    },
    {
        Name => '$Text with placeholders',
        DTL  => '$Text{"Name %s", "Name2"}',
        TT   => '[% Translate("Name %s", "Name2") | html %]',
    },
    {
        Name => '$Text with dynamic placeholder',
        DTL  => '$Text{"Name %s", "$QData{"Name2"}"}',
        TT   => '[% Translate("Name %s", Data.Name2) | html %]',
    },
    {
        Name => '$Text with config string',
        DTL  => '$Text{"$Config{"Name"}"}',
        TT   => '[% Translate(Config("Name")) | html %]',
    },
    {
        Name => '$Text with config placeholder',
        DTL  => '$Text{"Name %s", "$Config{"Name2"}"}',
        TT   => '[% Translate("Name %s", Config("Name2")) | html %]',
    },
    {
        Name => '$Text with env placeholder',
        DTL  => '$Text{"Name %s", "$QEnv{"Name2"}"}',
        TT   => '[% Translate("Name %s", Env("Name2")) | html %]',
    },
    {
        Name => '$Text with time placeholder',
        DTL  => '$Text{"Name %s", "$TimeShort{"$QData{"CreateTime"}"}"}',
        TT   => '[% Translate("Name %s", Localize(Data.CreateTime, "TimeShort")) | html %]',
    },
    {
        Name => '$Text with time placeholder',
        DTL  => '$Text{"Name %s", "$TimeLong{"$QData{"CreateTime"}"}"}',
        TT   => '[% Translate("Name %s", Localize(Data.CreateTime, "TimeLong")) | html %]',
    },
    {
        Name => '$Text with time placeholder',
        DTL  => '$Text{"Name %s", "$Date{"$QData{"CreateTime"}"}"}',
        TT   => '[% Translate("Name %s", Localize(Data.CreateTime, "Date")) | html %]',
    },
    {
        Name => '$Text with dynamic placeholders',
        DTL  => '$Text{"Name %s %s", "$QData{"Name2"}", "$QData{"Name3"}"}',
        TT   => '[% Translate("Name %s %s", Data.Name2, Data.Name3) | html %]',
    },
    {
        Name => 'simple $JSText',
        DTL  => '\'$JSText{"Name"}\'',
        TT   => '[% Translate("Name") | JSON %]',
    },
    {
        Name => '$JSText with a dot',
        DTL  => '\'$JSText{"Simple sentence"}.\'',
        TT   => '[% Translate("Simple sentence.") | JSON %]',
    },
    {
        Name => '$JSText with wrong delimiters',
        DTL  => '"$JSText{"Name"}"',
        TT   => '[% Translate("Name") | JSON %]',
    },
    {
        Name => '$JSText with placeholders',
        DTL  => '\'$JSText{"Name %s", "Name2"}\'',
        TT   => '[% Translate("Name %s", "Name2") | JSON %]',
    },
    {
        Name => '$JSText with dynamic placeholder',
        DTL  => '\'$JSText{"Name %s", "$QData{"Name2"}"}\'',
        TT   => '[% Translate("Name %s", Data.Name2) | JSON %]',
    },
    {
        Name => '$JSText with config placeholder',
        DTL  => '\'$JSText{"Name %s", "$Config{"Name2"}"}\'',
        TT   => '[% Translate("Name %s", Config("Name2")) | JSON %]',
    },
    {
        Name => '$JSText with dynamic placeholders',
        DTL  => '\'$JSText{"Name %s %s", "$QData{"Name2"}", "$QData{"Name3"}"}\'',
        TT   => '[% Translate("Name %s %s", Data.Name2, Data.Name3) | JSON %]',
    },
    {
        Name => '$Include',
        DTL  => '$Include{"Datepicker"}',
        TT   => '[% InsertTemplate("Datepicker.tt") %]',
    },
    {
        Name => 'dtl:block',
        DTL  => '
<!-- dtl:block:b1 -->
<!-- dtl:block:b11 -->
<!-- dtl:block:b11 -->
<!-- dtl:block:b12 -->
<!-- dtl:block:b12 -->
<!-- dtl:block:b1 -->
<!-- dtl:block:b2 -->
<!-- dtl:block:b2 -->
#<!-- dtl:block:b2 -->
#<!-- dtl:block:b2 -->',
        TT => '
[% RenderBlockStart("b1") %]
[% RenderBlockStart("b11") %]
[% RenderBlockEnd("b11") %]
[% RenderBlockStart("b12") %]
[% RenderBlockEnd("b12") %]
[% RenderBlockEnd("b1") %]
[% RenderBlockStart("b2") %]
[% RenderBlockEnd("b2") %]
#[% RenderBlockStart("b2") %]
#[% RenderBlockEnd("b2") %]',
    },
);

for my $Test (@Tests) {

    my $TT = $ProviderObject->MigrateDTLtoTT(
        Content => $Test->{DTL},
    );

    $Self->Is(
        $TT,
        $Test->{TT},
        $Test->{Name},
    );
}

1;
