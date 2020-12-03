( function _BlueprintClass_s_() {

'use strict';

let _global = _global_;
let _ = _global_.wTools;

// --
// implementation
// --

// function blueprintIsBlueprintOf( construction )
// {
//   let blueprint = this;
//   _.assert( arguments.length === 1 );
//   _.assert( _.blueprint.is( blueprint ) );
//   return _.blueprint.isBlueprintOf( blueprint, construction );
// }

// //
//
// function blueprintCompileSourceCode()
// {
//   let blueprint = this;
//   _.assert( arguments.length === 0 );
//   return _.blueprint.compileSourceCode( blueprint );
// }

// --
// declare
// --

let BlueprintConstructorPrototype = Object.create( null );

let BlueprintRuntime = Object.create( null );
Object.preventExtensions( BlueprintRuntime );

function Blueprint()
{
  return _.blueprint.define( ... arguments );
}
Blueprint.prototype = null; /* yyy */
Object.setPrototypeOf( Blueprint, null ); /* yyy */
// Blueprint.isBlueprintOf = blueprintIsBlueprintOf; /* xxx : move out? */
// Blueprint.compileSourceCode = blueprintCompileSourceCode; /* xxx : move out? */
Object.preventExtensions( Blueprint );

// --
// define tools
// --

var ToolsExtension =
{

  // fields

  BlueprintConstructorPrototype,
  BlueprintRuntime,
  Blueprint,

}

Object.assign( _, ToolsExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
