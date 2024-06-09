unit ufrmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, uRest, RESTRequest4D, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TfrmLogin = class(TForm)
    edtUsuario: TEdit;
    lblUsuario: TLabel;
    btnLogin: TButton;
    lblSenha: TLabel;
    edtSenha: TEdit;
    Image1: TImage;
    procedure btnLoginClick(Sender: TObject);
    procedure edtSenhaKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

uses ufrmMenuPrincipal;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
var
  json: string;
  fdMemToken: TFDMemTable;
begin
  fdMemToken := TFDMemTable.Create(nil);
  json := '{"login": "' + edtUsuario.Text + '","senha": "' + edtSenha.Text + '"}';
  fdMemToken := frmMenuPrincipal.rest.POST('/login', '', json);

  if fdMemToken.Fields[0].DisplayName = 'MESSAGE' then
  begin
    ShowMessage(fdMemToken.FieldByName('message').AsString);
  end
  else
  begin
    frmMenuPrincipal.uToken := fdMemToken.FieldByName('token').AsString;
    frmLogin.Close;
  end;

end;

procedure TfrmLogin.edtSenhaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnLogin.Click;
end;

end.
