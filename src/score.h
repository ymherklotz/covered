#ifndef __SCORE_H__
#define __SCORE_H__

/*!
 \file     score.h
 \author   Trevor Williams  (trevorw@charter.net)
 \date     11/29/2001
 \brief    Contains functions for score command.
*/

//! Parses score command-line and performs score.
int command_score( int argc, int last_arg, char** argv );

/*
 $Log$
 Revision 1.4  2002/07/20 21:34:58  phase1geo
 Separating ability to parse design and score dumpfile.  Now both or either
 can be done (allowing one to parse once and score multiple times).
*/

#endif

