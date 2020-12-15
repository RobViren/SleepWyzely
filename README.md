# SleepWyzely

A project to see if a the Wyze can be used for sleep monitoring. The infrared imaging capability, streaming output, and cheap price make it an ideal device. The fact that this operates by using a video camera makes this an in-ideal device. Still makes for an interesting challenge. 

**Project Setup:** I used a Wyze security camera to capture my sleep from the vantage point of my night stand pointed at the center mass of my chest. I used an SD card to record the night of sleep for processing. I am in the works on using the RTSP stream and processing real-time as well, possibly to a dedicated phone app for ease of use.

**Processing:** I used opencv to give me the raw data for Julia to process. I take the first frame as a keyframe and calculate the difference of each subsequent image as a percentage. If the percentage gets too high (meaning I am moving a whole lot) I skip some data and take a new keyframe image. The movements do not allow for accurate calculation, which is why I skip some data. This process produces a CSV file with **Time** (Approximate based on 10 FPS stream) and the **Count** which is the percent of image difference from keyframe.

**Post-processing:** I load the CSV into Julia to get the actual estimation. I smooth the data with a running average on the count. Depending on how I am positioned I get varying accuracy and sinusoidal amplitude. I used Pluto to play with the data and got within the realm of reasonable results.

Smoothed Sample of data. I use a simple peak finding package to get the distance between breaths in frames and use that to solve for time. The 10 FPS makes for easy conversion. 

![sample](https://github.com/RobViren/SleepWyzely/blob/master/images/sample.png)

Full Results

![pluto](https://github.com/RobViren/SleepWyzely/blob/master/images/pluto.png)

**Future Plans:** 

* Implement the code to run real-time and push results to a server for storage
* Create a CLI tool to provide the same functions
* Use flutter to make an app for fun

**Other Methods:** I had attempted to use, but failed to make work using DFT to calculate the breathing rate, but I ran into some issues finding the peak signal reliably. There is some low level module and compression noise that makes it a bit hard, but I am sure that someone with more signal processing skills could do it no problem. 
