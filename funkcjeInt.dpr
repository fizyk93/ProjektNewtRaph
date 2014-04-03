library funkcjeInt;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  System.SysUtils,
  System.Classes,
  Windows,
  IntervalArithmetic32and64 in 'IntervalArithmetic32and64.pas';

{$R *.res}

function f(x : interval) : interval;
var z : interval;
begin
  MessageBox(0, 'Hello World!', 'Hello', MB_OK + MB_ICONINFORMATION);
//  z :=x*x;
//  f := z*(z-5)+4;
  z := imul(x,x);
  f := imul(z,iadd(isub(z,int_read('5')),int_read('4')));
end;

function df(x : interval) : interval;
begin
//  df := 4*x*(x*x-2.5);
  df := imul(int_read('4'),(imul(x,isub(imul(x,x),int_read('2,5')))));
end;

function d2f(x : interval) : interval;
begin
//  d2f := 12*x*x-10;
  d2f := isub(imul(int_read('12'),imul(x,x)),int_read('10'));
end;


function test(x : interval) : interval;
begin
  MessageBox(0, 'Hello World!', 'Hello', MB_OK + MB_ICONINFORMATION);
//  x := 666;
//  test := int_read('4.34');
  test := imul(x,iadd(isub(x,int_read('5')),int_read('4')));
end;


exports
  f name 'f',
  df name 'df',
  d2f name 'd2f',
  test name 'test';

begin
end.
