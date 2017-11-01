function Initialize_DICOM

global AXES1_HANDLE AXES2_HANDLE AXES3_HANDLE AXES4_HANDLE AX_LINE_HANDLES
global DICOM
global IMG1 IMG2 IMG3
global AX1_LINE_V AX1_LINE_H AX2_LINE_V AX2_LINE_H AX3_LINE_V AX3_LINE_H
global SHAPEPATCH11 SHAPEPATCH12 SHAPEPATCH13 SHAPEPATCH14
global SHAPEPATCH21 SHAPEPATCH22 SHAPEPATCH23 SHAPEPATCH24
global SHAPEPATCH31 SHAPEPATCH32 SHAPEPATCH33 SHAPEPATCH34
global CENTERPOINTS CENTERPOINT1 CENTERPOINT2 CENTERPOINT3


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
DICOM.S = fliplr(((1:DICOM.numslices) - round(DICOM.numslices/2))*DICOM.slicespacing/10);
[DICOM.GridR,DICOM.GridC,DICOM.GridS] = ndgrid(DICOM.R,DICOM.C,DICOM.S);

DICOM.CR = DICOM.R(round(DICOM.numrows/2));
DICOM.CC = DICOM.C(round(DICOM.numcols/2));
DICOM.CS = DICOM.S(round(DICOM.numslices/2));

DICOM.RR = [min(DICOM.R),max(DICOM.R)];
DICOM.RC = [min(DICOM.C),max(DICOM.C)];
DICOM.RS = [min(DICOM.S),max(DICOM.S)];

[meshX,meshY,meshZ] = meshgrid(single(DICOM.R),single(DICOM.C),single(DICOM.S));
DICOM.xyz = ([meshX(:),meshY(:),meshZ(:)])';

xlim(AXES4_HANDLE,DICOM.RR)
ylim(AXES4_HANDLE,DICOM.RS)
zlim(AXES4_HANDLE,DICOM.RC)

DICOM.img = -1000*ones(512,512,256);
DICOM.temp_img = DICOM.img;
DICOM.img_original = DICOM.img;
DICOM.img_mask = false(size(DICOM.img));

axes(AXES1_HANDLE)
img1 = squeeze(DICOM.img(:,:,round(DICOM.numslices/2)));
IMG1 = imagesc(DICOM.C,DICOM.R,img1);
set(AXES1_HANDLE,'XLim',DICOM.RR)
set(AXES1_HANDLE,'YLim',DICOM.RC)
set(AXES1_HANDLE,'DataAspectRatio',[1,1,1]);
SHAPEPATCH11 = patch('XData',[],'YData',[]);
SHAPEPATCH12 = patch('XData',[],'YData',[]);
SHAPEPATCH13 = patch('XData',[],'YData',[]);
SHAPEPATCH14 = patch('XData',[],'YData',[],'EdgeColor','none','FaceColor','green','FaceAlpha',0.2);

axes(AXES2_HANDLE)
img2 = squeeze(DICOM.img(:,round(DICOM.numcols/2),:));
IMG2 = imagesc(DICOM.S,DICOM.R,img2);
set(AXES2_HANDLE,'YLim',DICOM.RR)
set(AXES2_HANDLE,'XLim',DICOM.RS)
set(AXES2_HANDLE,'DataAspectRatio',[1,1,1])
SHAPEPATCH21 = patch('XData',[],'YData',[]);
SHAPEPATCH22 = patch('XData',[],'YData',[]);
SHAPEPATCH23 = patch('XData',[],'YData',[]);
SHAPEPATCH24 = patch('XData',[],'YData',[],'EdgeColor','none','FaceColor','green','FaceAlpha',0.2);

axes(AXES3_HANDLE)
img3 = (squeeze(DICOM.img(round(DICOM.numrows/2),:,:)))';
IMG3 = imagesc(DICOM.C,DICOM.S,img3);
set(AXES3_HANDLE,'XLim',DICOM.RC)
set(AXES3_HANDLE,'YLim',DICOM.RS)
set(AXES3_HANDLE,'DataAspectRatio',[1,1,1])
SHAPEPATCH31 = patch('XData',[],'YData',[]);
SHAPEPATCH32 = patch('XData',[],'YData',[]);
SHAPEPATCH33 = patch('XData',[],'YData',[]);
SHAPEPATCH34 = patch('XData',[],'YData',[],'EdgeColor','none','FaceColor','green','FaceAlpha',0.2);

shapepatchhandles = [SHAPEPATCH11,SHAPEPATCH12,SHAPEPATCH13,SHAPEPATCH21,SHAPEPATCH22,...
    SHAPEPATCH23,SHAPEPATCH31,SHAPEPATCH32,SHAPEPATCH33];



set(shapepatchhandles,'EdgeColor','green','EdgeAlpha',0.3,'LineStyle','-','FaceColor','none');


