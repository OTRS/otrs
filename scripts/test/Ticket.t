# --
# Ticket.t - ticket module testscript
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: Ticket.t,v 1.42 2009-01-22 20:03:18 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use utf8;
use Kernel::System::Ticket;
use Kernel::System::Queue;

my $Hook = $Self->{ConfigObject}->Get('Ticket::Hook');

$Self->{ConfigObject}->Set(
    Key   => 'Ticket::NumberGenerator',
    Value => 'Kernel::System::Ticket::Number::DateChecksum',
);
$Self->{TicketObject} = Kernel::System::Ticket->new( %{$Self} );
$Self->{QueueObject}  = Kernel::System::Queue->new( %{$Self} );
my $Tn = $Self->{TicketObject}->TicketCreateNumber() || 'NONE!!!';
my $String = "Re: " . $Self->{TicketObject}->TicketSubjectBuild(
    TicketNumber => $Tn,
    Subject      => 'Some Test',
);
my $TnGet = $Self->{TicketObject}->GetTNByString($String) || 'NOTHING FOUND!!!';
$Self->Is(
    $TnGet,
    $Tn,
    "GetTNByString() (DateChecksum: true eq)",
);
$Self->IsNot(
    $Self->{TicketObject}->GetTNByString('Ticket#: 200206231010138') || '',
    $Tn,
    "GetTNByString() (DateChecksum: false eq)",
);
$Self->False(
    $Self->{TicketObject}->GetTNByString("Ticket#: 1234567") || 0,
    "GetTNByString() (DateChecksum: false)",
);
my $OldTicketSubjectRe = $Self->{ConfigObject}->Get('Ticket::SubjectRe');
$Self->{ConfigObject}->Set(
    Key   => 'Ticket::SubjectRe',
    Value => 'RE',
);
my $NewSubject = $Self->{TicketObject}->TicketSubjectClean(
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
$NewSubject = $Self->{TicketObject}->TicketSubjectClean(
    TicketNumber => '2004040510440485',
    Subject      => 'Re[5]: [Ticket#: 2004040510440485] Re: RE: WG: Some Subject',
);
if ( $NewSubject !~ /^Re:/ ) {
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
$Self->{ConfigObject}->Set(
    Key   => 'Ticket::SubjectRe',
    Value => 'Antwort',
);
$NewSubject = $Self->{TicketObject}->TicketSubjectClean(
    TicketNumber => '2004040510440485',
    Subject      => 'Antwort: [Ticket#: 2004040510440485] Antwort: Antwort: Some Subject2',
);
if ( $NewSubject !~ /^Antwort:/ ) {
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
$Self->{ConfigObject}->Set(
    Key   => 'Ticket::SubjectRe',
    Value => $OldTicketSubjectRe,
);

my $TicketID = $Self->{TicketObject}->TicketCreate(
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    'TicketCreate()',
);

my %Ticket = $Self->{TicketObject}->TicketGet(
    TicketID => $TicketID,
);
$Self->Is(
    $Ticket{Title},
    'Some Ticket Title',
    'TicketGet() (Title)',
);
$Self->Is(
    $Ticket{Queue},
    'Raw',
    'TicketGet() (Queue)',
);
$Self->Is(
    $Ticket{Priority},
    '3 normal',
    'TicketGet() (Priority)',
);
$Self->Is(
    $Ticket{State},
    'closed successful',
    'TicketGet() (State)',
);
$Self->Is(
    $Ticket{Owner},
    'root@localhost',
    'TicketGet() (Owner)',
);
$Self->Is(
    $Ticket{Responsible},
    'root@localhost',
    'TicketGet() (Responsible)',
);
$Self->Is(
    $Ticket{Lock},
    'unlock',
    'TicketGet() (Lock)',
);
$Self->Is(
    $Ticket{ServiceID},
    '',
    'TicketGet() (ServiceID)',
);
$Self->Is(
    $Ticket{SLAID},
    '',
    'TicketGet() (SLAID)',
);
$Self->Is(
    $Ticket{TypeID},
    '1',
    'TicketGet() (TypeID)',
);

my $ArticleID = $Self->{TicketObject}->ArticleCreate(
    TicketID    => $TicketID,
    ArticleType => 'note-internal',
    SenderType  => 'agent',
    From =>
        'Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent <email@example.com>',
    To =>
        'Some Customer A Some Customer A Some Customer A Some Customer A Some Customer A Some Customer A  Some Customer ASome Customer A Some Customer A <customer-a@example.com>',
    Cc =>
        'Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B <customer-b@example.com>',
    ReplyTo =>
        'Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B <customer-b@example.com>',
    Subject =>
        'some short description some short description some short description some short description some short description some short description some short description some short description ',
    Body => 'the message text
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.

Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.

Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.

Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.

Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.

Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.

Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.

Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.

Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.

Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.

Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.

Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.

Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.

Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.

Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.

Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
',

    #    MessageID => '<asdasdasd.123@example.com>',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify => 1,    # if you don't want to send agent notifications
);

$Self->True(
    $ArticleID,
    'ArticleCreate()',
);

my %Article = $Self->{TicketObject}->ArticleGet(
    ArticleID => $ArticleID,
);
$Self->Is(
    $Article{Title},
    'Some Ticket Title',
    'ArticleGet()',
);
$Self->True(
    $Article{From} eq
        'Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent <email@example.com>',
    'ArticleGet()',
);

# ticket watch tests
my $Subscribe = $Self->{TicketObject}->TicketWatchSubscribe(
    TicketID    => $TicketID,
    WatchUserID => 1,
    UserID      => 1,
);
$Self->True(
    $Subscribe || 0,
    'TicketWatchSubscribe()',
);
my $Unsubscribe = $Self->{TicketObject}->TicketWatchUnsubscribe(
    TicketID    => $TicketID,
    WatchUserID => 1,
    UserID      => 1,
);
$Self->True(
    $Unsubscribe || 0,
    'TicketWatchUnsubscribe()',
);

# add new subscription (will be deleted by TicketDelete(), also check foreign keys)
$Subscribe = $Self->{TicketObject}->TicketWatchSubscribe(
    TicketID    => $TicketID,
    WatchUserID => 1,
    UserID      => 1,
);
$Self->True(
    $Subscribe || 0,
    'TicketWatchSubscribe()',
);

# Check the TicketFreeField functions
my %TicketFreeText = ();
for ( 1 .. 16 ) {
    my $TicketFreeTextSet = $Self->{TicketObject}->TicketFreeTextSet(
        Counter  => $_,
        Key      => 'Planet' . $_,
        Value    => 'Sun' . $_,
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $TicketFreeTextSet,
        'TicketFreeTextSet() ' . $_,
    );
}

%TicketFreeText = $Self->{TicketObject}->TicketGet(
    TicketID => $TicketID,
);
for ( 1 .. 16 ) {
    $Self->Is(
        $TicketFreeText{ 'TicketFreeKey' . $_ },
        'Planet' . $_,
        "TicketGet() (TicketFreeKey$_)",
    );
    $Self->Is(
        $TicketFreeText{ 'TicketFreeText' . $_ },
        'Sun' . $_,
        "TicketGet() (TicketFreeText$_)",
    );
}

# TicketFreeTextSet check, if only a value is available but no key
for ( 1 .. 16 ) {
    my $TicketFreeTextSet = $Self->{TicketObject}->TicketFreeTextSet(
        Counter  => $_,
        Value    => 'Earth' . $_,
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $TicketFreeTextSet,
        'TicketFreeTextSet () without key ' . $_,
    );
}

%TicketFreeText = $Self->{TicketObject}->TicketGet(
    TicketID => $TicketID,
);

for ( 1 .. 16 ) {
    $Self->Is(
        $TicketFreeText{ 'TicketFreeKey' . $_ },
        'Planet' . $_,
        "TicketGet() (TicketFreeKey$_)",
    );
    $Self->Is(
        $TicketFreeText{ 'TicketFreeText' . $_ },
        'Earth' . $_,
        "TicketGet() (TicketFreeText$_)",
    );
}

# TicketFreeTextSet check, if only a key is available but no value
for ( 1 .. 16 ) {
    my $TicketFreeTextSet = $Self->{TicketObject}->TicketFreeTextSet(
        Counter  => $_,
        Key      => 'Location' . $_,
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $TicketFreeTextSet,
        'TicketFreeTextSet () without value ' . $_,
    );
}

%TicketFreeText = $Self->{TicketObject}->TicketGet(
    TicketID => $TicketID,
);

for ( 1 .. 16 ) {
    $Self->Is(
        $TicketFreeText{ 'TicketFreeKey' . $_ },
        'Location' . $_,
        "TicketGet() (TicketFreeKey$_)",
    );
    $Self->Is(
        $TicketFreeText{ 'TicketFreeText' . $_ },
        'Earth' . $_,
        "TicketGet() (TicketFreeText$_)",
    );
}

# TicketFreeTextSet check, if no key and value
for ( 1 .. 16 ) {
    my $TicketFreeTextSet = $Self->{TicketObject}->TicketFreeTextSet(
        Counter  => $_,
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $TicketFreeTextSet,
        'TicketFreeTextSet () without key and value ' . $_,
    );
}

%TicketFreeText = $Self->{TicketObject}->TicketGet(
    TicketID => $TicketID,
);
for ( 1 .. 16 ) {
    $Self->Is(
        $TicketFreeText{ 'TicketFreeKey' . $_ },
        'Location' . $_,
        "TicketGet() (TicketFreeKey$_)",
    );
    $Self->Is(
        $TicketFreeText{ 'TicketFreeText' . $_ },
        'Earth' . $_,
        "TicketGet() (TicketFreeText$_)",
    );
}

# TicketFreeTextSet check, with empty keys and values
for ( 1 .. 16 ) {
    my $TicketFreeTextSet = $Self->{TicketObject}->TicketFreeTextSet(
        Counter  => $_,
        TicketID => $TicketID,
        Key      => '',
        Value    => '',
        UserID   => 1,
    );
    $Self->True(
        $TicketFreeTextSet,
        'TicketFreeTextSet () with empty key and value ' . $_,
    );
}

%TicketFreeText = $Self->{TicketObject}->TicketGet(
    TicketID => $TicketID,
);
for ( 1 .. 16 ) {
    $Self->Is(
        $TicketFreeText{ 'TicketFreeKey' . $_ },
        '',
        "TicketGet() (TicketFreeKey$_)",
    );
    $Self->Is(
        $TicketFreeText{ 'TicketFreeText' . $_ },
        '',
        "TicketGet() (TicketFreeText$_)",
    );
}

for ( 1 .. 16 ) {
    my $TicketFreeTextSet = $Self->{TicketObject}->TicketFreeTextSet(
        Counter  => $_,
        Key      => 'Hans' . $_,
        Value    => 'Max' . $_,
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $TicketFreeTextSet,
        'TicketFreeTextSet() ' . $_,
    );
}

# Check the TicketFreeTime functions
my %TicketFreeTime = ();
for ( 1 .. 5 ) {
    my $TicketFreeTimeSet = $Self->{TicketObject}->TicketFreeTimeSet(
        Counter          => $_,
        Prefix           => 'a',
        "a$_" . "Year"   => 2008,
        "a$_" . "Month"  => 2,
        "a$_" . "Day"    => 25,
        "a$_" . "Hour"   => 22,
        "a$_" . "Minute" => $_,
        TicketID         => $TicketID,
        UserID           => 1,
    );
    $Self->True(
        $TicketFreeTimeSet,
        'TicketFreeTimeSet() ' . $_,
    );
}

%TicketFreeTime = $Self->{TicketObject}->TicketGet(
    TicketID => $TicketID,
);
for ( 1 .. 5 ) {
    $Self->Is(
        $TicketFreeTime{ 'TicketFreeTime' . $_ },
        "2008-02-25 22:0$_:00",
        "TicketGet() (TicketFreeTime$_)",
    );
}
my @ArticleFreeTime = $Self->{TicketObject}->ArticleGet(
    TicketID => $TicketID,
);
for ( 1 .. 5 ) {
    $Self->Is(
        $ArticleFreeTime[0]->{ 'TicketFreeTime' . $_ },
        "2008-02-25 22:0$_:00",
        "ArticleGet() (TicketFreeTime$_)",
    );
}

# set undef
for ( 1 .. 5 ) {
    my $TicketFreeTimeSet = $Self->{TicketObject}->TicketFreeTimeSet(
        Counter          => $_,
        Prefix           => 'a',
        "a$_" . "Year"   => '0000',
        "a$_" . "Month"  => 0,
        "a$_" . "Day"    => 0,
        "a$_" . "Hour"   => 0,
        "a$_" . "Minute" => 0,
        TicketID         => $TicketID,
        UserID           => 1,
    );
    $Self->True(
        $TicketFreeTimeSet,
        'TicketFreeTimeSet() ' . $_,
    );
}

%TicketFreeTime = $Self->{TicketObject}->TicketGet(
    TicketID => $TicketID,
);
for ( 1 .. 5 ) {
    $Self->Is(
        $TicketFreeTime{ 'TicketFreeTime' . $_ },
        '',
        "TicketGet() (TicketFreeTime$_)",
    );
}

# article attachment checks
for my $Backend (qw(DB FS)) {
    $Self->{ConfigObject}->Set(
        Key   => 'Ticket::StorageModule',
        Value => 'Kernel::System::Ticket::ArticleStorage' . $Backend,
    );
    my $TicketObject = Kernel::System::Ticket->new( %{$Self} );
    for my $File (
        qw(Ticket-Article-Test1.xls Ticket-Article-Test1.txt Ticket-Article-Test1.doc
        Ticket-Article-Test1.png Ticket-Article-Test1.pdf Ticket-Article-Test-utf8-1.txt Ticket-Article-Test-utf8-1.bin)
        )
    {
        my $Content = '';
        open( IN, '<', $Self->{ConfigObject}->Get('Home') . "/scripts/test/sample/$File" )
            || die $!;
        binmode(IN);
        while (<IN>) {
            $Content .= $_;
        }
        close(IN);
        my $FileNew                = "ÄÖÜ ? カスタマ-" . $File;
        my $MD5Orig                = $Self->{MainObject}->MD5sum( String => $Content );
        my $ArticleWriteAttachment = $TicketObject->ArticleWriteAttachment(
            Content     => $Content,
            Filename    => $FileNew,
            ContentType => 'image/png',
            ArticleID   => $ArticleID,
            UserID      => 1,
        );
        $Self->True(
            $ArticleWriteAttachment,
            "$Backend ArticleWriteAttachment() - $FileNew",
        );
        my %Data = $TicketObject->ArticleAttachment(
            ArticleID => $ArticleID,
            FileID    => 1,
        );
        $Self->True(
            $Data{Content},
            "$Backend ArticleAttachment() Content - $FileNew",
        );
        $Self->True(
            $Data{ContentType},
            "$Backend ArticleAttachment() ContentType - $FileNew",
        );
        $Self->True(
            $Data{Content} eq $Content,
            "$Backend ArticleWriteAttachment() / ArticleAttachment() - $FileNew",
        );
        $Self->True(
            $Data{ContentType} eq 'image/png',
            "$Backend ArticleWriteAttachment() / ArticleAttachment() - $File",
        );
        my $MD5New = $Self->{MainObject}->MD5sum( String => $Data{Content} );
        $Self->Is(
            $MD5Orig || '1',
            $MD5New  || '2',
            "$Backend MD5 - $FileNew",
        );
        my $Delete = $TicketObject->ArticleDeleteAttachment(
            ArticleID => $ArticleID,
            UserID    => 1,
        );
        $Self->True(
            $Delete,
            "$Backend ArticleDeleteAttachment() - $FileNew",
        );
    }
}

my %TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit        => 100,
    TicketNumber => $Ticket{TicketNumber},
    UserID       => 1,
    Permission   => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketNumber)',
);

%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit        => 100,
    TicketNumber => [ $Ticket{TicketNumber}, '1234' ],
    UserID       => 1,
    Permission   => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketNumber[ARRAY])',
);

