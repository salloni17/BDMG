unit ufrmTarefas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, System.ImageList, Vcl.ImgList,
  Vcl.ButtonGroup, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls,
  Datasnap.DBClient, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Buttons, FireDAC.Stan.Async,
  FireDAC.DApt, Vcl.DBCtrls, Vcl.Mask;

type
  TfrmTarefas = class(TForm)
    DBGrid1: TDBGrid;
    pnSuperior: TPanel;
    btnAdicionar: TButton;
    imgPrincipal: TImageList;
    btnRemover: TButton;
    btnEditar: TButton;
    btnAlterarStatus: TButton;
    pnEsquerdo: TPanel;
    pndireito: TPanel;
    pnBaixo: TPanel;
    btnSalvar: TButton;
    btnCancelar: TButton;
    memLista: TFDMemTable;
    dsLista: TDataSource;
    memListaID: TIntegerField;
    memListaNOME_TAREFA: TStringField;
    memListaSTATUS: TIntegerField;
    memListaPRIORIDADE: TStringField;
    memListaDATA_FINALIZACAO: TStringField;
    memListaNOME_STATUS: TStringField;
    pnStatus: TPanel;
    Label1: TLabel;
    cbStatus: TComboBox;
    btnCancelaStatus: TSpeedButton;
    btnSalvarStatus: TSpeedButton;
    fdReceptor: TFDMemTable;
    pnSecundario: TPanel;
    lblTituloTarefa: TLabel;
    lblPrioridade: TLabel;
    edtTituloTarefa: TEdit;
    cbPrioridade: TComboBox;
    lblSituacao: TLabel;
    cbSituacao: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure btnAlterarStatusClick(Sender: TObject);
    procedure btnCancelaStatusClick(Sender: TObject);
    procedure btnSalvarStatusClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure btnCancelaAcaoClick(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
  private
    { Private declarations }
    procedure ControlarAcao(Inserir, Deletar, Editar, Salvar, Cancelar, Alterar: Boolean);
    procedure CarregarDados;
  public
    { Public declarations }
  end;

var
  frmTarefas: TfrmTarefas;

implementation

{$R *.dfm}

{ TfrmTarefas }

uses ufrmMenuPrincipal;

procedure TfrmTarefas.btnAdicionarClick(Sender: TObject);
begin
  edtTituloTarefa.Text := '';
  cbPrioridade.ItemIndex := 0;
  lblSituacao.Visible := False;
  cbSituacao.Visible := False;
  pnSecundario.Visible := True;
  ControlarAcao(False, False, False, True, True, False);
end;

procedure TfrmTarefas.btnAlterarStatusClick(Sender: TObject);
begin
  fdReceptor := frmMenuPrincipal.rest.GET('/tarefastatus/' + memLista.FieldByName('STATUS').AsString , frmMenuPrincipal.uToken);

  if fdReceptor.Fields[0].DisplayName = 'MESSAGE' then
  begin
    ShowMessage(fdReceptor.FieldByName('MESSAGE').AsString);
    pnStatus.Visible := False;
  end
  else
  begin
    cbStatus.Items.Clear;
    fdReceptor.First;
    while not fdReceptor.Eof do
    begin
      cbStatus.Items.Add(fdReceptor.FieldByName('NOME_STATUS').AsString);
      fdReceptor.Next;
    end;
    cbStatus.Text := memLista.FieldByName('NOME_STATUS').AsString;
    pnStatus.Visible := True;
    ControlarAcao(False, False, False, False, False, False);
  end;
end;

procedure TfrmTarefas.btnCancelaAcaoClick(Sender: TObject);
begin
  pnSecundario.Visible := False;
  memLista.Cancel;

  if memLista.IsEmpty then
    ControlarAcao(True, False, False, False, False, False)
  else
    ControlarAcao(True, True, True, False, False, True);
end;

procedure TfrmTarefas.btnCancelarClick(Sender: TObject);
begin
  pnSecundario.Visible := False;
  memLista.Cancel;

  if memLista.IsEmpty then
    ControlarAcao(True, False, False, False, False, False)
  else
    ControlarAcao(True, True, True, False, False, True);
end;

procedure TfrmTarefas.btnCancelaStatusClick(Sender: TObject);
begin
  pnStatus.Visible := False;
  ControlarAcao(True, True, True, False, False, True);
end;

procedure TfrmTarefas.btnEditarClick(Sender: TObject);
begin
  fdReceptor := frmMenuPrincipal.rest.GET('/tarefastatus/' + memLista.FieldByName('STATUS').AsString , frmMenuPrincipal.uToken);

  lblSituacao.Visible := True;
  cbSituacao.Visible := True;

  cbSituacao.Items.Clear;
  fdReceptor.First;
  while not fdReceptor.Eof do
  begin
    cbSituacao.Items.Add(fdReceptor.FieldByName('NOME_STATUS').AsString);
    fdReceptor.Next;
  end;

  edtTituloTarefa.Text := memLista.FieldByName('NOME_TAREFA').AsString;
  cbPrioridade.Text := memLista.FieldByName('PRIORIDADE').AsString;
  cbSituacao.Text := memLista.FieldByName('NOME_STATUS').AsString;

  pnSecundario.Visible := True;
  ControlarAcao(False, False, False, True, True, False);

end;

procedure TfrmTarefas.btnRemoverClick(Sender: TObject);
begin
  if MessageDlg('Voc� tem certeza que deseja excluir a tarefa selecionada?',mtConfirmation,[mbyes,mbno],0) = mrYes then
  begin
    fdReceptor := frmMenuPrincipal.rest.DELETE('/tarefa/' + memLista.FieldByName('ID').AsString, frmMenuPrincipal.uToken);

    ShowMessage(fdReceptor.FieldByName('MESSAGE').AsString);
    CarregarDados;

    if memLista.IsEmpty then
      ControlarAcao(True, False, False, False, False, False)
    else
      ControlarAcao(True, True, True, False, False, True);

  end;
end;

procedure TfrmTarefas.btnSalvarClick(Sender: TObject);
var
json: string;
begin
  if cbSituacao.Visible = False then
  begin
    if Trim(edtTituloTarefa.Text) = '' then
      ShowMessage('Campo T�tulo n�o pode estar vazio')
    else if (cbPrioridade.Text) = '' then
      ShowMessage('Selecione uma prioridade')
    else
      fdReceptor := frmMenuPrincipal.rest.POST('/tarefa', frmMenuPrincipal.uToken, '{"nomeTarefa": "'  + edtTituloTarefa.Text +
        '", "prioridade": "' + cbPrioridade.Text + '"}')
  end
  else
  begin
    if Trim(edtTituloTarefa.Text) = '' then
      ShowMessage('Campo T�tulo n�o pode estar vazio')
    else if (edtTituloTarefa.Text) = '' then
      ShowMessage('Selecione uma prioridade')
    else
    begin
      fdReceptor.Locate('NOME_STATUS', cbSituacao.Text, []);
      json := '{"codigo": "' + memLista.FieldByName('ID').AsString + '","nomeTarefa": "' + edtTituloTarefa.Text + '", ' +
        '"status": {"codigo": "' + fdReceptor.FieldByName('ID').AsString + '"}, "prioridade": "' + cbPrioridade.Text + '"}';
      fdReceptor := frmMenuPrincipal.rest.PUT('/tarefa', frmMenuPrincipal.uToken, json);
    end;
  end;

  ShowMessage(fdReceptor.FieldByName('MESSAGE').AsString);
  CarregarDados;

  if memLista.IsEmpty then
    ControlarAcao(True, False, False, False, False, False)
  else
    ControlarAcao(True, True, True, False, False, True);

  pnSecundario.Visible := False;
end;

procedure TfrmTarefas.btnSalvarStatusClick(Sender: TObject);
var
  json: string;
begin
  fdReceptor.Locate('NOME_STATUS', cbStatus.Text, []);

  json := '{"codigo": "' + memLista.FieldByName('ID').AsString + '","nomeTarefa": "' + memLista.FieldByName('NOME_TAREFA').AsString + '", ' +
        '"status": {"codigo": "' + fdReceptor.FieldByName('ID').AsString + '"}, "prioridade": "' + memLista.FieldByName('PRIORIDADE').AsString + '"}';
  fdReceptor := frmMenuPrincipal.rest.PUT('/tarefa', frmMenuPrincipal.uToken, json);

  pnStatus.Visible := False;
  CarregarDados;

  if memLista.IsEmpty then
    ControlarAcao(True, False, False, False, False, False)
  else
    ControlarAcao(True, True, True, False, False, True);
end;

procedure TfrmTarefas.CarregarDados;
var
  i: Integer;
begin
  fdReceptor := frmMenuPrincipal.rest.GET('/tarefa', frmMenuPrincipal.uToken);

  if fdReceptor.Fields[0].DisplayName = 'MESSAGE' then
  begin
    memLista.Active := False;
  end
  else
  begin
    for i := memLista.RecordCount - 1 downto 0 do
      memLista.Delete;

    memLista.CopyDataSet(fdReceptor);
    memLista.Active := True;
  end;
  fdReceptor.Free;
end;

procedure TfrmTarefas.ControlarAcao(Inserir, Deletar, Editar, Salvar, Cancelar,
  Alterar: Boolean);
begin
  btnAdicionar.Enabled := Inserir;
  btnRemover.Enabled := Deletar;
  btnEditar.Enabled := Editar;
  btnSalvar.Enabled := Salvar;
  btnCancelar.Enabled := Cancelar;
  btnAlterarStatus.Enabled := Alterar;
end;

procedure TfrmTarefas.FormShow(Sender: TObject);
begin
  pnStatus.Visible := False;
  pnSecundario.Visible := False;
  CarregarDados;

  if not memLista.IsEmpty then
    ControlarAcao(True, True, True, False, False, True)
  else
    ControlarAcao(True, False, False, False, False, False);
end;

end.
