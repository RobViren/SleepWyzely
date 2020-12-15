import cv2
import glob

# Small program to glob together the fragmented wyze recordings
out = cv2.VideoWriter("big.mp4",cv2.VideoWriter_fourcc(*'mp4v'), 10.0, (1920, 1080))
for vid in glob.glob("data/wyze/*/*.mp4"):
    print(vid)
    cap = None
    try:
        cap = cv2.VideoCapture(vid)
    except:
        break
    ret = True
    while ret:
        ret, src = cap.read()
        if ret:
            out.write(src)
out.release()