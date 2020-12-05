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

  o.blueprint = false;

  return _.definition._traitMake( 'callable', o );
}

callable.defaults =
{
  callback : null,
}

//

function typed( o )
{
  if( !_.mapIs( o ) )
  o = { val : arguments[ 0 ] };
  _.routineOptions( typed, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.boolIs( o.val ) );

  o.blueprintForm2 = blueprintForm2;
  o.blueprint = false;

  return _.definition._traitMake( 'typed', o );

  /* */

  function blueprintForm2( blueprint )
  {

    _.assert( _.boolIs( blueprint.Traits.typed.val ) );

    _.blueprint._routineAdd( blueprint, 'allocate', blueprint.Traits.typed.val ? allocateTyped : allocateUntyped );
    _.blueprint._routineAdd( blueprint, 'retype', blueprint.Traits.typed.val ? retypeTyped : retypeUntyped );

  }

  function allocateTyped( genesis )
  {
    if( genesis.construction === null )
    genesis.construction = new( _.constructorJoin( genesis.runtime.Make, [] ) );
    _.assert( genesis.construction === null || genesis.construction instanceof genesis.runtime.Make );
    return genesis.construction;
  }

  function allocateUntyped( genesis )
  {
    if( genesis.construction && genesis.construction instanceof genesis.runtime.Make )
    genesis.construction = Object.create( null );
    else if( genesis.construction === null )
    genesis.construction = Object.create( null );
    _.assert( genesis.construction === null || _.mapIs( genesis.construction ) );
    _.assert( !( genesis.construction instanceof genesis.runtime.Make ) );
    return genesis.construction;
  }

  function retypeTyped( genesis )
  {
    if( genesis.construction )
    {
      if( !genesis.construction || !( genesis.construction instanceof genesis.runtime.Make ) )
      Object.setPrototypeOf( genesis.construction, genesis.runtime.Make.prototype );
    }
    else if( genesis.construction === null )
    {
      genesis.construction = new( _.constructorJoin( genesis.runtime.Make, [] ) );
    }
    _.assert( genesis.construction instanceof genesis.runtime.Make );
    return genesis.construction;
  }

  function retypeUntyped( genesis )
  {
    if( genesis.construction )
    {
      if( Object.getPrototypeOf( genesis.construction ) !== null )
      Object.setPrototypeOf( genesis.construction, null );
    }
    else if( genesis.construction === null )
    {
      genesis.construction = Object.create( null );
    }
    _.assert( _.mapIs( genesis.construction ) );
    _.assert( !( genesis.construction instanceof genesis.runtime.Make ) );
    return genesis.construction;
  }

}

typed.defaults =
{
  val : true
}

//

function withConstructor( o )
{
  if( !_.mapIs( o ) )
  o = { val : arguments[ 0 ] };
  _.routineOptions( withConstructor, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.boolIs( o.val ) );

  o.blueprintForm2 = blueprintForm2;
  o.blueprint = false;

  return _.definition._traitMake( 'withConstructor', o );

  /* */

  function blueprintForm2( blueprint )
  {

    _.assert( !_.mapOwnKey( blueprint.prototype, 'constructor' ) );
    if( blueprint.Traits.withConstructor.val )
    {
      _.assert( _.routineIs( blueprint.Make ) );
      _.assert( _.objectIs( blueprint.prototype ) );
      let properties =
      {
        value : blueprint.Make,
        enumerable : false,
        configurable : false,
        writable : false,
      };
      Object.defineProperty( blueprint.prototype, 'constructor', properties );
    }

  }

}

withConstructor.defaults =
{
  val : true,
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
  o.blueprint = false;

  return _.definition._traitMake( 'extendable', o );

  function blueprintForm2( blueprint )
  {
    _.assert( _.boolIs( blueprint.Traits.extendable.val ) );
    if( blueprint.Traits.extendable.val )
    return;
    _.blueprint._routineAdd( blueprint, 'initEnd', preventExtensions );
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
  _.assert( _.blueprint.isDefinitive( o.val ) );

  o.blueprintForm1 = blueprintForm1;
  o.blueprintForm2 = blueprintForm2;
  o.blueprint = false;

  return _.definition._traitMake( 'prototype', o );

  function blueprintForm1( blueprint )
  {
    _.assert( _.blueprint.isDefinitive( blueprint.Traits.prototype.val ) );
    _.assert( blueprint.Make === null );
    _.assert( _.routineIs( blueprint.Traits.prototype.val.Make ) );
    _.assert( _.objectIs( blueprint.prototype ) );
    _.assert( _.objectIs( blueprint.Traits.prototype.val.prototype ) );
    blueprint.Runtime.prototype = Object.create( blueprint.Traits.prototype.val.prototype );
  }

  function blueprintForm2( blueprint )
  {
    _.assert( _.blueprint.isDefinitive( blueprint.Traits.prototype.val ) );
    _.assert( _.routineIs( blueprint.Make ) );
    _.assert( _.routineIs( blueprint.Traits.prototype.val.Make ) );
    Object.setPrototypeOf( blueprint.Make, blueprint.Traits.prototype.val.Make );
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
  o.blueprint = false;

  return _.definition._traitMake( 'name', o );

  function blueprintForm1( blueprint )
  {
    _.assert( blueprint.Make === null );
    blueprint.Runtime.Name = o.val;
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
  withConstructor,
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