%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit      => 100,
    Title      => $Ticket{Title},
    UserID     => 1,
    Permission => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:Title)',
);

%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit      => 100,
    Title      => [ $Ticket{Title}, 'SomeTitleABC' ],
    UserID     => 1,
    Permission => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:Title[ARRAY])',
);

%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit      => 100,
    CustomerID => $Ticket{CustomerID},
    UserID     => 1,
    Permission => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CustomerID)',
);

%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit      => 100,
    CustomerID => [ $Ticket{CustomerID}, 'LULU' ],
    UserID     => 1,
    Permission => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CustomerID[ARRAY])',
);

%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit             => 100,
    CustomerUserLogin => $Ticket{CustomerUser},
    UserID            => 1,
    Permission        => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CustomerUser)',
);

%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit             => 100,
    CustomerUserLogin => [ $Ticket{CustomerUserID}, '1234' ],
    UserID            => 1,
    Permission        => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CustomerUser[ARRAY])',
);

%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit             => 100,
    TicketNumber      => $Ticket{TicketNumber},
    Title             => $Ticket{Title},
    CustomerID        => $Ticket{CustomerID},
    CustomerUserLogin => $Ticket{CustomerUserID},
    UserID            => 1,
    Permission        => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketNumber,Title,CustomerID,CustomerUserID)',
);

