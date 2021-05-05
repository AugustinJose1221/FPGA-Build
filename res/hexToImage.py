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
bgrImage = numpy.array(l).reshape(60, 60)
cv2.imwrite('FilterOut.jpg', bgrImage)
