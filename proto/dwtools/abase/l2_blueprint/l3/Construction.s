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

    if( construction === blueprint.construct.prototype )
    return true;

  }
  while( next )

  if( construction !== _.Construction.prototype )
  return false;

  return true;
}

//

function extend( dst, src )
{
  if( dst === null )
  dst = Object.create( null );

  if( _.blueprint.is( src ) )
  {
    _.assert( !_.blueprint.is( dst ), 'not implemented' ); /* xxx */
    _.mapExtend( dst, src.fields );

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

function makeWithBlueprint( construction, blueprint, args )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( _.blueprint.isRuntime( blueprint.runtime ) );
  return _.construction.makeWithRuntime( construction, blueprint.runtime, args );
}

//

function makeWithRuntime( construction, runtime, args )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );

  let o2 =
  {
    construction,
    args,
    runtime,
  }

  return _.construction._make( o2 );
}

//

function _make( o )
{

  if( o.args === undefined || o.args === null )
  o.args = [];

  _.assertRoutineOptions( _make, arguments );
  _.assert( o.construction === null || _.objectIs( o.construction ) );
  _.assert( _.arrayLike( o.args ) );
  _.assert( o.args.length === 0 || o.args.length === 1 );
  _.assert( arguments.length === 1 );
  _.assert( _.boolIs( o.runtime.typed ) );

  let op = o.args[ 0 ];

  if( o.args.length === 1 && _.arrayLike( op ) )
  {
    return constructionsFromLong( op );
  }

  if( o.construction === null )
  if( o.runtime.typed )
  if( op instanceof o.runtime.construct )
  {
    _.assert( o.args.length === 1 );
    return op;
  }

  o.construction = constructionAllocate();

  if( o.runtime.typed )
  _.assert( o.construction instanceof o.runtime.construct );
  else
  _.assert( !( o.construction instanceof o.runtime.construct ) );

  _.construction._init( o.construction, o.runtime );
  _.construction._extendArguments( o.construction, o.runtime, o.args );

  return o.construction;

  function constructionAllocate()
  {
    return o.runtime.constructionHandlers.allocate( o.construction, o.runtime.construct );
  }

  function constructionsFromLong( long )
  {
    let result = [];
    for( let i = 0 ; i < long.length ; i++ )
    {
      let op = long[ i ];
      if( op === null )
      continue;
      if( o.construction === null )
      result.push( o.runtime.construct.call( null, op ) );
      else
      result.push( new o.runtime.construct( op ) );
    }
    return result;
  }

}

_make.defaults =
{
  construction : null,
  args : null,
  runtime : null,
}

//

function _init( construction, runtime )
{
  _.assert( arguments.length === 2 );

  if( runtime.constructionHandlers.initBegin )
  for( let i = 0 ; i < runtime.constructionHandlers.initBegin.length ; i++ )
  runtime.constructionHandlers.initBegin[ i ]( construction, runtime );

  _.construction._initFields( construction, runtime );
  _.construction._initDefines( construction, runtime );

  if( runtime.constructionHandlers.initEnd )
  for( let i = 0 ; i < runtime.constructionHandlers.initEnd.length ; i++ )
  runtime.constructionHandlers.initEnd[ i ]( construction, runtime );

  return construction;
}

//

function _initFields( construction, runtime )
{

  _.assert( _.objectIs( construction ) );
  _.assert( _.blueprint.isRuntime( runtime ) );
  _.assert( arguments.length === 2 );

  _.mapExtend( construction, runtime.fields );

  return construction;
}

//

function _initDefines( construction, runtime )
{

  _.assert( _.objectIs( construction ) );
  _.assert( _.blueprint.isRuntime( runtime ) );
  _.assert( arguments.length === 2 );

  if( runtime.constructionHandlers.constructionInit )
  for( let i = 0 ; i < runtime.constructionHandlers.constructionInit.length ; i++ )
  {
    let constructionInitContext = runtime.constructionHandlers.constructionInit[ i ];
    constructionInitContext.constructionInit.call( null, construction, constructionInitContext.name );
  }

  return construction;
}

//

function _extendArguments( construction, runtime, args )
{

  _.assert( _.objectIs( construction ) );
  _.assert( _.blueprint.isRuntime( runtime ) );
  _.assert( args === undefined || _.arrayLike( args ) );
  _.assert( args === undefined || args.length === 0 || args.length === 1 );
  _.assert( arguments.length === 3 );

  if( !args || !args.length )
  return construction;

  _.assert( args.length === 1 );
  let o = args[ 0 ];

  _.assert( _.objectIs( o ) );

  if( construction !== o )
  _.mapExtend( construction, o );

  return construction;
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

  makeWithBlueprint,
  makeWithRuntime,
  _make,
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

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _;

})();