%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit             => 100,
    TicketNumber      => [ $Ticket{TicketNumber}, 'ABC' ],
    Title             => [ $Ticket{Title}, '123' ],
    CustomerID        => [ $Ticket{CustomerID}, '1213421' ],
    CustomerUserLogin => [ $Ticket{CustomerUserID}, 'iadasd' ],
    UserID            => 1,
    Permission        => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketNumber,Title,CustomerID,CustomerUser[ARRAY])',
);

%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit        => 100,
    TicketNumber => [ $Ticket{TicketNumber}, 'ABC' ],
    StateType    => 'Closed',
    UserID       => 1,
    Permission   => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketNumber,StateType:Closed)',
);

%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit        => 100,
    TicketNumber => [ $Ticket{TicketNumber}, 'ABC' ],
    StateType    => 'Open',
    UserID       => 1,
    Permission   => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketNumber,StateType:Open)',
);

%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit      => 100,
    Body       => '*write perl modules*',
    StateType  => 'Closed',
    UserID     => 1,
    Permission => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:Body,StateType:Closed)',
);

%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit      => 100,
    Body       => '*write perl modules*',
    StateType  => 'Open',
    UserID     => 1,
    Permission => 'rw',
);
$Self->True(
    !$TicketIDs{$TicketID},
    'TicketSearch() (HASH:Body,StateType:Open)',
);

my $TicketMove = $Self->{TicketObject}->MoveTicket(
    Queue              => 'Junk',
    TicketID           => $TicketID,
    SendNoNotification => 1,
    UserID             => 1,
);
$Self->True(
    $TicketMove,
    'MoveTicket()',
);

my $TicketState = $Self->{TicketObject}->StateSet(
    State    => 'open',
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $TicketState,
    'StateSet()',
);

%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit        => 100,
    TicketNumber => [ $Ticket{TicketNumber}, 'ABC' ],
    StateType    => 'Open',
    UserID       => 1,
    Permission   => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketNumber,StateType:Open)',
);

%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit        => 100,
    TicketNumber => [ $Ticket{TicketNumber}, 'ABC' ],
    StateType    => 'Closed',
    UserID       => 1,
    Permission   => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketNumber,StateType:Closed)',
);

