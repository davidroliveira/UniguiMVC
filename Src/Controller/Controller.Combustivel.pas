unit Controller.Combustivel;

interface

uses
  System.SysUtils, System.Variants,
  Controller.Base, View.Base.Lista, View.Base.Ficha, Dao.Persistencia,
  Model.Combustivel, View.Combustivel.Lista, View.Combustivel.Ficha;

type
  TControllerCombustivel = class(TControllerBase<TViewCombustivelLista,TViewCombustivelFicha,TCombustivel>)
  public
    procedure AlimentaView; override;
    procedure AlimentaModel; override;
  end;

implementation

{ TControllerCombustivel }

procedure TControllerCombustivel.AlimentaModel;
begin
  inherited;

end;

procedure TControllerCombustivel.AlimentaView;
begin
  inherited;

end;

end.
