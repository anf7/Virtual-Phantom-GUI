function Cancel_Object_Callback(~,~,~)

global ADDOBJ_ACTIVE_H ADDOBJ_INACTIVE_H sl AXES4_HANDLE
global Xpts Ypts Zpts Xcenter Ycenter Zcenter maxdim DICOM
global SHAPEPATCH11 SHAPEPATCH12 SHAPEPATCH13 SHAPEPATCH14
global SHAPEPATCH21 SHAPEPATCH22 SHAPEPATCH23 SHAPEPATCH24
global SHAPEPATCH31 SHAPEPATCH32 SHAPEPATCH33 SHAPEPATCH34
global CENTERPOINT1 CENTERPOINT2 CENTERPOINT3

set(ADDOBJ_ACTIVE_H,'Enable','off')
set(ADDOBJ_INACTIVE_H,'Enable','on')
set(sl,'Enabled',0);

[Xpts,Ypts,Zpts,Xcenter,Ycenter,Zcenter,maxdim] = deal([]);

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

Update_3D