for my $Condition (
    '(Some&&Agent)',
    'Some&&Agent',
    '(Some+Agent)',
    ' (Some+Agent)',
    ' (Some+Agent)  ',
    'Some&&Agent',
    'Some+Agent',
    ' Some+Agent',
    'Some+Agent ',
    ' Some+Agent ',
    '(!SomeWordShouldNotFound||(Some+Agent))',
    '((Some+Agent)||(SomeAgentNotFound||AgentNotFound))',
    )
{
    %TicketIDs = $Self->{TicketObject}->TicketSearch(

        # result (required)
        Result => 'HASH',

        # result limit
        Limit           => 1000,
        From            => $Condition,
        ConditionInline => 1,
        UserID          => 1,
        Permission      => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID} || 0,
        "TicketSearch() (HASH:From,ConditionInline,From='$Condition')",
    );
}

for my $Condition (
    '(SomeNotFoundWord&&AgentNotFoundWord)',
    'SomeNotFoundWord||AgentNotFoundWord',
    ' SomeNotFoundWord||AgentNotFoundWord',
    'SomeNotFoundWord&&AgentNotFoundWord',
    'SomeNotFoundWord&&AgentNotFoundWord  ',
    '(SomeNotFoundWord AgentNotFoundWord)',
    'SomeNotFoundWord&&AgentNotFoundWord',
    '(SomeWordShouldNotFound||(!Some+!Agent))',
    '((SomeNotFound&&Agent)||(SomeAgentNotFound||AgentNotFound))',
    )
{
    %TicketIDs = $Self->{TicketObject}->TicketSearch(

        # result (required)
        Result => 'HASH',

        # result limit
        Limit           => 1000,
        From            => $Condition,
        ConditionInline => 1,
        UserID          => 1,
        Permission      => 'rw',
    );
    $Self->True(
        ( !$TicketIDs{$TicketID} ) || 0,
        "TicketSearch() (HASH:From,ConditionInline,From='$Condition')",
    );
}

my $TicketPriority = $Self->{TicketObject}->PrioritySet(
    Priority => '2 low',
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $TicketPriority,
    'PrioritySet()',
);

my $TicketTitle = $Self->{TicketObject}->TicketTitleUpdate(
    Title    => 'Some Title 1234567',
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $TicketTitle,
    'TicketTitleUpdate()',
);

my $TicketLock = $Self->{TicketObject}->LockSet(
    Lock               => 'lock',
    TicketID           => $TicketID,
    SendNoNotification => 1,
    UserID             => 1,
);
$Self->True(
    $TicketLock,
    'LockSet()',
);

# Test CreatedUserIDs
%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit          => 100,
    CreatedUserIDs => [ 1, 455, 32 ],
    UserID         => 1,
    Permission     => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CreatedUserIDs[Array])',
);

# Test CreatedPriorities
%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit             => 100,
    CreatedPriorities => [ '2 low', '3 normal' ],
    UserID            => 1,
    Permission        => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CreatedPriorities[Array])',
);

# Test CreatedPriorityIDs
%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit              => 100,
    CreatedPriorityIDs => [ 2, 3 ],
    UserID             => 1,
    Permission         => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CreatedPriorityIDs[Array])',
);

# Test CreatedStates
%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit         => 100,
    CreatedStates => ['closed successful'],
    UserID        => 1,
    Permission    => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CreatedStates[Array])',
);

# Test CreatedStateIDs
%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit           => 100,
    CreatedStateIDs => [2],
    UserID          => 1,
    Permission      => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CreatedStateIDs[Array])',
);

# Test CreatedQueues
%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit         => 100,
    CreatedQueues => ['Raw'],
    UserID        => 1,
    Permission    => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CreatedQueues[Array])',
);

# Test CreatedQueueIDs
%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit           => 100,
    CreatedQueueIDs => [ 2, 3 ],
    UserID          => 1,
    Permission      => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CreatedQueueIDs[Array])',
);

# Test TicketCreateTimeNewerMinutes
%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit                        => 100,
    TicketCreateTimeNewerMinutes => 60,
    UserID                       => 1,
    Permission                   => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCreateTimeNewerMinutes => 60)',
);

# Test TicketCreateOlderMinutes
%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit                        => 100,
    TicketCreateTimeOlderMinutes => 60,
    UserID                       => 1,
    Permission                   => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCreateTimeOlderMinutes => 60)',
);

# Test TicketCreateTimeNewerDate
my $SystemTime = $Self->{TimeObject}->SystemTime();
%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit                     => 100,
    TicketCreateTimeNewerDate => $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $SystemTime - ( 60 * 60 ),
    ),
    UserID     => 1,
    Permission => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCreateTimeNewerDate => 60)',
);

# Test TicketCreateOlderDate
%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit                     => 100,
    TicketCreateTimeOlderDate => $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $SystemTime - ( 60 * 60 ),
    ),
    UserID     => 1,
    Permission => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCreateTimeOlderDate => 60)',
);

# Test TicketCloseTimeNewerDate
%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit                    => 100,
    TicketCloseTimeNewerDate => $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $SystemTime - ( 60 * 60 ),
    ),
    UserID     => 1,
    Permission => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCloseTimeNewerDate => 60)',
);

# Test TicketCloseOlderDate
%TicketIDs = $Self->{TicketObject}->TicketSearch(

    # result (required)
    Result => 'HASH',

    # result limit
    Limit                    => 100,
    TicketCloseTimeOlderDate => $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $SystemTime - ( 60 * 60 ),
    ),
    UserID     => 1,
    Permission => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCloseTimeOlderDate => 60)',
);

my %Ticket2 = $Self->{TicketObject}->TicketGet(
    TicketID => $TicketID,
);
$Self->Is(
    $Ticket2{Title},
    'Some Title 1234567',
    'TicketGet() (Title)',
);
$Self->Is(
    $Ticket2{Queue},
    'Junk',
    'TicketGet() (Queue)',
);
$Self->Is(
    $Ticket2{Priority},
    '2 low',
    'TicketGet() (Priority)',
);
$Self->Is(
    $Ticket2{State},
    'open',
    'TicketGet() (State)',
);
$Self->Is(
    $Ticket2{Lock},
    'lock',
    'TicketGet() (Lock)',
);

