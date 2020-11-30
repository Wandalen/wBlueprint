( function _Traits_s_() {

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
  _.assert( _.routineIs( o.val ) );

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
  o = { typed : arguments[ 0 ] };
  _.routineOptions( typed, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.boolIs( o.typed ) );

  o.blueprintForm3 = blueprintForm3;

  return _.definition._traitMake( typed, o );

  function blueprintForm3( blueprint )
  {

    _.assert( blueprint._InternalRoutinesMap.allocate === undefined );
    _.assert( _.boolIs( blueprint.Traits.typed.typed ) );

    if( blueprint.Traits.typed.typed )
    blueprint._InternalRoutinesMap.allocate = allocateTyped;
    else
    blueprint._InternalRoutinesMap.allocate = allocateUntyped;

    if( blueprint.Traits.typed.typed )
    blueprint._InternalRoutinesMap.reconstruct = reconstructTyped;
    else
    blueprint._InternalRoutinesMap.reconstruct = reconstructUntyped;

    if( blueprint.Traits.typed.withConstructor )
    {
      _.assert( blueprint.prototype.constructor === undefined );
      _.assert( _.routineIs( blueprint.Construct ) );
      _.assert( _.objectIs( blueprint.prototype ) );
      blueprint.prototype.constructor = blueprint.Construct;
    }

  }

  function allocateTyped( construction, construct )
  {
    if( construction === null )
    construction = new( _.constructorJoin( construct, [ construct ] ) );
    _.assert( construction === null || construction instanceof construct );
    return construction;
  }

  function allocateUntyped( construction, construct )
  {
    if( construction && construction instanceof construct )
    construction = Object.create( null );
    else if( construction === null )
    construction = Object.create( null );
    _.assert( construction === null || _.mapIs( construction ) );
    _.assert( !( construction instanceof construct ) );
    return construction;
  }

  function reconstructTyped( construction, construct )
  {
    if( construction )
    {
      if( !construction || !( construction instanceof construct ) )
      Object.setPrototypeOf( construction, construct.prototype );
    }
    else if( construction === null )
    {
      _.assert( 0, 'not tested' );
      construction = new( _.constructorJoin( construct, [ construct ] ) );
    }
    _.assert( construction instanceof construct );
    return construction;
  }

  function reconstructUntyped( construction, construct )
  {
    if( construction )
    {
      if( Object.getPrototypeOf( construction ) !== null )
      Object.setPrototypeOf( construction, null );
    }
    else if( construction === null )
    {
      _.assert( 0, 'not tested' );
      construction = Object.create( null );
    }
    _.assert( _.mapIs( construction ) );
    _.assert( !( construction instanceof construct ) );
    return construction;
  }

}

typed.defaults =
{
  typed : true,
  withConstructor : false,
}

//

function extendable( o )
{
  if( !_.mapIs( o ) )
  o = { val : arguments[ 0 ] };
  _.routineOptions( extendable, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.boolIs( o.val ) );

  o.blueprintForm2 = blueprintForm2;

  return _.definition._traitMake( extendable, o );

  function blueprintForm2( blueprint )
  {
    _.assert( _.boolIs( blueprint.Traits.extendable.val ) );
    if( blueprint.Traits.extendable.val )
    return;
    blueprint._InternalRoutinesMap.initEnd = blueprint._InternalRoutinesMap.initEnd || [];
    blueprint._InternalRoutinesMap.initEnd.push( preventExtensions );
  }

  function preventExtensions( genesis )
  {
    Object.preventExtensions( genesis.construction );
  }

}

extendable.defaults =
{
  val : true,
}

//

function prototype( o )
{
  if( !_.mapIs( o ) )
  o = { val : arguments[ 0 ] };
  _.routineOptions( prototype, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.blueprint.is( o.val ) );

  o.blueprintForm1 = blueprintForm1;

  return _.definition._traitMake( prototype, o );

  function blueprintForm1( blueprint )
  {
    _.assert( _.blueprint.is( blueprint.Traits.prototype.val ) );
    _.assert( blueprint.construct === undefined );
    _.assert( blueprint.Traits.prototype.val.construct === undefined );
    _.assert( _.routineIs( blueprint.Traits.prototype.val.Construct ) );
    _.assert( _.objectIs( blueprint.prototype ) );
    _.assert( _.objectIs( blueprint.Traits.prototype.val.prototype ) );
    blueprint.prototype = Object.create( blueprint.Traits.prototype.val.prototype );
  }

}

prototype.defaults =
{
  val : null,
}

//

function name( o )
{
  if( !_.mapIs( o ) )
  o = { val : arguments[ 0 ] };
  _.routineOptions( name, o );
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( o.val ) );

  o.blueprintForm1 = blueprintForm1;

  return _.definition._traitMake( name, o );

  function blueprintForm1( blueprint )
  {
    blueprint.Name = o.val;
  }

}

name.defaults =
{
  val : null,
}

// --
// define
// --

/**
* Collection of definitions which are traits.
* @namespace wTools.trait
* @extends Tools
* @module Tools/base/Proto
*/

let TraitExtension =
{

  callable,
  typed,
  extendable,
  prototype,
  name,

}

_.trait = _.trait || Object.create( null );
_.mapExtend( _.trait, TraitExtension );

//

/**
* Routines to manipulate traits.
* @namespace wTools.definition
* @extends Tools
* @module Tools/base/Proto
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

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
