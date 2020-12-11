( function _Definitions_s_() {

'use strict';

let Self = _global_.wTools;
let _global = _global_;
let _ = _global_.wTools;

// --
// collection
// --

function _singleArgumentHead( routine, args )
{
  let o = args[ 0 ];
  if( !o )
  o = Object.create( null );

  o = _.routineOptions( routine, o );

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );
  _.assert( _.mapIs( args[ 0 ] ) );

  return o;
}

//

function _pairArgumentsHead( routine, args )
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

function _staticBlueprintForm( o )
{
  _.assertRoutineOptions( _staticBlueprintForm, o );
  _.assert( _.objectIs( o.blueprint.prototype ) );
  _.assert( _.routineIs( o.blueprint.Make ) );

  if( o.writable === null )
  o.writable = true;
  if( o.configurable === null )
  o.configurable = true;
  if( o.enumerable === null )
  o.enumerable = false;

  let val = o.val;
  let prototype = o.blueprint.prototype;
  let make = o.blueprint.Make;
  let opts =
  {
    enumerable : o.enumerable,
    configurable : o.configurable,
  };

  if( o.writable )
  {
    opts.get = () =>
    {
      return val;
    }
    opts.set = ( src ) =>
    {
      val = src;
      return src;
    }
  }
  else
  {
    opts.writable = false;
    opts.value = val;
  }

  Object.defineProperty( o.blueprint.Make, o.name, opts );
  Object.defineProperty( o.blueprint.prototype, o.name, opts );

  return o.blueprint;
}

_staticBlueprintForm.defaults =
{

  blueprint : null,
  name : null,
  val : null,

  enumerable      : null,
  configurable    : null,
  writable        : null,

}

//

let _valueGenerate = Object.create( null );
_valueGenerate.val = function val( val ) { return val }
_valueGenerate.shallow = function shallow( val ) { return _.entityMake( val ) }
_valueGenerate.deep = function deep( val ) { return _.replicate({ src : val }) }
_valueGenerate.call = function call( val ) { return val() }
_valueGenerate.new = function nw( val ) { return new val() }

//

function prop_head( routine, args )
{
  let o = _pairArgumentsHead( ... arguments );

  _.assert( _.mapIs( o ) );
  _.assert( o.val !== undefined );

  _.assert( _.strIs( o.valToIns ) );
  _.assert( _.longHas( [ 'scalar', 'map', 'enumerable' ], o.collection ) );
  _.assert( 'scalar' === o.collection, 'not implemented' ); /* zzz : implement */
  _.assert( _.longHas( [ 'val' , 'shallow' , 'deep' , 'call' , 'new' ], o.valToIns ) );
  _.assert( o.val !== undefined );

  _.assert( o.collection === 'scalar', 'not implemented' );
  _.assert( o.insToIns === 'val', 'not implemented' );
  _.assert( o.datToIns === 'val', 'not implemented' );
  _.assert( o.insToDat === 'val', 'not implemented' );
  _.assert( o.datToDat === 'val', 'not implemented' );

  return o;
}

function prop_body( o )
{

  o = _.assertRoutineOptions( prop_body, arguments );

  if( o.blueprintDepthLimit === null )
  o.blueprintDepthLimit = o.static ? 1 : 0

  if( o.writable === null )
  o.writable = true;
  else
  o.writable = !!o.writable;
  if( o.configurable === null )
  o.configurable = true;
  else
  o.configurable = !!o.configurable;
  if( o.enumerable === null )
  o.enumerable = !o.static;
  else
  o.enumerable = !!o.enumerable;

  o.definitionGroup = 'definition.named';
  o.blueprintForm2 = blueprintForm2;

  o.blueprint = false;

  /* */

  _.assert( o.blueprintDepthLimit >= 0 );
  _.assert( _.boolIs( o.writable ) );
  _.assert( _.boolIs( o.configurable ) );
  _.assert( _.boolIs( o.enumerable ) );

  /* */

  let val = o.val;
  let valueGenerate = o.valueGenerate = _valueGenerate[ o.valToIns ];
  let definition = _.definition._definitionMake( 'prop', o );
  _.assert( _.routineIs( valueGenerate ), () => `Unknown valToIns::${definition.valToIns}` );

  /* */

  // Object.preventExtensions( definition );
  _.assert( !Object.isExtensible( definition ) );
  return definition;

  /* */

  function blueprintForm2( blueprint, name )
  {
    let constructionInit = null;

    _.assert( _.strDefined( name ) || _.strDefined( ext.name ) );
    _.assert( name === null || definition.name === null || name === definition.name );

    if( definition.name && definition.name !== name )
    name = definition.name;

    if( definition.static )
    {
      _.blueprint._staticBlueprintForm
      ({
        blueprint,
        name,
        val : definition.valueGenerate( definition.val ),
        enumerable : definition.enumerable,
        configurable : definition.configurable,
        writable : definition.writable,
      });
    }
    else
    {
      if( definition.valToIns === 'val' && definition.enumerable && definition.configurable && definition.writable )
      blueprint.Props[ name ] = definition.val;
      else if( definition.enumerable && definition.configurable && definition.writable )
      constructionInit = constructionInitOrdinary_functor( definition );
      else
      constructionInit = constructionInitVal_functor( definition );
      if( constructionInit !== null )
      _.blueprint._routineAdd( blueprint, 'constructionInit', constructionInit );
    }
  }

  /* */

  function constructionInitOrdinary_functor( definition )
  {
    let valueGenerate = definition.valueGenerate;
    let name = definition.name;
    let val = definition.val;
    return function constructionInit( genesis )
    {
      genesis.construction[ name ] = valueGenerate( val );
    }
  }

  /* */

  function constructionInitVal_functor( definition )
  {
    let enumerable = definition.enumerable;
    let configurable = definition.configurable;
    let writable = definition.writable;
    let valueGenerate = definition.valueGenerate;
    let name = definition.name;
    let val = definition.val;
    return function constructionInit( genesis )
    {
      let opts =
      {
        value : valueGenerate( val ),
        enumerable,
        configurable,
        writable,
      };
      Object.defineProperty( genesis.construction, name, opts );
    }
  }

  /* */

}

prop_body.defaults =
{

  order           : 0,
  before          : null,
  after           : null,

  static          : 0,
  enumerable      : null,
  configurable    : null,
  writable        : null,

  collection      : 'scalar',
  insToIns        : 'val',
  datToIns        : 'val',
  insToDat        : 'val',
  datToDat        : 'val',
  valToIns        : 'val',
  val             : null,
  name            : null,
  // relation        : null,

  accessor        : null,
  // grab            : null,
  // get             : null,
  // put             : null,
  // set             : null,

  blueprintDepthLimit : null,
  blueprintDepthReserve : 0,

}

let prop = _.routineUnite( prop_head, prop_body );
_.routineEr( prop, _singleArgumentHead );

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
valToIns        : [ val , shallow , deep , call , new ]                                                     @default : val
relation        : [ null , composes , aggregates , associates , restricts , medials , statics , copiers ]   @default : null
val             : *                                                                                         @default : null
*/

//

function props_body( o )
{
  let self = this;

  if( _.longIs( o.val ) )
  {
    return _.map_( o.val, ( e ) => mapEach( e ) );
  }
  else
  {
    return mapEach( o.val );
  }

  function mapEach( map )
  {
    _.assert( _.mapIs( map ) );
    let r = _.map_( map, ( e, k ) =>
    {
      let o2 = _.mapExtend( null, o );
      o2.val = e;
      _.assert( o2.name === null );
      o2.name = k;
      let r = _.define.prop.body.call( self, o2 );
      _.assert( r.name === k );
      return r;
    });
    r = _.mapVals( r );
    return r;
  }

}

props_body.defaults =
{
  ... prop.defaults,
}

let props = _.routineUnite( prop_head, props_body );
_.routineEr( props, _singleArgumentHead );

//

function val_body( o )
{
  return _.define.prop.body.call( this, o );
}

val_body.defaults =
{
  ... prop.defaults,
  valToIns : 'val',
}

let val = _.routineUnite( prop_head, val_body );
_.routineEr( val, _singleArgumentHead );

//

function vals_body( o )
{
  return _.define.props.body.call( this, o );
}

vals_body.defaults =
{
  ... prop.defaults,
  valToIns : 'val',
}

let vals = _.routineUnite( prop_head, vals_body );
_.routineEr( vals, _singleArgumentHead );

//

function shallow_body( o )
{
  return _.define.prop.body.call( this, o );
}

shallow_body.defaults =
{
  ... prop.defaults,
  valToIns : 'shallow',
}

let shallow = _.routineUnite( prop_head, shallow_body );
_.routineEr( shallow, _singleArgumentHead );

//

function shallows_body( o )
{
  return _.define.props.body.call( this, o );
}

shallows_body.defaults =
{
  ... prop.defaults,
  valToIns : 'shallow',
}

let shallows = _.routineUnite( prop_head, shallows_body );
_.routineEr( shallows, _singleArgumentHead );

//

function deep_body( o )
{
  return _.define.prop.body.call( this, o );
}

deep_body.defaults =
{
  ... prop.defaults,
  valToIns : 'deep',
}

let deep = _.routineUnite( prop_head, deep_body );
_.routineEr( deep, _singleArgumentHead );

//

function deeps_body( o )
{
  return _.define.props.body.call( this, o );
}

deeps_body.defaults =
{
  ... prop.defaults,
  valToIns : 'deep',
}

let deeps = _.routineUnite( prop_head, deeps_body );
_.routineEr( deeps, _singleArgumentHead );

//

function call_body( o )
{
  return _.define.prop.body.call( this, o );
}

call_body.defaults =
{
  ... prop.defaults,
  valToIns : 'call',
}

let call = _.routineUnite( prop_head, call_body );
_.routineEr( call, _singleArgumentHead );

//

function calls_body( o )
{
  return _.define.props.body.call( this, o );
}

calls_body.defaults =
{
  ... prop.defaults,
  valToIns : 'call',
}

let calls = _.routineUnite( prop_head, calls_body );
_.routineEr( calls, _singleArgumentHead );

//

function new_body( o )
{
  return _.define.prop.body.call( this, o );
}

new_body.defaults =
{
  ... prop.defaults,
  valToIns : 'new',
}

let _new = _.routineUnite( prop_head, new_body );
_.routineEr( _new, _singleArgumentHead );

//

function news_body( o )
{
  return _.define.props.body.call( this, o );
}

news_body.defaults =
{
  ... prop.defaults,
  valToIns : 'new',
}

let _news = _.routineUnite( prop_head, news_body );
_.routineEr( _news, _singleArgumentHead );

//

function static_body( o )
{
  return _.define.prop.body.call( this, o );
}

static_body.defaults =
{
  ... prop.defaults,
  static : 1,
}

let _static = _.routineUnite( prop_head, static_body );
_.routineEr( _static, _singleArgumentHead );

//

function statics_body( o )
{
  return _.define.props.body.call( this, o );
}

statics_body.defaults =
{
  ... prop.defaults,
  static : 1,
}

let _statics = _.routineUnite( prop_head, statics_body );
_.routineEr( _statics, _singleArgumentHead );

//

function _amendment_head( routine, args )
{
  let o = _pairArgumentsHead( ... arguments );
  _.assert( _.longHas( [ 'extend', 'supplement' ], o.amending ) );
  return o;
}

function _amendment_body( o )
{

  _.assertRoutineOptions( _amendment_body, arguments );
  _.assert( _.objectIs( o.val ) );
  _.assert( _.blueprintIsDefinitive( o.val ) );

  o.definitionGroup = 'definition.unnamed';
  o.constructionAmend = constructionAmend;
  o.blueprintAmend = blueprintAmend;
  o.blueprint = false;

  let definition = _.definition._definitionMake( o.amending, o );

  _.assert( definition.amending === o.amending );

  Object.freeze( definition );
  return definition;

  function constructionAmend( construction, key )
  {
    _.assert( 0, 'not implemented' ); /* zzz */
  }

  function blueprintAmend( op )
  {
    let definition = this;
    let blueprint = op.blueprint;
    if( op.blueprintDepth )
    return;
    return _.blueprint._amend
    ({
      ... op,
      extension : definition.val,
      amending : definition.amending,
      // amending : op.amending, /* zzz : ? */
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

let extension = _.routineUnite( _amendment_head, _amendment_body );

extension.defaults =
{
  ... _amendment.defaults,
  amending : 'extend',
}

_.routineEr( extension, _singleArgumentHead );

//

let supplementation = _.routineUnite( _amendment_head, _amendment_body );

supplementation.defaults =
{
  ... _amendment.defaults,
  amending : 'supplement',
}

_.routineEr( supplementation, _singleArgumentHead );

//

function inherit( o )
{
  if( !_.mapIs( o ) )
  o = { val : arguments[ 0 ] };
  _.routineOptions( inherit, o );
  _.assert( _.blueprint.isDefinitive( o.val ) );
  let result = [];
  result.push( _.define.extension( o.val ) );
  result.push( _.trait.prototype( o.val ) );

  if( !o.val.Traits.typed )
  result.push( _.trait.typed() );

  return result;
}

inherit.defaults =
{
  val : null,
}

//

function alias_body( o ) /* xxx */
{

  _.assertRoutineOptions( alias_body, arguments );

  o.definitionGroup = 'definition.named';
  o.constructionAmend = constructionAmend;
  o.blueprintForm2 = blueprintForm2;
  o.blueprint = false;

  let originalContainer = o.originalContainer;
  let originalName = o.originalName;

  _.assert( originalContainer === null || !!originalContainer );
  _.assert( _.strDefined( originalName ) );

  let definition = _.definition._definitionMake( o.amending, o );
  Object.freeze( definition );
  return definition;

  function constructionInit( genesis )
  {
    let originalContainer2 = originalContainer || genesis.construction;

    Object.defineProperty( o.blueprint.Make, o.name, opts );

    debugger;
    _.assert( 0, 'not implemented' ); /* zzz */
  }

  function constructionAmend( construction, key )
  {
    _.assert( 0, 'not implemented' ); /* zzz */
  }

  function blueprintForm2( blueprint, name )
  {
    let definition = this;
    blueprint = op.blueprint;
    _.blueprint._routineAdd( blueprint, 'constructionInit', constructionInit );
  }

}

alias_body.defaults =
{
  originalContainer : null,
  originalName : null,
}

let alias = _.routineUnite( _singleArgumentHead, alias_body );
_.routineEr( alias );

// --
//
// --

let BlueprintExtension =
{

  _singleArgumentHead,
  _pairArgumentsHead,
  _staticBlueprintForm,
  _valueGenerate,

}

_.blueprint = _.blueprint || Object.create( null );
_.mapExtend( _.blueprint, BlueprintExtension );

let DefineExtension =
{

  prop,
  props,
  val,
  vals,
  shallow,
  shallows,
  deep,
  deeps,
  call,
  calls,
  new : _new,
  news : _news,
  static : _static,
  statics : _statics,

  _amendment,
  extension,
  supplementation,
  inherit,

  alias,

}

_.define = _.define || Object.create( null );
_.mapExtend( _.define, DefineExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
