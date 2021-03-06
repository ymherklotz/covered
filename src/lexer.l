%{
/*
 Copyright (c) 2006-2010 Trevor Williams

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later version.

 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with this program;
 if not, write to the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

/*!
 \file     lexer.c
 \author   Trevor Williams  (phase1geo@gmail.com)
 \date     12/2/2001
 \brief    Lexer for Verilog language
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <ctype.h>

#include "db.h"
#include "defines.h"
#include "gen_item.h"
#include "generator.new.h"
#include "keywords.h"
#include "link.h"
#include "obfuscate.h"
#include "parser_misc.h"
#ifdef GENERATOR
#include "gen_parser.h"
#else
#include "parser.h"
#endif
#include "tree.h"
#include "util.h"
#include "vsignal.h"
#include "vector.h"

#ifdef GENERATOR
#define yylval GENlval
#define lexer_keyword_1995_code     gen_lexer_keyword_1995_code
#define lexer_keyword_2001_code     gen_lexer_keyword_2001_code
#define lexer_keyword_sv_code       gen_lexer_keyword_sv_code
#define lexer_keyword_sys_1995_code gen_lexer_keyword_sys_1995_code
#define lexer_keyword_sys_2001_code gen_lexer_keyword_sys_2001_code
#define lexer_keyword_sys_sv_code   gen_lexer_keyword_sys_sv_code
#else
#define yylval VLlval
#define lexer_keyword_1995_code     vl_lexer_keyword_1995_code
#define lexer_keyword_2001_code     vl_lexer_keyword_2001_code
#define lexer_keyword_sv_code       vl_lexer_keyword_sv_code
#define lexer_keyword_sys_1995_code vl_lexer_keyword_sys_1995_code
#define lexer_keyword_sys_2001_code vl_lexer_keyword_sys_2001_code
#define lexer_keyword_sys_sv_code   vl_lexer_keyword_sys_sv_code
#endif
#define YYDEBUG 1
#define YYERROR_VERBOSE 1

extern YYLTYPE yylloc;

extern void reset_pplexer( char* filename, FILE* out );
extern int PPVLlex( void );

extern int          ignore_mode;
extern int          generate_mode;
extern int          attr_mode;
extern unsigned int exclude_mode;
extern unsigned int ignore_racecheck_mode;
extern char         user_msg[USER_MSG_LENGTH];
extern char*        ppfilename;
extern str_link*    modlist_head;
extern str_link*    modlist_tail;
extern func_unit*   curr_funit;
extern sig_range    curr_prange;
extern sig_range    curr_urange;
extern gen_item*    last_gi;
extern isuppl       info_suppl;
extern bool         flag_conservative;
extern int          block_depth;
extern unsigned int for_start_line;
extern unsigned int for_start_col;
extern char*        directive_filename;
extern char*        pragma_coverage_name;
extern char*        pragma_racecheck_name;


/*!
 Contains state before entering exclusive block.
*/
static int  state_enter;

static void line_directive();
static void line_directive2();
void process_timescale( const char* txt, bool report );
static int  yywrap();
static void check_for_pragma( char* comment );

/*!
 Pointer to head of file list to parse.
*/
static str_link* filelist_head = 0;

/*!
 Pointer to tail of file list to parse.
*/
static str_link* filelist_curr = 0;

/*!
 Integer value of last keyword parsed.
*/
static int last_keyword = 0;

/*!
 Tree containing all found modules parsed within the design.
*/
static tnode* found_modules = NULL;

/*!
 Specifies if the current file was previously parsed.  If it was, we need to ignore
 all globally declared stuff.
*/
static bool file_prev_parsed;

/*!
 Saves file version information (if found) for the current file.
*/
static char* file_version = NULL;

/*@-unreachable@*/
%}

%option stack

%x LCOMMENT
%x CCOMMENT
%x CSTRING
%x ERROR_LINE
%s IGNORE_MODULE
%s IGNORE_ASSERT
%s IGNORE_PROPERTY
%s IGNORE_SEQUENCE
%s IGNORE_GLOBALS
%s IGNORE_PROGRAM
%s PARSE
%s UDPTABLE
%s TIMEUNIT
%s LIBOPTIONS
%s IMEXPORT
%x PPTIMESCALE

WSPACE [ \t\b\f]+

%%

  /* Whitespace -- we ignore this */
[ \t\b\f\r]   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
 }

  /* Newline character - blank line -- we ignore these */
\n {
  yylloc.first_line++;
  yylloc.ppfline++;
  yylloc.pplline++;
  yylloc.last_line++;
  yylloc.last_column = 0;
 }

  /* Handle line directives */
^{WSPACE}?"#line"[ ]+\"[^\"]*\"[ ]+[0-9]+.* {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  line_directive();
 }

^{WSPACE}?"`line"[ ]+[0-9]+[ ]+\"[^\"]*\".* {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  line_directive2();
 }

  /* Single-line comment -- we ignore this information */
"//"          {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  state_enter         = YY_START;
  BEGIN( LCOMMENT );
 }
<LCOMMENT>.   {
  yylloc.last_column += 1;
  yymore();
 }
<LCOMMENT>\n  {
  check_for_pragma( yytext );
  BEGIN( state_enter );
  yylloc.first_line++;
  yylloc.ppfline++;
  yylloc.pplline++;
  yylloc.last_line++;
  yylloc.last_column = 0;
 }

  /* Multi-line comment */
"/*"           {
  state_enter         = YY_START;
  BEGIN( CCOMMENT );
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
 }
