# Replicating Spotify's Data Transmission Process
The aim of this project was to emulate the transmission and reception of data through QPSK modulation, mirroring the technology used by platforms like Spotify to transmit songs. we employed a 5-second excerpt from the song "[mother tongue](https://www.youtube.com/watch?v=-aC_TSkGvPw)" by Bring Me The Horizon. 

## How to Use
* Inside the file BitStreamRepr.m, change the filename on the first line of code to a desired .wav or mp3 file, or use the included cropped song.
  * *Warning*: Due to MATLAB, the script using a five second song can take ~30 seconds to run, so be careful how long the input song is.
* Run the file
* Once finished, it will have created a .wav file inside current folder, and the .wav should be identical to the one inputted.
* If desired, split up MATLAB script into two to represent transmitter and reciever, currently it is put into one script for convenience, but is able to be split where declared in the script.


## Ideation
The methodology was simple: model how a song can be transmitted, modulated, received. In aims of playing the received audio to sound like the original audio. To do this, we would convert the song
to a bit stream. Bit Stream would be converted to Constellation States. States would be modulated using QPSK Modulation. After modulation, to get the original song, we would repeat this process backwards.
Details on each step as follows.

## Step 1) Data Collection
For testing purposes, we trimmed "mother tongue" full 03:37 clip to 00:05 seconds. Using this 5 second clip, we read it into MATLAB to get 2 pieces of data: sampled data (y) and sampling frequency
(Fs). In layman's terms, y represents the song as points on a sine wave. Fs is how many of those numbers are taken in a given second. We will manipulate y throughout our code to acheive our goal.

## Step 2) Conversion of Song to Bit Stream
Now that we had a list of numbers, we had to convert it to a list of one of those 4 samples of the QPSK constellation seen before. To do this, we can't just take the numbers and convert them, as for example -266 can't be obviously represented as one of four states, so we had to convert it to bits. Bits are a series of 0s and 1s, the same as binary. You represent numbers via a series of bits as seen here:

![pic1](https://github.com/rudra-singh1/Spotify-Data-Transmission-Workflow/assets/136931703/9cde6c22-4f59-4fe2-a84d-139913d5cff9)

I wrote a script to turn these numbers into bits, but we had a hiccup: negative numbers. These negative numbers posed a challenge, as with our original method of translating we had no way to properly represent a negative number. I made a small change to account for this: Add a new bit to the beginning of each number that represented a sign, with 1 meaning positive and 0 being negative.

With this change, all the numbers were sucessfully converted to bits and it was onto states.

## Step 3) Conversion of Bit Stream to Constellation States
Now, we have a bit array representing sampled data, we will convert this to Constellation States. These states create a Constellation diagram shows all the possible symbols that can be
transmitted by the system as a collection of points. There would be 4 points on the diagram:
* 1st Point) 00 bits = #0 Constellation State
* 2nd Point) 01 bits = #1 Constellation State
* 3rd Point) 10 bits = #2 Constellation State
* 4th Point) 11 bits = #3 Constellation State

Constellation Diagram Example Below:

![pic2](https://github.com/rudra-singh1/Spotify-Data-Transmission-Workflow/assets/136931703/eafbc7d8-f86d-4196-b7a2-2679f7f3a455)

Now, this is an example of a Constellation Diagram when we ran our code:
![pic3](https://github.com/rudra-singh1/Spotify-Data-Transmission-Workflow/assets/136931703/370868e0-d66b-482f-92ed-731e2bdda765)


## Step 4) Theory: QPSK Moduation
Quadrature phase shift keying (QPSK) is a modulation technique, and it actually transmits two bits per symbol. In other words, a QPSK symbol doesn’t represent 0 or 1—it
represents 00, 01, 10, or 11 (the Constellation States). These 4 Constellation States are then transmitted using 4 different phase shifts. We can intuitively determine what these four possible phase shifts should be: First we recall that modulation is only the beginning of the communication process; the receiver needs to be able to extract the original information from the modulated signal. Next, it makes sense to seek maximum separation between the four phase options, so that the receiver has less difficulty distinguishing one state from another. We have 360° of phase to work with and four phase states, and thus the separation should be 360°/4 = 90°. So our four QPSK phase shifts are 45°, 135°, 225°, and 315°. Detailed in diagram below:

![pic4](https://github.com/rudra-singh1/Spotify-Data-Transmission-Workflow/assets/136931703/86ce7846-ac31-418a-bb78-acebc4d789cc)

Once these waves are sent via a generator, they get recieved and demodulated back to states using the reverse process.
## Step 5) Conversion of Constellation States to Bit Stream

This uses the reverse technique of the earlier step: going from states to bits. This was fairly straightforward just as it was before:

* #0 Constellation State = 00 bits
* #1 Constellation State = 01 bits
* #2 Constellation State = 10 bits
* #3 Constellation State = 11 bits

With the states turned back into bits, all that was left was to turn these bits back into the song.

## Step 6) Conversion of Bit Stream to Song

Now with the bits, I used the reverse process of step #2 where we converted the song to bits. I would grab 16 bits at a time, as that represented a number. I would ignore the first one at the beginning, and go through 2-16 where I would get the actual number. Then, if the first digit was 0, I would multiply the whole thing by -1, leading to a negative number. One built in function later, and we had a fully working .wav of the same song we had put in earlier, only this time it had been communicated across devices!

## References
* Mathworks Documentation - understanding functions
* All About Circuits Website - details on QPSK Theory
* MATLAB - IDE
* [Image 1](https://knowthecode.io/labs/basics-of-digitizing-data/episode-5)
* [Image 2](https://www.techglads.com/cse/sem3/qpsk/)
* Image 3 - from Spike (Constellation Analysis Platform)
* [Image 4](https://www.allaboutcircuits.com/technical-articles/quadrature-phase-shift-keying-qpsk-modulation/)
