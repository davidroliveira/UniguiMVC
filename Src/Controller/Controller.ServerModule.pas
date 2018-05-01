unit Controller.ServerModule;

interface

uses
  Forms, Classes, SysUtils, uniGUIServer, uniGUIMainModule, uniGUIApplication,
  uIdCustomHTTPServer, uniGUITypes, UniGUIVars, View.ServerModule;

type
  EInstanciaServerModuleError = class(Exception);

  TControllerServerModule = class
  strict private
    FView: TServerModule;
    class var FInstancia: TControllerServerModule;
    constructor CreatePrivate;
    procedure Init;
    procedure UniGUIServerModuleDestroy(Sender: TObject);
  public
    constructor Create;
    class function GetInstancia: TControllerServerModule;
  end;

  TServerModuleHelper = class(TServerModule)
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

{ TControllerServerModule }

constructor TControllerServerModule.Create;
begin
  raise EInstanciaServerModuleError.CreateResFmt(@MsgInstanciaServerModuleError, [Self.ClassName]);
end;

constructor TControllerServerModule.CreatePrivate;
begin
  inherited Create;
  Init;
end;

class function TControllerServerModule.GetInstancia: TControllerServerModule;
begin
  if not Assigned(FInstancia) then
    FInstancia := TControllerServerModule.CreatePrivate;
  Result := FInstancia;
end;

procedure TControllerServerModule.Init;
begin
  FView := TServerModuleHelper.Create(Application);
  FView.OnDestroy := Self.UniGUIServerModuleDestroy;
end;

procedure TControllerServerModule.UniGUIServerModuleDestroy(Sender: TObject);
begin
  Free;
end;

initialization
  RegisterServerModuleClass(TServerModuleHelper);
end.
