import cv2
import numpy as np
import datetime

WIDTH = 1920
HEIGHT = 1080
FPS = 10
MAX_COUNT = HEIGHT * WIDTH * 255
SCALE_FACTOR = 4
THRESH = 5
FILE_NAME = "small_sample"
cap = cv2.VideoCapture("data/{}.mp4".format(FILE_NAME))
#option to process the data live using the RTSP version of Wyze
#cap = cv2.VideoCapture("rtsp://rodbiren:password@192.168.1.114/live")
cap.set(cv2.CAP_PROP_FRAME_HEIGHT,HEIGHT)
cap.set(cv2.CAP_PROP_FRAME_WIDTH,WIDTH)
cap.set(cv2.CAP_PROP_FPS,FPS)


# Vars
current_tick = 0
key_frame = None
first_loop = True
PERCENT_THRESH = 1

# Header
f = open("{}_simple.csv".format(FILE_NAME),"w+")
f.write("Time,Count\n")

while True:
    # Keep track of approximate time
    current_tick = current_tick + 1

    # Get Frame
    ret,src = cap.read()
    if ret == False:
        cv2.destroyAllWindows()
        cap.release()      
        f.close()
        exit(-1)

    # Gray Scale
    gray = cv2.cvtColor(src,cv2.COLOR_BGR2GRAY)
    gray = cv2.blur(gray,(7,7))
    #gray = cv2.resize(gray,(int(WIDTH/SCALE_FACTOR),int(HEIGHT/SCALE_FACTOR)))

    # Start Process After Buffer Is Full
    if not first_loop:
        diff = cv2.absdiff(key_frame,gray)
        #Another optional way of processing the data
        #ret,delt = cv2.threshold(diff,THRESH,256,cv2.THRESH_BINARY)
        percent_active = np.sum(diff)/(MAX_COUNT) * 100
        print("{:10.4f} {:10.4f}".format(current_tick/FPS/60, percent_active))
        
        if percent_active > PERCENT_THRESH:
            key_frame = gray.copy()
            f.write("{0},{1}\n".format(current_tick/FPS,PERCENT_THRESH))
        else:
            f.write("{0},{1}\n".format(current_tick/FPS,percent_active))

        # cv2.imshow("diff",diff)
        # cv2.imshow("src",src)
    else:
        key_frame = gray.copy()
        first_loop = False

    # key = cv2.waitKey(1)
    # if key == 27:
    #     cv2.destroyAllWindows()
    #     cap.release()      
    #     f.close()
    #     bpm.close()
    #     break
    gray_prev = gray.copy()