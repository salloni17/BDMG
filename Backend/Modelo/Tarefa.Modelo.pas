unit Tarefa.Modelo;

interface

uses Model.Connection, FireDAC.Comp.Client, Data.DB, TarefaStatus.Modelo, DateUtils ;

type
  TTarefaModelo = class
  private
    FCodigo: Integer;
    FNomeTarefa: String;
    FStatus: TTarefaStatusModelo;
    FDataFinalizacao: TDateTime;
    FPrioridade: String;

  public
    property codigo: integer read FCodigo write FCodigo;
    property nomeTarefa: string read FNomeTarefa write FNomeTarefa;
    property status: TTarefaStatusModelo read FStatus write FStatus;
    property dataFinalizacao: TDateTime read FDataFinalizacao write FDataFinalizacao;
    property prioridade: string read FPrioridade write FPrioridade;

    //METODOS
    constructor Create;
    destructor Destroy; override;
    function findOne(id: Integer): TFDQuery;
    function findAll: TFDQuery;
    function insert: Boolean;
    function delete: Boolean;
    function update: Boolean;

    function updateStatus: Boolean;
    function totalTarefas: Integer;
    function totalTarefasConcluidas: TFDQuery;
    function mediaPrioridades: TFDQuery;
  end;

implementation

{ TUsuarioModelo }

constructor TTarefaModelo.Create;
begin
  Model.Connection.Connect;
  status := TTarefaStatusModelo.Create;
end;

function TTarefaModelo.delete(): Boolean;
var
  qryGenerica: TFDQuery;
begin
  try
    qryGenerica := TFDQuery.Create(nil);
    qryGenerica.Connection := Model.Connection.FConnection;
    qryGenerica.SQL.Text := 'DELETE FROM TAREFAS WHERE ID = :id';
    qryGenerica.Params.ParamByName('id').AsInteger := codigo;
    qryGenerica.ExecSQL;

    qryGenerica.Free;
    Result := True;
  except
    qryGenerica.Free;
    Result := False;
  end;
end;

destructor TTarefaModelo.Destroy;
begin
  Model.Connection.Disconect;
end;

function TTarefaModelo.findAll: TFDQuery;
var
  qryGenerica: TFDQuery;
begin
  qryGenerica := TFDQuery.Create(nil);
  qryGenerica.Connection := Model.Connection.FConnection;
  qryGenerica.SQL.Text := 'SELECT T.ID, T.NOME_TAREFA, T.STATUS, TS.NOME_STATUS, T.DATA_FINALIZACAO, T.PRIORIDADE FROM TAREFAS T LEFT JOIN TAREFA_STATUS TS ON TS.ID = T.STATUS WHERE T.DATA_FINALIZACAO IS NULL';
  qryGenerica.Open;

  Result := qryGenerica;
end;

function TTarefaModelo.findOne(id: integer): TFDQuery;
var
  qryGenerica: TFDQuery;
begin
  qryGenerica := TFDQuery.Create(nil);
  qryGenerica.Connection := Model.Connection.FConnection;
  qryGenerica.SQL.Text := 'SELECT T.ID, T.NOME_TAREFA, T.STATUS, TS.NOME_STATUS, T.DATA_FINALIZACAO, T.PRIORIDADE FROM TAREFAS T LEFT JOIN TAREFA_STATUS TS ON TS.ID = T.STATUS WHERE T.ID = :id';
  qryGenerica.Params.ParamByName('id').AsInteger := id;
  qryGenerica.Open;

  Result := qryGenerica;
end;

function TTarefaModelo.insert: Boolean;
var
  qryGenerica: TFDQuery;
