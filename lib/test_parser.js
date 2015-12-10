var parse=require("./parser", dust).parse;

var dust=require("./dust");
var util=require("util");
var beautify=require("js-beautify");

var istr='\
{hello asd qwe=kl | qwe |r| q| r| h | u} \n\
{#rdf:subj k=n jkhj ha:kl gh:hu=kl:ng } \n\
{k} {jkhj} {@view oa:hasTarget class=foaf:Person name=personView /} \n \
{/rdf}\n';

//{@view oa:hasTarget class=foaf:Person name=personView /} \n \

//istr='{hello jk:asd ll=kk dd:qwe=kl:dfg kl=10.5 /}';

//istr='{yhello ll="oa:kk jj:kk" jj:kk=bb:ll ty=10.9 | q|w|e}';

console.log(istr);

var ast=parse(istr);
console.log(util.inspect(ast, false, null));

var source=dust.compile(istr);
console.log(beautify(source,{indent_size:2}));
