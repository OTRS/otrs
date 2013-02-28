# --
# Main/Flock.t - flock in file read / write tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Time::HiRes ();

use Kernel::System::DB;

# this test only works in *nix
if ( $^O =~ /^mswin/i ) {

    $Self->True(
        1,
        'Microsft Windows OS was detected, this test can not run on under this OS'
            . '... skiping all other tests!',
    );
    return 1;
}

# this function was addapted from main.pm FileWrite (should be in sync with Main.pm)

=item FileWriteSleep->()

to write data to file system

    my $FileLocation = $FileWriteSleep->(
        Directory => 'c:\some\location',
        Filename  => 'me_to/alal.xml',
        # or Location
        Location  => 'c:\some\location\me_to\alal.xml'

        Content   => \$Content,
        Sleep     => 5,
        Who       => 'Parent'   # or Child, default Parent
    );

    my $FileLocation = $FileWriteSleep(
        Directory  => 'c:\some\location',
        Filename   => 'me_to/alal.xml',
        # or Location
        Location   => 'c:\some\location\me_to\alal.xml'

        Content    => \$Content,
        Mode       => 'binmode', # binmode|utf8
        Type       => 'Local',   # optional - Local|Attachment|MD5
        Permission => '644',     # unix file permissions
    );

=cut

my $FileWriteSleep = sub {
    my %Param = @_;

    if ( $Param{Filename} && $Param{Directory} ) {

        # filename clean up
        $Param{Filename} = $Self->FilenameCleanUp(
            Filename => $Param{Filename},
            Type => $Param{Type} || 'Local',    # Local|Attachment|MD5
        );
        $Param{Location} = "$Param{Directory}/$Param{Filename}";
    }
    elsif ( $Param{Location} ) {

        # filename clean up
        $Param{Location} =~ s/\/\//\//g;
    }
    else {
        $Self->True(
            0,
            'From $Param{Who} - FileWriteSleep->() Need Filename and Directory or Location!'
        );
    }

    # set sleep parameter
    if ( !defined $Param{Sleep} ) {
        $Param{Sleep} = 0;
    }

    # set process references
    if ( !defined $Param{Who} ) {
        $Param{Who} = 'Parent';
    }

    # set open mode (if file exists, lock it on open, done by '+<')
    my $Exists;
    if ( -f $Param{Location} ) {
        $Exists = 1;
    }
    my $Mode = '>';
    if ($Exists) {
        $Mode = '+<';
    }
    if ( $Param{Mode} && $Param{Mode} =~ /^(utf8|utf\-8)/i ) {
        $Mode = '>:utf8';
        if ($Exists) {
            $Mode = '+<:utf8';
        }
    }

    # return if file can not open
    my $FH;
    if ( !open $FH, $Mode, $Param{Location} ) {    ## no critic
        $Self->True(
            0,
            "From $Param{Who} - FileWriteSleep->() Can't write '$Param{Location}': $!",
        );
        return;
    }
    else {
        $Self->True(
            1,
            "From $Param{Who} - FileWriteSleep->() Open file '$Param{Location}' for write in "
                . "mode '$Mode'",
        );
    }

    # lock file (Exclusive Lock)
    if ( !flock $FH, 2 ) {
        $Self->True(
            0,
            "From $Param{Who} - FileWriteSleep->() Can't lock '$Param{Location}': $!",
        );
    }
    else {
        $Self->True(
            1,
            "From $Param{Who} - FileWriteSleep->() Locked file '$Param{Location}' exclusive",
        );
    }

    # empty file first (needed if file is open by '+<')
    truncate $FH, 0;

    # enable binmode
    if ( !$Param{Mode} || lc $Param{Mode} eq 'binmode' ) {

        # make sure, that no utf8 stamp exists (otherway perl will do auto convert to iso)
        $Self->{EncodeObject}->EncodeOutput( $Param{Content} );

        # set file handle to binmode
        binmode $FH;
    }

    # write file if content is not undef
    if ( defined ${ $Param{Content} } ) {
        print $FH ${ $Param{Content} };
        $Self->True(
            1,
            "From $Param{Who} - FileWriteSleep->() Test file writent with: '${ $Param{Content} }'",
        );
    }

    # write empty file if content is undef
    else {
        print $FH '';
        $Self->True(
            1,
            "From $Param{Who} - FileWriteSleep->() Test file writent with: ''",
        );
    }

    # wait with file locked
    print "From $Param{Who} - Sleeping for $Param{Sleep} secs with file locked\n";
    sleep $Param{Sleep};

    # close the filehandle
    close $FH;
    $Self->True(
        1,
        "From $Param{Who} - FileWriteSleep->() Test file closed",
    );

    # set permission
    if ( $Param{Permission} ) {
        if ( length $Param{Permission} == 3 ) {
            $Param{Permission} = "0$Param{Permission}";
        }
        chmod( oct( $Param{Permission} ), $Param{Location} );
    }

    return $Param{Filename} if $Param{Filename};
    return $Param{Location};
};

#
# Pepare test
#

