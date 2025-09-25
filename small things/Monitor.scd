// [F1] Button to monitor SoundIn.ar I have this is in my startup file.

(
Ndef(\mon,{Out.ar(0,SoundIn.ar([0,1])*ToggleFF.kr(KeyState.kr(122,0,1,0)))}).play;
SkipJack({Ndef(\mon).play},inf,false,"monitor")
);

// Turn it off.
(SkipJack.stop("monitor");Ndef(\mon).stop)