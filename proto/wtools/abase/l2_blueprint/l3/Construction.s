( function _Construction_s_() {

'use strict';

let _global = _global_;
let _ = _global_.wTools;

// --
// implementation
// --

function isTyped( construction )
{
  _.assert( arguments.length === 1 );

  if( !construction )
  return false;

  let next = construction;
  do
  {
    construction = next
    next = Object.getPrototypeOf( construction );
  }
  while( next )

  if( construction !== _.Construction.prototype )
  return false;

  return true;
}

//

function isInstanceOf( construction, runtime )
{

  if( _.blueprint.isDefinitive( runtime ) )
  runtime = runtime.Runtime;

  _.assert( arguments.length === 2 );
  _.assert( _.blueprint.isRuntime( runtime ) );
  _.assert( _.fuzzyLike( runtime.Typed ) );
  _.assert( _.routineIs( runtime.Make ) );

  if( !construction )
  return false;

  if( runtime.Typed && runtime.Make.prototype !== null )
  {
    return construction instanceof runtime.Make;
  }

  if( _.mapIs( construction ) )
  return _.maybe;
  return false;
}

//

function amend( o )
{
  o = _.routineOptions( amend, arguments );
  if( o.dstConstruction === null )
  o.dstConstruction = Object.create( null );
  let amending = o.amending;
  let blueprint = blueprintLook( o.src, null );

  if( !blueprint )
  {
    let defs = [];
    let prototype = _.prototype.of( o.dstConstruction );
    let add = o.amending === 'supplement' ? 'push' : 'unshift';

    defs[ add ]( o.src );

    {
      let opts = Object.create( null );
      opts.val = _.maybe;
      if( prototype ) /* xxx : cover */
      {
        opts.prototype = prototype;
        opts.new = false;
      }
      defs[ add ]( _.trait.typed( opts ) );
    }

    defs[ add ]( _.trait.extendable( true ) );

    // if( prototype )
    // defs[ add ]( _.trait.prototype( prototype, { new : false } ) ); /* xxx : cover */
    // defs[ add ]( _.trait.extendable( true ) );
    // defs[ add ]( _.trait.typed( _.maybe ) ); /* xxx : cover */

    blueprint = _.blueprint._define({ args : defs, amending : o.amending });
  }

  constructionBlueprintExtend( o.dstConstruction, blueprint, null );

  return o.dstConstruction;

  /* */

  function blueprintLook( src, name )
  {
    if( _.mapIs( src ) )
    return blueprintMapLook( src, name );
    else if( _.longIs( src ) )
    return blueprintArrayLook( src, name )
    else if( _.definitionIs( src ) )
    return false;
    else if( _.blueprintIsDefinitive( src ) )
    return src;
    else
    return false;
  }

  function blueprintMapLook( map, name )
  {
    let result = null
    _.assert( _.mapIs( map ) );
    for( let name2 in map )
    {
      let prop = map[ name2 ];
      let r = blueprintLook( prop, name );
      if( r !== null )
      result = !result ? r : false;
      if( result === false )
      return result;
    }
    return null;
  }

  function blueprintArrayLook( array, name )
  {
    let result = null;
    for( let prop of array )
    {
      let r = blueprintLook( prop, name );
      if( r !== null )
      result = !result ? r : false;
      if( result === false )
      return result;
    }
    return result;
  }

  /* */

  function constructionBlueprintExtend( dstConstruction, blueprint, name )
  {
    _.assert( !_.blueprint.is( dstConstruction ) );
    _.construction._retype
    ({
      construction : dstConstruction,
      runtime : blueprint.Runtime,
      amending,
    });
  }

  /* */

}

amend.defaults =
{
  dstConstruction : null,
  src : null,
  amending : 'extend',
}

//

/* zzz qqq : cover and extend */
function extend( dstConstruction, src )
{
  return _.construction.amend
  ({
    dstConstruction,
    src,
    amending : 'extend'
  });
}

//

/* zzz qqq : cover and extend */
function supplement( dstConstruction, src )
{
  return _.construction.amend
  ({
    dstConstruction,
    src,
    amending : 'supplement'
  });
}

// //
//
// function _amendDefinitionWithoutMethod( o )
// {
//
//   _.assertMapHasAll( o, _amendDefinitionWithoutMethod.defaults );
//   _.assert( _.strIs( o.key ) || _.symbolIs( o.key ) || o.key === null );
//   _.assert( _.definitionIs( o.definition ) );
//   _.assert( _.longHas( [ 'supplement', 'extend' ], o.amending ) );
//
//   debugger;
//   if( o.amending === 'supplement' )
//   {
//     debugger;
//     /* zzz qqq : cover */
//     if( o.key !== null )
//     if( Object.hasOwnProperty.call( o.construction, o.key ) && o.construction[ o.key ] !== undefined )
//     return;
//   }
//
//   // debugger; zzz
//
//   let prototype = _.prototype.of( o.construction );
//   let defs = [];
//   if( prototype && o.definition.kind === 'prototype' )
//   debugger;
//   if( prototype && o.definition.kind !== 'prototype' ) /* zzz : cover */
//   defs.push( _.trait.prototype( prototype, { new : false } ) );
//   if( o.definition.kind === 'extendable' )
//   debugger;
//   if( o.definition.kind !== 'extendable' ) /* zzz : cover */
//   defs.push( _.trait.extendable( true ) );
//   if( o.definition.kind !== 'typed' )
//   debugger;
//   if( o.definition.kind !== 'typed' ) /* zzz : cover */
//   defs.push( _.trait.typed( _.maybe ) );
//
//   let args;
//
//   let newDefinition = o.key === null ? o.definition : { [ o.key ] : o.definition };
//
//   if( o.amending === 'extend' )
//   args = [ defs, newDefinition ];
//   else
//   args = [ newDefinition, defs ];
//
//   let blueprint = _.blueprint._define({ args, amending : o.amending });
//
//   _.construction._init
//   ({
//     constructing : false,
//     construction : o.construction,
//     amending : o.amending,
//     runtime : blueprint.Runtime,
//   });
//
// }
//
// _amendDefinitionWithoutMethod.defaults =
// {
//   construction : null,
//   definition : null,
//   key : null,
//   amending : null,
// }

//

function _amendCant( construction, definition, key )
{
  debugger;
  throw _.err( `Definition::${definition.kind} cant extend created construction after initialization. Use this definition during initialization only.` );
}

// --
// make
// --

function _make_head( routine, args )
{
  let genesis;

  if( args.length === 3 )
  {
    genesis = Object.create( null );
    genesis.construction = args[ 0 ];
    genesis.runtime = args[ 1 ];
    genesis.args = args[ 2 ];
    if( args[ 2 ][ 0 ] )
    {
      genesis.construction = args[ 2 ][ 0 ];
    }
    else if( !_.construction.isInstanceOf( genesis.construction, genesis.runtime ) )
    {
      _.assert( !( genesis.construction instanceof genesis.runtime.Retype ), 'Use no "new" to call routine::From' );
      genesis.construction = null;
    }
  }
  else
  {
    genesis = args[ 0 ];
    _.assert( _.mapIs( genesis ) );
  }

  _.routineOptions( routine, genesis );

  if( genesis.args === null )
  genesis.args = [];

  if( Config.debug )
  {
    let isInstance = _.construction.isInstanceOf( genesis.construction, genesis.runtime );
    _.assert( args.length === 1 || args.length === 3 );
    _.assert( !( genesis.construction instanceof genesis.runtime.Retype ), 'Use no "new" to call routine::From' );
    _.assert( genesis.args.length === 0 || genesis.args.length === 1 );
    _.assert( genesis.runtime.makeCompiled === undefined, 'not implemented' );
  }

  return genesis;
}

//

function _make3( genesis )
{

  if( genesis.args === undefined || genesis.args === null )
  genesis.args = [];

  _.assertRoutineOptions( _make3, arguments );
  _.assert( genesis.construction === null || _.objectIs( genesis.construction ) );
  _.assert( _.arrayLike( genesis.args ) );
  _.assert( genesis.args.length === 0 || genesis.args.length === 1 );
  _.assert( arguments.length === 1 );
  _.assert( _.fuzzyIs( genesis.runtime.Typed ) );

  if( genesis.constructing === 'retype' )
  {
    genesis.construction = genesis.runtime._RuntimeRoutinesMap.retype( genesis );
  }
  else if( genesis.constructing === 'allocate' )
  {
    let wasNull = genesis.construction === null
    genesis.construction = genesis.runtime._RuntimeRoutinesMap.allocate( genesis );
    if( genesis.runtime.Typed && wasNull )
    return genesis.construction;
  }
  else _.assert( genesis.constructing === false );

  if( genesis.runtime.Typed === true )
  _.assert( genesis.runtime.Make.prototype === null || genesis.construction instanceof genesis.runtime.Make );
  // else if( genesis.runtime.Typed === false ) /* yyy */
  // _.assert( genesis.runtime.Make.prototype === null || !( genesis.construction instanceof genesis.runtime.Make ) );

  _.construction._init( genesis );
  _.construction._extendArguments( genesis );

  return genesis.construction;
}

_make3.defaults =
{
  constructing : null,
  construction : null,
  amending : null,
  args : null,
  runtime : null,
}

//

function _make2( construction, runtime, args )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );

  let genesis = Object.create( null );
  genesis.construction = construction;
  genesis.args = args;
  genesis.runtime = runtime;
  genesis.constructing = 'allocate';
  genesis.amending = 'extend';

  return _.construction._make3( genesis );
}

