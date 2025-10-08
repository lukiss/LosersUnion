
(
// Disable cheats  - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
s.options.numWireBufs=64;
s.options.blockSize=64;
s.options.memSize=8192;
s.reboot;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
s.waitForBoot{
	b=Buffer.read(s,[apollo11(_),child(_)].choose.(ExampleFiles));
	0.1.wait;
	play{PlayBuf.ar(1,b,BufRateScale.kr(b),doneAction: 2)!2};
	(b.duration*0.9).wait;
	Ndef(\warpSauce,{
		// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		g=(TChoose.kr(TDuty.kr(Diwhite(3,12)/8),[0,-2,5,-5])).midiratio;
		c=([-28]++(-21,-19..11)).degreeToKey(
			Scale.choose).midiratio * g;
		r=(c.reverse/(s.sampleRate/[1024,8192].resamp1(c.size)));
		// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		t={Duty.kr(Diwhite(1,8)/8,0,Drand([-1,1],inf)*Dwhite(1/16,pi/2))};
		u=TChoose.kr(TDuty.kr(t.abs),_);
		p={var a=(1..c.size);u.([a,a.reverse,a.perfectShuffle,a.scramble])};
		z=(_.asDigits(2,4)!15);
		m={u.(z)};
		i={TIRand.kr(-8,8,TDuty.kr(t.abs.frac))};
		y={[LFSaw.kr(u.([t,i])*t.frac),LFSaw.kr(1!c.size*m*u.([t,i])*t.frac)]};
		v=Sanitize.kr(u.(
			[m/4,(((log(u.(y.())+1/2*(u.(y.())+1s*p)).sin.max
			**(u.([u.(y.())+2*p,12]))).sin.abs
			**(u.([u.(y.())+2*p,12]))).sin
		*u.([m,1]))]).sin);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		o=LeakDC.ar(v*
			Warp1.ar(1,b,
				LFSaw.kr(t>0/b.duration*t.frac.hanWindow)+1/2
				// +LFNoise2.kr(8!c.size).range(0.001,0.0001),
				,c,r,-1,2pi,LFNoise2.kr(8!c.size).range(0.0251,0.001),4,
		));
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		o=Splay.ar(o,(t*i).sin);
		// o=PitchShift.ar(o,1/8,(t!2).midiratio,0s1,0s1)+o;
		o=CompanderD.ar(
			LPZ2.ar(o+HPF.ar(BrownNoise.ar(-144.dbamp!2),880)),
			1/2,1/2,1/2,0.01,2/8).softclip;
		o=LeakDC.ar(o).sanitize;
		o=Limiter.ar(o);
		Out.ar(\out.kr(0),o);
	})
})