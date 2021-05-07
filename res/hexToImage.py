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
bgrImage = numpy.array(l).reshape(480, 320)
cv2.imwrite('FILTEROUT7.jpg', bgrImage)
