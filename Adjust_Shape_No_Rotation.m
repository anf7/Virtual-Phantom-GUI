function Adjust_Shape_No_Rotation

global AXES4_HANDLE
global r1 r2 r3 r4 ckh
global e1 e2 e3 e4 e5 e6 e7 e8 e9 sl
global Xpts Ypts Zpts X0pts Y0pts Z0pts X1pts Y1pts Z1pts
global Xcenter Ycenter Zcenter
global OBJECTS DICOM dataarray
global AX1_LINE_V AX1_LINE_H AX2_LINE_V AX2_LINE_H AX3_LINE_V AX3_LINE_H IMG1 IMG2 IMG3 AX1_TEXT AX2_TEXT AX3_TEXT
global SHAPEPATCH11 SHAPEPATCH12 SHAPEPATCH13 SHAPEPATCH14
global SHAPEPATCH21 SHAPEPATCH22 SHAPEPATCH23 SHAPEPATCH24
global SHAPEPATCH31 SHAPEPATCH32 SHAPEPATCH33 SHAPEPATCH34
global CENTERPOINT1 CENTERPOINT2 CENTERPOINT3

% profile on

cla(AXES4_HANDLE)
axes(AXES4_HANDLE)
vval = get(AXES4_HANDLE,'View');
hold(AXES4_HANDLE,'on')

[Xcenter,Ycenter,Zcenter] = deal([]);

shading interp
material dull 
lightangle(270,180)

epsi = 10^-3;
sp_cy_pts = 32;

shapeID = find([get(r1,'Value'),get(r2,'Value'),...
    get(r3,'Value'),get(r4,'Value')]);

v1 = str2double(get(e1,'String'));
v2 = str2double(get(e2,'String'));
v3 = str2double(get(e3,'String'));
v4 = mod(360 - str2double(get(e4,'String')),360);
v5 = mod(360 - str2double(get(e5,'String')),360);
v6 = mod(360 - str2double(get(e6,'String')),360);
v4dsp = str2double(get(e4,'String'));
v5dsp = str2double(get(e5,'String'));
v6dsp = str2double(get(e6,'String'));
v7 = str2double(get(e7,'String'));
v8 = str2double(get(e8,'String'));
v9 = str2double(get(e9,'String'));
vs = get(sl,'Value');
transck = get(ckh,'Value');
maxdim = NaN;

dataarray = single([v1,v2,v3,v4,v5,v6,v7,v8,v9,vs,transck,maxdim]);

maddX = [];
maddY = [];
maddZ = [];
MaddX = [];
MaddY = [];
MaddZ = [];
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
    maddX = min([min(x(:)),maddX]);
    maddY = min([min(y(:)),maddY]);
    maddZ = min([min(z(:)),maddZ]);
    MaddX = max([max(x(:)),MaddX]);
    MaddY = max([max(y(:)),MaddY]);
    MaddZ = max([max(z(:)),MaddZ]);
end


if isnumeric(dataarray) && all(~isnan(dataarray(1:11)))

x = [];
y = [];
z = [];
x0 = [];
y0 = [];
z0 = [];
x1 = [];
y1 = [];
z1 = [];
obj1 = false;
obj2 = false;
obj3 = false;
if shapeID == 1 && v7 > 0 && v8 > 0 && v9 > 0 && strcmp(get(e1,'Enable'),'on')
    
    [x,y,z] = sphere(sp_cy_pts);
    x = x*v7/2;
    y = y*v9/2;
    z = z*v8/2;
    
    maxdim = max([max(x(:)) - min(x(:)),max(y(:)) - min(y(:)),max(z(:)) - min(z(:))]);
    
    [x,y,z] = Rotate_3D(x,y,z,[0,1,0],v5,[0,0,0]);
    [x,y,z] = Rotate_3D(x,y,z,[sind(v5+90),0,cosd(v5+90)],v4,[0,0,0]); 
    axr = [-cosd(v5+90)*sind(v4),cosd(v4),sind(v5+90)*sind(v4)];
    [x,y,z] = Rotate_3D(x,y,z,axr,v6,[0,0,0]);
    
    x = x + v1;
    y = y + v3;
    z = z + v2;
    
    
    s = surf(AXES4_HANDLE,x*(1+epsi),y*(1+epsi),z*(1+epsi),'LineStyle','none','FaceLighting','gouraud');
       
    obj1 = true;
    
    
    
