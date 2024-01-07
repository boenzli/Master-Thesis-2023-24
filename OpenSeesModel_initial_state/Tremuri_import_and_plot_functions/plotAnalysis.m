function outputFlag = plotAnalysis(model, result, DriftType, DriftLimit)

dlimit=DriftLimit
  
f=figure; hold on;
set(gcf,'Units', 'Centimeters')
set(gcf,'Position', [17.9652    5.5563   16.0602   23.4685]);

maxDamage = DriftLimit;

set(gcf,'color','w');
for kMode = 1%:nModes
    
   
    %subplot(3,2,kMode)
    
    %drawModel(model, 'ColorPiers', 'none', 'ColorSpandrels', 'none', 'ColorBeams', 'none');
    drawModel(model, 'ColorPiers', 'none', 'ColorSpandrels', 'none', 'ColorBeams', 'none', 'styleElements', 'wireframe', 'ColorEdges', [1 1 1]*0.6 );
    
    scaleFactor = 1;
    readNode = 0;
    for kNode=1:length(model.node)
        if ~isempty(model.node(kNode).x)
            readNode = readNode +1;
            maxDisp_n(readNode) = max(abs([max(abs(result.node(kNode).u)), max(abs(result.node(kNode).v)), max(abs(result.node(kNode).w))]) );
        end
    end
    
    scaleFactor = 2.0/max(maxDisp_n);
    
    %scaleFactor = 20000;
    scaleFactor = 1;
    step = 1;
    
    if DriftType=='S'
        drawModel(model, result, 'StyleNodes', 'sk', 'ColorPiers', [0.8 0 0], 'ColorSpandrels', [0 0 0.8], 'deformed', scaleFactor, 'step', step, 'mapDamage', 'driftS', 'maxDamage', maxDamage, 'walls', [1 2 3 4 5 6 7 8 9 10 11 12 ]);
    elseif DriftType=='F'
            drawModel(model, result, 'StyleNodes', 'sk', 'ColorPiers', [0.8 0 0], 'ColorSpandrels', [0 0 0.8], 'deformed', scaleFactor, 'step', step, 'mapDamage', 'driftF', 'maxDamage', maxDamage, 'walls', [1 2 3 4 5 6 7 8 9 10 11 12]);
        else
            drawModel(model, result, 'StyleNodes', 'sk', 'ColorPiers', [0.8 0 0], 'ColorSpandrels', [0 0 0.8], 'deformed', scaleFactor, 'step', step, 'walls', [1 2 3 4 5 6 7 8 9 10 11 12]);
    end
    
        
    colormap (flipud(hot));
    caxis([0 maxDamage]);
    colorbar('northoutside');
    
%      drawModel(model, modal(kMode).result, 'StyleNodes', 'none', 'ColorPiers', 'none', 'ColorSpandrels', 'none', 'deformed', scaleFactor, 'step', 1, 'styleElements', 'wireframe', 'ColorEdges', [0.5 0 0]);
%      drawModel(model, modal(kMode).result, 'ColorPiers','none', 'ColorSpandrels', 'none', 'ColorEdges', [1 1 1], 'ColorEdgesFloors', [0.5 0 0], ...
%                'ColorFloors', [1 0 0]*0.5, 'deformed', scaleFactor, 'step', 1, 'floors', true, 'walls', []);
    
    view(-30, 40)
    %view(0, 90)
    axis equal
    axis off
    
  
      
end


b = uicontrol('Parent',f,'Style','slider','Position',[81,54,200,23],'value',scaleFactor, 'min',0, 'max',max(1000,scaleFactor));
bgcolor = f.Color;
bl1 = uicontrol('Parent',f,'Style','text','Position',[50,54,23,23],...
                'String','0','BackgroundColor',bgcolor);
bl2 = uicontrol('Parent',f,'Style','text','Position',[281,54,23,23],...
                'String',num2str(max(1000,scaleFactor)),'BackgroundColor',bgcolor);
bl3 = uicontrol('Parent',f,'Style','text','Position',[120,25,100,23],...
                'String','Scale Factor','BackgroundColor',bgcolor);
            
            
bb = uicontrol('Parent',f,'Style','slider','Position',[81,54+55,200,23],'value',step, 'min',1, 'max',length(result.time));
bgcolor = f.Color;
bbl1 = uicontrol('Parent',f,'Style','text','Position',[50,54+55,23,23],'String','1','BackgroundColor',bgcolor);
bbl2 = uicontrol('Parent',f,'Style','text','Position',[281,54+55,23,23], 'String',num2str(length(result.time)),'BackgroundColor',bgcolor);
bbl3 = uicontrol('Parent',f,'Style','text','Position',[120,25+55,100,23],'String','Step number','BackgroundColor',bgcolor);


b.Callback = @(es,ed) updatePlot(model, result, b, bb,DriftType,DriftLimit); 
bb.Callback = @(es,ed) updatePlot(model, result, b, bb,DriftType,DriftLimit); 

outputFlag = 1;


end


function updatePlot(model, result, slider1, slider2,DriftType,DriftLimit)

maxDamage = DriftLimit;

  hold off
  drawModel(model, 'ColorPiers', 'none', 'ColorSpandrels', 'none', 'ColorBeams', 'none', 'styleElements', 'wireframe', 'ColorEdges', [1 1 1]*0.6 );
  hold on
  if DriftType=='S'
      drawModel(model, result, 'StyleNodes', 'sk', 'ColorPiers', [0.8 0 0], 'ColorSpandrels', [0 0 0.8], 'deformed', get(slider1,'value'), 'step', floor(get(slider2,'value')), 'mapDamage', 'driftS', 'maxDamage', maxDamage, 'walls', [1 2 3 4 5 6 7 8 9 10 11 12]);
      title ("Shear drifts");
  elseif DriftType=='F'
      title ("Flexural drifts");
      drawModel(model, result, 'StyleNodes', 'sk', 'ColorPiers', [0.8 0 0], 'ColorSpandrels', [0 0 0.8], 'deformed', get(slider1,'value'), 'step', floor(get(slider2,'value')), 'mapDamage', 'driftF', 'maxDamage', maxDamage, 'walls', [1 2 3 4 5 6 7 8 9 10 11 12]);
  else
      title ("Deformed shape");
      drawModel(model, result, 'StyleNodes', 'sk', 'ColorPiers', [0.8 0 0], 'ColorSpandrels', [0 0 0.8], 'deformed', get(slider1,'value'), 'step', floor(get(slider2,'value')), 'walls', [1 2 3 4 5 6 7 8 9 10 11 12]);
  end
  
  
    colormap (flipud(hot));
    caxis([0 maxDamage]);
    colorbar('northoutside');
  
 view(-30, 40)
 %view(0, 90)
 axis equal
 axis off
 
 
end

