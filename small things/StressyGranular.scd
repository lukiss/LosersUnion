
// Replace with something more interresting.

b=Buffer.read(s,ExampleFiles.apollo11);

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(Ndef(\igen,{
	var snd,t,pos,lap,curve,ps,pe,win,fs,pitch,lfo;

	lfo={
		var trig,rnd;
		trig=TDuty.kr(Diwhite(1/13,2/3));
		rnd={TChoose.kr(trig,2**_!8/16)};
		TChoose.kr(trig,
			[
				LFNoise2.kr(rnd).clip2,
				LFNoise0.kr(rnd*4).clip2
			]
		).lag(rnd/16)
	};

	f=lfo.lincurve(-1,1,0.5,110,8);
	g=lfo.lincurve(-1,1,1/64,4,lfo*6);
	lap=lfo.lincurve(-1,1,0.01,1b,lfo*4);
	curve = LFNoise2.kr(1).linlin(-1,1,-18,-4);
	ps=lfo.lincurve(-1,1,-24,24,lfo*4).midiratio;
	fs=LFNoise2.ar(0.01)+1/2*b.numFrames;
	pe=lfo.lincurve(-1,1,-24,24,lfo*4).midiratio;
	win=lfo.lincurve(-1,1,128,8192,lfo*4);
	pos=lfo.linlin(-1,1,0,b.numFrames);
	pitch=lfo.linlin(-1,1,-14,14,lfo*4).midiratio;
	t=Impulse.ar(f/16,(..15)/16);

	snd={|n|
		Pan2.ar(LeakDC.ar(
			BufRd.ar(1,b,
				Phasor.ar(
					t@n,
					BufRateScale.kr(b)*pitch
					*Env.perc(0s3,lap/g/4+0s3,1,-1*curve)
					.ar(0,t@n).linlin(0,1,ps,pe),
					fs,
					fs+win,fs).wrap(0,b.numFrames)
				,0,4)
			*ar(Env.perc(0s2,(lap/g).wrap(0s3,g),1,curve),0,t@n)
		),LFNoise2.kr(1/2)/1.5)
	}!t.size;
	snd=snd.sum;
	snd=LPZ2.ar(snd);
	snd=Splay.ar(snd);
	snd=PitchShift.ar(snd,1/8,(lfo!2/5).midiratio) + snd * -12.dbamp;
	snd=CompanderD.ar(snd,1/2,2/3,1/2,0s1,1b);
	Out.ar(0,snd)
}))