elseif shapeID == 2 && v7 > 0 && v8 > 0 && v9 > 0 && strcmp(get(e1,'Enable'),'on')
    
    
    [x,z,y] = cylinder(1,sp_cy_pts);
    
    x = x*v7/2;
    y = v9*(y - 0.5);  
    z = z*v8/2;
    
    maxdim = max([sqrt((max(x(:)) - min(x(:)))^2 + v9^2),sqrt((max(z(:)) - min(z(:)))^2 + v9^2)]);
    
    [x0,y0,z0] = deal(zeros(size(x)));
    x0(1,:) = x(1,:);
    z0(1,:) = z(1,:);
    y0(1,:)= y(1,:);
    y0(2,:)= y(1,:);
    
    [x1,y1,z1] = deal(zeros(size(x)));
    x1(1,:) = x(2,:);
    z1(1,:) = z(2,:);
    y1(1,:)= y(2,:);
    y1(2,:)= y(2,:);
    
    [x,y,z] = Rotate_3D(x,y,z,[0,1,0],v5,[0,0,0]);
    [x,y,z] = Rotate_3D(x,y,z,[sind(v5+90),0,cosd(v5+90)],v4,[0,0,0]); 
    axr = [-cosd(v5+90)*sind(v4),cosd(v4),sind(v5+90)*sind(v4)];
    [x,y,z] = Rotate_3D(x,y,z,axr,v6,[0,0,0]);
    
    [x0,y0,z0] = Rotate_3D(x0,y0,z0,[0,1,0],v5,[0,0,0]);
    [x0,y0,z0] = Rotate_3D(x0,y0,z0,[sind(v5+90),0,cosd(v5+90)],v4,[0,0,0]); 
    axr = [-cosd(v5+90)*sind(v4),cosd(v4),sind(v5+90)*sind(v4)];
    [x0,y0,z0] = Rotate_3D(x0,y0,z0,axr,v6,[0,0,0]);
    
    [x1,y1,z1] = Rotate_3D(x1,y1,z1,[0,1,0],v5,[0,0,0]);
    [x1,y1,z1] = Rotate_3D(x1,y1,z1,[sind(v5+90),0,cosd(v5+90)],v4,[0,0,0]); 
    axr = [-cosd(v5+90)*sind(v4),cosd(v4),sind(v5+90)*sind(v4)];
    [x1,y1,z1] = Rotate_3D(x1,y1,z1,axr,v6,[0,0,0]);
   
    
    x = x + v1;
    y = y + v3;
    z = z + v2;
    x0 = x0 + v1;
    y0 = y0 + v3;
    z0 = z0 + v2;
    x1 = x1 + v1;
    y1 = y1 + v3;
    z1 = z1 + v2;
    
    s = surf(AXES4_HANDLE,x*(1+epsi),y*(1+epsi),z*(1+epsi),'LineStyle','-','MeshStyle','row','FaceLighting','gouraud');
    s0 = surf(AXES4_HANDLE,x0*(1+epsi),y0*(1+epsi),z0*(1+epsi),'LineStyle','none','FaceLighting','gouraud');
    s1 = surf(AXES4_HANDLE,x1*(1+epsi),y1*(1+epsi),z1*(1+epsi),'LineStyle','none','FaceLighting','gouraud');
    
    obj1 = true;
    obj2 = true;
    obj3 = true;
    
elseif shapeID == 3 && v7 > 0 && v8 > 0 && v9 > 0 && strcmp(get(e1,'Enable'),'on')
        
    z = zeros(2,5);
    
    x = [v7,-v7,-v7,v7,v7;v7,-v7,-v7,v7,v7]/2;
    y = [v9,v9,-v9,-v9,v9;v9,v9,-v9,-v9,v9]/2;
    z(1,:) = v8/2;
    z(2,:) = -v8/2;
    
    maxdim = sqrt(v7^2 + v8^2 + v9^2);
    
    
    [x,y,z] = Rotate_3D(x,y,z,[0,1,0],v5,[0,0,0]);
    [x,y,z] = Rotate_3D(x,y,z,[sind(v5+90),0,cosd(v5+90)],v4,[0,0,0]); 
    axr = [-cosd(v5+90)*sind(v4),cosd(v4),sind(v5+90)*sind(v4)];
    [x,y,z] = Rotate_3D(x,y,z,axr,v6,[0,0,0]);
       
    x = x + v1;
    y = y + v3;
    z = z + v2;
    
    [x0,y0,z0] = deal(zeros(4,5));
    
    x0(2:3,:) = x;
    y0(2:3,:) = y;
    z0(2:3,:) = z;
    x0(1,:) = x(1,1);
    x0(4,:) = x(2,1);
    y0(1,:) = y(1,1);
    y0(4,:) = y(2,1);
    z0(1,:) = z(1,1);
    z0(4,:) = z(2,1);
    
    s = surf(AXES4_HANDLE,x*(1+epsi),y*(1+epsi),z*(1+epsi),'LineStyle','-','LineWidth',0.5,'FaceLighting','gouraud');
    s0 = surf(AXES4_HANDLE,x0*(1+epsi),y0*(1+epsi),z0*(1+epsi),'LineStyle','none','LineWidth',0.5,'FaceLighting','gouraud');
    obj1 = true;
    obj2 = true;
    
