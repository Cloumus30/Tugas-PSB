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
  object Label1: TLabel
    Left = 8
    Top = 92
    Width = 93
    Height = 14
    Caption = 'Frekuensi Sampling'
  end
  object Label2: TLabel
    Left = 8
    Top = 152
    Width = 79
    Height = 14
    Caption = 'Frekuensi Sinyal'
  end
  object Label3: TLabel
    Left = 8
    Top = 209
    Width = 58
    Height = 14
    Caption = 'Jumlah Data'
  end
  object Button1: TButton
    Left = 32
    Top = 32
    Width = 105
    Height = 33
    Caption = 'FFT'
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
    Top = 264
    Width = 345
    Height = 217
    Title.Text.Strings = (
      'FFT')
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
    Top = 263
    Width = 353
    Height = 218
    Title.Text.Strings = (
      'IFFT')
    View3D = False
    TabOrder = 3
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series3: TLineSeries
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
  object Edit1: TEdit
    Left = 32
    Top = 112
    Width = 121
    Height = 22
    TabOrder = 4
    Text = '160'
  end
  object Edit2: TEdit
    Left = 32
    Top = 172
    Width = 121
    Height = 22
    TabOrder = 5
    Text = '20'
  end
  object Edit3: TEdit
    Left = 32
    Top = 229
    Width = 121
    Height = 22
    TabOrder = 6
    Text = '512'
  end
  object Button2: TButton
    Left = 143
    Top = 32
    Width = 105
    Height = 33
    Caption = 'IFFT'
    TabOrder = 7
    OnClick = Button2Click
  end
end
