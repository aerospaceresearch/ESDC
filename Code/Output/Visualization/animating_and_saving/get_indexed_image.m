function [A, map] = get_indexed_image(fig)
  frame = getframe(fig);
  im = frame2im(frame);
  [A, map] = rgb2ind(im);
end