<CCOMMENT>.    {
  yylloc.last_column += 1;
  yymore();
 }
<CCOMMENT>\n   {
  yylloc.first_line++;
  yylloc.ppfline++;
  yylloc.pplline++;
  yylloc.last_line++;
  yylloc.last_column = 0;
  yymore();
 }
<CCOMMENT>"*/" {
  check_for_pragma( yytext );
  yylloc.last_column += 2;
  BEGIN( state_enter );
 }

  /* Multi-character symbols */
<PARSE>"(*"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_PSTAR;
 }

<PARSE>"*)"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_STARP;
 }

<PARSE>"<<"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_LS;
 }

<PARSE>"<<<"  {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 3;
  return K_LSS;
 }

<PARSE>">>"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_RS;
 }

<PARSE>">>>"  {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 3;
  return K_RSS;
 }

<PARSE>"<="   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_LE;
 }

<PARSE>">="   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_GE;
 }

<PARSE>"=="   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_EQ;
 }

<PARSE>"!="   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_NE;
 }

<PARSE>"==="  {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 3;
  return K_CEQ;
 }

<PARSE>"!=="  {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 3;
  return K_CNE;
 }

<PARSE>"=?="  {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 3;
  return K_PEQ;
 }

<PARSE>"!?="  {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 3;
  return K_PNE;
 }

<PARSE>"||"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_LOR;
 }

<PARSE>"&&"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_LAND;
 }

<PARSE>"&&&"  {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 3;
  return K_TAND;
 }

<PARSE>"~|"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_NOR;
 }

<PARSE>"~^"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_NXOR;
 }

<PARSE>"^~"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_NXOR;
 }

<PARSE>"~&"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_NAND;
 }

<PARSE>"->"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_TRIGGER;
 }

<PARSE>"+:"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_PO_POS;
 }

<PARSE>"-:"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_PO_NEG;
 }

<PARSE>"=>"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_EG;
 }

<PARSE>"*>"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_SG;
 }

<PARSE>".*"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_PS;
 }

<PARSE>"##"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_PP;
 }

<PARSE>"+="   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_ADD_A;
 }

<PARSE>"-="   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_SUB_A;
 }

<PARSE>"*="   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_MLT_A;
 }

<PARSE>"/="   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_DIV_A;
 }

<PARSE>"%="   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_MOD_A;
 }

<PARSE>"&="   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_AND_A;
 }

<PARSE>"|="   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_OR_A;
 }

<PARSE>"^="   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_XOR_A;
 }

<PARSE>"<<="  {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 3;
  return K_LS_A;
 }

<PARSE>">>="  {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 3;
  return K_RS_A;
 }

<PARSE>"<<<=" {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 4;
  return K_ALS_A;
 }

<PARSE>">>>=" {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 4;
  return K_ARS_A;
 }

<PARSE>"++"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_INC;
 }

<PARSE>"--"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_DEC;
 }

<PARSE>"**"   {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 2;
  return K_POW;
 }

  /* Properly handle all cases of (*) and convert it to a simple '*' */
<PARSE>"("{WSPACE}*"*"{WSPACE}*")" {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  return '*';
 }

  /* Single character symbols */
<PARSE>[}{;:\[\],()#=.@&!?<>%|^~+*/-] {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 1;
  if( (yytext[0] == ';') || (yytext[0] == ',') ) {
    curr_prange.clear = TRUE;
    curr_urange.clear = TRUE;
  }
  return yytext[0];
 }

  /* C-style strings */
<PARSE>\"            {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += 1;
 #ifdef GENERATOR
  yymore();
 #endif
  state_enter         = YY_START;
  BEGIN( CSTRING );
 }
<CSTRING>\\\" {
  yylloc.last_column += 2;
  yymore();
 }
<CSTRING>\n   {
  yylloc.last_column = 0;
  BEGIN( state_enter );
  yylloc.first_line++;
  yylloc.ppfline++;
  yylloc.pplline++;
  yylloc.last_line++;
  return 0;
 }
<CSTRING>\"   {
  int   str_len = strlen( yytext );
  char* tmpstr;
  tmpstr = strdup_safe( yytext );
 #ifdef GENERATOR
  yylval.text = tmpstr;
 #else
  tmpstr[ str_len - 1 ] = '\0';
  vector_from_string( &tmpstr, TRUE, &(yylval.num.vec), &(yylval.num.base) );
  free_safe( tmpstr, (str_len + 1) );
 #endif
  yylloc.last_column += 1;
  BEGIN( state_enter );
  return STRING;
 }
<CSTRING>.    {
  yylloc.last_column += 1;
  yymore();
 }

  /* Ignore modules that are not needed by the parser. */
<IGNORE_MODULE>endmodule    {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  if( file_prev_parsed ) {
    BEGIN( IGNORE_GLOBALS );
  } else {
    BEGIN( PARSE );
  }
  return I_endmodule;
 }
<IGNORE_MODULE>endprimitive {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  if( file_prev_parsed ) {
    BEGIN( IGNORE_GLOBALS );
  } else {
    BEGIN( PARSE );
  }
  return( K_endprimitive );
 }
<IGNORE_MODULE>. {
 }

  /* Used when we have previously parsed a file and want to ignore all global variables (SystemVerilog mode only) */
<IGNORE_GLOBALS>module {
  yyless( 0 );
  BEGIN( PARSE );
 }
