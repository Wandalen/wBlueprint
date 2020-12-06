( function _Proto_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../wtools/Tools.s' );
  _.include( 'wTesting' );
  require( '../../abase/l2_blueprint/Include.s' );
}

let _global = _global_;
let _ = _global_.wTools;

// --
// test
// --

function instanceIs( t )
{
  var self = this;

  t.will = 'pure map';
  t.true( !_.instanceIs( Object.create( null ) ) );

  t.will = 'map';
  t.true( !_.instanceIs( {} ) );

  t.will = 'primitive';
  t.true( !_.instanceIs( 0 ) );
  t.true( !_.instanceIs( 1 ) );
  t.true( !_.instanceIs( '1' ) );
  t.true( !_.instanceIs( null ) );
  t.true( !_.instanceIs( undefined ) );

  t.will = 'routine';
  t.true( !_.instanceIs( Date ) );
  t.true( !_.instanceIs( F32x ) );
  t.true( !_.instanceIs( function(){} ) );
  t.true( !_.instanceIs( Self.constructor ) );

  t.will = 'long';
  t.true( _.instanceIs( [] ) );
  t.true( _.instanceIs( new F32x() ) );

  t.will = 'object-like';
  t.true( _.instanceIs( /x/ ) );
  t.true( _.instanceIs( new Date() ) );
  t.true( _.instanceIs( new (function(){})() ) );
  t.true( _.instanceIs( Self ) );

  t.will = 'object-like prototype';
  t.true( !_.instanceIs( Object.getPrototypeOf( [] ) ) );
  t.true( !_.instanceIs( Object.getPrototypeOf( /x/ ) ) );
  t.true( !_.instanceIs( Object.getPrototypeOf( new Date() ) ) );
  t.true( !_.instanceIs( Object.getPrototypeOf( new F32x() ) ) );
  t.true( !_.instanceIs( Object.getPrototypeOf( new (function(){})() ) ) );
  t.true( !_.instanceIs( Object.getPrototypeOf( Self ) ) );

}

//

function prototypeIs( t )
{
  var self = this;

  t.will = 'pure map';
  t.true( !_.prototypeIs( Object.create( null ) ) );

  t.will = 'map';
  t.true( !_.prototypeIs( {} ) );

  t.will = 'primitive';
  t.true( !_.prototypeIs( 0 ) );
  t.true( !_.prototypeIs( 1 ) );
  t.true( !_.prototypeIs( '1' ) );
  t.true( !_.prototypeIs( null ) );
  t.true( !_.prototypeIs( undefined ) );

  t.will = 'routine';
  t.true( !_.prototypeIs( Date ) );
  t.true( !_.prototypeIs( F32x ) );
  t.true( !_.prototypeIs( function(){} ) );
  t.true( !_.prototypeIs( Self.constructor ) );

  t.will = 'object-like';
  t.true( !_.prototypeIs( [] ) );
  t.true( !_.prototypeIs( /x/ ) );
  t.true( !_.prototypeIs( new Date() ) );
  t.true( !_.prototypeIs( new F32x() ) );
  t.true( !_.prototypeIs( new (function(){})() ) );
  t.true( !_.prototypeIs( Self ) );

  t.will = 'object-like prototype';
  t.true( _.prototypeIs( Object.getPrototypeOf( [] ) ) );
  t.true( _.prototypeIs( Object.getPrototypeOf( /x/ ) ) );
  t.true( _.prototypeIs( Object.getPrototypeOf( new Date() ) ) );
  t.true( _.prototypeIs( Object.getPrototypeOf( new F32x() ) ) );
  t.true( _.prototypeIs( Object.getPrototypeOf( new (function(){})() ) ) );
  t.true( _.prototypeIs( Object.getPrototypeOf( Self ) ) );

}

//

function constructorIs( t )
{
  var self = this;

  t.will = 'pure map';
  t.true( !_.constructorIs( Object.create( null ) ) );

  t.will = 'map';
  t.true( !_.constructorIs( {} ) );

  t.will = 'primitive';
  t.true( !_.constructorIs( 0 ) );
  t.true( !_.constructorIs( 1 ) );
  t.true( !_.constructorIs( '1' ) );
  t.true( !_.constructorIs( null ) );
  t.true( !_.constructorIs( undefined ) );

  t.will = 'routine';
  t.true( _.constructorIs( Date ) );
  t.true( _.constructorIs( F32x ) );
  t.true( _.constructorIs( function(){} ) );
  t.true( _.constructorIs( Self.constructor ) );

  t.will = 'object-like';
  t.true( !_.constructorIs( [] ) );
  t.true( !_.constructorIs( /x/ ) );
  t.true( !_.constructorIs( new Date() ) );
  t.true( !_.constructorIs( new F32x() ) );
  t.true( !_.constructorIs( new (function(){})() ) );
  t.true( !_.constructorIs( Self ) );

  t.will = 'object-like prototype';
  t.true( !_.constructorIs( Object.getPrototypeOf( [] ) ) );
  t.true( !_.constructorIs( Object.getPrototypeOf( /x/ ) ) );
  t.true( !_.constructorIs( Object.getPrototypeOf( new Date() ) ) );
  t.true( !_.constructorIs( Object.getPrototypeOf( new F32x() ) ) );
  t.true( !_.constructorIs( Object.getPrototypeOf( new (function(){})() ) ) );
  t.true( !_.constructorIs( Object.getPrototypeOf( Self ) ) );

}

