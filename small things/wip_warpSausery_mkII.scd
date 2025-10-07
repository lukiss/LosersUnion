(
// Disable cheats  - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
s.options.numWireBufs=64;
s.options.blockSize=64;
s.options.memSize=8192;
s.reboot;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
s.waitForBoot{
	b=Buffer.read(s,[ExampleFiles.child,ExampleFiles.apollo11].choose);
	0.1.wait;
	Ndef(\warpSauce,{
		// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		g=(TChoose.kr(TDuty.kr(Diwhite(3,12)/8),[0,-2,5,-5])).midiratio;
		c=([-28]++(-21,-19..14)).degreeToKey(
		Scale.choose.postln).midiratio * g;
		r=(c.reverse/(s.sampleRate/[1024,8192].resamp1(c.size)));
		// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		t={Duty.kr(Diwhite(1,6)/8,0,Drand([-1,1],inf)
			*Dxrand(1<<_!8 / Dxrand(1<<_!8, inf), inf)).fold(0s,pi/2)};
		u=TChoose.kr(CoinGate.kr(1/7,TDuty.kr(t.abs)),_);
		p={	var a=(1..c.size);
			u.([a,a.reverse,a.perfectShuffle,a.scramble]
		)};
		j={|trig,speed,trans,vsp|
			speed=(BufRateScale.kr(b));
			trig=TDuty.kr(((Diwhite(1,4)/8)));
			vsp=TChoose.kr(trig,1<<_!8/512);
			Phasor.ar(trig,
				SampleDur.ir*speed*vsp,0,1,
				TRand.kr(0.0,1.0,trig)
		)}.();
		m={u.(({|n|0!c.size+(n+1).asDigits(2)}!c.size))};
		i={u.((-4..4)+0s1)};
		y={[ LFSaw.kr(u.([t,i,t.tan,i.sin])),
			 LFSaw.kr(u.([m*t,m*i,i!c.size,t!c.size]))]};
		v=((log2(u.(y.())+1/2*(u.(y.())+2*p)).sin.max
			**((u.(y.())+2*u.([8,p])).wrap(0.125,12))).sin.abs
			**((u.(y.())+2*(u.([8,p]))).wrap(0.125,12))
			*u.([m,1!c.size])).sin;

	o=Sanitize.kr(v)*Sanitize.ar(
		Warp1.ar(1,b,
				u.([TRand.kr(0.0,1.0,TDuty.kr(t.abs*4)).lag3(t.abs/128),j])
		+LFNoise2.kr(8!c.size).range(0.0151,0.001),
		c,r,-1,2pi,LFNoise2.kr(8!c.size).range(0.0151,0.001),4,
		));
		o=Splay.ar(o,SinOsc.ar(i));
		o=CompanderD.ar(LPZ2.ar(o),1/2,1/2,1/2,0s1,0s);
	o=LeakDC.ar(o);
	o=Limiter.ar(o);
	Out.ar(\out.kr(0),o);
})
})