%Article = $Self->{TicketObject}->ArticleGet(
    ArticleID => $ArticleID,
);
$Self->Is(
    $Article{Title},
    'Some Title 1234567',
    'ArticleGet() (Title)',
);
$Self->Is(
    $Article{Queue},
    'Junk',
    'ArticleGet() (Queue)',
);
$Self->Is(
    $Article{Priority},
    '2 low',
    'ArticleGet() (Priority)',
);
$Self->Is(
    $Article{State},
    'open',
    'ArticleGet() (State)',
);
$Self->Is(
    $Article{Owner},
    'root@localhost',
    'ArticleGet() (Owner)',
);
$Self->Is(
    $Article{Responsible},
    'root@localhost',
    'ArticleGet() (Responsible)',
);
$Self->Is(
    $Article{Lock},
    'lock',
    'ArticleGet() (Lock)',
);
for ( 1 .. 16 ) {
    $Self->Is(
        $Article{ 'TicketFreeKey' . $_ },
        'Hans' . $_,
        "ArticleGet() (TicketFreeKey$_)",
    );
    $Self->Is(
        $Article{ 'TicketFreeText' . $_ },
        'Max' . $_,
        "ArticleGet() (TicketFreeText$_)",
    );
}

my @MoveQueueList = $Self->{TicketObject}->MoveQueueList(
    TicketID => $TicketID,
    Type     => 'Name',
);

$Self->Is(
    $MoveQueueList[0],
    'Raw',
    'MoveQueueList() (Raw)',
);
$Self->Is(
    $MoveQueueList[$#MoveQueueList],
    'Junk',
    'MoveQueueList() (Junk)',
);

my $TicketAccountTime = $Self->{TicketObject}->TicketAccountTime(
    TicketID  => $TicketID,
    ArticleID => $ArticleID,
    TimeUnit  => '4.5',
    UserID    => 1,
);

$Self->True(
    $TicketAccountTime,
    'TicketAccountTime() 1',
);

my $TicketAccountTime2 = $Self->{TicketObject}->TicketAccountTime(
    TicketID  => $TicketID,
    ArticleID => $ArticleID,
    TimeUnit  => '4123.53',
    UserID    => 1,
);

$Self->True(
    $TicketAccountTime2,
    'TicketAccountTime() 2',
);

my $TicketAccountTime3 = $Self->{TicketObject}->TicketAccountTime(
    TicketID  => $TicketID,
    ArticleID => $ArticleID,
    TimeUnit  => '4,53',
    UserID    => 1,
);

$Self->True(
    $TicketAccountTime3,
    'TicketAccountTime() 3',
);

my $AccountedTime = $Self->{TicketObject}->TicketAccountedTimeGet( TicketID => $TicketID );

$Self->Is(
    $AccountedTime,
    4132.56,
    'TicketAccountedTimeGet()',
);

my $AccountedTime2 = $Self->{TicketObject}->ArticleAccountedTimeGet(
    ArticleID => $ArticleID,
);

$Self->Is(
    $AccountedTime2,
    4132.56,
    'ArticleAccountedTimeGet()',
);

# article flag tests
my @Tests = (
    {
        Name   => 'seen flag',
        Flag   => 'seen',
        UserID => 1,
    },
    {
        Name   => 'not seend flag',
        Flag   => 'not seen',
        UserID => 1,
    },
);

for my $Test (@Tests) {
    my %Flag = $Self->{TicketObject}->ArticleFlagGet(
        ArticleID => $ArticleID,
        UserID    => 1,
    );
    $Self->False(
        $Flag{ $Test->{Flag} } || 0,
        'ArticleFlagGet()',
    );
    my $Set = $Self->{TicketObject}->ArticleFlagSet(
        ArticleID => $ArticleID,
        Flag      => $Test->{Flag},
        UserID    => 1,
    );
    $Self->True(
        $Set || 0,
        'ArticleFlagSet()',
    );
    %Flag = $Self->{TicketObject}->ArticleFlagGet(
        ArticleID => $ArticleID,
        UserID    => 1,
    );
    $Self->True(
        $Flag{ $Test->{Flag} } || 0,
        'ArticleFlagGet()',
    );
    my $Delete = $Self->{TicketObject}->ArticleFlagDelete(
        ArticleID => $ArticleID,
        Flag      => $Test->{Flag},
        UserID    => 1,
    );
    $Self->True(
        $Delete || 0,
        'ArticleFlagDelete()',
    );
    %Flag = $Self->{TicketObject}->ArticleFlagGet(
        ArticleID => $ArticleID,
        UserID    => 1,
    );
    $Self->False(
        $Flag{ $Test->{Flag} } || 0,
        'ArticleFlagGet()',
    );
}

my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
    SystemTime => $Self->{TimeObject}->SystemTime(),
);

my %TicketStatus = $Self->{TicketObject}->HistoryTicketStatusGet(
    StopYear   => $Year,
    StopMonth  => $Month,
    StopDay    => $Day,
    StartYear  => $Year - 2,
    StartMonth => $Month,
    StartDay   => $Day,
);

if ( $TicketStatus{$TicketID} ) {
    my %TicketHistory = %{ $TicketStatus{$TicketID} };
    $Self->Is(
        $TicketHistory{TicketNumber},
        $Ticket{TicketNumber},
        "HistoryTicketStatusGet() (TicketNumber)",
    );
    $Self->Is(
        $TicketHistory{TicketID},
        $TicketID,
        "HistoryTicketStatusGet() (TicketID)",
    );
    $Self->Is(
        $TicketHistory{CreateUserID},
        1,
        "HistoryTicketStatusGet() (CreateUserID)",
    );
    $Self->Is(
        $TicketHistory{Queue},
        'Junk',
        "HistoryTicketStatusGet() (Queue)",
    );
    $Self->Is(
        $TicketHistory{CreateQueue},
        'Raw',
        "HistoryTicketStatusGet() (CreateQueue)",
    );
    $Self->Is(
        $TicketHistory{State},
        'open',
        "HistoryTicketStatusGet() (State)",
    );
    $Self->Is(
        $TicketHistory{CreateState},
        'closed successful',
        "HistoryTicketStatusGet() (CreateState)",
    );
    $Self->Is(
        $TicketHistory{Priority},
        '2 low',
        "HistoryTicketStatusGet() (Priority)",
    );
    $Self->Is(
        $TicketHistory{CreatePriority},
        '3 normal',
        "HistoryTicketStatusGet() (CreatePriority)",
    );
    for ( 1 .. 16 ) {
        $Self->Is(
            $TicketHistory{ 'TicketFreeKey' . $_ },
            'Hans' . $_,
            "HistoryTicketStatusGet() (TicketFreeKey$_)",
        );
        $Self->Is(
            $TicketHistory{ 'TicketFreeText' . $_ },
            'Max' . $_,
            "HistoryTicketStatusGet() (TicketFreeText$_)",
        );
    }
}
else {
    $Self->True(
        0,
        'HistoryTicketStatusGet()',
    );
}

