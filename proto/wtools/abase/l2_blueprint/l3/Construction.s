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

  if( _.blueprint.is( runtime ) )
  runtime = runtime.Runtime;

  _.assert( arguments.length === 2 );
  _.assert( _.blueprint.isRuntime( runtime ) );
  _.assert( _.boolIs( runtime.Typed ) );

  if( runtime.Typed )
  return construction instanceof runtime.Make;

  if( _.mapIs( construction ) )
  return _.maybe;
  return false;
}

//

function extend( dst, src )
{
  if( dst === null )
  dst = Object.create( null );

  if( _.blueprint.is( src ) )
  {
    _.assert( !_.blueprint.is( dst ), 'not implemented' ); /* xxx */
    _.mapExtend( dst, src.Fields );
    _.assert( 0, 'not implemented' );
  }
  else
  {

    for( let s in src )
    {
      let def = src[ s ];
      if( _.definitionIs( def ) )
      definitionExtend( def, dst, s );
      else
      dst[ s ] = def;
    }

  }

  return dst;

  function definitionExtend( def, dst, s )
  {
    def.constructionAmend( dst, s, 'extend' );
  }

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
  construction = _.construction._construct2( construction, runtime, args );

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

  construction = _.construction._construct2( construction, runtime, args );

  return construction;
}

//

function _construct2( construction, runtime, args )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );

  let genesis = Object.create( null );
  genesis.construction = construction;
  genesis.args = args;
  genesis.runtime = runtime;
  genesis.retyping = 0;

  return _.construction._construct3( genesis );
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
  genesis.retyping = 1;

  return _.construction._construct3( genesis );
}

//

function _construct3( genesis )
{

  if( genesis.args === undefined || genesis.args === null )
  genesis.args = [];

  _.assertRoutineOptions( _construct3, arguments );
  _.assert( genesis.construction === null || _.objectIs( genesis.construction ) );
  _.assert( _.arrayLike( genesis.args ) );
  _.assert( genesis.args.length === 0 || genesis.args.length === 1 );
  _.assert( arguments.length === 1 );
  _.assert( _.boolIs( genesis.runtime.Typed ) );

  genesis.construction = constructAct();

  if( genesis.runtime.Typed )
  _.assert( genesis.construction instanceof genesis.runtime.Make );
  else
  _.assert( !( genesis.construction instanceof genesis.runtime.Make ) );

  _.construction._init( genesis );
  if( !genesis.retyping )
  _.construction._extendArguments( genesis );

  return genesis.construction;

  /* */

  function constructAct()
  {
    if( genesis.retyping )
    return genesis.runtime._InternalRoutinesMap.retype( genesis );
    else
    return genesis.runtime._InternalRoutinesMap.allocate( genesis );
  }

}

_construct3.defaults =
{
  construction : null,
  args : null,
  runtime : null,
  retyping : 0,
}

//

function _init( genesis )
{
  _.assert( arguments.length === 1 );

  if( genesis.runtime._InternalRoutinesMap.initBegin )
  for( let i = 0 ; i < genesis.runtime._InternalRoutinesMap.initBegin.length ; i++ )
  genesis.runtime._InternalRoutinesMap.initBegin[ i ]( genesis );

  _.construction._initFields( genesis );
  _.construction._initDefines( genesis );

  if( genesis.runtime._InternalRoutinesMap.initEnd )
  for( let i = 0 ; i < genesis.runtime._InternalRoutinesMap.initEnd.length ; i++ )
  genesis.runtime._InternalRoutinesMap.initEnd[ i ]( genesis );

  return genesis;
}

_init.defaults =
{
  construction : null,
  runtime : null,
  retyping : 0,
}

//

function _initFields( genesis )
{

  _.assert( _.objectIs( genesis.construction ) );
  _.assert( _.blueprint.isRuntime( genesis.runtime ) );
  _.assert( arguments.length === 1 );

  if( genesis.retyping )
  _.mapSupplement( genesis.construction, genesis.runtime.Fields );
  else
  _.mapExtend( genesis.construction, genesis.runtime.Fields );

  return genesis.construction;
}

_initFields.defaults =
{
  construction : null,
  runtime : null,
  retyping : 0,
}

//

function _initDefines( genesis )
{

  _.assert( _.objectIs( genesis.construction ) );
  _.assert( _.blueprint.isRuntime( genesis.runtime ) );
  _.assert( arguments.length === 1 );

  if( genesis.runtime._InternalRoutinesMap.constructionInit )
  for( let i = 0 ; i < genesis.runtime._InternalRoutinesMap.constructionInit.length ; i++ )
  {
    let constructionInitContext = genesis.runtime._InternalRoutinesMap.constructionInit[ i ];
    constructionInitContext.constructionInit( genesis );
    // constructionInitContext.constructionInit.call( null, genesis.construction, constructionInitContext.name ); /* xxx : pass genesis? */
  }

  return genesis.construction;
}

_initDefines.defaults =
{
  construction : null,
  runtime : null,
  retyping : 0,
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
  retyping : 0,
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
  extend,

  _from,
  _makeEach,
  _make,
  _construct2,
  _retype,
  _construct3,
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
