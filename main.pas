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
    Rozwi¹zanieGroup: TGroupBox;
    RozwEdit: TEdit;
    FloatRadio: TRadioButton;
    IntRadio: TRadioButton;
    OdpLabel: TLabel;
    SzerLabel: TLabel;
    SzerEdit: TEdit;
    x0Edit2: TEdit;
    ZaladujDLL: TButton;
    fatxEdit: TEdit;
    fatxLabel: TLabel;
    itEdit: TEdit;
    itLabel: TLabel;
    procedure PrzeliczClick(Sender: TObject);
    procedure IntRadioClick(Sender: TObject);
    procedure FloatRadioClick(Sender: TObject);
    procedure ZaladujDLLClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  ELoadLibrary = class(Exception);
  ELoadDLLFunction = class(Exception);

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
  //x0Edit.Width := 136;
  Przelicz.Enabled := false;
end;

procedure TOkno.IntRadioClick(Sender: TObject);
begin
  NazwaEdit.Text := 'funkcjeInt.dll';
  x0Edit2.Visible := true;
  //x0Edit.Width := 68;
  Przelicz.Enabled := false;
end;

procedure TOkno.PrzeliczClick(Sender: TObject);
var
  n : Integer;
  xInt, fatxInt : interval;
  x, fatx, eps : Extended;
  mit, it, st : Integer;
  intvl : interval;
  ans : interval;
  err : Integer;
  tmp, left, right : string;
begin

  SzerEdit.Text := '';

    if FloatRadio.checked then
    begin

      Val(x0Edit.Text, x, err);
      Val(mitEdit.Text, mit, err);
      Val(epsEdit.Text, eps, err);

      try

        Str(NewtonRaphson (x, f, df, d2f, mit, eps, fatx, it, st):26, tmp);
        RozwEdit.Text := tmp;
        Str(fatx:25, tmp);
        fatxEdit.Text := tmp;
        itEdit.Text := IntToStr(it);

      except
         MessageBox(0, PWideChar('Podano niepoprawne dane!' + sLineBreak + 'Numer b³êdu: st = ' + IntToStr(st)), 'B³¹d', MB_OK + MB_ICONINFORMATION);
      end;

    end
    else
    begin
      if x0Edit2.Text = '' then xInt :=  int_read(x0Edit.Text)
      else
      begin
        xInt.a :=  left_read(x0Edit.Text);
        xInt.b := right_read(x0Edit2.Text);
      end;
      mit := StrToInt(mitEdit.Text);
      eps := StrToFloat(epsEdit.Text);
      try
        ans := NewtonRaphsonInterval(xInt, fInt, dfInt, d2fInt, mit, eps, fatxInt, it, st);
        iends_to_strings(ans, left, right);
        //ShowMessage(IntToStr(it));
        RozwEdit.Text := '(' + left + ';' + right + ')';
        Str(int_width(ans):25, tmp);
        SzerEdit.Text := tmp;
        Str(fatxInt.a:25, tmp);
        fatxEdit.Text := '(' + tmp + ';';
        Str(fatxInt.b:25, tmp);
        fatxEdit.Text := fatxEdit.Text + tmp + ')';
        itEdit.Text := IntToStr(it);

      except
        MessageBox(0, PWideChar('Podano niepoprawne dane!' + sLineBreak + 'Numer b³êdu: st = ' + IntToStr(st)), 'B³¹d', MB_OK + MB_ICONINFORMATION);
      end;
    end;
    if st = 3 then raise Exception.Create('Nie uda³o siê osi¹gn¹æ zadanej dok³adnoœci w podanej liczbie iteracji!');
end;

procedure TOkno.ZaladujDLLClick(Sender: TObject);
begin
  try
    if DLL > 0 then FreeLibrary(DLL);
    DLL := LoadLibrary(PChar(NazwaEdit.text)); // za³adowanie pliku
    if DLL = 0 then raise ELoadLibrary.Create('B³¹d wczytywania biblioteki DLL');
    Przelicz.Enabled := true;

    if FloatRadio.checked then
    begin
      @f := GetProcAddress(DLL, PWideChar(fEdit.Text));  // pobranie wskaŸnika do procedury
      if @f = nil then raise ELoadDLLFunction.Create('Nie mo¿na za³adowaæ procedury: ' + PWideChar(fEdit.Text));
      @df := GetProcAddress(DLL, PWideChar(dfEdit.Text));
      if @df = nil then raise ELoadDLLFunction.Create('Nie mo¿na za³adowaæ procedury: ' + PWideChar(dfEdit.Text));
      @d2f := GetProcAddress(DLL, PWideChar(d2fEdit.Text));
      if @d2f = nil then raise ELoadDLLFunction.Create('Nie mo¿na za³adowaæ procedury: ' + PWideChar(d2fEdit.Text));
      @test := GetProcAddress(DLL, 'test');  // pobranie wskaŸnika do procedury
      @blah := GetProcAddress(DLL, 'blah');

    end
    else
    begin
      @fInt := GetProcAddress(DLL, PWideChar(fEdit.Text));  // pobranie wskaŸnika do procedury
      @dfInt := GetProcAddress(DLL, PWideChar(dfEdit.Text));
      @d2fInt := GetProcAddress(DLL, PWideChar(d2fEdit.Text));
      @test := GetProcAddress(DLL, 'test');  // pobranie wskaŸnika do procedury

      if @test = nil then raise Exception.Create('Nie mo¿na za³adowaæ procedury');
    end;
  except
      on E: ELoadLibrary do
      begin
        Przelicz.Enabled := false;
        MessageBox(0, PWideChar('B³¹d ³adowania biblioteki DLL: ' + NazwaEdit.text), 'B³¹d', MB_OK + MB_ICONINFORMATION);
      end;

      on E: ELoadDLLFunction do MessageBox(0, PWideChar(E.Message), 'B³¹d', MB_OK + MB_ICONINFORMATION);
  end;
end;

end.
