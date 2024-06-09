unit Usuario.Controller;

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
  Usuario.Modelo,
  FireDAC.Comp.Client,
  Data.DB,
  Dataset.Serialize;

type
  TUsuarioController = class
      class procedure Registry;
      class procedure GetOne(Req: THorseRequest; Res: THorseResponse; Next: TProc);
      class procedure GetToken(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation  

{ TUsuarioController }

class procedure TUsuarioController.GetOne(Req: THorseRequest; Res: THorseResponse;
  Next: TProc);
var
  Usuario: TUsuarioModelo;
  qry: TFDQuery;
  ojson: TFDQuery;
  login: string;
begin

  if Req.Params.Count = 0 then
    Res.Send<TJSONObject>(TJSONObject.Create.AddPair('message', 'Usuário não encontrado')).Status(THTTPStatus.NotFound);

  login := Req.Params.Items['login'];
  Usuario := TUsuarioModelo.Create;
  qry := Usuario.find(login);

  if not qry.IsEmpty then
    Res.Send<TJSONObject>(qry.ToJSONObject()).Status(THTTPStatus.OK)
  else
    Res.Send<TJSONObject>(TJSONObject.Create.AddPair('message', 'Usuário não encontrado')).Status(THTTPStatus.NotFound);
end;

class procedure TUsuarioController.GetToken(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
  var
    Usuario: TUsuarioModelo;
    qry: TFDQuery;
    LToken: TJWT;
    LCompactToken: string;
    LBody: TJSONValue;
begin
  if Req.Body.Trim() = ''  then
    Res.Send<TJSONObject>(TJSONObject.Create.AddPair('message', 'Usuário não encontrado')).Status(THTTPStatus.NotFound)
  else
  begin
    LBody :=  TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body), 0) as TJSONValue;
    Usuario := TUsuarioModelo.Create;
    qry := Usuario.find(LBody.GetValue<string>('login', ''));
    if not qry.IsEmpty then
    begin
      if qry.FieldByName('senha').AsString = LBody.GetValue<string>('senha', '') then
      begin
        LToken :=  TJWT.Create;
        LToken.Claims.Expiration := IncHour(Now, 1);
        LCompactToken := TJOSE.SHA256CompactToken('BBMG', LToken);
        FreeAndNil(LToken);

        Res.Send<TJSONObject>(TJSONObject.Create.AddPair('token', LCompactToken)).Status(THTTPStatus.Ok);
      end
      else
        Res.Send<TJSONObject>(TJSONObject.Create.AddPair('message', 'Usuário não encontrado')).Status(THTTPStatus.NotFound);
    end
    else
      Res.Send<TJSONObject>(TJSONObject.Create.AddPair('message', 'Usuário não encontrado')).Status(THTTPStatus.NotFound);
  end;
end;

class procedure TUsuarioController.Registry;
begin
  THorse.Get('/usuario/:login', GetOne);
  THorse.Post('/login', GetToken);
end;

end.
