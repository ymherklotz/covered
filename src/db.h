#ifndef __DB_H__
#define __DB_H__

/*!
 \file     db.h
 \author   Trevor Williams  (trevorw@charter.net)
 \date     12/7/2001
 \brief    Contains functions for writing and reading contents of
           covered database file.
*/

#include "defines.h"

//! Writes contents of expressions, modules and signals to database file.
bool db_write( char* file, bool parse_mode );

//! Reads contents of database file and stores into internal lists.
bool db_read( char* file, int read_mode );

//! Adds specified module node to module tree.  Called by parser.
void db_add_instance( char* scope, char* modname );

//! Adds specified module to module list.  Called by parser.
void db_add_module( char* name, char* file );

//! Adds specified declared parameter to parameter list.  Called by parser.
void db_add_declared_param( char* name, expression* expr );

//! Adds specified override parameter to parameter list.  Called by parser.
void db_add_override_param( char* inst_name, expression* expr );

//! Adds specified defparam to parameter override list.  Called by parser.
void db_add_defparam( char* name, expression* expr );

//! Adds specified signal to signal list.  Called by parser.
void db_add_signal( char* name, int width, int lsb );

//! Finds specified signal in module and returns pointer to the signal structure.  Called by parser.
signal* db_find_signal( char* name );

//! Creates new expression from specified information.  Called by parser and db_add_expression.
expression* db_create_expression( expression* right, expression* left, int op, int line, char* sig_name );

//! Adds specified expression to expression list.  Called by parser.
void db_add_expression( expression* root );

//! Creates new statement expression from specified information.  Called by parser.
statement* db_create_statement( expression* exp );

//! Adds specified statement to current module's statement list.  Called by parser.
void db_add_statement( statement* stmt );

//! Connects one statement block to another.
void db_statement_connect( statement* curr_stmt, statement* next_stmt );

//! Sets STMT_STOP bit in the appropriate statements.
void db_statement_set_stop( statement* stmt, statement* post, bool both );

//! Connects true statement to specified statement.
void db_connect_statement_true( statement* stmt, statement* exp_true );

//! Connects false statement to specified statement.
void db_connect_statement_false( statement* stmt, statement* exp_false );

//! Sets current VCD scope to specified scope.
void db_set_vcd_scope( char* scope );

//! Adds symbol to signal specified by name.
void db_assign_symbol( char* name, char* symbol );

//! Sets the found symbol value to specified character value.  Called by VCD lexer.
void db_set_symbol_char( char* sym, char value );

//! Sets the found symbol value to specified string value.  Called by VCD lexer.
void db_set_symbol_string( char* sym, char* value );

//! Performs a timestep for all signal changes during this timestep.
void db_do_timestep( int time ); 

/* $Log$
/* Revision 1.16  2002/09/23 01:37:44  phase1geo
/* Need to make some changes to the inst_parm structure and some associated
/* functionality for efficiency purposes.  This checkin contains most of the
/* changes to the parser (with the exception of signal sizing).
/*
/* Revision 1.15  2002/09/21 07:03:28  phase1geo
/* Attached all parameter functions into db.c.  Just need to finish getting
/* parser to correctly add override parameters.  Once this is complete, phase 3
/* can start and will include regenerating expressions and signals before
/* getting output to CDD file.
/*
/* Revision 1.14  2002/09/19 05:25:19  phase1geo
/* Fixing incorrect simulation of static values and fixing reports generated
/* from these static expressions.  Also includes some modifications for parameters
/* though these changes are not useful at this point.
/*/* Revision 1.13  2002/08/26 12:57:03  phase1geo/* In the middle of adding parameter support.  Intermediate checkin but does/* not break regressions at this point./*/* Revision 1.12  2002/08/23 12:55:33  phase1geo/* Starting to make modifications for parameter support.  Added parameter source/* and header files, changed vector_from_string function to be more verbose/* and updated Makefiles for new param.h/.c files./*/* Revision 1.11  2002/07/22 05:24:46  phase1geo/* Creating new VCD parser.  This should have performance benefits as well as/* have the ability to handle any problems that come up in parsing./*/* Revision 1.10  2002/07/05 16:49:47  phase1geo/* Modified a lot of code this go around.  Fixed VCD reader to handle changes in/* the reverse order (last changes are stored instead of first for timestamp)./* Fixed problem with AEDGE operator to handle vector value changes correctly./* Added casez2.v diagnostic to verify proper handling of casez with '?' characters./* Full regression passes; however, the recent changes seem to have impacted/* performance -- need to look into this./*/* Revision 1.9  2002/07/03 21:30:52  phase1geo/* Fixed remaining issues with always statements.  Full regression is running/* error free at this point.  Regenerated documentation.  Added EOR expression/* operation to handle the or expression in event lists./*/* Revision 1.8  2002/07/01 15:10:42  phase1geo/* Fixing always loopbacks and setting stop bits correctly.  All verilog diagnostics/* seem to be passing with these fixes./*/* Revision 1.7  2002/06/27 12:36:47  phase1geo/* Fixing bugs with scoring.  I think I got it this time./*/* Revision 1.6  2002/06/24 12:34:56  phase1geo/* Fixing the set of the STMT_HEAD and STMT_STOP bits.  We are getting close./*/* Revision 1.5  2002/06/24 04:54:48  phase1geo/* More fixes and code additions to make statements work properly.  Still not/* there at this point./*/* Revision 1.4  2002/05/13 03:02:58  phase1geo/* Adding lines back to expressions and removing them from statements (since the line/* number range of an expression can be calculated by looking at the expression line/* numbers)./*/* Revision 1.3  2002/05/03 03:39:36  phase1geo/* Removing all syntax errors due to addition of statements.  Added more statement/* support code.  Still have a ways to go before we can try anything.  Removed lines/* from expressions though we may want to consider putting these back for reporting/* purposes./*/* Revision 1.2  2002/04/30 05:04:25  phase1geo/* Added initial go-round of adding statement handling to parser.  Added simple/* Verilog test to check correct statement handling.  At this point there is a/* bug in the expression write function (we need to display statement trees in/* the proper order since they are unlike normal expression trees.)/* */

#endif

