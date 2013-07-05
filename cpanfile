requires 'parent';
requires 'perl', '5.008005';

on build => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Requires';
};
