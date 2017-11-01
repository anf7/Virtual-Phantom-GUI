function Update_3D

global AXES4_HANDLE
global OBJECTS DICOM

cla(AXES4_HANDLE)
axes(AXES4_HANDLE)
vval = get(AXES4_HANDLE,'View');
hold(AXES4_HANDLE,'on')


shading interp
material dull 
lightangle(270,180)

% maddX = [];
% maddY = [];
% maddZ = [];
% MaddX = [];
% MaddY = [];
% MaddZ = [];
facealpha = 0.1;
edgealpha = 0.2;
for n = 1:length(OBJECTS) 
    doss = [0,0,0]; 
    if ~isempty(OBJECTS(n).Xpts) && ~isempty(OBJECTS(n).Ypts) && ~isempty(OBJECTS(n).Zpts)
        x = OBJECTS(n).Ypts;
        y = -OBJECTS(n).Zpts;
        z = OBJECTS(n).Xpts;
        doss(1) = 1;
    end
    if ~isempty(OBJECTS(n).X0pts) && ~isempty(OBJECTS(n).Y0pts) && ~isempty(OBJECTS(n).Z0pts)
        x0 = OBJECTS(n).Y0pts;
        y0 = -OBJECTS(n).Z0pts;
        z0 = OBJECTS(n).X0pts;
        doss(2) = 1;
    end
    if ~isempty(OBJECTS(n).X1pts) && ~isempty(OBJECTS(n).Y1pts) && ~isempty(OBJECTS(n).Z1pts)
        x1 = OBJECTS(n).Y1pts;
        y1 = -OBJECTS(n).Z1pts;
        z1 = OBJECTS(n).X1pts;
        doss(3) = 1;
    end
    if sum(doss) == 1
        surf(AXES4_HANDLE,x,y,z,'FaceColor',[0.4,1,1],'FaceAlpha',facealpha,'LineStyle','none');
    elseif sum(doss) == 2
        surf(AXES4_HANDLE,x,y,z,'FaceColor',[0.4,1,1],'FaceAlpha',facealpha,'LineStyle','-','EdgeAlpha',edgealpha);
        surf(AXES4_HANDLE,x0,y0,z0,'FaceColor',[0.4,1,1],'FaceAlpha',facealpha,'LineStyle','none');
    elseif sum(doss) == 3
        surf(AXES4_HANDLE,x,y,z,'FaceColor',[0.4,1,1],'FaceAlpha',facealpha,'LineStyle','-','MeshStyle','row','EdgeAlpha',edgealpha);
        surf(AXES4_HANDLE,x0,y0,z0,'FaceColor',[0.4,1,1],'FaceAlpha',facealpha,'LineStyle','none');
        surf(AXES4_HANDLE,x1,y1,z1,'FaceColor',[0.4,1,1],'FaceAlpha',facealpha,'LineStyle','none');
    end  
%     maddX = min([min(x(:)),maddX]);
%     maddY = min([min(y(:)),maddY]);
%     maddZ = min([min(z(:)),maddZ]);
%     MaddX = max([max(x(:)),MaddX]);
%     MaddY = max([max(y(:)),MaddY]);
%     MaddZ = max([max(z(:)),MaddZ]);
end

% if ~isempty(OBJECTS)
%         
%     rx = MaddX - maddX;
%     ry = MaddY - maddY;
%     rz = MaddZ - maddZ;
% 
%     maxr = max([rx,ry,rz]);
% 
%     cx = maddX + 0.5*rx;
%     cy = maddY + 0.5*ry;
%     cz = maddZ + 0.5*rz;
% 
%     
%     rx = [cx - 0.62*maxr, cx + 0.62*maxr];
%     ry = [cy - 0.62*maxr, cy + 0.62*maxr];
%     rz = [cz - 0.62*maxr, cz + 0.62*maxr];
%     if isempty(DICOM.bpts)        
%         xlim(AXES4_HANDLE,rx)
%         ylim(AXES4_HANDLE,ry)
%         zlim(AXES4_HANDLE,rz)
%         set(AXES4_HANDLE,'DataAspectRatio',[1 1 1])
%     else
%         xlim(AXES4_HANDLE,[min([rx(1),DICOM.RR(1)]),max([rx(2),DICOM.RR(2)])])
%         ylim(AXES4_HANDLE,[min([ry(1),DICOM.RS(1)]),max([ry(2),DICOM.RS(2)])])
%         zlim(AXES4_HANDLE,[min([rz(1),DICOM.RC(1)]),max([rz(2),DICOM.RC(2)])])
%         set(AXES4_HANDLE,'DataAspectRatio',[1 1 1])
%     end
%     
% else
%     if isempty(DICOM.bpts) 
%         xlim(AXES4_HANDLE,[-1,1])
%         ylim(AXES4_HANDLE,[-1,1])
%         zlim(AXES4_HANDLE,[-1,1])
%         set(AXES4_HANDLE,'DataAspectRatio',[1 1 1])
%     else
%         xlim(AXES4_HANDLE,DICOM.RR)
%         ylim(AXES4_HANDLE,DICOM.RS)
%         zlim(AXES4_HANDLE,DICOM.RC)
%         set(AXES4_HANDLE,'DataAspectRatio',[1 1 1])
%     end
% end
set(AXES4_HANDLE,'DataAspectRatio',[1 1 1])
set(AXES4_HANDLE,'View',vval);


if ~isempty(DICOM.bpts1)
    hScatter1 = plot3(DICOM.bpts1(2,:),DICOM.bpts1(3,:),DICOM.bpts1(1,:),'.');
    set(hScatter1,'MarkerSize',1)
end
if ~isempty(DICOM.bpts2)
    hScatter2 = plot3(DICOM.bpts2(2,:),DICOM.bpts2(3,:),DICOM.bpts2(1,:),'.');
    set(hScatter2,'MarkerSize',1)
end

drawnow
