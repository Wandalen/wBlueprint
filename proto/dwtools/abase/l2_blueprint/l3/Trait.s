( function _Trait_s_() {

'use strict';

let Self = _global_.wTools;
let _global = _global_;
let _ = _global_.wTools;

let Definition = _.Definition;
_.routineIs( Definition );

// --
// implementation
// --

function callable( o )
{
  if( !_.mapIs( o ) )
  o = { callback : arguments[ 0 ] };
  _.routineOptions( callable, o );
  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( o.value ) );

  return _.definition._traitMake( callable, o );
}

callable.defaults =
{
  callback : null,
}

//

function typed( o )
{
  if( !_.mapIs( o ) )
  o = { value : arguments[ 0 ] };
  _.routineOptions( typed, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.boolIs( o.value ) );

  o.blueprintForm2 = blueprintForm2;

  return _.definition._traitMake( typed, o );

  function blueprintForm2( blueprint )
  {
    _.assert( blueprint.constructionHandlers.allocate === undefined );
    _.assert( _.boolIs( blueprint.traits.typed.value ) );
    if( blueprint.traits.typed.value )
    blueprint.constructionHandlers.allocate = allocateTyped;
    else
    blueprint.constructionHandlers.allocate = allocateUntyped;
  }

  function allocateTyped( construction, blueprint )
  {
    if( construction === null )
    construction = new( _.constructorJoin( blueprint.construct, [ blueprint ] ) );
    _.assert( construction === null || construction instanceof blueprint.construct );
    return construction;
  }

  function allocateUntyped( construction, blueprint )
  {
    if( construction && construction instanceof blueprint.construct )
    construction = Object.create( null );
    else if( construction === null )
    construction = Object.create( null );
    _.assert( construction === null || _.mapIs( construction ) );
    _.assert( !( construction instanceof blueprint.construct ) );
    return construction;
  }

}

typed.defaults =
{
  value : true,
}

//

function extendable( o )
{
  if( !_.mapIs( o ) )
  o = { value : arguments[ 0 ] };
  _.routineOptions( typed, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.boolIs( o.value ) );

  o.blueprintForm2 = blueprintForm2;

  return _.definition._traitMake( extendable, o );

  function blueprintForm2( blueprint )
  {
    _.assert( _.boolIs( blueprint.traits.extendable.value ) );
    if( blueprint.traits.extendable.value )
    return;
    blueprint.constructionHandlers.initEnd = blueprint.constructionHandlers.initEnd || [];
    blueprint.constructionHandlers.initEnd.push( preventExtensions );
  }

  function preventExtensions( construction, blueprint )
  {
    Object.preventExtensions( construction );
  }

}

extendable.defaults =
{
  value : true,
}

//

function prototype( o )
{
  if( !_.mapIs( o ) )
  o = { value : arguments[ 0 ] };
  _.routineOptions( typed, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.blueprint.is( o.value ) );

  o.blueprintForm2 = blueprintForm2;

  return _.definition._traitMake( prototype, o );

  function blueprintForm2( blueprint )
  {
    _.assert( _.blueprint.is( blueprint.traits.prototype.value ) );
    blueprint.construct.prototype = Object.create( blueprint.traits.prototype.value.construct.prototype );
  }

}

prototype.defaults =
{
  value : true,
}

// --
// define
// --

/**
* Collection of definitions which are traits.
* @namespace "wTools.trait"
* @augments wTools
* @memberof module:Tools/base/Proto
*/

let TraitExtension =
{

  callable,
  typed,
  extendable,
  prototype,

}

_.trait = _.trait || Object.create( null );
_.mapExtend( _.trait, TraitExtension );

//

/**
* Routines to manipulate traits.
* @namespace "wTools.definition"
* @augments wTools
* @memberof module:Tools/base/Proto
*/

let DefinitionTraitExtension =
{

  // routines
  is : _.traitIs,

}

_.definition.trait = _.definition.trait || Object.create( null );
_.mapExtend( _.definition.trait, DefinitionTraitExtension );
_.assert( _.routineIs( _.traitIs ) );
_.assert( _.definition.trait.is === _.traitIs );

//

let ToolsExtension =
{
}

_.mapExtend( _, ToolsExtension );
_.assert( _.routineIs( _.traitIs ) );

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