AX1_LINE_V = imline(AXES1_HANDLE,double([DICOM.CC,DICOM.CC]),double(DICOM.RR),'PositionConstraintFcn',@cnstr_vline);
AX1_LINE_H = imline(AXES1_HANDLE,double(DICOM.RC),double([DICOM.CR,DICOM.CR]),'PositionConstraintFcn',@cnstr_hline);
AX2_LINE_V = imline(AXES2_HANDLE,double([DICOM.CS,DICOM.CS]),double(DICOM.RR),'PositionConstraintFcn',@cnstr_vline);
AX2_LINE_H = imline(AXES2_HANDLE,double(DICOM.RS),double([DICOM.CR,DICOM.CR]),'PositionConstraintFcn',@cnstr_hline);
AX3_LINE_V = imline(AXES3_HANDLE,double([DICOM.CC,DICOM.CC]),double(DICOM.RS),'PositionConstraintFcn',@cnstr_vline);
AX3_LINE_H = imline(AXES3_HANDLE,double(DICOM.RC),double([DICOM.CS,DICOM.CS]),'PositionConstraintFcn',@cnstr_hline);

AX_LINE_HANDLES = [AX1_LINE_V, AX1_LINE_H, AX2_LINE_V, AX2_LINE_H, AX3_LINE_V, AX3_LINE_H];

setColor(AX1_LINE_V,[0.5,0.5,1])
setColor(AX1_LINE_H,[0.5,0.5,1])
setColor(AX2_LINE_V,[0.5,0.5,1])
setColor(AX2_LINE_H,[0.5,0.5,1])
setColor(AX3_LINE_V,[0.5,0.5,1])
setColor(AX3_LINE_H,[0.5,0.5,1])

set([AXES1_HANDLE,AXES2_HANDLE,AXES3_HANDLE],'CLim',DICOM.range)

linechildren = zeros(1,length(AX_LINE_HANDLES));
for n = 1:length(AX_LINE_HANDLES)
    lc = get(AX_LINE_HANDLES(n),'Children');
    for p = 1:length(lc)
        if strcmp(lc(p).Tag,'end point 2') || strcmp(lc(p).Tag,'end point 1') || strcmp(lc(p).Tag,'bottom line')
            set(lc(p),'Visible','off')
        else
            linechildren(n) = lc(p);
        end
    end
end

set(linechildren,'LineStyle','--')

addlistener(linechildren(1),'XData','PostSet',@moveline1);
addlistener(linechildren(2),'YData','PostSet',@moveline1);
addlistener(linechildren(3),'XData','PostSet',@moveline2);
addlistener(linechildren(4),'YData','PostSet',@moveline2);
addlistener(linechildren(5),'XData','PostSet',@moveline3);
addlistener(linechildren(6),'YData','PostSet',@moveline3);


CENTERPOINT1 = impoint(AXES1_HANDLE,0,0);
CENTERPOINT2 = impoint(AXES2_HANDLE,0,0);
CENTERPOINT3 = impoint(AXES3_HANDLE,0,0);
CENTERPOINTS = [CENTERPOINT1,CENTERPOINT2,CENTERPOINT3];
ctrfcn1 = makeConstrainToRectFcn('impoint',get(AXES1_HANDLE,'XLim'),get(AXES1_HANDLE,'YLim'));
ctrfcn2 = makeConstrainToRectFcn('impoint',get(AXES2_HANDLE,'XLim'),get(AXES2_HANDLE,'YLim'));
ctrfcn3 = makeConstrainToRectFcn('impoint',get(AXES3_HANDLE,'XLim'),get(AXES3_HANDLE,'YLim'));
setPositionConstraintFcn(CENTERPOINT1,ctrfcn1);
setPositionConstraintFcn(CENTERPOINT2,ctrfcn2);
setPositionConstraintFcn(CENTERPOINT3,ctrfcn3);
addNewPositionCallback(CENTERPOINT1,@movepoint1);
addNewPositionCallback(CENTERPOINT2,@movepoint2);
addNewPositionCallback(CENTERPOINT3,@movepoint3);
set(CENTERPOINT1,'Visible','off')
set(CENTERPOINT2,'Visible','off')
set(CENTERPOINT3,'Visible','off')



function constr_pos = cnstr_vline(user_pos)
    xlimit = get(gca,'XLim');
    ylimit = get(gca,'YLim');
    constr_pos = user_pos;
    constr_pos(1,2) = ylimit(1);
    constr_pos(2,2) = ylimit(2);
    if user_pos(1,1) < xlimit(1)
        constr_pos(1,1) = xlimit(1);
    elseif user_pos(1,1) > xlimit(2)
        constr_pos(1,1) = xlimit(2);
    end
    constr_pos(2,1) = constr_pos(1,1);
end

function constr_pos = cnstr_hline(user_pos)
    xlimit = get(gca,'XLim');
    ylimit = get(gca,'YLim');
    constr_pos = user_pos;
    constr_pos(1,1) = xlimit(1);
    constr_pos(2,1) = xlimit(2);
    if user_pos(1,2) < ylimit(1)
        constr_pos(1,2) = ylimit(1);
    elseif user_pos(1,2) > ylimit(2)
        constr_pos(1,2) = ylimit(2);
    end
    constr_pos(2,2) = constr_pos(1,2);
end


end