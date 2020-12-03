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

function _staticBlueprintForm( o )
{
  _.assertRoutineOptions( _staticBlueprintForm, o );
  _.assert( _.objectIs( o.blueprint.prototype ) );
  _.assert( _.routineIs( o.blueprint.Make ) );

  let val = o.val;
  let prototype = o.blueprint.prototype;
  let make = o.blueprint.Make;
  let opts =
  {
    get : () => val,
    set : ( src ) =>
    {
      val = src;
      return src;
    },
    enumerable : true,
    configurable : true,
  };
  if( _.routineIs( val ) )
  opts.enumerable = false;
  Object.defineProperty( o.blueprint.Make, o.key, opts );
  Object.defineProperty( o.blueprint.prototype, o.key, opts );

  return o.blueprint;
}

_staticBlueprintForm.defaults =
{
  blueprint : null,
  key : null,
  val : null,
}

//

let _valueGenerate = Object.create( null );
_valueGenerate.val = function get() { return this.val }
_valueGenerate.shallow = function get() { return _.entityMake( this.val ) }
_valueGenerate.deep = function get() { return _.replicate({ src : this.val }) }
_valueGenerate.call = function get() { return this.val() }
_valueGenerate.new = function get() { return new this.val() }

//

function prop_head( routine, args )
{
  let o = _pairArgumentshead( ... arguments );

  _.assert( _.mapIs( o ) );
  _.assert( o.val !== undefined );

  if( o.blueprintDepthLimit === null )
  o.blueprintDepthLimit = o.static ? 1 : 0

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
  _.assert( o.blueprintDepthLimit >= 0 );

  o.definitionGroup = 'definition.named';
  o.blueprintForm2 = blueprintForm2;
  o.constructionInit = null;

  let definition = new _.Definition( o );
  let val = definition.val;

  /* */

  let valueGenerate = definition.valueGenerate = _valueGenerate[ o.valToIns ];
  _.assert( _.routineIs( valueGenerate ), () => `Unknown valToIns::${o.valToIns}` );

  /* */

  Object.preventExtensions( definition );
  return definition;

  /* */

  function blueprintForm2( blueprint, name )
  {
    let handlers = blueprint._InternalRoutinesMap.constructionInit = blueprint._InternalRoutinesMap.constructionInit || [];

    _.assert( _.strDefined( name ) || _.strDefined( ext.name ) );
    _.assert( name === null || definition.name === null || name === definition.name );

    if( definition.name && definition.name !== name )
    name = definition.name;

    _.assert( definition.constructionInit === null );
    _.assert( _.strDefined( definition.name ) );

    if( o.static )
    {
      _.blueprint._staticBlueprintForm
      ({
        blueprint,
        key : name,
        val : definition.valueGenerate(),
      });
    }
    else
    {
      if( o.valToIns === 'val' )
      {
        blueprint.Props[ name ] = definition.val;
      }
      else
      {
        definition.constructionInit = function( genesis )
        {
          genesis.construction[ this.name ] = valueGenerate.call( this );
        }
      }
      if( definition.constructionInit !== null )
      {
        handlers.push({ constructionInit : definition.constructionInit, name : definition.name, val })
        definition.constructionInit.meta =
        {
          extenral : { val },
        }
      }
    }
  }

}

prop_body.defaults =
{

  order           : 0,
  before          : null,
  after           : null,
  static          : 0,
  // enumerable      : 1,
  // configurable    : 1,
  // writable        : 1,

  collection      : 'scalar',
  insToIns        : 'val',
  datToIns        : 'val',
  insToDat        : 'val',
  datToDat        : 'val',
  valToIns        : 'val',
  val             : null,
  name            : null,
  // relation        : null,

  blueprintDepthLimit : null,
  blueprintDepthReserve : 0,

}

let prop = _.routineUnite( prop_head, prop_body );

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
  o = { val : arguments[ 0 ] };
  _.routineOptions( inherit, o );
  _.assert( _.blueprint.is( o.val ) );
  let result = [];
  result.push( _.define.extension( o.val ) );
  result.push( _.trait.prototype( o.val ) );
  if( o.val.Traits.typed )
  result.push( _.trait.typed({ typed : o.val.Traits.typed.typed, withConstructor : o.val.Traits.typed.withConstructor }) );
  else
  result.push( _.trait.typed() );
  return result;
}

inherit.defaults =
{
  val : null,
}

// --
//
// --

let BlueprintExtension =
{

  _pairArgumentshead,
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

}

_.define = _.define || Object.create( null );
_.mapExtend( _.define, DefineExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
