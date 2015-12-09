var PEG  = require('pegjs'),
    fs   = require('fs'),
    path = require('path'),
    root = path.join(path.dirname(__filename), "..");

var parser_src = PEG.buildParser(
    fs.readFileSync(path.join(root, 'src', 'dust.pegjs'), 'utf8'), {output:"source"});

fs.writeFileSync(path.join(root, 'lib', 'parser.js'), "(function(dust){\n\nvar parser = "
  + parser_src.replace('this.SyntaxError', 'SyntaxError') + ";\n\n"
  + "dust.parse = parser.parse;\n\n"
  + "})(typeof exports !== 'undefined' ? exports : window.dust);"
);
