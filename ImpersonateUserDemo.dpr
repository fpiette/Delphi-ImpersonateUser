program ImpersonateUserDemo;

uses
  Vcl.Forms,
  ImpersonateUserDemoMain in 'ImpersonateUserDemoMain.pas' {ImpersonateUserMainForm},
  ImpersonateUser in 'ImpersonateUser.pas',
  ImpersonateFileStream in 'ImpersonateFileStream.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TImpersonateUserMainForm, ImpersonateUserMainForm);
  Application.Run;
end.
