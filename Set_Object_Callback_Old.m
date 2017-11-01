function Set_Object_Callback_Old(~,~,~)

global DICOM
global OBJECTS
global LISTBOX_HANDLE
global NEW_OBJ_ID
global e1 e2 e3 e4 e5 e6 e7 e8 e9 sl ckh ts
global Xpts Ypts Zpts X0pts Y0pts Z0pts X1pts Y1pts Z1pts maxdim
global ADDOBJ_ACTIVE_H ADDOBJ_INACTIVE_H AXES4_HANDLE
global OBJECTARRAY
global Xcenter Ycenter Zcenter

Xrng = ((1:DICOM.numrows) - round(DICOM.numrows/2))*DICOM.pixelsize(1)/10;
Yrng = ((1:DICOM.numcols) - round(DICOM.numcols/2))*DICOM.pixelsize(2)/10;
Zrng = ((1:DICOM.numslices) - round(DICOM.numslices/2))*DICOM.slicespacing/10;
        
xyz = [Xpts(:),Ypts(:),Zpts(:)];
minX = min(Xpts(:));
minY = min(Ypts(:));
minZ = min(Zpts(:));
maxX = max(Xpts(:));
maxY = max(Ypts(:));
maxZ = max(Zpts(:));

Xgrd = DICOM.R;
Ygrd = DICOM.C;
Zgrd = fliplr(DICOM.S);  

X1 = find(Xgrd > minX,1,'first') - 1;
if isempty(X1)
    X1 = length(Xgrd);
elseif X1 < 1
    X1 = 1;
end
X2 = find(Xgrd < maxX,1,'last') + 1;
if isempty(X2)
    X2 = 1;
elseif X2 > length(Xgrd)
    X2 = length(Xgrd);
end

Y1 = find(Ygrd > minY,1,'first') - 1;
if isempty(Y1)
    Y1 = length(Ygrd);
elseif Y1 < 1
    Y1 = 1;
end
Y2 = find(Ygrd < maxY,1,'last') + 1;
if isempty(Y2)
    Y2 = 1;
elseif Y2 > length(Ygrd)
    Y2 = length(Ygrd);
end

Z1 = find(Zgrd > minZ,1,'first') - 1;
if isempty(Z1)
    Z1 = length(Zgrd);
elseif Z1 < 1
    Z1 = 1;
end
Z2 = find(Zgrd < maxZ,1,'last') + 1;
if isempty(Z2)
    Z2 = 1;
elseif Z2 > length(Zgrd)
    Z2 = length(Zgrd);
end


[gX,gY,gZ] = ndgrid(Xgrd(X1:X2),Ygrd(Y1:Y2),Zgrd(Z1:Z2));
[tX,tY,tZ] = size(gX);

testpts = [gX(:),gY(:),gZ(:)];
in = inhull(testpts,xyz);
int_pts = logical(reshape(in,[tX,tY,tZ]));

