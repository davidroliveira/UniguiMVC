unit Dao.Persistencia;

interface

uses
  Rtti, StrUtils, System.Variants, Classes, System.SysUtils, Vcl.Forms,
  System.TypInfo, Data.DB,

  Dao.DB, Dao.Atributo,

  FireDAC.Comp.Client, FireDAC.VCLUI.Wait, FireDAC.DApt;

type
  TPersistencia = class
  strict private
    FSQL: string;
    function GetNomedaTabela: string;
    function GetCampoChavePrimaria: string;
  public
    property SQL: string read FSQL write FSQL;
    property NomedaTabela: string read GetNomedaTabela;
    property NomeCampoChavePrimaria: string read GetCampoChavePrimaria;

    function Inserir: Boolean; virtual;
    function Alterar: Boolean; virtual;
    function Excluir: Boolean; virtual;

    function Carregar(const AValor: Int64): Boolean; overload; virtual; abstract;
    function Carregar: Boolean; overload;

  end;

implementation

function TPersistencia.Alterar: Boolean;
var
  AContexto: TRttiContext;
  ATipo: TRttiType;
  APropriedade: TRttiProperty;
  AAtributo: TCustomAttribute;
  ANomeTabela, ACampo, ASql, AWhere: string;
  Parametros, ParametrosPK: array of TParametroQuery;
  Parametro, ParametroPK: TParametroQuery;
  QueryTmp: TFDQuery;
begin
  Result := False;
  ACampo := NullAsStringValue;
  setLength(Parametros,0);
  setLength(ParametrosPK,0);
  AContexto := TRttiContext.Create;
  try
    ATipo := AContexto.GetType(ClassType);
    for AAtributo in ATipo.GetAttributes do
    begin
      if AAtributo is Tabela then
      begin
        ANomeTabela := Tabela(AAtributo).Nome;
        Break;
      end;
    end;
    for APropriedade in ATipo.GetProperties do
    begin
      for AAtributo in APropriedade.GetAttributes do
      begin
        if AAtributo is Campo then
        begin
          ACampo := ACampo + '       ' + Campo(AAtributo).Nome + ',' + sLineBreak;
          if APropriedade.GetValue(Self).AsVariant <> Null then
          begin
            if (Campo(AAtributo).ChavePrimaria) then
            begin
              SetLength(ParametrosPK, Length(ParametrosPK)+1);
              ParametrosPK[high(ParametrosPK)].Name := Campo(AAtributo).Nome;
              ParametrosPK[high(ParametrosPK)].Value := APropriedade.GetValue(Self).AsVariant;
            end
            else
            begin
              SetLength(Parametros, Length(Parametros)+1);
              Parametros[high(Parametros)].Name := Campo(AAtributo).Nome;
              Parametros[high(Parametros)].Value := APropriedade.GetValue(Self).AsVariant;
            end;
          end
        end;
      end;
    end;
    AWhere := NullAsStringValue;
    for ParametroPK in ParametrosPK do
    begin
      if AWhere = NullAsStringValue then
        AWhere := AWhere + 'WHERE '
      else
        AWhere := AWhere + '  AND ';
      AWhere := AWhere + '(' + ParametroPK.Name + ' = :' + ParametroPK.Name + ')';
    end;
      
    ACampo := Trim(ACampo);
    ACampo := Copy(ACampo, 1, ACampo.Length - 1);
    ASql :=
      'SELECT ' + ACampo + sLineBreak +
      '  FROM ' + ANomeTabela + sLineBreak +
      ' ' + AWhere;
    QueryTmp := TConexao.GetInstancia.CriaQuery(ASql, ParametrosPK);
    try
      QueryTmp.Edit;
      for Parametro in Parametros do
      begin
        if VarToStrDef(Parametro.Value,NullAsStringValue) = NullAsStringValue then
          QueryTmp.FieldByName(Parametro.Name).Clear
        else if QueryTmp.FieldByName(Parametro.Name) is TBlobField then
          raise Exception.Create('Implementar Persistencia TBlobField')
          //TBlobField(QueryTmp.FieldByName(Parametro.Name)).LoadFromStream(Parametro.Value)
        else
          QueryTmp.FieldByName(Parametro.Name).Value := Parametro.Value;
      end;
      QueryTmp.Post;
      for APropriedade in ATipo.GetProperties do
      begin
        for AAtributo in APropriedade.GetAttributes do
        begin
          if (AAtributo is Campo) then
            APropriedade.SetValue(Self, Tvalue.FromVariant(QueryTmp.FieldByName(Campo(AAtributo).Nome).Value));
        end;
      end;
      QueryTmp.Close;
      Result := True;
    finally
      FreeAndNil(QueryTmp);
    end;
  finally
    AContexto.Free;
  end;
end;

