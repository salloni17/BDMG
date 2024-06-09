unit ufrmMenuPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, uRest;

type
  TfrmMenuPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    Consultar1: TMenuItem;
    arefas1: TMenuItem;
    Relatrios1: TMenuItem;
    Grficos1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure arefas1Click(Sender: TObject);
    procedure Grficos1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    rest: TCallRest;
    uToken: string;
  end;

var
  frmMenuPrincipal: TfrmMenuPrincipal;

implementation


{$R *.dfm}

uses ufrmLogin, ufrmTarefas, ufrmGraficos;

procedure TfrmMenuPrincipal.arefas1Click(Sender: TObject);
begin
  if not Assigned(frmTarefas) then
    frmTarefas := TfrmTarefas.Create(Self);

  frmTarefas.Show;
end;

procedure TfrmMenuPrincipal.FormCreate(Sender: TObject);
begin
  rest := TCallRest.Create;
  frmMenuPrincipal.Visible := False;
  uToken := '';
  
  frmLogin := TfrmLogin.Create(self);
  frmLogin.ShowModal;
end;

procedure TfrmMenuPrincipal.FormShow(Sender: TObject);
begin
  if uToken = '' then
    frmMenuPrincipal.Close;
end;

procedure TfrmMenuPrincipal.Grficos1Click(Sender: TObject);
begin
  if not Assigned(frmGraficos) then
    frmGraficos := TfrmGraficos.Create(Self);

  frmGraficos.Show;
end;

end.