//

function propertyConstant( test )
{

  test.case = 'second argument is map';
  var dstMap = {};
  _.property.constant( dstMap, { a : 5 } );
  var descriptor = Object.getOwnPropertyDescriptor( dstMap, 'a' );
  test.identical( descriptor.writable, false );
  test.identical( dstMap.a, 5 );

  test.case = 'rewrites existing field';
  var dstMap = { a : 5 };
  _.property.constant( dstMap, { a : 1 } );
  var descriptor = Object.getOwnPropertyDescriptor( dstMap, 'a' );
  test.identical( descriptor.writable, false );
  test.identical( dstMap.a, 1 );

  test.case = '3 arguments';
  var dstMap = {};
  _.property.constant( dstMap, 'a', 5 );
  var descriptor = Object.getOwnPropertyDescriptor( dstMap, 'a' );
  test.identical( descriptor.writable, false );
  test.identical( dstMap.a, 5 );

  test.case = '2 arguments, no value';
  var dstMap = {};
  _.property.constant( dstMap, 'a' );
  var descriptor = Object.getOwnPropertyDescriptor( dstMap, 'a' );
  test.identical( descriptor.writable, false );
  test.identical( dstMap.a, undefined );
  test.true( 'a' in dstMap );

  test.case = 'second argument is array';
  var dstMap = {};
  _.property.constant( dstMap, [ 'a' ], 5 );
  var descriptor = Object.getOwnPropertyDescriptor( dstMap, 'a' );
  test.identical( descriptor.writable, false );
  test.identical( dstMap.a, 5 );

  if( !Config.debug )
  return;

  test.case = 'empty call';
  test.shouldThrowErrorSync( function()
  {
    _.property.constant( );
  });

  test.case = 'invalid first argument type';
  test.shouldThrowErrorSync( function()
  {
    _.property.constant( 1, { a : 'a' } );
  });

  test.case = 'invalid second argument type';
  test.shouldThrowErrorSync( function()
  {
    _.property.constant( {}, 13 );
  });

}

//

function prototypeHasPrototype( test )
{

  test.case = 'map';
  var src = {};
  var got = _.prototype.hasPrototype( src, src );
  test.identical( got, true );
  var got = _.prototype.hasPrototype( src, Object.prototype );
  test.identical( got, true );
  var got = _.prototype.hasPrototype( Object.prototype, src );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( src, {} );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( {}, src );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( Object.create( null ), src );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( src, Object.create( null ) );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( null, src );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( src, null );
  test.identical( got, false );

  test.case = 'pure map';
  var src = Object.create( null );
  var got = _.prototype.hasPrototype( src, src );
  test.identical( got, true );
  var got = _.prototype.hasPrototype( src, Object.prototype );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( Object.prototype, src );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( src, {} );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( {}, src );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( Object.create( null ), src );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( src, Object.create( null ) );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( null, src );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( src, null );
  test.identical( got, false );

  test.case = 'map chain';
  var prototype = Object.create( null );
  var src = Object.create( prototype );
  var got = _.prototype.hasPrototype( src, src );
  test.identical( got, true );
  var got = _.prototype.hasPrototype( src, prototype );
  test.identical( got, true );
  var got = _.prototype.hasPrototype( prototype, src );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( src, Object.prototype );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( Object.prototype, src );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( src, {} );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( {}, src );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( Object.create( null ), src );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( src, Object.create( null ) );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( null, src );
  test.identical( got, false );
  var got = _.prototype.hasPrototype( src, null );
  test.identical( got, false );

}

// --
// declare
// --

let Self =
{

  name : 'Tools.l2.blueprint.Etc',
  silencing : 1,

  tests :
  {

    instanceIs,
    prototypeIs,
    constructorIs,

    propertyConstant,
    prototypeHasPrototype,

  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
