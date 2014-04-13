unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IntervalArithmetic32and64, NewtRaph, NewtRaphInterval,
  Vcl.ExtCtrls;

type
  TOkno = class(TForm)
    Przelicz: TButton;
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
    Rozwi�zanieGroup: TGroupBox;
    RozwEdit: TEdit;
    FloatRadio: TRadioButton;
    IntRadio: TRadioButton;
    OdpLabel: TLabel;
    SzerLabel: TLabel;
    SzerEdit: TEdit;
    x0Edit2: TEdit;
    procedure PrzeliczClick(Sender: TObject);
    procedure IntRadioClick(Sender: TObject);
    procedure FloatRadioClick(Sender: TObject);
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


procedure TOkno.FloatRadioClick(Sender: TObject);
begin
  NazwaEdit.Text := 'funkcje.dll';
  x0Edit2.Visible := false;
  x0Edit.Width := 136;
end;

procedure TOkno.IntRadioClick(Sender: TObject);
begin
  NazwaEdit.Text := 'funkcjeInt.dll';
  x0Edit2.Visible := true;
  x0Edit.Width := 68;
end;

procedure TOkno.PrzeliczClick(Sender: TObject);
var
  n : Integer;
  xInt, fatxInt : interval;
  x, fatx, eps : Extended;
  mit, it, st : Integer;
  intvl : interval;
  ans : interval;
begin
  DLL := LoadLibrary(PChar(NazwaEdit.text)); // za�adowanie pliku
  SzerEdit.Text := '';
  try

    if FloatRadio.checked then
    begin
      @f := GetProcAddress(DLL, PWideChar(fEdit.Text));  // pobranie wska�nika do procedury
      @df := GetProcAddress(DLL, PWideChar(dfEdit.Text));
      @d2f := GetProcAddress(DLL, PWideChar(d2fEdit.Text));
      @test := GetProcAddress(DLL, 'test');  // pobranie wska�nika do procedury
      @blah := GetProcAddress(DLL, 'blah');

      x :=  StrToFloat(x0Edit.Text);
      mit := StrToInt(mitEdit.Text);
      eps := StrToFloat(epsEdit.Text);
      try
        RozwEdit.Text := FloatToStr(NewtonRaphson (x, f, df, d2f, mit, eps, fatx, it, st));
      except
         MessageBox(0, 'Podano niepoprawne dane!', 'B��d', MB_OK + MB_ICONINFORMATION);
      end;

    end
    else
    begin
      @fInt := GetProcAddress(DLL, PWideChar(fEdit.Text));  // pobranie wska�nika do procedury
      @dfInt := GetProcAddress(DLL, PWideChar(dfEdit.Text));
      @d2fInt := GetProcAddress(DLL, PWideChar(d2fEdit.Text));
      @test := GetProcAddress(DLL, 'test');  // pobranie wska�nika do procedury

      if @test = nil then raise Exception.Create('Nie mo�na za�adowa� procedury');

      if x0Edit2.Text = '' then xInt :=  int_read(x0Edit.Text)
      else
      begin
        xInt.a :=  int_read(x0Edit.Text).a;
        xInt.b := int_read(x0Edit2.Text).b;
      end;
      mit := StrToInt(mitEdit.Text);
      eps := StrToFloat(epsEdit.Text);
      try
        ans := NewtonRaphsonInterval(xInt, fInt, dfInt, d2fInt, mit, eps, fatxInt, it, st);
        RozwEdit.Text := intervalToString(ans);
        SzerEdit.Text := FloatToStr(int_width(ans));
      except
        MessageBox(0, 'Podano niepoprawne dane!', 'B��d', MB_OK + MB_ICONINFORMATION);
      end;


    end;
  finally
    FreeLibrary(DLL);
  end;
end;

end.
