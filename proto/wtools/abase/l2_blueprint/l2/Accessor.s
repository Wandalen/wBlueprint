( function _Accessor_s_() {

'use strict';

let Self = _global_.wTools;
let _global = _global_;
let _ = _global_.wTools;

/**
 * @summary Collection of routines for declaring accessors
 * @namespace wTools.accessor
 * @extends Tools
 * @module Tools/base/Proto
 */

// --
// fields
// --

/**
 * Accessor defaults
 * @typedef {Object} AccessorDefaults
 * @property {Boolean} [ strict=1 ]
 * @property {Boolean} [ preservingValue=1 ]
 * @property {Boolean} [ prime=1 ]
 * @property {String} [ combining=null ]
 * @property {Boolean} [ writable=true ]
 * @property {Boolean} [ readOnlyProduct=0 ]
 * @property {Boolean} [ enumerable=1 ]
 * @property {Boolean} [ configurable=0 ]
 * @property {Function} [ getter=null ]
 * @property {Function} [ graber=null ]
 * @property {Function} [ setter=null ]
 * @property {Function} [ suite=null ]
 * @namespace Tools.accessor
 **/

let Combining = [ 'rewrite', 'supplement', 'apppend', 'prepend' ];
let AccessorType = [ 'grab', 'get', 'put', 'set', 'move' ];

let AsuiteFields =
{
  grab : null,
  get : null,
  put : null,
  set : null,
  move : null,
}

let AccessorTypeMap =
{
  grab : null,
  get : null,
  put : null,
  set : null,
  move : null,
  suite : null,
}

let AccessorDefaults =
{

  ... AccessorTypeMap,
  suite : null,

  strict : 1, /* zzz : deprecated */
  preservingValue : null,
  prime : null,
  combining : null,
  addingMethods : null,
  enumerable : null,
  configurable : null,
  writable : null,

  // readOnly : 0, /* yyy : use writable instead */
  // readOnlyProduct : 0,

}

let AccessorPreferences =
{

  ... AccessorTypeMap,
  suite : null,

  strict : 1,
  preservingValue : 1,
  prime : null,
  combining : null,
  addingMethods : 0,
  enumerable : 1,
  configurable : 0,
  writable : 1,

  // writable : 1,
  // readOnlyProduct : 0,

}

// --
// getter / setter generator
// --

function _propertyGetterSetterNames( propertyName )
{
  let result = Object.create( null );

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( propertyName ) );

  result.grab = '_' + propertyName + 'Grab';
  result.get = '_' + propertyName + 'Get';
  result.put = '_' + propertyName + 'Put';
  result.set = '_' + propertyName + 'Set';
  result.move = '_' + propertyName + 'Move';

  /* zzz : use it? */

  return result;
}

//

function _optionsNormalize( o )
{

  _.assert( arguments.length === 1 );

  optionNormalize( 'grab' );
  optionNormalize( 'get' );
  optionNormalize( 'put' );
  optionNormalize( 'set' );

  function optionNormalize( n1 )
  {
    if( _.boolLike( o[ n1 ] ) )
    o[ n1 ] = !!o[ n1 ];
  }

}

//

function _asuiteForm( o )
{
  let result = o.asuite;

  _.assert( arguments.length === 1 );
  _.assert( o.methods === null || !_.primitiveIs( o.methods ) );
  _.assert( _.strIs( o.name ) || _.symbolIs( o.name ) );
  _.assert( _.mapIs( o.asuite ) );
  _.assertMapHasOnly( o.asuite, _.accessor.AsuiteFields );
  _.assertRoutineOptions( _asuiteForm, o );

  let fieldName;
  let fieldSymbol;
  if( _.symbolIs( o.name ) )
  {
    fieldName = Symbol.keyFor( o.name );
    fieldSymbol = o.name;
  }
  else
  {
    fieldName = o.name;
    fieldSymbol = Symbol.for( o.name );
  }

  if( o.suite )
  _.assertMapHasOnly( o.suite, _.accessor.AccessorType );

  for( let k in o.asuite, _.accessor.AsuiteFields )
  methodNormalize( k );

  /* grab */

  if( !result.grab || result.grab === true )
  if( o.asuite.grab === null || o.asuite.grab === true || o.asuite.grab === 1 )
  {
    if( result.move )
    result.grab = function grab()
    {
      let it = _.accessor._moveItMake
      ({
        srcInstance : this,
        instanceKey : fieldName,
        accessorKind : 'grab',
      });
      result.move.call( this, it );
      return it.value;
    }
    else if( _.routineIs( result.get ) )
    result.grab = result.get;
    else
    result.grab = function grab()
    {
      return this[ fieldSymbol ];
    }
  }

  /* get */

  if( !result.get || result.get === true )
  if( o.asuite.get === null || o.asuite.get === true || o.asuite.get === 1 )
  {
    if( result.move )
    result.get = function get()
    {
      let it = _.accessor._moveItMake
      ({
        srcInstance : this,
        instanceKey : fieldName,
        accessorKind : 'get',
      });
      result.move.call( this, it );
      return it.value;
    }
    else if( _.routineIs( result.grab ) )
    result.get = result.grab;
    else
    result.get = function get()
    {
      return this[ fieldSymbol ];
    }
  }

  /* put */

  if( !result.put || result.put === true )
  if( o.asuite.put === null || o.asuite.put === true || o.asuite.put === 1 )
  {
    if( result.move )
    result.put = function put( src )
    {
      let it = _.accessor._moveItMake
      ({
        dstInstance : this,
        instanceKey : fieldName,
        value : src,
        accessorKind : 'put',
      });
      result.move.call( this, it );
      return it.value;
    }
    else if( _.routineIs( result.set ) )
    result.put = result.set;
    else
    result.put = function put( src )
    {
      this[ fieldSymbol ] = src;
      return src;
    }
  }

  /* set */

  if( !result.set || result.set === true )
  if( o.asuite.set === null || o.asuite.set === true || o.asuite.set === 1 )
  {
    if( result.move )
    result.set = function set( src )
    {
      let it = _.accessor._moveItMake
      ({
        dstInstance : this,
        instanceKey : fieldName,
        value : src,
        accessorKind : 'set',
      });
      result.move.call( this, it );
      return it.value;
    }
    else if( _.routineIs( result.put ) )
    result.set = result.put;
    else if( o.asuite.put !== false || o.asuite.set )
    result.set = function set( src )
    {
      this[ fieldSymbol ] = src;
      return src;
    }
    else
    o.asuite.set = false;
  }

  /* move */

  if( !result.move || result.move === true )
  {
    if( o.asuite.move === true || o.asuite.move === 1 )
    {
      result.move = function move( it )
      {
        _.assert( 0, 'not tested' ); /* xxx */
        debugger;
        return it.src;
      }
    }
    else
    {
      result.move = false;
    }
  }

  // /* readOnlyProduct */
  //
  // if( o.readOnlyProduct && result.get )
  // {
  //   let get = result.get;
  //   result.get = function get()
  //   {
  //     debugger;
  //     let result = get.apply( this, arguments );
  //     if( !_.primitiveIs( result ) )
  //     result = _.proxyReadOnly( result );
  //     return result;
  //   }
  // }

  /* validation */

  if( Config.debug )
  {
    for( let k in AsuiteFields )
    _.assert
    (
      _.definitionIs( result[ k ] ) || _.routineIs( result[ k ] ) || result[ k ] === false,
      () => `Field "${fieldName}" is not read only, but setter not found ${_.toStrShort( o.methods )}`
    );
  }

  return result;

  /* */

  function methodNormalize( name )
  {
    let capitalName = _.strCapitalize( name );
    _.assert( o.asuite[ name ] === null || _.boolLike( o.asuite[ name ] ) || _.routineIs( o.asuite[ name ] ) || _.definitionIs( o.asuite[ name ] ) );
    if( o.asuite[ name ] !== false && o.asuite[ name ] !== 0 )
    {
      if( _.routineIs( o.asuite[ name ] ) || _.definitionIs( o.asuite[ name ] ) )
      result[ name ] = o.asuite[ name ];
      else if( o.suite && ( _.routineIs( o.suite[ name ] ) || _.definitionIs( o.suite[ name ] ) ) )
      result[ name ] = o.suite[ name ];
      else if( o.methods && o.methods[ '' + fieldName + capitalName ] )
      result[ name ] = o.methods[ fieldName + capitalName ];
      else if( o.methods && o.methods[ '_' + fieldName + capitalName ] )
      result[ name ] = o.methods[ '_' + fieldName + capitalName ];
      else if( o.methods && o.methods[ '__' + fieldName + capitalName ] )
      result[ name ] = o.methods[ '__' + fieldName + capitalName ];
    }
  }

  /* */

}

_asuiteForm.defaults =
{
  suite : null,
  asuite : null,
  methods : null,
  name : null,
}

//

function _asuiteUnfunct( o )
{

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o.asuite ) );
  _.assertRoutineOptions( _asuiteUnfunct, arguments );

  resultUnfunct( 'grab' );
  resultUnfunct( 'get' );
  resultUnfunct( 'put' );
  resultUnfunct( 'set' );
  resultUnfunct( 'move' );

  return o.asuite;

  /* */

  function resultUnfunct( kind )
  {
    _.assert( _.primitiveIs( kind ) );
    if( !o.asuite[ kind ] )
    return;
    let amethod = o.asuite[ kind ];
    let r = _.accessor._amethodUnfunct
    ({
      amethod,
      kind,
      accessor : o.accessor,
      withDefinition : o.withDefinition,
      withFunctor : o.withFunctor,
    });
    o.asuite[ kind ] = r;
    return r;
  }

}

