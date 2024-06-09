unit ufrmGraficos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  VCLTee.TeEngine, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart, VCLTee.DBChart,
  VCLTee.TeeDBCrossTab, VCLTee.Series;

type
  TfrmGraficos = class(TForm)
    Chart1: TChart;
    fdPizza: TFDMemTable;
    Series1: TPieSeries;
    DBCrossTabSource1: TDBCrossTabSource;
    Chart2: TChart;
    Series2: TBarSeries;
    fdBarra: TFDMemTable;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGraficos: TfrmGraficos;

implementation

{$R *.dfm}

uses ufrmMenuPrincipal;

procedure TfrmGraficos.FormShow(Sender: TObject);
var
  i: Integer;
begin
  fdPizza := frmMenuPrincipal.rest.GET('/tarefa/media', frmMenuPrincipal.uToken);

  if fdPizza.Fields[0].DisplayName = 'MESSAGE' then
  begin
    fdPizza.Active := False;
  end
  else
  begin
    fdPizza.Active := True;
    fdPizza.First;

    while not fdPizza.Eof do
    begin
      Series1.AddPie(fdPizza.FieldByName('MEDIA_TAREFA').AsInteger, fdPizza.FieldByName('PRIORIDADE').AsString);
      fdPizza.Next;
    end;
  end;




  fdBarra := frmMenuPrincipal.rest.GET('/tarefa/totalConcluida', frmMenuPrincipal.uToken);

  if fdBarra.Fields[0].DisplayName = 'MESSAGE' then
  begin
    fdBarra.Active := False;
  end
  else
  begin
    fdBarra.Active := True;
    fdBarra.First;

    while not fdBarra.Eof do
    begin
      Series2.AddBar(fdBarra.FieldByName('QUANTIDADE').AsInteger, fdBarra.FieldByName('DATA_FINALIZACAO').AsString, clBlue);
      fdBarra.Next;
    end;
  end;



end;

end.
