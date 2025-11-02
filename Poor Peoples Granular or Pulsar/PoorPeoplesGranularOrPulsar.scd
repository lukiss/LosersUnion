(

s.waitForBoot;

/*

.                          .        ______
.     __             ____ _.      _(      )_,
.    / /_____  __   / __///.    .( ____     )__
.   / /   / /_/  \_/ / /_. .   _(_/   (__      \
.  / / / /\  / /_// /\  /  .  (_ \ \ |  (_     _)
. / /___/___/\___/_/___/__ ..(° )(__-____)____)
. \___________/_/________/ .|||_|_/ ∑   __  \
.    / / /  \/ /  \/  \    .| (   )  __(_ \_ \_
.   / / / / / / / / / /    .`-/--¥\ (___  /   /
.   \__/_/ /_/\__/_/ /_    .  \______(___/___/
.       /___/     /___/    .

POOR PEOPLES PULSAR
VERSION 1e-07
2021

Decided to share a little instrument initially used for
a cassette i recorded some time ago. I added some knobs
with scrambled labels. It's not as marvellous as
NuPG by Marcin Pietruszewski or Pulsaret by ApeSoft but
then it would not be the poor peoples pulsar, wouldn't it?

So feel free to build further on this or just make some
wonderful joyious noise!

MANUAL:

You draw a train or env in the window above the 13 knobs.
Start drawing and the thing springs to life and and mayhem
ensues.

         _______________,!
        f.--------------.|°
        ||  __     __   ||:
        ||  /\  -  /\   ||:
        ||     \_/      ||:
        ||              |||
        ||______________|||
        |________________|!
        /////////////////X
       ///////////////////
      /     _____      //
     /_____/____/_____//
     `-----------------'

*/


// Setting up things, buffers and windows and whatnot

c=Env.perc(0.0001,curve: -8).discretize(512).asCollection;
e=Buffer.sendCollection(s,c);
b=Buffer.alloc(s,512);
w=Window("Poor Peoples Pulsar",Rect(400,400,560,500)).alwaysOnTop_(true);
z=CompositeView(w,Rect(0,0,550,200));
w.view.background_(Color.white);
u=UserView(w,Rect(10,220,w.bounds.width,w.bounds.height));
u.addFlowLayout();

// The plotter where you draw your window from most values are polled.

a=Plotter("Loser!",parent: z).value_(c).editMode_(true).editFunc_({b.sendCollection(a.value)});
a.setProperties(\gridOnX,false,\gridOnY,false);

// Sending a snappier Env to variable c and passing it on to buffer e

c=Env.perc(0.0001,curve: -8).discretize(256).asCollection;
e=Buffer.sendCollection(s,c);


// Making a function to plot knobs so we don't have to write this
// nonsense over and over again for each knob. Remove the .scramble part
// if You prefer to have labels that make sense to you. I tend to start
// think too much.

k={|c,a,b|EZKnob(u,(60@90)*1.2,c.scramble,controlSpec: b,action: {|v|
Ndef(\ppp).set(a,(v.value))}).setColors(nil,nil,Color.clear,nil,Color.black,Color.red,[Color.clear,Color.black,Color.clear,Color.green])};

k.("CAR HI ",\carMax,ControlSpec(1, 15000, \exp, 1,1,));      // High limit for Carrier Freq
k.("MOD HI ",\modMax,ControlSpec(1, 15000, \exp, 1,1,));      // Lower limit for Mod freq
k.("DUR HI ",\durMax,ControlSpec(0.01, 10, \exp, 0, 0.001,)); // Max grain duration
k.("TRG HI ",\trigHi,ControlSpec(0.01, 215, \lin, 0,1,));     // Max trigger freq
k.("SPEED  ",\speed,ControlSpec(0.0001, 5, \exp, 0, 0.001,)); // The speed the buffer is scanned
k.("INDEX  ",\index,ControlSpec(1, 15, \lin, 0.25,1,));       // Index of modulation
k.("LAG    ",\lag,ControlSpec(0.001, 2, \lin, 0,1,));         // Lag the values spat out from b.
k.("CAR LO ",\carMin,ControlSpec(1, 15000, \exp, 1, 1,));     // Low limit for Carrier
k.("MOD LO ",\modMin,ControlSpec(1, 15000, \exp, 1, 4441,));  // Low limit for mod freq
k.("DUR LO ",\durMin,ControlSpec(0.001, 1, \exp, 0, 0.001,)); // Min grain duration
k.("TRG LO ",\trigLo,ControlSpec(0.01, 115, \exp, 0,1,));     // Min trigger freq
k.("FLUX   ",\flux,ControlSpec(0.0001, 2, \lin, 0,1,));       // Flux varies the speed b is read.
k.("ENV",\env,ControlSpec(0, 2, \lin, 1,0));               // Envbuffer. 0:perc, 1:hann, 2:custom

// enabling the handy little serverwindow with s.makeGui so you have
// a recordbutton at hand all the time when you stumble upon some
// interresting sounds and open the main window.

s.makeGui;
w.front;


Ndef(\ppp,{

	f={LFDNoise1.kr(1,\flux.kr(0.25),1).abs};
	r={BufRd.ar(1,b,Phasor.ar(0,LFDNoise1.kr(1,0.001,\speed.kr(0.1)),0,b.numFrames),1,4).lag3(0.1*\lag.kr(0.01)*f)};


	Out.ar(0,{

		LeakDC.ar(

GrainFM.ar(
			numChannels: 2,
			trigger:t=Impulse.ar(r.linlin(0,1,f*\trigLo.kr(2),f*\trigHi.kr(212))),
			dur: r.linexp(0.0,1,f*\durMin.kr(0.001),f*\durMax.kr(5)),
			carfreq: r.linexp(0,1,f*\carMin.kr(3),f*\carMax.kr(5555)),
			modfreq: r.linexp(0,1,f*\modMin.kr(3),f*\modMax.kr(5553)),
			index: f*r*\index.kr(11),
				pan: LFDNoise1.kr(r.linlin(0,1,5,20),0.25),
			envbufnum: Select.kr(\env.kr(0),[e,-1,b])
			)
		)
	})
});

CmdPeriod.doOnce({w.close;Ndef(\ppp).clear});

)



