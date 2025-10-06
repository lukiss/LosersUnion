// - Choose Your Weapon, eller välj något niceare! - - - - - - - - - - -

b=Buffer.read(s,[ExampleFiles.child,ExampleFiles.apollo11].choose);

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(Ndef(\warpSauce,{
	g=(TChoose.kr(TDuty.kr(Diwhite(3,12)/8),[0,-2,5,-5])).midiratio;

	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	// c=(-36,-34..14).degreeToKey(
	// Scale.choose).midiratio.postln * g;
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	c=([-21]++(-12,-10..13)).degreeToKey(
	Scale.dorian).midiratio.postln * g;
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	r=(c.reverse/(s.sampleRate/[1024,8192].resamp1(c.size)));

	t={Duty.kr(Dwhite(1,3pi)/pi,0,Drand([-1,1],inf)
		*Dxrand(1<<_!7 /Dxrand(1<<_!7,inf),inf))};

	p={	var a; a=(1..c.size);
		TChoose.kr(TDuty.ar(t.abs),
			[a,a.reverse,a.perfectShuffle,a.scramble]
	)};

	j={|trig,speed,trans,vsp|
		speed=(BufRateScale.kr(b));
		trig=TDuty.ar(t.abs)+TDuty.kr(((Diwhite(1,4)/8)));
		vsp=TChoose.kr(TDuty.ar(t.abs),1<<_!8/512);
		Phasor.ar(trig,
			SampleDur.ir*speed*vsp,0,1,
			TRand.kr(0.0,1.0,t.sum*trig)
	)}.();

	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	// This is where i am stuck, i want a more elegant solution
	// for the "v" variable.
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	v=[
		(log2(LFDNoise3.kr(8)+1/2*(p)).sin.abs**8).sin.max,
		(log(LFSaw.kr(t,-1)+1/2*(p.tan*t)).sin.max**8).sin,
		(log2(LFSaw.kr(t)+1/2*(p)).cos.max**(4*t.abs)).sin.abs,
		(log(LFSaw.kr(t)+1/2*(p).tan).cos)>LFSaw.kr(t.sin,0,0.45,0.5),
		(LFSaw.kr(t/4)+1/2*3pi*log((1..c.size)/c.size+pi*3pi)
			.difsqr(LFSaw.kr(t).max*c)).sin.max,
		(LFSaw.kr(t/8)+1/2*13*((1..c.size)/c.size+pi)).sin.max**8,
		(log(LFSaw.kr(t)+1/2*(p)).wrap2(LFSaw.kr(t)*8).max).sin.abs,
		(log10(LFSaw.kr(t.tan)+1/2
			*(p.cpsmidi).tan).sin.max**(ceil(t.abs)*4)),
		((LFSaw.kr(t)+1/2*(p*(log(LFSaw.kr(t.tan)+1/2*pi)))).sin.max
			**(ceil(t.abs)*8)),
		(log(LFSaw.kr(t.tan)+1/2*
			(p*(log10(LFSaw.kr(t)+1/2*c.size)))).sin.abs
			**(ceil(t.abs)*8)).sin.max,
		(log2(LFSaw.kr(t)+1/2*(p
			.ring4((LFSaw.kr(t)
			+1/2**t.abs*c.size)))).cos.max**(t.abs*8)).sin.max,
		(log10(LFSaw.kr(t)+1/2*(p
			.ring4((LFSaw.kr(t)+1/2
				**t.abs*c.size)))).cos.max**t.abs).sin.max,
		(log(LFSaw.kr(t)+1/2*(p
			.ring4((LFSaw.kr(t)+1/2**t.abs*c.size)
				*t.abs))).cos.max**t.abs).sin.abs,
		(log10(LFSaw.kr(t%6)+1/2**t.abs*(p
			.ring3((LFSaw.kr(t%6)+1/2*(ceil(t.abs*8)))))).sin.max
		**(ceil(t.abs)*4)).sin.abs,
		(log2(LFSaw.kr(t)+1*(p
			.ring2(tan(LFSaw.kr(t)+1/2**8)*8))).sin.max
		**(LFSaw.kr(t)+1*8+2)).sin.abs,
		((log(LFSaw.kr(t)+1/2*(p)).sin.max**(t.abs*4)).sin.abs),
		LFSaw.kr(t*2,(2*((c.size..1)/c.size))-1).max**32,
		0.25!c.size,
		(log(LFSaw.kr(t).acos.max*(p)).cos.max**(16)),
		(log2(p.ring4(1-LFSaw.kr(t)**2*0.75pi)).cos.max**(8)),
		((log10((LFSaw.kr(t%2pi)+1/2*p).cpsmidi)
			.wrap*0.25pi).sin.max**(16)),
		(log10(LFSaw.kr(t.wrap2(6))+1/2*p).cos
			**(LFSaw.kr(t)+1*8+0s)).sin.max**(8),
		1-(((LFSaw.kr(t.abs/16,-1).abs*1.5pi
			*(p/c.size+1pi)).sin.hanWindow)**18)*0.4,
		(p/c.size),
		((p/c.size).hanWindow**t.abs).sin.max,
		0!c.size+[0,1],
		0!c.size+[1,0]
	].scramble;

	o=LeakDC.ar(Warp1.ar(1,b,
		TChoose.kr(
			CoinGate.ar(0.3,TDuty.ar(t.abs)),
			[
				TRand.kr(0.0,1.0,TDuty.ar(t.abs)),
				j,j,j,
				LFSaw.kr(1/b.duration/TChoose.kr(TDuty.ar(t.abs),1<<_!12))+1/2
		])
		+LFNoise2.kr(8!c.size).range(0.0051,0.001),
		c,r,-1,2pi,LFNoise2.kr(8!c.size).range(0.0151,0.001),4,
	).sanitize);

	o=o*Select.kr(Stepper.kr(CoinGate.kr(1/2,TDuty.ar(t.abs)),0,0,v.size,1),v);
	o=o.sanitize;
	o=Splay.ar(HPF.ar(o,50),SinOsc.ar(c.size*p@0/2));
	o=CompanderD.ar(LPZ2.ar(o),1/2,1/2,1/3,0.01,0s);
	o=LeakDC.ar(o);
	o=Limiter.ar(o);
	Out.ar(0,o)
}))

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
