# --
# ACLImport.t - ACL Import DB tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use vars (qw($Self));

use utf8;

use Kernel::Config;
use Kernel::System::ACL::DB::ACL;
use Kernel::System::UnitTest::Helper;
use Kernel::System::YAML;

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $ACLObject    = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $YAMLObject   = $Kernel::OM->Get('Kernel::System::YAML');

# define needed variables
my $RandomID = $HelperObject->GetRandomID();
my $Home     = $Self->{ConfigObject}->Get('Home');
my $UserID   = 1;

my $CheckACL = sub {
    my %Param = @_;

    my $Test          = $Param{Test};
    my %ACLDataLookup = %{ $Param{ACLDataLookup} };
    my $ACLName       = $Param{ACLName};
    my $ACL           = $Param{ACL};

    # update ACL reference from 3.3.x style if needed
    if ( ref $ACLDataLookup{$ACLName}->{ConfigChange}->{Possible}->{Action} eq 'HASH' ) {
        my %ActionList = %{ $ACLDataLookup{$ACLName}->{ConfigChange}->{Possible}->{Action} };
        my @PossibleNotActions;

        ACTION:
        for my $Action ( sort keys %ActionList ) {
            next ACTION if $ActionList{$Action} ne 0;
            push @PossibleNotActions, $Action;
        }

        delete $ACLDataLookup{$ACLName}->{ConfigChange}->{Possible}->{Action};
        $ACLDataLookup{$ACLName}->{ConfigChange}->{PossibleNot}->{Action} = \@PossibleNotActions;
    }

    for my $Attribute (
        qw( Name Comment Description StopAfterMatch ConfigMatch ConfigChange ValidID)
        )
    {
        if ( $Attribute eq 'ConfigMatch' || $Attribute eq 'ConfigChange' ) {
            $Self->IsDeeply(
                $ACL->{$Attribute},
                $ACLDataLookup{$ACLName}->{$Attribute},
                "ACLImport() $Test->{Name} - $ACLName Expected Attribute $Attribute",
            );
        }
        else {

            # set undefined values as empty (quick fix for ORACLE)
            $ACL->{$Attribute} //= '';

            $Self->Is(
                $ACL->{$Attribute},
                $ACLDataLookup{$ACLName}->{$Attribute},
                "ACLImport() $Test->{Name} - $ACLName Expected Attribute $Attribute",
            );
        }
    }
};

#
# Tests for ACLAdd
#
my @Tests = (
    {
        Name    => 'ACLImport Test: No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name    => 'ACLImport Test: No UserID',
        Config  => {},
        ACLFile => 'Properties.yml',
        Success => 0,
    },
    {
        Name   => 'ACLImport Test: No Content',
        Config => {
            Content => '',
            UserID  => $UserID
        },
        Success => 0,
    },
    {
        Name   => 'ACLImport Test: Properties',
        Config => {
            UserID => $UserID,
        },
        ACLFile         => 'Properties.yml',
        ExpectedResults => {
            AddedACLs   => "100-ACL-Test-Properties$RandomID",
            UpdatedACLs => '',
            ACLErrors   => '',
        },
        Success => 1,
    },
    {
        Name   => 'ACLImport Test: PropertiesDatabase',
        Config => {
            UserID => $UserID,
        },
        ACLFile         => 'PropertiesDatabase.yml',
        ExpectedResults => {
            AddedACLs   => "100-ACL-Test-PropertiesDatabase$RandomID",
            UpdatedACLs => '',
            ACLErrors   => '',
        },
        Success => 1,
    },
    {
        Name   => 'ACLImport Test: PossibleNot',
        Config => {
            UserID => $UserID,
        },
        ACLFile         => 'PossibleNot.yml',
        ExpectedResults => {
            AddedACLs   => "100-ACL-Test-PossibleNot$RandomID",
            UpdatedACLs => '',
            ACLErrors   => '',
        },
        Success => 1,
    },
    {
        Name   => 'ACLImport Test: Multiple',
        Config => {
            UserID => $UserID,
        },
        ACLFile         => 'Multiple.yml',
        ExpectedResults => {
            AddedACLs   => "100-ACL-Test-Multiple1$RandomID, 100-ACL-Test-Multiple2$RandomID",
            UpdatedACLs => '',
            ACLErrors   => '',
        },
        Success => 1,
    },
    {
        Name   => 'ACLImport Test: Properties Updated without Overwrite',
        Config => {
            UserID => $UserID,
        },
        ACLFile         => 'PropertiesUpdated.yml',
        ExpectedResults => {
            AddedACLs   => '',
            UpdatedACLs => '',
            ACLErrors   => "100-ACL-Test-Properties$RandomID",
        },
        Success => 1,
    },
    {
        Name   => 'ACLImport Test: Properties Updated with Overwrite',
        Config => {
            OverwriteExistingEntities => 1,
            UserID                    => $UserID,
        },
        ACLFile         => 'PropertiesUpdated.yml',
        ExpectedResults => {
            AddedACLs   => '',
            UpdatedACLs => "100-ACL-Test-Properties$RandomID",
            ACLErrors   => '',
        },
        Success => 1,
    },
    {
        Name   => 'ACLImport Test: Actions from 3.3.x',
        Config => {
            UserID => $UserID,
        },
        ACLFile         => 'Actions33.yml',
        ExpectedResults => {
            AddedACLs   => "100-ACL-Test-Actions33$RandomID",
            UpdatedACLs => '',
            ACLErrors   => '',
        },
        Success => 1,
    },
    {
        Name   => 'ACLImport Test: Actions from 3.3.x Empty',
        Config => {
            UserID => $UserID,
        },
        ACLFile         => 'Actions33Empty.yml',
        ExpectedResults => {
            AddedACLs   => "100-ACL-Test-Actions33Empty$RandomID",
            UpdatedACLs => '',
            ACLErrors   => '',
        },
        Success => 1,
    },
);

