#ifndef __RACE_H__
#define __RACE_H__

/*!
 \file     race.h
 \author   Trevor Williams  (trevorw@charter.net)
 \date     12/15/2004
 \brief    Contains functions used to check for race conditions and proper signal use
           within the specified design.
*/

#include "defines.h"


/*! \brief Parses entire statement tree pointed to by stmt, adding all found signals within it to the stmt_sig list */
void race_find_and_add_stmt_sigs( statement* stmt, statement* root );

/*! \brief Deallocates specified stmt_sig structure from memory */
void race_stmt_sig_dealloc( stmt_sig* ss );


/*
 $Log$
 Revision 1.1  2004/12/16 13:52:58  phase1geo
 Starting to add support for race-condition detection and handling.

*/

#endif

