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
  o.kind = 'callable';
  return _.definition._traitMake( o );
  // return _.definition._traitMake( 'callable', o );
}

callable.defaults =
{
  callback : null,
  _blueprint : false,
}

//

/*

== typed:0

prototype:0
preserve prototype of the map, but change if not map to pure map

prototype:1
change prototype to null

prototype:null
change prototype to null

prototype:object
throw error

== typed:1

prototype:0
preserve prototype of typed destination, but change if it is map

prototype:1
set generated prototype

prototype:null
throw error

prototype:object
set custom prototype

== typed:maybe

prototype:0
preserve prototype of typed destination
preserve as map if untyped destination
create typed
// create untyped -- xxx

prototype:1
set generated prototype if destination is typed
change prototype to null if untyped
create typed

prototype:null
preserve prototype if typed
set prototype to null if untyped
create untyped

prototype:object
set custom prototype if typed
preserve if untyped
create typed

*/

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

  if( _.boolLike( o.val ) )
  o.val = !!o.val;
  if( _.boolLike( o.new ) )
  o.new = !!o.new;
  if( _.boolLike( o.prototype ) )
  o.prototype = !!o.prototype;

  _.assert( _.fuzzyIs( o.val ), () => `Expects fuzzy-like argument, but got ${_.strType( o.val )}` );
  _.assert( o.new === null || _.boolIs( o.new ), () => `Expects bool-like option::new, but got ${_.strType( o.new )}` );
  _.assert
  (
    o.val !== false || _.primitiveIs( o.prototype )
    , () => `Trait::typed should be either not false or prototype should be [ true, false, null ], it is ${_.strType( o.prototype )}`
  );

  o.blueprintForm1 = blueprintForm1;
  o.blueprintForm2 = blueprintForm2;
  o.blueprintDefinitionRewrite = blueprintDefinitionRewrite;

  let val = o.val;
  let allocate;
  let retype;

  o.kind = 'typed';
  return _.definition._traitMake( o );