//

function _make( construction, runtime, args )
{

  _.assert( arguments.length === 3 );

  if( !runtime.Typed && construction instanceof runtime.Make )
  {
    construction = null;
  }
  else if( _.construction.isInstanceOf( construction, runtime ) )
  {
  }
  else
  {
    construction = null;
  }

  _.assert( !runtime.makeCompiled, 'not tested' );

  construction = _.construction._make2( construction, runtime, args );

  return construction;
}

//

function _makeEach( construction, runtime, args )
{
  let result = [];
  _.assert( arguments.length === 3 );
  for( let a = 0 ; a < args.length ; a++ )
  {
    let construction = runtime.Make( args[ a ] );
    if( construction !== undefined )
    result.push( construction );
  }
  return result;
}

//

function _from( construction, runtime, args )
{

  if( Config.debug )
  {
    let isInstance = _.construction.isInstanceOf( construction, runtime );
    _.assert( arguments.length === 3 );
    _.assert( isInstance === false || isInstance === _.maybe );
    _.assert( !( construction instanceof runtime.Make ) );
    _.assert( !( construction instanceof runtime.From ), 'Use no "new" to call routine::From' );
  }

  if( _.construction.isInstanceOf( args[ 0 ], runtime ) )
  {
    _.assert( args.length === 1 );
    construction = args[ 0 ];
    return construction;
  }
  else
  {
    construction = null;
  }

  _.assert( !runtime.makeCompiled, 'not tested' );
  construction = _.construction._make2( construction, runtime, args );

  return construction;
}

