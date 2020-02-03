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

  for( let s in src )
  {
    let def = src[ s ];
    if( _.definitionIs( def ) )
    definitionExtend( def, dst, s );
    else
    dst[ s ] = def;
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

  if( args === undefined )
  args = [];

  _.assert( construction === null || _.objectIs( construction ) );
  _.assert( _.arrayLike( args ) );
  _.assert( args.length === 0 || args.length === 1 );
  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( _.blueprint.is( blueprint ) );
  _.assert( !!blueprint.traits.typed );

  let o = args[ 0 ];

  if( args.length === 1 && _.arrayLike( args[ 0 ] ) )
  {
    return constructionsFromLong( args[ 0 ] );
  }

  if( construction === null )
  if( blueprint.traits.typed.value )
  if( o instanceof blueprint.construct )
  {
    _.assert( args.length === 1 );
    return o;
  }

  construction = constructionAllocate();

  if( blueprint.traits.typed.value )
  _.assert( construction instanceof blueprint.construct );
  else
  _.assert( !( construction instanceof blueprint.construct ) );

  _.construction._init( construction, blueprint );
  _.construction._extendArguments( construction, blueprint, args );

  return construction;

  function constructionAllocate()
  {
    return blueprint.constructionHandlers.allocate( construction, blueprint );
  }

  function constructionsFromLong( long )
  {
    let result = [];
    for( let i = 0 ; i < long.length ; i++ )
    {
      let o = long[ i ];
      if( o === null )
      continue;
      if( construction === null )
      result.push( blueprint.construct( o ) );
      else
      result.push( new blueprint.construct( o ) );
    }
    return result;
  }

}

//

function _init( construction, blueprint )
{
  _.assert( arguments.length === 2 );

  if( blueprint.constructionHandlers.initBegin )
  for( let i = 0 ; i < blueprint.constructionHandlers.initBegin.length ; i++ )
  blueprint.constructionHandlers.initBegin[ i ]( construction, blueprint );

  _.construction._initFields( construction, blueprint );
  _.construction._initDefines( construction, blueprint );

  if( blueprint.constructionHandlers.initEnd )
  for( let i = 0 ; i < blueprint.constructionHandlers.initEnd.length ; i++ )
  blueprint.constructionHandlers.initEnd[ i ]( construction, blueprint );

  return construction;
}

//

function _initFields( construction, blueprint )
{

  _.assert( _.objectIs( construction ) );
  _.assert( _.blueprint.is( blueprint ) );
  _.assert( arguments.length === 2 );

  _.mapExtend( construction, blueprint.fields );

  return construction;
}

//

function _initDefines( construction, blueprint )
{

  _.assert( _.objectIs( construction ) );
  _.assert( _.blueprint.is( blueprint ) );
  _.assert( arguments.length === 2 );

  // for( let f in blueprint.namedDefinitions )
  // {
  //   let definition = blueprint.namedDefinitions[ f ];
  //   // if( definition.isMeta )
  //   // continue;
  //   // _.assert( _.routineIs( definition.initialValueGet ) );
  //   if( definition.initialValueGet )
  //   _.assert( 0, 'not implemented' );
  //   // definition.initialValueGet({ fieldName : f });
  //   // construction[ f ] = definition.initialValueGet({ fieldName : f })
  // }

  if( blueprint.constructionHandlers.constructionInit )
  for( let i = 0 ; i < blueprint.constructionHandlers.constructionInit.length ; i++ )
  {
    let definition = blueprint.constructionHandlers.constructionInit[ i ];
    _.assert( _.strDefined( definition.name ) );
    _.assert( _.routineIs( definition.constructionInit ) );
    definition.constructionInit( construction, definition.name )
  }

  return construction;
}

//

function _extendArguments( construction, blueprint, args )
{

  _.assert( _.objectIs( construction ) );
  _.assert( _.blueprint.is( blueprint ) );
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
// Construction.prototype.constructor = Construction;

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
