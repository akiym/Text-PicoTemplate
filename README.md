# NAME

Text::PicoTemplate - Pico template engine only render variables

# SYNOPSIS

    use Text::PicoTemplate;

    print render_string('<% local_part %>@example.com', {
        local_part => 'foo',
    });

# DESCRIPTION

Text::PicoTemplate is pico template engine. No escape variables, no expressions.

__THIS IS A DEVELOPMENT RELEASE. API MAY CHANGE WITHOUT NOTICE__.

# FUNCTIONS

## render\_string($string, \\%vars)

Renders a template string with given variables.

    print render_string('hello, <% john %>!', {john => 'John'});
    # => hello, John!

# FAQ

## How do I change the style of tags?

    use Text::PicoTemplate;

    $Text::PicoTemplate::TAG_START = '[%';
    $Text::PicoTemplate::TAG_END   = '%]';

# AUTHOR

Takumi Akiyama <akiym@cpan.org>

# SEE ALSO

[Text::MicroTemplate](http://search.cpan.org/perldoc?Text::MicroTemplate)

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
