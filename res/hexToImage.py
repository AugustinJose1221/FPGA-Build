import numpy
import cv2
File =  open("out.txt", 'r+')
content = File.read()
val = 0
l = []
for i in content.split("\n"):
    if(i != ''):
        val = int(i, 16)
        l.append(val)
    else:
        continue
bgrImage = numpy.array(l).reshape(448, 598)
cv2.imwrite('SOBEL1.jpg', bgrImage)
