var peg  = require('pegjs'),
    fs   = require('fs'),
    path = require('path'),
    root = path.join(path.dirname(__filename), "..");

var options = {
    cache: false,
    trackLineAndColumn: true,
    output:"source"
};

var parser_src = peg.buildParser(fs.readFileSync(path.join(root, 'src', 'dust.pegjs'), 'utf8'), options);

var namespace = 'parser';

fs.writeFileSync(path.join(root, 'lib', 'parser.js'), "(function(dust){\n\nvar "+namespace+" = "
  + parser_src.replace('this.SyntaxError', ''+namespace+'.SyntaxError') + ";\n\n"
  + "dust.parse = "+namespace+".parse;\n\n"
  + "})(typeof exports !== 'undefined' ? exports : getGlobal());"
);