end


dataarray(12) = single(maxdim);

if ~isempty(DICOM.bpts1)
    hScatter1 = plot3(DICOM.bpts1(2,:),DICOM.bpts1(3,:),DICOM.bpts1(1,:),'b.');
    set(hScatter1,'MarkerSize',1)
end
if ~isempty(DICOM.bpts2)
    hScatter2 = plot3(DICOM.bpts2(2,:),DICOM.bpts2(3,:),DICOM.bpts2(1,:),'r.');
    set(hScatter2,'MarkerSize',1)
end


if slID == 4 && v7 > 0 && v8 > 0 && v9 > 0 && strcmp(get(e1,'Enable'),'on')
    
    line(v1+0.55*maxdim*[sind(v5+90),-sind(v5+90)],...
        v3+[0,0],...
        v2+0.55*maxdim*[cosd(v5+90),-cosd(v5+90)],...
        'Linewidth',2,...
        'Color',[0.3,0.3,1.0],...
        'Parent',AXES4_HANDLE)
    
    [px,py,pz] = deal(zeros(1,v4dsp+2));
    for n = 1:v4dsp+1  
        px(1,n) = v1+0.55*maxdim*cosd(v5+90)*sind(n-1);
        py(1,n) = v3+0.55*maxdim*cosd(n-1);
        pz(1,n) = v2+0.55*maxdim*sind(v5+270)*sind(n-1);
    end
    px(1,v4dsp+2) = v1;
    py(1,v4dsp+2) = v3;
    pz(1,v4dsp+2) = v2;
    
%     if v4dsp > 10
%         spandeg = 10;
%         Arrow3d([px(1,v4dsp-spandeg),py(1,v4dsp-spandeg),pz(1,v4dsp-spandeg)],[px(1,v4dsp+1),py(1,v4dsp+1),pz(1,v4dsp+1)]);
%     end
    
    patch('XData',px,'YData',py,'ZData',pz,'FaceColor',[0.3,0.3,1],'FaceAlpha',0.3,'Parent',AXES4_HANDLE)
    
    
    [px2,py2,pz2] = deal(zeros(1,360-v4dsp+2));
    for n = 1:360-v4dsp+1  
        px2(1,n) = v1+0.55*maxdim*cosd(v5+90)*sind(n+v4dsp-1);
        py2(1,n) = v3+0.55*maxdim*cosd(n+v4dsp-1);
        pz2(1,n) = v2+0.55*maxdim*sind(v5+270)*sind(n+v4dsp-1);
    end
    px2(1,360-v4dsp+2) = v1;
    py2(1,360-v4dsp+2) = v3;
    pz2(1,360-v4dsp+2) = v2;
    patch('XData',px2,'YData',py2,'ZData',pz2,'FaceColor',[0.7,0.7,0.7],'FaceAlpha',0.1,'EdgeColor','none','EdgeAlpha',0.1)
    
%     if v4dsp <= 10
%         spandeg = 10;
%         Arrow3d([px2(1,360-spandeg),py2(1,360-spandeg),pz2(1,360-spandeg)],[px(1,v4dsp+1),py(1,v4dsp+1),pz(1,v4dsp+1)]);
%     end
    
elseif slID == 5 && v7 > 0 && v8 > 0 && v9 > 0 && strcmp(get(e1,'Enable'),'on')
        
    line(v1+[0,0],...
        v3+0.55*maxdim*[-1,1],...
        v2+[0,0],...
        'Linewidth',2,...
        'Color',[0.3,0.3,1.0])
    
    [px,py,pz] = deal(zeros(1,v5dsp+2));
    for n = 1:v5dsp+1  
        px(1,n) = v1-0.55*maxdim*cosd(n+90-1);
        py(1,n) = v3;
        pz(1,n) = v2+0.55*maxdim*sind(n+270-1);
    end
    px(1,v5dsp+2) = v1;
    py(1,v5dsp+2) = v3;
    pz(1,v5dsp+2) = v2;
    