<IGNORE_GLOBALS>primitive {
  yyless( 0 );
  BEGIN( PARSE );
 }

  /* Ignore assertion syntax */
<IGNORE_ASSERT>; {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  BEGIN( PARSE );
  return ';';
 }
<IGNORE_ASSERT>. {
  yylloc.last_column += 1;
  yymore();
 }

  /* Ignore property syntax */
<IGNORE_PROPERTY>endproperty {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  BEGIN( PARSE );
  return K_endproperty;
 }
<IGNORE_PROPERTY>. {
  yylloc.last_column += 1;
  yymore();
 }

  /* Ignore sequence syntax */
<IGNORE_SEQUENCE>endsequence {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  BEGIN( PARSE );
  return K_endsequence;
 }
<IGNORE_SEQUENCE>. {
  yylloc.last_column += 1;
  yymore();
 }

  /* Ignore program syntax */
<IGNORE_PROGRAM>endprogram {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  BEGIN( PARSE );
  return K_endprogram;
 }
<IGNORE_PROGRAM>. {
  yylloc.last_column += 1;
  yymore();
 }

  /* Entries for user defined primitive tables -- not currently supported */
<UDPTABLE>\(\?0\)    {
  yylloc.last_column += strlen( yytext );
  return '_';
 }
<UDPTABLE>\(\?1\)    {
  yylloc.last_column += strlen( yytext );
  return '+';
 }
<UDPTABLE>\(\?[xX]\) {
  yylloc.last_column += strlen( yytext );
  return '%';
 }
<UDPTABLE>\(\?\?\)   {
  yylloc.last_column += strlen( yytext );
  return '*';
 }
<UDPTABLE>\(01\)     {
  yylloc.last_column += strlen( yytext );
  return 'r';
 }
<UDPTABLE>\(0[xX]\)  {
  yylloc.last_column += strlen( yytext );
  return 'Q';
 }
<UDPTABLE>\(0\?\)    {
  yylloc.last_column += strlen( yytext );
  return 'P';
 }
<UDPTABLE>\(10\)     {
  yylloc.last_column += strlen( yytext );
  return 'f';
 }
<UDPTABLE>\(1[xX]\)  {
  yylloc.last_column += strlen( yytext );
  return 'M';
 }
<UDPTABLE>\(1\?\)    {
  yylloc.last_column += strlen( yytext );
  return 'N';
 }
<UDPTABLE>\([xX]0\)  {
  yylloc.last_column += strlen( yytext );
  return 'F';
 }
<UDPTABLE>\([xX]1\)  {
  yylloc.last_column += strlen( yytext );
  return 'R';
 }
<UDPTABLE>\([xX]\?\) {
  yylloc.last_column += strlen( yytext );
  return 'B';
 }
<UDPTABLE>[bB]       {
  yylloc.last_column += strlen( yytext );
  return 'b';
 }
<UDPTABLE>[lL]       {
  yylloc.last_column += strlen( yytext );
  return 'l';
 }
<UDPTABLE>[hH]       {
  yylloc.last_column += strlen( yytext );
  return 'h';
 }
<UDPTABLE>[fF]       {
  yylloc.last_column += strlen( yytext );
  return 'f';
 }
<UDPTABLE>[rR]       {
  yylloc.last_column += strlen( yytext );
  return 'r';
 }
<UDPTABLE>[xX]       {
  yylloc.last_column += strlen( yytext );
  return 'x';
 }
<UDPTABLE>[nN]       {
  yylloc.last_column += strlen( yytext );
  return 'n';
 }
<UDPTABLE>[pP]       {
  yylloc.last_column += strlen( yytext );
  return 'p';
 }
<UDPTABLE>[zZ]       {
  yylloc.last_column += strlen( yytext );
  return 'z';
 }
<UDPTABLE>[01\?\*\-] {
  yylloc.last_column += strlen( yytext );
  return yytext[0];
 }

  /* Entries for time units */
<TIMEUNIT>step {
  yylloc.last_column += strlen( yytext );
  return K_TU_STEP;
 }
<TIMEUNIT>s    {
  yylloc.last_column += strlen( yytext );
  return K_TU_S;
 }
<TIMEUNIT>ms   {
  yylloc.last_column += strlen( yytext );
  return K_TU_MS;
 }
<TIMEUNIT>us   {
  yylloc.last_column += strlen( yytext );
  return K_TU_US;
 }
<TIMEUNIT>ns   {
  yylloc.last_column += strlen( yytext );
  return K_TU_NS;
 }
<TIMEUNIT>ps   {
  yylloc.last_column += strlen( yytext );
  return K_TU_PS;
 }
<TIMEUNIT>fs   {
  yylloc.last_column += strlen( yytext );
  return K_TU_FS;
 }

  /* Library options */
<LIBOPTIONS>-incdir {
  yylloc.last_column += strlen( yytext );
  return K_INCDIR;
 }

  /* Import/Export options */
<IMEXPORT>\"DPI\" {
  yylloc.last_column += strlen( yytext );
  return K_DPI;
 }

  /* Keyword and signal identifiers */