var defaults = _asuiteUnfunct.defaults =
{
  accessor : null,
  asuite : null,
  withDefinition : false,
  withFunctor : true,
}

//

function _amethodUnfunct( o )
{

  _.assert( arguments.length === 1 );
  if( !o.amethod )
  return o.amethod;

  if( o.withFunctor && o.amethod.identity && _.longHas( o.amethod.identity, 'functor' ) )
  {
    let o2 = Object.create( null );
    if( o.amethod.defaults )
    {
      if( o.amethod.defaults.fieldName !== undefined )
      o2.fieldName = o.accessor.name;
      if( o.amethod.defaults.accessor !== undefined )
      o2.accessor = o.accessor;
      if( o.amethod.defaults.accessorKind !== undefined )
      o2.accessorKind = o.kind;
    }
    o.amethod = o.amethod( o2 );
  }
  // else if( o.withDefinition && _.definitionIs( o.amethod ) )
  // {
  //   _.assert( _.routineIs( o.amethod.valueGenerate ) );
  //   _.assert( o.amethod.val !== undefined );
  //   o.amethod = o.amethod.valueGenerate( o.amethod.val );
  // }
  // xxx

  _.assert( o.amethod !== undefined );
  return o.amethod;
}

_amethodUnfunct.defaults =
{
  amethod : null,
  accessor : null,
  kind : null,
  withDefinition : false,
  withFunctor : true,
}

