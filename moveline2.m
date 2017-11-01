function moveline2(~,~)

global DICOM dataarray ckh sl e1
global AX1_LINE_H AX1_LINE_V AX2_LINE_H AX2_LINE_V AX3_LINE_H
global IMG1 IMG2 IMG3
global AX1_TEXT AX2_TEXT AX3_TEXT

rpos = getPosition(AX2_LINE_H);
cpos = getPosition(AX1_LINE_V);
spos = getPosition(AX2_LINE_V);
setPosition(AX1_LINE_H,[DICOM.RC(1),rpos(1,2);DICOM.RC(2),rpos(2,2)])
setPosition(AX3_LINE_H,[DICOM.RC(1),spos(1,1);DICOM.RC(2),spos(2,1)])

DICOM.CR = rpos(1,2);
DICOM.CC = cpos(1,1);
DICOM.CS = spos(1,1);

[~,Rind] = min(abs(DICOM.R - DICOM.CR));
[~,Cind] = min(abs(DICOM.C - DICOM.CC));
[~,Sind] = min(abs(DICOM.S - DICOM.CS));

if strcmp(get(e1,'Enable'),'on')
    bmaskax1 = find_inner_slice_points(dataarray,Sind,3,[DICOM.numrows,DICOM.numcols]);
    bmaskax2 = find_inner_slice_points(dataarray,Cind,2,[DICOM.numrows,DICOM.numslices]);
    bmaskax3 = find_inner_slice_points(dataarray,Rind,1,[DICOM.numcols,DICOM.numslices]);

    img1 = squeeze(DICOM.img(:,:,Sind));
    if any(bmaskax1(:))
        if get(ckh,'Value')
            oimg = squeeze(DICOM.img_original(:,:,Sind));
            img1(bmaskax1) = oimg(bmaskax1);
        else
            img1(bmaskax1) = get(sl,'Value');
        end
    end
    set(IMG1,'CData',img1)

    img2 = squeeze(DICOM.img(:,Cind,:));
    if any(bmaskax2(:))
        if get(ckh,'Value')
            oimg = squeeze(DICOM.img_original(:,Cind,:));
            img2(bmaskax2) = oimg(bmaskax2);
        else
            img2(bmaskax2) = get(sl,'Value');
        end
    end
    set(IMG2,'CData',img2)

    img3 = squeeze(DICOM.img(Rind,:,:));
    if any(bmaskax3(:))
        if get(ckh,'Value')
            oimg = squeeze(DICOM.img_original(Rind,:,:));
            img3(bmaskax3) = oimg(bmaskax3);
        else
            img3(bmaskax3) = get(sl,'Value');
        end
    end
    img3 = img3';
    set(IMG3,'CData',img3)
else
    i1 = squeeze(DICOM.img(:,:,Sind));
    set(IMG1,'CData',i1)

    i2 = squeeze(DICOM.img(:,Cind,:));
    set(IMG2,'CData',i2)

    i3 = squeeze(DICOM.img(Rind,:,:))';
    set(IMG3,'CData',i3) 
end

set(AX1_TEXT,'Position',[DICOM.RR(1),DICOM.RC(end),0],'String',[' Z = ',num2str(DICOM.CS)])
set(AX2_TEXT,'Position',[DICOM.RS(end),DICOM.RR(end),0],'String',[' X = ',num2str(DICOM.CC)])
set(AX3_TEXT,'Position',[DICOM.RC(1),DICOM.RS(1),0],'String',[' Y = ',num2str(DICOM.CR)])
