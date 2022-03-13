#ifndef _LEVBV_TEST
#define _LEVBV_TEST
#endif

#include <string.h>
#include <cwchar>
#include <codecvt>
#include <locale>

#include <vector>

#include <ctime>
#include <cmath>

#include <cstdio>
#include <iostream>

#include "levbv.h"
#include "levbv.c"

//#include <iostream>       // std::cout, std::hex
#include <string>         // std::string, std::u32string
//#include <locale>         // std::wstring_convert
//#include <codecvt>        // std::codecvt_utf8
#include <cstdint>        // std::uint_least32_t

/*
// https://github.com/tesseract-ocr/tesseract/issues/3560
// tesseract/src/training/unicharset/lstmtrainer.cpp
// LSTMTrainer::ComputeCharError
// Computes CER (Character Error Rate). 
 double ComputeCER(const std::vector<int> &truth_str, 
                   const std::vector<int> &ocr_str) { 
 
   int truth_size = truth_str.size;
   int ocr_size   = ocr_str.size; 
 
   return static_cast<double>(char_errors) / truth_size; 
 } 
 
// Computes WER (Word Error Rate)
// NOTE that this is destructive on both input strings.
// LSTMTrainer::ComputeWordError(&truth_text, &ocr_text);
double ComputeWER(std::string *truth_str, std::string *ocr_str) {
                        
  using StrMap = std::unordered_map<std::string, int, std::hash<std::string>>;
  
  std::vector<std::string> truth_words = split(*truth_str, ' ');
  if (truth_words.empty()) {
    return 0.0;
  }
  
  std::vector<std::string> ocr_words = split(*ocr_str, ' ');
  StrMap word_counts;
  
  for (const auto &truth_word : truth_words) {
    std::string truth_word_string(truth_word.c_str());
    auto it = word_counts.find(truth_word_string);
    if (it == word_counts.end()) {
      word_counts.insert(std::make_pair(truth_word_string, 1));
    } else {
      ++it->second;
    }
  }	
  // *****
    int truth_words;
	int ocr_words;
	
  	return static_cast<double>(word_recall_errs) / truth_words;
}
*/

//using namespace std;
int main() {

    clock_t tic;
    clock_t toc;
    double elapsed;
    double total = 0;
    double rate;

    uint64_t count;
    uint64_t megacount;
    uint32_t iters     = 1000000;
    uint32_t megaiters = 1;

/*
    // m=10, n=11, llcs=7, sim=0.667
    const char ascii_str1[] = "Choerephon";
    const char ascii_str2[] = "Chrerrplzon";
    uint32_t ascii_len1 = strlen(ascii_str1);
    uint32_t ascii_len2 = strlen(ascii_str2);
*/

/*
https://www.cplusplus.com/reference/locale/wstring_convert/
// converting from UTF-32 to UTF-8
#include <iostream>       // std::cout, std::hex
#include <string>         // std::string, std::u32string
#include <locale>         // std::wstring_convert
#include <codecvt>        // std::codecvt_utf8
#include <cstdint>        // std::uint_least32_t

// from_bytes
// to_bytes
int main ()
{
  std::u32string str32 ( U"\U00004f60\U0000597d" );  // ni hao (你好)
  std::string str8;

  std::wstring_convert<std::codecvt_utf8<char32_t>,char32_t> cv;

  str8 = cv.to_bytes(str32);

  // print contents (as their hex representations):
  std::cout << std::hex;

  std::cout << "UTF-32: ";
  for (char32_t c : str32)
    std::cout << '[' << std::uint_least32_t(c) << ']';
  std::cout << '\n';

  std::cout << "UTF-8 : ";
  for (char c : str8)
    std::cout << '[' << int(static_cast<unsigned char>(c)) << ']';
  std::cout << '\n';

  return 0;
}


*/
//const char8_t * = u8"こんにちは世界";
    // https://www.cplusplus.com/doc/tutorial/constants/
    char utf_str1[] = u8"Choerephon"; // u8 = utf-8 encoded
    char utf_str2[] = u8"Chſerſplzon";
    
    //std::string utf_str1 = u8"Choerephon";
    //std::string utf_str2 = u8"Chſerſplzon";
    
    int utf_len1 = strlen(utf_str1);
    int utf_len2 = strlen(utf_str2);
    printf("strlen(utf_str1): %u \n", utf_len1);
    printf("strlen(utf_str2): %u \n", utf_len2);
    
    std::u32string a_string;
    std::wstring_convert<std::codecvt_utf8<char32_t>,char32_t> cv;
    a_string = cv.from_bytes(utf_str1);
    int a_chars = a_string.size();

	std::u32string b_string;
	b_string = cv.from_bytes(utf_str2);
    int b_chars = b_string.size();
    printf("a_string.size(): %u \n", a_chars);
    printf("b_string.size(): %u \n", b_chars);   
        

// https://stackoverflow.com/questions/2923272/how-to-convert-vector-to-array
    uint32_t *a_ucs = (uint32_t *)&a_string[0];
    uint32_t *b_ucs = (uint32_t *)&b_string[0];
	
    int distance;
    
    distance = dist_utf8_ucs (utf_str1, utf_len1, utf_str2, utf_len2);
    printf("[dist_utf8_ucs] distance: %u expect: 4\n", distance);

	distance = dist_mixed(a_ucs, a_chars, b_ucs, b_chars);
	printf("[dist_mixed]    distance: %u expect: 4\n", distance);   

    /* ########## dist_utf8_ucs ########## */

if (1) {
    tic = clock();

    megaiters = 20;

    for (megacount = 0; megacount < megaiters; megacount++) {
      for (count = 0; count < iters; count++) {
          distance = dist_utf8_ucs (utf_str1, utf_len1, utf_str2, utf_len2);
      }
    }

    toc = clock();
    elapsed = (double)(toc - tic) / (double)CLOCKS_PER_SEC;
    total += elapsed;
    rate    = (double)megaiters / (double)elapsed;

    printf("[dist_utf8_ucs] iters: %u M Elapsed: %f s Rate: %.1f (M/sec) %u\n",
        megaiters, elapsed, rate, distance);
}

    /* ########## dist_mixed ########## */

if (1) {
    tic = clock();

    megaiters = 20;

    for (megacount = 0; megacount < megaiters; megacount++) {
      for (count = 0; count < iters; count++) {
          distance = dist_mixed(a_ucs, a_chars, b_ucs, b_chars);
      }
    }

    toc = clock();
    elapsed = (double)(toc - tic) / (double)CLOCKS_PER_SEC;
    total += elapsed;
    rate    = (double)megaiters / (double)elapsed;

    printf("[dist_mixed]    iters: %u M Elapsed: %f s Rate: %.1f (M/sec) %u\n",
        megaiters, elapsed, rate, distance);
}

    printf("Total: %f seconds\n", total);



    return 0;    
    
}