<PARSE>[a-zA-Z_][a-zA-Z0-9$_]*(\[[^]]*\]\.[a-zA-Z_][a-zA-Z0-9$_]*)* {
  str_link* foundmod;
  int       rc   = lexer_keyword_1995_code( yytext, yyleng );
  if( (rc == IDENTIFIER) && parser_check_generation( GENERATION_2001 ) ) {
    rc = lexer_keyword_2001_code( yytext, yyleng );
  }
  if( (rc == IDENTIFIER) && parser_check_generation( GENERATION_SV ) ) {
    rc = lexer_keyword_sv_code( yytext, yyleng );
    if( (rc == IDENTIFIER) && (ignore_mode == 0) ) {
 #ifdef GENERATOR
      if( db_find_typedef( yytext ) != NULL ) {
        yylval.text = strdup_safe( yytext );
        rc = TYPEDEF_IDENTIFIER;
      }
 #else
      if( (yylval.typdef = db_find_typedef( yytext )) != NULL ) {
        rc = TYPEDEF_IDENTIFIER;
      }
 #endif
    }
  }
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  if( rc == K_for ) {
    for_start_line = yylloc.ppfline;
    for_start_col  = yylloc.first_column;
  }
  if( rc == IDENTIFIER ) {
    if( (generate_mode == 0) && ((last_gi == NULL) || (last_gi->suppl.part.type != GI_TYPE_INST)) && (strchr( yytext, '.' ) != NULL) ) {
      yylval.text = gen_item_calc_signal_name( yytext, curr_funit, yylloc.ppfline, TRUE );
    } else {
      yylval.text = strdup_safe( yytext );
    }
    // printf( "Allocated IDENTIFIER %p  %s, line %d\n", yylval.text, yylval.text, yylloc.first_line );
    if( strncmp( yylval.text, "PATHPULSE$", 10) == 0 ) {
      rc = PATHPULSE_IDENTIFIER;
    }
    if( (last_keyword == K_module) || (last_keyword == K_primitive) ) {
      if( (foundmod = str_link_find( yytext, modlist_head )) == NULL ) {
        free_safe( yylval.text, (strlen( yylval.text ) + 1) );
        BEGIN( IGNORE_MODULE );
        (void)tree_add( yytext, yylloc.incl_fname, FALSE, &found_modules );
        rc = IGNORE;
      } else {
        if( (filelist_curr != filelist_head) && (error_count == 0) ) {
          /* The module has been found, recirculate filelist */
          unsigned int rv = snprintf( user_msg, USER_MSG_LENGTH, "Parsing file '%s'", obf_file( yylloc.orig_fname ) );
          assert( rv < USER_MSG_LENGTH );
          print_output( user_msg, NORMAL, __FILE__, __LINE__ );
          filelist_curr = filelist_head;
        }
        last_keyword = 0;
      }
    }
  } else if( (rc == K_endmodule) || (rc == K_endprimitive) ) {
    if( file_prev_parsed ) {
      BEGIN( IGNORE_GLOBALS );
    }
  } else if( rc == K_assert ) {
    BEGIN( IGNORE_ASSERT );
  } else if( rc == K_property ) {
    BEGIN( IGNORE_PROPERTY );
  } else if( rc == K_sequence ) {
    BEGIN( IGNORE_SEQUENCE );
  } else if( rc == K_program ) {
    BEGIN( IGNORE_PROGRAM );
  } else if( rc != TYPEDEF_IDENTIFIER ) {
    last_keyword = rc;
    yylval.text = '\0';
  }
  return( rc );
 }

  /* Signal names starting with a '\' character */
<PARSE>\\[^ \t\b\f\r\n]+  {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  {
    unsigned int rv;
    unsigned int slen = strlen( yytext ) + 2;
    yylval.text = (char*)malloc_safe( slen );
    rv = snprintf( yylval.text, slen, "%s ", yytext );
    assert( rv < slen );
  }
  return IDENTIFIER; 
 }

  /* System call lines -- we ignore this information */
<PARSE>\$([a-zA-Z0-9$_]+)   {
  int rc = lexer_keyword_sys_1995_code( (yytext + 1), (yyleng - 1) );
  if( (rc == S_ignore) && parser_check_generation( GENERATION_2001 ) ) {
    rc = lexer_keyword_sys_2001_code( (yytext + 1), (yyleng - 1) );
  }
  if( (rc == S_ignore) && parser_check_generation( GENERATION_SV ) ) {
    rc = lexer_keyword_sys_sv_code( (yytext + 1), (yyleng - 1) );
  }
  /* If we are running in conservative mode, change $random, $urandom and $urandom_range to ignored lies */
  if( flag_conservative && ((rc == S_random) || (rc == S_urandom) || (rc == S_urandom_range)) ) {
    rc = S_ignore;
  }
 #ifdef GENERATOR
  yylval.text = strdup_safe( yytext );
 #endif
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  return( rc ); 
 }

  /* Unsized decimal number */
<PARSE>[0-9][0-9_]* {
  yylval.text = strdup_safe( yytext );
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  return DEC_NUMBER;
 }

  /* Decimal number */
<PARSE>\'[sS]?[dD][ \t]*[0-9][0-9_]* {
  yylval.text = strdup_safe( yytext );
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  return BASE_NUMBER;
 }

  /* Binary number */
<PARSE>\'[sS]?[bB][ \t]*[0-1xzXZ_\?]+ {
  yylval.text = strdup_safe( yytext );
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  return BASE_NUMBER;
 }

  /* Octal number */
<PARSE>\'[sS]?[oO][ \t]*[0-7xzXZ_\?]+ {
  yylval.text = strdup_safe( yytext );
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  return BASE_NUMBER;
 }

  /* Hexidecimal number - Size indicated */
<PARSE>\'[sS]?[hH][ \t]*[0-9a-fA-FxzXZ_\?]+ {
  yylval.text = strdup_safe( yytext );
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  return BASE_NUMBER;
 }

  /* Real numbers */
