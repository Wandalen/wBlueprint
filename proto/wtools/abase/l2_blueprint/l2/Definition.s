( function _Definition_s_() {

'use strict';

/**
* Collection of definitions for constructions.
* @namespace wTools.define
* @extends Tools
* @module Tools/base/Proto
*/

let Self = _global_.wTools;
let _global = _global_;
let _ = _global_.wTools;

// --
// implement
// --

/**
* @classdesc Class container for creating property-like entity from non-primitive value.
  Is used by routines:
  @see {@link module:Tools/base/Proto.wTools.define.own}
  @see {@link module:Tools/base/Proto.wTools.define.common}
  @see {@link module:Tools/base/Proto.wTools.define.instanceOf}
  @see {@link module:Tools/base/Proto.wTools.define.makeWith}
  @see {@link module:Tools/base/Proto.wTools.define.contained}
* @class Definition
* @namespace Tools.define
* @module Tools/base/Proto
*/

function Definition( o )
{
  _.assert( arguments.length === 1 );
  if( !( this instanceof Definition ) )
  if( o instanceof Definition )
  return o;
  else
  return new( _.constructorJoin( Definition, arguments ) );
  _.mapExtend( this, o );
  _.assert( _.longHas( _.definition.DefinitionGroup, o.defGroup ) );
  return this;
}

Object.setPrototypeOf( Definition, null );
Definition.prototype = Object.create( null );
Definition.prototype.clone = function()
{
  let result = new Definition( this );
  return result;
}

//

function retype( o )
{
  _.assert( _.mapIs( o ) );
  Object.setPrototypeOf( o, Definition.prototype );
  return o;
}

//

function toVal( definition )
{
  _.assert( _.definitionIs( definition ) );
  _.assert( _.routineIs( definition.toVal ) );
  _.assert( definition.val !== undefined );
  return definition.toVal( definition.val );
}

// //
//
// function _constructionAmendCant( construction, key )
// {
//   let trait = this;
//   return _.construction._amendCant( construction, definition, key );
//   // throw _.err( `Trait::${trait.kind} cant extend created construction after initialization. Use this trait during initialization only.` );
// }

//

function _traitMake( kind, o ) /* xxx : reuse _definitionMake */
{

  _.assert( arguments.length === 2 );
  _.assert( _.strDefined( kind ) );
  _.assert( _.mapIs( o ) );
  // _.assert( o._blueprint === undefined || o._blueprint === null || o._blueprint === false );
  _.assert( o._blueprint === null || o._blueprint === false );

  if( !o.defGroup )
  o.defGroup = 'trait';
  if( !o.kind )
  o.kind = kind;
  // if( !o.constructionAmend ) /* yyy */
  // {
  //   o.constructionAmend = constructionAmend;
  //   // console.log( `Generated _amendDefinitionWithoutMethod for ${o.kind}` );
  // }
  if( o._blueprint === undefined )
  o._blueprint = null;

  let definition = new _.Definition( o );
  // let definition = _.definition.retype( o ); /* xxx : use */
  // _.assert( definition ==== o );
  _.assert( definition.blueprintAmend === undefined );
  _.assert( definition.constructionAmend === undefined );
  _.assert( definition.blueprint === undefined );

  if( definition._blueprint === false ) /* xxx */
  Object.freeze( definition );
  else
  Object.preventExtensions( definition );

  return definition;

  // function constructionAmend( dst, key, amending )
  // {
  //   debugger;
  //   _.construction._amendDefinitionWithoutMethod
  //   ({
  //     construction : dst,
  //     definition,
  //     key,
  //     amending,
  //   });
  // }

}

//

function _definitionMake( kind, o )
{

  _.assert( arguments.length === 2 );
  _.assert( _.strDefined( kind ) );
  _.assert( _.mapIs( o ) );
  // _.assert( o._blueprint === undefined || o._blueprint === null || o._blueprint === false );
  _.assert( o._blueprint === null || o._blueprint === false );

  if( !o.defGroup )
  o.defGroup = 'definition.unnamed';
  if( !o.kind )
  o.kind = kind;
  // if( !o.constructionAmend ) /* yyy */
  // o.constructionAmend = constructionAmend;
  if( o._blueprint === undefined )
  o._blueprint = null;

  let definition = new _.Definition( o );

  _.assert( definition.blueprintAmend === undefined );
  _.assert( definition.constructionAmend === undefined );
  _.assert( definition.blueprint === undefined );

  // Object.preventExtensions( definition );

  if( definition._blueprint === false ) /* xxx */
  Object.freeze( definition );
  else
  Object.preventExtensions( definition );

  return definition;

  // function constructionAmend( dst, key, amending )
  // {
  //   debugger;
  //   _.construction._amendDefinitionWithoutMethod
  //   ({
  //     construction : dst,
  //     definition,
  //     key,
  //     amending,
  //   });
  // }

}

// --
// define
// --

/**
* Routines to manipulate definitions.
* @namespace wTools.definition
* @extends Tools
* @module Tools/base/Proto
*/

let DefinitionExtension =
{

  // routines

  is : _.definitionIs,
  retype,
  toVal,
  // _constructionAmendCant,
  _traitMake,
  _definitionMake,

  // fields

}

_.define = _.define || Object.create( null );
_.definition = _.definition || Object.create( null );
_.mapExtend( _.definition, DefinitionExtension );
_.assert( _.routineIs( _.definitionIs ) );
_.assert( _.definition.is === _.definitionIs );

//

let ToolsExtension =
{
  Definition,
}

_.mapExtend( _, ToolsExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
