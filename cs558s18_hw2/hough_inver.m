function y= hough_inver(r,c)

x = linspace(0,548,400);

theta = c*pi/548;

p = 407-r;

y = p/sin(theta)-x*cot(theta);

end