%     if v5dsp > 10
%         spandeg = 10;
%         Arrow3d([px(1,v5dsp-spandeg),py(1,v5dsp-spandeg),pz(1,v5dsp-spandeg)],[px(1,v5dsp+1),py(1,v5dsp+1),pz(1,v5dsp+1)]);
%     end
    
    patch('XData',px,'YData',py,'ZData',pz,'FaceColor',[0.3,0.3,1],'FaceAlpha',0.3)
    
    
    [px2,py2,pz2] = deal(zeros(1,360-v5dsp+2));
    for n = 1:360-v5dsp+1  
        px2(1,n) = v1-0.55*maxdim*cosd(n+v5dsp+90-1);
        py2(1,n) = v3;
        pz2(1,n) = v2+0.55*maxdim*sind(n+v5dsp+270-1); 
    end
    px2(1,360-v5dsp+2) = v1;
    py2(1,360-v5dsp+2) = v3;
    pz2(1,360-v5dsp+2) = v2;
    patch('XData',px2,'YData',py2,'ZData',pz2,'FaceColor',[0.7,0.7,0.7],'FaceAlpha',0.1,'EdgeColor','none','EdgeAlpha',0.1)
    
%     if v5dsp <= 10
%         spandeg = 10;
%         Arrow3d([px2(1,360-spandeg),py2(1,360-spandeg),pz2(1,360-spandeg)],[px(1,v5dsp+1),py(1,v5dsp+1),pz(1,v5dsp+1)]);
%     end
    
elseif slID == 6 && v7 > 0 && v8 > 0 && v9 > 0 && strcmp(get(e1,'Enable'),'on')
    line(v1+0.55*maxdim*[cosd(v5+90)*sind(v4),-cosd(v5+90)*sind(v4)],...
        v3+0.55*maxdim*[-cosd(v4),cosd(v4)],...
        v2+0.55*maxdim*[-sind(v5+90)*sind(v4),sind(v5+90)*sind(v4)],...
        'Linewidth',2,...
        'Color',[0.3,0.3,1.0])
    
    
    [px,py,pz] = deal(zeros(1,v6dsp+2));
    
    for n = 1:v6dsp+1  
        sx = -0.55*maxdim*cosd(n+90+v5dsp-1);
        sy = 0;
        sz = 0.55*maxdim*sind(n+270+v5dsp-1);
        [px(1,n),py(1,n),pz(1,n)] = Rotate_3D(sx,sy,sz,[sind(v5dsp+270),0,cosd(v5dsp+90)],v4dsp,[0,0,0]);
    end
    px(1,v6dsp+2) = 0;
    py(1,v6dsp+2) = 0;
    pz(1,v6dsp+2) = 0;
    
%     if v6dsp > 10
%         spandeg = 10;
%         Arrow3d([px(1,v6dsp-spandeg)+v1,py(1,v6dsp-spandeg)+v3,pz(1,v6dsp-spandeg)+v2],[px(1,v6dsp+1)+v1,py(1,v6dsp+1)+v3,pz(1,v6dsp+1)+v2]);
%     end
    
    patch('XData',px+v1,'YData',py+v3,'ZData',pz+v2,'FaceColor',[0.3,0.3,1],'FaceAlpha',0.3,'EdgeAlpha',0.7)
    
    [px2,py2,pz2] = deal(zeros(1,360-v6dsp+2));
    for n = 1:360-v6dsp+1  
        sx = -0.55*maxdim*cosd(n+v6dsp+v5dsp+90-1);
        sy = 0;
        sz = 0.55*maxdim*sind(n+v6dsp+v5dsp+270-1);
        [px2(1,n),py2(1,n),pz2(1,n)] = Rotate_3D(sx,sy,sz,[sind(v5dsp+270),0,cosd(v5dsp+90)],v4dsp,[0,0,0]); 
    end
    px2(1,360-v6dsp+2) = 0;
    py2(1,360-v6dsp+2) = 0;
    pz2(1,360-v6dsp+2) = 0;
    patch('XData',px2+v1,'YData',py2+v3,'ZData',pz2+v2,'FaceColor',[0.7,0.7,0.7],'FaceAlpha',0.1,'EdgeColor','none','EdgeAlpha',0.1)
    
%     if v6dsp <= 10
%         spandeg = 10;
%         Arrow3d([px2(1,360-spandeg)+v1,py2(1,360-spandeg)+v3,pz2(1,360-spandeg)+v2],[px(1,v6dsp+1)+v1,py(1,v6dsp+1)+v3,pz(1,v6dsp+1)+v2]);
%     end
    
end

