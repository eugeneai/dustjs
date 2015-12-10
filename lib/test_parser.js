/* your connection code */
var parse=require("./parser", dust).parse;
//var compiler=require("./compiler", dust);

var dust=require("./dust");
var util=require("util");

//console.log(parser);
//console.log(compiler);


//parser(dust);
//compiler(dust);

/*
[ 'body',
  [ 'buffer', ' ' ],
  [ 'format', '\n', '' ],
  [ 'reference',
    [ 'key', 'hello', text: 'hello' ],
    [ 'filters', 'qwe', 'r', 'q', 'r', 'h', 'u' ],
    [ 'params', [Object], [Object] ] ],
  [ 'buffer', ' ' ],
  [ 'format', '\n', '' ],
  [ '#',
    [ 'key', 'rdf', text: 'rdf' ],
    [ 'context', [Object] ],
    [ 'params', [Object], [Object], [Object], [Object] ],
    [ 'bodies', [Object] ] ],
  [ 'format', '\n', '' ] ]
*/


var istr=' \n\
{hello asd qwe=kl | qwe |r| q| r| h | u} \n\
{#rdf:subj k=n jkhj ha:kl gh:hu=kl:ng } \n\
{/rdf}\n';

istr='{#hello jk:asd ll=kk dd:qwe=kl:dfg \
     kl=10.5 /}';

console.log(istr);

var ast=parse(istr);
console.log(util.inspect(ast, false, null));

var source=dust.compile(istr);
console.log(source);
