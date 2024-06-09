unit TarefaStatus.Controller;

interface

uses
  Horse,
  Classes,
  SysUtils,
  System.Json,
  Horse.JWT,
  JOSE.Core.JWT,
  JOSE.Core.Builder,
  System.DateUtils,
  TarefaStatus.Modelo,
  FireDAC.Comp.Client,
  Data.DB,
  Dataset.Serialize;

type
  TTarefaStatusController = class
      class procedure Registry;
      class procedure GetOne(Req: THorseRequest; Res: THorseResponse; Next: TProc);
      class procedure GetAll(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TTarefaStatusController }

class procedure TTarefaStatusController.GetOne(Req: THorseRequest; Res: THorseResponse;
  Next: TProc);
var
  qry: TFDQuery;
  tarefaStatus: TTarefaStatusModelo;
  ojson: TJSONObject;
  id: integer;
begin
  if Req.Params.Count = 0 then
    Res.Send<TJSONObject>(TJSONObject.Create.AddPair('message', 'Status não encontrado')).Status(THTTPStatus.NotFound);

  id := StrToInt(Req.Params.Items['id']);
  tarefaStatus := TTarefaStatusModelo.Create;
  qry := TarefaStatus.find(id);

  if not qry.IsEmpty then
    Res.Send<TJSONObject>(qry.ToJSONObject()).Status(THTTPStatus.OK)
  else
    Res.Send<TJSONObject>(TJSONObject.Create.AddPair('message', 'Status não encontrado')).Status(THTTPStatus.NotFound);
end;

class procedure TTarefaStatusController.GetAll(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
  var
    lista: TFDQuery;
    status: TTarefaStatusModelo;
    id: integer;
    vWhere: string;
begin

  if Req.Params.Count = 0 then
    Res.Send<TJSONObject>(TJSONObject.Create.AddPair('message', 'Status não encontrado')).Status(THTTPStatus.NotFound);
  id := StrToInt(Req.Params.Items['id']);

  vWhere := '';

  if id = 1 then
    vWhere := 'WHERE ID IN (1,2)'
  else if id = 2 then
    vWhere := 'WHERE ID IN (2,3,4,5)'
  else if id = 3 then
    vWhere := 'WHERE ID IN (2,3,4,5)';

  status := TTarefaStatusModelo.Create;
  lista := status.findAll(vWhere);

  if lista.IsEmpty then
    Res.Send<TJSONObject>(TJSONObject.Create.AddPair('message', 'lista de status não encontrado')).Status(THTTPStatus.NotFound)
  else
    Res.Send<TJsonArray>(lista.ToJSONArray()).Status(THTTPStatus.OK);
end;

class procedure TTarefaStatusController.Registry;
begin
  THorse.Get('/tarefastatus/:id', GetOne);
  THorse.Get('/tarefastatus/:id', GetAll);
end;

end.
