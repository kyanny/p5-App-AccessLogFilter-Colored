#!/usr/bin/env perl
use strict;
use warnings;

use Getopt::Long qw(HelpMessage VersionMessage);
use Term::ANSIColor qw(colored);
use File::Spec::Functions;

$| = 1;

our $VERSION = '0.01';
$VERSION = eval $VERSION;

Getopt::Long::Configure('bundling', 'no_ignore_case', 'auto_help', 'auto_version');
GetOptions(
    'c|color=s' => \my $color,
    'conf:s' => \my $conf,
    'verbose' => \my $verbose,
    'h' => \&HelpMessage,
    'v' => \&VersionMessage,
);
$color ||= 'cyan';

my $filter = shift || '';

our @parts = qw(host ident user time method resource proto status bytes referer agent);
our $regexp = qr/^([^ ]*) ([^ ]*) ([^ ]*) \[([^]]*)\] "([^ ]*)(?: *([^ ]*) *([^ ]*))?" ([^ ]*) ([^ ]*) "(.*?)" "(.*?)"/;
our $log_format = q!%s %s %s [%s] "%s %s %s" %s %s "%s" "%s"!;

if (defined($conf)) {
    $conf ||= catfile($ENV{HOME}, '.App-AccessLogFilter-Colored');
    if (-f $conf) {
        print STDERR "[info] load $conf\n" if $verbose;
        require "$conf";
    }
}

while (<>) {
    my %line;
    @line{@parts} = /$regexp/;

    if (eval($filter)) {
        for my $part (@parts) {
            if ($filter =~ /$part/) {
                $line{$part} = colored($line{$part}, $color);
            }
        }
        my $new_line = sprintf($log_format, @line{@parts});
        print $new_line, "\n";
    }
}

__END__

=head1 NAME

access-log-filter-colored.pl-colored.pl - poor grep(1) for combined/extended log with color

=head1 SYNOPSIS

    $ access-log-filter-colored.pl 'filter expression' < /var/log/httpd/access_log
   
    options:
     -c, --color      specify highlight color 
     --conf           specify config file for log format customize (see CUSTOMIZE section)
     -h, -?, --help   print help message
     -v, --version    print version string

examples:

    $ access-log-filter-colored.pl '$line{status} == 500' < /var/log/httpd/access_log
   
    $ access-log-filter-colored.pl --color=red '$line{method} eq "POST"' < /var/log/httpd/access_log
   
    $ access-log-filter-colored.pl --conf -- '$line{agent} =~ /iphone/i' < /var/log/httpd/access_log
   
    $ tailf /var/log/httpd/access_log \
        | access-log-filter-colored.pl '$line{method} eq "POST"' -c yellow --conf\
        | access-log-filter-colored.pl '$line{agent} =~ /flash/i' -c magenta --conf

=head1 CUSTOMIZE

You can customize log format. When --conf option passed, $HOME/.App-AccessLogFilter-Colored will load.
When --conf=/path/to/file option passed, the file /path/to/file will load. Config file is Perl script.

example:

    # LogFormat  "%h %l %u %t \"%r\" %>s %b %D %X \"%{Referer}i\" \"%{User-Agent}i\""
    
    @parts = qw(host ident user time method resource proto status bytes microseconds connection referer agent);
    $regexp = qr/^([^ ]*) ([^ ]*) ([^ ]*) \[([^]]*)\] "([^ ]*)(?: *([^ ]*) *([^ ]*))?" ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) "(.*?)" "(.*?)"/;
    $log_format = q!%s %s %s [%s] "%s %s %s" %s %s %s %s "%s" "%s"!;
    
    1;

=head1 SEE ALSO

 L<Term::ANSIColor> for more details about color name
 L<http://pmakino.jp/tdiary/20070907.html> (thanks for regexp)

=head1 AUTHOR

Kensuke Nagae <kyanny at gmail dot com>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
