#!perl
use 5.008;

use strict;
use warnings;
use utf8;

binmode(STDOUT,":encoding(UTF-8)");
binmode(STDERR,":encoding(UTF-8)");

#use lib qw(../blib/);

use Test::More;
use Test::More::UTF8;

use Text::Levenshtein::BVXS;
use Text::Levenshtein;

#use Text::Levenshtein::XS qw(distance);

my $examples1 = [
  [ '', ''],
  [ 'a', ''],
  [ '', 'b'],
  [ 'b', 'b'],
  ['ttatc__cg',
   '__agcaact'],
  ['abcabba_',
   'cb_ab_ac'],
   ['yqabc_',
    'zq__cb'],
  [ 'rrp',
    'rep'],
  [ 'a',
    'b' ],
  [ 'aa',
    'a_' ],
  [ 'abb',
    '_b_' ],
  [ 'a_',
    'aa' ],
  [ '_b_',
    'abb' ],
  [ 'ab',
    'cd' ],
  [ 'ab',
    '_b' ],
  [ 'ab_',
    '_bc' ],
  [ 'abcdef',
    '_bc___' ],
  [ 'abcdef',
    '_bcg__' ],
  [ 'xabcdef',
    'y_bc___' ],
  [ 'öabcdef',
    'ü§bc___' ],
  [ 'o__horens',
    'ontho__no'],
  [ 'Jo__horensis',
    'Jontho__nota'],
  [ 'horen',
    'ho__n'],
  [ 'Chrerrplzon',
    'Choereph_on'],
  [ 'Chrerr',
    'Choere'],
  [ 'rr',
    're'],
  [ 'abcdefg_',
    '_bcdefgh'],

  [ 'aabbcc',
    'abc'],
  [ 'aaaabbbbcccc',
    'abc'],
  [ 'aaaabbcc',
    'abc'],
  [ 'ſhoereſhoſ',
    'Choerephon'],
];



my $examples2 = [
  [ 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVY_', # l=52
    '_bcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVYZ'],
  [ 'abcdefghijklmnopqrstuvwxyz0123456789!"$%&/()=?ABCDEFGHIJKLMNOPQRSTUVY_',
    '_bcdefghijklmnopqrstuvwxyz0123456789!"$%&/()=?ABCDEFGHIJKLMNOPQRSTUVYZ'],
  [ 'abcdefghijklmnopqrstuvwxyz0123456789"$%&/()=?ABCDEFGHIJKLMNOPQRSTUVY_',
    '!'],
  [ '!',
    'abcdefghijklmnopqrstuvwxyz0123456789"$%&/()=?ABCDEFGHIJKLMNOPQRSTUVY_'],
  [ 'abcdefghijklmnopqrstuvwxyz012345678!9!"$%&/()=?ABCDEFGHIJKLMNOPQRSTUVYZ',
    'abcdefghijklmnopqrstuvwxyz012345678_9!"$%&/()=?ABCDEFGHIJKLMNOPQRSTUVYZ'],
  [ 'abcdefghijklmnopqrstuvwxyz012345678_9!"$%&/()=?ABCDEFGHIJKLMNOPQRSTUVYZ',
    'abcdefghijklmnopqrstuvwxyz012345678!9!"$%&/()=?ABCDEFGHIJKLMNOPQRSTUVYZ'],
  [ 'aaabcdefghijklmnopqrstuvwxyz012345678_9!"$%&/()=?ABCDEFGHIJKLMNOPQRSTUVYZZZ',
    'a!Z'],
];

# prefix/suffix optimisation
my $examples3 = [
  [ 'a',
    'a', ],
  [ 'aa',
    'aa', ],
  [ 'a_',
    'aa', ],
  [ 'aa',
    'a_', ],
  [ '_b_',
    'abb', ],
  [ 'abb',
    '_b_', ],
];



if (1) {
  for my $example (@$examples1) {
    my $a = $example->[0];
    my $b = $example->[1];
    my @a = $a =~ /([^_])/g;
    my @b = $b =~ /([^_])/g;
    my $A = join('',@a);
    my $B = join('',@b);
    my $m = scalar @a;
    my $n = scalar @b;

    my $distance = &Text::Levenshtein::distance($A,$B);

    is(
      &Text::Levenshtein::BVXS::distance($A,$B),
      #distance($A,$B),
      $distance,

      #"[$a] m: $m, [$b] n: $n -> " . distance($A,$B)
      "[$a] m: $m, [$b] n: $n -> " . $distance
    );
  }
}