/* -

- blueprintForm1
- blueprintForm2
- blueprintDefinitionRewrite
- allocateTyped
- allocateUntyped
- retypeMaybe
- retypeTyped
- retypeUntypedPreserving
- retypeUntypedForcing
- retypeToMap

*/

  /* */

  function blueprintForm1( op )
  {
    let prototype;
    let trait = op.blueprint.TraitsMap.typed;

    /**/

    if( _.boolLike( trait.new ) )
    trait.new = !!trait.new;
    if( _.boolLike( trait.prototype ) )
    trait.prototype = !!trait.prototype;

    if( trait.prototype === _.nothing )
    {
      if( _.mapIs( trait._dstConstruction ) && trait.val === _.maybe )
      trait.prototype = false;
      else if( trait.val === true )
      trait.prototype = true;
      else
      trait.prototype = false;
    }

    if( trait.new === null )
    {
      if( trait.val === _.maybe && trait.prototype === true )
      trait.new = false;
      else
      trait.new = _.blueprint.is( trait.prototype ) || trait.prototype === true;
    }

    _.assert( _.boolIs( trait.new ), () => `Expects bool-like option::new, but got ${_.strType( trait.new )}` );
    _.assert
    (
      trait.prototype === null || _.boolIs( trait.prototype ) || !_.primitiveIs( trait.prototype )
      , () => `Prototype should be either bool, null or non-primitive, but is ${_.strType( trait.prototype )}`
    );
    _.assert
    (
      trait.val !== false || _.primitiveIs( trait.prototype )
      , () => `Trait::typed should be either not false or prototype should be any of [ true, false, null ], but it is ${_.strType( trait.prototype )}`
    );
    _.assert( trait._blueprint === op.blueprint );

    /**/

    if( trait._dstConstruction )
    {
      trait._dstConstruction = _.nothing;
    }

    _.assert( trait._dstConstruction === _.nothing );
    _.assert( op.blueprint.make === null );
    _.assert( op.blueprint.runtime.prototype === null );

    if( _.boolIs( trait.prototype ) )
    {

      if( trait.val === false )
      {
        prototype = null;
      }
      else if( trait.val === _.maybe )
      {
        if( trait.prototype === true )
        prototype = Object.create( _.Construction.prototype );
        else
        prototype = op.blueprint.runtime.prototype;
      }
      else
      {
        prototype = Object.create( _.Construction.prototype );
      }

      op.blueprint.runtime.prototype = prototype;
    }
    else
    {

      if( _.blueprint.is( trait.prototype ) )
      {
        prototype = trait.prototype.prototype;
        _.assert( _.routineIs( trait.prototype.make ) );
        _.assert
        (
            _.objectIs( trait.prototype.prototype )
          , `Cant use ${_.blueprint.qnameOf( trait.prototype )} as prototype. This blueprint is not prototyped.`
        );
      }
      else
      {
        prototype = trait.prototype;
      }

      if( trait.new && prototype )
      op.blueprint.runtime.prototype = Object.create( prototype );
      else
      op.blueprint.runtime.prototype = prototype;

    }

    let effectiveTyped = !!trait.val && prototype !== null;

    if( trait.val === _.maybe && !trait.prototype )
    effectiveTyped = false;

    allocate = effectiveTyped ? allocateTyped : allocateUntyped;
    retype = effectiveTyped ? retypeTyped : retypeUntypedPreserving;
    if( trait.val === false && ( trait.prototype === null || trait.prototype === true ) )
    retype = retypeUntypedForcing;
    if( trait.val === _.maybe )
    retype = retypeMaybe;

    _.blueprint._practiceAdd( op.blueprint, 'allocate', allocate );
    _.blueprint._practiceAdd( op.blueprint, 'retype', retype );

  }

  /* */

  function blueprintForm2( op )
  {
    let trait = op.blueprint.TraitsMap.typed;
    let prototype;

    _.assert( trait.val === val );
    _.assert( _.fuzzyIs( trait.val ) );
    _.assert( op.blueprint.typed === trait.val || trait.val === _.maybe );
    _.assert( trait._blueprint === op.blueprint );
    _.assert( _.fuzzyIs( op.blueprint.typed ) );

    Object.freeze( trait );

    if( _.boolIs( trait.prototype ) )
    return;

    if( _.blueprint.is( trait.prototype ) )
    {
      prototype = trait.prototype.prototype;
      _.assert( _.blueprint.isDefinitive( trait.prototype ) );
      _.assert( _.routineIs( op.blueprint.make ) );
      _.assert( _.routineIs( trait.prototype.make ) );
      Object.setPrototypeOf( op.blueprint.make, trait.prototype.make );
    }
    else
    {
      prototype = trait.prototype;
      _.assert( prototype !== null || op.blueprint.typed !== true, 'Object with null prototype cant be typed' );
      if( prototype && Object.hasOwnProperty.call( prototype, 'constructor' ) && _.routineIs( prototype.constructor ) )
      if( op.blueprint.make !== prototype.constructor )
      Object.setPrototypeOf( op.blueprint.make, prototype.constructor );
    }

  }

  /* */

  function blueprintDefinitionRewrite( op )
  {
    _.assert( !op.primeDefinition || !op.secondaryDefinition || op.primeDefinition.kind === op.secondaryDefinition.kind );

    if( op.primeDefinition && op.secondaryDefinition && op.secondaryDefinition._dstConstruction !== _.nothing )
    {

      if( _global_.debugger )
      debugger;
      _.assert( op.primeDefinition._dstConstruction === _.nothing );

      let prototype = _.prototype.of( op.secondaryDefinition._dstConstruction );
      let opts = op.primeDefinition.cloneShallow();
      opts._blueprint = op.blueprint;

      if( op.primeDefinition.val === true && op.primeDefinition.prototype === _.nothing )
      opts.prototype = true;

      if
      (
           prototype
        && prototype !== Object.prototype
        && op.primeDefinition.val
        && ( opts.prototype === _.nothing || opts.prototype === false ) )
      {

        opts.prototype = prototype;
        opts.new = false;

      }
      else if
      (
           !!op.secondaryDefinition._dstConstruction
        && ( _.boolIs( opts.prototype ) || opts.prototype === _.nothing )
        && op.primeDefinition.val === _.maybe
      )
      {

        if( opts.prototype === _.nothing )
        {
          if( prototype === Object.prototype )
          opts.prototype = false;
          else
          opts.prototype = prototype;
        }
        else if( prototype === null || prototype === Object.prototype )
        {
          if( opts.prototype !== true )
          opts.prototype = false;
        }

      }

      op.blueprint.TraitsMap[ op.primeDefinition.kind ] = opts;
      return;
    }

    /*
    default handler otherwise
    */
    op.blueprintDefinitionRewrite( op );

  }

  /* */

  function allocateTyped( genesis )
  {
    if( _global_.debugger )
    debugger;
    _.assert( !!genesis.runtime.typed );
    if( genesis.construction === null )
    genesis.construction = new( _.constructorJoin( genesis.runtime.make, genesis.args ) );
    _.assert( genesis.construction === null || !genesis.runtime.prototype || genesis.construction instanceof genesis.runtime.make );
    return genesis.construction;
  }

  /* */

  function allocateUntyped( genesis )
  {
    if( _global_.debugger )
    debugger;

    if( genesis.runtime.prototype === null && !_.mapIsPure( genesis.construction ) )
    genesis.construction = Object.create( null );
    else if( genesis.construction && genesis.runtime.prototype !== null && genesis.construction instanceof genesis.runtime.make )
    genesis.construction = Object.create( null );
    else if( genesis.construction === null )
    genesis.construction = Object.create( null );
    _.assert( genesis.construction === null || _.mapIs( genesis.construction ) );
    _.assert( genesis.runtime.prototype === null || !( genesis.construction instanceof genesis.runtime.make ) );
    return genesis.construction;
  }

  /* */

  function retypeMaybe( genesis )
  {
    if( _global_.debugger )
    debugger;

    if( genesis.construction === null )
    {
      if( !genesis.runtime._reprototyping || genesis.runtime.prototype === null )
      {
        _.assert( 0, 'not tested' );
        genesis.construction = Object.create( null );
      }
      else
      {
        _.assert( 0, 'not tested' );
        genesis.construction = new( _.constructorJoin( genesis.runtime.make, genesis.args ) );
      }
    }
    else if( _.mapIs( genesis.construction ) )
    {
      if( genesis.runtime._reprototyping === null || genesis.runtime._reprototyping === true )
      if( Object.getPrototypeOf( genesis.construction ) !== null )
      Object.setPrototypeOf( genesis.construction, null );
    }
    else
    {

      if( genesis.runtime._reprototyping )
      if( Object.getPrototypeOf( genesis.construction ) !== genesis.runtime.prototype )
      Object.setPrototypeOf( genesis.construction, genesis.runtime.prototype );

    }

    return genesis.construction;
  }

  /* */

  function retypeTyped( genesis )
  {
    if( _global_.debugger )
    debugger;
    if( genesis.construction === null )
    {
      genesis.construction = new( _.constructorJoin( genesis.runtime.make, genesis.args ) );
    }
    else if( genesis.construction )
    {
      if( genesis.runtime._reprototyping !== false || _.mapIs( genesis.construction ) )
      if( genesis.runtime.prototype === null || !( genesis.construction instanceof genesis.runtime.make ) )
      Object.setPrototypeOf( genesis.construction, genesis.runtime.prototype );
    }

    _.assert
    (
      !_.mapIs( genesis.construction )
    );

    _.assert
    (
      genesis.runtime._reprototyping === false
      || genesis.runtime.typed === _.maybe
      || genesis.runtime.prototype === null
      || genesis.construction instanceof genesis.runtime.make
    );
    return genesis.construction;
  }

  /* */

  function retypeUntypedPreserving( genesis )
  {
    if( _global_.debugger )
    debugger;
    if( genesis.construction )
    {
      let wasProto = Object.getPrototypeOf( genesis.construction );
      if( wasProto !== null && wasProto !== Object.prototype )
      if( genesis.runtime.typed !== _.maybe )
      Object.setPrototypeOf( genesis.construction, null );
    }
    else if( genesis.construction === null )
    {
      genesis.construction = Object.create( null );
    }
    _.assert( _.mapIs( genesis.construction ) );
    return genesis.construction;
  }

  /* */

  function retypeUntypedForcing( genesis )
  {
    if( _global_.debugger )
    debugger;
    if( genesis.construction )
    {
      let wasProto = Object.getPrototypeOf( genesis.construction );
      if( genesis.runtime.typed !== _.maybe )
      Object.setPrototypeOf( genesis.construction, null );
    }
    else if( genesis.construction === null )
    {
      genesis.construction = Object.create( null );
    }
    _.assert( _.mapIs( genesis.construction ) );
    return genesis.construction;
  }

  /* */

}

