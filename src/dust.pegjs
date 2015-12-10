start
  = body

/*-------------------------------------------------------------------------------------------------------------------------------------
   body is defined as anything that matches with the part 0 or more times
---------------------------------------------------------------------------------------------------------------------------------------*/
body
  = p:part* { return ["body"].concat(p) }

/*-------------------------------------------------------------------------------------------------------------------------------------
   part is defined as anything that matches with comment or section or partial or special or reference or buffer
---------------------------------------------------------------------------------------------------------------------------------------*/
part
  = comment / section / partial / special / reference / buffer

/*-------------------------------------------------------------------------------------------------------------------------------------
   section is defined as matching with with sec_tag_start followed by 0 or more white spaces plus a closing brace plus body
   plus bodies plus end_tag or sec_tag_start followed by a slash and closing brace
---------------------------------------------------------------------------------------------------------------------------------------*/
section "section"
  = t:sec_tag_start ws* rd b:body e:bodies n:end_tag &{ return t[1].text === n.text;}
  { e.push(["param", ["literal", "block"], b]); t.push(e); return t }
  / t:sec_tag_start ws* "/" rd
  { t.push(["bodies"]); return t }

/*-------------------------------------------------------------------------------------------------------------------------------------
   sec_tag_start is defined as matching an opening brace followed by one of #?^<+@% plus identifier plus context plus param
   followed by 0 or more white spaces
---------------------------------------------------------------------------------------------------------------------------------------*/
sec_tag_start
  = ld t:[#?^<+@%] ws* n:identifier c:context p:params
  { return [t, n, c, p] }

/*-------------------------------------------------------------------------------------------------------------------------------------
   end_tag is defined as matching an opening brace followed by a slash plus 0 or more white spaces plus identifier followed
   by 0 or more white spaces and ends with closing brace
---------------------------------------------------------------------------------------------------------------------------------------*/
end_tag "end tag"
  = ld "/" ws* n:identifier ws* rd
  { return n }

/*-------------------------------------------------------------------------------------------------------------------------------------
   context is defined as matching a colon followed by an identifier
---------------------------------------------------------------------------------------------------------------------------------------*/
context
  = n:(":" n:identifier {return n})?
  { return n ? ["context", n] : ["context"] }

/*-------------------------------------------------------------------------------------------------------------------------------------
  params is defined as matching white space followed by = and identfier or inline
---------------------------------------------------------------------------------------------------------------------------------------*/
params "params"
  = p:(ws+ a:param {return a;} )*
  { return ["params"].concat(p); }

param "param"
  = k:parkey v:parval {return ["param", ["literal", k], v];}

parkey "parkey"
  = k:(rdfent / key) {return k;}

parval "parval"
  = "=" v:(number / rdfentval / identifier / inline )
       {return v;}
  / "" {var arr=["key", true]; arr.text=true; return arr;}

rdfentval "rdfentval"
  = r:rdfent { var arr=["key", r]; arr.text=r; return arr; };

/*-------------------------------------------------------------------------------------------------------------------------------------
   bodies is defined as matching a opening brace followed by key and closing brace, plus body 0 or more times.
---------------------------------------------------------------------------------------------------------------------------------------*/
bodies "bodies"
  = p:(ld ":" k:key rd v:body {return ["param", ["literal", k], v]})*
  { return ["bodies"].concat(p) }

/*-------------------------------------------------------------------------------------------------------------------------------------
   reference is defined as matching a opening brace followed by an identifier plus one or more filters and a closing brace
---------------------------------------------------------------------------------------------------------------------------------------*/
reference "reference"
  = ld n:identifier p:params f:filters rd
  { return ["reference", n, f, p] }

/*-------------------------------------------------------------------------------------------------------------------------------------
  partial is defined as matching a opening brace followed by a > plus anything that matches with key or inline plus
  context followed by slash and closing brace
---------------------------------------------------------------------------------------------------------------------------------------*/
partial "partial"
  = ld s:(">"/"+") n:(k:key {return ["literal", k]} / inline) c:context p:params ws* "/" rd
  { var key = (s ===">")? "partial" : s; return [key, n, c, p] }

/*-------------------------------------------------------------------------------------------------------------------------------------
   filters is defined as matching a pipe character followed by anything that matches the key
---------------------------------------------------------------------------------------------------------------------------------------*/
filters "filters"
  = f:(ws* "|" ws* n:key ws* {return n})*
  { return ["filters"].concat(f) }

/*-------------------------------------------------------------------------------------------------------------------------------------
   special is defined as matching a opening brace followed by tilde plus key plus a closing brace
---------------------------------------------------------------------------------------------------------------------------------------*/
special "special"
  = ld "~" k:key rd
  { return ["special", k] }

/*-------------------------------------------------------------------------------------------------------------------------------------
   identifier is defined as matching a path or key
---------------------------------------------------------------------------------------------------------------------------------------*/
identifier "identifier"
  = p:path     { var arr = ["path"].concat(p); arr.text = p[1].join('.'); return arr; }
  / k:key      { var arr = ["key", k]; arr.text = k; return arr; }

rdfent "rdfent"
  = r:(n:key ":" i:key {return n+":"+i;}) {return r;}

number "number"
  = n:(frac / integer) { return ['literal', n]; }

frac "frac"
  = l:integer "." r:integer+ { return parseFloat(l + "." + r.join('')); }

integer "integer"
  = digits:[0-9]+ { return parseInt(digits.join(""), 10); }

/*-------------------------------------------------------------------------------------------------------------------------------------
  path is defined as matching a key plus one or more characters of key preceded by a dot
---------------------------------------------------------------------------------------------------------------------------------------*/
path "path"
  = k:key? d:(nestedKey / array)+ {
    d = d[0];
    if (k && d) {
      d.unshift(k);
      return [false, d];;
    }
    return [true, d];
  }
  / "." { return [true, []] }

/*-------------------------------------------------------------------------------------------------------------------------------------
   key is defined as a character matching a to z, upper or lower case, followed by 0 or more alphanumeric characters
---------------------------------------------------------------------------------------------------------------------------------------*/
key "key"
  = h:[a-zA-Z_$] t:[0-9a-zA-Z_$]*
  { return h + t.join('') }

nestedKey "nestedKey"
  = d:("." k:key {return k})+ a:(array)? { if (a) { return d.concat(a); } else { return d; } }

array "array"
  = i:("[" a:([0-9]+) "]" {return a.join('')}) nk: nestedKey? { if(nk) { nk.unshift(i); } else {nk = [i] } return nk; }

/*-------------------------------------------------------------------------------------------------------------------------------------
   inline params is defined as matching two double quotes or double quotes plus literal followed by closing double quotes or
   double quotes plus inline_part followed by the closing double quotes
---------------------------------------------------------------------------------------------------------------------------------------*/
inline "inline"
  = '"' '"'                 { return ["literal", ""] }
  / '"' l:literal '"'       { return ["literal", l] }
  / '"' p:inline_part+ '"'  { return ["body"].concat(p) }

/*-------------------------------------------------------------------------------------------------------------------------------------
  inline_part is defined as matching a special or reference or literal
---------------------------------------------------------------------------------------------------------------------------------------*/
inline_part
  = special / reference / l:literal { return ["buffer", l] }

buffer "buffer"
  = e:eol w:ws*
  { return ["format", e, w.join('')] }
  / b:(!tag !eol !comment c:. {return c})+
  { return ["buffer", b.join('')] }

/*-------------------------------------------------------------------------------------------------------------------------------------
   literal is defined as matching esc or any character except the double quotes and it cannot be a tag
---------------------------------------------------------------------------------------------------------------------------------------*/
literal "literal"
  = b:(!tag c:(esc / [^"]) {return c})+
  { return b.join('') }

esc
  = '\\"' { return '"' }

comment "comment"
  = "{!" c:(!"!}" c:. {return c})* "!}"
  { return ["comment", c.join('')] }

/*-------------------------------------------------------------------------------------------------------------------------------------
   tag is defined as matching an opening brace plus any of #?^><+%:@/~% plus 0 or more whitespaces plus any character or characters that
   doesn't match rd or eol plus 0 or more whitespaces plus a closing brace
---------------------------------------------------------------------------------------------------------------------------------------*/
tag
  = ld [#?^><+%:@/~%] ws* (!rd !eol .)+  ws* rd
  / reference

ld
  = "{"

rd
  = "}"

eol
  = "\n"        //line feed
  / "\r\n"      //carriage + line feed
  / "\r"        //carriage return
  / "\u2028"    //line separator
  / "\u2029"    //paragraph separator

ws
  = [\t\v\f \u00A0\uFEFF] / eol
