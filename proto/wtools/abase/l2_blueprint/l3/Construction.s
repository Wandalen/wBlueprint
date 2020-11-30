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

function isInstanceOf( construction, blueprint )
{
  _.assert( arguments.length === 2 );
  _.assert( _.blueprint.is( blueprint ) );

  if( !construction )
  return false;

  let next = construction;
  do
  {
    construction = next
    next = Object.getPrototypeOf( construction );
    if( construction === blueprint.Construct.prototype )
    return true;
  }
  while( next )

  // if( construction !== _.Construction.prototype ) /* yyy */
  // return false;
  // return true;

  return false; /* yyy */
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

function constructWithBlueprint( construction, blueprint, args )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( _.blueprint.isRuntime( blueprint._Runtime ) );
  return _.construction.constructWithRuntime( construction, blueprint._Runtime, args );
}

//

function constructWithRuntime( construction, runtime, args )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );

  let genesis = Object.create( null );
  genesis.construction = construction;
  genesis.args = args;
  genesis.runtime = runtime;
  genesis.reconstructing = 0;

  return _.construction._construct( genesis );
}

//

function reconstructWithRuntime( construction, runtime, args )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );

  let genesis = Object.create( null );
  genesis.construction = construction;
  genesis.args = args;
  genesis.runtime = runtime;
  genesis.reconstructing = 1;

  return _.construction._construct( genesis );
}

//

function _construct( genesis )
{

  if( genesis.args === undefined || genesis.args === null )
  genesis.args = [];

  _.assertRoutineOptions( _construct, arguments );
  _.assert( genesis.construction === null || _.objectIs( genesis.construction ) );
  _.assert( _.arrayLike( genesis.args ) );
  _.assert( genesis.args.length === 0 || genesis.args.length === 1 );
  _.assert( arguments.length === 1 );
  _.assert( _.boolIs( genesis.runtime.typed ) );

  let op = genesis.args[ 0 ];

  if( genesis.args.length === 1 && _.arrayLike( op ) )
  {
    return constructionsFromLong( op );
  }

  if( genesis.construction === null ) /* xxx : ? */
  if( genesis.runtime.typed )
  if( op instanceof genesis.runtime.construct )
  {
    _.assert( genesis.args.length === 1 );
    return op;
  }

  genesis.construction = constructAct();

  if( genesis.runtime.typed )
  _.assert( genesis.construction instanceof genesis.runtime.construct );
  else
  _.assert( !( genesis.construction instanceof genesis.runtime.construct ) );

  _.construction._init( genesis );
  if( !genesis.reconstructing )
  _.construction._extendArguments( genesis );

  return genesis.construction;

  /* */

  function constructAct()
  {
    if( genesis.reconstructing )
    return genesis.runtime._InternalRoutinesMap.reconstruct( genesis.construction, genesis.runtime.construct );
    else
    return genesis.runtime._InternalRoutinesMap.allocate( genesis.construction, genesis.runtime.construct );
  }

  function constructionsFromLong( long )
  {
    let result = [];
    for( let i = 0 ; i < long.length ; i++ )
    {
      let op = long[ i ];
      if( op === null )
      continue;
      if( genesis.construction === null )
      result.push( genesis.runtime.construct.call( null, op ) );
      else
      result.push( new genesis.runtime.construct( op ) );
    }
    return result;
  }

}

_construct.defaults =
{
  construction : null,
  args : null,
  runtime : null,
  reconstructing : 0,
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
  reconstructing : 0,
}

//

function _initFields( genesis )
{

  _.assert( _.objectIs( genesis.construction ) );
  _.assert( _.blueprint.isRuntime( genesis.runtime ) );
  _.assert( arguments.length === 1 );

  if( genesis.reconstructing )
  _.mapSupplement( genesis.construction, genesis.runtime.Fields );
  else
  _.mapExtend( genesis.construction, genesis.runtime.Fields );

  return genesis.construction;
}

_initFields.defaults =
{
  construction : null,
  runtime : null,
  reconstructing : 0,
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
    constructionInitContext.constructionInit.call( null, genesis.construction, constructionInitContext.name ); /* xxx : pass genesis? */
  }

  return genesis.construction;
}

_initDefines.defaults =
{
  construction : null,
  runtime : null,
  reconstructing : 0,
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
  reconstructing : 0,
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

  constructWithBlueprint,
  constructWithRuntime,
  reconstructWithRuntime,
  _construct,
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
