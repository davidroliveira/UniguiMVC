program UniguiMVC;

uses
  Forms,
  View.Module.Server in 'View\View.Module.Server.pas' {ModuleServer: TUniGUIServerModule},
  View.Module.Main in 'View\View.Module.Main.pas' {ModuleMain: TUniGUIMainModule},
  View.Base.Form in 'View\View.Base.Form.pas' {BaseForm: TUniForm},
  View.Main.Form in 'View\View.Main.Form.pas' {MainForm},
  Controller.Module.Server in 'Controller\Controller.Module.Server.pas',
  Controller.Module.Main in 'Controller\Controller.Module.Main.pas',
  Controller.Main.Form in 'Controller\Controller.Main.Form.pas',
  Dao.Atributo in 'Dao\Dao.Atributo.pas',
  Dao.Persistencia in 'Dao\Dao.Persistencia.pas',
  Dao.DB in 'Dao\Dao.DB.pas',
  View.Base.Lista in 'View\View.Base.Lista.pas' {BaseLista: TUniForm},
  View.Base.Ficha in 'View\View.Base.Ficha.pas' {BaseFicha: TUniForm},
  View.Combustivel.Lista in 'View\View.Combustivel.Lista.pas' {ViewCombustivelLista: TUniForm},
  Model.Combustivel in 'Model\Model.Combustivel.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  TControllerModuleServer.GetInstancia;
  Application.Run;
end.
