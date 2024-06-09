unit uRest;

interface

uses RESTRequest4D, DataSet.Serialize.Adapter.RESTRequest4D,
FireDAC.Comp.Client, Data.DB;

type
  TCallRest = class
  private
  public
    function GET(caminho, token: string): TFDMemTable;
    function POST(caminho, token, body: string): TFDMemTable;
    function PUT(caminho, token, body: string): TFDMemTable;
    function DELETE(caminho, token: string): TFDMemTable;
  end;

implementation

const
  uBaseURL = 'http://localhost:9000';

{ TCallRest }

function TCallRest.DELETE(caminho, token: string): TFDMemTable;
var
  FDMemTable: TFDMemTable;
begin
  FDMemTable := TFDMemTable.Create(nil);
  TRequest.New.BaseURL(uBaseURL + caminho)
    .Accept('application/json')
    .TokenBearer(token)
    .Adapters(TDataSetSerializeAdapter.New(FDMemTable))
    .Delete;
  Result := FDMemTable;
end;

function TCallRest.GET(caminho, token: string): TFDMemTable;
var
  FDMemTable: TFDMemTable;
begin
  FDMemTable := TFDMemTable.Create(nil);
  TRequest.New.BaseURL(uBaseURL + caminho)
    .AddHeader('HeaderName', 'HeaderValue')
    .AddParam('ParameterName', 'ParameterValue')
    .Accept('application/json')
    .TokenBearer(token)
    .Adapters(TDataSetSerializeAdapter.New(FDMemTable))
    .Get;
  Result := FDMemTable;
end;

function TCallRest.POST(caminho, token, body: string): TFDMemTable;
var
  FDMemTable: TFDMemTable;
begin
 FDMemTable := TFDMemTable.Create(nil);
 TRequest.New.BaseURL(uBaseURL + caminho)
      .ContentType('application/json')
      .Accept('application/json')
      .TokenBearer(token)
      .AddBody(body)
      .Adapters(TDataSetSerializeAdapter.New(FDMemTable))
      .Post;
 Result := FDMemTable;
end;

function TCallRest.PUT(caminho, token, body: string): TFDMemTable;
var
  FDMemTable: TFDMemTable;
begin
 FDMemTable := TFDMemTable.Create(nil);
 TRequest.New.BaseURL(uBaseURL + caminho)
      .ContentType('application/json')
      .Accept('application/json')
      .TokenBearer(token)
      .AddBody(body)
      .Adapters(TDataSetSerializeAdapter.New(FDMemTable))
      .Put;
 Result := FDMemTable;
end;

end.