function TPersistencia.Carregar: Boolean;
var
  AContexto: TRttiContext;
  ATipo: TRttiType;
  APropriedade: TRttiProperty;
  AAtributo: TCustomAttribute;
  ANomeTabela, AWhere, ACampo, ASql: string;
  ParametrosPK: array of TParametroQuery;
  ParametroPK: TParametroQuery;
  QueryTmp: TFDQuery;
begin
  Result := False;
  setLength(ParametrosPK,0);
  AContexto := TRttiContext.Create;
  try
    ATipo := AContexto.GetType(ClassType);
    for AAtributo in ATipo.GetAttributes do
    begin
      if AAtributo is Tabela then
      begin
        ANomeTabela := Tabela(AAtributo).Nome;
        Break;
      end;
    end;
    for APropriedade in ATipo.GetProperties do
    begin
      for AAtributo in APropriedade.GetAttributes do
      begin
        if AAtributo is Campo then
        begin
          ACampo := ACampo + '       ' + Campo(AAtributo).Nome + ',' + sLineBreak;
          if APropriedade.GetValue(Self).AsVariant <> Null then
          begin
            if (Campo(AAtributo).ChavePrimaria) then
            begin
              SetLength(ParametrosPK, Length(ParametrosPK)+1);
              ParametrosPK[high(ParametrosPK)].Name := Campo(AAtributo).Nome;
              ParametrosPK[high(ParametrosPK)].Value := APropriedade.GetValue(Self).AsVariant;
            end
          end
        end;
      end;
    end;
    AWhere := NullAsStringValue;
    for ParametroPK in ParametrosPK do
    begin
      if AWhere = NullAsStringValue then
        AWhere := AWhere + 'WHERE '
      else
        AWhere := AWhere + '  AND ';
      AWhere := AWhere + '(' + ParametroPK.Name + ' = :' + ParametroPK.Name + ')';
    end;

    ACampo := Trim(ACampo);
    ACampo := Copy(ACampo, 1, ACampo.Length - 1);
    ASql :=
      'SELECT ' + ACampo + sLineBreak +
      '  FROM ' + ANomeTabela + sLineBreak +
      ' ' + AWhere;
    QueryTmp := TConexao.GetInstancia.CriaQuery(ASql, ParametrosPK);
    try
      for APropriedade in ATipo.GetProperties do
      begin
        for AAtributo in APropriedade.GetAttributes do
        begin
          if (AAtributo is Campo) then
            APropriedade.SetValue(Self, Tvalue.FromVariant(QueryTmp.FieldByName(Campo(AAtributo).Nome).Value));
        end;
      end;
      QueryTmp.Close;
      Result := True;
    finally
      FreeAndNil(QueryTmp);
    end;
  finally
    QueryTmp.Free;
    AContexto.Free;
  end;
end;

function TPersistencia.Excluir: Boolean;
var
  AContexto: TRttiContext;
  ATipo: TRttiType;
  APropriedade: TRttiProperty;
  AAtributo: TCustomAttribute;
  ANomeTabela, ACampo, AWhere, ASql: string;
  ParametrosPK: array of TParametroQuery;
  ParametroPK: TParametroQuery;
  QueryTmp: TFDQuery;
begin
  Result := False;
  setLength(ParametrosPK,0);
  AContexto := TRttiContext.Create;
  try
    ATipo := AContexto.GetType(ClassType);

    for AAtributo in ATipo.GetAttributes do
    begin
      if AAtributo is Tabela then
      begin
        ANomeTabela := Tabela(AAtributo).Nome;
        Break;
      end;
    end;
    for APropriedade in ATipo.GetProperties do
    begin
      for AAtributo in APropriedade.GetAttributes do
      begin
        if AAtributo is Campo then
        begin
          if APropriedade.GetValue(Self).AsVariant <> Null then
          begin
            if (Campo(AAtributo).ChavePrimaria) then
            begin
              ACampo := ACampo + '       ' + Campo(AAtributo).Nome + ',' + sLineBreak;
              SetLength(ParametrosPK, Length(ParametrosPK)+1);
              ParametrosPK[high(ParametrosPK)].Name := Campo(AAtributo).Nome;
              ParametrosPK[high(ParametrosPK)].Value := APropriedade.GetValue(Self).AsVariant;
            end
          end
        end;
      end;
    end;
    AWhere := NullAsStringValue;
    for ParametroPK in ParametrosPK do
    begin
      if AWhere = NullAsStringValue then
        AWhere := AWhere + 'WHERE '
      else
        AWhere := AWhere + '  AND ';
      AWhere := AWhere + '(' + ParametroPK.Name + ' = :' + ParametroPK.Name + ')';
    end;

    ACampo := Trim(ACampo);
    ACampo := Copy(ACampo, 1, ACampo.Length - 1);
    ASql :=
      'SELECT ' + ACampo + sLineBreak +
      '  FROM ' + ANomeTabela + sLineBreak +
      ' ' + AWhere;
    QueryTmp := TConexao.GetInstancia.CriaQuery(ASql, ParametrosPK);
    try
      QueryTmp.Delete;
      for APropriedade in ATipo.GetProperties do
      begin
        for AAtributo in APropriedade.GetAttributes do
        begin
          if (AAtributo is Campo) then
            APropriedade.SetValue(Self, Tvalue.FromVariant(Null));
        end;
      end;
      QueryTmp.Close;
      Result := True;
    finally
      FreeAndNil(QueryTmp);
    end;
  finally
    AContexto.Free;
  end;
