( function _Prototype_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../wtools/Tools.s' );

  require( '../../abase/l2_blueprint/Include.s' );

  _.include( 'wTesting' );

}

let _global = _global_;
let _ = _global_.wTools;

// --
// test
// --

function hasPrototype( test )
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

  name : 'Tools.l2.Blueprint.prototype',
  silencing : 1,

  tests :
  {

    hasPrototype

  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
