( function _Definition_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../node_modules/Tools' );

  _.include( 'wTesting' );

  if( !_.module.isIncluded( 'wProto' ) )
  {
    require( '../../abase/l2_blueprint/Include.s' );
  }

}

var _global = _global_;
var _ = _global_.wTools;

// --
// test
// --

function definitionIs( test )
{
  test.case = 'instance of Definition';
  var src = new _.Definition( { ini : 1, defGroup : 'definition.unnamed' } );
  var got = _.definitionIs( src );
  test.identical( got, true );
}

// --
// declare
// --

var Self =
{

  name : 'Tools.base.l2.Blueprint.definition',
  silencing : 1,

  tests :
  {
    definitionIs, // Dmytro : the second part of routine in module wTools
  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