<PARSE>[0-9][0-9_]*\.[0-9][0-9_]*([Ee][+-]?[0-9][0-9_]*)? { 
  double       rtime;
  unsigned int slen = strlen( yytext );
  char*        stmp = strdup_safe( yytext );
 #ifdef GENERATOR
  yylval.text = stmp;
 #else
  yylval.realtime = (vector*)malloc_safe( sizeof( vector ) );
  if( sscanf( remove_underscores( stmp ), "%lf", &rtime ) == 1 ) {
    vector_init_r64( yylval.realtime, (rv64*)malloc_safe( sizeof( rv64 ) ), rtime, yytext, TRUE, VTYPE_VAL );
  } else {
    assert( 0 );
  }
  free_safe( stmp, (slen + 1) );
 #endif
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  return REALTIME;
 }

  /* Real numbers */
<PARSE>[0-9][0-9_]*[Ee][+-]?[0-9][0-9_]* { 
  double       rtime;
  unsigned int slen = strlen( yytext );
  char*        stmp = strdup_safe( yytext );
 #ifdef GENERATOR
  yylval.text = stmp;
 #else
  yylval.realtime = (vector*)malloc_safe( sizeof( vector ) );
  if( sscanf( remove_underscores( stmp ), "%lf", &rtime ) == 1 ) {
    vector_init_r64( yylval.realtime, (rv64*)malloc_safe( sizeof( rv64 ) ), rtime, yytext, TRUE, VTYPE_VAL );
  } else {
    assert( 0 );
  }
  free_safe( stmp, (slen + 1) );
 #endif
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  return REALTIME;
 }

  /* Timescale directive */
^{WSPACE}?`timescale {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  state_enter         = YY_START;
  BEGIN( PPTIMESCALE );
 }
<PPTIMESCALE>.      {
  yylloc.first_column = yylloc.last_column;
  yylloc.last_column += strlen( yytext );
  yymore();
 }
<PPTIMESCALE>\n      {
  process_timescale( yytext, TRUE );
  yylloc.first_line++;
  yylloc.ppfline++;
  yylloc.pplline++;
  yylloc.last_line++;
  BEGIN( state_enter );
  yylloc.last_column = 0;
 }

  /* Miscellaneous directives -- we ignore this information */
^{WSPACE}?`celldefine{WSPACE}?.* {
  yylloc.last_column = strlen( yytext );
 }
^{WSPACE}?`default_nettype{WSPACE}?.* {
  yylloc.last_column = strlen( yytext );
 }
^{WSPACE}?`delay_mode_distributed{WSPACE}?.* {
  yylloc.last_column = strlen( yytext );
 }
^{WSPACE}?`delay_mode_unit{WSPACE}?.*        {
  yylloc.last_column = strlen( yytext );
 }
^{WSPACE}?`delay_mode_path{WSPACE}?.*        {
  yylloc.last_column = strlen( yytext );
 }
^{WSPACE}?`disable_portfaults{WSPACE}?.*     {
  yylloc.last_column = strlen( yytext );
 }
^{WSPACE}?`enable_portfaults{WSPACE}?.*      {
  yylloc.last_column = strlen( yytext );
 }
^{WSPACE}?`endcelldefine{WSPACE}?.*          {
  yylloc.last_column = strlen( yytext );
 }
^{WSPACE}?`endprotect{WSPACE}?.*             {
  yylloc.last_column = strlen( yytext );
 }
^{WSPACE}?`nosuppress_faults{WSPACE}?.*      {
  yylloc.last_column = strlen( yytext );
 }
^{WSPACE}?`nounconnected_drive{WSPACE}?.*    {
  yylloc.last_column = strlen( yytext );
 }
^{WSPACE}?`protect{WSPACE}?.*                {
  yylloc.last_column = strlen( yytext );
 }
^{WSPACE}?`resetall{WSPACE}?.*               {
  yylloc.last_column = strlen( yytext );
 }
^{WSPACE}?`suppress_faults{WSPACE}?.*        {
  yylloc.last_column = strlen( yytext );
 }
^{WSPACE}?`unconnected_drive{WSPACE}?.*      {
  yylloc.last_column = strlen( yytext );
 }