//

function _objectMethodsNamesGet( o )
{

  _.routineOptions( _objectMethodsNamesGet, o );

  if( o.anames === null )
  o.anames = Object.create( null );

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o.asuite ) );
  _.assert( _.strIs( o.name ) );
  _.assert( !!o.object );

  for( let t = 0 ; t < _.accessor.AccessorType.length ; t++ )
  {
    let type = _.accessor.AccessorType[ t ];
    if( o.asuite[ type ] && !o.anames[ type ] )
    {
      let type2 = _.strCapitalize( type );
      if( o.object[ o.name + type2 ] === o.asuite[ type ] )
      o.anames[ type ] = o.name + type2;
      else if( o.object[ '_' + o.name + type2 ] === o.asuite[ type ] )
      o.anames[ type ] = '_' + o.name + type2;
      else
      o.anames[ type ] = o.name + type2;
    }
  }

  return o.anames;
}

_objectMethodsNamesGet.defaults =
{
  object : null,
  asuite : null,
  anames : null,
  name : null,
}

//

function _objectMethodsGet( object, propertyName )
{
  let result = Object.create( null );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.objectIs( object ) );
  _.assert( _.strIs( propertyName ) );

  result.grabName = object[ propertyName + 'Grab' ] ? propertyName + 'Grab' : '_' + propertyName + 'Grab';
  result.getName = object[ propertyName + 'Get' ] ? propertyName + 'Get' : '_' + propertyName + 'Get';
  result.putName = object[ propertyName + 'Put' ] ? propertyName + 'Put' : '_' + propertyName + 'Put';
  result.setName = object[ propertyName + 'Set' ] ? propertyName + 'Set' : '_' + propertyName + 'Set';
  result.moveName = object[ propertyName + 'Move' ] ? propertyName + 'Move' : '_' + propertyName + 'Move';

  result.grab = object[ result.grabName ];
  result.get = object[ result.getName ];
  result.set = object[ result.setName ];
  result.put = object[ result.putName ];
  result.move = object[ result.moveName ];

  return result;
}

//

function _objectMethodsValidate( o )
{

  if( !Config.debug )
  return true;

  _.assert( _.strIs( o.name ) || _.symbolIs( o.name ) );
  _.assert( !!o.object );
  _.routineOptions( _objectMethodsValidate, o );

  if( _.symbolIs( o.name ) )
  debugger;

  let name = _.symbolIs( o.name ) ? Symbol.keyFor( o.name ) : o.name;
  let AccessorType = _.accessor.AccessorType; /* yyy : ? */
  // let AccessorType = [ 'get', 'set' ];

  for( let t = 0 ; t < AccessorType.length ; t++ )
  {
    let type = AccessorType[ t ];
    if( !o.asuite[ type ] )
    {
      let name1 = name + _.strCapitalize( type );
      let name2 = '_' + name + _.strCapitalize( type );
      let name3 = '__' + name + _.strCapitalize( type );
      if( name1 in o.object )
      throw _.err( `Object should not have method ${name1}, if accessor has it disabled` );
      if( name2 in o.object )
      throw _.err( `Object should not have method ${name2}, if accessor has it disabled` );
      if( name3 in o.object )
      throw _.err( `Object should not have method ${name2}, if accessor has it disabled` );
    }
  }

  return true;
}

