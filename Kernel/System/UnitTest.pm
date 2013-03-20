# --
# Kernel/System/UnitTest.pm - the global test wrapper
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::UnitTest;

use strict;
use warnings;

use if $^O eq 'MSWin32', "Win32::Console::ANSI";
use Term::ANSIColor;

use vars qw(@ISA);

=head1 NAME

Kernel::System::UnitTest - global test interface

=head1 SYNOPSIS

Functions to run existing unit tests, as well as
functions to define test cases.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create unit test object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Time;
    use Kernel::System::UnitTest;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $UnitTestObject = Kernel::System::UnitTest->new(
        EncodeObject => $EncodeObject,
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

    $UnitTestObject->Run(
        Name      => 'JSON:User:Auth',  # optional, control which tests to select
        Directory => 'Selenium',        # optional, control which tests to select
    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my %ResultSummary;
    my $Home = $Self->{ConfigObject}->Get('Home');

    my $Directory = "$Home/scripts/test";

    # custom subdirectory passed
    if ( $Param{Directory} ) {
        $Directory .= "/$Param{Directory}";
        $Directory =~ s/\.//g;
    }

    my @Files = $Self->{MainObject}->DirectoryRead(
        Directory => $Directory,
        Filter => [ '*.t', '*/*.t', '*/*/*.t', '*/*/*/*.t', '*/*/*/*/*.t', '*/*/*/*/*/*.t' ],
    );

    my $StartTime = $Self->{TimeObject}->SystemTime();
    my $Product   = $Param{Product}
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
        my $UnitTestFile = $Self->{MainObject}->FileRead( Location => $File );
        if ( !$UnitTestFile ) {
            $Self->True( 0, "ERROR: $!: $File" );
            print STDERR "ERROR: $!: $File\n";
        }
        else {
            $Self->_PrintHeadlineStart($File);

            # create a new scope to be sure to destroy local object of the test files
            {

                # HERE the actual tests are run!!!
                if ( !eval ${$UnitTestFile} ) {    ## no critic
                    $Self->True( 0, "ERROR: Syntax error in $File: $@" );
                    print STDERR "ERROR: Syntax error in $File: $@\n";
                }
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
            $ResultSummary{Vendor} = 'Fedora unknown';
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
    elsif ( -e '/etc/lsb-release' ) {

        my $ConfigFile = $Self->{MainObject}->FileRead(
            Location => '/etc/lsb-release',
            Result   => 'ARRAY',
        );

        if ( $ConfigFile && $ConfigFile->[0] ) {
            $ConfigFile->[0] =~ s/DISTRIB_ID=//;
            $ResultSummary{Vendor} = $ConfigFile->[0];
            if ( $ConfigFile->[1] ) {
                $ConfigFile->[1] =~ s/DISTRIB_RELEASE=//;
                chomp $ResultSummary{Vendor};
                $ResultSummary{Vendor} .= ' ' . $ConfigFile->[1];
            }
            else {
                $ResultSummary{Vendor} .= ' (unknown release)';
            }
        }
        else {
            $ResultSummary{Vendor} = 'Ubuntu unknown';
        }
    }
    elsif ( -e '/etc/debian_version' ) {

        my $ConfigFile = $Self->{MainObject}->FileRead(
            Location => '/etc/debian_version',
            Result   => 'ARRAY',
        );

        if ( $ConfigFile && $ConfigFile->[0] ) {
            $ResultSummary{Vendor} = 'Debian ' . $ConfigFile->[0];
        }
        else {
            $ResultSummary{Vendor} = 'Debian unknown';
        }
    }
    elsif ( -e '/etc/gentoo-release' ) {

        my $ConfigFile = $Self->{MainObject}->FileRead(
            Location => '/etc/gentoo-release',
            Result   => 'ARRAY',
        );

        if ( $ConfigFile && $ConfigFile->[0] ) {
            $ResultSummary{Vendor} = $ConfigFile->[0];
        }
        else {
            $ResultSummary{Vendor} = 'Gentoo unknown';
        }
    }
    elsif ( $^O eq 'freebsd' ) {

        my $Release = `uname -r`;
        $ResultSummary{Vendor} = 'FreeBSD ' . $Release;
    }
    elsif ( $^O eq 'MSWin32' ) {

        $ResultSummary{Vendor} = 'MS Windows unknown';

        my @Release = `systeminfo`;

        for my $Row (@Release) {

            my ($Name) = $Row =~ m{ \A OS \s Name: \s+ (.+?) \s* \z }xms;

            if ($Name) {
                $Name =~ s{Microsoft}{MS}xmsg;
                $ResultSummary{Vendor} = $Name;
            }

            my ($Version) = $Row =~ m{ \A OS \s Version: \s+ (.+?) \s* \z }xms;

            if ($Version) {
                $ResultSummary{Vendor} .= ' ' . $Version;
            }
        }
    }
    else {
        $ResultSummary{Vendor} = 'unknown';
    }

    chomp $ResultSummary{Vendor};
    $ResultSummary{Database}  = $Self->{DBObject}->{'DB::Type'};
    $ResultSummary{TestOk}    = $Self->{TestCountOk};
    $ResultSummary{TestNotOk} = $Self->{TestCountNotOk};

    $Self->_PrintSummary(%ResultSummary);
    if ( $Self->{Content} ) {
        print $Self->{Content};
    }

    if ( $Self->{Output} eq 'XML' ) {
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

            # extract duration time
            my $Duration = $Self->{Duration}->{$Key};

            $XML .= "<Unit Name=\"$Key\" Duration=\"$Duration\">\n";

            for my $TestCount ( sort { $a <=> $b } keys %{ $Self->{XML}->{Test}->{$Key} } ) {
                my $Result  = $Self->{XML}->{Test}->{$Key}->{$TestCount}->{Result};
                my $Content = $Self->{XML}->{Test}->{$Key}->{$TestCount}->{Name};
                $Content =~ s/&/&amp;/g;
                $Content =~ s/</&lt;/g;
                $Content =~ s/>/&gt;/g;
                $XML .= qq|  <Test Result="$Result" Count="$TestCount">$Content</Test>\n|;
            }

            $XML .= "</Unit>\n";
        }
        $XML .= "</otrs_test>\n";

        print $XML;
    }
    return 1;
}

=item True()

test for a scalar value that evaluates to true.

Send a scalar value to this function along with the test's name:

    $UnitTestObject->True(1, 'Test Name');

    $UnitTestObject->True($ParamA, 'Test Name');

Internally, the function receives this value and evaluates it to see
if it's true, returning 1 in this case or undef, otherwise.

    my $TrueResult = $UnitTestObject->True(
        $TestValue,
        'Test Name',
    );

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

test for a scalar value that evaluates to false.

It has the same interface as L<True()>, but tests
for a false value instead.

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

compares two scalar values for equality.

To this function you must send a pair of scalar values to compare them,
and the name that the test will take, this is done as shown in the examples
below.

    $UnitTestObject->Is($A, $B, 'Test Name');

Returns 1 if the values were equal, or undef otherwise.

    my $IsResult = $UnitTestObject->Is(
        $ValueFromFunction,      # test data
        1,                       # expected value
        'Test Name',
    );

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

compares two scalar values for inequality.

It has the same interface as L<Is()>, but tests
for inequality instead.

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

=item IsDeeply()

compares complex data structures for equality.

To this function you must send the references to two data structures to be compared,
and the name that the test will take, this is done as shown in the examples
below.

    $UnitTestObject-> IsDeeply($ParamA, $ParamB, 'Test Name');

Where $ParamA and $ParamB must be references to a structure (scalar, list or hash).

Returns 1 if the data structures are the same, or undef otherwise.

    my $IsDeeplyResult = $UnitTestObject->IsDeeply(
        \%ResultHash,           # test data
        \%ExpectedHash,         # expected value
        'Dummy Test Name',
    );

=cut

sub IsDeeply {
    my ( $Self, $Test, $ShouldBe, $Name ) = @_;

    if ( !$Name ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Name! E. g. Is(\$A, \$B, \'Test Name\')!'
        );
        $Self->_Print( 0, 'ERROR: Need Name! E. g. Is(\$A, \$B, \'Test Name\')' );
        return;
    }

    my $Diff = $Self->_DataDiff(
        Data1 => $Test,
        Data2 => $ShouldBe,
    );

    if ( !defined $Test && !defined $ShouldBe ) {
        $Self->_Print( 1, "$Name (is 'undef')" );
        return 1;
    }
    elsif ( !defined $Test && defined $ShouldBe ) {
        $Self->_Print( 0, "$Name (is 'undef' should be defined)" );
        return;
    }
    elsif ( defined $Test && !defined $ShouldBe ) {
        $Self->_Print( 0, "$Name (is defined should be 'undef')" );
        return;
    }
    elsif ( !$Diff ) {
        $Self->_Print( 1, "$Name matches expected value" );
        return 1;
    }
    else {
        my $ShouldBeDump = $Self->{MainObject}->Dump($ShouldBe);
        my $TestDump     = $Self->{MainObject}->Dump($Test);
        $Self->_Print( 0, "$Name (is '$TestDump' should be '$ShouldBeDump')" );
        return;
    }
}

=item IsNotDeeply()

compares two data structures for inequality.

It has the same interface as L<IsDeeply()>, but tests
for inequality instead.

=cut

sub IsNotDeeply {
    my ( $Self, $Test, $ShouldBe, $Name ) = @_;

    if ( !$Name ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Name! E. g. IsNot(\$A, \$B, \'Test Name\')!'
        );
        $Self->_Print( 0, 'ERROR: Need Name! E. g. IsNot(\$A, \$B, \'Test Name\')' );
        return;
    }

    my $Diff = $Self->_DataDiff(
        Data1 => $Test,
        Data2 => $ShouldBe,
    );

    if ( !defined $Test && !defined $ShouldBe ) {
        $Self->_Print( 0, "$Name (is 'undef')" );
        return;
    }
    elsif ( !defined $Test && defined $ShouldBe ) {
        $Self->_Print( 1, "$Name (is 'undef')" );
        return 1;
    }
    elsif ( defined $Test && !defined $ShouldBe ) {
        $Self->_Print( 1, "$Name (differs from expected value)" );
        return 1;
    }

    if ($Diff) {
        $Self->_Print( 1, "$Name (The structures are not equal.)" );
        return 1;
    }
    else {

        #        $Self->_Print( 0, "$Name (matches the expected value)" );
        my $TestDump = $Self->{MainObject}->Dump($Test);
        $Self->_Print( 0, "$Name (The structures are equal: '$TestDump')" );

        return;
    }
}

=begin Internal:

=cut

=item _DataDiff()

compares two data structures with each other. Returns 1 if
they are different, undef otherwise.

Data parameters need to be passed by reference and can be SCALAR,
ARRAY or HASH.

    my $DataIsDifferent = $SysConfigObject->_DataDiff(
        Data1 => \$Data1,
        Data2 => \$Data2,
    );

=cut

sub _DataDiff {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data1 Data2)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # ''
    if ( ref $Param{Data1} eq '' && ref $Param{Data2} eq '' ) {

        # do nothing, it's ok
        return if !defined $Param{Data1} && !defined $Param{Data2};

        # return diff, because its different
        return 1 if !defined $Param{Data1} || !defined $Param{Data2};

        # return diff, because its different
        return 1 if $Param{Data1} ne $Param{Data2};

        # return, because its not different
        return;
    }

    # SCALAR
    if ( ref $Param{Data1} eq 'SCALAR' && ref $Param{Data2} eq 'SCALAR' ) {

        # do nothing, it's ok
        return if !defined ${ $Param{Data1} } && !defined ${ $Param{Data2} };

        # return diff, because its different
        return 1 if !defined ${ $Param{Data1} } || !defined ${ $Param{Data2} };

        # return diff, because its different
        return 1 if ${ $Param{Data1} } ne ${ $Param{Data2} };

        # return, because its not different
        return;
    }

    # ARRAY
    if ( ref $Param{Data1} eq 'ARRAY' && ref $Param{Data2} eq 'ARRAY' ) {
        my @A = @{ $Param{Data1} };
        my @B = @{ $Param{Data2} };

        # check if the count is different
        return 1 if $#A ne $#B;

        # compare array
        for my $Count ( 0 .. $#A ) {

            # do nothing, it's ok
            next if !defined $A[$Count] && !defined $B[$Count];

            # return diff, because its different
            return 1 if !defined $A[$Count] || !defined $B[$Count];

            if ( $A[$Count] ne $B[$Count] ) {
                if ( ref $A[$Count] eq 'ARRAY' || ref $A[$Count] eq 'HASH' ) {
                    return 1 if $Self->_DataDiff( Data1 => $A[$Count], Data2 => $B[$Count] );
                    next;
                }
                return 1;
            }
        }
        return;
    }

    # HASH
    if ( ref $Param{Data1} eq 'HASH' && ref $Param{Data2} eq 'HASH' ) {
        my %A = %{ $Param{Data1} };
        my %B = %{ $Param{Data2} };

        # compare %A with %B and remove it if checked
        for my $Key ( sort keys %A ) {

            # Check if both are undefined
            if ( !defined $A{$Key} && !defined $B{$Key} ) {
                delete $A{$Key};
                delete $B{$Key};
                next;
            }

            # return diff, because its different
            return 1 if !defined $A{$Key} || !defined $B{$Key};

            if ( $A{$Key} eq $B{$Key} ) {
                delete $A{$Key};
                delete $B{$Key};
                next;
            }

            # return if values are different
            if ( ref $A{$Key} eq 'ARRAY' || ref $A{$Key} eq 'HASH' ) {
                return 1 if $Self->_DataDiff( Data1 => $A{$Key}, Data2 => $B{$Key} );
                delete $A{$Key};
                delete $B{$Key};
                next;
            }
            return 1;
        }

        # check rest
        return 1 if %B;
        return;
    }

    if ( ref $Param{Data1} eq 'REF' && ref $Param{Data2} eq 'REF' ) {
        return 1 if $Self->_DataDiff( Data1 => ${ $Param{Data1} }, Data2 => ${ $Param{Data2} } );
        return;
    }

    return 1;
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

    # set default name
    $Name ||= '->>No Name!<<-';

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

    # set duration start time
    $Self->{DurationStartTime}->{$Name} = $Self->{TimeObject}->SystemTime();

    return 1;
}

sub _PrintHeadlineEnd {
    my ( $Self, $Name ) = @_;

    # set default name
    $Name ||= '->>No Name!<<-';

    if ( $Self->{Output} eq 'HTML' ) {
        $Self->{Content} .= "</table><br>\n";
    }
    elsif ( $Self->{Output} eq 'ASCII' ) {
    }

    # calculate duration time
    my $Duration = '';
    if ( $Self->{DurationStartTime}->{$Name} ) {

        $Duration = $Self->{TimeObject}->SystemTime() - $Self->{DurationStartTime}->{$Name};

        delete $Self->{DurationStartTime}->{$Name};
    }
    $Self->{Duration}->{$Name} = $Duration;

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
            print color('green') . " ok" . color('reset') . " $Self->{TestCount} - $Name\n";
        }
        $Self->{XML}->{Test}->{ $Self->{XMLUnit} }->{ $Self->{TestCount} }->{Result} = 'ok';
        $Self->{XML}->{Test}->{ $Self->{XMLUnit} }->{ $Self->{TestCount} }->{Name}   = $Name;
        return 1;
    }
    else {
        $Self->{TestCountNotOk}++;
        if ( $Self->{Output} eq 'HTML' ) {
            $Self->{Content}
                .= "<tr><td width='70' bgcolor='red'>not ok $Self->{TestCount}</td><td>$Name</td></tr>\n";
        }
        elsif ( $Self->{Output} eq 'ASCII' ) {
            print color('red') . " not ok" . color('reset') . " $Self->{TestCount} - $Name\n";
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

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