begin
  try
    qryGenerica := TFDQuery.Create(nil);
    qryGenerica.Connection := Model.Connection.FConnection;
    qryGenerica.SQL.Text := 'INSERT INTO TAREFAS (NOME_TAREFA, STATUS, PRIORIDADE) VALUES (:NOME_TAREFA, :STATUS, :PRIORIDADE)';
    qryGenerica.Params.ParamByName('NOME_TAREFA').AsString := nomeTarefa;
    qryGenerica.Params.ParamByName('STATUS').AsInteger := status.codigo;
    qryGenerica.Params.ParamByName('PRIORIDADE').AsString := prioridade;
    qryGenerica.ExecSQL;

    Result := True;
  except
    qryGenerica.Free;
    Result := False;
  end;
end;

function TTarefaModelo.mediaPrioridades: TFDQuery;
var
  qryGenerica: TFDQuery;
begin
  qryGenerica := TFDQuery.Create(nil);
  qryGenerica.Connection := Model.Connection.FConnection;
  qryGenerica.SQL.Text := 'SELECT  PRIORIDADE, COUNT(*) * 100 / (SELECT COUNT(*) FROM TAREFAS WHERE STATUS = 3) MEDIA_TAREFA FROM TAREFAS WHERE STATUS = 3 GROUP BY PRIORIDADE';
  qryGenerica.Open;

  Result := qryGenerica;
end;

function TTarefaModelo.totalTarefas: Integer;
var
  qryGenerica: TFDQuery;
begin
  qryGenerica := TFDQuery.Create(nil);
  qryGenerica.Connection := Model.Connection.FConnection;
  qryGenerica.SQL.Text := 'SELECT COUNT(*) QUANTIDADE FROM TAREFAS';
  qryGenerica.Open;

  Result := qryGenerica.FieldByName('QUANTIDADE').AsInteger;
end;

function TTarefaModelo.totalTarefasConcluidas: TFDQuery;
var
  qryGenerica: TFDQuery;
begin
  qryGenerica := TFDQuery.Create(nil);
  qryGenerica.Connection := Model.Connection.FConnection;
  qryGenerica.SQL.Text := 'SELECT  CAST(DATA_FINALIZACAO AS DATE) DATA_FINALIZACAO, COUNT(*) QUANTIDADE FROM TAREFAS WHERE STATUS = 4 AND DATA_FINALIZACAO BETWEEN DATEADD(DAY, -7, GETDATE()) AND GETDATE() GROUP BY CAST(DATA_FINALIZACAO AS DATE)';
  qryGenerica.Open;

  Result := qryGenerica;
end;

function TTarefaModelo.update: Boolean;
var
  qryGenerica: TFDQuery;
begin
  try
    qryGenerica := TFDQuery.Create(nil);
    qryGenerica.Connection := Model.Connection.FConnection;
    qryGenerica.SQL.Text := 'UPDATE TAREFAS SET NOME_TAREFA = :NOME_TAREFA, STATUS = :STATUS, PRIORIDADE = :PRIORIDADE WHERE ID = :ID';
    qryGenerica.Params.ParamByName('NOME_TAREFA').AsString := nomeTarefa;
    qryGenerica.Params.ParamByName('STATUS').AsInteger := status.codigo;
    qryGenerica.Params.ParamByName('PRIORIDADE').AsString := prioridade;
    qryGenerica.Params.ParamByName('ID').AsInteger := codigo;
    qryGenerica.ExecSQL;

    Result := True;
  except
    qryGenerica.Free;
    Result := False;
  end;
end;

function TTarefaModelo.updateStatus: Boolean;
var
  qryGenerica: TFDQuery;
begin
  try
    qryGenerica := TFDQuery.Create(nil);
    qryGenerica.Connection := Model.Connection.FConnection;
    qryGenerica.SQL.Text := 'UPDATE TAREFAS SET STATUS = :STATUS WHERE ID = :ID';
    qryGenerica.Params.ParamByName('STATUS').AsInteger := status.codigo;
    qryGenerica.Params.ParamByName('ID').AsInteger := codigo;
    qryGenerica.ExecSQL;

    Result := True;
  except
    qryGenerica.Free;
    Result := False;
  end;

end;

end.