end;

function TPersistencia.GetCampoChavePrimaria: string;
var
  AContexto: TRttiContext;
  ATipo: TRttiType;
  APropriedade: TRttiProperty;
  AAtributo: TCustomAttribute;
begin
  Result := NullAsStringValue;
  AContexto := TRttiContext.Create;
  try
    ATipo := AContexto.GetType(ClassType);
    for APropriedade in ATipo.GetProperties do
    begin
      for AAtributo in APropriedade.GetAttributes do
      begin
        if AAtributo is Campo then
        begin
          if Campo(AAtributo).ChavePrimaria then
            Result := Campo(AAtributo).Nome;
        end;
      end;
    end;
  finally
    AContexto.Free;
  end;
end;

function TPersistencia.GetNomedaTabela: string;
var
  AContexto: TRttiContext;
  ATipo: TRttiType;
  AAtributo: TCustomAttribute;
begin
  Result := NullAsStringValue;
  AContexto := TRttiContext.Create;
  try
    ATipo := AContexto.GetType(ClassType);
    for AAtributo in ATipo.GetAttributes do
    begin
      if AAtributo is Tabela then
        Result := Tabela(AAtributo).Nome;
    end;
  finally
    AContexto.Free;
  end;
end;

function TPersistencia.Inserir: Boolean;
var
  AContexto: TRttiContext;
  ATipo: TRttiType;
  APropriedade: TRttiProperty;
  AAtributo: TCustomAttribute;
  ANomeTabela, ACampo, ASql: string;
  Parametros: array of TParametroQuery;
  Parametro: TParametroQuery;
  QueryTmp: TFDQuery;
begin
  Result := False;
  ACampo := NullAsStringValue;
  setLength(Parametros,0);
  AContexto := TRttiContext.Create;
  try
    ATipo := AContexto.GetType(ClassType);
    for AAtributo in ATipo.GetAttributes do
    begin
      if AAtributo is Tabela then
      begin
        ANomeTabela := Tabela(AAtributo).Nome;
        Break;
      end;
    end;
    for APropriedade in ATipo.GetProperties do
    begin
      for AAtributo in APropriedade.GetAttributes do
      begin
        if AAtributo is Campo then
        begin
          ACampo := ACampo + '       ' + Campo(AAtributo).Nome + ',' + sLineBreak;
          if APropriedade.GetValue(Self).AsVariant <> Null then
          begin
            if not (Campo(AAtributo).ChavePrimaria) then
            begin
              SetLength(Parametros, Length(Parametros)+1);
              Parametros[high(Parametros)].Name := Campo(AAtributo).Nome;
              Parametros[high(Parametros)].Value := APropriedade.GetValue(Self).AsVariant;
            end;
          end
        end;
      end;
    end;

    ACampo := Trim(ACampo);
    ACampo := Copy(ACampo, 1, ACampo.Length - 1);
    ASql :=
      'SELECT ' + ACampo + sLineBreak +
      '  FROM ' + ANomeTabela + sLineBreak +
      ' WHERE 1=2';
    QueryTmp := TConexao.GetInstancia.CriaQuery(ASql, []);
    try
      QueryTmp.Insert;
      for Parametro in Parametros do
      begin
        if VarToStrDef(Parametro.Value,NullAsStringValue) = NullAsStringValue then
          QueryTmp.FieldByName(Parametro.Name).Clear
        else if QueryTmp.FieldByName(Parametro.Name) is TBlobField then
          raise Exception.Create('Implementar Persistencia TBlobField')
          //TBlobField(QueryTmp.FieldByName(Parametro.Name)).LoadFromStream(Parametro.Value)
        else
          QueryTmp.FieldByName(Parametro.Name).Value := Parametro.Value;
      end;
      QueryTmp.Post;
      for APropriedade in ATipo.GetProperties do
      begin
        for AAtributo in APropriedade.GetAttributes do
        begin
          if (AAtributo is Campo) then
            APropriedade.SetValue(Self, Tvalue.FromVariant(QueryTmp.FieldByName(Campo(AAtributo).Nome).Value));
        end;
      end;
      QueryTmp.Close;
      Result := True;
    finally
      FreeAndNil(QueryTmp);
    end;
  finally
    AContexto.Free;
  end;
end;

end.
