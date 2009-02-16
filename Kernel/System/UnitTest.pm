# --
# Kernel/System/UnitTest.pm - the global test wrapper
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: UnitTest.pm,v 1.21 2009-02-16 11:49:56 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::UnitTest;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.21 $) [1];

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
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        LogObject    => $LogObject,
        ConfigObject => $ConfigObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
    );
    my $UnitTestObject = Kernel::System::UnitTest->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # check needed objects
    for (qw(ConfigObject DBObject LogObject TimeObject MainObject EncodeObject)) {
        if ( $Param{$_} ) {
            $Self->{$_} = $Param{$_};
        }
        else {
            die "Got no $_!";
        }
    }

    $Self->{Output} = $Param{Output} || 'ASCII';

    if ( $Self->{Output} eq 'HTML' ) {
        print "
<html>
<head>
    <title>"
            . $Self->{ConfigObject}->Get('Product') . " "
            . $Self->{ConfigObject}->Get('Version')
            . " - Test Summary</title>
</head>
<a name='top'></a>
<body>

\n";
    }

    $Self->{XML}     = undef;
    $Self->{XMLUnit} = '';

    return $Self;
}

=item Run()

Run all tests located in scripts/test/*.t and print result to stdout.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my %ResultSummary = ();
    my $Home          = $Self->{ConfigObject}->Get('Home');
    my @Files         = glob("$Home/scripts/test/*.t");
    my $StartTime     = $Self->{TimeObject}->SystemTime();
    my $Product       = $Param{Product}
        || $Self->{ConfigObject}->Get('Product') . " " . $Self->{ConfigObject}->Get('Version');
    my @Names = split( /:/, $Param{Name} || '' );

    $Self->{TestCountOk}    = 0;
    $Self->{TestCountNotOk} = 0;
    for my $File (@Files) {

        # check if only some tests are requested
        if (@Names) {
            my $Use = 0;
            for my $Name (@Names) {
                if ( $Name && $File =~ /\/\Q$Name\E\.t$/ ) {
                    $Use = 1;
                }
            }
            if ( !$Use ) {
                next;
            }
        }
        $Self->{TestCount} = 0;
        my $ConfigFile = $Self->{MainObject}->FileRead( Location => $File );
        if ( !$ConfigFile ) {
            $Self->True( 0, "ERROR: $!: $File" );
            print STDERR "ERROR: $!: $File\n";
        }
        else {
            $Self->_PrintHeadlineStart($File);
            if ( !eval ${$ConfigFile} ) {
                $Self->True( 0, "ERROR: Syntax error in $File: $@" );
                print STDERR "ERROR: Syntax error in $File: $@\n";
            }
            $Self->_PrintHeadlineEnd($File);
        }
    }

    my $Time = $Self->{TimeObject}->SystemTime() - $StartTime;
    $ResultSummary{TimeTaken} = $Time;
    $ResultSummary{Time}      = $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );
    $ResultSummary{Product} = $Product;
    $ResultSummary{Host}    = $Self->{ConfigObject}->Get('FQDN');
    $ResultSummary{Perl}    = sprintf "%vd", $^V;
    $ResultSummary{OS}      = $^O;
    if ( -e '/etc/SuSE-release' ) {
        my $ConfigFile = $Self->{MainObject}->FileRead(
            Location => '/etc/SuSE-release',
            Result   => 'ARRAY',
        );
        if ( $ConfigFile && $ConfigFile->[0] ) {
            $ResultSummary{Vendor} = $ConfigFile->[0];
        }
        else {
            $ResultSummary{Vendor} = 'SUSE unknown';
        }
    }
    elsif ( -e '/etc/fedora-release' ) {
        my $ConfigFile = $Self->{MainObject}->FileRead(
            Location => '/etc/fedora-release',
            Result   => 'ARRAY',
        );
        if ( $ConfigFile && $ConfigFile->[0] ) {
            $ResultSummary{Vendor} = $ConfigFile->[0];
        }
        else {
            $ResultSummary{Vendor} = 'fedora unknown';
        }
    }
    elsif ( -e '/etc/redhat-release' ) {
        my $ConfigFile = $Self->{MainObject}->FileRead(
            Location => '/etc/redhat-release',
            Result   => 'ARRAY',
        );
        if ( $ConfigFile && $ConfigFile->[0] ) {
            $ResultSummary{Vendor} = $ConfigFile->[0];
        }
        else {
            $ResultSummary{Vendor} = 'RedHat unknown';
        }
    }
    elsif ( -e '/etc/debian_version' ) {
        my $ConfigFile = $Self->{MainObject}->FileRead(
            Location => '/etc/debian_version',
            Result   => 'ARRAY',
        );
        if ( $ConfigFile && $ConfigFile->[0] ) {
            $ResultSummary{Vendor} = 'debian ' . $ConfigFile->[0];
        }
        else {
            $ResultSummary{Vendor} = 'debian unknown';
        }
    }
    else {
        $ResultSummary{Vendor} = 'unknown';
    }
    chomp( $ResultSummary{Vendor} );
    $ResultSummary{Database}  = $Self->{DBObject}->{'DB::Type'};
    $ResultSummary{TestOk}    = $Self->{TestCountOk};
    $ResultSummary{TestNotOk} = $Self->{TestCountNotOk};

    $Self->_PrintSummary(%ResultSummary);
    my $XML = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n";
    $XML .= "<otrs_test>\n";
    $XML .= "<Summary>\n";
    for my $Key ( sort keys %ResultSummary ) {
        $ResultSummary{$Key} =~ s/&/&amp;/g;
        $ResultSummary{$Key} =~ s/</&lt;/g;
        $ResultSummary{$Key} =~ s/>/&gt;/g;
        $ResultSummary{$Key} =~ s/"/&quot;/g;
        $XML .= "  <Item Name=\"$Key\">$ResultSummary{$Key}</Item>\n";
    }
    $XML .= "</Summary>\n";
    for my $Key ( sort keys %{ $Self->{XML}->{Test} } ) {
        $XML .= "<Unit Name=\"$Key\">\n";
        for my $TestCount ( sort { $a <=> $b } keys %{ $Self->{XML}->{Test}->{$Key} } ) {
            my $Content = $Self->{XML}->{Test}->{$Key}->{$TestCount}->{Name};
            $Content =~ s/&/&amp;/g;
            $Content =~ s/</&lt;/g;
            $Content =~ s/>/&gt;/g;
            $Content =~ s/"/&quot;/g;
            $Content =~ s/'/&quot;/g;
            $XML
                .= "  <Test Result=\"$Self->{XML}->{Test}->{$Key}->{$TestCount}->{Result}\" Count=\"$TestCount\">$Content</Test>\n";
        }
        $XML .= "</Unit>\n";
    }
    $XML .= "</otrs_test>\n";
    if ( $Self->{Content} ) {
        print $Self->{Content};
    }
    if ( $Self->{Output} eq 'XML' && $XML ) {
        print $XML;
    }
    return 1;
}

=item True()

A true test.

    $UnitTestObject->True(1, 'Test Name');

    $UnitTestObject->True($A eq $B, 'Test Name');

=cut

sub True {
    my ( $Self, $True, $Name ) = @_;

    if ( !$Name ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Name! E. g. True(\$A, \'Test Name\')!'
        );
        $Self->_Print( 0, 'ERROR: Need Name! E. g. True(\$A, \'Test Name\')' );
        return;
    }

    if ($True) {
        $Self->_Print( 1, $Name );
        return 1;
    }
    else {
        $Self->_Print( 0, $Name );
        return;
    }
}

=item False()

A false test.

    $UnitTestObject->False(0, 'Test Name');

    $UnitTestObject->False($A ne $B, 'Test Name');

=cut

sub False {
    my ( $Self, $False, $Name ) = @_;

    if ( !$Name ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Name! E. g. False(\$A, \'Test Name\')!'
        );
        $Self->_Print( 0, 'ERROR: Need Name! E. g. False(\$A, \'Test Name\')' );
        return;
    }

    if ( !$False ) {
        $Self->_Print( 1, $Name );
        return 1;
    }
    else {
        $Self->_Print( 0, $Name );
        return;
    }
}

=item Is()

A Is $A (is) eq $B (should be) test.

    $UnitTestObject->Is($A, $B, 'Test Name');

=cut

sub Is {
    my ( $Self, $Test, $ShouldBe, $Name ) = @_;

    if ( !$Name ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Name! E. g. Is(\$A, \$B, \'Test Name\')!'
        );
        $Self->_Print( 0, 'ERROR: Need Name! E. g. Is(\$A, \$B, \'Test Name\')' );
        return;
    }

    if ( !defined $Test && !defined $ShouldBe ) {
        $Self->_Print( 1, "$Name (is 'undef')" );
        return 1;
    }
    elsif ( !defined $Test && defined $ShouldBe ) {
        $Self->_Print( 0, "$Name (is 'undef' should be '$ShouldBe')" );
        return;
    }
    elsif ( defined $Test && !defined $ShouldBe ) {
        $Self->_Print( 0, "$Name (is '$Test' should be 'undef')" );
        return;
    }
    elsif ( $Test eq $ShouldBe ) {
        $Self->_Print( 1, "$Name (is '$ShouldBe')" );
        return 1;
    }
    else {
        $Self->_Print( 0, "$Name (is '$Test' should be '$ShouldBe')" );
        return;
    }
}

=item IsNot()

A Is $A (is) nq $B (should not be) test.

    $UnitTestObject->IsNot($A, $B, 'Test Name');

=cut

sub IsNot {
    my ( $Self, $Test, $ShouldBe, $Name ) = @_;

    if ( !$Name ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Name! E. g. IsNot(\$A, \$B, \'Test Name\')!'
        );
        $Self->_Print( 0, 'ERROR: Need Name! E. g. IsNot(\$A, \$B, \'Test Name\')' );
        return;
    }

    if ( !defined $Test && !defined $ShouldBe ) {
        $Self->_Print( 0, "$Name (is 'undef')" );
        return;
    }
    elsif ( !defined $Test && defined $ShouldBe ) {
        $Self->_Print( 1, "$Name (is 'undef')" );
        return 1;
    }
    elsif ( defined $Test && !defined $ShouldBe ) {
        $Self->_Print( 1, "$Name (is '$Test')" );
        return 1;
    }
    if ( $Test ne $ShouldBe ) {
        $Self->_Print( 1, "$Name (is '$Test')" );
        return 1;
    }
    else {
        $Self->_Print( 0, "$Name (is '$Test' should not be '$ShouldBe')" );
        return;
    }
}

sub _PrintSummary {
    my ( $Self, %ResultSummary ) = @_;

    # show result
    if ( $Self->{Output} eq 'HTML' ) {
        print "<table width='600' border='1'>\n";
        if ( $ResultSummary{TestNotOk} ) {
            print "<tr><td bgcolor='red' colspan='2'>Summary</td></tr>\n";
        }
        else {
            print "<tr><td bgcolor='green' colspan='2'>Summary</td></tr>\n";
        }
        print "<tr><td>Product: </td><td>$ResultSummary{Product}</td></tr>\n";
        print "<tr><td>Test Time:</td><td>$ResultSummary{TimeTaken} s</td></tr>\n";
        print "<tr><td>Time:     </td><td> $ResultSummary{Time}</td></tr>\n";
        print "<tr><td>Host:     </td><td>$ResultSummary{Host}</td></tr>\n";
        print "<tr><td>Perl:     </td><td>$ResultSummary{Perl}</td></tr>\n";
        print "<tr><td>OS:       </td><td>$ResultSummary{OS}</td></tr>\n";
        print "<tr><td>Vendor:   </td><td>$ResultSummary{Vendor}</td></tr>\n";
        print "<tr><td>Database: </td><td>$ResultSummary{Database}</td></tr>\n";
        print "<tr><td>TestOk:   </td><td>$ResultSummary{TestOk}</td></tr>\n";
        print "<tr><td>TestNotOk:</td><td>$ResultSummary{TestNotOk}</td></tr>\n";
        print "</table><br>\n";
    }
    elsif ( $Self->{Output} eq 'ASCII' ) {
        print "=====================================================================\n";
        print " Product:   $ResultSummary{Product}\n";
        print " Test Time: $ResultSummary{TimeTaken} s\n";
        print " Time:      $ResultSummary{Time}\n";
        print " Host:      $ResultSummary{Host}\n";
        print " Perl:      $ResultSummary{Perl}\n";
        print " OS:        $ResultSummary{OS}\n";
        print " Vendor:    $ResultSummary{Vendor}\n";
        print " Database:  $ResultSummary{Database}\n";
        print " TestOk:    $ResultSummary{TestOk}\n";
        print " TestNotOk: $ResultSummary{TestNotOk}\n";
        print "=====================================================================\n";
    }
    return 1;
}

sub _PrintHeadlineStart {
    my ( $Self, $Name ) = @_;
    if ( !$Name ) {
        $Name = '->>No Name!<<-';
    }

    if ( $Self->{Output} eq 'HTML' ) {
        $Self->{Content} .= "<table width='600' border='1'>\n";
        $Self->{Content} .= "<tr><td colspan='2'>$Name</td></tr>\n";
    }
    elsif ( $Self->{Output} eq 'ASCII' ) {
        print "+-------------------------------------------------------------------+\n";
        print "$Name:\n";
        print "+-------------------------------------------------------------------+\n";
    }
    $Self->{XMLUnit} = $Name;
    return 1;
}

sub _PrintHeadlineEnd {
    my ( $Self, $Name ) = @_;
    if ( !$Name ) {
        $Name = '->>No Name!<<-';
    }

    if ( $Self->{Output} eq 'HTML' ) {
        $Self->{Content} .= "</table><br>\n";
    }
    elsif ( $Self->{Output} eq 'ASCII' ) {
    }
    return 1;
}

sub _Print {
    my ( $Self, $Test, $Name ) = @_;
    if ( !$Name ) {
        $Name = '->>No Name!<<-';
    }

    $Self->{TestCount}++;
    if ($Test) {
        $Self->{TestCountOk}++;
        if ( $Self->{Output} eq 'HTML' ) {
            $Self->{Content}
                .= "<tr><td width='70' bgcolor='green'>ok $Self->{TestCount}</td><td>$Name</td></tr>\n";
        }
        elsif ( $Self->{Output} eq 'ASCII' ) {
            print " ok $Self->{TestCount} - $Name\n";
        }
        $Self->{XML}->{Test}->{ $Self->{XMLUnit} }->{ $Self->{TestCount} }->{Result} = 'ok';
        $Self->{XML}->{Test}->{ $Self->{XMLUnit} }->{ $Self->{TestCount} }->{Name}   = $Name;
        return 1;
    }
    elsif ( $Self->{Output} eq 'ASCII' ) {
        $Self->{TestCountNotOk}++;
        if ( $Self->{Output} eq 'HTML' ) {
            $Self->{Content}
                .= "<tr><td width='70' bgcolor='red'>not ok $Self->{TestCount}</td><td>$Name</td></tr>\n";
        }
        else {
            print " not ok $Self->{TestCount} - $Name\n";
        }
        $Self->{XML}->{Test}->{ $Self->{XMLUnit} }->{ $Self->{TestCount} }->{Result} = 'not ok';
        $Self->{XML}->{Test}->{ $Self->{XMLUnit} }->{ $Self->{TestCount} }->{Name}   = $Name;
        return;
    }
}

sub DESTROY {
    my $Self = shift;

    if ( $Self->{Output} eq 'HTML' ) {
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
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.21 $ $Date: 2009-02-16 11:49:56 $

=cut
