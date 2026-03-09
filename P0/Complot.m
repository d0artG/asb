function [] = Complot(varargin)

error(nargchk(1,2,nargin));
[msg,x,S] = Cplotchk(varargin);
error(msg)

% Get some spacing between the various signals
alpha = mean(max(S')-min(S'));
% save alpha alpha
% load alpha alpha
for i = 1:size(S,1)
  SS(i,:) = S(i,:) - alpha*(i-1)*ones(size(S(1,:)));
end

% Plotting per se
if nargin == 1
   plot(SS')
   else
   plot(x,SS')
end
% axis([x(1) x(length(SS)) min(min(SS)) max(max(SS)) ])
axis([0 x(length(SS)) min(min(SS)) max(max(SS)) ])
set(gca,'YTick',-size(S,1)*alpha:alpha:0);
set(gca,'YTicklabel',size(S,1)+1:-1:1);

% Reading routine
function [msg,x,S] = Cplotchk(P);
msg = [];

if length(P) > 2
   msg = 'Too many inputs.';
else
   if length(P) == 1
      S = P{1};
      x = 1:length(S);
   end
   if length(P) == 2
      x = P{1};
      S = P{2};
   end
end