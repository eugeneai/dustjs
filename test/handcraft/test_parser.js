var parse=require("../../lib/parser", dust).parse;

var dust=require("../../lib/dust");
var util=require("util");
var beautify=require("js-beautify");

var istr='\
{hello}{hello|a}{hello ab|c}{hello ab}\
{hello asd qwe=kl | qwe |r| q| r| h | u} \n\
{#rdf:subj k=n jkhj ha:kl gh:hu=kl:ng } \n\
{k} {jkhj} {@view oa:hasTarget class=foaf:Person name=personView /} \n \
{/rdf}\n';

//{@view oa:hasTarget class=foaf:Person name=personView /} \n \

istr='<a>{#stream}{#delay}{.}{/delay}{/stream}/}</a>';

var test_data=function() {
  var d = 1;
  return {
    stream: function() {
      return "asynchronous templates for the browser and node.js".split('');
    },
    delay: function(chunk, context, bodies) {
      return chunk.map(function(chunk) {
        setTimeout(function() {
          chunk.render(bodies.block, context).end();
        }, d++ * 15);
      });
    }
  };
};

console.log(istr);
/*
var ast=parse(istr);
console.log(util.inspect(ast, false, null));
*/

var source=dust.compile(istr, "test");
console.log(beautify(source,{indent_size:2}));

// var fn=dust.compileFn(istr);

/*
dust.render("test", test_data(), function(err, out) {
  console.log(out);
});
*/
