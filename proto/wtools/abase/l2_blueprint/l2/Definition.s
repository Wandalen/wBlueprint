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
  _.assert( _.longHas( _.definition.DefinitionKind, o.definitionGroup ) );
  return this;
}

Definition.prototype = Object.create( null );
Definition.prototype.clone = function()
{
  return new Definition( this );
}

//

function _constructionAmendCant( construction, key )
{
  let trait = this;
  debugger;
  throw _.err( `Trait::${trait.kind} cant extend created construction after initialization. Use this trait during initialization only.` );
}

//

function _traitMake( routine, o )
{

  _.assert( arguments.length === 2 );
  _.assert( _.routineIs( routine ) );
  _.assert( _.strDefined( routine.name ) );
  _.assert( _.mapIs( o ) );

  o.definitionGroup = 'trait';
  // o.val = null;
  o.kind = routine.name;
  if( !o.constructionAmend )
  o.constructionAmend = _.definition._constructionAmendCant;

  let definition = new _.Definition( o );
  Object.freeze( definition );
  return definition;
}

// --
// define
// --

let DefinitionKind = [ 'etc', 'trait', 'definition.unnamed', 'definition.named' ];

let KnownFields =
{
  valueGenerate : 'routine::valueGenerate( map::o ) -> anything::',
  constructionAmend : 'routine::constructionAmend( Construction::construction primitive::key ) -> nothing::',
  blueprintAmend : 'routine::( map::o ) -> nothing::',
  blueprintForm1 : 'routine::( Blueprint::blueprint ) -> nothing::',
  blueprintForm2 : 'routine::( Blueprint::blueprint ) -> nothing::',
  blueprintForm3 : 'routine::( Blueprint::blueprint ) -> nothing::',
}

let BlueprintInternalRoutines =
{
  blueprintAmend : 'routine::( map::o ) -> nothing::',
  blueprintForm1 : 'routine::( Blueprint::blueprint ) -> nothing::',
  blueprintForm2 : 'routine::( Blueprint::blueprint ) -> nothing::',
  blueprintForm3 : 'routine::( Blueprint::blueprint ) -> nothing::',
}

let ConstructionInternalRoutines =
{
  constructionInit : null,
  constructionAmend : 'routine::constructionAmend( Construction::construction primitive::key ) -> nothing::',
  allocate : null,
  reconstruct : null,
  initBegin : null,
  initEnd : null,
}

//

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
  _constructionAmendCant,
  _traitMake,

  // fields
  DefinitionKind,
  KnownFields,
  BlueprintInternalRoutines,
  ConstructionInternalRoutines,

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
