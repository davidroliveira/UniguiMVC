program UniguiMVC;

uses
  Forms,
  View.ServerModule in 'View\View.ServerModule.pas' {ServerModule: TUniGUIServerModule},
  View.MainModule in 'View\View.MainModule.pas' {MainModule: TUniGUIMainModule},
  View.BaseForm in 'View\View.BaseForm.pas' {BaseForm: TUniForm},
  View.Main in 'View\View.Main.pas' {Main},
  Controller.ServerModule in 'Controller\Controller.ServerModule.pas',
  Controller.MainModule in 'Controller\Controller.MainModule.pas',
  Controller.Main in 'Controller\Controller.Main.pas',
  Dao.Atributo in 'Dao\Dao.Atributo.pas',
  Dao.Persistencia in 'Dao\Dao.Persistencia.pas',
  Dao.DB in 'Dao\Dao.DB.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  TControllerServerModule.GetInstancia;
  Application.Run;
end.