if (0) {
  for my $example (@$examples2) {
    my $a = $example->[0];
    my $b = $example->[1];
    my @a = $a =~ /([^_])/g;
    my @b = $b =~ /([^_])/g;
    my $A = join('',@a);
    my $B = join('',@b);
    my $m = scalar @a;
    my $n = scalar @b;

    my $distance = distance($A,$B);

    is(
      Text::Levenshtein::BV->distance(\@a,\@b),
      #distance($A,$B),
      $distance,

      #"[$a] m: $m, [$b] n: $n -> " . distance($A,$B)
      "[$a] m: $m, [$b] n: $n -> " . $distance
    );
  }
}


if (1) {
  for my $example (@$examples3) {
    my $a = $example->[0];
    my $b = $example->[1];
    my @a = $a =~ /([^_])/g;
    my @b = $b =~ /([^_])/g;
    my $A = join('',@a);
    my $B = join('',@b);
    my $m = scalar @a;
    my $n = scalar @b;

    my $distance = &Text::Levenshtein::distance($A,$B);

    is(
      &Text::Levenshtein::BVXS::distance($A,$B),
      #distance($A,$B),
      $distance,

      #"[$a] m: $m, [$b] n: $n -> " . distance($A,$B)
      "[$a] m: $m, [$b] n: $n -> " . $distance
    );
  }
}

# test prefix-suffix optimization
if (0) {
  my $prefix = 'a';
  my $infix  = 'b';
  my $suffix = 'c';

  my $max_length = 2;

  my @a_strings;

  for my $prefix_length1 (0..$max_length) {
    for my $infix_length1 (0..$max_length) {
      for my $suffix_length1 (0..$max_length) {
        my $a = $prefix x $prefix_length1 . $infix x $infix_length1 . $suffix x $suffix_length1;
        push @a_strings, $a;
      }
    }
  }

  for my $a (@a_strings) {
    for my $b (@a_strings) {
      my @a = split(//,$a);
      my $m = scalar @a;
      my @b = split(//,$b);
      my $n = scalar @b;

      is(
        Text::Levenshtein::BV->distance(\@a,\@b),
        distance(\@a,\@b),

        "[$a] m: $m, [$b] n: $n -> " . distance(\@a,\@b)
      );
    }
  }
}

# test error-by-one
if (0) {
  my $string1 = 'a';
  my $string2 = 'b';
  my @base_lengths = (16, 32, 64, 128, 256);

  for my $base_length (@base_lengths) {
    for my $delta (-1, 0, 1) {
      my $mult = $base_length + $delta;
      my @a = split(//, $string1 x $mult);
      my $m = scalar @a;
      my @b = split(//, $string2 x $mult);
      my $n = scalar @b;
      is(
        Text::Levenshtein::BV->distance(\@a,\@b),
        distance(\@a,\@b),

        "[$string1 x $mult] m: $m, [$string2 x $mult] n: $n -> " . distance(\@a,\@b)
       );
    }
  }
}

# test carry for possible machine words
if (0) {
  my $string1 = 'abd';
  my $string2 = 'badc';
  my @base_lengths = (16, 32, 64, 128, 256);

  for my $base_length1 (@base_lengths) {
    my $mult1 = int($base_length1/length($string1)) + 1;
    my @a = split(//,$string1 x $mult1);
    my $m = scalar @a;
    for my $base_length2 (@base_lengths) {
      my $mult2 = int($base_length2/length($string2)) + 1;
      my @b = split(//,$string2 x $mult2);
      my $n = scalar @b;
      is(
        Text::Levenshtein::BV->distance(\@a,\@b),
        distance(\@a,\@b),

        "[$string1 x $mult1] m: $m, [$string2 x $mult2] n: $n -> " . distance(\@a,\@b)
      );
    }
  }
}


my @data3 = ([qw/a b d/ x 50], [qw/b a d c/ x 50]);

if (0) {
  is(
    Text::Levenshtein::BV->distance(@data3),
    distance(@data3),

    '[qw/a b d/ x 50], [qw/b a d c/ x 50] -> ' . distance(@data3)
  );

}


done_testing;