my %ACLToDelete;
for my $Test (@Tests) {

    my $ACLData;

    # read process for yml file if needed
    my $FileRef;
    if ( $Test->{ACLFile} ) {
        $FileRef = $Self->{MainObject}->FileRead(
            Location => $Home . '/scripts/test/sample/ACL/' . $Test->{ACLFile},
        );
        my $RandomID = $HelperObject->GetRandomID();

        # convert process to Perl for easy handling
        $ACLData = $YAMLObject->Load( Data => $$FileRef );
    }

    # update all ACL names for easy search
    if ( IsArrayRefWithData($ACLData) ) {
        for my $ACLItem ( @{$ACLData} ) {
            $ACLItem->{Name} .= $RandomID;
        }
    }

    # convert process back to YAML and set it as part of the config
    my $Content = $YAMLObject->Dump( Data => $ACLData );
    $Test->{Config}->{Content} = $Content;

    # call import function
    my $ACLImport = $ACLObject->ACLImport( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->True(
            $ACLImport->{Success},
            "ACLImport() $Test->{Name} - return value with true",
        );

        for my $ResultKey ( sort keys %{ $Test->{ExpectedResults} } ) {
            $Self->Is(
                $ACLImport->{$ResultKey},
                $Test->{ExpectedResults}->{$ResultKey},
                "ACLImport() $Test->{Name} - Expected $ResultKey",
            );
        }

        my %ACLDataLookup = map { $_->{Name} => $_ } @{$ACLData};

        my @AddedACLs = split ',', $ACLImport->{AddedACLs};
        for my $ACLName (@AddedACLs) {

            # cleanup possilbe leasing whitespaces in name
            $ACLName =~ s{^\s+}{};
            my $ACL = $ACLObject->ACLGet(
                Name   => $ACLName,
                UserID => $UserID,
            );

            $CheckACL->(
                Test          => $Test,
                ACLDataLookup => \%ACLDataLookup,
                ACLName       => $ACLName,
                ACL           => $ACL
            );

            $ACLToDelete{ $ACL->{ID} } = 1;
        }

        my @UpdatedACLs = split ',', $ACLImport->{UpdatedACLs};
        for my $ACLName (@UpdatedACLs) {

            # cleanup possilbe leasing whitespaces in name
            $ACLName =~ s{^\s+}{};
            my $ACL = $ACLObject->ACLGet(
                Name   => $ACLName,
                UserID => $UserID,
            );

            $CheckACL->(
                Test          => $Test,
                ACLDataLookup => \%ACLDataLookup,
                ACLName       => $ACLName,
                ACL           => $ACL
            );
        }
    }
    else {
        $Self->False(
            $ACLImport->{Success},
            "ACLImport() $Test->{Name} - return value with false",
        );

    }
}

print "------------System Cleanup------------\n";

# remove added ACLs
for my $ACLID ( sort keys %ACLToDelete ) {
    my $Success = $ACLObject->ACLDelete(
        ID     => $ACLID,
        UserID => $UserID,
    );

    # sanity check
    $Self->True(
        $Success,
        "ACLDelete() ACLID:$ACLID | Deleted sucessfully",
    );

    $Self->True(
        $ACLObject->ACLsNeedSync(),
        "ACLDelete() ACLID:$ACLID sync flag set after ACLDelete",
    );

    $Self->True(
        $ACLObject->ACLsNeedSyncReset(),
        "ACLDelete() ACLID:$ACLID sync flag reset",
    );

    $Self->False(
        $ACLObject->ACLsNeedSync(),
        "ACLDelete() ACLID:$ACLID sync flag not set after reset",
    );
}

1;