//

function _fromEach( construction, runtime, args )
{
  let result = [];
  _.assert( arguments.length === 3 );
  for( let a = 0 ; a < args.length ; a++ )
  {
    let construction = runtime.From( args[ a ] );
    if( construction !== undefined )
    result.push( construction );
  }
  return result;
}

//

function _retype_body( genesis )
{

  if( Config.debug )
  {
    let isInstance = _.construction.isInstanceOf( genesis.construction, genesis.runtime );
    _.assert( arguments.length === 1 );
    _.assert( !( genesis.construction instanceof genesis.runtime.Retype ), 'Use no "new" to call routine::From' );
    _.assert( genesis.args.length === 0 || genesis.args.length === 1 );
    _.assert( genesis.runtime.makeCompiled === undefined, 'not implemented' );
  }

  return _.construction._make3( genesis );
}

_retype_body.defaults =
{
  ... _make3.defaults,
  constructing : 'retype',
  amending : 'supplement',
}

let _retype = _.routineUnite( _make_head, _retype_body );

//

function _retypeEach( construction, runtime, args )
{
  let result = [];
  _.assert( arguments.length === 3 );
  for( let a = 0 ; a < args.length ; a++ )
  {
    let construction = runtime.Retype( args[ a ] );
    if( construction !== undefined )
    result.push( construction );
  }
  return result;
}

