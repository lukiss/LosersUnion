// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
//  A silly little frontend for the GrainFM Ugen.
//
//  Sound starts when you alter the last window. F1 Resets the LFO/Env buffer
//  reader. F2 - F11 sets how it is read.
//
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(
s.options.blockSize_(1);
s.reboot.waitForBoot{
	var keez="[F1] ReSync , [F2]-[F11] Speeds [t] OnTop||| ";
	// var fg=Color(5/5,1/5,0/5);
	var fg=Color.black;

	(
		w=Window(
			keez + "|_(_)_\\_\\|=_|)_ UNION".toUpper.scramble,
			Rect(120,120,810,3*150+10),false).front;

		j=Image(8,8);j.draw({
			Pen.color_(fg);
			Pen.fillOval(Rect.aboutPoint(2@2,6/5,6/5));
			Pen.fillOval(Rect.aboutPoint(6@6,6/5,6/5));
		});

		w.addFlowLayout( 0@10, 0@0 );
		w.background_(Color(1,1,0,1));
		w.view.setBackgroundImage(j,5);
		w.alwaysOnTop_(true);

		// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		b=Buffer.allocConsecutive(6,s,128,1,bufnum: 1000);
		z={|n|Env.sine.discretize(128).rotate(n*24)}!6;

		o={|n|p=Plotter("Hej",Rect(0,0,400,150),w);
			p.editMode_(true);
			p.editFunc_({sendCollection(b[n],o[n].value)});
			p.plotMode_(\dstems);
			p.plotColor_(fg);
			p.resolution_(0);
			p.value_(z[n]).setProperties(
				\backgroundColor, Color.clear,
				\gridColorY, Color(1/5,0/5,3/5),
				\gridColorX, Color(1/5,0/5,3/5),
			);
			p.showUnits_(false);
			p.setGridProperties(\x,\numTicks,8
			);
		}!6;

		CmdPeriod.doOnce { w.close };

		// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		Ndef(\_,{ var snd;

			r=BufRd.ar(1,_,
				Phasor.ar(
					\reset.tr,
					LFNoise2.ar(2,\drift.kr(0.123),\fwd.kr(1))*SampleDur.ir,
					0,1)*b[0].numFrames,1,1
			);

			snd=Splay.ar(
				LeakDC.ar(
					GrainFM.ar(2,
						Impulse.ar((r.(b[0]).linlin(0,1,0.5,220))),
						1/(r.(b[1])*310+1),
						r.(b[2]).lincurve(0,1,40,1820,5),
						r.(b[3]).lincurve(0,1,80,2820,5),
						r.(b[4]).lincurve(0,1,0.2,8,8);,
						sin(r.(b[1])*2pi*r.(b[5])),
						b[5])
				).softclip
			);
			snd=FreeVerb.ar(snd,1/24,r.(b[1]),1-r.(b[5]));
			snd=PitchShift.ar(
				snd,1/8,sin(r.(b[3])*2pi*r.(b[5])/2).midiratio,
				0.01,0.01,1,Median.ar(5,snd)
			);

			Out.ar(0,{
				Compander.ar(DelayC.ar(snd,1/128,1/128),snd,
					1/2,1/2,1/2,0.001,0s).softclip}
			);

		}
		);

		w.view.keyDownAction = { |doc, char, mod, unicode, keycode, key|
			[doc, char, mod, unicode, keycode, key].postln;

			case(
			{ key==16777264 }, { Ndef(\_).set(\reset,1)},
			{ key==16777265 },
					{ Ndef(\_).set(\fwd,1);
						w.name_(keez+Ndef(\_).getKeysValues.asString)
					},
			{ key==16777266 },
				{ Ndef(\_).set(\fwd,0.5);
						w.name_(keez+Ndef(\_).getKeysValues.asString)
				},
			{ key==16777267 },
				{ Ndef(\_).set(\fwd,0.25);
					w.name_(keez+Ndef(\_).getKeysValues.asString)},
			{ key==16777268 },
				{ Ndef(\_).set(\fwd,0.125);
					w.name_(keez+Ndef(\_).getKeysValues.asString)},
			{ key==16777269 },
				{ Ndef(\_).set(\fwd,0);
					w.name_(keez+Ndef(\_).getKeysValues.asString)},
			{ key==16777270 },
				{ Ndef(\_).set(\drift,0.125/2);
					w.name_(keez+Ndef(\_).getKeysValues.asString)},
			{ key==16777271 },
				{ Ndef(\_).set(\drift,0.125);
					w.name_(keez+Ndef(\_).getKeysValues.asString)},
			{ key==16777272 },
					{ Ndef(\_).set(\drift,0.25);
						w.name_(keez+Ndef(\_).getKeysValues.asString)},
			{ key==16777273 },
					{ Ndef(\_).set(\drift,0.5);
						w.name_(keez+Ndef(\_).getKeysValues.asString)},
			{ key==16777274 },
					{ Ndef(\_).set(\drift,1);
						w.name_(keez+Ndef(\_).getKeysValues.asString)},
				{ key==84 },
				{ if(w.alwaysOnTop==false){w.alwaysOnTop_(true)}{w.alwaysOnTop_(false)}}
	);
};
)})
