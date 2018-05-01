unit Controller.Main.Form;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniGUIBaseClasses,
  uniGUIApplication, uniGUIVars, View.Main.Form;

type
  TControllerMainForm = class
  strict private
    FView: TMainForm;
    procedure Init;
    procedure UniFormDestroy(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
  public
    constructor Create(Aview: TMainForm);
    procedure UniButton1Click(Sender: TObject);
  end;

  TMainFormHelper = class(TMainForm)
  private
    FController: TControllerMainForm;
  public
    constructor Create(Aowner: TComponent); override;
  end;

implementation

{ TMainFormHelper }

constructor TMainFormHelper.Create(Aowner: TComponent);
begin
  inherited;
  if not Assigned(FController) then
    FController := TControllerMainForm.Create(Self);
end;

{ TControllerMainForm }

constructor TControllerMainForm.Create(Aview: TMainForm);
begin
  inherited Create;
  FView := Aview;
  Init;
end;

procedure TControllerMainForm.Init;
begin
  FView.OnCreate := UniFormCreate;
  FView.UniButton1.OnClick := Self.UniButton1Click;
  FView.OnDestroy := Self.UniFormDestroy;
end;

procedure TControllerMainForm.UniButton1Click(Sender: TObject);
begin
  FView.ShowMessage(FView.UniEdit1.Text);
end;

procedure TControllerMainForm.UniFormCreate(Sender: TObject);
begin
  FView.UniEdit1.Text := 'Controller!';
end;

procedure TControllerMainForm.UniFormDestroy(Sender: TObject);
begin
  Free;
end;

initialization
  RegisterAppFormClass(TMainFormHelper);
end.