_objectMethodsValidate.defaults =
{
  object : null,
  asuite : null,
  name : null,
}

//

function _objectMethodMoveGet( srcInstance, name )
{
  _.assert( arguments.length === 2 );
  _.assert( _.strIs( name ) );

  if( !_.instanceIs( srcInstance ) )
  return null;

  if( srcInstance[ name + 'Move' ] )
  return srcInstance[ name + 'Move' ];
  else if( srcInstance[ '_' + name + 'Move' ] )
  return srcInstance[ '_' + name + 'Move' ];
  else if( srcInstance[ '__' + name + 'Move' ] )
  return srcInstance[ '__' + name + 'Move' ];

  return null;
}

//

function _moveItMake( o )
{
  return _.routineOptions( _moveItMake, arguments );
}

_moveItMake.defaults =
{
  dstInstance : null,
  srcInstance : null,
  instanceKey : null,
  srcContainer : null,
  dstContainer : null,
  containerKey : null,
  accessorKind : null,
  value : null,
}

//

function _objectPreserveValue( o )
{

  _.assertRoutineOptions( _objectPreserveValue, o );

  if( Object.hasOwnProperty.call( o.object, o.name ) )
  {
    if( o.asuite.put )
    o.asuite.put.call( o.object, o.object[ o.name ] );
    else
    o.object[ o.fieldSymbol ] = o.object[ o.name ];
  }

}

_objectPreserveValue.defaults =
{
  object : null,
  name : null,
  fieldSymbol : null,
  asuite : null,
}

//

function _objectAddMethods( o )
{

  _.assertRoutineOptions( _objectAddMethods, o );

  for( let n in o.asuite )
  {
    if( o.asuite[ n ] )
    Object.defineProperty( o.object, o.anames[ n ],
    {
      value : o.asuite[ n ],
      enumerable : false,
      writable : true,
      configurable : true,
    });
    // o.object[ o.anames[ n ] ] = o.asuite[ n ];
  }

}

_objectAddMethods.defaults =
{
  object : null,
  asuite : null,
  anames : null,
}


// --
// declare
// --

/**
 * Registers provided accessor.
 * Writes accessor's descriptor into accessors map of the prototype ( o.proto ).
 * Supports several combining methods: `rewrite`, `supplement`, `append`.
 *  * Adds diagnostic information to descriptor if running in debug mode.
 * @param {Object} o - options map
 * @param {String} o.name - accessor's name
 * @param {Object} o.proto - target prototype object
 * @param {String} o.declaratorName
 * @param {Array} o.declaratorArgs
 * @param {String} o.declaratorKind
 * @param {String} o.combining - combining method
 * @private
 * @function _register
 * @namespace Tools.accessor
 */

function _register( o )
{

  _.routineOptions( _register, arguments );
  _.assert( _.strDefined( o.declaratorName ) );
  _.assert( _.arrayIs( o.declaratorArgs ) );

  return descriptor;
}

_register.defaults =
{
  name : null,
  proto : null,
  declaratorName : null,
  declaratorArgs : null,
  declaratorKind : null,
  combining : 0,
}

//

function declareSingle_head( routine, args )
{

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );
  let o = _.routineOptions( routine, args );
  _.assert( !_.primitiveIs( o.object ), 'Expects object as argument but got', o.object );
  _.assert( _.strIs( o.name ) || _.symbolIs( o.name ) );
  _.assert( _.longHas( [ null, 0, false, 'rewrite', 'supplement' ], o.combining ), 'not tested' );

  return o;
}

