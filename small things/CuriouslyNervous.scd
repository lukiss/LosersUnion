(
s.options.blockSize_(1);s.reboot.waitForBoot{
	(Ndef(\CuriouslyNervous,{
		d=CuspL.ar(444)*0.0006;
		m={TChoose.ar(Dust.ar(2),[LFNoise2.ar(2),LFNoise0.ar(1)]+d).wrap2};
		o=d+LocalIn.ar+Impulse.ar(0);
		o={|i|OnePole.ar(o,m.().linlin(-1,1,0.9995,0.95)+(i/1000)+d)}!4;
		o={|i|fold2(o@i*(1+m*pi))}!4;
		o={|i|MoogFF.ar(o@i,m+1/2*3000+40)}!4;
		LocalOut.ar(o.sum);
		o=LeakDC.ar(o);
		o=Splay.ar(o.sanitize * -5.dbamp) ;
		Out.ar(0,o);
}))}
)