%{
    /* ===============================
     * Standard headers
     * =============================== */
    #include <cstdio>
    #include <iostream>
    #include <string>
    #include <vector>

    /* ===============================
     * Project headers
     * =============================== */
    #include "common.h"
    #include "live_set.hpp"
    #include "y.tab.hpp"

    using std::string;
    using std::cout;
    using std::endl;

    /* ===============================
     * Lexer / Parser interface
     * =============================== */
    extern FILE *yyin;
    extern int yylex();
    void yyerror(string msg);

    /* ===============================
     * Global analysis state
     * =============================== */

    /* Live variable set used for dead-code elimination */
    Live_Set g_liveSet;

    /* Current source line index */
    int g_lineNumber = 1;

    /* At most two RHS source operands */
    string g_rhsSources[2];

    /* Reconstructed source line for output */
    string g_currentLine;

    /* ===============================
     * Debug helper
     * =============================== */
    void dumpLiveSet()
    {
    #ifdef DEBUG
        DPRINT("Live Set:\n");
        for (const auto &var : g_liveSet.getSet())
            DPRINT(var << " ");
        DPRINT("\n----------------\n");
    #endif
    }
%}

%union {
    int    num;
    char * str;
}

/* ===============================
 * Tokens
 * =============================== */
%token PLUSOP MINUSOP MULTOP DIVOP POWEROP
%token EQOP OSB CSB SEMICOLON COMMA
%token<num> INTEGER
%token<str> VARIABLE

/* ===============================
 * Non-terminal types
 * =============================== */
%type<str> source
%type<str> assign_lhs

%%

/* ===============================
 * Grammar rules
 * =============================== */

program:
    { DPRINT("Initializing live set\n"); }
    init_live_set
    { dumpLiveSet(); }
    statement_list
    ;

statement_list:
    statement SEMICOLON statement_list
    |
    statement SEMICOLON
    ;

statement:
    assign_lhs assign_eq assign_rhs
    {
        string lhsVar = string($1);

        if (g_liveSet.is_exist(lhsVar)) {
            /* Variable is live: remove definition and add RHS sources */
            g_liveSet.remove_var(lhsVar);
            DPRINT("remove " << lhsVar << endl);

            for (const auto &src : g_rhsSources)
                if (!src.empty())
                    g_liveSet.push_new_var(src);
                else
                    DPRINT("source is null\n");

            cout << g_currentLine << endl;
        } else {
            /* Dead assignment */
            DPRINT("dead code detected\n");
        }

        DPRINT("line " << g_lineNumber << endl);
    #ifdef DEBUG
        dumpLiveSet();
    #endif
        g_lineNumber++;
        g_currentLine.clear();
    }
    ;

assign_lhs:
    VARIABLE { g_currentLine += string($1); }
    ;

assign_eq:
    EQOP { g_currentLine += "="; }
    ;

assign_rhs:
      source
      {
          g_rhsSources[0] = string($1);
          g_rhsSources[1].clear();
      }
    | source arithmetic_op source
      {
          g_rhsSources[0] = string($1);
          g_rhsSources[1] = string($3);
      }
    ;

source:
        INTEGER
        {
            $$ = strdup("");
            g_currentLine += std::to_string($1);
        }
    | VARIABLE
        {
            $$ = $1;
            g_currentLine += string($1);
        }
    ;

arithmetic_op:
      PLUSOP  { g_currentLine += "+"; }
    | MINUSOP { g_currentLine += "-"; }
    | MULTOP  { g_currentLine += "*"; }
    | DIVOP   { g_currentLine += "/"; }
    | POWEROP { g_currentLine += "^"; }
    ;

init_live_set:
    OSB variable_list CSB
    |
    OSB CSB
    ;

variable_list:
    VARIABLE { g_liveSet.push_new_var(string($1)); } COMMA variable_list  
    |
    VARIABLE { g_liveSet.push_new_var(string($1)); }
    ;

%%

/* ===============================
 * Error handling
 * =============================== */
void yyerror(string msg)
{
    cout << "error: " << msg << endl;
}

int yywrap()
{
    return 1;
}

/* ===============================
 * Entry point
 * =============================== */
int main(int argc, char *argv[])
{
    g_rhsSources[0].clear();
    g_rhsSources[1].clear();
    g_currentLine.clear();

    if (argc < 1) {
        cout << "usage: " << argv[0] << " <input_file> " << argc << endl;
        return -1;
    }

    yyin = fopen(argv[1], "r");
    yyparse();
    fclose(yyin);

    return 0;
}
