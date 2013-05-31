# --
# TicketSubject.t - ticket module testscript
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use utf8;
use vars (qw($Self));

use Kernel::Config;
use Kernel::System::Ticket;

# create local objects
my $ConfigObject = Kernel::Config->new();
my $UserObject   = Kernel::System::User->new(
    ConfigObject => $ConfigObject,
    %{$Self},
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

for my $TicketHook ( 'Ticket#', 'Call#', 'Ticket' ) {
    for my $TicketSubjectConfig ( 'Right', 'Left' ) {

        $ConfigObject->Set(
            Key   => 'Ticket::Hook',
            Value => $TicketHook,
        );
        $ConfigObject->Set(
            Key   => 'Ticket::SubjectFormat',
            Value => $TicketSubjectConfig,
        );
        $ConfigObject->Set(
            Key   => 'Ticket::NumberGenerator',
            Value => 'Kernel::System::Ticket::Number::DateChecksum',
        );

        my $TicketObject = Kernel::System::Ticket->new(
            %{$Self},
            ConfigObject => $ConfigObject,
        );

        # check GetTNByString
        my $Tn = $TicketObject->TicketCreateNumber() || 'NONE!!!';
        my $String = 'Re: ' . $TicketObject->TicketSubjectBuild(
            TicketNumber => $Tn,
            Subject      => 'Some Test',
        );
        my $TnGet = $TicketObject->GetTNByString($String) || 'NOTHING FOUND!!!';
        $Self->Is(
            $TnGet,
            $Tn,
            "GetTNByString() (DateChecksum: true eq)",
        );
        $Self->IsNot(
            $TicketObject->GetTNByString('Ticket#: 200206231010138') || '',
            $Tn,
            "GetTNByString() (DateChecksum: false eq)",
        );
        $Self->False(
            $TicketObject->GetTNByString("Ticket#: 1234567") || 0,
            "GetTNByString() (DateChecksum: false)",
        );

        # TicketSubjectClean()
        # check Ticket::SubjectRe with "RE"
        $ConfigObject->Set(
            Key   => 'Ticket::SubjectRe',
            Value => 'RE',
        );
        my $NewSubject = $TicketObject->TicketSubjectClean(
            TicketNumber => '2004040510440485',
            Subject      => 'Re: [Ticket#: 2004040510440485] Re: RE: Some Subject',
        );
        if ( $NewSubject !~ /^Re:/ ) {
            $Self->True(
                1,
                "TicketSubjectClean() (Re: $NewSubject)",
            );
        }
        else {
            $Self->True(
                0,
                "TicketSubjectClean() (Re: $NewSubject)",
            );
        }

        # TicketSubjectClean()
        $NewSubject = $TicketObject->TicketSubjectClean(
            TicketNumber => '2004040510440485',
            Subject => 'Re[5]: [' . $TicketHook . ': 2004040510440485] Re: RE: WG: Some Subject',
        );
        if ( $NewSubject !~ /^(Re:|\[$TicketHook)/ ) {
            $Self->True(
                1,
                "TicketSubjectClean() (Re[5]: $NewSubject)",
            );
        }
        else {
            $Self->True(
                0,
                "TicketSubjectClean() (Re[5]: $NewSubject)",
            );
        }

        # TicketSubjectClean()
        $NewSubject = $TicketObject->TicketSubjectClean(
            TicketNumber => '2004040510440485',
            Subject => 'Re[5]: Re: RE: WG: Some Subject [' . $TicketHook . ': 2004040510440485]',
        );
        if ( $NewSubject !~ /2004040510440485/ ) {
            $Self->True(
                1,
                "TicketSubjectClean() (Re[5]: $NewSubject)",
            );
        }
        else {
            $Self->True(
                0,
                "TicketSubjectClean() (Re[5]: $NewSubject)",
            );
        }

        # TicketSubjectBuild()
        $NewSubject = $TicketObject->TicketSubjectBuild(
            TicketNumber => '2004040510440485',
            Subject      => "Re: [$TicketHook: 2004040510440485] Re: RE: WG: Some Subject",
        );
        if ( $TicketSubjectConfig eq 'Left' ) {
            $Self->Is(
                $NewSubject,
                'RE: [' . $TicketHook . '2004040510440485] Some Subject',
                "TicketSubjectBuild() $TicketSubjectConfig ($NewSubject)",
            );
        }
        else {
            $Self->Is(
                $NewSubject,
                'RE: Some Subject [' . $TicketHook . '2004040510440485]',
                "TicketSubjectBuild() $TicketSubjectConfig ($NewSubject)",
            );
        }

        # check Ticket::SubjectRe with "Antwort"
        $ConfigObject->Set(
            Key   => 'Ticket::SubjectRe',
            Value => 'Antwort',
        );
        $NewSubject = $TicketObject->TicketSubjectClean(
            TicketNumber => '2004040510440485',
            Subject      => 'Antwort: ['
                . $TicketHook
                . ': 2004040510440485] Antwort: Antwort: Some Subject2',
        );
        if ( $NewSubject !~ /^(Antwort:|\[Ticket)/ ) {
            $Self->True(
                1,
                "TicketSubjectClean() (Antwort: $NewSubject)",
            );
        }
        else {
            $Self->True(
                0,
                "TicketSubjectClean() (Antwort: $NewSubject)",
            );
        }

        # TicketSubjectBuild()
        $NewSubject = $TicketObject->TicketSubjectBuild(
            TicketNumber => '2004040510440485',
            Subject => '[' . $TicketHook . ':2004040510440485] Antwort: Re: Antwort: Some Subject2',
        );
        if ( $TicketSubjectConfig eq 'Left' ) {
            $Self->Is(
                $NewSubject,
                'Antwort: [' . $TicketHook . '2004040510440485] Re: Antwort: Some Subject2',
                "TicketSubjectBuild() $TicketSubjectConfig ($NewSubject)",
            );
        }
        else {
            $Self->Is(
                $NewSubject,
                'Antwort: Re: Antwort: Some Subject2 [' . $TicketHook . '2004040510440485]',
                "TicketSubjectBuild() $TicketSubjectConfig ($NewSubject)",
            );
        }

        # check Ticket::SubjectRe with "Antwort"
        $ConfigObject->Set(
            Key   => 'Ticket::SubjectRe',
            Value => '',
        );
        $NewSubject = $TicketObject->TicketSubjectClean(
            TicketNumber => '2004040510440485',
            Subject      => 'RE: ['
                . $TicketHook
                . ': 2004040510440485] Antwort: Antwort: Some Subject2',
        );
        if ( $NewSubject !~ /^(\[Ticket:#: 2004040510440485\].+?|RE\s)/ ) {
            $Self->True(
                1,
                "TicketSubjectClean() ($NewSubject)",
            );
        }
        else {
            $Self->True(
                0,
                "TicketSubjectClean() ($NewSubject)",
            );
        }

        # TicketSubjectBuild()
        $NewSubject = $TicketObject->TicketSubjectBuild(
            TicketNumber => '2004040510440485',
            Subject => 'Re: [' . $TicketHook . ': 2004040510440485] Re: Antwort: Some Subject2',
        );
        if ( $TicketSubjectConfig eq 'Left' ) {
            $Self->Is(
                $NewSubject,
                '[' . $TicketHook . '2004040510440485] Antwort: Some Subject2',
                "TicketSubjectBuild() $TicketSubjectConfig ($NewSubject)",
            );
        }
        else {
            $Self->Is(
                $NewSubject,
                'Antwort: Some Subject2 [' . $TicketHook . '2004040510440485]',
                "TicketSubjectBuild() $TicketSubjectConfig ($NewSubject)",
            );
        }

        # TicketSubjectClean()
        # check Ticket::SubjectFwd with "FWD"
        $ConfigObject->Set(
            Key   => 'Ticket::SubjectFwd',
            Value => 'FWD',
        );

        # TicketSubjectBuild()
        $NewSubject = $TicketObject->TicketSubjectBuild(
            TicketNumber => '2004040510440485',
            Subject      => "Re: [$TicketHook: 2004040510440485] Re: RE: WG: Some Subject",
            Action       => 'Forward',
        );
        if ( $TicketSubjectConfig eq 'Left' ) {
            $Self->Is(
                $NewSubject,
                'FWD: [' . $TicketHook . '2004040510440485] Some Subject',
                "TicketSubjectBuild() $TicketSubjectConfig ($NewSubject)",
            );
        }
        else {
            $Self->Is(
                $NewSubject,
                'FWD: Some Subject [' . $TicketHook . '2004040510440485]',
                "TicketSubjectBuild() $TicketSubjectConfig ($NewSubject)",
            );
        }

        # check Ticket::SubjectFwd with "WG"
        $ConfigObject->Set(
            Key   => 'Ticket::SubjectFwd',
            Value => 'WG',
        );
        $NewSubject = $TicketObject->TicketSubjectClean(
            TicketNumber => '2004040510440485',
            Subject      => 'Antwort: ['
                . $TicketHook
                . ': 2004040510440485] WG: Fwd: Some Subject2',
            Action => 'Forward',
        );
        if ( $NewSubject !~ /^(WG:|\[Ticket)/ ) {
            $Self->True(
                1,
                "TicketSubjectClean() (WG: $NewSubject)",
            );
        }
        else {
            $Self->True(
                0,
                "TicketSubjectClean() (Antwort: $NewSubject)",
            );
        }
    }
}

1;
