use ExtUtils::MakeMaker;
WriteMakefile(
    NAME => 'App::AccessLogFilter::Colored',
    VERSION_FROM => "lib/App/AccessLogFilter/Colored.pm",
    ABSTRACT => 'poor grep(1) for combined/extended log with color',
    PREREQ_PM => {
        'Term::ANSIColor' => 0,
    },
    LICENSE => 'perl',
    EXE_FILES => [ 'bin/access-log-filter-colored.pl' ],
);
