unit Controller.Module.Server;

interface

uses
  Forms, Classes, SysUtils, uniGUIServer, uniGUIMainModule, uniGUIApplication,
  uIdCustomHTTPServer, uniGUITypes, UniGUIVars, View.Module.Server;

type
  EInstanciaModuleServerError = class(Exception);

  TControllerModuleServer = class
  strict private
    FView: TModuleServer;
    class var FInstancia: TControllerModuleServer;
    constructor CreatePrivate;
    procedure Init;
    procedure UniGUIServerModuleDestroy(Sender: TObject);
  public
    constructor Create;
    class function GetInstancia: TControllerModuleServer;
  end;

  TServerModuleHelper = class(TModuleServer)
  protected
    procedure FirstInit; override;
  end;

implementation

resourcestring
  MsgInstanciaServerModuleError = 'Apenas uma instância da classe %s permitida';

{ TServerModuleHelper }

procedure TServerModuleHelper.FirstInit;
begin
  inherited;
  InitServerModule(Self);
end;

{ TControllerModuleServer }

constructor TControllerModuleServer.Create;
begin
  raise EInstanciaModuleServerError.CreateResFmt(@MsgInstanciaServerModuleError, [Self.ClassName]);
end;

constructor TControllerModuleServer.CreatePrivate;
begin
  inherited Create;
  Init;
end;

class function TControllerModuleServer.GetInstancia: TControllerModuleServer;
begin
  if not Assigned(FInstancia) then
    FInstancia := TControllerModuleServer.CreatePrivate;
  Result := FInstancia;
end;

procedure TControllerModuleServer.Init;
begin
  FView := TServerModuleHelper.Create(Application);
  FView.OnDestroy := Self.UniGUIServerModuleDestroy;
end;

procedure TControllerModuleServer.UniGUIServerModuleDestroy(Sender: TObject);
begin
  Free;
end;

initialization
  RegisterServerModuleClass(TServerModuleHelper);
end.
