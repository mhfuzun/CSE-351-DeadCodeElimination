/* ===============================
 * Character classes
 * =============================== */
digit   [0-9]
letter  [A-Za-z]

%{
    /* ===============================
     * Standard headers
     * =============================== */
    #include <cstdio>
    #include <cstdlib>
    #include <cstring>
    #include <string>

    /* ===============================
     * Parser interface
     * =============================== */
    #include "y.tab.hpp"

    using std::string;

    /* ===============================
     * Lexer state
     * =============================== */
    int g_lineCount = 0;
%}

%option noyywrap

%%

"+"     { return PLUSOP; }
"-"     { return MINUSOP; }
"*"     { return MULTOP; }
"/"     { return DIVOP; }
"^"     { return POWEROP; }
"="     { return EQOP; }

"{"     { return OSB; }
"}"     { return CSB; }
";"     { return SEMICOLON; }
","     { return COMMA; }

{digit}+ {
    yylval.num = atoi(yytext);
    return INTEGER;
}

{letter}({letter}|{digit})* {
    yylval.str = strdup(yytext);
    return VARIABLE;
}

\n {
    g_lineCount++;
}

. { /* intentionally ignored */ }

%%
