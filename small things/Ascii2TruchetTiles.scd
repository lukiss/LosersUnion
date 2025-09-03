//  - - - - - - - - - - - - - - - - - - - - - - - - -
//  ASCII to Truchet Tiles encoder or cipher if you
//  will. I needed this. For reasons.
//
//  Attempt no. 1 - - - - - - - - - - - - - - - - - -

(
t={|p|
	p.postln;{"- ".post}!(p.size/2+1);Post.nl;
	x=flat({|n|p.ascii[n].asDigits(4)}!p.size);
	o=x.size.do{|n|i=x[n];["◢","◣","◤","◥"][i].post};
	Post.nl;
};

t.("Goodbye, Cruel World.");
)

//  Attempt no. 2 - - - - - - - - - - - - - - - - - -

(
t = {|p,q|
	p.postln;{"- ".post}!(p.size/2+1);Post.nl;
	q="";p.ascii.collect({|a|c=a.asDigits(4);
	c.size.do{|n|q=q++(["◢","◣","◤","◥"][n])}
	});q.postln;Post.nl};

t.("I'll never get the hang of .collect");
)

//  - - - - - - - - - - - - - - - - - - - - - - - - -
