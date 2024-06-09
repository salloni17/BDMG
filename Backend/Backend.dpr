program Backend;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.JSON,
  Horse,
  Horse.Jhonson,
  Horse.JWT,
  Usuario.Modelo in 'Modelo\Usuario.Modelo.pas',
  Usuario.Controller in 'Controller\Usuario.Controller.pas',
  TarefaStatus.Modelo in 'Modelo\TarefaStatus.Modelo.pas',
  TarefaStatus.Controller in 'Controller\TarefaStatus.Controller.pas',
  Tarefa.Modelo in 'Modelo\Tarefa.Modelo.pas',
  Tarefa.Controller in 'Controller\Tarefa.Controller.pas',
  Model.Connection in 'Modelo\Model.Connection.pas';

begin
  //middlewares
  THorse.Use(Jhonson);
  THorse.Use(HorseJWT('BBMG',  THorseJWTConfig.New.SkipRoutes(['/', '/ping','login'])));

  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send('pong');
    end);


  //Controllers
  TUsuarioController.Registry;
  TTarefaStatusController.Registry;
  TTarefaController.Registry;

  THorse.Listen(9000);
end.