//

function _init( genesis )
{
  _.assert( arguments.length === 1 );

  if( genesis.runtime._RuntimeRoutinesMap.initBegin )
  for( let i = 0 ; i < genesis.runtime._RuntimeRoutinesMap.initBegin.length ; i++ )
  genesis.runtime._RuntimeRoutinesMap.initBegin[ i ]( genesis );

  _.construction._initFields( genesis );
  _.construction._initDefines( genesis );

  if( genesis.runtime._RuntimeRoutinesMap.initEnd )
  for( let i = 0 ; i < genesis.runtime._RuntimeRoutinesMap.initEnd.length ; i++ )
  genesis.runtime._RuntimeRoutinesMap.initEnd[ i ]( genesis );

  return genesis;
}

_init.defaults =
{
  constructing : null,
  construction : null,
  amending : null,
  runtime : null,
}

//

function _initFields( genesis )
{

  _.assert( _.objectIs( genesis.construction ) );
  _.assert( _.blueprint.isRuntime( genesis.runtime ) );
  _.assert( arguments.length === 1 );
  _.assert( _.longHas( [ 'extend', 'supplement' ], genesis.amending ) );
  _.assert( _.mapIs( genesis.runtime.PropsSupplementation ) );

  if( genesis.amending === 'extend' )
  _.mapExtend( genesis.construction, genesis.runtime.PropsExtension );
  else
  _.mapSupplement( genesis.construction, genesis.runtime.PropsExtension );

  _.mapSupplement( genesis.construction, genesis.runtime.PropsSupplementation );

  return genesis.construction;
}

_initFields.defaults =
{
  construction : null,
  runtime : null,
  constructing : null,
}

//

function _initDefines( genesis )
{

  _.assert( _.objectIs( genesis.construction ) );
  _.assert( _.blueprint.isRuntime( genesis.runtime ) );
  _.assert( arguments.length === 1 );
  _.assert( _.longHas( [ 'extend', 'supplement' ], genesis.amending ) );

  if( genesis.runtime._RuntimeRoutinesMap.constructionInit )
  for( let i = 0 ; i < genesis.runtime._RuntimeRoutinesMap.constructionInit.length ; i++ )
  {
    let constructionInit = genesis.runtime._RuntimeRoutinesMap.constructionInit[ i ];
    constructionInit( genesis );
  }

  return genesis.construction;
}

_initDefines.defaults =
{
  construction : null,
  runtime : null,
  constructing : null,
}

//

function _extendArguments( genesis )
{

  _.assert( _.objectIs( genesis.construction ) );
  _.assert( _.blueprint.isRuntime( genesis.runtime ) );
  _.assert( genesis.args === undefined || _.arrayLike( genesis.args ) );
  _.assert( genesis.args === undefined || genesis.args.length === 0 || genesis.args.length === 1 );
  _.assert( arguments.length === 1 );

  if( !genesis.args || !genesis.args.length )
  return genesis.construction;

  _.assert( genesis.args.length === 1 );

  let o = genesis.args[ 0 ];
  if( o === null )
  return genesis.construction;

  _.assert( _.objectIs( o ) );

  if( genesis.construction !== o )
  _.mapExtend( genesis.construction, o );

  return genesis.construction;
}

_extendArguments.defaults =
{
  construction : null,
  args : null,
  runtime : null,
  constructing : null,
}

// --
// class Construction
// --

function Construction()
{
}

Construction.prototype = Object.create( null );
Object.freeze( Construction.prototype );

// --
// namespace construction
// --

let construction = Object.create( null );

var ConstructionExtension =
{

  isTyped,
  isInstanceOf,

  amend,
  extend,
  supplement,
  // _amendDefinitionWithoutMethod,
  _amendCant,

  _make2,
  _make3,

  _make,
  _makeEach,
  _from,
  _fromEach,
  _retype,
  _retypeEach,

  _init,
  _initFields,
  _initDefines,
  _extendArguments,

}

Object.assign( construction, ConstructionExtension );

// --
// namespace tools
// --

var ToolsExtension =
{

  construction,
  Construction,

}

_.assert( _.construction === undefined );

Object.assign( _, ToolsExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