function declareSingle_body( o )
{

  _.assertRoutineOptions( declareSingle_body, arguments );
  _.assert( arguments.length === 1 );
  _.assert( _.boolLike( o.writable ) || o.writable === null );

  _.accessor._optionsNormalize( o );

  let fieldName;
  let fieldSymbol;
  if( _.symbolIs( o.name ) )
  {
    fieldName = Symbol.keyFor( o.name );
    fieldSymbol = o.name;
  }
  else
  {
    fieldName = o.name;
    fieldSymbol = Symbol.for( o.name );
  }

  /* */

  if( !needed() )
  return false;

  /* */

  o.suite = _.accessor._amethodUnfunct
  ({
    amethod : o.suite,
    accessor : o,
    kind : 'suite',
    withDefinition : true,
    withFunctor : true,
  });

  o.asuite = _.accessor._asuiteForm
  ({
    name : o.name,
    methods : o.methods,
    suite : o.suite,
    asuite :
    {
      grab : o.grab,
      get : o.get,
      put : o.put,
      set : o.writable || o.writable === null ? o.set : false, /* xxx */
      move : o.move,
    },
  });

  o.asuite = _.accessor._asuiteUnfunct
  ({
    accessor : o,
    asuite : o.asuite,
    withDefinition : false,
    withFunctor : true,
  });

  if( o.writable === null )
  o.writable = !!o.asuite.set;
  _.assert( _.boolLike( o.writable ) );

  defaultsApply();

  let anames;
  if( o.prime || o.addingMethods )
  anames = _.accessor._objectMethodsNamesGet
  ({
    object : o.object,
    asuite : o.asuite,
    name : o.name,
  })

  /* */

  if( o.prime )
  register();

  /* preservingValue */

  if( o.preservingValue )
  _.accessor._objectPreserveValue
  ({
    object : o.object,
    name : o.name,
    asuite : o.asuite,
    fieldSymbol,
  });

  /* addingMethods */

  if( o.addingMethods )
  _.accessor._objectAddMethods
  ({
    object : o.object,
    asuite : o.asuite,
    anames,
  });

  /* define accessor */

  _.assert( o.asuite.get === false || _.routineIs( o.asuite.get ) || _.definitionIs( o.asuite.get ) );
  _.assert( o.asuite.set === false || _.routineIs( o.asuite.set ) );

  _.property.declare.body
  ({
    object : o.object,
    name : o.name,
    enumerable : !!o.enumerable,
    configurable : !!o.configurable,
    writable : !!o.writable,
    get : o.asuite.get,
    set : o.asuite.set,
  });

  /* validate */

  if( Config.debug )
  validate();

  return o;

  /* - */

  function needed()
  {
    let propertyDescriptor = _.prototype.propertyDescriptorActiveGet( o.object, o.name );
    if( propertyDescriptor.descriptor )
    {

      _.assert
      (
        _.strIs( o.combining ), () =>
          `Option::overriding of property ${o.name}`
        + ` supposed to be any of ${_.accessor.Combining }`
        + ` but it is ${o.combining}`
      );
      _.assert( o.combining === 'rewrite' || o.combining === 'append' || o.combining === 'supplement', 'not implemented' );

      if( o.combining === 'supplement' )
      return false;

      _.assert( propertyDescriptor.object !== o.object, () => `Attempt to redefine own accessor "${o.name}" of ${_.toStrShort( o.object )}` );

    }
    return true;
  }

  /* */

  function validate()
  {
    _.accessor._objectMethodsValidate({ object : o.object, name : o.name, asuite : o.asuite });
  }

  /* */

  function defaultsApply()
  {

    if( o.prime === null )
    o.prime = !!_.workpiece && _.workpiece.prototypeIsStandard( o.object );

    for( let k in o )
    {
      if( o[ k ] === null && _.boolLike( _.accessor.AccessorPreferences[ k ] ) )
      o[ k ] = _.accessor.AccessorPreferences[ k ];
    }

    _.assert( _.boolLike( o.prime ) );
    _.assert( _.boolLike( o.configurable ) );
    _.assert( _.boolLike( o.enumerable ) );
    _.assert( _.boolLike( o.addingMethods ) );
    _.assert( _.boolLike( o.preservingValue ) );

  }

  /* */

  function register()
  {

    let o2 = _.mapExtend( null, o );
    o2.names = o.name;
    o2.methods = Object.create( null );
    o2.object = null;
    delete o2.name;
    delete o2.asuite;

    for( let k in o.asuite )
    if( o.asuite[ k ] )
    o2.methods[ anames[ k ] ] = o.asuite[ k ];

    _.accessor._register
    ({
      proto : o.object,
      name : o.name,
      declaratorName : 'accessor',
      declaratorArgs : [ o2 ],
      combining : o.combining,
    });

  }

  /* */

}

var defaults = declareSingle_body.defaults =
{
  ... AccessorDefaults,
  name : null,
  object : null,
  methods : null,
}

let declareSingle = _.routineUnite( declareSingle_head, declareSingle_body );

//

