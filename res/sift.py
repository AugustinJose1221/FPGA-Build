import cv2
import numpy as np

img = cv2.imread('Final1.jpg')
gray= cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
'''
sift = cv2.SIFT()
kp = sift.detect(gray,None)
'''
descriptor = cv2.xfeatures2d.SIFT_create()
(kps, features) = descriptor.detectAndCompute(gray, None)
img=cv2.drawKeypoints(gray,kps, outImage = None)

cv2.imwrite('CV2SIFT.jpg',img)
