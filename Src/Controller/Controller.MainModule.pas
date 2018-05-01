unit Controller.MainModule;

interface

uses
  uniGUIMainModule, SysUtils, Classes, UniGUIVars, View.ServerModule,
  uniGUIApplication, View.MainModule;

type
  TControllerMainModule = class
  strict private
    FView: TMainModule;
    procedure Init;
    procedure UniGUIMainModuleCreate(Sender: TObject);
    procedure UniGUIMainModuleDestroy(Sender: TObject);
  public
    constructor Create(Aview: TMainModule);
  end;

  TMainModuleHelper = class(TMainModule)
  public
    constructor Create(Aowner: TComponent; AUniApplication: TComponent); override;
  end;

implementation

{ TMainModuleHelper }

constructor TMainModuleHelper.Create(Aowner, AUniApplication: TComponent);
begin
  inherited;
  TControllerMainModule.Create(Self);
end;

{ TControllerMainModule }

constructor TControllerMainModule.Create(Aview: TMainModule);
begin
  inherited Create;
  FView := Aview;
  Init;
end;

procedure TControllerMainModule.Init;
begin
  FView.OnCreate := Self.UniGUIMainModuleCreate;
  FView.OnDestroy := Self.UniGUIMainModuleDestroy;
end;

procedure TControllerMainModule.UniGUIMainModuleCreate(Sender: TObject);
begin
  FView.Theme := 'gray';
end;

procedure TControllerMainModule.UniGUIMainModuleDestroy(Sender: TObject);
begin
  Free;
end;

initialization
  RegisterMainModuleClass(TMainModuleHelper);
end.