/**
 * Accessor options
 * @typedef {Object} AccessorOptions
 * @property {Object} [ object=null ] - source object wich properties will get getter/setter defined.
 * @property {Object} [ names=null ] - map that that contains names of fields for wich function defines setter/getter.
 * Function uses values( rawName ) of object( o.names ) properties to check if fields of( o.object ) have setter/getter.
 * Example : if( rawName ) is 'a', function searchs for '_aSet' or 'aSet' and same for getter.
 * @property {Object} [ methods=null ] - object where function searchs for existing setter/getter of property.
 * @property {Array} [ message=null ] - setter/getter prints this message when called.
 * @property {Boolean} [ strict=true ] - makes object field private if no getter defined but object must have own constructor.
 * @property {Boolean} [ enumerable=true ] - sets property descriptor enumerable option.
 * @property {Boolean} [ preservingValue=true ] - saves values of existing object properties.
 * @property {Boolean} [ prime=true ]
 * @property {String} [ combining=null ]
 * @property {Boolean} [ writable=true ] - if false function doesn't define setter to property.
 * @property {Boolean} [ configurable=false ]
 * @property {Function} [ get=null ]
 * @property {Function} [ set=null ]
 * @property {Function} [ suite=null ]
 *
 * @namespace Tools.accessor
 **/

/**
 * Defines set/get functions on source object( o.object ) properties if they dont have them.
 * If property specified by( o.names ) doesn't exist on source( o.object ) function creates it.
 * If ( o.object.constructor.prototype ) has property with getter defined function forbids set/get access
 * to object( o.object ) property. Field can be accessed by use of Symbol.for( rawName ) function,
 * where( rawName ) is value of property from( o.names ) object.
 *
 * Can be called in three ways:
 * - First by passing all options in one object( o );
 * - Second by passing ( object ) and ( names ) options;
 * - Third by passing ( object ), ( names ) and ( message ) option as third parameter.
 *
 * @param {Object} o - options {@link module:Tools/base/Proto.wTools.accessor~AccessorOptions}.
 *
 * @example
 * let Self = ClassName;
function ClassName( o ) { };
 * _.accessor.declare( Self, { a : 'a' }, 'set/get call' )
 * Self.a = 1; // set/get call
 * Self.a;
 * // returns
 * // set/get call
 * // 1
 *
 * @throws {exception} If( o.object ) is not a Object.
 * @throws {exception} If( o.names ) is not a Object.
 * @throws {exception} If( o.methods ) is not a Object.
 * @throws {exception} If( o.message ) is not a Array.
 * @throws {exception} If( o ) is extented by unknown property.
 * @throws {exception} If( o.strict ) is true and object doesn't have own constructor.
 * @throws {exception} If( o.writable ) is false and property has own setter.
 * @function declare
 * @namespace Tools.accessor
 */

function declareMultiple_head( routine, args )
{
  let o;

  _.assert( arguments.length === 2 );

  if( args.length === 1 )
  {
    o = args[ 0 ];
  }
  else
  {
    o = Object.create( null );
    o.object = args[ 0 ];
    o.names = args[ 1 ];
    _.assert( args.length >= 2 );
  }

  if( args.length > 2 )
  {
    _.assert( o.messages === null || o.messages === undefined );
    o.message = _.longSlice( args, 2 );
  }

  if( _.strIs( o.names ) )
  o.names = { [ o.names ] : o.names }

  _.routineOptions( routine, o );

  // if( o.writable === null )
  // o.writable = true;

  _.assert( !_.primitiveIs( o.object ), 'Expects object as argument but got', o.object );
  _.assert( _.objectIs( o.names ) || _.arrayIs( o.names ), 'Expects object names as argument but got', o.names );

  return o;
}

function declareMultiple_body( o )
{

  _.assertRoutineOptions( declareMultiple_body, arguments );

  if( _.arrayLike( o.object ) )
  {
    _.each( o.object, ( object ) =>
    {
      let o2 = _.mapExtend( null, o );
      o2.object = object;
      declareMultiple_body( o2 );
    });
    return o.object;
  }

  if( !o.methods )
  o.methods = o.object;

  /* verification */

  _.assert( !_.primitiveIs( o.methods ) );
  _.assert( !_.primitiveIs( o.object ), () => 'Expects object {-object-}, but got ' + _.toStrShort( o.object ) );
  _.assert( _.objectIs( o.names ), () => 'Expects object {-names-}, but got ' + _.toStrShort( o.names ) );

  /* */

  let result = Object.create( null );
  for( let name in o.names )
  result[ name ] = declare( name, o.names[ name ] );

  let names2 = Object.getOwnPropertySymbols( o.names );
  for( let n = 0 ; n < names2.length ; n++ )
  result[ names2[ n ] ] = declare( names2[ n ], o.names[ names2[ n ] ],  );

  return result;

  /* */

  function declare( name, extension )
  {
    let o2 = Object.assign( Object.create( null ), o );

    if( _.mapIs( extension ) )
    {
      _.assertMapHasOnly( extension, _.accessor.AccessorDefaults );
      _.mapExtend( o2, extension );
      _.assert( !!o2.object );
    }
    else if( _.definitionIs( extension ) )
    {
      o2.suite = extension;
    }
    // yyy xxx
    // else if( _.definitionIs( extension ) && extension.subKind === 'constant' )
    // {
    //   _.mapExtend( o2, { get : extension, set : false, put : false } );
    // }
    else if( _.routineIs( extension ) && extension.identity && _.longHas( extension.identity, 'functor' ) )
    {
      _.mapExtend( o2, { suite : extension } );
    }
    else _.assert( name === extension, `Unexpected type ${_.strType( extension )}` );

    o2.name = name;
    delete o2.names;

    return _.accessor.declareSingle.body( o2 );
  }

}

