
    # --------------------------------------------------- #
    # FAQ settings
    # --------------------------------------------------- #

    $Self->{'FAQ::FAQHook'} = 'FAQ#';
    $Self->{'FAQ::Default::State'} = 'internal (agent)';

    $Self->{'FAQ::Field1'} = 'Symptom';
    $Self->{'FAQ::Field2'} = 'Problem';
    $Self->{'FAQ::Field3'} = 'Solution';
    $Self->{'FAQ::Field4'} = 'field4';
    $Self->{'FAQ::Field5'} = 'field5';
    $Self->{'FAQ::Field6'} = 'Comment (internal)';

    # --------------------------------------------------- #
    # link object settings                                #
    # what objects are known by the system                #
    # --------------------------------------------------- #
    $Self->{'LinkObject'}->{'FAQ'} = {
        Name => 'FAQ Object',
        Type => 'Object',
        LinkObjects => ['Ticket', 'FAQ'],
    };

    # --------------------------------------------------- #
    # faq interface
    # --------------------------------------------------- #
    $Self->{'Frontend::Module'}->{'FAQ'} = {
        Group => ['faq'],
        GroupRo => ['faq'],
        Description => 'FAQ-Area',
        NavBarName => 'FAQ',
        NavBar => [
          {
            GroupRo => ['faq'],
            Description => 'FAQ-Area',
            Type => 'Menu',
            Block => 'ItemArea',
            Name => 'FAQ',
            Image => 'help.png',
            Link => 'Action=FAQ&Nav=Normal',
            NavBar => 'FAQ',
            Prio => 8300,
            AccessKey => 'q',
          },
          {
            Group => ['faq'],
            Description => 'New Article',
            Name => 'New Article',
            Image => 'new.png',
            Link => 'Action=FAQ&Subaction=Add',
            NavBar => 'FAQ',
            Prio => 200,
            AccessKey => 'n',
          },
          {
            GroupRo => ['faq'],
            Description => 'FAQ-Search',
            Name => 'Search',
            Image => 'search.png',
            Link => 'Action=FAQ&Subaction=Search',
            NavBar => 'FAQ',
            Prio => 300,
            AccessKey => 's',
          },
          {
            GroupRo => ['faq'],
            Description => 'History',
            Name => 'History',
            Image => 'list.png',
            Link => 'Action=FAQ&Subaction=SystemHistory',
            NavBar => 'FAQ',
            Prio => 310,
            AccessKey => 'o',
          },
        ],
    };
    $Self->{'Frontend::Module'}->{'FAQCategory'} = {
        GroupRo => [],
        Group => ['faq'],
        Description => 'FAQ-Category',
        Title => 'Category',
        NavBarName => 'FAQ',
        NavBar => [
          {
            Description => 'Category',
            Name => 'Category',
            Image => 'fileopen.png',
            Link => 'Action=FAQCategory',
            NavBar => 'FAQ',
            Prio => 900,
            AccessKey => 'g',
          },
        ],
    };
    $Self->{'Frontend::Module'}->{'FAQLanguage'} = {
        GroupRo => [],
        Group => ['faq'],
        Description => 'FAQ-Language',
        Title => 'Language',
        NavBarName => 'FAQ',
        NavBar => [
          {
            Description => 'Language',
            Name => 'Language',
            Image => 'fileopen.png',
            Link => 'Action=FAQLanguage',
            NavBar => 'FAQ',
            Prio => 910,
            AccessKey => 'u',
          },
        ],
    };

    # customer panel
    $Self->{'CustomerFrontend::Module'}->{'CustomerFAQ'} = {
        Description => 'Customer faq.',
        NavBarName => 'FAQ',
        NavBar => [
          {
            Description => 'FAQ-Area',
            Name => 'FAQ-Area',
            Image => 'help.png',
            Link => 'Action=CustomerFAQ',
            Prio => 400,
            AccessKey => 'f',
          },
        ],
    };

    # param => default value
    $Self->{'PublicFrontend::CommonParam'}->{Action} = 'PublicFAQ';

    # public panel
    $Self->{'PublicFrontend::Module'}->{'PublicFAQ'} = {
        Description => 'Customer faq.',
        NavBarName => 'FAQ',
        NavBar => [
          {
            Description => 'FAQ-Area',
            Name => 'FAQ-Area',
            Image => 'help.png',
            Link => 'Action=CustomerFAQ',
            Prio => 400,
            AccessKey => 'f',
          },
        ],
    };

