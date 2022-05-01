unit bigint;

interface

{ compare two bigstring }
function bigcompare(a, b: string): integer;

{ add two bigstring }
function bigadd(a, b: string): string;

{ sub two bigstring }
function bigsub(a, b: string): string;

{ core version of bigmul by multiply a bigstring with a longint }
function bigmul_(a: string; b: longint): string;

{ multiply two bigstring }
function bigmul(a, b: string): string; { multiply two bigstring }

{ core version of bigdiv by divide a bigstring with a longint }
function bigdiv_(a: string; b: longint): string;

{ divide two bigstring }
function bigdiv(a, b: string): string;

{ core version of bigmod by modulus a bigstring with a longint }
function bigmod_(a: string; b: longint): longint;

{ modulus two bigstring }
function bigmod(a, b: string): string;

implementation

function bigcompare(a, b: string): integer;
begin
  while length(a) < length(b) do a := '0' + a;
  while length(a) > length(b) do b := '0' + b;
  if a = b then exit(0);
  if a > b then exit(1);
  exit(-1);
end;

function bigadd(a, b: string): string;
var sum, carry, i, x, y, signa, signb, cr: integer;
    c: string;
begin
  signa := 1; signb := 1;
  if a[1] = '-' then begin
    signa := -1;
    delete(a, 1, 1);
  end;
  if b[1] = '-' then begin
    signb := -1;
    delete(b, 1, 1);
  end;
  if signa <> signb then begin
    cr := bigcompare(a, b);
    if cr = 0 then exit('0');
    if cr = -1 then begin
      if signb = -1 then exit('-' + bigsub(b, a))
      else exit(bigsub(b, a));
    end;
    if cr = 1 then exit('-' + bigsub(a, b));
  end;
  carry := 0; c := '';
  while length(a) < length(b) do a := '0' + a;
  while length(a) > length(b) do b := '0' + b;
  for i := length(a) downto 1 do begin
    x := ord(a[i]) - 48;
    y := ord(b[i]) - 48;
    sum := x + y + carry;
    carry := sum div 10;
    c := chr(sum mod 10 + 48) + c;
  end;
  if carry > 0 then c := '1' + c;
  if (signa = -1) and (signb = -1) then c := '-' + c;
  bigadd := c;
end;

function bigsub(a, b: string): string;
var c: string;
    s, bor, i, signa, signb, cr: integer;
begin
  signa := 1; signb := 1;
  if a[1] = '-' then begin
    signa := -1;
    delete(a, 1, 1);
  end;
  if b[1] = '-' then begin
    signb := -1;
    delete(b, 1, 1);
  end;
  if signa <> signb then begin
    if signa = -1 then exit('-' + bigadd(a, b));
    if signb = -1 then exit(bigadd(a, b));
  end
  else if (signa = -1) and (signb = -1) then exit(bigsub(b, a));
  cr := bigcompare(a, b);
  if cr = -1 then exit('-' + bigsub(b, a));
  bor := 0; c := '';
  while length(a) < length(b) do a := '0' + a;
  while length(a) > length(b) do b := '0' + b;
  for i := length(a) downto 1 do begin
    s := ord(a[i]) - ord(b[i]) - bor;
    if s < 0 then begin
      inc(s, 10);
      bor := 1;
    end
    else bor := 0;
    c := chr(s + 48) + c;
  end;
  while (length(c) > 1) and (c[1] = '0') do delete(c, 1, 1);
  bigsub := c;
end;

{ core version of bigmul by multiply a bigstring with a longint }
function bigmul_(a: string; b: longint): string;
var i, signa, signb: integer;
    car, s: longint;
    c, tmp: string;
begin
  signa := 1; signb := 1;
  if b < 0 then begin
    signb := -1;
    b := b * -1;
  end;
  if a[1] = '-' then begin
    signa := -1;
    delete(a, 1, 1);
  end;
  c := '';
  car := 0;
  for i := length(a) downto 1 do begin
    s := (ord(a[i]) - 48) * b + car;
    car := s div 10;
    c := chr(s mod 10 + 48) + c;
  end;
  if car > 0 then str(car, tmp) else tmp := '';
  tmp := tmp + c;
  if signa <> signb then tmp := '-' + tmp;
  bigmul_ := tmp;
end;

function bigmul(a, b: string): string;
var sum, tmp: string;
    m, i, j, signa, signb: integer;
begin
  signa := 1; signb := 1;
  if a[1] = '-' then begin
    signa := -1;
    delete(a, 1, 1);
  end;
  if b[1] = '-' then begin
    signb := -1;
    delete(b, 1, 1);
  end;
  m := -1; sum := '';
  for i := length(a) downto 1 do begin
    inc(m);
    tmp := bigmul_(b, ord(a[i]) - 48);
    for j := 1 to m do tmp := tmp + '0';
    sum := bigadd(tmp, sum);
  end;
  if signa <> signb then sum := '-' + sum;
  bigmul := sum;
end;

{ core version of bigdiv by divide a bigstring with a longint }
function bigdiv_(a: string; b: longint): string;
var s, i, hold: longint;
    c: string;
    signa, signb: integer;
begin
  signa := 1; signb := 1;
  if a[1] = '-' then begin
    signa := -1;
    delete(a, 1, 1);
  end;
  if b < 0 then begin
    signb := -1;
    b := b * -1;
  end;
  hold := 0; s := 0; c := '';
  for i := 1 to length(a) do begin
    hold := hold * 10 + ord(a[i]) - 48;
    s := hold div b;
    hold := hold mod b;
    c := c + chr(s + 48);
  end;
  while (length(c) > 1) and (c[1] = '0') do delete(c, 1, 1);
  if signa <> signb then c := '-' + c;
  bigdiv_ := c;
end;

function bigdiv(a, b: string): string;
var c, hold: string;
    kb: array[0..10] of string;
    i, k: longint;
    signa, signb: integer;
begin
  if a[1] = '-' then begin
    signa := -1;
    delete(a, 1, 1);
  end;
  if b[1] = '-' then begin
    signb := -1;
    delete(b, 1, 1);
  end;
  kb[0] := '0';
  for i := 1 to 10 do
    kb[i] := bigadd(kb[i - 1], b);
  hold := '';
  c := '';
  for i := 1 to length(a) do begin
    hold := hold + a[i];
    k := 1;
    while bigcompare(hold, kb[k]) <> -1 do inc(k);
    c := c + chr(k - 1 + 48);
    hold := bigsub(hold, kb[k - 1]);
  end;
  while (length(c) > 1) and (c[1] = '0') do delete(c, 1, 1);
  if signa <> signb then c := '-' + c;
  bigdiv := c;
end;

{ core version of bigmod by modulus a bigstring with a longint }
function bigmod_(a: string; b: longint): longint;
var i, hold: longint;
begin
  hold := 0;
  for i := 1 to length(a) do
    hold := (ord(a[i]) - 48 + hold * 10) mod b;
  bigmod_ := hold;
end;

function bigmod(a, b: string): string;
var hold: string;
    kb: array[0..10] of string;
    i, k: longint;
begin
  kb[0] := '0';
  for i := 1 to 10 do
    kb[i] := bigadd(kb[i - 1], b);
  hold := '';
  for i := 1 to length(a) do begin
    hold := hold + a[i];
    k := 1;
    while bigcompare(hold, kb[k]) <> -1 do inc(k);
    hold := bigsub(hold, kb[k - 1]);
  end;
  bigmod := hold;
end;

end.
