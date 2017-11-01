function Set_Object_Callback(~,~,~)

global DICOM
global OBJECTS dataarray
global LISTBOX_HANDLE
global NEW_OBJ_ID
global sl ckh ts
global Xpts Ypts Zpts X0pts Y0pts Z0pts X1pts Y1pts Z1pts maxdim
global ADDOBJ_ACTIVE_H ADDOBJ_INACTIVE_H AXES4_HANDLE
global OBJECTARRAY
global Xcenter Ycenter Zcenter 
global SHAPEPATCH11 SHAPEPATCH12 SHAPEPATCH13 SHAPEPATCH14
global SHAPEPATCH21 SHAPEPATCH22 SHAPEPATCH23 SHAPEPATCH24
global SHAPEPATCH31 SHAPEPATCH32 SHAPEPATCH33 SHAPEPATCH34
global CENTERPOINT1 CENTERPOINT2 CENTERPOINT3

Xrng = ((1:DICOM.numrows) - round(DICOM.numrows/2))*DICOM.pixelsize(1)/10;
Yrng = ((1:DICOM.numcols) - round(DICOM.numcols/2))*DICOM.pixelsize(2)/10;
Zrng = ((1:DICOM.numslices) - round(DICOM.numslices/2))*DICOM.slicespacing/10;

setdataarray = find_inner_points(dataarray);

hu = setdataarray(10);
if setdataarray(11);
    DICOM.img(DICOM.img_mask) = DICOM.img_original(DICOM.img_mask);
else
    DICOM.img(DICOM.img_mask) = hu;
end
int_pts = find(DICOM.img_mask);
DICOM.img_mask = false(size(DICOM.img));

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
OBJECTS(n + 1).DataArray = setdataarray;
if get(ckh,'Value')
    OBJECTS(n + 1).HU = NaN;
else
    OBJECTS(n + 1).HU = hu;
end
OBJECTS(n + 1).XRng = Xrng;
OBJECTS(n + 1).YRng = Yrng;
OBJECTS(n + 1).ZRng = Zrng;
OBJECTS(n + 1).XSz = DICOM.numrows;
OBJECTS(n + 1).YSz = DICOM.numcols;
OBJECTS(n + 1).ZSz = DICOM.numslices;
OBJECTS(n + 1).IntPts = int_pts;
OBJECTS(n + 1).ListboxStr = listbox_strings{end};

set(ckh,'Value',0);
hu = get(sl,'Value');
set(ts,'String',['HU Value = ',num2str(hu)])
set(ts,'Enable','on')
set(sl,'Enabled',1)

xlim(AXES4_HANDLE,DICOM.RR)
ylim(AXES4_HANDLE,DICOM.RS)
zlim(AXES4_HANDLE,DICOM.RC)

set(SHAPEPATCH11,'XData',[],'YData',[])
set(SHAPEPATCH12,'XData',[],'YData',[])
set(SHAPEPATCH13,'XData',[],'YData',[])
set(SHAPEPATCH14,'XData',[],'YData',[])
set(SHAPEPATCH21,'XData',[],'YData',[])
set(SHAPEPATCH22,'XData',[],'YData',[])
set(SHAPEPATCH23,'XData',[],'YData',[])
set(SHAPEPATCH24,'XData',[],'YData',[])
set(SHAPEPATCH31,'XData',[],'YData',[])
set(SHAPEPATCH32,'XData',[],'YData',[])
set(SHAPEPATCH33,'XData',[],'YData',[])
set(SHAPEPATCH34,'XData',[],'YData',[])
set(CENTERPOINT1,'Visible','Off');
set(CENTERPOINT2,'Visible','Off');
set(CENTERPOINT3,'Visible','Off');

Update_Axes
Update_3D

set(ADDOBJ_ACTIVE_H,'Enable','off')
set(ADDOBJ_INACTIVE_H,'Enable','on')
set(sl,'Enabled',0)

