use strict;
use warnings;
use utf8;
use Test::More;
use Text::PicoTemplate;

is render_string('foo'), 'foo';
is render_string('Hello, <% stuff %>!', {stuff => 'world'}), 'Hello, world!';
is render_string('<% greeting %>, <% person %>!', {
    greeting => 'こんにちは',
    person   => 'professor',
}), 'こんにちは, professor!';
is render_string('Hello, <% 地球 %>!', {'地球' => 'world'}), 'Hello, world!';
is render_string('<% $var %>', {'$var' => 'variable'}), 'variable';
is render_string('Hello, <%
    stuff
%>!', {stuff => 'world'}), 'Hello, world!';

is render_string('<% %>'), '<% %>';
is render_string('foo <% bar bar %>', {'bar bar' => 'baz'}), 'foo <% bar bar %>';

is render_string('<%v%>'), '<%v%>';

is render_string('<% tag %>', {tag => '<% tag %>'}), '<% tag %>';
is render_string('<% <% v %> %>', {'<% v %>' => 'tag'}), 'tag';
is render_string('<% <% <% v %> %> %>', {'<% <% v %> %>' => 'tag'}), 'tag';

{
    local $@;
    eval {
        render_string('foo <% bar %>');
    };
    like $@, qr/Undefined symbol: bar at line 1\./;
}
{
    local $@;
    eval {
        render_string(<<'...');
ABC
DEF
GHI
<% JKL %>
MNO
...
    };
    like $@, qr/Undefined symbol: JKL at line 4\./;
}

done_testing;
