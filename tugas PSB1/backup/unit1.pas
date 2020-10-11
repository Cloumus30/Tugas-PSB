unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, Forms, Controls, Graphics,
  Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ListBox4: TListBox;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);

  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
  var
  txtfile:TextFile;
  s: array[0..10000] of extended;
  n: integer;
  ecg1: array[0..10000] of extended;
  ecg2: array[0..10000] of extended;
begin
     if Opendialog1.execute then
     begin
      n:=0;
       Assignfile(txtfile,opendialog1.Filename);
       reset(txtfile);
       readln(txtfile);
        readln(txtfile);
       while not eof(txtfile) do
        begin
          Readln(txtfile,s[n],ecg1[n],ecg2[n]);
          //val(s[n],r,c);
          //if c<>0 then
          //begin
          //  ListBox3.Items.Add(FloatToStr(c));
          //end;
          ListBox1.Items.Add(FloatToStr(s[n]));
          ListBox2.Items.Add(FloatToStr(ecg1[n]));
          ListBox3.Items.Add(FloatToStr(ecg2[n]));
          //ListBox2.Items.Add(FloatToStr(r));
          //ListBox3.Items.Add(FloatToStr(c));
          //ListBox1.Items.Add(FloatToStr(t[n]));
          Chart1LineSeries1.AddXY(s[n],ecg1[n]);
          Chart1LineSeries2.AddXY(s[n],ecg2[n]);
          Inc(n);
        end;
       CloseFile(txtfile);

     end;
     ListBox4.Items.Add(FloatToStr(n));
end;



end.

