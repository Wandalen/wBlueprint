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
  // _.assert( args.length === 1 || args.length === 2 ); /* yyy */
  _.assert( args.length === 0 || args.length === 1 || args.length === 2 );
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

// function prototype_body( o )
// {
//   _.routineOptions( prototype_body, o );
//
//   if( o.new === null )
//   o.new = _.blueprint.is( o.val );
//
//   if( _.boolLike( o.val ) )
//   o.val = !!o.val;
//
//   _.assert( arguments.length === 0 || arguments.length === 1 );
//   _.assert( _.boolLike( o.new ) );
//   _.assert( o.val === null || _.boolIs( o.val ) || !_.primitiveIs( o.val ) );
//
//   o.blueprintForm1 = blueprintForm1;
//   o.blueprintForm2 = blueprintForm2;
//   o.blueprint = false;
//
//   return _.definition._traitMake( 'prototype', o );
//
//   /* */
//
//   function blueprintForm1( o )
//   {
//     let prototype;
//
//     _.assert( o.blueprint.Make === null );
//     _.assert( _.objectIs( o.blueprint.prototype ) );
//
//     if( _.boolIs( o.blueprint.Traits.prototype.val ) )
//     {
//       /* xxx : take into account option::new */
//       /* xxx : take into account true/false */
//       /* xxx : merge traits typed and prototype */
//       return;
//     }
//
//     if( _.blueprint.is( o.blueprint.Traits.prototype.val ) )
//     {
//       prototype = o.blueprint.Traits.prototype.val.prototype;
//       _.assert( _.routineIs( o.blueprint.Traits.prototype.val.Make ) );
//       _.assert( _.objectIs( o.blueprint.Traits.prototype.val.prototype ) );
//     }
//     else
//     {
//       prototype = o.blueprint.Traits.prototype.val;
//     }
//     if( o.blueprint.Traits.prototype.new )
//     o.blueprint.Runtime.prototype = Object.create( prototype );
//     else
//     o.blueprint.Runtime.prototype = prototype;
//   }
//
//   /* */
//
//   function blueprintForm2( o )
//   {
//     let prototype;
//
//     _.assert( _.fuzzyIs( o.blueprint.Typed ) );
//
//     if( _.boolIs( o.blueprint.Traits.prototype.val ) )
//     {
//       return;
//     }
//
//     if( _.blueprint.is( o.blueprint.Traits.prototype.val ) )
//     {
//       prototype = o.blueprint.Traits.prototype.val.prototype;
//       _.assert( _.blueprint.isDefinitive( o.blueprint.Traits.prototype.val ) );
//       _.assert( _.routineIs( o.blueprint.Make ) );
//       _.assert( _.routineIs( o.blueprint.Traits.prototype.val.Make ) );
//       Object.setPrototypeOf( o.blueprint.Make, o.blueprint.Traits.prototype.val.Make );
//     }
//     else
//     {
//       prototype = o.blueprint.Traits.prototype.val;
//       _.assert( prototype !== null || !o.blueprint.Typed, 'Object with null prototype cant be typed' );
//       if( prototype && Object.hasOwnProperty.call( prototype, 'constructor' ) && _.routineIs( prototype.constructor ) )
//       if( o.blueprint.Make !== prototype.constructor )
//       Object.setPrototypeOf( o.blueprint.Make, prototype.constructor );
//     }
//
//     /* yyy */
//     // if( Config.debug )
//     // if( prototype !== null && o.blueprint.Typed === false )
//     // _.blueprint._routineAdd( o.blueprint, 'initEnd', notPrototyped );
//
//     // function notPrototyped( genesis )
//     // {
//     //   if( _global_.debugger )
//     //   debugger;
//     //   _.assert
//     //   (
//     //     Object.getPrototypeOf( genesis.construction ) !== prototype,
//     //     'trait::typed is false, but construction has prototype defined by trait::prototype'
//     //   );
//     // }
//
//   }
//
//   /* */
//
// }
//
// prototype_body.defaults =
// {
//   val : null,
//   new : null,
// }
//
// let prototype = _.routineUnite( _pairArgumentsHead, prototype_body );

//

// function typed( o )
// {

