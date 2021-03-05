( function _Property_test_s_( )
{

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

function _constant( test )
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

function declare( test )
{

  /* */

  test.case = 'basic';
  var obj1 = Object.create( null );
  _.property.declare( obj1, { name : 'a1', get : get1, set : set1 } );
  var exp = { a1 : undefined };
  test.identical( obj1, exp );
  test.identical( obj1.a1, undefined );
  test.identical( obj1[ Symbol.for( 'a1' ) ], undefined );

  var exp = { a1 : 2 };
  obj1.a1 = 2;
  test.identical( obj1, exp );
  test.identical( obj1.a1, 2 );
  test.identical( obj1[ Symbol.for( 'a1' ) ], 2 );

  var exp =
  {
    'get' : get1,
    'set' : set1,
    'enumerable' : true,
    'configurable' : true
  }
  var got = Object.getOwnPropertyDescriptor( obj1, 'a1' );
  test.identical( got, exp );

  /* */

  test.case = 'set : false';
  var obj1 = Object.create( null );
  _.property.declare( obj1, { name : 'a1', get : get1, set : false } );
  var exp = { a1 : undefined };
  test.identical( obj1, exp );
  test.identical( obj1.a1, undefined );
  test.identical( obj1[ Symbol.for( 'a1' ) ], undefined );

  var exp = { a1 : 2 };
  obj1[ Symbol.for( 'a1' ) ] = 2;
  test.identical( obj1, exp );
  test.identical( obj1.a1, 2 );
  test.identical( obj1[ Symbol.for( 'a1' ) ], 2 );

  var exp =
  {
    'get' : get1,
    'set' : undefined,
    'enumerable' : true,
    'configurable' : true
  }
  var got = Object.getOwnPropertyDescriptor( obj1, 'a1' );
  test.identical( got, exp );

  test.shouldThrowErrorSync( () => obj1.a1 = 'x' );
  test.identical( obj1.a1, 2 );

  /* */

  test.case = 'get : false';
  var obj1 = Object.create( null );
  _.property.declare( obj1, { name : 'a1', get : false, set : set1 } );
  var exp = {};
  test.identical( _.mapBut( obj1, { a1 : null } ), exp );
  // test.identical( obj1.a1, undefined );
  test.shouldThrowErrorSync( () => obj1.a1 );
  test.identical( obj1[ Symbol.for( 'a1' ) ], undefined );

  var exp = {};
  obj1.a1 = 2;
  test.identical( _.mapBut( obj1, { a1 : null } ), exp );
  // test.identical( obj1.a1, undefined );
  test.shouldThrowErrorSync( () => obj1.a1 );
  test.identical( obj1[ Symbol.for( 'a1' ) ], 2 );

  var got = Object.getOwnPropertyDescriptor( obj1, 'a1' );
  var exp =
  {
    'get' : got.get,
    'set' : set1,
    'enumerable' : true,
    'configurable' : true
  }
  test.identical( got, exp );
  test.identical( got.get.name, 'noGet' );

  /* */

  test.case = 'val';
  var obj1 = Object.create( null );
  _.property.declare( obj1, { name : 'a1', val : 1 } );
  var exp = { a1 : 1 };
  test.identical( obj1, exp );
  test.identical( obj1.a1, 1 );
  test.identical( obj1[ Symbol.for( 'a1' ) ], undefined );

  var exp = { a1 : 2 };
  obj1.a1 = 2;
  test.identical( obj1, exp );
  test.identical( obj1.a1, 2 );
  test.identical( obj1[ Symbol.for( 'a1' ) ], undefined );

  var exp =
  {
    'value' : 2,
    'writable' : true,
    'enumerable' : true,
    'configurable' : true
  }
  var got = Object.getOwnPropertyDescriptor( obj1, 'a1' );
  test.identical( got, exp );

  /* */

  if( !Config.debug )
  return;

  test.case = 'get : false , val : 1';
  test.shouldThrowErrorSync( () => _.property.declare( obj1, { name : 'a1', get : false, set : set1, val : 1 } ) );
  test.case = 'set : false , val : 1';
  test.shouldThrowErrorSync( () => _.property.declare( obj1, { name : 'a1', get : get1, set : false, val : 1 } ) );

  /* */

  function get1()
  {
    return this[ Symbol.for( 'a1' ) ];
  }

  function set1( src )
  {
    return this[ Symbol.for( 'a1' ) ] = src;
  }

}

// --
// declare
// --

let Self =
{

  name : 'Tools.l2.blueprint.Property',
  silencing : 1,

  tests :
  {

    _constant,
    // hasPrototype,
    declare,

  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
