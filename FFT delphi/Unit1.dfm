object Form1: TForm1
  Left = 363
  Top = 127
  Caption = 'Form1'
  ClientHeight = 512
  ClientWidth = 912
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object Button1: TButton
    Left = 96
    Top = 40
    Width = 105
    Height = 33
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Chart1: TChart
    Left = 280
    Top = 22
    Width = 513
    Height = 201
    Title.Text.Strings = (
      'Input Signal')
    View3D = False
    TabOrder = 1
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series1: TLineSeries
      SeriesColor = clRed
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object Chart2: TChart
    Left = 152
    Top = 248
    Width = 345
    Height = 217
    Title.Text.Strings = (
      'TChart')
    View3D = False
    TabOrder = 2
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series2: TBarSeries
      Legend.Text = 'ini'
      LegendTitle = 'ini'
      BarBrush.BackColor = clDefault
      Marks.Visible = False
      Marks.Callout.Length = 8
      SeriesColor = clRed
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
    object Series4: TBarSeries
      Marks.Visible = False
      SeriesColor = clRed
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
  object Chart3: TChart
    Left = 528
    Top = 247
    Width = 353
    Height = 218
    Title.Text.Strings = (
      'TChart')
    View3D = False
    TabOrder = 3
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series3: TBarSeries
      BarBrush.BackColor = clDefault
      Marks.Visible = False
      Marks.Callout.Length = 8
      SeriesColor = clRed
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
end
