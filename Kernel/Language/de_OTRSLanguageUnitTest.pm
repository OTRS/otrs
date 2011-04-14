# --
# Kernel/Language/de_OTRSLanguageUnitTest.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: de_OTRSLanguageUnitTest.pm,v 1.1.2.1 2011-04-14 12:20:54 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_OTRSLanguageUnitTest;

use strict;

sub Data {
    my $Self = shift;

     $Self->{Translation}->{'OTRSLanguageUnitTest::Test1'} = 'Test1';
     $Self->{Translation}->{'OTRSLanguageUnitTest::Test2'} = 'Test2 [%s]';
     $Self->{Translation}->{'OTRSLanguageUnitTest::Test3'} = 'Test3 [%s] (A=%s)';
     $Self->{Translation}->{'OTRSLanguageUnitTest::Test4'} = 'Test4 [%s] (A=%s;B=%s)';
     $Self->{Translation}->{'OTRSLanguageUnitTest::Test5'} = 'Test5 [%s] (A=%s;B=%s;C=%s)';
     $Self->{Translation}->{'OTRSLanguageUnitTest::Test6'} = 'Test6 [%s] (A=%s;B=%s;C=%s;D=%s)';
}

1;
