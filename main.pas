unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IntervalArithmetic32and64, NewtRaph,
  Vcl.ExtCtrls;

type
  TOkno = class(TForm)
    Przelicz: TButton;
    testEdit: TEdit;
    DLLGroup: TGroupBox;
    ArytmetykaGroup: TRadioGroup;
    Nazwa: TLabel;
    NazwaEdit: TEdit;
    fLabel: TLabel;
    fEdit: TEdit;
    dfLabel: TLabel;
    dfEdit: TEdit;
    d2fLabel: TLabel;
    d2fEdit: TEdit;
    DaneGroup: TGroupBox;
    x0Label: TLabel;
    x0Edit: TEdit;
    mitLabel: TLabel;
    mitEdit: TEdit;
    epsLabel: TLabel;
    epsEdit: TEdit;
    RozwiπzanieGroup: TGroupBox;
    RozwEdit: TEdit;
    FloatRadio: TRadioButton;
    IntRadio: TRadioButton;
    procedure PrzeliczClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Okno: TOkno;
  DLL : THandle;
  f, df, d2f: function(x : Extended) : Extended;
  fInt, dfInt, d2fInt: function(x : interval) : interval;
  test : function(x : interval) : interval;
  blah : procedure(var x : Integer);

implementation

{$R *.dfm}


procedure TOkno.PrzeliczClick(Sender: TObject);
var
  n : Integer;
  x, eps, fatx : Extended;
  mit, it, st : Integer;
  intvl : interval;
begin
  DLL := LoadLibrary('funkcjeInt.dll'); // za≥adowanie pliku
  try
//    @f := GetProcAddress(DLL, PWideChar(fEdit.Text));  // pobranie wskaünika do procedury
//    @df := GetProcAddress(DLL, PWideChar(dfEdit.Text));
//    @d2f := GetProcAddress(DLL, PWideChar(d2fEdit.Text));
//    @test := GetProcAddress(DLL, 'test');  // pobranie wskaünika do procedury
//    @blah := GetProcAddress(DLL, 'blah');

    @fInt := GetProcAddress(DLL, PWideChar(fEdit.Text));  // pobranie wskaünika do procedury
    @dfInt := GetProcAddress(DLL, PWideChar(dfEdit.Text));
    @d2fInt := GetProcAddress(DLL, PWideChar(d2fEdit.Text));
    @test := GetProcAddress(DLL, 'test');  // pobranie wskaünika do procedury

    if @test = nil then raise Exception.Create('Nie moøna za≥adowaÊ procedury');

    x :=  StrToFloat(x0Edit.Text);
    mit := StrToInt(mitEdit.Text);
    eps := StrToFloat(epsEdit.Text);
//    RozwEdit.Text := FloatToStr(NewtonRaphson (x, f, df, d2f, mit, eps, fatx, it, st));
    intvl.a := 1.32;
    intvl.b := 3.243;
    testEdit.Text := intervalToString(d2fInt(int_read('2.44')));
  finally
    FreeLibrary(DLL);
  end;
end;

end.
