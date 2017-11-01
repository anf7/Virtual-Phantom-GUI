function Clear_DICOM_Callback(~,~,~)


global AXES1_HANDLE AXES2_HANDLE AXES3_HANDLE AXES4_HANDLE
global DICOM OBJECTS
global IMG1 IMG2 IMG3
global AX1_LINE_V AX1_LINE_H AX2_LINE_V AX2_LINE_H AX3_LINE_V AX3_LINE_H
global jRangeSlider sl

view(AXES4_HANDLE,[-30,30])

DICOM.numrows = 512;
DICOM.numcols = 512;
DICOM.numslices = 256;
DICOM.pixelsize = [0.9375,0.9375];
DICOM.slicespacing = 3;
DICOM.patientname = 'N/A';
DICOM.range = [-1000,3096];
DICOM.bpts1 = [];
DICOM.bpts2 = [];

DICOM.R = ((1:DICOM.numrows) - round(DICOM.numrows/2))*DICOM.pixelsize(1)/10;
DICOM.C = ((1:DICOM.numcols) - round(DICOM.numcols/2))*DICOM.pixelsize(2)/10;
DICOM.S = ((1:DICOM.numslices) - round(DICOM.numslices/2))*DICOM.slicespacing/10;
[DICOM.GridR,DICOM.GridC,DICOM.GridS] = ndgrid(DICOM.R,DICOM.C,DICOM.S);

[meshX,meshY,meshZ] = meshgrid(single(DICOM.R),single(DICOM.C),single(DICOM.S));
DICOM.xyz = ([meshX(:),meshY(:),meshZ(:)])';

DICOM.CR = DICOM.R(round(DICOM.numrows/2));
DICOM.CC = DICOM.C(round(DICOM.numcols/2));
DICOM.CS = DICOM.S(round(DICOM.numslices/2));

DICOM.RR = [min(DICOM.R),max(DICOM.R)];
DICOM.RC = [min(DICOM.C),max(DICOM.C)];
DICOM.RS = [min(DICOM.S),max(DICOM.S)];

DICOM.img = -1000*ones(512,512,256);
DICOM.temp_img = DICOM.img;
DICOM.img_original = DICOM.img;
DICOM.img_mask = false(size(DICOM.img));

axes(AXES1_HANDLE)
img1 = squeeze(DICOM.img(:,:,round(DICOM.numslices/2)));
set(IMG1,'CData',img1)
set(IMG1,'XData',DICOM.C)
set(IMG1,'YData',DICOM.R)
set(AXES1_HANDLE,'XLim',DICOM.RR)
set(AXES1_HANDLE,'YLim',DICOM.RC)

axes(AXES2_HANDLE)
img2 = squeeze(DICOM.img(:,round(DICOM.numcols/2),:));
set(IMG2,'CData',img2)
set(IMG2,'XData',DICOM.S)
set(IMG2,'YData',DICOM.R)
set(AXES2_HANDLE,'YLim',DICOM.RR)
set(AXES2_HANDLE,'XLim',DICOM.RS)

axes(AXES3_HANDLE)
img3 = (squeeze(DICOM.img(round(DICOM.numrows/2),:,:)))';
set(IMG3,'CData',img3)
set(IMG3,'XData',DICOM.C)
set(IMG3,'YData',DICOM.S)
set(AXES3_HANDLE,'XLim',DICOM.RC)
set(AXES3_HANDLE,'YLim',DICOM.RS)  


setPosition(AX1_LINE_V,double([DICOM.CC,DICOM.RR(1);DICOM.CC,DICOM.RR(2)]));
setPosition(AX1_LINE_H,double([DICOM.RC(1),DICOM.CR;DICOM.RC(2),DICOM.CR]));
setPosition(AX2_LINE_V,double([DICOM.CS,DICOM.RR(1);DICOM.CS,DICOM.RR(2)]));
setPosition(AX2_LINE_H,double([DICOM.RS(1),DICOM.CR;DICOM.RS(2),DICOM.CR]));
setPosition(AX3_LINE_V,double([DICOM.CC,DICOM.RS(1);DICOM.CC,DICOM.RS(2)]));
setPosition(AX3_LINE_H,double([DICOM.RC(1),DICOM.CS;DICOM.RC(2),DICOM.CS]));

set(jRangeSlider,'Minimum',DICOM.range(1))
set(jRangeSlider,'Maximum',DICOM.range(2))

set(jRangeSlider,'LowValue',DICOM.range(1));
set(jRangeSlider,'HighValue',DICOM.range(2));

set(sl,'Minimum',-1000,'Maximum',3096,'Value',0);

set(AXES1_HANDLE,'CLim',[DICOM.range(1),DICOM.range(2)])
set(AXES2_HANDLE,'CLim',[DICOM.range(1),DICOM.range(2)])
set(AXES3_HANDLE,'CLim',[DICOM.range(1),DICOM.range(2)])

set([AXES1_HANDLE,AXES2_HANDLE,AXES3_HANDLE],'CLim',DICOM.range)

Xrng = ((1:DICOM.numrows) - round(DICOM.numrows/2))*DICOM.pixelsize(1)/10;
Yrng = ((1:DICOM.numcols) - round(DICOM.numcols/2))*DICOM.pixelsize(2)/10;
Zrng = ((1:DICOM.numslices) - round(DICOM.numslices/2))*DICOM.slicespacing/10;

for n = 1:length(OBJECTS)
   if isequal(Xrng,OBJECTS(n).XRng) && isequal(Yrng,OBJECTS(n).YRng) && isequal(Zrng,OBJECTS(n).ZRng)...
            && DICOM.numrows == OBJECTS(n).XSz && DICOM.numcols == OBJECTS(n).YSz && DICOM.numslices == OBJECTS(n).ZSz
        if isnan(OBJECTS(n).HU);
            DICOM.img(OBJECTS(n).IntPts) = DICOM.img_original(OBJECTS(n).IntPts);
        else
            DICOM.img(OBJECTS(n).IntPts) = OBJECTS(n).HU;
        end
    else
        [~] = find_inner_points(OBJECTS(n).DataArray);

        hu = OBJECTS(n).DataArray(10);
        if OBJECTS(n).DataArray(11)
            DICOM.img(DICOM.img_mask) = DICOM.img_original(DICOM.img_mask);
        else
            DICOM.img(DICOM.img_mask) = hu;
        end
        int_pts = find(DICOM.img_mask);
        DICOM.img_mask = false(size(DICOM.img));

        OBJECTS(n).XRng = Xrng;
        OBJECTS(n).YRng = Yrng;
        OBJECTS(n).ZRng = Zrng;
        OBJECTS(n).XSz = DICOM.numrows;
        OBJECTS(n).YSz = DICOM.numcols;
        OBJECTS(n).ZSz = DICOM.numslices;
        OBJECTS(n).IntPts = int_pts;

    end        
end
 
xlim(AXES4_HANDLE,DICOM.RR)
ylim(AXES4_HANDLE,DICOM.RS)
zlim(AXES4_HANDLE,DICOM.RC)
Update_Axes
% Adjust_Shape(0)
Update_3D