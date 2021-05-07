from PIL import Image

im = Image.open("Final2.jpg")
fil = open('data2.txt', 'w')
pixel = im.load()
row, column = im.size
for y in range(column):
    for x in range(row):
        pix = pixel[x, y]
        r = hex(pix[2])
        g = hex(pix[1])
        b = hex(pix[0])
        if len(str(r))==3:
            r = str(r)[0:2] + "0" + str(r)[2]
        if len(str(g))==3:
            g = str(g)[0:2] + "0" + str(g)[2]
        if len(str(b))==3:
            b = str(b)[0:2] + "0" + str(b)[2]
        fil.write(r[2:4] + '\n' + g[2:4] + '\n' + b[2:4] + '\n')
fil.close()
