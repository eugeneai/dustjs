/**
 * helper for including re-usable shared partials such as degree icon, miniprofile and ads
 * @method partial
 * @param {Object} params a configuration object created from attributes set in the template.
 * template param specifies the partial template to be rendered --optional
 * key params specifies the special context for the partial tag data --optional, defaults to creating tag data in partial block
 */
dust.helpers.partial = function( chunk, context, bodies, params ){
  var partial = {};
	if( params) {
	 var partialTagContext = params.key ? params.key : "partial" ;
	  for(var param in params) {
    	if(param !== 'key') {
	     partial[param] = params[param];
    	}
	  }
	}
	// append pre tag data
	var partialTagData = context.get(partialTagContext);
	if(partialTagData){
	  for(var data in partialTagData){
	 	 partial[data] = partialTagData[data];
	 }
	}
	partial.isPartial= true;

  // before rendering creates new context using makeBase
  if(params && params.template) {//use the name arg as the partial file to render
    // if there is a context, append it
    var template = params.template;
    // no override context
    if(template.indexOf(":") == -1) {
      return chunk.partial(template, dust.makeBase(partial));
    } 
    else {
      var contextIndex = template.indexOf(":");
      var overrideContext = template.substring(parseInt(contextIndex + 1));
      template = template.substring(0, parseInt(contextIndex));
      var partialOverrideContext = context.get(overrideContext);
      if(partialOverrideContext) {
        for(var data in partialOverrideContext) {
          partial[data] = partialOverrideContext[data];
        }
      }
      return chunk.partial(template, dust.makeBase(partial));
    }
  } 
  else {
    return bodies.block(chunk, dust.makeBase(partial));
  }
};


/**
 * helper works only with the partial, no body at this point
 * provides defaults to key params used in partial helper
 * @method param
 * @param {Object} params a configuration object created from attributes set in the template.
 */
dust.helpers.param = function( chunk, context, bodies, params ){
	if(context.global.isPartial){
	 if(params){
     var key = params.key, 
         defaultVal = params.defaultVal, 
         pKeyValue = context.global[key]; 
	  if(key && !pKeyValue && defaultVal){
	   context.global[key] = defaultVal;
	  }
	 }
	}
  return chunk;
};
