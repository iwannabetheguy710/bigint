# BigInt: A light-weight big integer library utility
## Language suport
* #### Pascal (simply supported compare, +, -, *, /, mod)
```pas
program test;
uses crt, bigint;

var a, b: string;

begin
  clrscr;

  readln(a);
  readln(b);

  writeln('a + b = ', bigadd(a, b)); { + }
  writeln('a - b = ', bigsub(a, b)); { - }
  writeln('a * b = ', bigmul(a, b)); { * }
  writeln('a / b = ', bigdiv(a, b)); { / }
  writeln('a % b = ', bigmod(a, b)); { mod }

  readkey;
end.
```
