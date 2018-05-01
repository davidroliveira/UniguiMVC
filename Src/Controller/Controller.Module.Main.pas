unit Controller.Module.Main;

interface

uses
  uniGUIMainModule, SysUtils, Classes, UniGUIVars, View.Module.Server,
  uniGUIApplication, View.Module.Main;

type
  TControllerModuleMain = class
  strict private
    FView: TModuleMain;
    procedure Init;
    procedure UniGUIMainModuleCreate(Sender: TObject);
    procedure UniGUIMainModuleDestroy(Sender: TObject);
  public
    constructor Create(Aview: TModuleMain);
  end;

  TModuleMainHelper = class(TModuleMain)
  public
    constructor Create(Aowner: TComponent; AUniApplication: TComponent); override;
  end;

implementation

{ TModuleMainHelper }

constructor TModuleMainHelper.Create(Aowner, AUniApplication: TComponent);
begin
  inherited;
  TControllerModuleMain.Create(Self);
end;

{ TControllerModuleMain }

constructor TControllerModuleMain.Create(Aview: TModuleMain);
begin
  inherited Create;
  FView := Aview;
  Init;
end;

procedure TControllerModuleMain.Init;
begin
  FView.OnCreate := Self.UniGUIMainModuleCreate;
  FView.OnDestroy := Self.UniGUIMainModuleDestroy;
end;

procedure TControllerModuleMain.UniGUIMainModuleCreate(Sender: TObject);
begin
  FView.Theme := 'gray';
end;

procedure TControllerModuleMain.UniGUIMainModuleDestroy(Sender: TObject);
begin
  Free;
end;

initialization
  RegisterMainModuleClass(TModuleMainHelper);
end.