^{WSPACE}?`uselib{WSPACE}?.*                 {
  yylloc.last_column = strlen( yytext );
 }

  /* Handle lines with errors */
<ERROR_LINE>.* {
  yy_pop_state();
 }

  /* Handle any characters in ignored space */
<IGNORE_GLOBALS,IGNORE_MODULE,IGNORE_ASSERT,IGNORE_PROPERTY,IGNORE_SEQUENCE>. {
  yylloc.last_column += 1;
  yymore();
 }

  /* Final catchall. something got lost or mishandled. */
. { fprintf( stderr, "%u: unmatched character (%c)\n", yylloc.first_line, yytext[0] ); }

%%

/*@=unreachable@*/

#ifndef GENERATOR

/*!
 Called at the start of UDP table parsing.
*/
void lex_start_udp_table() {

  BEGIN( UDPTABLE );

}

/*!
 Called at the end of UDP table parsing.
*/
void lex_end_udp_table() {

  BEGIN( INITIAL );

}

/*!
 Called at the start of time unit parsing.
*/
void lex_start_time_unit() {

  BEGIN( TIMEUNIT );

}

/*!
 Called at the end of time unit parsing.
*/
void lex_end_time_unit() {

  BEGIN( INITIAL );

}

/*!
 Called at the start of library_argument parsing.
*/
void lex_start_library_options() {

  BEGIN( LIBOPTIONS );

}

/*!
 Called at the end of library argument parsing.
*/
void lex_end_library_options() {

  BEGIN( INITIAL );

}

/*!
 Called at the start of import/export library parsing.
*/
void lex_start_import_export() {

  BEGIN( IMEXPORT );

}

/*!
 Called at the end of import/export library parsing.
*/
void lex_end_import_export() {

  BEGIN( INITIAL );

}

#endif

/*!
 Parses and handles a line directive that is in the CPP format.
*/
static void line_directive() {

  char* qt1;
  char* qt2;
  
  qt1 = strchr( yytext, '"');
  assert( qt1 );
  qt1 += 1;
  
  qt2 = strchr( qt1, '"' );
  assert( qt2 );
  
  directive_filename = (char*)realloc_safe( directive_filename, (strlen( directive_filename ) + 1), (qt2 - qt1 + 1) );
  strncpy( directive_filename, qt1, qt2-qt1 );
  directive_filename[qt2-qt1] = '\0';
  
  yylloc.orig_fname = directive_filename;
  
  qt2 += 1;
  yylloc.first_line = strtoul( qt2, 0, 0 );
  yylloc.last_line = yylloc.first_line;

}

/*!
 Parses and handles a line directive in the Verilog-2001 format.
*/
static void line_directive2() {

  char* cp;
  char* qt1;
  char* qt2;
  
  cp = yytext + strspn( yytext, "`line" );
  assert( *cp != 0 );
  cp += strspn( cp, " " );
  yylloc.first_line = strtoul( cp, &cp, 10 ) - 1;
  yylloc.last_line = yylloc.first_line;
  
  cp += strspn( cp, " " );
  if( *cp == 0 ) return;
  
  qt1 = strchr( yytext, '"' );
  assert( qt1 );
  qt1 += 1;
  
  qt2 = strchr( qt1, '"' );
  assert( qt2 );
  
  directive_filename = (char*)realloc_safe( directive_filename, (strlen( directive_filename ) + 1), (qt2 - qt1 + 1) );
  strncpy( directive_filename, qt1, qt2 - qt1 );
  directive_filename[qt2-qt1] = '\0';
  
  yylloc.orig_fname = directive_filename;

}

/*!
 Parses either the time unit or time precision token.
*/
static void process_timescale_token(
  char* token,  /*!< User-specified timescale token (either unit or precision information) */
  char* type,   /*!< String specifying timescale token type ("unit" or "precision") */
  int*  value,  /*!< Integer value to store shift information in */
  bool  report  /*!< If set to TRUE, calls VLerror with appropriate error information */
) {

  int  i      = 3;            /* Loop iterator */
  char msg[USER_MSG_LENGTH];  /* Error message container */

  while( (i > 0) && (strncmp( token, "100", i ) != 0) ) i--;

  if( i == 0 ) {
    if( report ) {
      unsigned int rv = snprintf( msg, USER_MSG_LENGTH, "Illegal time %s value specified (must be 1, 10 or 100)", type );
      assert( rv < USER_MSG_LENGTH );
      VLerror( msg );
    }
    Throw 0;
  } else {
    *value = i - 1;
    token += i;
    if(      strncmp(  "s", token, 1 ) == 0 ) { token += 1; }
    else if( strncmp( "ms", token, 2 ) == 0 ) { token += 2;  *value -= 3; }
    else if( strncmp( "us", token, 2 ) == 0 ) { token += 2;  *value -= 6; }
    else if( strncmp( "ns", token, 2 ) == 0 ) { token += 2;  *value -= 9; }
    else if( strncmp( "ps", token, 2 ) == 0 ) { token += 2;  *value -= 12; }
    else if( strncmp( "fs", token, 2 ) == 0 ) { token += 2;  *value -= 15; }
    else {
      if( report ) {
        unsigned int rv = snprintf( msg, USER_MSG_LENGTH, "Illegal time %s measurement specified (must be 's', 'ms', 'us', 'ns', 'ps' or 'fs')", type );
        assert( rv < USER_MSG_LENGTH );
        VLerror( msg );
      }
      Throw 0;
    }
    if( *token != '\0' ) {
      if( report ) {
        VLerror( "Illegal timescale directive specified" );
      }
      Throw 0;
    }
  }

}

#ifndef GENERATOR

/*!
 Processes a text string into timescale information.
*/
void process_timescale(
  const char* txt,    /*!< String containing timescale information */
  bool        report  /*!< If set to TRUE, reports any error information to the VLerror function */
) {

  char*        str;             /* String version of text minus spaces */
  unsigned int i;               /* Loop iterator */
  int          num_spaces = 0;  /* Number of spaces found in given string */
  int          unit = 0;        /* Time unit offset */
  int          prec = 0;        /* Time precision offset */

  /* Copy the given string */
  str = strdup_safe( txt );

  Try {

    /* Remove all spaces */
    for( i=0; i<(strlen( str )+1); i++ ) {
      if( (str[i] == ' ') || (str[i] == '\t') || (str[i] == '\n') || (str[i] == '\r') ) {
        num_spaces++;
      } else {
        str[i-num_spaces] = str[i];
      }
    }

    /* Get timescale tokens */
    i = strcspn( str, "/" );
    if( i == strlen( str ) ) {

      if( report ) {
        VLerror( "Timescale missing '/' character" );
      }
      Throw 0;

    } else {

      /* Process the time unit and precision tokens */
      str[i] = '\0';
      process_timescale_token( str, "unit", &unit, report );
      process_timescale_token( (str + i + 1), "precision", &prec, report );

    }
  
    /* Check to make sure that the unit setting is greater than the precision */
    if( unit < prec ) {
      if( report ) {
        VLerror( "Invalid timescale settings (unit must be greater than the precision)" );
      }
      Throw 0;
    }

    /* Handle the timescale with the database */
    db_set_timescale( unit, prec );
  
  } Catch_anonymous {
    free_safe( str, (strlen( txt ) + 1) );
    Throw 0;
  }

  /* Finally, deallocate memory */
  free_safe( str, (strlen( txt ) + 1) );

}

