// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
//   A quick and ugly test to see if I could twist and bend
//   waveforms like the Wavetable synth in Ableton Live. That
//   synth obviously runs two sets of wavetables and a third
//   Oscillator plus a million ways to sync and patch with
//   Envelopes. And then some. Obviously change out the
//   a11wlk01.wav to something of your liking.
//
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

~channels=1;
~filename=Platform.resourceDir++"/sounds/a11wlk01.wav";

c=Buffer.allocConsecutive(16,s,1024,~channels,bufnum: 100);
{|n|c[n].read(~filename,n*1024,1024)}!c.size;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(Ndef(\____ ,{
    var snd, skew, osc=0, warp, loop, focus, freq, dur, blend;

    switch(osc, {0},{osc=LFSaw},{1},{osc=LFTri},{2},{osc=SinOsc});
    t     = TDuty.kr(dur=ceil(LFNoise2.kr(3)+1*5)/8);
    freq  = TChoose.kr(t,
                [TIRand.kr(0,60,t),LFNoise2.kr(3).exprange(8,60)]
            ).midicps;
    skew  = LFNoise2.kr(3).lincurve(-1,1,-8,10,LFNoise2.kr(1)+1*8).max * -1;
    warp  = LFNoise2.kr(3).lincurve(-1,1,-8,8,2).max+1;
    loop  = LFNoise2.kr(1)>0;
    focus = LFNoise2.kr(2).range(0,c.size-1);
    blend = LFNoise2.kr(1).range(0.5,1);

    snd={|n|BufRd.ar(1,c[n].bufnum,
        osc.ar(freq,-1).lincurve(-1,1,0,c[n].numFrames*warp,skew),
        loop,4 )}!c.size;

    snd=SelectXFocus.ar(focus,snd,blend,true);
    snd=LeakDC.ar(snd);

    snd=snd*Env.asr(0s1,1,1/8/dur,-8).kr(0,Trig1.ar(t,7/8*dur));
    snd=Splay.ar(snd);
    Out.ar(0,snd);
}))

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