var defaults = declareMultiple_body.defaults = _.mapExtend( null, declareSingle.defaults );
defaults.names = null;
delete defaults.name;

let declareMultiple = _.routineUnite( declareMultiple_head, declareMultiple_body );

//

/**
 * @summary Declares forbid accessor.
 * @description
 * Forbid accessor throws an Error when user tries to get value of the property.
 * @param {Object} o - options {@link module:Tools/base/Proto.wTools.accessor~AccessorOptions}.
 *
 * @example
 * let Self = ClassName;
function ClassName( o ) { };
 * _.accessor.forbid( Self, { a : 'a' } )
 * Self.a; // throw an Error
 *
 * @function forbid
 * @namespace Tools.accessor
 */

function forbid_body( o )
{

  _.assertRoutineOptions( forbid_body, arguments );

  if( !o.methods )
  o.methods = Object.create( null );

  if( _.arrayLike( o.object ) )
  {
    debugger;
    _.each( o.object, ( object ) =>
    {
      let o2 = _.mapExtend( null, o );
      o2.object = object;
      forbid_body( o2 );
    });
    debugger;
    return o.object;
  }

  if( _.objectIs( o.names ) )
  o.names = _.mapExtend( null, o.names );

  if( o.prime === null )
  o.prime = !!_.workpiece && _.workpiece.prototypeIsStandard( o.object );

  /* verification */

  _.assert( !_.primitiveIs( o.object ), () => 'Expects object {-o.object-} but got ' + _.toStrShort( o.object ) );
  _.assert( _.objectIs( o.names ) || _.arrayIs( o.names ), () => 'Expects object {-o.names-} as argument but got ' + _.toStrShort( o.names ) );

  /* message */

  let _constructor = o.object.constructor || null;
  _.assert( _.routineIs( _constructor ) || _constructor === null );
  if( !o.protoName )
  o.protoName = ( _constructor ? ( _constructor.name || _constructor._name || '' ) : '' ) + '.';
  if( !o.message )
  o.message = 'is deprecated';
  else
  o.message = _.arrayIs( o.message ) ? o.message.join( ' : ' ) : o.message;

  /* property */

  if( _.objectIs( o.names ) )
  {
    let result = Object.create( null );

    for( let n in o.names )
    {
      let name = o.names[ n ];
      let o2 = _.mapExtend( null, o );
      o2.fieldName = name;
      _.assert( n === name, () => 'Key and value should be the same, but ' + _.strQuote( n ) + ' and ' + _.strQuote( name ) + ' are not' );
      let declared = _.accessor._forbidSingle( o2 );
      if( declared )
      result[ name ] = declared;
      else
      delete o.names[ name ];
    }

    return result;
  }
  else
  {
    let result = [];
    let namesArray = o.names;

    o.names = Object.create( null );
    for( let n = 0 ; n < namesArray.length ; n++ )
    {
      let name = namesArray[ n ];
      let o2 = _.mapExtend( null, o );
      o2.fieldName = name;
      let delcared = _.accessor._forbidSingle( o2 );
      if( declared )
      {
        o.names[ name ] = declared;
        result.push( declared );
      }
    }

    return result;
  }

}

var defaults = forbid_body.defaults =
{

  ... declareMultiple.body.defaults,

  preservingValue : 0,
  enumerable : 0,
  combining : 'rewrite',
  message : null,

  prime : 0,
  strict : 0,

}

let forbid = _.routineUnite( declareMultiple_head, forbid_body );

//

