%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex();
int yyparse();
void yyerror(char *s);
void intToNumeral(int x, char* numeral);
%}

// declare tokens
%token I II III IV V VI VII VIII IX X XX XXX XL L LX LXX LXXX XC C CC CCC CD D DC DCC DCCC CM M
%token ADD SUB DIV MUL OP CP
%token EOL

%%

calclist:
    | calclist expr EOL { char numeral[50]; intToNumeral($2, numeral); printf("%s\n", numeral); }
;

expr: factor
 |expr ADD factor {$$ = $1 + $3; }
 |expr SUB factor {$$ = $1 - $3; }
;


factor: parenthesis
 |factor MUL parenthesis {$$ = $1 * $3; }
 |factor DIV parenthesis {$$ = $1 / $3; }
 ;


 parenthesis: val
 |OP expr CP {$$ = $2; }
 ;


val: numeral
 | val numeral {
                 if ($1 + $2 > 1000 & $1 < 1000) { yyerror("syntax error\n"); }
                 if ($1 != $2 || ($1 >= 1000 && $2 >= 1000))
                 {
                    $$ = $1 + $2;
                 }
                 else
                 {
                    yyerror("syntax error");
                 }
                }

;


numeral: I { $$ = $1; }
 | II { $$ = $1; }
 | III { $$ = $1; }
 | IV { $$ = $1; }
 | V { $$ = $1; }
 | VI { $$ = $1; }
 | VII { $$ = $1; }
 | VIII { $$ = $1; }
 | IX { $$ = $1; }
 | X { $$ = $1; }
 | XX { $$ = $1; }
 | XXX { $$ = $1; }
 | XL { $$ = $1; }
 | L { $$ = $1; }
 | LX { $$ = $1; }
 | LXX { $$ = $1; }
 | LXXX { $$ = $1; }
 | XC { $$ = $1; }
 | C { $$ = $1; }
 | CC { $$ = $1; }
 | CCC { $$ = $1; }
 | CD { $$ = $1; }
 | D { $$ = $1; }
 | DC { $$ = $1; }
 | DCC { $$ = $1; }
 | DCCC { $$ = $1; }
 | CM { $$ = $1; }
 | M { $$ = $1; }
;


%%

void intToNumeral(int x,char* numeral ){
    if(x == 0){
        *numeral++ ='Z';
        return;
    }
    if(x < 0){
        *numeral++ ='-';
        x *= -1; 
    }
    char *hundreds[] = {"", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"};
	char *tens[] = {"", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"};
	char *units[] = {"", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"};
	int   size[] = { 0, 1, 2, 3, 2, 1, 2, 3, 4, 2};
	while (x >= 1000) {
		*numeral++ = 'M';
		x -= 1000;
	}
	strcpy (numeral, hundreds[x/100]); numeral += size[x/100]; x = x % 100;
	strcpy (numeral, tens[x/10]);  numeral += size[x/10];  x = x % 10;
	strcpy (numeral, units[x]);     numeral += size[x];
	*numeral++ = '\0';
}

int main()
{
  yyparse();
  return 0;
}

void yyerror(char *s)
{
  printf("%s\n", s);
  exit(0);
}