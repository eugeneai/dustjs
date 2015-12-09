/* your connection code */
//var parser=require("./parser", dust);
//var compiler=require("./compiler", dust);

var dust=require("./dust");

//console.log(parser);
//console.log(compiler);


//parser(dust);
//compiler(dust);



var istr=' \n\
{hello asd qwe | qwe |r| q| r| h | u} \n\
{#rdf:subj k=n jkhj ha:kl gh:hu=kl:ng } \n\
{/rdf}\n';


//console.log(dust);

//var ast=dust.parse(istr);
//console.log(ast);

var source=dust.compile(istr);
console.log(source);
