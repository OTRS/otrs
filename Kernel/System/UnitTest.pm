# --
# Kernel/System/UnitTest.pm - the global test wrapper
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: UnitTest.pm,v 1.8 2007-03-12 23:18:06 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::UnitTest;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.8 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::UnitTest - global test interface

=head1 SYNOPSIS

All test functions

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create test object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Test;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        LogObject => $LogObject,
        ConfigObject => $ConfigObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        MainObject => $MainObject,
        TimeObject => $TimeObject,
    );
    my $UnitTestObject = Kernel::System::UnitTest->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        MainObject => $MainObject,
        DBObject => $DBObject,
        TimeObject => $TimeObject,
    );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    $Self->{Debug} = $Param{Debug} || 0;

    # check needed objects
    foreach (qw(ConfigObject DBObject LogObject TimeObject MainObject EncodeObject)) {
        if ($Param{$_}) {
            $Self->{$_} = $Param{$_};
        }
        else {
            die "Got no $_!";
        }
    }

    $Self->{Output} = $Param{Output} || 'ASCII';

    if ($Self->{Output} eq 'HTML') {
        print "
<html>
<head>
    <title>".$Self->{ConfigObject}->Get('Product')." ".$Self->{ConfigObject}->Get('Version')." - Test Summary</title>
</head>
<a name='top'></a>
<body>

\n";
    }

    return $Self;
}

=item Run()