if ~isempty(gX)
    hu = get(sl,'Value');
    DICOM_part = DICOM.img(X1:X2,Y1:Y2,Z1:Z2);
    if get(ckh,'Value')
        DICOM_orig_part = DICOM.img_original(X1:X2,Y1:Y2,Z1:Z2);
        DICOM_part(int_pts) = DICOM_orig_part(int_pts);
    else
        DICOM_part(int_pts) = hu;
    end
    DICOM.img(X1:X2,Y1:Y2,Z1:Z2) = DICOM_part;

    listbox_strings = get(LISTBOX_HANDLE,'String');
    
    if NEW_OBJ_ID == 1
        objnum = max(OBJECTARRAY(:,1));
        if isempty(objnum)
            objnum = 0;
        end
        OBJECTARRAY(end + 1,:) = [objnum + 1, 0, 0, 0];
        listbox_strings{length(listbox_strings) + 1} = ['Spheroid #',num2str(objnum + 1)];
    elseif NEW_OBJ_ID == 2
        objnum = max(OBJECTARRAY(:,2));
        if isempty(objnum)
            objnum = 0;
        end
        OBJECTARRAY(end + 1,:) = [0, objnum + 1, 0, 0];
        listbox_strings{length(listbox_strings) + 1} = ['Cylinder #',num2str(objnum + 1)];
    elseif NEW_OBJ_ID == 3
        objnum = max(OBJECTARRAY(:,3));
        if isempty(objnum)
            objnum = 0;
        end
        OBJECTARRAY(end + 1,:) = [0, 0, objnum + 1, 0];
        listbox_strings{length(listbox_strings) + 1} = ['Cuboid #',num2str(objnum + 1)];
    elseif NEW_OBJ_ID == 4
        objnum = max(OBJECTARRAY(:,4));
        if isempty(objnum)
            objnum = 0;
        end
        OBJECTARRAY(end + 1,:) = [0, 0, 0, objnum + 1];
        listbox_strings{length(listbox_strings) + 1} = ['Custom Object #',num2str(objnum + 1)];
    end
    if get(ckh,'Value')
        listbox_strings{end}(end + 1:end + 14) = [' (Transparent)'];
    end

    set(LISTBOX_HANDLE,'String',listbox_strings)

    n = length(OBJECTS);
    OBJECTS(n + 1).ObjID = NEW_OBJ_ID;
    OBJECTS(n + 1).Xpts = Xpts;
    OBJECTS(n + 1).Ypts = Ypts;
    OBJECTS(n + 1).Zpts = Zpts;
    OBJECTS(n + 1).X0pts = X0pts;
    OBJECTS(n + 1).Y0pts = Y0pts;
    OBJECTS(n + 1).Z0pts = Z0pts;
    OBJECTS(n + 1).X1pts = X1pts;
    OBJECTS(n + 1).Y1pts = Y1pts;
    OBJECTS(n + 1).Z1pts = Z1pts;
    OBJECTS(n + 1).Pos1 = e1;
    OBJECTS(n + 1).Pos2 = e2;
    OBJECTS(n + 1).Pos3 = e3;
    OBJECTS(n + 1).Rot1 = e4;
    OBJECTS(n + 1).Rot2 = e5;
    OBJECTS(n + 1).Rot3 = e6;
    OBJECTS(n + 1).Dim1 = e7;
    OBJECTS(n + 1).Dim2 = e8;
    OBJECTS(n + 1).Dim3 = e9;
    if get(ckh,'Value')
        OBJECTS(n + 1).HU = NaN;
    else
        OBJECTS(n + 1).HU = hu;
    end
    OBJECTS(n + 1).SpanX = [X1,X2];
    OBJECTS(n + 1).SpanY = [Y1,Y2];
    OBJECTS(n + 1).SpanZ = [Z1,Z2];
    OBJECTS(n + 1).XRng = Xrng;
    OBJECTS(n + 1).YRng = Yrng;
    OBJECTS(n + 1).ZRng = Zrng;
    OBJECTS(n + 1).XSz = DICOM.numrows;
    OBJECTS(n + 1).YSz = DICOM.numcols;
    OBJECTS(n + 1).ZSz = DICOM.numslices;
    OBJECTS(n + 1).IntPts = int_pts;
    OBJECTS(n + 1).ListboxStr = listbox_strings{end};
    
    [Xpts,Ypts,Zpts,Xcenter,Ycenter,Zcenter,maxdim] = deal([]);
end

set(ckh,'Value',0);
hu = get(sl,'Value');
set(ts,'String',['HU Value = ',num2str(hu)])
set(ts,'Enable','on')
set(sl,'Enabled',1)

xlim(AXES4_HANDLE,DICOM.RR)
ylim(AXES4_HANDLE,DICOM.RS)
zlim(AXES4_HANDLE,DICOM.RC)

Update_Axes
Update_3D

set(ADDOBJ_ACTIVE_H,'Enable','off')
set(ADDOBJ_INACTIVE_H,'Enable','on')
set(sl,'Enabled',0)

