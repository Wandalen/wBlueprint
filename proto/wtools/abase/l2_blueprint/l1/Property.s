( function _Property_s_() {

'use strict';

let Self = _global_.wTools;
let _global = _global_;
let _ = _global_.wTools;

// --
// implementation
// --

/**
 * @summary Defines hidden property with name( name ) and value( value ) on target object( dstPrototype ).
 *
 * @description
 * Property is defined as not enumarable.
 * Also accepts second argument as map of properties.
 * If second argument( name ) is a map and third argument( value ) is also defined, then all properties will have value of last arg.
 *
 * @param {Object} dstPrototype - target object
 * @param {String|Object} name - name of property or map of names
 * @param {*} value - destination object
 *
 * @throws {Exception} If number of arguments is not supported.
 * @throws {Exception} If dstPrototype is not an Object
 * @function hide
 *
 * @namespace Tools.property
 * @module Tools/base/Proto
 */

function hide( dstPrototype, name, value )
{

  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( !_.primitiveIs( dstPrototype ), () => 'dstPrototype is needed, but got ' + _.toStrShort( dstPrototype ) );

  if( _.containerIs( name ) )
  {
    if( !_.objectIs( name ) )
    debugger;
    if( !_.objectIs( name ) )
    name = _.indexExtending( name, ( e ) => { return { [ e ] : undefined } } );
    _.each( name, ( v, n ) =>
    {
      if( value !== undefined )
      _.property.hide( dstPrototype, n, value );
      else
      _.property.hide( dstPrototype, n, v );
    });
    return;
  }

  if( value === undefined )
  value = dstPrototype[ name ];

  _.assert( _.strIs( name ), 'name is needed, but got', name );

  Object.defineProperty( dstPrototype, name,
  {
    value,
    enumerable : false,
    writable : true,
    configurable : true,
  });

}

//

/**
 * Makes constants properties on object by creating new or replacing existing properties.
 * @param {object} dstPrototype - prototype of class which will get new constant property.
 * @param {object} namesObject - name/value map of constants.
 *
 * @example
 * let Self = ClassName;
function ClassName( o ) { };
 * let Constants = { num : 100  };
 * _.property.constant( Self.prototype, Constants );
 * console.log( Self.prototype ); // returns { num: 100 }
 * Self.prototype.num = 1;// error assign to read only property
 *
 * @function constant
 * @throws {exception} If no argument provided.
 * @throws {exception} If( dstPrototype ) is not a Object.
 * @throws {exception} If( name ) is not a Map.
 * @namespace Tools.property
 * @module Tools/base/Proto
 */

function _constant( dstPrototype, name, value )
{

  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( !_.primitiveIs( dstPrototype ), () => 'dstPrototype is needed, but got ' + _.toStrShort( dstPrototype ) );

  if( _.containerIs( name ) )
  {
    if( !_.objectIs( name ) )
    debugger;
    if( !_.objectIs( name ) )
    name = _.indexExtending( name, ( e ) => { return { [ e ] : undefined } } );
    _.each( name, ( v, n ) =>
    {
      if( value !== undefined )
      _.property.constant( dstPrototype, n, value );
      else
      _.property.constant( dstPrototype, n, v );
    });
    return;
  }

  if( value === undefined )
  value = dstPrototype[ name ];

  _.assert( _.strIs( name ), 'name is needed, but got', name );

  Object.defineProperty( dstPrototype, name,
  {
    value,
    enumerable : true,
    writable : false,
    configurable : false,
  });

}

//

function declare_head( routine, args )
{

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );

  if( args.length === 2 )
  {
    o = args[ 1 ];
    _.assert( !o.object );
    o.object = args[ 0 ];
  }
  else
  {
    o = args[ 0 ];
  }

  _.routineOptions( routine, o );
  _.assert( !_.primitiveIs( o.object ), 'Expects object as argument but got', o.object );
  _.assert( _.strIs( o.name ) || _.symbolIs( o.name ) );

  return o;
}

//

function declare_body( o )
{

  // if( o.name === 'qualifiedName' && o.object[ 'qualifiedName' ] !== undefined )
  // debugger;

  if( _.definitionIs( o.get ) )
  {
    _.assert( _.routineIs( o.get.valueGenerate ) );
    _.assert( o.get.val !== undefined );
    o.get = o.get.valueGenerate( o.get.val );
    // o.get = o.get.val; /* xxx */
  }

  _.assert( _.boolIs( o.enumerable ) );
  _.assert( _.boolIs( o.configurable ) );
  _.assert( _.boolIs( o.writable ) );

  let o2 =
  {
    enumerable : !!o.enumerable,
    configurable : !!o.configurable,
  }

  if( o.get === false )
  {
    if( o.set )
    o2.set = o.set;
  }
  else if( _.routineIs( o.get ) )
  {
    if( o.set )
    o2.set = o.set;
    o2.get = o.get;
  }
  else
  {
    _.assert( o.set === false );
    o2.value = o.get;
    o2.writable = !!o.writable;
  }

  _.assert( !o.writable || o.set !== false );
  _.assert( o.writable || !o.set );

  Object.defineProperty( o.object, o.name, o2 );
}

declare_body.defaults =
{
  object : null,
  name : null,
  enumerable : null,
  configurable : null,
  writable : null,
  get : null,
  set : null,
}

let declare = _.routineUnite( declare_head, declare_body );
_.routineEr( declare ); /* qqq : cover */

// --
// define
// --

let PropertyExtension =
{

  hide,
  constant : _constant,
  declare,

}

/* xxx : introduce namespace _.property in module::Tools */
_.property = _.property || Object.create( null );
_.mapExtend( _.property, PropertyExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