#endif

/*!
 \return Returns 0 if we should continue to parse or 1 if we should stop.

 The lexical analyzer calls this function when the current file
 ends.  Here I pop the include stack and resume the previous file.  If
 there is no previous file, then the main input is ended.
*/
static int yywrap() {

  int retval = 0;

#ifndef GENERATOR

  str_link*    curr;
  str_link*    tmpm;
  char*        fname = NULL;
  FILE*        out;
  tnode*       node;
  unsigned int rv;

  /* Close input file */
  if( yyin != 0 ) {
    rv = fclose( yyin );
    assert( rv == 0 );
  }

  /* Clear the file version information (if found) */
  free_safe( file_version, (strlen( file_version ) + 1) );
  file_version = NULL;

  /* Delete the current buffer */
  yy_delete_buffer( YY_CURRENT_BUFFER );

  /*
   If we have no more modules to find in our module list, then remove the
   temporary preprocessor file, deallocate the found_modules tree and
   stop parsing.
  */
  if( modlist_head == NULL ) {
    rv = unlink( ppfilename );
    assert( rv == 0 );
    tree_dealloc( found_modules );
    return( 1 );
  }
  
  /* If there was an error found during parsing, stop now */
  if( error_count > 0 ) {
    return( 1 );
  }

  curr = filelist_curr;
  tmpm = modlist_head;

  while( (tmpm != NULL) && (fname == NULL) ) {
    if( (node = tree_find( tmpm->str, found_modules )) != NULL ) {
      fname = node->value;
      file_prev_parsed = TRUE;
    } else {
      if( (curr = get_next_vfile( curr, tmpm->str )) == NULL ) {
        tmpm = tmpm->next;
        curr = filelist_curr;
      } else {
        fname            = curr->str;
        file_prev_parsed = curr->suppl2;
      }
    }
  }

  /* If the rest of the modules could not be found, display them to the user */
  if( (modlist_head != NULL) && (tmpm == NULL) ) {
    print_output( "Unable to find the following modules:", FATAL, __FILE__, __LINE__ );
    curr = modlist_head;
    while( curr != NULL ) {
      unsigned int rv = snprintf( user_msg, USER_MSG_LENGTH, "%s", obf_funit( curr->str ) );
      assert( rv < USER_MSG_LENGTH );
      print_output( user_msg, FATAL_WRAP, __FILE__, __LINE__ );
      curr = curr->next;
    }
    rv = unlink( ppfilename );
    assert( rv == 0 );
    tree_dealloc( found_modules );
    Throw 0;
  }

  /* Create temporary output filename */
  out = fopen( ppfilename, "w" );
  assert( out != NULL );

  Try {

    /* Now run the preprocessor on this file first */
    reset_pplexer( fname, out );
    (void)PPVLlex();

  } Catch_anonymous {
    rv = fclose( out );
    assert( rv == 0 );
    Throw 0;
  }

  rv = fclose( out );
  assert( rv == 0 );

  yyin = fopen( ppfilename, "r" );
  yyrestart( yyin );

  yylloc.first_line  = 1;
  yylloc.ppfline     = 1;
  yylloc.pplline     = 1;
  yylloc.last_line   = 1;
  yylloc.last_column = 0;
  yylloc.orig_fname  = fname;
  yylloc.incl_fname  = fname;

  filelist_curr = curr->next;

  /* If the current file was previously parsed, set the start state to IGNORE_GLOBALS */
  if( file_prev_parsed ) {
    BEGIN( IGNORE_GLOBALS );
  } else {
    BEGIN( PARSE );
  }

#else

  retval = 1;

#endif

  return( retval );

}

#ifndef GENERATOR

