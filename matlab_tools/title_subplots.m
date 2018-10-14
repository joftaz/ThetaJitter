function [ varargout ] = title_subplots(fig_title )
% title_subplots 'title'
% h = title_subplots 'title' : return the handle of the whole figure
% h, ht = title_subplots 'title' : return the handle of the whole figure
% and the text object
%title for the figure
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');

h =text(0.5, 1,sprintf('\\bf %s', fig_title),'HorizontalAlignment' ,'center','VerticalAlignment', 'top');

if nargout == 1
  varargout = ha;
end

if nargout == 2
  varargout = {ha, h};
end

end

