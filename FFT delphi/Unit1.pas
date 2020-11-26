unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TeEngine, Series, ExtCtrls, TeeProcs, Chart,Math,
  VclTee.TeeGDIPlus;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Chart1: TChart;
    Series1: TLineSeries;
    Chart2: TChart;
    Chart3: TChart;
    Series3: TBarSeries;
    Series2: TBarSeries;
    Series4: TBarSeries;
    procedure Button1Click(Sender: TObject);
 procedure fft(t:extended);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  x1,amp,xi,xr,xasalr,xasali:array [-10000..10000] of extended;
  jumdat,i,N,panjang_fft, indexfft,fs:integer;


implementation

{$R *.dfm}
//main program
procedure TForm1.Button1Click(Sender: TObject);
  var i:integer;
begin
Series1.Clear;
jumdat:=512;
fs:=160;
for i:= 1 to jumdat do
  begin
   x1[i]:= 1.5+3*sin(2*pi*i/fs*20);
   Series1.AddXY(i,x1[i]);
  end;


 { assignfile(filename,'singledimsingal.dat');
  rewrite(filename);
  for i:= 1 to 512 do
  begin
    writeln(filename,i,' ',x1[i]);
  end;
  closefile(filename);}

  for i:= 1 to jumdat do
  begin
    xasalr[i]:=x1[i];
    xasali[i]:=0.0;
  end;

  N:=round(ln(jumdat)/ln(2));
  panjang_fft:=1 shl N  ;
  fft(1.0);


  indexfft:=jumdat div 2;

  for i:= indexfft+1  to panjang_fft do
  begin
    amp[i-indexfft]:= sqrt(xr[i]*xr[i]+xi[i]*xi[i])/(panjang_fft div 2);
  end;

  for i:= 1 to panjang_fft div 2 do
  begin
     amp[i+indexfft]:= sqrt(xr[i]*xr[i]+xi[i]*xi[i])/ (panjang_fft div 2);
  end;

  amp[indexfft+1]:= amp[indexfft+1]/2;

  for i:=0 to indexfft-1 do
  begin
    Series2.AddXY((i-1)*fs/jumdat,amp[i+indexfft]);
    Series4.AddXY((i-indexfft-1)*fs/jumdat,amp[i]);
  end;




end;

procedure Tform1.fft(t:extended);
label satu,dua,tiga,empat;
var
    lim1,lim2,lim3,l,r,m,k,i,j:integer;
    d,x1,x2,b1,b2,c1,c2,arg,sin1,cos1:extended;
begin
  m:= N;
  for k:= 1 to panjang_fft do
  begin
     xr[k]:=xasalr[k];
     xi[k]:=xasali[k];
  end;
  if t=1.0 then
    d:=1.0
  else
    d:=panjang_fft;

{suffle data input}


  lim1:=panjang_fft-1;
  lim1:=panjang_fft-1;
  lim2:= trunc(panjang_fft/2);
  j:= 1;
  for i:= 1 to lim1  do
  begin
    if i > j-1  then
    goto dua;
    x1:=xr[j];
    x2:=xi[j];
    xr[j]:=xr[i];
    xi[j]:=xi[i];
    xr[i]:=x1;
    xi[i]:=x2;
dua:
    l:=lim2;
tiga:
    if l > j-1 then goto empat;
    j:=j-l;
    l:=trunc(l/2);
    goto tiga;
empat:
    j:=j+l;
end;

 {inplace transformation}
//-----------------------
    for i:= 1 to m do
    begin
      lim1:= trunc(exp((i-1)*ln(2)));
      lim2:= trunc(exp((m-i)*ln(2)));
      for l:= 1 to lim2 do
      begin
        for r:= 1 to lim1 do
        begin
          lim3:= (r-1)+(l-1)*2*lim1+1;
          b1:=xr[lim3];
          b2:=xi[lim3];
          c1:=xr[lim3+lim1];
          c2:=xi[lim3+lim1];
          arg:=2*pi*(r-1)*lim2/panjang_fft;
          cos1:=cos(arg);
          sin1:=sin(arg);
          x1:=c1*cos1+c2*sin1*t;
          x2:=-c1*sin1*t+c2*cos1;
          xr[lim3]:=b1+x1;
          xi[lim3]:=b2+x2;

          xr[lim3+lim1]:=b1-x1;
          xi[lim3+lim1]:=b2-x2;
        end;
      end;

    end;

  for k:= 1 to panjang_fft do
  begin
     xr[k]:=xr[k]/d;
     xi[k]:=xi[k]/d;
  end;
end;



end.
