unit TarefaStatus.Modelo;

interface

uses Model.Connection, FireDAC.Comp.Client, Data.DB;

type
  TTarefaStatusModelo = class
  private
    FCodigo: Integer;
    FNomeStatus: String;
  public
    property codigo: integer read FCodigo write FCodigo;
    property nomeStatus: string read FNomeStatus write FNomeStatus;

    //METODOS
    constructor Create;
    destructor Destroy; override;
    function find(codigo: integer): TFDQuery;
    function findAll(vWhere: string): TFDQuery;
  end;

implementation

{ TTarefaStatusModelo }

constructor TTarefaStatusModelo.Create;
begin
  Model.Connection.Connect;
end;

destructor TTarefaStatusModelo.Destroy;
begin
  Model.Connection.Disconect;
end;

function TTarefaStatusModelo.find(codigo: integer): TFDQuery;
var
  qryGenerica: TFDQuery;
begin
  qryGenerica := TFDQuery.Create(nil);
  qryGenerica.Connection := Model.Connection.FConnection;
  qryGenerica.SQL.Text := 'SELECT ID, NOME_STATUS FROM TAREFA_STATUS WHERE ID = :codigo';
  qryGenerica.Params.ParamByName('codigo').AsInteger := codigo;
  qryGenerica.Open;

  Result := qryGenerica;
end;

function TTarefaStatusModelo.findAll(vWhere: string): TFDQuery;
var
 qryGenerica: TFDQuery;
begin
  qryGenerica := TFDQuery.Create(nil);
  qryGenerica.Connection := Model.Connection.FConnection;
  qryGenerica.SQL.Text := 'SELECT ID, NOME_STATUS FROM TAREFA_STATUS ' + vWhere;
  qryGenerica.Open;
  qryGenerica.First;

  Result := qryGenerica;
end;

end.
