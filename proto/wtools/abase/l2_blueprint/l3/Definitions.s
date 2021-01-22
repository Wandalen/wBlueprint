( function _Definitions_s_()
{

'use strict';

let Self = _global_.wTools;
let _global = _global_;
let _ = _global_.wTools;

//

let PropOptionsLogic =
{
  order           : 0,
  // before          : null,
  // after           : null,
  blueprintDepthLimit : null,
  blueprintDepthReserve : 0,
}

let PropOptionsDescriptor =
{
  static          : 0,
  enumerable      : null,
  configurable    : null,
  writable        : null,
}

let PropOptionsMove =
{
  collection      : 'scalar',
  insToIns        : 'val',
  datToIns        : 'val',
  insToDat        : 'val',
  datToDat        : 'val',
  valToIns        : 'val',
  // relation        : null,
}

let PropOptionsAccessor =
{
  accessor        : null,
  methods         : null,
  storingStrategy : 'underscore',
  combining       : null,
  addingMethods   : null,
  // ... _.accessor.AmethodTypesMap,
}

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
  _.assert( args.length === 0 || args.length === 1 );
  _.assert( _.mapIs( o ) );

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

let _toVal = Object.create( null );
_toVal.val = function val( val ) { return val }
_toVal.shallow = function shallow( val ) { return _.entityMake( val ) }
_toVal.deep = function deep( val ) { return _.replicate({ src : val }) }
_toVal.call = function call( val ) { return val() }
_toVal.new = function nw( val ) { return new val() }

//

function prop_head( routine, args )
{
  let o = args[ 1 ];

  if( !o )
  o = { val : args[ 0 ] };
  else if( args[ 0 ] !== undefined )
  o.val = args[ 0 ];

  if( _.boolLike( o.accessor ) )
  o.accessor = !!o.accessor;

  o.accessor = _.accessor.suiteMove( o.accessor, o );

  o = _.routineOptions( routine, o );

  if( _.boolLike( o.writable ) )
  o.writable = !!o.writable;
  if( o.configurable === null )
  o.configurable = true;
  else
  o.configurable = !!o.configurable;

  if( o.enumerable === null )
  o.enumerable = !o.static;
  else
  o.enumerable = !!o.enumerable;

  if( o.static === null )
  o.static = false;
  else
  o.static = !!o.static;

  if( o.blueprintDepthLimit === null )
  o.blueprintDepthLimit = o.static ? 1 : 0;

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );
  _.assert( args[ 1 ] === undefined || _.mapIs( args[ 1 ] ) );

  _.assert( _.mapIs( o ) );

  _.assert( _.strIs( o.valToIns ) );
  _.assert( _.longHas( [ 'scalar', 'map', 'enumerable' ], o.collection ) );
  _.assert( 'scalar' === o.collection, 'not implemented' ); /* zzz : implement */
  _.assert( _.longHas( [ 'no', 'val', 'shallow', 'deep', 'call', 'new' ], o.valToIns ) );

  _.assert( o.collection === 'scalar', 'not implemented' );
  _.assert( o.insToIns === 'val', 'not implemented' );
  _.assert( o.datToIns === 'val', 'not implemented' );
  _.assert( o.insToDat === 'val', 'not implemented' );
  _.assert( o.datToDat === 'val', 'not implemented' );

  _.assert( o.blueprintDepthLimit >= 0 );
  _.assert( _.boolIs( o.writable ) || o.writable === null );
  _.assert( _.boolIs( o.configurable ) );
  _.assert( _.boolIs( o.enumerable ) );
  _.assert( _.boolIs( o.static ) );

  return o;
}

//

function prop_body( o )
{

  _.assertMapHasAll( o, prop_body.defaults );
  _.assert( o.val !== undefined );
  _.assert( o.blueprintDepthLimit >= 0 );
  _.assert( _.boolIs( o.writable ) || o.writable === null );
  _.assert( _.boolIs( o.configurable ) );
  _.assert( _.boolIs( o.enumerable ) );

  o.definitionGroup = 'definition.named';
  o.blueprintForm2 = blueprintForm2;
  o.blueprint = false;

  /* */

  let val = o.val;
  let toVal = o.toVal = _toVal[ o.valToIns ];
  let definition = _.definition._definitionMake( 'prop', o );
  _.assert( _.routineIs( toVal ), () => `Unknown toVal::${definition.valToIns} )` );

  /* */

  _.assert( !Object.isExtensible( definition ) );
  return definition;

  /* */

  function blueprintForm2( o )
  {
    let constructionInit = null;

    _.assert( _.strDefined( o.propName ) || _.strDefined( ext.name ) );
    _.assert( o.propName === null || definition.name === null || o.propName === definition.name );

    if( definition.name && definition.name !== o.propName )
    o.propName = definition.name;

    // if( _global_.debugger )
    // debugger;

    if( definition.static )
    {
      let o2 =
      {
        blueprint : o.blueprint,
        name : o.propName,
        amending : o.amending
        // val : definition.toVal( definition.val ),
      }
      if( optionsHasAccessor( definition ) )
      _declareStaticWithAccessor( o2 );
      else
      _declareStaticWithoutAccessor( o2 );
    }
    else
    {
      if( optionsHasAccessor( definition ) )
      {
        constructionInit = constructionInitAccessor_functor( o.blueprint, definition );
      }
      else if( definition.valToIns === 'val' && definition.enumerable && definition.configurable && ( definition.writable || definition.writable === null ) )
      {
        if( definition.val === _.nothing )
        o.blueprint.PropsSupplementation[ o.propName ] = undefined;
        else
        o.blueprint.PropsExtension[ o.propName ] = _.escape.undo( definition.val );
      }
      else if( definition.enumerable && definition.configurable && ( definition.writable || definition.writable === null ) )
      {
        constructionInit = constructionInitOrdinary_functor( o.blueprint, definition );
      }
      else
      {
        constructionInit = constructionInitUnordinary_functor( o.blueprint, definition );
      }
      if( constructionInit !== null )
      _.blueprint._routineAdd( o.blueprint, 'constructionInit', constructionInit );
    }

  }

  /* */

  function _declareStaticWithAccessor( o )
  {
    let prototype = o.blueprint.prototype;
    let name = o.name;
    let opts =
    {
      enumerable : definition.enumerable,
      configurable : definition.configurable,
    };

    _.assert( _.boolIs( definition.configurable ) );
    _.assert( _.boolIs( definition.enumerable ) );
    _.assert( !_.boolLikeFalse( definition.accessor ) );
    _.assert( !_.prototype._isStandardEntity( prototype ), 'Attempt to pollute _global_.Object.prototype' ); /* xxx : cover */

    if( _global_.debugger )
    debugger;

    let val2;
    if( o.amending === 'supplement' && prototype[ name ] !== undefined )
    val2 = prototype[ name ];
    else if( val === _.nothing )
    val2 = prototype[ name ];
    else
    val2 = definition.toVal( definition.val );

    let o2 =
    {
      name : o.name,
      object : prototype,
      methods : definition.methods,
      suite : definition.accessor,
      val : val2,
      storingStrategy : definition.storingStrategy,
      enumerable : definition.enumerable,
      configurable : definition.configurable,
      writable : definition.writable,
      combining : definition.combining,
      addingMethods : definition.addingMethods,
    }

    o2.needed = _.accessor._objectDeclaringIsNeeded( o2 );
    if( o2.needed )
    {
      _.accessor.suiteNormalize( o2 );
      for( let mname in _.accessor.AmethodTypesMap )
      if( o2.normalizedAsuite[ mname ] )
      o2.normalizedAsuite[ mname ] = _.routineJoin( prototype, o2.normalizedAsuite[ mname ] );
      _.accessor.declareSingle.body( o2 );
    }

    opts.get = () =>
    {
      return prototype[ name ];
    }

    if( definition.writable || definition.writable === null )
    {
      opts.set = ( src ) =>
      {
        prototype[ name ] = src;
      }
    }

    Object.defineProperty( o.blueprint.Make, name, opts );

    return o.blueprint;
  }

  /* */

  function _declareStaticWithoutAccessor( o )
  {
    let prototype = o.blueprint.prototype;
    let name = o.name;
    let opts =
    {
      enumerable : definition.enumerable,
      configurable : definition.configurable,
    };

    _.assert( _.boolIs( definition.configurable ) );
    _.assert( _.boolIs( definition.enumerable ) );
    _.assert( !_.prototype._isStandardEntity( prototype ), 'Attempt to pollute _global_.Object.prototype' );

    if( _global_.debugger )
    debugger;

    /* xxx : introduce option::preservingValue? */
    let val2;
    if( o.amending === 'supplement' && prototype[ name ] !== undefined )
    val2 = prototype[ name ];
    else if( definition.val === _.nothing )
    val2 = prototype[ name ];
    else
    val2 = definition.toVal( _.escape.undo( definition.val ) );

    if( definition.writable || definition.writable === null )
    {
      opts.get = () =>
      {
        return val2;
      }
      opts.set = ( src ) =>
      {
        val2 = src;
        return src;
      }
    }
    else
    {
      opts.writable = false;
      opts.value = val2;
    }
    Object.defineProperty( o.blueprint.Make, name, opts );
    Object.defineProperty( o.blueprint.prototype, name, opts );

    return o.blueprint;
  }

  /* */

  function constructionInitAccessor_functor( blueprint, definition )
  {
    const toVal = definition.toVal;
    const name = definition.name;
    const methods = definition.methods;
    const storingStrategy = definition.storingStrategy;
    const enumerable = definition.enumerable;
    const configurable = definition.configurable;
    const writable = definition.writable;
    const combining = definition.combining;
    const addingMethods = definition.addingMethods;
    const accessor = definition.accessor;
    const val = definition.val;
    const prototype = blueprint.prototype;

    let o2, normalizedAsuite;

    _.assert( _.fuzzyIs( blueprint.Typed ) );

    if( _global_.debugger )
    debugger;

    if( blueprint.Typed )
    {
      o2 = _.accessor.declareSingle
      ({
        name,
        object : blueprint.prototype,
        methods,
        suite : _.mapExtend( null, accessor ),
        storingStrategy,
        storageIniting : false,
        enumerable,
        configurable,
        writable,
        combining,
        addingMethods,
      });
      normalizedAsuite = o2.normalizedAsuite;
      _.accessor._objectInitStorage( blueprint.prototype, normalizedAsuite ); /* xxx : remove the call and introduce maybe extra option of declareSingle */
    }

    if( blueprint.Typed === true )
    return constructionInitTyped;
    else if( blueprint.Typed === false )
    return constructionInitUntyped;
    else if( blueprint.Typed === _.maybe )
    return constructionInitMaybe;
    else _.assert( 0 );

    function constructionInitTyped( genesis )
    {
      if( _global_.debugger )
      debugger;
      _.accessor._objectInitStorage( genesis.construction, normalizedAsuite );

      let val2;
      if( genesis.amending === 'supplement' && genesis.construction[ name ] !== undefined )
      val2 = genesis.construction[ name ];
      else if( val === _.nothing )
      val2 = genesis.construction[ name ];
      else
      val2 = toVal( val );

      if( val2 !== _.nothing )
      _.accessor._objectSetValue
      ({
        object : genesis.construction,
        normalizedAsuite,
        storingStrategy,
        name,
        val : val2,
      });
    }

    function constructionInitUntyped( genesis )
    {
      if( _global_.debugger )
      debugger;

      let val2;
      if( genesis.amending === 'supplement' && genesis.construction[ name ] !== undefined )
      val2 = genesis.construction[ name ];
      else if( val === _.nothing )
      val2 = genesis.construction[ name ];
      else
      val2 = toVal( val );

      _.accessor.declareSingle
      ({
        object : genesis.construction,
        methods,
        suite : _.mapExtend( null, accessor ),
        storingStrategy,
        name,
        val : val2,
        enumerable,
        configurable,
        writable,
        combining,
        addingMethods,
      });
    }

    function constructionInitMaybe( genesis )
    {
      let prototype2 = Object.getPrototypeOf( genesis.construction );
      if( prototype2 === prototype )
      {
        constructionInitTyped( genesis );
      }
      else
      {
        constructionInitUntyped( genesis );
      }
    }

  }

  /* */

  function constructionInitOrdinary_functor( blueprint, definition )
  {
    const toVal = definition.toVal;
    const name = definition.name;
    const val = _.escape.undo( definition.val );
    return function constructionInit( genesis )
    {
      if( _global_.debugger )
      debugger;
      if( genesis.amending === 'supplement' && genesis.construction[ name ] !== undefined )
      genesis.construction[ name ] = genesis.construction[ name ];
      /* it is important to set. property could be owned by prototype */
      else if( val === _.nothing )
      genesis.construction[ name ] = genesis.construction[ name ];
      /* it is important to set. property could be owned by prototype */
      else
      genesis.construction[ name ] = toVal( val );
    }
  }

  /* */

  function constructionInitUnordinary_functor( blueprint, definition )
  {
    const enumerable = definition.enumerable;
    const configurable = definition.configurable;
    const writable = definition.writable === null ? true : definition.writable;
    const toVal = definition.toVal;
    const name = definition.name;
    const val = _.escape.undo( definition.val );
    return function constructionInit( genesis )
    {
      const opts =
      {
        enumerable,
        configurable,
        writable,
      };
      if( genesis.amending === 'supplement' && genesis.construction[ name ] !== undefined )
      opts.value = genesis.construction[ name ];
      else if( val === _.nothing )
      opts.value = genesis.construction[ name ];
      else
      opts.value = toVal( val );
      Object.defineProperty( genesis.construction, name, opts );
    }
  }

  /* */

  // function valFor( o2 )
  // {
  //   let val2;
  //   if( o2.amending === 'supplement' && o2.construction[ name ] !== undefined )
  //   val2 = o2.construction[ name ];
  //   else if( o2.val === _.nothing )
  //   val2 = o2.construction[ name ];
  //   else
  //   val2 = toVal( o2.val );
  //   return val2
  // }

  /* */

  function optionsHasAccessor( op )
  {
    return !!op.accessor;
  }

  /* */

}

prop_body.defaults =
{

  name            : null,
  val             : _.nothing,

  ... PropOptionsLogic,
  /*
  order           : 0,
  // before          : null,
  // after           : null,
  blueprintDepthLimit : null,
  blueprintDepthReserve : 0,
  */

  ... PropOptionsDescriptor,
  /*
  static          : 0,
  enumerable      : null,
  configurable    : null,
  writable        : null,
  */

  ... PropOptionsMove,
  /*
  collection      : 'scalar',
  insToIns        : 'val',
  datToIns        : 'val',
  insToDat        : 'val',
  datToDat        : 'val',
  valToIns        : 'val',
  // relation        : null,
  */

  ... PropOptionsAccessor,
  /*
  accessor        : null,
  methods         : null,
  storingStrategy : 'underscore',
  // grab            : null,
  // get             : null,
  // put             : null,
  // set             : null,
  */

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
toVal   : routine                                                                                   @default : null
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

function nothing_body( o )
{

  _.assertRoutineOptions( nothing_body, arguments );
  o.definitionGroup = 'definition.unnamed';
  // o.constructionAmend = constructionAmend;
  o.blueprintAmend = blueprintAmend;
  o.blueprint = false;

  let definition = _.definition._definitionMake( 'nothing', o );

  _.assert( definition.amending === o.amending );

  Object.freeze( definition );
  return definition;

  // function constructionAmend( construction, key )
  // {
  // }

  function blueprintAmend( op )
  {
  }

}

nothing_body.defaults =
{
  ... PropOptionsLogic,
  blueprintDepthReserve : -1,
  blueprintDepthLimit : 1,
}

let nothing = _.routineUnite( _singleArgumentHead, nothing_body );

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
  // o.constructionAmend = constructionAmend;
  o.blueprintAmend = blueprintAmend;
  o.blueprint = false;

  let definition = _.definition._definitionMake( 'amend', o );

  _.assert( definition.amending === o.amending );

  Object.freeze( definition );
  return definition;

  // function constructionAmend( construction, key )
  // {
  //   _.assert( 0, 'not implemented' ); /* zzz */
  // }

  function blueprintAmend( op )
  {
    let definition = this;
    let blueprint = op.blueprint;

    return _.blueprint._amend
    ({
      ... op,
      extension : definition.val,
      amending : op.amending === 'extend' ? definition.amending : op.amending, /* zzz : cover? */
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
  blueprintDepthLimit : 1, /* yyy */
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

  // result.push( _.trait.prototype( o.val ) );
  // if( !o.val.Traits.typed )
  // result.push( _.trait.typed() );

  // debugger;
  if( o.val.Traits.typed )
  {
    result.push( _.trait.typed( o.val.Traits.typed.val, { prototype : o.val } ) );
  }
  else
  {
    result.push( _.trait.typed( true, { prototype : o.val } ) );
  }

  // result.push( _.trait.typed( true, { prototype : o.val } ) );

  return result;
}

inherit.defaults =
{
  val : null,
}

//

function _constant_functor() /* xxx : test with blueprint? */
{
  let prototype = Object.create( null );
  prototype.definitionGroup = 'definition.named';
  prototype.subKind = 'constant';
  prototype.asAccessorSuite = asAccessorSuite;
  prototype.toVal = toVal;
  _.property.hide( prototype, 'asAccessorSuite' );
  _.property.hide( prototype, 'toVal' );
  // _.property.hide( prototype, 'constructionAmend' );
  _.definition.retype( prototype );
  Object.freeze( prototype );

  _constant.defaults =
  {
    val : null,
  }

  return _constant;

  /* */

  function _constant( val )
  {
    let o = Object.create( prototype );
    o.val = val;
    _.assert( arguments.length === 1 );
    _.assert( o.val !== undefined );
    return o;
  }

  /* */

  function asAccessorSuite( op )
  {
    _.assert( _.definitionIs( op.amethod ) );
    return { get : op.amethod, set : false, put : false };
  }

  /* */

  function toVal( val )
  {
    _.assert( val !== undefined );
    return val;
  }

  /* */

}

let _constant = _constant_functor();

//

function alias_head( routine, args )
{
  let o = args[ 0 ];

  if( !_.mapIs( args[ 0 ] ) )
  o = { originalName : args[ 0 ] };

  _.assert( args.length === 1 );

  return _.define.prop.head( routine, [ undefined, o ] );
}

function alias_body( o )
{

  _.assertRoutineOptions( alias_body, arguments );

  let originalContainer = o.originalContainer;
  let originalName = o.originalName;

  _.assert( originalContainer === null || !!originalContainer );
  _.assert( _.strDefined( originalName ) );
  _.assert( o.val === undefined );
  _.assert( o.accessor === null || _.boolLikeTrue( o.accessor ) || _.mapIs( o.accessor ) );

  if( !_.mapIs( o.accessor ) )
  o.accessor = Object.create( null );

  if( originalContainer === null )
  {
    let accessor2 = { grab : selfGet, get : selfGet, put : selfSet, set : selfSet }
    _.accessor.suiteSupplement( o.accessor, accessor2 );
  }
  else
  {
    let accessor2 = { grab : get, get, put : set, set }
    _.accessor.suiteSupplement( o.accessor, accessor2 );
  }

  o.val = _.nothing;
  _.mapSupplement( o, _.define.prop.defaults );
  let definition = _.define.prop.body( o );
  return definition;

  /* */

  function get()
  {
    return originalContainer[ originalName ];
  }

  function set( src )
  {
    originalContainer[ originalName ] = src;
    return originalContainer[ originalName ];
  }

  function selfGet()
  {
    return this[ originalName ];
  }

  function selfSet( src )
  {
    this[ originalName ] = src;
    return this[ originalName ];
  }

}

alias_body.defaults =
{
  ... _.mapBut( prop.defaults, { methods : null, val : null } ),
  originalContainer : null,
  originalName : null,
}

let alias = _.routineUnite( alias_head, alias_body );
_.routineEr( alias );

// --
//
// --

let DefinitionExtension =
{
  PropOptionsLogic,
  PropOptionsDescriptor,
  PropOptionsMove,
  PropOptionsAccessor,
}

_.mapExtend( _.definition, DefinitionExtension );

let BlueprintExtension =
{

  _singleArgumentHead,
  _pairArgumentsHead,
  _toVal,

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

  nothing,

  _amendment,
  extension,
  supplementation,
  inherit,

  constant : _constant,
  // alias,
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
