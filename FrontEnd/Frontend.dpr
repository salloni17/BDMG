program Frontend;

uses
  Vcl.Forms,
  ufrmMenuPrincipal in 'Formularios\ufrmMenuPrincipal.pas' {frmMenuPrincipal},
  ufrmLogin in 'Formularios\ufrmLogin.pas' {frmLogin},
  uRest in 'Units\uRest.pas',
  ufrmTarefas in 'Formularios\ufrmTarefas.pas' {frmTarefas},
  ufrmGraficos in 'Formularios\ufrmGraficos.pas' {frmGraficos};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMenuPrincipal, frmMenuPrincipal);
  Application.CreateForm(TfrmTarefas, frmTarefas);
  Application.CreateForm(TfrmGraficos, frmGraficos);
  Application.Run;
end.