typed_body.defaults =
{
  val : true,
  prototype : _.nothing,
  new : null,
  _dstConstruction : _.nothing,
  _blueprint : null,
}

let typed = _.routineUnite( typed_head, typed_body );

//

function constructor( o )
{
  if( !_.mapIs( o ) )
  o = { val : arguments[ 0 ] };
  _.routineOptions( constructor, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.boolLike( o.val ) );

  o.val = !!o.val;
  o.blueprintForm2 = blueprintForm2;
  o._blueprint = false;
  o.kind = 'constructor';
  return _.definition._traitMake( o );

  /* */

  function blueprintForm2( op )
  {

    if( _global_.debugger )
    debugger;

    if( !op.blueprint.TraitsMap.constructor.val )
    return;

    let prototyped = op.blueprint.prototype && op.blueprint.prototype !== Object.prototype;

    _.assert( _.routineIs( op.blueprint.make ) );
    _.assert( _.fuzzyIs( op.blueprint.typed ) );

    if( prototyped )
    if( op.amending !== 'supplement' || !_.mapOnlyOwnKey( op.blueprint.prototype, 'constructor' ) )
    {
      let properties =
      {
        value : op.blueprint.make,
        enumerable : false,
        configurable : false,
        writable : false,
      };
      Object.defineProperty( op.blueprint.prototype, 'constructor', properties );
    }

    let prototype = op.blueprint.prototype;
    let supplementing = op.amending === 'supplement';
    let constructor = op.blueprint.make;
    let typed = op.blueprint.typed;
    if( typed !== true )
    {
      _.blueprint._practiceAdd( op.blueprint, 'constructionInitEnd', constructionInitEnd );
    }

    function constructionInitEnd( genesis )
    {
      if( _global_.debugger )
      debugger;
      _.assert( !_.primitiveIs( genesis.construction ) );
      if( typed )
      {
        let prototype2 = Object.getPrototypeOf( genesis.construction );
        if( prototype2 && prototype2 === prototype )
        return;
      }
      if( genesis.amending === 'supplement' && Object.hasOwnProperty.call( genesis.construction, 'constructor' ) )
      return;
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

constructor.defaults =
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

  o.kind = 'extendable';
  return _.definition._traitMake( o );

  function blueprintForm2( op )
  {
    _.assert( _.boolIs( op.blueprint.TraitsMap.extendable.val ) );
    if( op.blueprint.TraitsMap.extendable.val )
    return;
    _.blueprint._practiceAdd( op.blueprint, 'constructionInitEnd', preventExtensions );
  }

  function preventExtensions( genesis )
  {
    Object.preventExtensions( genesis.construction );
  }

}

extendable.defaults =
{
  val : true,
  _blueprint : false,
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
  o.kind = 'name';
  return _.definition._traitMake( o );

  function blueprintForm1( op )
  {
    _.assert( op.blueprint.make === null );
    _.assert( op.blueprint.name === null );
    op.blueprint.runtime.name = op.definition.val;
  }

}

name.defaults =
{
  val : null,
  _blueprint : false,
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
  constructor, /* xxx : reuse static:maybe _.define.prop() ?*/
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
