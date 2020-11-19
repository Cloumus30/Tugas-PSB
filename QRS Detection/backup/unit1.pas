unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls,math;

type
  arrextend=array of extended;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Chart1: TChart;
    Chart10: TChart;
    Chart10LineSeries1: TLineSeries;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    Chart2: TChart;
    Chart2BarSeries1: TBarSeries;
    Chart3: TChart;
    Chart3LineSeries1: TLineSeries;
    Chart3LineSeries2: TLineSeries;
    Chart3LineSeries3: TLineSeries;
    Chart4: TChart;
    Chart4LineSeries1: TLineSeries;
    Chart4LineSeries2: TLineSeries;
    Chart4LineSeries3: TLineSeries;
    Chart5: TChart;
    Chart5LineSeries1: TLineSeries;
    Chart6: TChart;
    Chart6LineSeries1: TLineSeries;
    Chart7: TChart;
    Chart7LineSeries1: TLineSeries;
    Chart8: TChart;
    Chart8LineSeries1: TLineSeries;
    Chart9: TChart;
    Chart9LineSeries1: TLineSeries;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ListBox1: TListBox;
    OpenDialog1: TOpenDialog;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    ScrollBar3: TScrollBar;
    ScrollBox1: TScrollBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure ScrollBar3Change(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure windowing;
    procedure inputFile;
  private

  public

  end;

var
  Form1: TForm1;
  txtFile:TextFile;
  xw,mav,inptim,inpamp,dattim,datamp:array[0..100000] of extended;
  hpfInp,derInp,sqrInp,mav2Inp,thresholdInp:array of extended;
  Lwind,jumdat,mavstep:integer;
  fs,thresValue:extended;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
//  ScrollBar LPF Cut off Freq
    ScrollBar1.Max:=100;
    ScrollBar1.Min:=0;
    ScrollBar1.Position:=StrToInt(Edit2.Text);

//  ScrollBar HPF Cut Off Freq
    ScrollBar2.Max:=100;
    ScrollBar2.Min:=0;
    ScrollBar2.Position:=StrToInt(Edit3.Text);

//  ScrollBar MAV Step Size
    ScrollBar3.Max:=50;
    ScrollBar3.Min:=0;
    ScrollBar3.Position:=StrToInt(Edit1.Text);
end;
procedure TForm1.inputFile;
var
  i,k:integer;
  strs,inp2: String;
  strArr: array of String;
begin
     if Opendialog1.execute then
     begin
      i:=0;
//      input file txt
       Assignfile(txtFile,opendialog1.Filename);
       reset(txtFile);
//       Skip Baris 1
              Readln(txtFile);
//       Baris 2 tempat frekuensi Sampling
       Readln(txtFile,inp2);
          strs:=Trim(inp2);
          strArr:=strs.Split(['(',' ']);
          strs:=strArr[1].Replace('.',',');
          fs:=1/StrToFloat(strs);
          Label2.Caption:=FloatToStr(fs)+' Hz';
//          input data = (datT(waktu), datA(Amplitudo))
       while not eof(txtFile) do
        begin
          Readln(txtFile,inptim[i],inpamp[i]);
//        Plot Data input ke Chart
          datamp[i]:=inpamp[i];
          dattim[i]:=inptim[i];
          Chart1LineSeries1.AddXY(dattim[i],datamp[i]);
           //ListBox1.items.add(FloatToStr(datamp[i]));
          Inc(i);
        end;
       CloseFile(txtFile);
//       Jumlah data
         jumdat:=i;
        Label4.Caption:=IntToStr(jumdat);
     end;
end;

// DFT Function
function dftFunc(inp:array of extended;jumdata:integer):arrextend;
var
  k,i:integer;
  real,imaj:extended;
  sinimaj,sinreal,magspek:array of extended;
begin
     SetLength(sinimaj,jumdata);
     SetLength(sinreal,jumdata);
     SetLength(magspek,round(jumdata/2));
     for k:=0 to jumdata-1 do
    begin
        real:=0;
        imaj:=0;
         for i:=0 to jumdata-1 do
         begin
           real:= real+inp[i]*cos(2*pi*k*i/jumdata);
           imaj:= imaj-inp[i]*sin(2*pi*k*i/jumdata);
         end;
         sinimaj[k]:=imaj;
         sinreal[k]:=real;
       end;
       for i:=0 to round(jumdata/2) do
     begin
      magspek[i]:=1/(jumdata/2)*(sqrt(sqr(sinimaj[i]) +sqr(sinreal[i])));
     end;
     result:=magspek;
  end;
// LPF Function
function lpfFunc(inp:array of extended; wc:integer; jumdata:integer):arrextend;
var
  i:integer;
  T:extended;
  lpf:array of extended;
begin
     SetLength(lpf,jumdata);
     for i:=0 to jumdata-1 do
     begin
      T:=1/fs;
      lpf[i]:=((((2/T)-wc)*lpf[i-1])+(wc*inp[i])+(wc*inp[i-1]))/((2/T)+wc);
     end;
     result:=lpf;
end;
// HPF Function
function hpfFunc(inp:array of extended; wc:integer; jumdata:integer):arrextend;
var
  i:integer;
  T:extended;
  hpf:array of extended;
begin
     setLength(hpf,jumdata);
     for i:=0 to jumdata-1 do
     begin
      T:=1/fs;
      hpf[i]:=(((8/sqr(T))-2*wc)*hpf[i-1]-(((4/sqr(T))-((2*sqrt(2)*wc)/T)+wc))*hpf[i-2]+(4/sqr(T)*inp[i])-(8/sqr(T)*inp[i-1])+((4/sqr(T))*inp[i-2]))/((wc+(2*sqrt(2)*wc)/T)+(4/sqr(T)));
     end;
     result:=hpf;
end;
// derivative Function
function derFunc(inp:array of extended; jumdata:integer):arrextend;
var
  i:integer;
  y:array of extended;
begin
     setLength(y,jumdata);
     for i:=0 to jumdata-1 do
     begin
          //y[i]:=((2*inp[i])+inp[i-1]-inp[i-3]-(2*inp[i-4]))/8;
          y[i]:=(1/8*0.01)*(inp[i+2]-inp[i-2]-(2*inp[i-1])+(2*inp[i+1]));
     end;
     result:=y;
end;
// Squarring Function
function sqrFunc(inp:array of extended; jumdata:integer):arrextend;
var
  i:integer;
  res:array of extended;
begin
     setLength(res,jumdata);
     for i:=0 to jumdata-1 do
     begin
          res[i]:=sqr(inp[i]);
     end;
     result:=res;
end;

//  MAV Filter Function
function mavFunc(inp:array of extended; step:integer; jumdata:integer):arrextend;
var
  i,j:integer;
  mav:array of extended;
  mavtemp:extended;
begin
     setLength(mav,jumdata);
     for i:=0 to jumdata-1 do
         begin
            mavtemp:=0;
            for j:=0 to step-1 do
            begin
               mavtemp:=mavtemp+inp[i-j];
            end;
            mav[i]:=mavtemp;
         end;
     for i:=0 to jumdata-1 do
         begin
            mavtemp:=0;
            for j:=0 to step-1 do
            begin
               mavtemp:=mavtemp+mav[i+j];
            end;
            mav[i]:=mavtemp;
         end;
     result:=mav;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i:integer;
  dftres:array of extended;
begin
    //DFT;
    dftres:=dftFunc(datamp,jumdat);
    for i:=0 to Length(dftres)-1 do
    begin
     Chart2BarSeries1.AddXY(i*fs/jumdat,dftres[i]);
    end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     inputFile;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  i,step:integer;
  mav:array of extended;
begin
     Chart9LineSeries1.Clear;
     step:=StrToInt(Edit1.Text);
     mav:= mavFunc(mav2Inp,step,Length(mav2Inp));
     SetLength(thresholdInp,Length(mav));
     for i:=0 to Length(mav)-1 do
     begin
      Chart9LineSeries1.AddXY(i,mav[i]);
      thresholdInp[i]:=mav[i];
     end;
     if Length(thresholdInp)>0 then
     begin
       Button9.Enabled:=True;
     end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
windowing;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  i,wc:integer;
  lpf:array of extended;
begin
Chart5LineSeries1.clear;
  wc:=StrToInt(Edit2.Text);
  lpf:=lpfFunc(datamp,wc,jumdat);
  setLength(hpfInp,Length(lpf));
  for i:=0 to Length(lpf)-1 do
  begin
   Chart5LineSeries1.AddXY(i,lpf[i]);
   hpfInp[i]:=lpf[i];
  end;
     if Length(hpfInp)>0 then
   begin
     button6.Enabled:=True;
   end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  i,wc:integer;
  hpf:array of extended;
begin
     Chart6LineSeries1.clear;
     wc:=StrToInt(Edit3.Text);
     hpf:=hpfFunc(hpfInp,wc,jumdat);
     SetLength(derInp,Length(hpf));
     for i:=0 to Length(hpf)-1 do
     begin
      Chart6LineSeries1.AddXY(i,hpf[i]);
      derInp[i]:=hpf[i];
     end;
     if Length(derInp)>0 then
   begin
     button7.Enabled:=True;
   end;
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  i:integer;
  der:array of extended;
begin
  Chart7LineSeries1.clear;
  der:=derFunc(derInp,length(derInp));
  SetLength(sqrInp,Length(der));
  for i:=0 to Length(der)-1 do
  begin
   Chart7LineSeries1.addXY(i,der[i]);
   sqrInp[i]:=der[i];
  end;
  if Length(sqrInp)>0 then
  begin
    Button8.Enabled:=True;
  end;
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  i:integer;
  sqrRes:array of extended;
begin
     Chart8LineSeries1.Clear;
     sqrRes:= sqrFunc(sqrInp,Length(sqrInp));
     setLength(mav2Inp,Length(sqrInp));
     for i:=0 to Length(sqrInp)-1 do
     begin
      mav2Inp[i]:=sqrRes[i];
      Chart8LineSeries1.AddXY(i,sqrRes[i]);
     end;
     if Length(mav2Inp)>0 then
     begin
       Button3.Enabled:=True;
     end;
end;

procedure TForm1.Button9Click(Sender: TObject);
var
  i:integer;
  thres:array of extended;
begin
     Chart10LineSeries1.Clear;
     Chart1LineSeries2.Clear;
     thresValue:=0.0000172*60/100;
     setLength(thres,Length(thresholdInp));
     for i:=0 to Length(thresholdInp)-1 do
     begin
         if thresholdInp[i]>=thresValue then
         begin
           thres[i]:= 1;
         end
         else
         begin
            thres[i]:=0;
         end;
         Chart10LineSeries1.addXY(i,thres[i]);
         Chart1LineSeries2.addXY(i,thres[i]);
     end;
end;

procedure TForm1.windowing;
var
  i,j,rangbawah,rangatas:integer;
  p,qrs,t,dftp,dftqrs,dftT:array of extended;
begin
     SetLength(p,jumdat);
     SetLength(qrs,jumdat);
     SetLength(t,jumdat);
     SetLength(dftp,jumdat);
     SetLength(dftqrs,jumdat);
     SetLength(dftT,jumdat);
     rangbawah:=276;
     rangatas:=284;
//     Sinyal P
     for i:=0 to jumdat-1 do
     begin
       if (i>=rangbawah) and (i<=rangatas) then
       begin
         p[i]:=datamp[i]*1;
       end
       else
       begin
         p[i]:=datamp[i]*0
       end;
       Chart3LineSeries1.AddXY(i,p[i]);
     end;
//   Sinyal QRS
     rangbawah:=286;
     rangatas:=300;
     for i:=0 to jumdat-1 do
     begin
       if (i>=rangbawah) and (i<=rangatas) then
       begin
         qrs[i]:=datamp[i]*1;
       end
       else
       begin
         qrs[i]:=datamp[i]*0
       end;
       Chart3LineSeries2.AddXY(i,qrs[i]);
     end;
//   Sinyal T
     rangbawah:=302;
     rangatas:=330;
     for i:=0 to jumdat-1 do
     begin
       if (i>=rangbawah) and (i<=rangatas) then
       begin
         t[i]:=datamp[i]*1;
       end
       else
       begin
         t[i]:=datamp[i]*0
       end;
       Chart3LineSeries3.AddXY(i,t[i]);
     end;
//   Plot DFT
     if button4.Active then
     begin
//   Plot DFT P
       dftp:=dftFunc(p,jumdat);
       for i:=0 to Length(dftp) do
       begin
         Chart4LineSeries1.addxy(i*fs/jumdat,dftp[i]);
       end;
//   Plot DFT QRS
     dftqrs:=dftFunc(qrs,jumdat);
     for i:=0 to Length(dftqrs) do
     begin
     Chart4LineSeries2.addxy(i*fs/jumdat,dftqrs[i]);
     end;
//   PLOT DFT T
     dftT:=dftFunc(t,jumdat);
     for i:=0 to Length(dftT) do
     begin
     Chart4LineSeries3.addxy(i*fs/jumdat,dftT[i]);
     end;
     end;
end;

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
  Edit2.Text:=IntToStr(ScrollBar1.Position);
  Button5.Click;
end;

procedure TForm1.ScrollBar2Change(Sender: TObject);
begin
     Edit3.Text:=IntToStr(ScrollBar2.Position);
     Button6.Click;
end;

procedure TForm1.ScrollBar3Change(Sender: TObject);
begin
  Edit1.Text:=IntToStr(ScrollBar3.Position);
  Button3.Click;
end;

procedure TForm1.TabControl1Change(Sender: TObject);
begin
  ListBox1.items.add('change');
end;


end.

