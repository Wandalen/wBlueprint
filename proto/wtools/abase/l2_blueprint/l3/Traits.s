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

function _pairArgumentsHead( routine, args )
{
  let o = args[ 1 ];

  if( !o )
  o = { val : args[ 0 ] };
  else
  o.val = args[ 0 ];

  o = _.routineOptions( routine, o );

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );
  _.assert( args[ 1 ] === undefined || _.mapIs( args[ 1 ] ) );

  return o;
}

//

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
  _.assert( _.fuzzyLike( o.val ) );

  if( _.boolLike( o.val ) )
  o.val = !!o.val;
  o.constructionAmend = constructionAmend;
  o.blueprintForm2 = blueprintForm2;
  o.blueprint = false;

  const val = o.val;
  const allocate = o.val ? allocateTyped : allocateUntyped;
  const retype = o.val ? retypeTyped : retypeUntyped;

  return _.definition._traitMake( 'typed', o );

  /* */

  function constructionAmend( construction, key )
  {
    debugger; xxx
    if( val )
    retype({ construction });
  }

  function blueprintForm2( blueprint )
  {

    _.assert( blueprint.Traits.typed.val === val );
    _.assert( _.fuzzyIs( blueprint.Traits.typed.val ) );
    _.assert( blueprint.Typed === blueprint.Traits.typed.val );

    _.blueprint._routineAdd( blueprint, 'allocate', blueprint.Traits.typed.val ? allocateTyped : allocateUntyped );
    _.blueprint._routineAdd( blueprint, 'retype', blueprint.Traits.typed.val ? retypeTyped : retypeUntyped );

  }

  function allocateTyped( genesis )
  {
    if( _global_.debugger )
    debugger;
    if( genesis.construction === null )
    genesis.construction = new( _.constructorJoin( genesis.runtime.Make, [] ) );
    _.assert( genesis.construction === null || !genesis.runtime.Make.prototype || genesis.construction instanceof genesis.runtime.Make );
    return genesis.construction;
  }

  function allocateUntyped( genesis )
  {
    if( _global_.debugger )
    debugger;
    if( genesis.construction && genesis.construction instanceof genesis.runtime.Make )
    genesis.construction = Object.create( null );
    else if( genesis.construction === null )
    genesis.construction = Object.create( null );
    _.assert( genesis.construction === null || _.mapIs( genesis.construction ) );
    _.assert( genesis.runtime.Make.prototype === null || !( genesis.construction instanceof genesis.runtime.Make ) );
    return genesis.construction;
  }

  function retypeTyped( genesis )
  {
    if( _global_.debugger )
    debugger;
    if( genesis.construction )
    {
      if( !genesis.construction || !( genesis.construction instanceof genesis.runtime.Make ) )
      if( genesis.runtime.Typed !== _.maybe )
      Object.setPrototypeOf( genesis.construction, genesis.runtime.Make.prototype );
    }
    else if( genesis.construction === null )
    {
      genesis.construction = new( _.constructorJoin( genesis.runtime.Make, [] ) );
    }
    _.assert( genesis.runtime.Typed === _.maybe || genesis.construction instanceof genesis.runtime.Make );
    return genesis.construction;
  }

  function retypeUntyped( genesis )
  {
    if( _global_.debugger )
    debugger;
    if( genesis.construction )
    {
      let wasProto = Object.getPrototypeOf( genesis.construction );
      if( wasProto !== null && wasProto !== Object.prototype )
      if( genesis.runtime.Typed !== _.maybe )
      Object.setPrototypeOf( genesis.construction, null );
    }
    else if( genesis.construction === null )
    {
      genesis.construction = Object.create( null );
    }
    _.assert( _.mapIs( genesis.construction ) );
    _.assert( genesis.runtime.Typed === _.maybe || !( genesis.construction instanceof genesis.runtime.Make ) );
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

function prototype_body( o )
{
  _.routineOptions( prototype_body, o );

  if( o.new === null )
  o.new = _.blueprint.is( o.val );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.boolLike( o.new ) );
  _.assert( o.val === null || !_.primitiveIs( o.val ) );

  o.blueprintForm1 = blueprintForm1;
  o.blueprintForm2 = blueprintForm2;
  o.blueprint = false;

  return _.definition._traitMake( 'prototype', o );

  /* */

  function blueprintForm1( blueprint )
  {
    let prototype;

    _.assert( blueprint.Make === null );
    _.assert( _.objectIs( blueprint.prototype ) );

    if( _global_.debugger )
    debugger;

    if( _.blueprint.is( blueprint.Traits.prototype.val ) )
    {
      prototype = blueprint.Traits.prototype.val.prototype;
      _.assert( _.routineIs( blueprint.Traits.prototype.val.Make ) );
      _.assert( _.objectIs( blueprint.Traits.prototype.val.prototype ) );
    }
    else
    {
      prototype = blueprint.Traits.prototype.val;
    }
    if( blueprint.Traits.prototype.new )
    blueprint.Runtime.prototype = Object.create( prototype );
    else
    blueprint.Runtime.prototype = prototype;
  }

  /* */

  function blueprintForm2( blueprint )
  {
    _.assert( _.boolIs( blueprint.Typed ) );
    if( _.blueprint.is( blueprint.Traits.prototype.val ) )
    {
      _.assert( _.blueprint.isDefinitive( blueprint.Traits.prototype.val ) );
      _.assert( _.routineIs( blueprint.Make ) );
      _.assert( _.routineIs( blueprint.Traits.prototype.val.Make ) );
      Object.setPrototypeOf( blueprint.Make, blueprint.Traits.prototype.val.Make );
    }
    else
    {
      let prototype = blueprint.Traits.prototype.val;
      _.assert( prototype !== null || !blueprint.Typed, 'Object with null prototype cant be typed' );
      if( prototype && Object.hasOwnProperty.call( prototype, 'constructor' ) && _.routineIs( prototype.constructor ) )
      Object.setPrototypeOf( blueprint.Make, prototype.constructor );
    }
  }

  /* */

}

prototype_body.defaults =
{
  val : null,
  new : null,
}

let prototype = _.routineUnite( _pairArgumentsHead, prototype_body );

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
