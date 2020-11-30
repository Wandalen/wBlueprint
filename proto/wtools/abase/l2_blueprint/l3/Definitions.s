( function _Definitions_s_() {

'use strict';

let Self = _global_.wTools;
let _global = _global_;
let _ = _global_.wTools;

// --
// collection
// --

function _pairArgumentshead( routine, args )
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

function field( o )
{

  _.assert( _.mapIs( o ) );
  _.assert( o.ini !== undefined );
  o = _.routineOptions( field, arguments );
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( o.iniToIns ) );
  _.assert( _.longHas( [ 'scalar' , 'array' , 'map' ], o.collection ) );
  _.assert( 'scalar' === o.collection, 'not implemented' ); /* zzz : implement */
  _.assert( _.longHas( [ 'val' , 'shallow' , 'clone' , 'call' , 'construct' ], o.iniToIns ) );
  _.assert( o.ini !== undefined );

  _.assert( o.collection === 'scalar', 'not implemented' );
  _.assert( o.insToIns === 'val', 'not implemented' );
  _.assert( o.datToIns === 'val', 'not implemented' );
  _.assert( o.insToDat === 'val', 'not implemented' );
  _.assert( o.datToDat === 'val', 'not implemented' );

  o.definitionGroup = 'definition.named';
  o.blueprintForm2 = blueprintForm2;
  o.name = null;
  o.constructionInit = null;

  let definition = new _.Definition( o );
  let ini = definition.ini;

  /* */

  if( o.iniToIns === 'val' )
  {
    definition.valueGenerate = function get() { return this.ini }
  }
  else if( o.iniToIns === 'shallow' )
  {
    definition.valueGenerate = function get() { return _.entityMake( this.ini ) }
  }
  else if( o.iniToIns === 'deep' )
  {
    debugger;
    definition.valueGenerate = function get() { return _.cloneJust( this.ini ) }
  }
  else if( o.iniToIns === 'make' )
  {
    debugger;
    definition.valueGenerate = function get() { return this.ini() }
  }
  else if( o.iniToIns === 'construct' )
  {
    debugger;
    definition.valueGenerate = function get() { return new this.ini() }
  }
  else _.assert( 0 );

  /* */

  function blueprintForm2( blueprint, key )
  {
    let handlers = blueprint._InternalRoutinesMap.constructionInit = blueprint._InternalRoutinesMap.constructionInit || [];

    if( o.iniToIns === 'val' )
    {
      definition.constructionInit = constructionInitVal;
    }
    else if( o.iniToIns === 'shallow' )
    {
      definition.constructionInit = constructionInitShallow;
    }
    else if( o.iniToIns === 'clone' )
    {
      debugger;
      definition.constructionInit = constructionInitClone;
    }
    else if( o.iniToIns === 'make' )
    {
      debugger;
      definition.constructionInit = constructionInitCall;
    }
    else if( o.iniToIns === 'construct' )
    {
      debugger;
      definition.constructionInit = constructionInitNew;
    }
    else _.assert( 0 );

    _.assert( _.strIs( definition.name ) );
    handlers.push({ constructionInit : definition.constructionInit, name : definition.name })
    definition.constructionInit.meta =
    {
      extenral : { ini : ini }
    }
  }

  /* */

/*
  common,
  own,
  instanceOf,
  makeWith,
*/

  Object.preventExtensions( definition );
  return definition;

  function constructionInitVal( construction, name )
  {
    construction[ name ] = ini;
  }
  function constructionInitShallow( construction, name )
  {
    construction[ name ] = _.entityMake( ini );
  }
  function constructionInitClone( construction, name )
  {
    construction[ name ] = _.cloneJust( ini );
  }
  function constructionInitCall( construction, name )
  {
    construction[ name ] = ini()
  }
  function constructionInitNew( construction, name )
  {
    construction[ name ] = new ini()
  }

}

field.defaults =
{
  order           : 0,
  // static          : 0,
  // enumerable      : 1,
  // configurable    : 1,
  // writable :      : 1,
  collection      : 'scalar',
  insToIns        : 'val',
  datToIns        : 'val',
  insToDat        : 'val',
  datToDat        : 'val',
  iniToIns        : 'val',
  ini             : null,
  // relation        : null,
}

/*
|                | Composes | Aggregates | Associates  |  Restricts  |  Medials  |   Statics   |
| -------------- |:--------:|:----------:|:-----------:|:-----------:|:---------:|:-----------:|
| Static         |          |            |             |             |           |      +      |
| Ins to Ins     |   deep   |    val     |    val      |      -      |     -     |             |
| Dat to Ins     |   deep   |    deep    |    val      |      -      |   val     |             |
| Ins to Dat     |   deep   |    deep    |    val      |      -      |     -     |             |
| Dat to Dat     |   deep   |    deep    |    val      |      -      |   val     |             |
*/

/*
order           : [ -10 .. +10 ]                                                                            @default : 0
static          : [ 0 , 1 ]                                                                                 @default : 0
enumerable      : [ 0 , 1 ]                                                                                 @default : 1
configurable    : [ 0 , 1 ]                                                                                 @default : 1
writable        : [ 0 , 1 ]                                                                                 @default : 1
valueGenerate   : routine                                                                                   @default : null
collection      : [ scalar , array , map ]                                                                  @default : scalar
insToIns        : [ val , shallow , deep ]                                                                  @default : val
datToIns        : [ val , shallow , deep ]                                                                  @default : val
insToDat        : [ val , shallow , deep ]                                                                  @default : val
datToDat        : [ val , shallow , deep ]                                                                  @default : val
iniToIns        : [ val , shallow , deep , make , construct ]                                               @default : val
relation        : [ null , composes , aggregates , associates , restricts , medials , statics , copiers ]   @default : null
ini             : *                                                                                         @default : null
*/

//

function shallow( src )
{
  let o = Object.create( null );

  o.ini = src;
  o.iniToIns = 'shallow';

  // debugger;
  return _.define.field( o );
}

//

function _amendment_head( routine, args )
{
  let o = _pairArgumentshead( ... arguments );
  _.assert( _.longHas( [ 'extend', 'supplement' ], o.amending ) );
  return o;
}

function _amendment_body( o )
{

  _.assertRoutineOptions( _amendment_body, arguments );
  _.assert( _.objectIs( o.val ) );
  _.assert( _.blueprintIs( o.val ) );

  o.definitionGroup = 'definition.unnamed';

  let definition = new _.Definition( o );

  definition.kind = o.amending;
  definition.constructionAmend = constructionAmend;
  definition.blueprintAmend = blueprintAmend;

  _.assert( definition.amending === o.amending );

  Object.freeze( definition );
  return definition;

  function constructionAmend( construction, key )
  {
    _.assert( 0, 'not implemented' ); /* zzz */
  }

  function blueprintAmend( o )
  {
    let definition = this;
    let blueprint = o.blueprint;
    if( o.blueprintDepth )
    return;
    return _.blueprint._amend
    ({
      ... o,
      extension : definition.val,
      amending : definition.amending,
      // amending : o.amending, /* xxx : cover */
      blueprintAction : 'amend',
      blueprintDepthReserve : definition.blueprintDepthReserve + o.blueprintDepthReserve,
    });
  }

}

_amendment_body.defaults =
{
  amending : null,
  val : null,
  blueprintDepthReserve : 0,
}

let _amendment = _.routineUnite( _amendment_head, _amendment_body );

//

function extension()
{
  let o = _.define._amendment.head( extension, arguments );
  return _.define._amendment.body( o );
}

extension.defaults =
{
  ... _amendment.defaults,
  amending : 'extend',
}

//

function supplementation()
{
  let o = _.define._amendment.head( supplementation, arguments );
  return _.define._amendment.body( o );
}

supplementation.defaults =
{
  ... _amendment.defaults,
  amending : 'supplement',
}

//

function inherit( o )
{
  if( !_.mapIs( o ) )
  o = { ini : arguments[ 0 ] };
  _.routineOptions( inherit, o );
  let result = [];
  result.push( _.define.extension( o.ini ) );
  result.push( _.trait.prototype( o.ini ) );
  result.push( _.trait.typed( true ) );
  return result;
}

inherit.defaults =
{
  ini : null,
}

//

function static_head( routine, args )
{
  let o = _pairArgumentshead( ... arguments );
  return o;
}

function static_body( o )
{

  _.assertRoutineOptions( static_body, o );
  _.assert( arguments.length === 1 );

  o.definitionGroup = 'definition.named';
  o.name = null;
  let definition = new _.Definition( o );
  definition.kind = 'static';
  definition.constructionAmend = constructionAmend;
  definition.blueprintForm2 = blueprintForm2;
  Object.preventExtensions( definition );

  _.assert( definition.blueprintDepthReserve >= 0 );

  return definition;

  function constructionAmend( construction, key )
  {
    _.assert( 0, 'not implemented' ); /* zzz */
  }

  function blueprintForm2( blueprint, key )
  {
    let definition = this;
    blueprint.Construct.prototype[ key ] = definition.val;
  }

}

static_body.defaults =
{
  val : null,
  blueprintDepthLimit : 1,
  blueprintDepthReserve : 0,
}

let _static = _.routineUnite( static_head, static_body );

//

function statics_head( routine, args )
{
  let o = _pairArgumentshead( ... arguments );
  return o;
}

// function statics_body( fields )
function statics_body( o )
{

  _.assert( arguments.length === 1 );
  _.assertRoutineOptions( statics_body, o );
  _.assert( _.mapIs( o.val ) || _.longIs( o.val ), `Expects primitive or routine` );

  // let o = Object.create( null );
  // o.val = val;
  o.definitionGroup = 'definition.named';
  o.name = null;

  let definition = new _.Definition( o );
  definition.kind = 'statics';
  definition.constructionAmend = constructionAmend;
  definition.blueprintForm2 = blueprintForm2;
  // definition.blueprintDepthReserve = 1;
  Object.preventExtensions( definition );

  _.assert( definition.blueprintDepthReserve >= 0 );

  return definition;

  function constructionAmend( construction, key )
  {
    _.assert( 0, 'not implemented' ); /* zzz */
  }

  function blueprintForm2( blueprint, key )
  {
    let definition = this;
    let fieldsArray = _.arrayAs( definition.val );
    for( let a = 0 ; a < fieldsArray.length ; a++ )
    {
      let fields = fieldsArray[ a ];
      _.assert( _.mapIs( fields ) );
      for( let f in fields )
      {
        let fieldValue = fieldsArray[ a ][ f ];
        blueprint.Construct.prototype[ f ] = fieldValue;
      }
    }
  }

}

statics_body.defaults =
{
  val : null,
  blueprintDepthLimit : 1,
  blueprintDepthReserve : 0,
}

let statics = _.routineUnite( statics_head, statics_body );

// --
//
// --

let DefineExtension =
{

  field,
  shallow,

  _amendment,
  extension,
  supplementation,
  inherit,

  static : _static,
  statics,

}

_.define = _.define || Object.create( null );
_.mapExtend( _.define, DefineExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
