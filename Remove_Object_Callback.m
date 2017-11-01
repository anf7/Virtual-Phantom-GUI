function Remove_Object_Callback(~, ~, ~)

global OBJECTS LISTBOX_HANDLE DICOM
global OBJECTARRAY

obj_vec = get(LISTBOX_HANDLE,'Value');


listbox_strings = cell(0);

DICOM.img = DICOM.img_original;

OBJECTARRAY(obj_vec,:) = [];

OBJECTS(obj_vec) = [];



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
    listbox_strings{length(listbox_strings) + 1} = OBJECTS(n).ListboxStr;
end

        
set(LISTBOX_HANDLE,'Value',[])
set(LISTBOX_HANDLE,'String',listbox_strings)
Update_Axes
Update_3D

