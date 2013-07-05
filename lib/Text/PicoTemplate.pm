package Text::PicoTemplate;
use strict;
use warnings;
use 5.008005;
our $VERSION = '0.01';

use parent qw/Exporter/;
use Carp ();

our @EXPORT = qw/render_string/;

our $TAG_START = '<%';
our $TAG_END   = '%>';

sub render_string {
    my ($string, $vars) = @_;
    $vars = {} unless defined $vars;

    unless (ref $vars eq 'HASH') {
        Carp::croak('Template variables must be a HASH reference');
    }

    my $re; $re = qr/
        $TAG_START
        \s*
        (
            (?> \S+ )
            | (??{ $re })
        )+
        \s*
        $TAG_END
    /x;
    $string =~ s{$re}{
        if (exists $vars->{$1}) {
            $vars->{$1};
        } else {
            _error($string, $1, @-);
        }
    }egx;
    return $string;
}

sub _error {
    my ($string, $var, @offsets) = @_;
    my $line_offset = 4;

    my $after = substr $string, 0, $offsets[0];
    my $line = 1;
    $line++ while $after =~ /\r\n?|\n/g;

    my $delim = '-' x 76;

    my $report = "Undefined symbol: $var at line $line.\n";
    my $template = _context($string, $line);
    $report .= "$delim\n$template$delim\n";
    die $report;
}

sub _context {
    my ($string, $line) = @_;
    my @lines = split /\r\n?|\n/, $string;
    return join '', map {
        0 < $_ && $_ <= @lines ? sprintf("%4d: %s\n", $_, $lines[$_ - 1]) : ''
    } ($line - 2) .. ($line + 2);
}

1;
__END__

=encoding utf8

=head1 NAME

Text::PicoTemplate - Pico template engine only render variables

=head1 SYNOPSIS

  use Text::PicoTemplate;

  print render_string('<% local_part %>@example.com', {
      local_part => 'foo',
  });

=head1 DESCRIPTION

Text::PicoTemplate is pico template engine. No escape variables, no expressions.

B<THIS IS A DEVELOPMENT RELEASE. API MAY CHANGE WITHOUT NOTICE>.

=head1 FUNCTIONS

=head2 render_string($string, \%vars)

Renders a template string with given variables.

  print render_string('hello, <% john %>!', {john => 'John'});
  # => hello, John!

=head1 FAQ

=head2 How do I change the style of tags?

  use Text::PicoTemplate;

  $Text::PicoTemplate::TAG_START = '[%';
  $Text::PicoTemplate::TAG_END   = '%]';

=head1 AUTHOR

Takumi Akiyama E<lt>akiym@cpan.orgE<gt>

=head1 SEE ALSO

L<Text::MicroTemplate>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
