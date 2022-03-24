#!perl
use 5.006;

use strict;
use warnings;
use utf8;

use open qw(:locale);

use lib qw(
../lib/
./lib/
/Users/helmut/github/perl/Levenshtein-Simple/lib
);

#use Test::More;

use Benchmark qw(:all) ;
use Data::Dumper;

#use Text::Levenshtein::BV;
#use Text::Levenshtein::BVXS;
use Text::Levenshtein::Uni;
#use Text::Levenshtein::XS qw(distance);
use Text::Levenshtein::XS;
use Text::Levenshtein;
use Text::Levenshtein::Flexible;

#use Text::Levenshtein::BVmyers;
#use Text::Levenshtein::BVhyrr;
use Levenshtein::Simple;

##use Text::LevenshteinXS;
use Text::Fuzzy;

#use LCS::BV;

my @data_ascii = (
  [split(//,'Chrerrplzon')],
  [split(//,'Choerephon')]
);

# ehorſ 5 letters ſhoer
my @data_uni = (
  [split(//,'Chſerſplzon')],
  [split(//,'Choerephon')]
);

my @strings_ascii = qw(Chrerrplzon Choerephon);
my @strings_uni   = qw(Chſerſplzon Choerephon);

my @data2 = (
  [split(//,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXY')],
  [split(//, 'bcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')]
);

my @strings2 = qw(
abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXY
bcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
);

my @data3 = ([qw/a b d/ x 50], [qw/b a d c/ x 50]);

my @strings3 = map { join('',@$_) } @data3;

my $tf_ascii = Text::Fuzzy->new($data_ascii[0]);
my $tf_uni   = Text::Fuzzy->new($data_uni[0]);

#print STDERR 'S::Similarity: ',similarity(@strings),"\n";
#print STDERR 'Text::Levenshtein::BV:       ',Text::Levenshtein::BV->distance(@data),"\n";
#print STDERR 'Text::Levenshtein::BVXS:     ',Text::Levenshtein::BVXS::distance(@strings),"\n";
#print STDERR 'Text::Levenshtein::BV2:      ',Text::Levenshtein::BV->distance2(@data),"\n";
#print STDERR 'Text::Levenshtein::XS:       ',&Text::Levenshtein::XS::distance(@strings),"\n";
#print STDERR 'Text::Levenshtein:           ',&Text::Levenshtein::distance(@strings),"\n";
#print STDERR 'Text::Levenshtein::Flexible: ',&Text::Levenshtein::Flexible::levenshtein(@strings),"\n";
#print STDERR 'Text::Fuzzy:                 ',$tf->distance($data[1]),"\n";
#print STDERR 'Text::LevenshteinXS:         ',&Text::LevenshteinXS::distance(@strings),"\n";


if (1) {
    cmpthese( -1, {
       'TL::Uni_ascii' => sub {
            Text::Levenshtein::Uni::distance(@strings_ascii)
        },
       'TL::Uni_uni' => sub {
            Text::Levenshtein::Uni::distance(@strings_uni)
        },
       'TL::Uni_l52' => sub {
            Text::Levenshtein::Uni::distance(@strings2)
        },
        'TL::Flex_ascii' => sub {
            &Text::Levenshtein::Flexible::levenshtein(@strings_ascii)
        },
        'TL::Flex_uni' => sub {
            &Text::Levenshtein::Flexible::levenshtein(@strings_uni)
        },
        'TL::Flex_l52' => sub {
            &Text::Levenshtein::Flexible::levenshtein(@strings2)
        },
    });
}

=pod
version 0.06
Text::Levenshtein::BV:       4
Text::Levenshtein::BVXS:     4
Text::Levenshtein:           4
Text::Levenshtein::Flexible: 4
Text::Fuzzy:                 5
                 Rate     TL Lev::Simple TL::BV LCS::BV T::Fuzz TL::BVXS TL::Flex
TL             6636/s     --        -78%   -95%    -96%   -100%    -100%    -100%
Lev::Simple   29537/s   345%          --   -77%    -84%    -98%     -99%     -99%
TL::BV       130326/s  1864%        341%     --    -30%    -91%     -96%     -96%
LCS::BV      187398/s  2724%        534%    44%      --    -87%     -94%     -94%
T::Fuzz     1434347/s 21514%       4756%  1001%    665%      --     -51%     -55%
TL::BVXS    2940717/s 44214%       9856%  2156%   1469%    105%       --      -8%
TL::Flex    3206187/s 48214%      10755%  2360%   1611%    124%       9%       --

version 0.07 'elsif'

                 Rate     TL Lev::Simple TL::BV LCS::BV T::Fuzz TL::BVXS TL::Flex
TL             5999/s     --        -79%   -95%    -97%   -100%    -100%    -100%
Lev::Simple   28980/s   383%          --   -77%    -84%    -98%     -99%     -99%
TL::BV       124842/s  1981%        331%     --    -33%    -91%     -96%     -96%
LCS::BV      185579/s  2993%        540%    49%      --    -87%     -93%     -94%
T::Fuzz     1402911/s 23285%       4741%  1024%    656%      --     -50%     -55%
TL::BVXS    2831802/s 47104%       9672%  2168%   1426%    102%       --      -9%
TL::Flex    3113701/s 51803%      10644%  2394%   1578%    122%      10%       --

                 Rate     TL Lev::Simple TL::BV LCS::BV T::Fuzz TL::BVXS TL::Flex
TL             6515/s     --        -79%   -95%    -97%   -100%    -100%    -100%
Lev::Simple   30351/s   366%          --   -76%    -84%    -98%     -99%     -99%
TL::BV       129152/s  1882%        326%     --    -34%    -91%     -96%     -96%
LCS::BV      194606/s  2887%        541%    51%      --    -86%     -93%     -94%
T::Fuzz     1379705/s 21076%       4446%   968%    609%      --     -53%     -54%
TL::BVXS    2940717/s 45034%       9589%  2177%   1411%    113%       --      -2%
TL::Flex    2998379/s 45919%       9779%  2222%   1441%    117%       2%       --

'mask per table'
                 Rate     TL Lev::Simple TL::BV LCS::BV T::Fuzz TL::BVXS TL::Flex
TL             6636/s     --        -78%   -95%    -97%   -100%    -100%    -100%
Lev::Simple   30075/s   353%          --   -78%    -85%    -98%     -99%     -99%
TL::BV       137845/s  1977%        358%     --    -30%    -90%     -95%     -96%
LCS::BV      196495/s  2861%        553%    43%      --    -86%     -94%     -94%
T::Fuzz     1420284/s 21302%       4622%   930%    623%      --     -53%     -56%
TL::BVXS    3028065/s 45530%       9968%  2097%   1441%    113%       --      -6%
TL::Flex    3215551/s 48355%      10592%  2233%   1536%    126%       6%       --

perl 5.32.0
                  Rate      TL Lev::Simple TL::BV LCS::BV T::Fuzz TL::Flex TL::BVXS
TL              6826/s      --        -83%   -96%    -97%    -99%    -100%    -100%
Lev::Simple    40573/s    494%          --   -77%    -84%    -97%     -99%    -100%
TL::BV        173769/s   2446%        328%     --    -32%    -87%     -95%     -99%
LCS::BV       254485/s   3628%        527%    46%      --    -80%     -93%     -98%
T::Fuzz      1291788/s  18825%       3084%   643%    408%      --     -66%     -89%
TL::Flex     3814985/s  55791%       9303%  2095%   1399%    195%       --     -69%
TL::BVXS    12287999/s 179925%      30186%  6971%   4729%    851%     222%       --

BVXS ascii

                  Rate      TL Lev::Simple TL::BV LCS::BV T::Fuzz TL::Flex TL::BVXS
TL              6576/s      --        -79%   -95%    -97%   -100%    -100%    -100%
Lev::Simple    30632/s    366%          --   -78%    -84%    -98%     -99%    -100%
TL::BV        138400/s   2005%        352%     --    -28%    -90%     -96%     -99%
LCS::BV       190934/s   2803%        523%    38%      --    -86%     -94%     -98%
T::Fuzz      1377633/s  20849%       4397%   895%    622%      --     -56%     -88%
TL::Flex     3099675/s  47035%      10019%  2140%   1523%    125%       --     -72%
TL::BVXS    11062957/s 168129%      36015%  7893%   5694%    703%     257%       --

BVXS uni sequential
Text::Levenshtein::BVXS:     3
Text::Levenshtein::Flexible: 3
Text::Fuzzy:                 3
                    Rate   T::Fuzz  TL::Flex TL::BVXS TL::BVXSnoop TL::BVXSnoutf
T::Fuzz        1279827/s        --      -51%     -54%         -61%          -96%
TL::Flex       2621439/s      105%        --      -5%         -21%          -92%
TL::BVXS       2759410/s      116%        5%       --         -17%          -91%
TL::BVXSnoop   3308308/s      158%       26%      20%           --          -90%
TL::BVXSnoutf 31638068/s     2372%     1107%    1047%         856%            --

BVXS utf8-i sequential

                    Rate   T::Fuzz  TL::Flex TL::BVXSnoop TL::BVXS TL::BVXSnoutf
T::Fuzz        1291788/s        --      -49%         -62%     -85%          -96%
TL::Flex       2541562/s       97%        --         -25%     -70%          -92%
TL::BVXSnoop   3398162/s      163%       34%           --     -60%          -89%
TL::BVXS       8574803/s      564%      237%         152%       --          -72%
TL::BVXSnoutf 30247384/s     2242%     1090%         790%     253%            --

~/github/perl/Text-Levenshtein-BVXS/xt$ perl 50_distance_bench.t
                     Rate T::Fuzz_ascii T::Fuzz_uni TL::Flex_uni TL::Flex_ascii TL::BVXS_uni TL::BVXS_ascii
T::Fuzz_ascii   1279827/s            --         -1%         -48%           -68%         -85%           -89%
T::Fuzz_uni     1298354/s            1%          --         -48%           -67%         -85%           -89%
TL::Flex_uni    2473057/s           93%         90%           --           -38%         -71%           -79%
TL::Flex_ascii  3978971/s          211%        206%          61%             --         -54%           -67%
TL::BVXS_uni    8652585/s          576%        566%         250%           117%           --           -27%
TL::BVXS_ascii 11883483/s          829%        815%         381%           199%          37%             --

# uni codepoints sequential

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS/xt$ perl 50_distance_bench.t
                     Rate T::Fuzz_ascii T::Fuzz_uni TL::BVXS_uni TL::Flex_uni TL::Flex_ascii TL::BVXS_ascii
T::Fuzz_ascii   1268085/s            --         -2%         -51%         -53%           -67%           -90%
T::Fuzz_uni     1291788/s            2%          --         -50%         -52%           -66%           -90%
TL::BVXS_uni    2572440/s          103%         99%           --          -5%           -33%           -79%
TL::Flex_uni    2698541/s          113%        109%           5%           --           -29%           -78%
TL::Flex_ascii  3817631/s          201%        196%          48%          41%             --           -69%
TL::BVXS_ascii 12365282/s          875%        857%         381%         358%           224%             --


TL::uni_noop    3398162/s
TL::utf8_noop  30247384/s

TL::BVXS_uni    2572440/s
TL::BVXS_utf8   8652585/s
TL::BVXS_ascii 12365282/s

# prefix/suffix
helmut@mbp:~/github/perl/Text-Levenshtein-BVXS$ perl xt/50_distance_bench.t
                     Rate T::Fuzz_ascii T::Fuzz_uni TL::Flex_uni TL::Flex_ascii TL::BVXS_uni TL::BVXS_ascii
T::Fuzz_ascii   1303272/s            --         -1%         -49%           -66%         -84%           -91%
T::Fuzz_uni     1310719/s            1%          --         -49%           -66%         -84%           -90%
TL::Flex_uni    2572440/s           97%         96%           --           -33%         -69%           -81%
TL::Flex_ascii  3817631/s          193%        191%          48%             --         -54%           -72%
TL::BVXS_uni    8265802/s          534%        531%         221%           117%           --           -40%
TL::BVXS_ascii 13762560/s          956%        950%         435%           260%          66%             --

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS$ perl xt/50_distance_bench.t
                     Rate T::Fuzz_ascii T::Fuzz_uni TL::Flex_uni TL::Flex_ascii TL::BVXS_uni TL::BVXS_ascii
T::Fuzz_ascii   1303975/s            --         -2%         -48%           -67%         -83%           -91%
T::Fuzz_uni     1329051/s            2%          --         -47%           -67%         -83%           -90%
TL::Flex_uni    2530597/s           94%         90%           --           -36%         -68%           -82%
TL::Flex_ascii  3978971/s          205%        199%          57%             --         -49%           -71%
TL::BVXS_uni    7841914/s          501%        490%         210%            97%           --           -43%
TL::BVXS_ascii 13762559/s          955%        936%         444%           246%          76%             --

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS/src$ ./levtest
[dist_asci] iters: 20 M Elapsed: 0.799409 s Rate: 25.0 (M/sec) 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.995221 s Rate: 10.0 (M/sec) 4
[dist_uni] iters: 20 M Elapsed: 1.106825 s Rate: 18.1 (M/sec) 4
Total: 3.901455 seconds

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS/src$ ./levtest
[dist_asci]     iters: 20 M Elapsed: 0.803021 s Rate: 24.9 (M/sec) 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.913089 s Rate: 10.5 (M/sec) 4
[dist_uni]      iters: 20 M Elapsed: 1.084475 s Rate: 18.4 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 0.873442 s Rate: 22.9 (M/sec) 4

using hybrid for uni
helmut@mbp:~/github/perl/Text-Levenshtein-BVXS$ perl xt/50_distance_bench.t
                     Rate TL::Flex_l52 TL::Flex_uni TL::Flex_ascii TL::BVXS_l52 TL::BVXS_uni TL::BVXS_ascii
TL::Flex_l52     211861/s           --         -91%           -94%         -95%         -97%           -98%
TL::Flex_uni    2383127/s        1025%           --           -35%         -42%         -71%           -81%
TL::Flex_ascii  3684085/s        1639%          55%             --         -10%         -56%           -71%
TL::BVXS_l52    4110496/s        1840%          72%            12%           --         -50%           -68%
TL::BVXS_uni    8303203/s        3819%         248%           125%         102%           --           -36%
TL::BVXS_ascii 12877248/s        5978%         440%           250%         213%          55%             --

2022-03-05 scan ascii first, minimize construction of non-ascii

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS/src$ ./levtest
[dist_asci]     iters: 20 M Elapsed: 0.800581 s Rate: 25.0 (M/sec) 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.803164 s Rate: 11.1 (M/sec) 4
[dist_uni]      iters: 20 M Elapsed: 1.129935 s Rate: 17.7 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 0.948622 s Rate: 21.1 (M/sec) 4
Total: 4.682302 seconds

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS$ perl xt/50_distance_bench.t
                     Rate TL::Flex_l52 TL::Flex_uni TL::Flex_ascii TL::BVXS_l52 TL::BVXS_uni TL::BVXS_ascii
TL::Flex_l52     227556/s           --         -91%           -94%         -94%         -97%           -98%
TL::Flex_uni    2502283/s        1000%           --           -33%         -37%         -69%           -82%
TL::Flex_ascii  3747463/s        1547%          50%             --          -6%         -53%           -73%
TL::BVXS_l52    3989148/s        1653%          59%             6%           --         -50%           -71%
TL::BVXS_uni    7989875/s        3411%         219%           113%         100%           --           -43%
TL::BVXS_ascii 13912027/s        6014%         456%           271%         249%          74%             --

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS/src$ ./levtest
[dist_asci]     distance: 4 expect: 4
[dist_utf8_ucs] distance: 4 expect: 4
[dist_uni]      distance: 4 expect: 4
[dist_hybrid]   distance: 4 expect: 4
[dist_asci]     iters: 20 M Elapsed: 0.809687 s Rate: 24.7 (M/sec) 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.824845 s Rate: 11.0 (M/sec) 4
[dist_uni]      iters: 20 M Elapsed: 1.140782 s Rate: 17.5 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 0.953847 s Rate: 21.0 (M/sec) 4
Total: 4.729161 seconds

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS/src$ ./levtestcpp
[dist_asci]     distance: 4 expect: 4
[dist_utf8_ucs] distance: 4 expect: 4
[dist_uni]      distance: 4 expect: 4
[dist_hybrid]   distance: 4 expect: 4
[dist_asci]     iters: 20 M Elapsed: 0.793727 s Rate: 25.2 (M/sec) 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.809635 s Rate: 11.1 (M/sec) 4
[dist_uni]      iters: 20 M Elapsed: 1.168586 s Rate: 17.1 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 0.948328 s Rate: 21.1 (M/sec) 4
Total: 4.720276 seconds

# simple with pre-/suffix
helmut@mbp:~/github/perl/Text-Levenshtein-Uni/src$ ./levtest
[dist_utf8_ucs] distance: 4 expect: 4
[dist_hybrid]   distance: 4 expect: 4
[dist_simple]   distance: 4 expect: 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.777167 s Rate: 11.3 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 0.966135 s Rate: 20.7 (M/sec) 4
[dist_simple]   iters: 20 M Elapsed: 2.193030 s Rate: 9.1 (M/sec) 4
Total: 4.936332 seconds

# simple without pre-/suffix
helmut@mbp:~/github/perl/Text-Levenshtein-Uni/src$ ./levtest
[dist_utf8_ucs] distance: 4 expect: 4
[dist_hybrid]   distance: 4 expect: 4
[dist_simple]   distance: 4 expect: 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.853366 s Rate: 10.8 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 1.010987 s Rate: 19.8 (M/sec) 4
[dist_simple]   iters: 20 M Elapsed: 3.219757 s Rate: 6.2 (M/sec) 4
Total: 6.084110 seconds

# mixed
helmut@mbp:~/github/perl/Text-Levenshtein-Uni/src$ ./levtest
[dist_utf8_ucs] distance: 4 expect: 4
[dist_hybrid]   distance: 4 expect: 4
[dist_mixed]    distance: 4 expect: 4
[dist_simple]   distance: 4 expect: 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.888164 s Rate: 10.6 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 1.016698 s Rate: 19.7 (M/sec) 4
[dist_mixed]    iters: 20 M Elapsed: 1.027602 s Rate: 19.5 (M/sec) 4
[dist_simple]   iters: 20 M Elapsed: 2.977173 s Rate: 6.7 (M/sec) 4
Total: 6.909637 seconds

helmut@mbp:~/github/perl/Text-Levenshtein-Uni/src$ ./levtestcpp
[dist_utf8_ucs] distance: 4 expect: 4
[dist_hybrid]   distance: 4 expect: 4
[dist_mixed]    distance: 4 expect: 4
[dist_simple]   distance: 4 expect: 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.888937 s Rate: 10.6 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 0.989074 s Rate: 20.2 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 0.995838 s Rate: 20.1 (M/sec) 4
[dist_mixed]    iters: 20 M Elapsed: 1.037983 s Rate: 19.3 (M/sec) 4
[dist_simple]   iters: 20 M Elapsed: 2.336609 s Rate: 8.6 (M/sec) 4
Total: 7.248441 seconds

helmut@mbp:~/github/perl/Text-Levenshtein-Uni$ perl xt/50_distance_bench.t
                    Rate TL::Flex_l52 TL::Uni_l52 TL::Flex_uni TL::Flex_ascii TL::Uni_uni TL::Uni_ascii
TL::Flex_l52    225467/s           --        -90%         -91%           -94%        -97%          -97%
TL::Uni_l52    2184532/s         869%          --         -15%           -41%        -73%          -74%
TL::Flex_uni   2572440/s        1041%         18%           --           -30%        -68%          -69%
TL::Flex_ascii 3674916/s        1530%         68%          43%             --        -54%          -56%
TL::Uni_uni    8065969/s        3477%        269%         214%           119%          --           -4%
TL::Uni_ascii  8385413/s        3619%        284%         226%           128%          4%            --

$ ./levtestcpp
strlen(utf_str1): 10
strlen(utf_str2): 13
a_string.size(): 10
b_string.size(): 11
[dist_utf8_ucs] distance: 4 expect: 4
[dist_mixed]    distance: 4 expect: 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.919418 s Rate: 10.4 (M/sec) 4
[dist_mixed]    iters: 20 M Elapsed: 1.093002 s Rate: 18.3 (M/sec) 4
Total: 3.012420 seconds

helmut@mbp:~/github/perl/Text-Levenshtein-Uni/src$ ./levtest
sizeof(int): 4

[dist_utf8_ucs] distance: 4 expect: 4
[dist_mixed]    distance: 4 expect: 4

strlen(utf_str1_l52): 51
strlen(utf_str2_l52): 51
a_chars_l52: 51
b_chars_l52: 51
[dist_mixed_l52] distance: 2 expect: 2

[dist_utf8_ucs] iters: 20 M Elapsed: 1.978637 s Rate: 10.1 (M/sec) 4
[dist_mixed]    iters: 20 M Elapsed: 1.113225 s Rate: 18.0 (M/sec) 4
[dist_mixed_l52] iters: 20 M Elapsed: 5.180744 s Rate: 3.9 (M/sec) 2
Total: 8.272606 seconds

helmut@mbp:~/github/perl/Text-Levenshtein-Uni$ perl xt/50_distance_bench.t
                    Rate TL::Flex_l52 TL::Uni_l52 TL::Flex_uni TL::Flex_ascii TL::Uni_ascii TL::Uni_uni
TL::Flex_l52    218453/s           --        -90%         -91%           -94%          -97%        -97%
TL::Uni_l52    2248783/s         929%          --          -7%           -39%          -71%        -71%
TL::Flex_uni   2429401/s        1012%          8%           --           -34%          -68%        -69%
TL::Flex_ascii 3679213/s        1584%         64%          51%             --          -52%        -53%
TL::Uni_ascii  7699334/s        3424%        242%         217%           109%            --         -2%
TL::Uni_uni    7864320/s        3500%        250%         224%           114%            2%          --

# without init if no unichars
$ ./levtest

[dist_utf8_ucs] iters: 20 M Elapsed: 1.842317 s Rate: 10.9 (M/sec) 4
[dist_mixed]    iters: 20 M Elapsed: 0.941020 s Rate: 21.3 (M/sec) 4
[dist_mixed_l52] iters: 20 M Elapsed: 4.662726 s Rate: 4.3 (M/sec) 2
Total: 7.446063 seconds

helmut@mbp:~/github/perl/Text-Levenshtein-Uni$ perl xt/50_distance_bench.t
                    Rate TL::Flex_l52 TL::Uni_l52 TL::Flex_uni TL::Flex_ascii TL::Uni_uni TL::Uni_ascii
TL::Flex_l52    214369/s           --        -91%         -91%           -94%        -97%          -97%
TL::Uni_l52    2293759/s         970%          --          -1%           -39%        -69%          -72%
TL::Flex_uni   2316929/s         981%          1%           --           -38%        -69%          -72%
TL::Flex_ascii 3744914/s        1647%         63%          62%             --        -50%          -54%
TL::Uni_uni    7419170/s        3361%        223%         220%            98%          --           -9%
TL::Uni_ascii  8143526/s        3699%        255%         251%           117%         10%            --

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS/src$ ./levtest
[dist_asci]     distance: 4 expect: 4
[dist_utf8_ucs] distance: 4 expect: 4
[dist_uni]      distance: 4 expect: 4
[dist_hybrid]   distance: 4 expect: 4
[dist_asci]     iters: 20 M Elapsed: 0.792167 s Rate: 25.2 (M/sec) 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.822315 s Rate: 11.0 (M/sec) 4
[dist_uni]      iters: 20 M Elapsed: 1.057966 s Rate: 18.9 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 1.029933 s Rate: 19.4 (M/sec) 4
Total: 4.702381 seconds

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS/src$ ./levtest
[dist_asci]     distance: 4 expect: 4
[dist_utf8_ucs] distance: 4 expect: 4
[dist_uni]      distance: 4 expect: 4
[dist_hybrid]   distance: 4 expect: 4
strlen(utf_str1_l52): 51
strlen(utf_str2_l52): 51
a_chars_l52: 51
b_chars_l52: 51
[dist_hybrid_l52] distance: 2 expect: 2

[dist_asci]     iters: 20 M Elapsed: 0.777958 s Rate: 25.7 (M/sec) 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.629534 s Rate: 12.3 (M/sec) 4
[dist_uni]      iters: 20 M Elapsed: 1.024981 s Rate: 19.5 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 0.856602 s Rate: 23.3 (M/sec) 4
[dist_hybrid_l52] iters: 20 M Elapsed: 4.317598 s Rate: 4.6 (M/sec) 2
Total: 8.606673 seconds

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS/src$ ./levtest

[dist_asci]     iters: 20 M Elapsed: 0.767510 s Rate: 26.1 (M/sec) 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.668906 s Rate: 12.0 (M/sec) 4
[dist_uni]      iters: 20 M Elapsed: 1.084455 s Rate: 18.4 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 0.877781 s Rate: 22.8 (M/sec) 4
[dist_hybrid_l52] iters: 1 M Elapsed: 0.211921 s Rate: 4.7 (M/sec) 2
[dist_simple_l52] iters: 1 M Elapsed: 2.805772 s Rate: 0.4 (M/sec) 2
[dist_hybrid_l68] iters: 1 M Elapsed: 1.104434 s Rate: 0.9 (M/sec) 2
[dist_simple_l68] iters: 1 M Elapsed: 5.239051 s Rate: 0.2 (M/sec) 2
Total: 13.759830 seconds

[dist_asci]       iters: 20 M Elapsed: 0.770701 s Rate: 26.0 (M/sec) 4
[dist_utf8_ucs]   iters: 20 M Elapsed: 1.668905 s Rate: 12.0 (M/sec) 4
[dist_uni]        iters: 20 M Elapsed: 1.044732 s Rate: 19.1 (M/sec) 4
[dist_hybrid]     iters: 20 M Elapsed: 0.894269 s Rate: 22.4 (M/sec) 4 rate*m = 224
[dist_simple]     iters: 20 M Elapsed: 2.318116 s Rate:  8.6 (M/sec) 4 n*m = 100
[dist_hybrid_l52] iters:  1 M Elapsed: 0.215284 s Rate:  4.6 (M/sec) 2 rate*m = 234.6
[dist_simple_l52] iters:  1 M Elapsed: 2.835607 s Rate:  0.4 (M/sec) 2 n*m = 2601 (x 21.5)
[dist_hybrid_l68] iters:  1 M Elapsed: 1.048904 s Rate:  1.0 (M/sec) 2 rate*m = 69
[dist_simple_l68] iters:  1 M Elapsed: 5.083186 s Rate:  0.2 (M/sec) 2 n*m = 4761 (x 43)
Total: 15.879704 seconds

# turning off m < 64
helmut@mbp:~/github/perl/Text-Levenshtein-BVXS/src$ ./levtest

[dist_asci]     iters: 20 M Elapsed: 0.783247 s Rate: 25.5 (M/sec) 4
[dist_utf8_ucs] iters: 20 M Elapsed: 8.471084 s Rate: 2.4 (M/sec) 4
[dist_uni]      iters: 20 M Elapsed: 1.068766 s Rate: 18.7 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 7.528333 s Rate: 2.7 (M/sec) 4 rate * m = 27
[dist_simple]   iters: 20 M Elapsed: 2.248503 s Rate: 8.9 (M/sec) 4
[dist_hybrid_l52] iters: 1 M Elapsed: 0.631711 s Rate: 1.6 (M/sec) 2 rate*m = 81,6
[dist_simple_l52] iters: 1 M Elapsed: 2.845362 s Rate: 0.4 (M/sec) 2
[dist_hybrid_l68] iters: 1 M Elapsed: 1.026796 s Rate: 1.0 (M/sec) 2 rate*m = 69
[dist_simple_l68] iters: 1 M Elapsed: 5.072917 s Rate: 0.2 (M/sec) 2
Total: 29.676719 seconds

# BVXS=simple has nearly 2-fold speed of Flexible

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS$ perl xt/50_distance_bench.t
                    Rate TL::Flex_l68 TL::BVXS_l68 TL::Flex_l52 TL::BVXS_l52 TL::Flex_uni TL::Flex_ascii TL::BVXS_uni TL::BVXS_ascii
TL::Flex_l68    127242/s           --         -31%         -42%         -60%         -95%           -97%         -97%           -98%
TL::BVXS_l68    183991/s          45%           --         -17%         -42%         -93%           -95%         -96%           -97%
TL::Flex_l52    220553/s          73%          20%           --         -31%         -91%           -94%         -96%           -96%
TL::BVXS_l52    318577/s         150%          73%          44%           --         -87%           -91%         -94%           -94%
TL::Flex_uni   2453219/s        1828%        1233%        1012%         670%           --           -33%         -51%           -55%
TL::Flex_ascii 3640889/s        2761%        1879%        1551%        1043%          48%             --         -27%           -33%
TL::BVXS_uni   4959481/s        3798%        2596%        2149%        1457%         102%            36%           --            -9%
TL::BVXS_ascii 5420446/s        4160%        2846%        2358%        1601%         121%            49%           9%             --

# BVXS=hybrid
helmut@mbp:~/github/perl/Text-Levenshtein-BVXS$ perl xt/50_distance_bench.t
                    Rate TL::Flex_l68 TL::Flex_l52 TL::BVXS_l68 TL::BVXS_l52 TL::Flex_uni TL::Flex_ascii TL::BVXS_uni TL::BVXS_ascii
TL::Flex_l68    124660/s           --         -45%         -84%         -95%         -95%           -97%         -98%           -99%
TL::Flex_l52    224877/s          80%           --         -71%         -90%         -91%           -94%         -97%           -97%
TL::BVXS_l68    778425/s         524%         246%           --         -67%         -69%           -80%         -90%           -91%
TL::BVXS_l52   2360644/s        1794%         950%         203%           --          -7%           -39%         -70%           -73%
TL::Flex_uni   2525239/s        1926%        1023%         224%           7%           --           -34%         -68%           -72%
TL::Flex_ascii 3847984/s        2987%        1611%         394%          63%          52%             --         -52%           -57%
TL::BVXS_uni   7989150/s        6309%        3453%         926%         238%         216%           108%           --           -10%
TL::BVXS_ascii 8907805/s        7046%        3861%        1044%         277%         253%           131%          11%             --

