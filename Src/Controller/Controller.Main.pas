unit Controller.Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniGUIBaseClasses,
  uniGUIApplication, uniGUIVars, View.Main;

type
  TControllerMain = class
  strict private
    FView: TMain;
    procedure Init;
    procedure UniFormDestroy(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
  public
    constructor Create(Aview: TMain);
    procedure UniButton1Click(Sender: TObject);
  end;

  TMainHelper = class(TMain)
  private
    FController: TControllerMain;
  public
    constructor Create(Aowner: TComponent); override;
  end;

implementation

{ TMainHelper }

constructor TMainHelper.Create(Aowner: TComponent);
begin
  inherited;
  if not Assigned(FController) then
    FController := TControllerMain.Create(Self);
end;

{ TControllerMain }

constructor TControllerMain.Create(Aview: TMain);
begin
  inherited Create;
  FView := Aview;
  Init;
end;

procedure TControllerMain.Init;
begin
  FView.OnCreate := UniFormCreate;
  FView.UniButton1.OnClick := Self.UniButton1Click;
  FView.OnDestroy := Self.UniFormDestroy;
end;

procedure TControllerMain.UniButton1Click(Sender: TObject);
begin
  FView.ShowMessage(FView.UniEdit1.Text);
end;

procedure TControllerMain.UniFormCreate(Sender: TObject);
begin
  FView.UniEdit1.Text := 'Controller!';
end;

procedure TControllerMain.UniFormDestroy(Sender: TObject);
begin
  Free;
end;

initialization
  RegisterAppFormClass(TMainHelper);
end.
