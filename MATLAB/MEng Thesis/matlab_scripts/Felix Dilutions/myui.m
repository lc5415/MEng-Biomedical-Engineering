function myui
bg = uibuttongroup('Visible','off',...
                  'Position',[0 0 .2 1],...
                  'SelectionChangedFcn',@bselection);
              
% Create three radio buttons in the button group.
r1 = uicontrol(bg,'Style',...
                  'radiobutton',...
                  'String','Option 1',...
                  'Position',[10 350 100 30],...
                  'HandleVisibility','off');
              
r2 = uicontrol(bg,'Style','radiobutton',...
                  'String','Option 2',...
                  'Position',[10 250 100 30],...
                  'HandleVisibility','off');

r3 = uicontrol(bg,'Style','radiobutton',...
                  'String','Option 3',...
                  'Position',[10 150 100 30],...
                  'HandleVisibility','off');
              
% Make the uibuttongroup visible after creating child objects. 
bg.Visible = 'on';


    function bselection(source,event)
       display(['Previous: ' event.OldValue.String]);
       display(['Current: ' event.NewValue.String]);
       display('------------------');
    end
end