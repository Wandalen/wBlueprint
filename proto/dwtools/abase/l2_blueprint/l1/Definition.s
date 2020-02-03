( function _Definition_s_() {

'use strict';

let Self = _global_.wTools;
let _global = _global_;
let _ = _global_.wTools;

// --
// implement
// --

/**
* @classdesc Class container for creating property-like entity from non-primitive value.
  Is used by routines:
  @see {@link module:Tools/base/Proto.wTools.define.own}
  @see {@link module:Tools/base/Proto.wTools.define.common}
  @see {@link module:Tools/base/Proto.wTools.define.instanceOf}
  @see {@link module:Tools/base/Proto.wTools.define.makeWith}
  @see {@link module:Tools/base/Proto.wTools.define.contained}
* @class Definition
* @memberof module:Tools/base/Proto.wTools.define
*/

function Definition( o )
{
  _.assert( arguments.length === 1 );
  if( !( this instanceof Definition ) )
  if( o instanceof Definition )
  return o;
  else
  return new( _.constructorJoin( Definition, arguments ) );
  _.mapExtend( this, o );
  _.assert( _.longHas( [ 'etc', 'trait', 'definition.unnamed', 'definition.named' ], o.definitionGroup ) );
  return this;
}

Definition.prototype = Object.create( null );
Definition.prototype.clone = function()
{
  return new Definition( this );
}

//

function _constructionAmendCant( construction, key )
{
  let trait = this;
  debugger;
  throw _.err( `Trait::${trait.kind} cant extend created construction after initialization. Use this trait during initialization only.` );
}

//

function _traitMake( routine, o )
{

  _.assert( arguments.length === 2 );
  _.assert( _.routineIs( routine ) );
  _.assert( _.strDefined( routine.name ) );
  _.assert( _.mapIs( o ) );

  o.definitionGroup = 'trait';
  o.ini = null;
  o.kind = routine.name;
  if( !o.constructionAmend )
  o.constructionAmend = _.definition._constructionAmendCant;

  let definition = new _.Definition( o );
  Object.freeze( definition );
  return definition;
}

// --
// collection
// --

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
    definition.initialValueGet = function get() { return this.ini }
  }
  else if( o.iniToIns === 'shallow' )
  {
    definition.initialValueGet = function get() { return _.entityMake( this.ini ) }
  }
  else if( o.iniToIns === 'deep' )
  {
    debugger;
    definition.initialValueGet = function get() { return _.cloneJust( this.ini ) }
  }
  else if( o.iniToIns === 'make' )
  {
    debugger;
    definition.initialValueGet = function get() { return this.ini() }
  }
  else if( o.iniToIns === 'construct' )
  {
    debugger;
    definition.initialValueGet = function get() { return new this.ini() }
  }
  else _.assert( 0 );

  /* */

  function blueprintForm2( blueprint, key )
  {
    let handlers = blueprint.constructionHandlers.constructionInit = blueprint.constructionHandlers.constructionInit || [];

    if( o.iniToIns === 'val' )
    {
      definition.constructionInit = constructionInitVal;
      // handlers.push( definition.constructionInit );
    }
    else if( o.iniToIns === 'shallow' )
    {
      definition.constructionInit = constructionInitShallow;
      // handlers.push( definition.constructionInit );
    }
    else if( o.iniToIns === 'clone' )
    {
      debugger;
      definition.constructionInit = constructionInitClone;
      // handlers.push( definition.constructionInit );
    }
    else if( o.iniToIns === 'make' )
    {
      debugger;
      definition.constructionInit = constructionInitCall;
      // handlers.push( definition.constructionInit )
    }
    else if( o.iniToIns === 'construct' )
    {
      debugger;
      definition.constructionInit = constructionInitNew;
      // handlers.push( definition.constructionInit )
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
initialValueGet : routine                                                                                   @default : null
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

function _amendment( o )
{

  _.assertRoutineOptions( _amendment, arguments );
  _.assert( _.longHas( [ 'extend', 'supplement' ], o.amending ) );

  if( Config.debug )
  for( let a = 0 ; a < o.args.length ; a++ )
  {
    let arg = o.args[ a ];
    _.assert( _.objectIs( arg ) );
  }

  o.definitionGroup = 'definition.unnamed';

  let definition = new _.Definition( o );

  definition.kind = o.amending;
  definition.amending = o.amending;
  definition.constructionAmend = constructionAmend;
  definition.blueprintAmend = blueprintAmend;

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
    return _.blueprint._amend
    ({
      blueprint,
      extension : definition.args,
      amending : definition.amending,
      blueprintAction : 'amend',
    });
  }

}

_amendment.defaults =
{
  amending : null,
  args : null,
}

//

function extension()
{
  return _.define._amendment({ args : arguments, amending : 'extend' });
}

//

function supplementation()
{
  return _.define._amendment({ args : arguments, amending : 'supplement' });
}

//

function _static( field )
{

  _.assert( arguments.length === 1 );

  let o = Object.create( null );
  o.value = field;
  o.definitionGroup = 'definition.named';
  o.name = null;

  let definition = new _.Definition( o );

  definition.kind = 'static';
  definition.constructionAmend = constructionAmend;
  definition.blueprintForm2 = blueprintForm2;

  Object.preventExtensions( definition );
  return definition;

  function constructionAmend( construction, key )
  {
    _.assert( 0, 'not implemented' ); /* zzz */
  }

  function blueprintForm2( blueprint, key )
  {
    let definition = this;
    blueprint.construct.prototype[ key ] = definition.value;
  }

}

//

function statics( fields )
{

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( fields ) || _.longIs( fields ), `Expects primitive or routine` );

  let o = Object.create( null );
  o.value = fields;
  o.definitionGroup = 'definition.named';
  o.name = null;

  let definition = new _.Definition( o );

  definition.kind = 'statics';
  definition.constructionAmend = constructionAmend;
  definition.blueprintForm2 = blueprintForm2;

  Object.preventExtensions( definition );
  return definition;

  function constructionAmend( construction, key )
  {
    _.assert( 0, 'not implemented' ); /* zzz */
  }

  function blueprintForm2( blueprint, key )
  {
    let definition = this;
    let fieldsArray = _.arrayAs( definition.value );

    for( let a = 0 ; a < fieldsArray.length ; a++ )
    {
      let fields = fieldsArray[ a ];
      _.assert( _.mapIs( fields ) );
      for( let f in fields )
      {
        let fieldValue = fieldsArray[ a ][ f ];
        blueprint.construct.prototype[ f ] = fieldValue;
      }
    }

  }

}

// --
// define
// --

let KnownFields =
{
  initialValueGet : 'routine::initialValueGet( map::o ) -> anything::',
  constructionAmend : 'routine::constructionAmend( Construction::construction primitive::key ) -> nothing::',
  blueprintAmend : 'routine::( map::o ) -> nothing::',
  blueprintForm1 : 'routine::( Blueprint::blueprint ) -> nothing::',
  blueprintForm2 : 'routine::( Blueprint::blueprint ) -> nothing::',
  blueprintForm3 : 'routine::( Blueprint::blueprint ) -> nothing::',
}

let BlueprintHandlers =
{
  blueprintAmend : 'routine::( map::o ) -> nothing::',
  blueprintForm1 : 'routine::( Blueprint::blueprint ) -> nothing::',
  blueprintForm2 : 'routine::( Blueprint::blueprint ) -> nothing::',
  blueprintForm3 : 'routine::( Blueprint::blueprint ) -> nothing::',
}

let ConstructionHandlers =
{
  constructionAmend : 'routine::constructionAmend( Construction::construction primitive::key ) -> nothing::',
  allocate : null,
  initBegin : null,
  initEnd : null,
}

//

/**
* Collection of definitions for constructions.
* @namespace "wTools.define"
* @augments wTools
* @memberof module:Tools/base/Proto
*/

let DefineExtension =
{

  field,
  shallow,

  _amendment,
  extension,
  supplementation,

  static : _static,
  statics,

}

_.define = _.define || Object.create( null );
_.mapExtend( _.define, DefineExtension );

//

/**
* Routines to manipulate definitions.
* @namespace "wTools.definition"
* @augments wTools
* @memberof module:Tools/base/Proto
*/

let DefinitionExtension =
{

  // routines
  is : _.definitionIs,
  _constructionAmendCant,
  _traitMake,

  // fields
  KnownFields,
  BlueprintHandlers,
  ConstructionHandlers,

}

_.definition = _.definition || Object.create( null );
_.mapExtend( _.definition, DefinitionExtension );
_.assert( _.routineIs( _.definitionIs ) );
_.assert( _.definition.is === _.definitionIs );

//

let ToolsExtension =
{
  Definition,
}

_.mapExtend( _, ToolsExtension );

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