# set test file to read and write
my $File = $Self->{ConfigObject}->Get('Home') . '/var/tmp/flock_' . rand(1000000);

# delete test file if exists
if ( -e $File ) {
    unlink $File;
}

my $InitialContent = "IV A New Hope";
my $ChildContent   = "V Emprire Strikes Back";
my $ParentContent  = "VI Return Of The Jedi";

#
# Start tests
#

# get time before write
my $TimeStart = [ Time::HiRes::gettimeofday() ];

$Self->Is(
    ref $TimeStart,
    'ARRAY',
    "Time::HiRes::gettimeofday() returned correct format",
);

if ( ref $TimeStart eq 'ARRAY' ) {
    my $Counter = 1;
    for my $Element (@$TimeStart) {
        $Self->IsNot(
            $Element,
            0,
            "Element $Counter from Time::HiRes::gettimeofday() is different than 0",
        );
        $Counter++;
    }
}
else {

    # maybe Time::HiRes is not intalled
    $Self->True(
        0,
        "Provably Time::HiRes module is not installed in this system",
    );
}

# write initial content in test file
my $FileLocation = $Self->{MainObject}->FileWrite(
    Location => $File,
    Content  => \$InitialContent,
);

# get time after write
my $TimeElapsed = Time::HiRes::tv_interval($TimeStart);

# sanity tests
$Self->True(
    $FileLocation,
    "From Parent - Test file $File was written successfuly",
);

$Self->True(
    $TimeElapsed < 1,
    "From Parent - Test file write took less than 1s (${TimeElapsed}s)",
);

my $ReadContentRef = $Self->{MainObject}->FileRead(
    Location => $File,
);

$Self->Is(
    ${$ReadContentRef},
    $InitialContent,
    "From Parent - Test file content match expected result",
);

# create one child process
print "From Parent - Create a child process\n";
my $PID = fork();

# refresh DBObject in both parent and child (otherwise when child terinates DB handlers disconect
# on both)
$Self->{DBObject} = Kernel::System::DB->new( %{$Self} );

my $Who = !defined $PID || $PID != 0 ? 'Parent' : 'Child';
$Self->Is(
    ref $Self->{DBObject},
    'Kernel::System::DB',
    "From $Who - DBObject correctly refreshed",
);

# check if child was not created
if ( !defined $PID ) {

    # call always a falling test to output the message
    $Self->True(
        0,
        'Child process could not be created',
    );
}

# child code:
elsif ( $PID == 0 ) {

    # read the test file
    my $ReadContentRef = $Self->{MainObject}->FileRead(
        Location => $File,
    );

    $Self->Is(
        ${$ReadContentRef},
        $InitialContent,
        "From Child - Test file content match expected result",
    );

    # wait for parent to read the file
    print "From Child - Sleeping 2 sec, so parent read the file\n";
    sleep 2;

    $FileWriteSleep->(
        Location => $File,
        Content  => \$ChildContent,
        Sleep    => 10,
        Who      => 'Child',
    );

    # read should wait until parent (that is waiting for unlock) writes the file
    # check contents after write
    $ReadContentRef = $Self->{MainObject}->FileRead(
        Location => $File,
    );

    # the file should not contain child content, but parent content
    $Self->Is(
        ${$ReadContentRef},
        $ParentContent,
        "From Child - Test file content match expected result (parent content)",
    );

    # terminate child process (this will close DBI connections)
    exit 0;
}

# parent code:
else {

    # wait until child read the file
    print "From Parent - Sleeping 1 sec, so child read the test file\n";
    sleep 1;

    # parent read file
    my $ReadContentRef = $Self->{MainObject}->FileRead(
        Location => $File,
    );

    $Self->Is(
        ${$ReadContentRef},
        $InitialContent,
        "From Parent - Test file content match expected result",
    );

    # wait until child locks the file
    print "From Parent - Sleeping 2 sec, so child locks the file\n";
    sleep 2;

    # get time before write
    my $TimeStart = [ Time::HiRes::gettimeofday() ];

    # write parent content in test file
    my $FileLocation = $Self->{MainObject}->FileWrite(
        Location => $File,
        Content  => \$ParentContent,
    );

    # get time after write
    my $TimeElapsed2 = Time::HiRes::tv_interval($TimeStart);

    # sanity tests
    $Self->True(
        $FileLocation,
        "From Parent - Test file $File was written successfuly",
    );

    $Self->True(
        $TimeElapsed2 > $TimeElapsed,
        "From Parent - Test file write took much more than ${TimeElapsed}s (${TimeElapsed2}s)",
    );

    $ReadContentRef = $Self->{MainObject}->FileRead(
        Location => $File,
    );

    $Self->Is(
        ${$ReadContentRef},
        $ParentContent,
        "From Parent - Test file content match expected result",
    );

    # wait bloked until child process ends
    waitpid $PID, 0;
}

# delete testfile
my $DeleteSuccess = $Self->{MainObject}->FileDelete(
    Location => $File,
);

$Self->True(
    $DeleteSuccess,
    "From Parent - Test file successfully deleted",
);

1;