function _forbidSingle()
{
  let o = _.routineOptions( _forbidSingle, arguments );
  let messageLine = o.protoName + o.fieldName + ' : ' + o.message;

  _.assert( _.strIs( o.protoName ) );
  _.assert( _.objectIs( o.methods ) );

  /* */

  let propertyDescriptor = _.prototype.propertyDescriptorActiveGet( o.object, o.fieldName );
  if( propertyDescriptor.descriptor )
  {
    _.assert( _.strIs( o.combining ), 'forbid : if accessor overided expect ( o.combining ) is', _.accessor.Combining.join() );

    if( _.routineIs( propertyDescriptor.descriptor.get ) && propertyDescriptor.descriptor.get.name === 'forbidden' )
    {
      return false;
    }

  }

  /* */

  if( !Object.isExtensible( o.object ) )
  {
    return false;
  }

  o.methods = null;
  o.suite = Object.create( null );
  o.suite.grab = forbidden;
  o.suite.get = forbidden;
  o.suite.put = forbidden;
  o.suite.set = forbidden;
  forbidden.isForbid = true;

  /* */

  if( o.prime )
  {

    _.assert( 0, 'not tested' );
    let o2 = _.mapExtend( null, o );
    o2.names = o.fieldName;
    o2.object = null;
    delete o2.protoName;
    delete o2.fieldName;

    _.accessor._register
    ({
      proto : o.object,
      name : o.fieldName,
      declaratorName : 'forbid',
      declaratorArgs : [ o2 ],
      combining : o.combining,
    });

  }

  _.assert( !o.strict );
  _.assert( !o.prime );

  o.strict = 0;
  o.prime = 0;

  let o2 = _.mapOnly( o, _.accessor.declare.body.defaults );
  o2.name = o.fieldName;
  delete o2.names;
  return _.accessor.declareSingle.body( o2 );

  /* */

  function forbidden()
  {
    debugger;
    throw _.err( messageLine );
  }

}

var defaults = _forbidSingle.defaults =
{
  ... forbid.defaults,
  fieldName : null,
  protoName : null,
}

//

/**
 * Checks if source object( object ) has own property( name ) and its forbidden.
 * @param {Object} object - source object
 * @param {String} name - name of the property
 *
 * @example
 * let Self = ClassName;
function ClassName( o ) { };
 * _.accessor.forbid( Self, { a : 'a' } );
 * _.accessor.ownForbid( Self, 'a' ) // returns true
 * _.accessor.ownForbid( Self, 'b' ) // returns false
 *
 * @function ownForbid
 * @namespace Tools.accessor
 */

function ownForbid( object, name )
{
  if( !Object.hasOwnProperty.call( object, name ) )
  return false;

  let descriptor = Object.getOwnPropertyDescriptor( object, name );
  if( _.routineIs( descriptor.get ) && descriptor.get.isForbid )
  {
    return true;
  }
  else
  {
    return false;
  }

}

// --
// etc
// --

/**
 * @summary Declares read-only accessor( s ).
 * @description Expects two arguments: (object), (names) or single as options map {@link module:Tools/base/Proto.wTools.accessor~AccessorOptions}
 *
 * @param {Object} object - target object
 * @param {Object} names - contains names of properties that will get read-only accessor
 *
 * @example
 * var Alpha = function _Alpha(){}
 * _.classDeclare
 * ({
 *   cls : Alpha,
 *   parent : null,
 *   extend : { Composes : { a : null } }
 * });
 * _.accessor.readOnly( Alpha.prototype,{ a : 'a' });
 *
 * @function forbid
 * @namespace Tools.accessor
 */

function readOnly_body( o )
{
  _.assertRoutineOptions( readOnly_body, arguments );
  _.assert( _.boolLikeFalse( o.writable ) );
  return _.accessor.declare.body( o );
}

var defaults = readOnly_body.defaults = _.mapExtend( null, declareMultiple.body.defaults );
defaults.writable = false;
// defaults.readOnly = true;

let readOnly = _.routineUnite( declareMultiple_head, readOnly_body );

//

let AccessorExtension =
{

  // getter / setter generator

  _propertyGetterSetterNames,
  _optionsNormalize,
  _asuiteForm,
  _asuiteUnfunct,
  _amethodUnfunct,
  _objectMethodsNamesGet,
  _objectMethodsGet,
  _objectMethodsValidate,
  _objectMethodMoveGet,

  _objectPreserveValue,
  _objectAddMethods,

  _moveItMake,

  // declare

  _register,
  declareSingle,
  declareMultiple,
  declare : declareMultiple,

  // forbid

  forbid,
  _forbidSingle,
  ownForbid,

  // etc

  readOnly,

  // fields

  Combining,
  AccessorType,
  AsuiteFields,
  AccessorTypeMap,
  AccessorDefaults,
  AccessorPreferences,

}

//

let ToolsExtension =
{
}

// --
// extend
// --

_.accessor = _.accessor || Object.create( null );
_.mapSupplement( _, ToolsExtension );
_.mapExtend( _.accessor, AccessorExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