/*!
 This function initializes the whole process. The first file is
 opened, and the lexer is initialized.  The include stack is cleared
 and ready to go.
*/
void reset_lexer(
  str_link* file_list_head  /*!< Pointer to list of files to process */
) {

  FILE*        out;
  str_link*    curr = file_list_head;
  unsigned int rv;

  if( (curr = get_next_vfile( curr, modlist_head->str )) == NULL ) {
    print_output( "No verilog files specified", FATAL, __FILE__, __LINE__ );
    Throw 0;
  }

  assert( curr->str != NULL );
  
  /* Create temporary output filename */
  if( ppfilename == NULL ) {
    unsigned int rv;
    ppfilename = (char*)malloc_safe( 10 );
    rv = snprintf( ppfilename, 10, "tmpXXXXXX" );
    assert( rv < 10 );
    assert( mkstemp( ppfilename ) != 0 );
  }
  out = fopen( ppfilename, "w" );
  if( out == NULL ) {
    unsigned int rv = snprintf( user_msg, USER_MSG_LENGTH, "Unable to open temporary file %s for writing", ppfilename );
    assert( rv < USER_MSG_LENGTH );
    print_output( user_msg, FATAL, __FILE__, __LINE__ );
    Throw 0;
  }
  
  Try {

    /* Now run the preprocessor on this file first */
    reset_pplexer( curr->str, out );
    (void)PPVLlex();

  } Catch_anonymous {
    rv = fclose( out );
    assert( rv == 0 );
    Throw 0;
  }
  
  rv = fclose( out );
  assert( rv == 0 );

  /* Clear the exclude_mode */
  exclude_mode = 0;

  yyin = fopen( ppfilename, "r" );
  yyrestart( yyin );

  yylloc.orig_fname  = curr->str;
  yylloc.incl_fname  = curr->str;
  yylloc.first_line  = 1;
  yylloc.ppfline     = 1;
  yylloc.pplline     = 1;
  yylloc.last_line   = 1;
  yylloc.last_column = 0;
  
  filelist_head = file_list_head;
  filelist_curr = file_list_head->next;
  file_prev_parsed = FALSE;

  /* Set start state to allow parsing */
  BEGIN( PARSE );

}

#else

/*!
 This function initializes the whole process. The first file is
 opened, and the lexer is initialized.  The include stack is cleared
 and ready to go.
*/
void reset_lexer_for_generation(
  char*       in_fname,  /*!< Name of file to read */
  const char* out_dir    /*!< Output directory name */
) {

  FILE*        out;
  unsigned int rv;
  unsigned int slen;
  char*        ofname;

  /* Create temporary output filename */
  slen   = strlen( out_dir ) + 11;
  ofname = (char*)malloc_safe( slen );
  rv     = snprintf( ofname, slen, "%s/tmpXXXXXX", out_dir );
  assert( rv < slen );
  assert( mkstemp( ofname ) != 0 );
  if( (out = fopen( ofname, "w" )) == NULL ) {
    unsigned int rv = snprintf( user_msg, USER_MSG_LENGTH, "Unable to open temporary file %s for writing", ofname );
    assert( rv < USER_MSG_LENGTH );
    print_output( user_msg, FATAL, __FILE__, __LINE__ );
    Throw 0;
  }
  
  Try {

    /* Now run the preprocessor on this file first */
    reset_pplexer( in_fname, out );
    (void)PPVLlex();

  } Catch_anonymous {
    rv = fclose( out );
    assert( rv == 0 );
    Throw 0;
  }
  
  rv = fclose( out );
  assert( rv == 0 );

  /* Clear the exclude_mode */
  exclude_mode = 0;

  yyin = fopen( ofname, "r" );
  free_safe( ofname, slen );
  yyrestart( yyin );

  yylloc.orig_fname  = in_fname;
  yylloc.incl_fname  = in_fname;
  yylloc.first_line  = 1;
  yylloc.ppfline     = 1;
  yylloc.pplline     = 1;
  yylloc.last_line   = 1;
  yylloc.last_column = 0;
  
  /* Set start state to allow parsing */
  BEGIN( PARSE );

}

#endif

/*!
 Checks the comment for pragma information in the given comment block and takes
 the appropriate action.
*/
static void check_for_pragma(
  char* comment  /*!< User-provided comment taken from a comment block */
) {

  if( comment != NULL ) {

    char* keyword = strdup_safe( comment );
    char* value   = strdup_safe( comment );
    char* ptr;
    int   str_len = strlen( comment ) + 1;

    /* Get the keyword and value if this comment is a pragma */
    if( sscanf( comment, "%s %s", keyword, value ) == 2 ) {

      /* If the keyword matches the given pragma keyword, check the value */
      if( (info_suppl.part.excl_pragma == 1) && (strcmp( keyword, pragma_coverage_name ) == 0) ) {

        /* Set the exclude_mode as specified by the user */
        if( strcmp( value, "on" ) == 0 ) {

          /* Don't allow exclude_mode to wrap */
          if( exclude_mode > 0 ) {
            exclude_mode--;
          }

        } else if( strcmp( value, "off" ) == 0 ) {
          exclude_mode++;
        }
 
      }

      /* If the keyword matches the given race condition check pragma keyword, check the value */
      if( (pragma_racecheck_name != NULL) && (strcmp( keyword, pragma_racecheck_name ) == 0) ) {

        if( strcmp( value, "on" ) == 0 ) {

          if( ignore_racecheck_mode > 0 ) {
            ignore_racecheck_mode--;
          }

        } else if( strcmp( value, "off" ) == 0 ) {
          ignore_racecheck_mode++;
        }

      }

    }

    /* Attempt to check to see if we have an rcs version string */
    if( (ptr = strstr( comment, "$Id:" )) != NULL ) {
      
      /* If the $Id string was found, extract the version information before the next $ (removing leading whitespace) */
      if( sscanf( (ptr + 4), "%[^$]", value ) == 1 ) {

        /* Remove trailing whitespace */
        ptr = value + (strlen( value ) - 1);
        while( (ptr >= value) && ((*ptr == ' ') || (*ptr == '\t') || (*ptr == '\n') || (*ptr == '\r') || (*ptr == '\b')) ) {
          *ptr = '\0';
          ptr--;
        }

        /* Save the file version information in the database */
        if( value[0] != '\0' ) {
          db_add_file_version( yylloc.orig_fname, value );
        }

      }

    }

    /* Deallocate memory */
    free_safe( keyword, str_len );
    free_safe( value, str_len );

  }

}