Run all tests located in scripts/test/*.t and print result to stdout.

=cut

sub Run {
    my $Self = shift;
    my %Param = @_;
    my %ResultSummary = ();
    my $Home = $Self->{ConfigObject}->Get('Home');
    my @Files = glob("$Home/scripts/test/*.t");
    my $StartTime = $Self->{TimeObject}->SystemTime();
    $Self->{TestCountOk} = 0;
    $Self->{TestCountNotOk} = 0;
    foreach my $File (@Files) {
        if ($Param{Name} && $File !~ /\/\Q$Param{Name}\E\.t$/) {
            next;
        }
        $Self->{TestCount} = 0;
        my $ConfigFile = '';
        if (open (IN, "< $File")) {
            while (<IN>) {
                $ConfigFile .= $_;
            }
            close (IN);
        }
        else {
            print STDERR "ERROR: $!: $File\n";
        }
        if ($ConfigFile) {
            $Self->_PrintHeadlineStart($File);
            if (! eval $ConfigFile) {
                print STDERR "ERROR: Syntax error in $File: $@\n";
            }
            else {
                # file loaded
#                print STDERR "Notice: Loaded: $File\n";
            }
            $Self->_PrintHeadlineEnd($File);
        }
    }

    my $Time = $Self->{TimeObject}->SystemTime() - $StartTime;
    $ResultSummary{TimeTaken} = $Time;
    $ResultSummary{Time} = $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );
    $ResultSummary{Host} = $Self->{ConfigObject}->Get('FQDN');
    $ResultSummary{Perl} = sprintf "%vd", $^V;
    $ResultSummary{OS} = $^O;
    $ResultSummary{TestOk} = $Self->{TestCountOk};
    $ResultSummary{TestNotOk} = $Self->{TestCountNotOk};

    $Self->_PrintSummary(%ResultSummary);
    if ($Self->{Content}) {
        print $Self->{Content};
    }

    return 1;
}

=item True()

A true test.

    $UnitTestObject->True(1, 'Test Name');

    $UnitTestObject->True($A eq $B, 'Test Name');

=cut

sub True {
    my $Self = shift;
    my $True = shift;
    my $Name = shift;
    if ($True) {
        $Self->_Print($True, $Name);
        return 1;
    }
    else {
        $Self->_Print($True, $Name);
        return;
    }
}

=item False()

A false test.

    $UnitTestObject->False(0, 'Test Name');

    $UnitTestObject->False($A ne $B, 'Test Name');

=cut

sub False {
    my $Self = shift;
    my $False = shift;
    my $Name = shift;
    if (!$False) {
        $Self->_Print(1, $Name);
        return 1;
    }
    else {
        $Self->_Print(0, $Name);
        return;
    }
}

=item Is()

A Is $A (is) eq $B (should be) test.

    $UnitTestObject->Is($A, $B, 'Test Name');

=cut

sub Is {
    my $Self = shift;
    my $Test = shift;
    my $ShouldBe = shift;
    my $Name = shift;
    if ($Test eq $ShouldBe) {
        $Self->_Print(1, "$Name (is '$ShouldBe')");
        return 1;
    }
    else {
        $Self->_Print(0, "$Name (is '$Test' should be '$ShouldBe')" );
        return;
    }
}

=item IsNot()

A Is $A (is) nq $B (should not be) test.

    $UnitTestObject->IsNot($A, $B, 'Test Name');

=cut

sub IsNot {
    my $Self = shift;
    my $Test = shift;
    my $ShouldBe = shift;
    my $Name = shift;
    if ($Test ne $ShouldBe) {
        $Self->_Print(1, "$Name (is '$Test')");
        return 1;
    }
    else {
        $Self->_Print(0, "$Name (is '$Test' should not be '$ShouldBe')" );
        return;
    }
}

sub _PrintSummary {
    my $Self = shift;
    my %ResultSummary = @_;
    # show result
    if ($Self->{Output} eq 'HTML') {
        print "<table width='600' border='1'>\n";
        if ($ResultSummary{TestNotOk}) {
            print "<tr><td bgcolor='red' colspan='2'>Summary</td></tr>\n";
        }
        else {
            print "<tr><td bgcolor='green' colspan='2'>Summary</td></tr>\n";
        }
        print "<tr><td>Product: </td><td>".$Self->{ConfigObject}->Get('Product')." ".$Self->{ConfigObject}->Get('Version')."</td></tr>\n";
        print "<tr><td>Test Time:</td><td>$ResultSummary{TimeTaken} s</td></tr>\n";
        print "<tr><td>Time:     </td><td> $ResultSummary{Time}</td></tr>\n";
        print "<tr><td>Host:     </td><td>$ResultSummary{Host}</td></tr>\n";
        print "<tr><td>Perl:     </td><td>$ResultSummary{Perl}</td></tr>\n";
        print "<tr><td>OS:       </td><td>$ResultSummary{OS}</td></tr>\n";
        print "<tr><td>TestOk:   </td><td>$ResultSummary{TestOk}</td></tr>\n";
        print "<tr><td>TestNotOk:</td><td>$ResultSummary{TestNotOk}</td></tr>\n";
        print "</table><br>\n";
    }
    else {
        print "=====================================================================\n";
        print " Product:   ".$Self->{ConfigObject}->Get('Product')." ".$Self->{ConfigObject}->Get('Version')."\n";
        print " Test Time: $ResultSummary{TimeTaken} s\n";
        print " Time:      $ResultSummary{Time}\n";
        print " Host:      $ResultSummary{Host}\n";
        print " Perl:      $ResultSummary{Perl}\n";
        print " OS:        $ResultSummary{OS}\n";
        print " TestOk:    $ResultSummary{TestOk}\n";
        print " TestNotOk: $ResultSummary{TestNotOk}\n";
        print "=====================================================================\n";
    }
    return 1;
}

sub _PrintHeadlineStart {
    my $Self = shift;
    my $Name = shift || '->>No Name!<<-';
    if ($Self->{Output} eq 'HTML') {
        $Self->{Content} .= "<table width='600' border='1'>\n";
        $Self->{Content} .= "<tr><td colspan='2'>$Name</td></tr>\n";
    }
    else {
        print "+-------------------------------------------------------------------+\n";
        print "$Name:\n";
        print "+-------------------------------------------------------------------+\n";
    }
    return 1;
}

sub _PrintHeadlineEnd {
    my $Self = shift;
    my $Name = shift || '->>No Name!<<-';
    if ($Self->{Output} eq 'HTML') {
        $Self->{Content} .= "</table><br>\n";
    }
    else {
    }
    return 1;
}

sub _Print {
    my $Self = shift;
    my $Test = shift;
    my $Name = shift || '->>No Name!<<-';
    $Self->{TestCount}++;
    if ($Test) {
        $Self->{TestCountOk}++;
        if ($Self->{Output} eq 'HTML') {
            $Self->{Content} .= "<tr><td width='70' bgcolor='green'>ok $Self->{TestCount}</td><td>$Name</td></tr>\n";
        }
        else {
            print " ok $Self->{TestCount} - $Name\n";
        }
        return 1;
    }
    else {
        $Self->{TestCountNotOk}++;
        if ($Self->{Output} eq 'HTML') {
            $Self->{Content} .= "<tr><td width='70' bgcolor='red'>not ok $Self->{TestCount}</td><td>$Name</td></tr>\n";
        }
        else {
            print " not ok $Self->{TestCount} - $Name\n";
        }
        return;
    }
}

sub DESTROY {
    my $Self = shift;
    if ($Self->{Output} eq 'HTML') {
        print "</body>\n";
        print "</html>\n";
    }
    return;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.8 $ $Date: 2007-03-12 23:18:06 $

=cut
