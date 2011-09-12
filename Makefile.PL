use ExtUtils::MakeMaker;
WriteMakefile(
    NAME => 'App::AccessLogFilter::Colored',
    VERSION_FROM => "bin/access-log-filter-colored.pl",
    ABSTRACT => 'grep for combined/extended log with color.',
    PREREQ_PM => {
        'Term::ANSIColor' => 0,
    },
    LICENSE => 'perl',
    EXE_FILES => [ 'bin/access-log-filter-colored.pl' ],
);
