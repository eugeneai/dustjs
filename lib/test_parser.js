/* your connection code */

var parser=require("./parser").parse;

var istr=' \n\
{hello asd qwe | qwe |r| q| r| h | u} \n\
{#rdf:subj k=n jkhj ha:kl gh:hu=kl:ng } \n\
{/rdf}\n';

var source=parser(istr);

console.log(source);