my $Delete = $Self->{TicketObject}->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $Delete,
    'TicketDelete()',
);

# ticket search sort/order test
my $TicketIDSortOrder1 = $Self->{TicketObject}->TicketCreate(
    Title        => 'Some Ticket Title - ticket sort/order by tests',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
sleep 2;
my $TicketIDSortOrder2 = $Self->{TicketObject}->TicketCreate(
    Title        => 'Some Ticket Title - ticket sort/order by tests2',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# find newest ticket by priority, age
my @TicketIDsSortOrder = $Self->{TicketObject}->TicketSearch(
    Result  => 'ARRAY',
    Title   => '%sort/order by test%',
    Queues  => ['Raw'],
    OrderBy => [ 'Down', 'Up' ],
    SortBy  => [ 'Priority', 'Age' ],
    UserID  => 1,
);
$Self->True(
    $TicketIDsSortOrder[0] eq $TicketIDSortOrder1,
    'TicketTicketSearch() - ticket sort/order by (Priority (Down), Age (Up))',
);

# find oldest ticket by priority, age
@TicketIDsSortOrder = $Self->{TicketObject}->TicketSearch(
    Result  => 'ARRAY',
    Title   => '%sort/order by test%',
    Queues  => ['Raw'],
    OrderBy => [ 'Down', 'Down' ],
    SortBy  => [ 'Priority', 'Age' ],
    UserID  => 1,
);
$Self->True(
    $TicketIDsSortOrder[0] eq $TicketIDSortOrder2,
    'TicketTicketSearch() - ticket sort/order by (Priority (Down), Age (Down))',
);
my $TicketIDSortOrder3 = $Self->{TicketObject}->TicketCreate(
    Title        => 'Some Ticket Title - ticket sort/order by tests2',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '4 high',
    State        => 'new',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
sleep 2;
my $TicketIDSortOrder4 = $Self->{TicketObject}->TicketCreate(
    Title        => 'Some Ticket Title - ticket sort/order by tests2',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '4 high',
    State        => 'new',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# find oldest ticket by priority, age
@TicketIDsSortOrder = $Self->{TicketObject}->TicketSearch(
    Result  => 'ARRAY',
    Title   => '%sort/order by test%',
    Queues  => ['Raw'],
    OrderBy => [ 'Down', 'Down' ],
    SortBy  => [ 'Priority', 'Age' ],
    UserID  => 1,
);
$Self->True(
    $TicketIDsSortOrder[0] eq $TicketIDSortOrder4,
    'TicketTicketSearch() - ticket sort/order by (Priority (Down), Age (Down))',
);

# find oldest ticket by priority, age
@TicketIDsSortOrder = $Self->{TicketObject}->TicketSearch(
    Result  => 'ARRAY',
    Title   => '%sort/order by test%',
    Queues  => ['Raw'],
    OrderBy => [ 'Up', 'Down' ],
    SortBy  => [ 'Priority', 'Age' ],
    UserID  => 1,
);
$Self->True(
    $TicketIDsSortOrder[0] eq $TicketIDSortOrder2,
    'TicketTicketSearch() - ticket sort/order by (Priority (Up), Age (Down))',
);

# find newest ticket
@TicketIDsSortOrder = $Self->{TicketObject}->TicketSearch(
    Result  => 'ARRAY',
    Title   => '%sort/order by test%',
    Queues  => ['Raw'],
    OrderBy => 'Down',
    SortBy  => 'Age',
    UserID  => 1,
);
$Self->True(
    $TicketIDsSortOrder[0] eq $TicketIDSortOrder4,
    'TicketTicketSearch() - ticket sort/order by (Age (Down))',
);

# find oldest ticket
@TicketIDsSortOrder = $Self->{TicketObject}->TicketSearch(
    Result  => 'ARRAY',
    Title   => '%sort/order by test%',
    Queues  => ['Raw'],
    OrderBy => 'Up',
    SortBy  => 'Age',
    UserID  => 1,
);
$Self->True(
    $TicketIDsSortOrder[0] eq $TicketIDSortOrder1,
    'TicketTicketSearch() - ticket sort/order by (Age (Up))',
);
$Self->True(
    $Self->{TicketObject}->TicketDelete(
        TicketID => $TicketIDSortOrder1,
        UserID   => 1,
    ),
    "TicketDelete()",
);
$Self->True(
    $Self->{TicketObject}->TicketDelete(
        TicketID => $TicketIDSortOrder2,
        UserID   => 1,
    ),
    "TicketDelete()",
);
$Self->True(
    $Self->{TicketObject}->TicketDelete(
        TicketID => $TicketIDSortOrder3,
        UserID   => 1,
    ),
    "TicketDelete()",
);
$Self->True(
    $Self->{TicketObject}->TicketDelete(
        TicketID => $TicketIDSortOrder4,
        UserID   => 1,
    ),
    "TicketDelete()",
);

# ticket index accelerator tests
for my $Module ( 'RuntimeDB', 'StaticDB' ) {
    my $QueueID = $Self->{QueueObject}->QueueLookup( Queue => 'Raw' );
    $Self->{ConfigObject}->Set(
        Key   => 'Ticket::IndexModule',
        Value => "Kernel::System::Ticket::IndexAccelerator::$Module",
    );
    $Self->{TicketObject} = Kernel::System::Ticket->new( %{$Self} );

    my @TicketIDs = ();
    $TicketID = $Self->{TicketObject}->TicketCreate(
        Title        => 'Some Ticket Title - ticket index accelerator tests',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'new',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    push( @TicketIDs, $TicketID );
    $Self->True(
        $TicketID,
        "$Module TicketCreate() - unlock - new",
    );

    my %IndexBefore = $Self->{TicketObject}->TicketAcceleratorIndex(
        UserID        => 1,
        QueueID       => [ 1, 2, 3, 4, 5, $QueueID ],
        ShownQueueIDs => [ 1, 2, 3, 4, 5, $QueueID ],
    );
    $TicketID = $Self->{TicketObject}->TicketCreate(
        Title        => 'Some Ticket Title - ticket index accelerator tests',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'closed successful',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    push( @TicketIDs, $TicketID );
    $Self->True(
        $TicketID,
        "$Module TicketCreate() - unlock - closed successful",
    );
    $TicketID = $Self->{TicketObject}->TicketCreate(
        Title        => 'Some Ticket Title - ticket index accelerator tests',
        Queue        => 'Raw',
        Lock         => 'lock',
        Priority     => '3 normal',
        State        => 'closed successful',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    push( @TicketIDs, $TicketID );
    $Self->True(
        $TicketID,
        "$Module TicketCreate() - lock - closed successful",
    );
    $TicketID = $Self->{TicketObject}->TicketCreate(
        Title        => 'Some Ticket Title - ticket index accelerator tests',
        Queue        => 'Raw',
        Lock         => 'lock',
        Priority     => '3 normal',
        State        => 'open',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    push( @TicketIDs, $TicketID );
    $Self->True(
        $TicketID,
        "$Module TicketCreate() - lock - open",
    );
    $TicketID = $Self->{TicketObject}->TicketCreate(
        Title        => 'Some Ticket Title - ticket index accelerator tests',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'open',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    push( @TicketIDs, $TicketID );
    $Self->True(
        $TicketID,
        "$Module TicketCreate() - unlock - open",
    );

    my %IndexNow = $Self->{TicketObject}->TicketAcceleratorIndex(
        UserID        => 1,
        QueueID       => [ 1, 2, 3, 4, 5, $QueueID ],
        ShownQueueIDs => [ 1, 2, 3, 4, 5, $QueueID ],
    );
    $Self->Is(
        $IndexBefore{AllTickets}  || 0,
        $IndexNow{AllTickets} - 2 || '',
        "$Module TicketAcceleratorIndex() - AllTickets",
    );
    for my $ItemNow ( @{ $IndexNow{Queues} } ) {
        if ( $ItemNow->{Queue} eq 'Raw' ) {
            for my $ItemBefore ( @{ $IndexBefore{Queues} } ) {
                if ( $ItemBefore->{Queue} eq 'Raw' ) {
                    $Self->Is(
                        $ItemBefore->{Count}  || 0,
                        $ItemNow->{Count} - 1 || '',
                        "$Module TicketAcceleratorIndex() - Count",
                    );
                }
            }
        }
    }
    my $TicketLock = $Self->{TicketObject}->LockSet(
        Lock               => 'lock',
        TicketID           => $TicketIDs[1],
        SendNoNotification => 1,
        UserID             => 1,
    );
    $Self->True(
        $TicketLock,
        "$Module LockSet()",
    );
    %IndexNow = $Self->{TicketObject}->TicketAcceleratorIndex(
        UserID        => 1,
        QueueID       => [ 1, 2, 3, 4, 5, $QueueID ],
        ShownQueueIDs => [ 1, 2, 3, 4, 5, $QueueID ],
    );
    $Self->Is(
        $IndexBefore{AllTickets}  || 0,
        $IndexNow{AllTickets} - 2 || '',
        "$Module TicketAcceleratorIndex() - AllTickets",
    );
    for my $ItemNow ( @{ $IndexNow{Queues} } ) {
        if ( $ItemNow->{Queue} eq 'Raw' ) {
            for my $ItemBefore ( @{ $IndexBefore{Queues} } ) {
                if ( $ItemBefore->{Queue} eq 'Raw' ) {
                    $Self->Is(
                        $ItemBefore->{Count}  || 0,
                        $ItemNow->{Count} - 1 || '',
                        "$Module TicketAcceleratorIndex() - Count",
                    );
                }
            }
        }
    }
    $TicketLock = $Self->{TicketObject}->LockSet(
        Lock               => 'lock',
        TicketID           => $TicketIDs[4],
        SendNoNotification => 1,
        UserID             => 1,
    );
    $Self->True(
        $TicketLock,
        "$Module LockSet()",
    );
    %IndexNow = $Self->{TicketObject}->TicketAcceleratorIndex(
        UserID        => 1,
        QueueID       => [ 1, 2, 3, 4, 5, $QueueID ],
        ShownQueueIDs => [ 1, 2, 3, 4, 5, $QueueID ],
    );
    $Self->Is(
        $IndexBefore{AllTickets}  || 0,
        $IndexNow{AllTickets} - 2 || '',
        "$Module TicketAcceleratorIndex() - AllTickets",
    );
    for my $ItemNow ( @{ $IndexNow{Queues} } ) {
        if ( $ItemNow->{Queue} eq 'Raw' ) {
            for my $ItemBefore ( @{ $IndexBefore{Queues} } ) {
                if ( $ItemBefore->{Queue} eq 'Raw' ) {
                    $Self->Is(
                        $ItemBefore->{Count} || 0,
                        $ItemNow->{Count}    || '',
                        "$Module TicketAcceleratorIndex() - Count",
                    );
                }
            }
        }
    }
    $TicketLock = $Self->{TicketObject}->LockSet(
        Lock               => 'unlock',
        TicketID           => $TicketIDs[4],
        SendNoNotification => 1,
        UserID             => 1,
    );
    $Self->True(
        $TicketLock,
        "$Module LockSet()",
    );
    %IndexNow = $Self->{TicketObject}->TicketAcceleratorIndex(
        UserID        => 1,
        QueueID       => [ 1, 2, 3, 4, 5, $QueueID ],
        ShownQueueIDs => [ 1, 2, 3, 4, 5, $QueueID ],
    );
    $Self->Is(
        $IndexBefore{AllTickets}  || 0,
        $IndexNow{AllTickets} - 2 || '',
        "$Module TicketAcceleratorIndex() - AllTickets",
    );
    for my $ItemNow ( @{ $IndexNow{Queues} } ) {
        if ( $ItemNow->{Queue} eq 'Raw' ) {
            for my $ItemBefore ( @{ $IndexBefore{Queues} } ) {
                if ( $ItemBefore->{Queue} eq 'Raw' ) {
                    $Self->Is(
                        $ItemBefore->{Count}  || 0,
                        $ItemNow->{Count} - 1 || '',
                        "$Module TicketAcceleratorIndex() - Count",
                    );
                }
            }
        }
    }
    my $TicketState = $Self->{TicketObject}->StateSet(
        State              => 'open',
        TicketID           => $TicketIDs[1],
        SendNoNotification => 1,
        UserID             => 1,
    );
    $Self->True(
        $TicketState,
        "$Module StateSet()",
    );
    $TicketLock = $Self->{TicketObject}->LockSet(
        Lock               => 'unlock',
        TicketID           => $TicketIDs[1],
        SendNoNotification => 1,
        UserID             => 1,
    );
    $Self->True(
        $TicketLock,
        "$Module LockSet()",
    );
    %IndexNow = $Self->{TicketObject}->TicketAcceleratorIndex(
        UserID        => 1,
        QueueID       => [ 1, 2, 3, 4, 5, $QueueID ],
        ShownQueueIDs => [ 1, 2, 3, 4, 5, $QueueID ],
    );
    $Self->Is(
        $IndexBefore{AllTickets}  || 0,
        $IndexNow{AllTickets} - 3 || '',
        "$Module TicketAcceleratorIndex() - AllTickets",
    );
    for my $ItemNow ( @{ $IndexNow{Queues} } ) {
        if ( $ItemNow->{Queue} eq 'Raw' ) {
            for my $ItemBefore ( @{ $IndexBefore{Queues} } ) {
                if ( $ItemBefore->{Queue} eq 'Raw' ) {
                    $Self->Is(
                        $ItemBefore->{Count}  || 0,
                        $ItemNow->{Count} - 2 || '',
                        "$Module TicketAcceleratorIndex() - Count",
                    );
                }
            }
        }
    }

    for my $TicketID (@TicketIDs) {
        $Self->True(
            $Self->{TicketObject}->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            ),
            "$Module TicketDelete()",
        );
    }
}

# ---
# avoid StateType and StateTypeID problems in TicketSearch()
# ---

# Get an error warning, if the result is different if use a StateType or its ID (StateTypeID)
use Kernel::System::State;

$Self->{StateObject} = Kernel::System::State->new( %{$Self} );

my %StateTypeList = $Self->{StateObject}->StateTypeList(
    UserID => 1,
);

# you need a hash with the state as key and the related StateType and StateTypeID as
# reference
my %StateAsKeyAndStateTypeAsValue;
for my $StateTypeID ( keys %StateTypeList ) {
    my @List = $Self->{StateObject}->StateGetStatesByType(
        StateType => [ $StateTypeList{$StateTypeID} ],
        Result    => 'Name',                             # HASH|ID|Name
    );
    for my $Index (@List) {
        $StateAsKeyAndStateTypeAsValue{$Index}->{Name} = $StateTypeList{$StateTypeID};
        $StateAsKeyAndStateTypeAsValue{$Index}->{ID}   = $StateTypeID;
    }
}

# to be sure that you have a result ticket create one
$TicketID = $Self->{TicketObject}->TicketCreate(
    Title        => 'StateTypeTest',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

my %StateList = $Self->{StateObject}->StateList(
    UserID => 1,
);

# now check every possible state
for my $State ( values %StateList ) {
    $Self->{TicketObject}->StateSet(
        State              => $State,
        TicketID           => $TicketID,
        SendNoNotification => 1,
        UserID             => 1,
    );

    my @TicketIDs = $Self->{TicketObject}->TicketSearch(
        Result       => 'ARRAY',
        Title        => '%StateTypeTest%',
        Queues       => ['Raw'],
        StateTypeIDs => [ $StateAsKeyAndStateTypeAsValue{$State}->{ID} ],
        UserID       => 1,
    );

    my @TicketIDsType = $Self->{TicketObject}->TicketSearch(
        Result    => 'ARRAY',
        Title     => '%StateTypeTest%',
        Queues    => ['Raw'],
        StateType => [ $StateAsKeyAndStateTypeAsValue{$State}->{Name} ],
        UserID    => 1,
    );

    if ( $TicketIDs[0] ) {
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID => $TicketIDs[0],
            UserID   => 1,
        );
    }

    # if there is no result the StateTypeID hasn't worked
    # Test if there is a result, if I use StateTypeID $StateAsKeyAndStateTypeAsValue{$State}->{ID}
    $Self->True(
        $TicketIDs[0],
        "TicketSearch() - StateTypeID - found ticket",
    );

# if it is not equal then there is in the using of StateType or StateTypeID an error
# check if you get the same result if you use the StateType attribute or the StateTypeIDs attribute.
# State($State) StateType($StateAsKeyAndStateTypeAsValue{$State}->{Name}) and StateTypeIDs($StateAsKeyAndStateTypeAsValue{$State}->{ID})
    $Self->Is(
        scalar @TicketIDs,
        scalar @TicketIDsType,
        "TicketSearch() - StateType",
    );
}

# the ticket is no longer needed
$Self->{TicketObject}->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

# tests for article search index modules
for my $Module (qw(StaticDB RuntimeDB)) {
    $Self->{ConfigObject}->Set(
        Key   => 'Ticket::SearchIndexModule',
        Value => 'Kernel::System::Ticket::ArticleSearchIndex::' . $Module,
    );
    my $TicketObject = Kernel::System::Ticket->new( %{$Self} );

    # create some content
    my $TicketID = $TicketObject->TicketCreate(
        Title        => 'Some Ticket Title',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'closed successful',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    $Self->True(
        $TicketID,
        'TicketCreate()',
    );

    my $ArticleID = $TicketObject->ArticleCreate(
        TicketID    => $TicketID,
        ArticleType => 'note-internal',
        SenderType  => 'agent',
        From        => 'Some Agent <email@example.com>',
        To          => 'Some Customer <customer@example.com>',
        Subject     => 'some short description',
        Body        => 'the message text
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify => 1,    # if you don't want to send agent notifications
    );
    $Self->True(
        $ArticleID,
        'ArticleCreate()',
    );

    # search
    my %TicketIDs = $TicketObject->TicketSearch(
        Subject      => '%short%',
        Result       => 'HASH',
        Limit        => 100,
        UserID       => 1,
        Permission   => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        'TicketSearch() (HASH:Subject)',
    );

    $ArticleID = $TicketObject->ArticleCreate(
        TicketID    => $TicketID,
        ArticleType => 'note-internal',
        SenderType  => 'agent',
        From        => 'Some Agent <email@example.com>',
        To          => 'Some Customer <customer@example.com>',
        Subject     => 'Fax Agreement laalala',
        Body        => 'the message text
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify => 1,    # if you don't want to send agent notifications
    );
    $Self->True(
        $ArticleID,
        'ArticleCreate()',
    );

    # search
    %TicketIDs = $TicketObject->TicketSearch(
        Subject      => '%fax agreement%',
        Result       => 'HASH',
        Limit        => 100,
        UserID       => 1,
        Permission   => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        'TicketSearch() (HASH:Subject)',
    );

    # search
    %TicketIDs = $TicketObject->TicketSearch(
        Body         => '%HELP%',
        Result       => 'HASH',
        Limit        => 100,
        UserID       => 1,
        Permission   => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        'TicketSearch() (HASH:Body)',
    );

    # search
    %TicketIDs = $TicketObject->TicketSearch(
        Body         => '%HELP_NOT_FOUND%',
        Result       => 'HASH',
        Limit        => 100,
        UserID       => 1,
        Permission   => 'rw',
    );
    $Self->True(
        !$TicketIDs{$TicketID},
        'TicketSearch() (HASH:Body)',
    );

    my $Delete = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $Delete,
        'TicketDelete()',
    );
}

1;
