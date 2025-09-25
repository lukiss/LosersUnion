( /* Highly annoying, wildly inefficient */
b=control(Bus,s,1);
play{Out.kr(b,Amplitude.ar(sum(SoundIn.ar([0,1])/2).tanh))};

fork{loop{
		a="";
		b.get{|v|q=(v.value.lincurve(0,1,0,1)*32).asInteger};
		q.do{a=a++("|")};Document.current.title_(a);
		0.1.wait
	}}
)