falpha = 0.97;
if obj1
    
    
    s.FaceColor = [1,1,1];
    s.FaceLighting = 'gouraud';
    s.AmbientStrength = 0.7;
    s.DiffuseStrength = 0.3;
    s.SpecularStrength = 0.3;
    s.SpecularExponent = 10;
    s.BackFaceLighting = 'unlit';
    s.FaceAlpha = falpha;
    
    if obj2
        s0.FaceColor = [1,1,1];
        s0.FaceLighting = 'gouraud';
        s0.AmbientStrength = 0.65;
        s0.DiffuseStrength = 0.3;
        s0.SpecularStrength = 0.3;
        s0.SpecularExponent = 10;
        s0.BackFaceLighting = 'unlit';
        s0.FaceAlpha = falpha;
        
        if obj3   
            s1.FaceColor = [1,1,1];
            s1.FaceLighting = 'gouraud';
            s1.AmbientStrength = 0.65;
            s1.DiffuseStrength = 0.3;
            s1.SpecularStrength = 0.3;
            s1.SpecularExponent = 10;
            s1.BackFaceLighting = 'unlit';
            s1.FaceAlpha = falpha;
        end
        
    end
    
    set(AXES4_HANDLE,'View',vval);
    
end




drawnow

if obj1
    Xcenter = v1;
    Ycenter = v2;
    Zcenter = v3;

    if Xcenter < DICOM.RR(1)
        Xcenter = DICOM.RR(1);
    elseif Xcenter > DICOM.RR(2)
        Xcenter = DICOM.RR(2);
    end
    if Ycenter < DICOM.RS(1)
        Ycenter = DICOM.RS(1);
    elseif Ycenter > DICOM.RS(2)
        Ycenter = DICOM.RS(2);
    end
    if Zcenter < DICOM.RC(1)
        Zcenter = DICOM.RC(1);
    elseif Zcenter > DICOM.RC(2)
        Zcenter = DICOM.RC(2);
    end

    Ypts = x;
    Zpts = -y;
    Xpts = z;
    Y0pts = x0;
    Z0pts = -y0;
    X0pts = z0;
    Y1pts = x1;
    Z1pts = -y1;
    X1pts = z1;
    
    Rpts = z;
    Cpts = x;
    Spts = y;
    
    
    rpos = getPosition(AX1_LINE_H);
    cpos = getPosition(AX1_LINE_V);
    spos = getPosition(AX2_LINE_V);
    DICOM.CR = round(rpos(1,2));
    DICOM.CC = round(cpos(1,1));
    DICOM.CS = round(spos(1,1));

    [~,Rind] = min(abs(DICOM.R - DICOM.CR));
    [~,Cind] = min(abs(DICOM.C - DICOM.CC));
    [~,Sind] = min(abs(DICOM.S - DICOM.CS));
    
    bmaskax1 = find_inner_slice_points(dataarray,Sind,3,[DICOM.numrows,DICOM.numcols]);
    bmaskax2 = find_inner_slice_points(dataarray,Cind,2,[DICOM.numrows,DICOM.numslices]);
    bmaskax3 = find_inner_slice_points(dataarray,Rind,1,[DICOM.numcols,DICOM.numslices]);
    
    img1 = squeeze(DICOM.img(:,:,Sind));
    if any(bmaskax1(:))
        if get(ckh,'Value')
            oimg = squeeze(DICOM.img_original(:,:,Sind));
            img1(bmaskax1) = oimg(bmaskax1);
        else
            img1(bmaskax1) = vs;
        end
    end
    set(IMG1,'CData',img1)
    
    img2 = squeeze(DICOM.img(:,Cind,:));
    if any(bmaskax2(:))
        if get(ckh,'Value')
            oimg = squeeze(DICOM.img_original(:,Cind,:));
            img2(bmaskax2) = oimg(bmaskax2);
        else
            img2(bmaskax2) = vs;
        end
    end
    set(IMG2,'CData',img2)
    
    img3 = squeeze(DICOM.img(Rind,:,:));
    if any(bmaskax3(:))
        if get(ckh,'Value')
            oimg = squeeze(DICOM.img_original(Rind,:,:));
            img3(bmaskax3) = oimg(bmaskax3);
        else
            img3(bmaskax3) = vs;
        end
    end
    img3 = img3';
    set(IMG3,'CData',img3)
    
    p14 = round(sp_cy_pts/4) + 1;
    p12 = round(sp_cy_pts/2) + 1;
    p34 = round(3*sp_cy_pts/4) + 1;
    
    
    setPosition(CENTERPOINT1,v1,v2)
    setPosition(CENTERPOINT2,v3,v2)
    setPosition(CENTERPOINT3,v1,v3)
    
    
    if shapeID == 1 && v7 > 0 && v8 > 0 && v9 > 0 && strcmp(get(e1,'Enable'),'on')          
        
        hullpts = convhull(Rpts(:),Cpts(:));
        Hpts = false(size(Cpts));
        Hpts(hullpts) = true;
        Cptsflp = [Cpts(:,1);flipud(Cpts(:,p12))]';
        Rptsflp = [Rpts(:,1);flipud(Rpts(:,p12))]';
        Sptsflp = [Spts(:,1);flipud(Spts(:,p12))]';
        Hptsflp = [Hpts(:,1);flipud(Hpts(:,p12))]';
        [xdata,ydata] = objfront(Cptsflp,Rptsflp,Sptsflp,Hptsflp);
        set(SHAPEPATCH11,'XData',xdata,'YData',ydata)
        Cptsflp = [Cpts(:,p14);flipud(Cpts(:,p34))]';
        Rptsflp = [Rpts(:,p14);flipud(Rpts(:,p34))]';
        Sptsflp = [Spts(:,p14);flipud(Spts(:,p34))]';
        Hptsflp = [Hpts(:,p14);flipud(Hpts(:,p34))]';
        [xdata,ydata] = objfront(Cptsflp,Rptsflp,Sptsflp,Hptsflp);
        set(SHAPEPATCH12,'XData',xdata,'YData',ydata)
        [xdata,ydata] = objfront(Cpts(p12,:),Rpts(p12,:),Spts(p12,:),Hpts(p12,:));
        set(SHAPEPATCH13,'XData',xdata,'YData',ydata)
        set(SHAPEPATCH14,'XData',Cpts(hullpts),'YData',Rpts(hullpts))
        set(SHAPEPATCH14,'EdgeColor','green')
        
        
        hullpts = convhull(Rpts(:),Spts(:));
        Hpts = false(size(Spts));
        Hpts(hullpts) = true;
        Sptsflp = [Spts(:,1);flipud(Spts(:,p12))]';
        Rptsflp = [Rpts(:,1);flipud(Rpts(:,p12))]';
        Cptsflp = [Cpts(:,1);flipud(Cpts(:,p12))]';
        Hptsflp = [Hpts(:,1);flipud(Hpts(:,p12))]';
        [xdata,ydata] = objfront(Sptsflp,Rptsflp,Cptsflp,Hptsflp);
        set(SHAPEPATCH21,'XData',xdata,'YData',ydata)
        Sptsflp = [Spts(:,p14);flipud(Spts(:,p34))]';
        Rptsflp = [Rpts(:,p14);flipud(Rpts(:,p34))]';
        Cptsflp = [Cpts(:,p14);flipud(Cpts(:,p34))]';
        Hptsflp = [Hpts(:,p14);flipud(Hpts(:,p34))]';
        [xdata,ydata] = objfront(Sptsflp,Rptsflp,Cptsflp,Hptsflp);
        set(SHAPEPATCH22,'XData',xdata,'YData',ydata)
        [xdata,ydata] = objfront(Spts(p12,:),Rpts(p12,:),Cpts(p12,:),Hpts(p12,:));
        set(SHAPEPATCH23,'XData',xdata,'YData',ydata)
        set(SHAPEPATCH24,'XData',Spts(hullpts),'YData',Rpts(hullpts))
        set(SHAPEPATCH24,'EdgeColor','green')
        
        
        hullpts = convhull(Spts(:),Cpts(:));
        Hpts = false(size(Cpts));
        Hpts(hullpts) = true;
        Cptsflp = [Cpts(:,1);flipud(Cpts(:,p12))]';
        Sptsflp = [Spts(:,1);flipud(Spts(:,p12))]';
        Rptsflp = [Rpts(:,1);flipud(Rpts(:,p12))]';
        Hptsflp = [Hpts(:,1);flipud(Hpts(:,p12))]';
        [xdata,ydata] = objfront(Cptsflp,Sptsflp,Rptsflp,Hptsflp);
        set(SHAPEPATCH31,'XData',xdata,'YData',ydata)
        Cptsflp = [Cpts(:,p14);flipud(Cpts(:,p34))]';
        Sptsflp = [Spts(:,p14);flipud(Spts(:,p34))]';
        Rptsflp = [Rpts(:,p14);flipud(Rpts(:,p34))]';
        Hptsflp = [Hpts(:,p14);flipud(Hpts(:,p34))]';
        [xdata,ydata] = objfront(Cptsflp,Sptsflp,Rptsflp,Hptsflp);
        set(SHAPEPATCH32,'XData',xdata,'YData',ydata)
        [xdata,ydata] = objfront(Cpts(p12,:),Spts(p12,:),Rpts(p12,:),Hpts(p12,:));
        set(SHAPEPATCH33,'XData',xdata,'YData',ydata)
        set(SHAPEPATCH34,'XData',Cpts(hullpts),'YData',Spts(hullpts))
        set(SHAPEPATCH34,'EdgeColor','green')

    elseif shapeID == 2 && v7 > 0 && v8 > 0 && v9 > 0 && strcmp(get(e1,'Enable'),'on')
      
        hullpts = convhull(Rpts(:),Cpts(:));
        mv = max(Spts,[],2);
        if mv(1) >= mv(2)
            set(SHAPEPATCH11,'XData',[],'YData',[])
            set(SHAPEPATCH12,'XData',Cpts(2,:),'YData',Rpts(2,:))
        else
            set(SHAPEPATCH11,'XData',Cpts(1,:),'YData',Rpts(1,:))
            set(SHAPEPATCH12,'XData',[],'YData',[])
        end
        set(SHAPEPATCH13,'XData',Cpts(hullpts),'YData',Rpts(hullpts))
        set(SHAPEPATCH14,'XData',Cpts(hullpts),'YData',Rpts(hullpts))
        set(SHAPEPATCH14,'EdgeColor','none')
        
        
        hullpts = convhull(Rpts(:),Spts(:));
        mv = max(Cpts,[],2);
        if mv(1) >= mv(2)
            set(SHAPEPATCH21,'XData',[],'YData',[])
            set(SHAPEPATCH22,'XData',Spts(2,:),'YData',Rpts(2,:))
        else
            set(SHAPEPATCH21,'XData',Spts(1,:),'YData',Rpts(1,:))
            set(SHAPEPATCH22,'XData',[],'YData',[])
        end
        set(SHAPEPATCH23,'XData',Spts(hullpts),'YData',Rpts(hullpts))
        set(SHAPEPATCH24,'XData',Spts(hullpts),'YData',Rpts(hullpts))
        set(SHAPEPATCH24,'EdgeColor','none')
        
        
        hullpts = convhull(Spts(:),Cpts(:));
        mv = max(Rpts,[],2);
        if mv(1) >= mv(2)
            set(SHAPEPATCH31,'XData',[],'YData',[])
            set(SHAPEPATCH32,'XData',Cpts(2,:),'YData',Spts(2,:))
        else
            set(SHAPEPATCH31,'XData',Cpts(1,:),'YData',Spts(1,:))
            set(SHAPEPATCH32,'XData',[],'YData',[])
        end
        set(SHAPEPATCH33,'XData',Cpts(hullpts),'YData',Spts(hullpts))
        set(SHAPEPATCH34,'XData',Cpts(hullpts),'YData',Spts(hullpts))
        set(SHAPEPATCH34,'EdgeColor','none')
        
    elseif shapeID == 3 && v7 > 0 && v8 > 0 && v9 > 0 && strcmp(get(e1,'Enable'),'on')
        
        hullpts = convhull(Rpts(:),Cpts(:));     
        mv = max(Spts,[],2);
        if mv(1) <= mv(2)
            set(SHAPEPATCH11,'XData',Cpts(1,:),'YData',Rpts(1,:))
        else
            set(SHAPEPATCH11,'XData',Cpts(2,:),'YData',Rpts(2,:))
        end
        S1 = Spts(:,1:2);
        S2 = Spts(:,3:4);
        if max(S1(:)) <= max(S2(:))
            set(SHAPEPATCH12,'XData',[Cpts(1,1:2),fliplr(Cpts(2,1:2))],'YData',[Rpts(1,1:2),fliplr(Rpts(2,1:2))]) 
        else
            set(SHAPEPATCH12,'XData',[Cpts(1,3:4),fliplr(Cpts(2,3:4))],'YData',[Rpts(1,3:4),fliplr(Rpts(2,3:4))]) 
        end
        S1 = Spts(:,2:3);
        S2 = Spts(:,4:5);
        if max(S1(:)) <= max(S2(:))
            set(SHAPEPATCH13,'XData',[Cpts(1,2:3),fliplr(Cpts(2,2:3))],'YData',[Rpts(1,2:3),fliplr(Rpts(2,2:3))]) 
        else
            set(SHAPEPATCH13,'XData',[Cpts(1,4:5),fliplr(Cpts(2,4:5))],'YData',[Rpts(1,4:5),fliplr(Rpts(2,4:5))]) 
        end
        
        set(SHAPEPATCH14,'XData',Cpts(hullpts),'YData',Rpts(hullpts))
        set(SHAPEPATCH14,'EdgeColor','none')
        
        
        hullpts = convhull(Rpts(:),Spts(:));     
        mv = max(Cpts,[],2);
        if mv(1) <= mv(2)
            set(SHAPEPATCH21,'XData',Spts(1,:),'YData',Rpts(1,:))
        else
            set(SHAPEPATCH21,'XData',Spts(2,:),'YData',Rpts(2,:))
        end
        S1 = Cpts(:,1:2);
        S2 = Cpts(:,3:4);
        if max(S1(:)) <= max(S2(:))
            set(SHAPEPATCH22,'XData',[Spts(1,1:2),fliplr(Spts(2,1:2))],'YData',[Rpts(1,1:2),fliplr(Rpts(2,1:2))]) 
        else
            set(SHAPEPATCH22,'XData',[Spts(1,3:4),fliplr(Spts(2,3:4))],'YData',[Rpts(1,3:4),fliplr(Rpts(2,3:4))]) 
        end
        S1 = Cpts(:,2:3);
        S2 = Cpts(:,4:5);
        if max(S1(:)) <= max(S2(:))
            set(SHAPEPATCH23,'XData',[Spts(1,2:3),fliplr(Spts(2,2:3))],'YData',[Rpts(1,2:3),fliplr(Rpts(2,2:3))]) 
        else
            set(SHAPEPATCH23,'XData',[Spts(1,4:5),fliplr(Spts(2,4:5))],'YData',[Rpts(1,4:5),fliplr(Rpts(2,4:5))]) 
        end
        
        set(SHAPEPATCH24,'XData',Spts(hullpts),'YData',Rpts(hullpts))
        set(SHAPEPATCH24,'EdgeColor','none')
        
        
        hullpts = convhull(Spts(:),Cpts(:));     
        mv = max(Rpts,[],2);
        if mv(1) <= mv(2)
            set(SHAPEPATCH31,'XData',Cpts(1,:),'YData',Spts(1,:))
        else
            set(SHAPEPATCH31,'XData',Cpts(2,:),'YData',Spts(2,:))
        end
        S1 = Rpts(:,1:2);
        S2 = Rpts(:,3:4);
        if max(S1(:)) <= max(S2(:))
            set(SHAPEPATCH32,'XData',[Cpts(1,1:2),fliplr(Cpts(2,1:2))],'YData',[Spts(1,1:2),fliplr(Spts(2,1:2))]) 
        else
            set(SHAPEPATCH32,'XData',[Cpts(1,3:4),fliplr(Cpts(2,3:4))],'YData',[Spts(1,3:4),fliplr(Spts(2,3:4))]) 
        end
        S1 = Rpts(:,2:3);
        S2 = Rpts(:,4:5);
        if max(S1(:)) <= max(S2(:))
            set(SHAPEPATCH33,'XData',[Cpts(1,2:3),fliplr(Cpts(2,2:3))],'YData',[Spts(1,2:3),fliplr(Spts(2,2:3))]) 
        else
            set(SHAPEPATCH33,'XData',[Cpts(1,4:5),fliplr(Cpts(2,4:5))],'YData',[Spts(1,4:5),fliplr(Spts(2,4:5))]) 
        end
        
        set(SHAPEPATCH34,'XData',Cpts(hullpts),'YData',Spts(hullpts))
        set(SHAPEPATCH34,'EdgeColor','none')
        
    end

    setPosition(AX1_LINE_V,double([DICOM.CC,DICOM.RR(1);DICOM.CC,DICOM.RR(2)]));
    setPosition(AX1_LINE_H,double([DICOM.RC(1),DICOM.CR;DICOM.RC(2),DICOM.CR]));
    setPosition(AX2_LINE_V,double([DICOM.CS,DICOM.RR(1);DICOM.CS,DICOM.RR(2)]));
    setPosition(AX2_LINE_H,double([DICOM.RS(1),DICOM.CR;DICOM.RS(2),DICOM.CR]));
    setPosition(AX3_LINE_V,double([DICOM.CC,DICOM.RS(1);DICOM.CC,DICOM.RS(2)]));
    setPosition(AX3_LINE_H,double([DICOM.RC(1),DICOM.CS;DICOM.RC(2),DICOM.CS]));

    set(AX1_TEXT,'Position',[DICOM.RR(1),DICOM.RC(end),0],'String',[' Z = ',num2str(DICOM.CS)])
    set(AX2_TEXT,'Position',[DICOM.RS(end),DICOM.RR(end),0],'String',[' X = ',num2str(DICOM.CC)])
    set(AX3_TEXT,'Position',[DICOM.RC(1),DICOM.RS(1),0],'String',[' Y = ',num2str(DICOM.CR)])

    drawnow
    

end


% profile off
% profile viewer

end