function typed_head( routine, args )
{
  let o = args[ 1 ];

  if( _.mapIs( args[ 0 ] ) )
  {
    o = args[ 0 ];
    _.assert( args.length === 1 );
  }
  else if( !o )
  {
    o = { val : args[ 0 ] };
  }
  else
  {
    o.val = args[ 0 ];
  }

  o = _.routineOptions( routine, o );

  _.assert( arguments.length === 2 );
  _.assert( args.length === 0 || args.length === 1 || args.length === 2 );
  _.assert( args[ 1 ] === undefined || _.mapIs( args[ 1 ] ) );

  return o;
}

function typed_body( o )
{
  _.routineOptions( typed_body, o );

  if( !_.mapIs( o ) )
  o = { val : arguments[ 0 ] };
  _.routineOptions( typed, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( _global_.debugger )
  debugger;

  if( _.boolLike( o.val ) )
  o.val = !!o.val;
  if( _.boolLike( o.new ) )
  o.new = !!o.new;
  if( _.boolLikeTrue( o.prototype ) )
  o.prototype = !!o.prototype;
  if( o.new === null )
  o.new = _.blueprint.is( o.prototype ) || o.prototype === true;

  _.assert( _.fuzzyIs( o.val ), () => `Expects fuzzy-like argument, but got ${_.strType( o.val )}` );
  _.assert( _.boolIs( o.new ), () => `Expects bool-like option::new, but got ${_.strType( o.new )}` );
  _.assert( o.prototype === null || o.prototype === true || !_.primitiveIs( o.prototype ) );

  // o.constructionAmend = constructionAmend;
  o.blueprintForm1 = blueprintForm1;
  o.blueprintForm2 = blueprintForm2;
  o.blueprint = false;

  const val = o.val;
  const allocate = o.val ? allocateTyped : allocateUntyped;
  const retype = o.val ? retypeTyped : retypeUntyped;

  return _.definition._traitMake( 'typed', o );

  /* */

  function blueprintForm1( o )
  {
    let prototype;

    _.assert( o.blueprint.Make === null );
    _.assert( _.objectIs( o.blueprint.prototype ) );

    if( _global_.debugger )
    debugger;

    if( _.boolIs( o.blueprint.Traits.typed.prototype ) )
    {
      /* xxx : take into account option::new */
      /* xxx : take into account true/false */
      /* xxx : merge traits typed and prototype */
      return;
    }

    if( _.blueprint.is( o.blueprint.Traits.typed.prototype ) )
    {
      prototype = o.blueprint.Traits.typed.prototype.prototype;
      _.assert( _.routineIs( o.blueprint.Traits.typed.prototype.Make ) );
      _.assert( _.objectIs( o.blueprint.Traits.typed.prototype.prototype ) );
    }
    else
    {
      prototype = o.blueprint.Traits.typed.prototype;
    }

    if( o.blueprint.Traits.typed.new )
    o.blueprint.Runtime.prototype = Object.create( prototype );
    else
    o.blueprint.Runtime.prototype = prototype;
  }

  /* */

  // function constructionAmend( construction, key )
  // {
  //   debugger; xxx
  //   if( val )
  //   retype({ construction });
  // }

  function blueprintForm2( o )
  {

    _.assert( o.blueprint.Traits.typed.val === val );
    _.assert( _.fuzzyIs( o.blueprint.Traits.typed.val ) );
    _.assert( o.blueprint.Typed === o.blueprint.Traits.typed.val );

    if( _global_.debugger )
    debugger;

    _.blueprint._routineAdd( o.blueprint, 'allocate', o.blueprint.Traits.typed.val ? allocateTyped : allocateUntyped );
    _.blueprint._routineAdd( o.blueprint, 'retype', o.blueprint.Traits.typed.val ? retypeTyped : retypeUntyped );

    let prototype;

    _.assert( _.fuzzyIs( o.blueprint.Typed ) );

    if( _.boolIs( o.blueprint.Traits.typed.prototype ) )
    {
      return;
    }

    if( _.blueprint.is( o.blueprint.Traits.typed.prototype ) )
    {
      prototype = o.blueprint.Traits.typed.prototype.prototype;
      _.assert( _.blueprint.isDefinitive( o.blueprint.Traits.typed.prototype ) );
      _.assert( _.routineIs( o.blueprint.Make ) );
      _.assert( _.routineIs( o.blueprint.Traits.typed.prototype.Make ) );
      Object.setPrototypeOf( o.blueprint.Make, o.blueprint.Traits.typed.prototype.Make );
    }
    else
    {
      prototype = o.blueprint.Traits.typed.prototype;
      _.assert( prototype !== null || !o.blueprint.Typed, 'Object with null prototype cant be typed' );
      if( prototype && Object.hasOwnProperty.call( prototype, 'constructor' ) && _.routineIs( prototype.constructor ) )
      if( o.blueprint.Make !== prototype.constructor )
      Object.setPrototypeOf( o.blueprint.Make, prototype.constructor );
    }

  }

  function allocateTyped( genesis )
  {
    if( genesis.construction === null )
    genesis.construction = new( _.constructorJoin( genesis.runtime.Make, genesis.args ) );
    _.assert( genesis.construction === null || !genesis.runtime.Make.prototype || genesis.construction instanceof genesis.runtime.Make );
    return genesis.construction;
  }

  function allocateUntyped( genesis )
  {
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
    // _.assert( genesis.runtime.Typed === _.maybe || !( genesis.construction instanceof genesis.runtime.Make ) ); /* yyy */
    return genesis.construction;
  }

}

typed_body.defaults =
{
  val : true,
  prototype : true,
  new : null,
}

let typed = _.routineUnite( typed_head, typed_body );
// let typed = _.routineUnite( _pairArgumentsHead, typed_body );

//

function withConstructor( o )
{
  if( !_.mapIs( o ) )
  o = { val : arguments[ 0 ] };
  _.routineOptions( withConstructor, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.boolLike( o.val ) );

  o.val = !!o.val;
  o.blueprintForm2 = blueprintForm2;
  o.blueprint = false;

  return _.definition._traitMake( 'withConstructor', o );

  /* */

  function blueprintForm2( o )
  {

    if( !o.blueprint.Traits.withConstructor.val )
    return;
    if( o.amending === 'supplement' && _.mapOnlyOwnKey( o.blueprint.prototype, 'constructor' ) )
    return;

    _.assert( !_.primitiveIs( o.blueprint.prototype ) );
    _.assert( o.blueprint.prototype !== Object.prototype, 'Constructor of `Object.prototype` should not be rewritten' );
    _.assert( _.routineIs( o.blueprint.Make ) );
    _.assert( _.fuzzyIs( o.blueprint.Typed ) );

    let properties =
    {
      value : o.blueprint.Make,
      enumerable : false,
      configurable : false,
      writable : false,
    };
    Object.defineProperty( o.blueprint.prototype, 'constructor', properties );

    let constructor = o.blueprint.Make;
    let typed = o.blueprint.Typed;

    if( typed !== true )
    {
      _.blueprint._routineAdd( o.blueprint, 'initEnd', initEnd );
    }

    function initEnd( genesis )
    {
      _.assert( !_.primitiveIs( genesis.construction ) );
      if( genesis.amending === 'supplement' && Object.hasOwnProperty.call( genesis.construction, 'constructor' ) )
      return;
      if( typed === _.maybe )
      {
        let prototype = Object.getPrototypeOf( genesis.construction );
        if( prototype && prototype.constructor === constructor )
        return;
      }
      let properties =
      {
        value : constructor,
        enumerable : false,
        configurable : false,
        writable : false,
      };
      Object.defineProperty( genesis.construction, 'constructor', properties );
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

  if( _.boolLike( o.val ) )
  o.val = !!o.val;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.boolIs( o.val ) );

  o.blueprintForm2 = blueprintForm2;
  o.blueprint = false;

  return _.definition._traitMake( 'extendable', o );

  function blueprintForm2( o )
  {
    _.assert( _.boolIs( o.blueprint.Traits.extendable.val ) );
    if( o.blueprint.Traits.extendable.val )
    return;
    _.blueprint._routineAdd( o.blueprint, 'initEnd', preventExtensions );
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

function name( o )
{
  if( !_.mapIs( o ) )
  o = { val : arguments[ 0 ] };
  _.routineOptions( name, o );
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( o.val ) );

  o.blueprintForm1 = blueprintForm1;
  o.blueprint = false;

  let def = _.definition._traitMake( 'name', o );
  return def;

  function blueprintForm1( o )
  {
    _.assert( o.blueprint.Make === null );
    o.blueprint.Runtime.Name = def.val;
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
  // prototype,
  typed,
  withConstructor,
  extendable,
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
