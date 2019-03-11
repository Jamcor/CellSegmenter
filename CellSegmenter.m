function CellSegmenter()

% [filename, pathname]=uigetfile('L:\Cappell_Lab\James\Beta-gal images (For James)\*.tif','MultiSelect','on');

[filenames,pathname]=uigetfile('D:\Marwa\Beta-gal images (For James)\*.tif','MultiSelect','on');

finishflag=0;
    

for i=1:length(filenames)
    
    if ~finishflag
  alldata.(filenames{i}(1:end-4))=SegmentCell(filenames{i});
    end
    
end

[file,path]=uiputfile(); %ask user to save file after segmentation has finished
save([path file],'alldata'); 
    
function data=SegmentCell(filename)
    
    im=imread([pathname filename]); %read in image
    
    figurehandle=figure; %create figure and handle
    imagehandle=imshow(im); %show image and get handle
    figurehandle.CloseRequestFcn={@CloseFigure}; %callback for closing figure
    
%     %create buttons and callbacks
%     nextcellcontrol=uicontrol('String','Next image','Callback',@NextImageCallback,'Units','normalized');
%     segmentcellcontrol=uicontrol('String','Segment','Callback',@SegmentCallback,'Units','normalized');
%     finishcontrol=uicontrol('String','Finish','Callback',@FinishCallback,'Units','normalized');    
%     nextcellcontrol.Position = [0.5099    0.0165    0.0397    0.0302];
%     segmentcellcontrol.Position = [0.4641 0.0153 0.0397 0.0308];
%     finishcontrol.Position = [0.5536 0.0165 0.0397 0.0296];
%     
    %create context menus and callbacks
    cmenu=uicontextmenu(); %create context menu and get handle
    imagehandle.UIContextMenu=cmenu; %apply context menu to image handle (not figure handle)
    nextcellcontrol=uimenu(cmenu,'Text','Next image','Callback',@NextImageCallback);
    segmentcellcontrol=uimenu(cmenu,'Text','Segment','Callback',@SegmentCallback);
    finishcontrol=uimenu(cmenu,'Text','Finish','Callback',@FinishCallback); 

    
    ndx=1; %index counter
    continueflag=1;  
    data=struct();

    while 1 
        
        uiwait(gcf);
        
        if exist('figurehandle') && segmentflag==1
        data.handles{ndx}=drawfreehand();
        data.cellmasks{ndx}=createMask(data.handles{ndx});
        data.regionprops{ndx}=regionprops(data.cellmasks{ndx});
        data.cellid(ndx)=ndx;
        
%       cmenu2=uicontextmenu();
%       data.handles.UIContextMenu=cmenu;
        
        ndx=ndx+1;
        elseif ~exist('figurehandle') && annotateflag==0
            disp('here');            
           return 
        end
    end
    
    function CloseFigure(src,event)
        continueflag=0; %stop segmentation
        delete(figurehandle); %delete figure
        clear figurehandle; %clear variable from workspace
    end



    function NextImageCallback(src,event)
        uiresume(gcf);
        continueflag=0; %stop segmentation
        annotateflag=0;
        delete(figurehandle); %delete figure        
        clear figurehandle; %clear variable from workspace
        
    end

    function SegmentCallback(src,event)
    segmentflag=1;
    annotateflag=0;
    uiresume(gcf);
    end
    
    function AnnotateCellCallback(src,event)
    segmentflag=0;
    annotateflag=1;
    uiresume(gcf);
    end
    
    function FinishCallback(src,event)
       finishflag=1;
       continueflag=0; %stop segmentation
       delete(figurehandle); %delete figure
       clear figurehandle; %clear variable from workspace
    end

end
end





