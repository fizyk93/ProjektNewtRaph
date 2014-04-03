program ProjektNewtRaph;

uses
  Vcl.Forms,
  main in 'main.pas' {Okno},
  IntervalArithmetic32and64 in 'IntervalArithmetic32and64.pas',
  uTExtendedX87 in 'uTExtendedX87.pas',
  NewtRaph in 'NewtRaph.pas',
  NewtRaphInterval in 'NewtRaphInterval.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TOkno, Okno);
  Application.Run;
end.
