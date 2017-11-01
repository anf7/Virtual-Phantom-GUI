function Update_Axes

global DICOM
global IMG1 IMG2 IMG3
global AX1_LINE_V AX1_LINE_H AX2_LINE_V AX2_LINE_H AX3_LINE_V AX3_LINE_H
global AX1_TEXT AX2_TEXT AX3_TEXT

rpos = getPosition(AX1_LINE_H);
cpos = getPosition(AX1_LINE_V);
spos = getPosition(AX2_LINE_V);
DICOM.CR = round(rpos(1,2));
DICOM.CC = round(cpos(1,1));
DICOM.CS = round(spos(1,1));

[~,Rind] = min(abs(DICOM.R - DICOM.CR));
[~,Cind] = min(abs(DICOM.C - DICOM.CC));
[~,Sind] = min(abs(DICOM.S - DICOM.CS));

img1 = squeeze(DICOM.img(:,:,Sind));
set(IMG1,'CData',img1)
img2 = squeeze(DICOM.img(:,Cind,:));
set(IMG2,'CData',img2)
img3 = squeeze(DICOM.img(Rind,:,:))';
set(IMG3,'CData',img3)

setPosition(AX1_LINE_V,double([DICOM.CC,DICOM.RR(1);DICOM.CC,DICOM.RR(2)]));
setPosition(AX1_LINE_H,double([DICOM.RC(1),DICOM.CR;DICOM.RC(2),DICOM.CR]));
setPosition(AX2_LINE_V,double([DICOM.CS,DICOM.RR(1);DICOM.CS,DICOM.RR(2)]));
setPosition(AX2_LINE_H,double([DICOM.RS(1),DICOM.CR;DICOM.RS(2),DICOM.CR]));
setPosition(AX3_LINE_V,double([DICOM.CC,DICOM.RS(1);DICOM.CC,DICOM.RS(2)]));
setPosition(AX3_LINE_H,double([DICOM.RC(1),DICOM.CS;DICOM.RC(2),DICOM.CS]));

set(AX1_TEXT,'Position',[DICOM.RR(1),DICOM.RC(end),0],'String',[' Z = ',num2str(DICOM.CS)])
set(AX2_TEXT,'Position',[DICOM.RS(end),DICOM.RR(end),0],'String',[' X = ',num2str(DICOM.CC)])
set(AX3_TEXT,'Position',[DICOM.RC(1),DICOM.RS(1),0],'String',[' Y = ',num2str(DICOM.CR)])