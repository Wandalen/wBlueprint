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

  // if( _global_.debugger )
  // debugger;

  if( runtime.Typed && runtime.Make.prototype !== null )
  {
    // if( !runtime.Make.prototype )
    // return _.maybe;
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
  if( _global_.debugger )
  debugger;
  return constructionExtend( o.dstConstruction, o.src, null );

  /* */

  function constructionExtend( dstConstruction, src, name )
  {
    if( _.mapIs( src ) )
    return constructionMapExtend( dstConstruction, src, name );
    else if( _.definitionIs( src ) )
    return constructionDefinitionExtend( dstConstruction, src, name );
    else if( _.blueprintIsDefinitive( src ) )
    return constructionBlueprintExtend( dstConstruction, src, name );
    else _.assert( 0 );
  }

  function constructionMapExtend( dstConstruction, map, name )
  {
    _.assert( _.mapIs( map ) );
    for( let name2 in map )
    {
      let def = map[ name2 ];
      if( _.definitionIs( def ) )
      constructionDefinitionExtend( dstConstruction, def, name2 );
      else
      dstConstruction[ name2 ] = def; /* xxx */
    }
    return dstConstruction;
  }

  function constructionDefinitionExtend( dstConstruction, def, name )
  {
    _.assert( _.definitionIs( def ) );
    def.constructionAmend( dstConstruction, name, o.amending );
    return dstConstruction;
  }

  function constructionBlueprintExtend( dstConstruction, blueprint, name )
  {
    _.assert( !_.blueprint.is( dstConstruction ) );
    return blueprint.Retype( dstConstruction );
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

//

// function _amendDefinitionWithoutMethod_functor( fop )
// {
//
//   _.routineOptions( _amendDefinitionWithoutMethod_functor, fop );
//
//   _amendDefinitionWithoutMethod.defaults =
//   {
//     construction : null,
//     definition : null,
//     key : null,
//     amend : null,
//   }
//
//   function _amendDefinitionWithoutMethod( o )
//   {
//
//     if( !o.definition )
//     o.definition = fop.definition
//
//     _.assertMapHasAll( o, _amendDefinitionWithoutMethod.defaults );
//     _.assert( _.strIs( o.key ) || _.symbolIs( o.key ) );
//     _.assert( _.definitionIs( o.definition ) );
//     _.assert( _.longHas( [ 'supplement', 'extend' ], o.amend ) );
//
//     if( o.amend === 'supplement' )
//     {
//       if( Object.hasOwnProperty.call( o.construction, o.key && o.construction[ o.key ] !== undefined ) )
//       return;
//     }
//
//     debugger;
//
//     let prototype = _.prototype.of( o.construction );
//     let defs = [];
//     if( prototype )
//     defs.push( _.trait.prototype( prototype, { new : false } ) );
//     defs.push( _.trait.extendable( true ) );
//     let blueprint = _.blueprint.define( defs, { [ o.key ] : o.definition } );
//     _.construction._init
//     ({
//       constructing : false,
//       construction : o.construction,
//       runtime : blueprint.Runtime,
//     });
//
//   }
//
// }
//
// _amendDefinitionWithoutMethod_functor.defaults =
// {
//   definition : null,
// }

//

function _amendDefinitionWithoutMethod( o )
{

  _.assertMapHasAll( o, _amendDefinitionWithoutMethod.defaults );
  _.assert( _.strIs( o.key ) || _.symbolIs( o.key ) );
  _.assert( _.definitionIs( o.definition ) );
  _.assert( _.longHas( [ 'supplement', 'extend' ], o.amend ) );

  if( o.amend === 'supplement' )
  {
    /* xxx qqq : cover */
    if( Object.hasOwnProperty.call( o.construction, o.key ) && o.construction[ o.key ] !== undefined )
    return;
  }

  let prototype = _.prototype.of( o.construction );
  let defs = [];
  if( prototype )
  defs.push( _.trait.prototype( prototype, { new : false } ) );
  defs.push( _.trait.extendable( true ) );
  let blueprint = _.blueprint.define( defs, { [ o.key ] : o.definition } );
  _.construction._init
  ({
    constructing : false,
    construction : o.construction,
    runtime : blueprint.Runtime,
  });

}

_amendDefinitionWithoutMethod.defaults =
{
  construction : null,
  definition : null,
  key : null,
  amend : null,
}

//

function _amendCant( construction, definition, key )
{
  debugger;
  throw _.err( `Definition::${definition.kind} cant extend created construction after initialization. Use this definition during initialization only.` );
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

function _retype( construction, runtime, args )
{

  if( Config.debug )
  {
    let isInstance = _.construction.isInstanceOf( construction, runtime );
    _.assert( arguments.length === 3 );
    _.assert( isInstance === false || isInstance === _.maybe );
    _.assert( !( construction instanceof runtime.Make ) );
    _.assert( !( construction instanceof runtime.Retype ), 'Use no "new" to call routine::From' );
    _.assert( args.length === 0 || args.length === 1 );
    _.assert( runtime.makeCompiled === undefined, 'not implemented' );
  }

  if( args[ 0 ] )
  construction = args[ 0 ];
  else if( !_.construction.isInstanceOf( construction, runtime ) )
  construction = null;

  let genesis = Object.create( null );
  genesis.construction = construction;
  genesis.args = args;
  genesis.runtime = runtime;
  genesis.constructing = 'retype';

  return _.construction._make3( genesis );
}

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

function _make2( construction, runtime, args )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );

  let genesis = Object.create( null );
  genesis.construction = construction;
  genesis.args = args;
  genesis.runtime = runtime;
  genesis.constructing = 'allocate';

  return _.construction._make3( genesis );
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

  genesis.construction = constructAct();

  if( genesis.runtime.Typed === true )
  _.assert( genesis.runtime.Make.prototype === null || genesis.construction instanceof genesis.runtime.Make );
  else if( genesis.runtime.Typed === false )
  _.assert( genesis.runtime.Make.prototype === null || !( genesis.construction instanceof genesis.runtime.Make ) );

  _.construction._init( genesis );
  _.construction._extendArguments( genesis );

  return genesis.construction;

  /* */

  function constructAct()
  {
    if( genesis.constructing === 'retype' )
    return genesis.runtime._RuntimeRoutinesMap.retype( genesis );
    else if( genesis.constructing === 'allocate' )
    return genesis.runtime._RuntimeRoutinesMap.allocate( genesis );
    else _.assert( genesis.constructing === false );
  }

}

_make3.defaults =
{
  constructing : null,
  construction : null,
  args : null,
  runtime : null,
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
  runtime : null,
}

//

function _initFields( genesis )
{

  _.assert( _.objectIs( genesis.construction ) );
  _.assert( _.blueprint.isRuntime( genesis.runtime ) );
  _.assert( arguments.length === 1 );

  if( genesis.constructing === 'allocate' )
  _.mapExtend( genesis.construction, genesis.runtime.Props );
  else if( genesis.constructing === 'retype' )
  _.mapSupplement( genesis.construction, genesis.runtime.Props );
  else if( genesis.constructing === false )
  _.mapSupplement( genesis.construction, genesis.runtime.Props );
  else _.assert( 0 );

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

  if( genesis.runtime._RuntimeRoutinesMap.constructionInit )
  for( let i = 0 ; i < genesis.runtime._RuntimeRoutinesMap.constructionInit.length ; i++ )
  {
    let constructionInitContext = genesis.runtime._RuntimeRoutinesMap.constructionInit[ i ];
    constructionInitContext( genesis );
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
  _amendDefinitionWithoutMethod,
  _amendCant,

  _make,
  _makeEach,
  _from,
  _fromEach,
  _retype,
  _retypeEach,

  _make2,
  _make3,
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
