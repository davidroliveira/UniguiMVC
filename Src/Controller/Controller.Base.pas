unit Controller.Base;

interface

uses
  Classes, Controls, System.Rtti, Vcl.Forms, Dialogs,
  Dao.Persistencia, Dao.DB, View.Base.Ficha, View.Base.Lista;

type
  TControllerBase<FrmLista: TBaseLista; FrmFicha: TBaseFicha; Persistencia: TPersistencia> = class
  strict private
    FViewFicha: FrmFicha;
    FModel: Persistencia;
    FViewLista: FrmLista;
  protected
    property ViewLista: FrmLista read FViewLista write FViewLista;
    property ViewFicha: FrmFicha read FViewFicha write FViewFicha;
    property Model: Persistencia read FModel write FModel;
    procedure AlimentaView; virtual; abstract;
    procedure AlimentaModel; virtual; abstract;
  public
    constructor Create(Filter: string = ''); virtual;
  end;

implementation



{ TControllerBase<FrmLista, FrmFicha, Persistencia> }

constructor TControllerBase<FrmLista, FrmFicha, Persistencia>.Create(Filter: string);
var
  Contexto: TRttiContext;
begin
  FModel := Contexto.GetType(TClass(Persistencia)).GetMethod('Create').Invoke(TClass(Persistencia), []).AsType<Persistencia>;

end;

end.
