# BoweBetterTalk-WWDC21

## The project

Bowe Better Talk is an interactive experience around the importance of speaking clearly and not keeping things to yourself. This subject is very special to me, as in many life situations I struggled to talk with people and had to overcome my fears to build healthier relationships. 

The project is in the Playground Book format and was designed to be played on iPad. It features microphone and shake detections as user input, together with immersive storytelling, animations, music and sound effects. 

It was my accepted submission for WWDC21 Swift Student Challenge.

Cutscene made with Hype4.
Visual assets made with Adobe Photoshop.
Audio assets made with macOS GarageBand.

Check it out on Youtube: lkjlkjelfskjelj

## The code

Big credits to https://github.com/dudamello/PlaygroundTemplate. This Playground Book template certainly saved me a lot of time I would spend setting everything up. Also, it made easier to understand how to manage pages and add cutscenes. 

The code is in SpriteKit and got some of its great features such as SKAction for character animation and physics simulation for the doodle effect. 
The scream and blow detection both uses AVAudioRecorder to measure the device volume input. 
The shake detection was implemented with CoreMotion accelerometer. 
Music and SFX playback with AVFoundation

The code is a bit of a mess, but I think trying to organize it would break its original short deadline look (or I'm just too lazy to do so...).





