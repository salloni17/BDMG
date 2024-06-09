object frmGraficos: TfrmGraficos
  Left = 0
  Top = 0
  Caption = 'Relat'#243'rio'
  ClientHeight = 798
  ClientWidth = 668
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnShow = FormShow
  TextHeight = 15
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 668
    Height = 417
    Title.Text.Strings = (
      'M'#233'dia de prioridades das tarefas')
    View3DOptions.Elevation = 315
    View3DOptions.Orthogonal = False
    View3DOptions.Perspective = 0
    View3DOptions.Rotation = 360
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 569
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series1: TPieSeries
      Marks.Tail.Margin = 2
      DataSource = DBCrossTabSource1
      XValues.Order = loAscending
      YValues.Name = 'Pie'
      YValues.Order = loNone
      Frame.InnerBrush.BackColor = clRed
      Frame.InnerBrush.Gradient.EndColor = clGray
      Frame.InnerBrush.Gradient.MidColor = clWhite
      Frame.InnerBrush.Gradient.StartColor = 4210752
      Frame.InnerBrush.Gradient.Visible = True
      Frame.MiddleBrush.BackColor = clYellow
      Frame.MiddleBrush.Gradient.EndColor = 8553090
      Frame.MiddleBrush.Gradient.MidColor = clWhite
      Frame.MiddleBrush.Gradient.StartColor = clGray
      Frame.MiddleBrush.Gradient.Visible = True
      Frame.OuterBrush.BackColor = clGreen
      Frame.OuterBrush.Gradient.EndColor = 4210752
      Frame.OuterBrush.Gradient.MidColor = clWhite
      Frame.OuterBrush.Gradient.StartColor = clSilver
      Frame.OuterBrush.Gradient.Visible = True
      Frame.Width = 4
      OtherSlice.Legend.Visible = False
    end
  end
  object Chart2: TChart
    Left = 0
    Top = 417
    Width = 668
    Height = 381
    Title.Text.Strings = (
      'Quantidade de tarefas finalizadas em 7 dias')
    Align = alClient
    TabOrder = 1
    ExplicitTop = 423
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series2: TBarSeries
      Marks.OnTop = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
  object fdPizza: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 464
    Top = 240
  end
  object DBCrossTabSource1: TDBCrossTabSource
    LabelField = 'PRIORIDADE'
    Series = Series1
    DataSet = fdPizza
  end
  object fdBarra: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 600
    Top = 600
  end
end
