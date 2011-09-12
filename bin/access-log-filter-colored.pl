#!/usr/bin/env perl
use strict;
use warnings;

use Getopt::Long qw(HelpMessage VersionMessage);
use Term::ANSIColor qw(colored);

our $VERSION = '0.01';
$VERSION = eval $VERSION;

Getopt::Long::Configure('bundling', 'no_ignore_case', 'auto_help', 'auto_version');
GetOptions(
    \my %opts,
    'h' => \&HelpMessage,
    'v' => \&VersionMessage,
);

my $filter = shift || '';

my @parts = qw(host ident user time method resource proto status bytes referer agent);

while (<>) {
    my %line;
    @line{@parts} = /^([^ ]*) ([^ ]*) ([^ ]*) \[([^]]*)\] "([^ ]*)(?: *([^ ]*) *([^ ]*))?" ([^ ]*) ([^ ]*) "(.*?)" "(.*?)"/;

    if (eval($filter)) {
        for my $part (@parts) {
            if ($filter =~ /$part/) {
                $line{$part} = colored($line{$part}, 'cyan');
            }
        }
        my $new_line = sprintf(q!%s %s %s [%s] "%s %s %s" %s %s "%s" "%s"!, @line{@parts});
        print $new_line, "\n";
    }
}

__END__

=head1 NAME

access-log-filter-colored.pl-colored.pl - poor grep(1) for combined/extended log with color

=head1 SYNOPSIS

 $ access-log-filter-colored.pl 'filter expression' < /var/log/httpd/access_log

 options:
  -h, -?, --help   print help message
  -v, --version    print version string

examples:

 $ access-log-filter-colored.pl '$line{status} == 500' < /var/log/httpd/access_log

 $ access-log-filter-colored.pl '$line{method} eq "POST"' < /var/log/httpd/access_log

 $ access-log-filter-colored.pl '$line{agent} =~ /iphone/i' < /var/log/httpd/access_log

 $ tailf /var/log/httpd/access_log \
     | access-log-filter-colored.pl '$line{method} eq "POST"' \
     | access-log-filter-colored.pl '$line{agent} =~ /flash/i'

=head1 SEE ALSO

 L<http://pmakino.jp/tdiary/20070907.html> (thanks for regexp)

=head1 AUTHOR

Kensuke Nagae <kyanny at gmail dot com>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
