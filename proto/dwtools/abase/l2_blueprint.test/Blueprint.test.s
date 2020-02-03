( function _Blueprint_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

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

function constructionAmendBlueprintGetterAlias( test )
{

  test.is( _.routineIs( _.accessor.define.getter.alias ) );

  var f1 = function f1(){};
  var _container =
  {
    Begin : function Begin(){ return 'Begin' },
    End : function End(){ return 'End' },
    Str : 'Str',
  }
  var container = _.mapExtend( function(){}, _container );

  var alias = ( originalName ) => _.accessor.define.getter.alias({ originalName, container : container });
  var blueprint =
  {
    begin : alias( 'Begin' ),
    end : alias( 'End' ),
    str : alias( 'Str' ),
    container1 : container,
    f1 : f1,
  }

  var map = _.construction.extend( null, blueprint );

  test.is( _.mapIs( map ) );
  test.is( _.mapIsPure( map ) );
  test.identical( _.mapKeys( map ), [ 'begin', 'end', 'str', 'container1', 'f1' ] );
  test.identical( map.begin, container.Begin );
  test.identical( map.str, container.Str );
  test.is( _.routineIs( map.begin ) );
  test.identical( map.str, 'Str' );
  test.identical( container.Str, 'Str' );

  container.Str = 'Str2';
  test.identical( map.str, 'Str2' );
  test.identical( container.Str, 'Str2' );

  test.shouldThrowErrorSync( () =>
  {
    map.str = 'Str2';
  });

}

constructionAmendBlueprintGetterAlias.description =
`
- construction extend by blueprint with alias definition produce proper object
- aliased fields of produced object has read access to container
`

//

function constructionAmendBlueprintSetterAlias( test )
{

  test.is( _.routineIs( _.accessor.define.setter.alias ) );

  var f1 = function f1(){};
  var _container =
  {
    Begin : function Begin(){ return 'Begin' },
    End : function End(){ return 'End' },
    Str : 'Str',
  }
  var container = _.mapExtend( function(){}, _container );

  var alias = ( originalName ) => _.accessor.define.setter.alias({ originalName, container : container });
  var blueprint =
  {
    begin : alias( 'Begin' ),
    end : alias( 'End' ),
    str : alias( 'Str' ),
    container1 : container,
    f1 : f1,
  }

  var map = _.construction.extend( null, blueprint );

  test.is( _.mapIs( map ) );
  test.is( _.mapIsPure( map ) );
  test.identical( _.mapKeys( map ), [ 'begin', 'end', 'str', 'container1', 'f1' ] );
  test.identical( map.begin, undefined );
  test.identical( map.str, undefined );

  container.Str = 'Str2';
  test.identical( map.str, undefined );
  test.identical( container.Str, 'Str2' );

  map.str = 'Str3';
  test.identical( map.str, undefined );
  test.identical( container.Str, 'Str3' );

}

constructionAmendBlueprintSetterAlias.description =
`
- construction extend by blueprint with alias definition produce proper object
- aliased fields of produced object has write access to container
`

//

function constructionAmendBlueprintAccessorAlias( test )
{

  test.is( _.routineIs( _.accessor.define.suite.alias ) );

  var f1 = function f1(){};
  var _container =
  {
    Begin : function Begin(){ return 'Begin' },
    End : function End(){ return 'End' },
    Str : 'Str',
  }
  var container = _.mapExtend( function(){}, _container );

  var alias = ( originalName ) => _.accessor.define.suite.alias({ originalName, container : container });
  var blueprint =
  {
    begin : alias( 'Begin' ),
    end : alias( 'End' ),
    str : alias( 'Str' ),
    container1 : container,
    f1 : f1,
  }

  var map = _.construction.extend( null, blueprint );

  test.is( _.mapIs( map ) );
  test.is( _.mapIsPure( map ) );
  test.identical( _.mapKeys( map ), [ 'begin', 'end', 'str', 'container1', 'f1' ] );
  test.identical( map.begin, container.Begin );
  test.identical( map.str, container.Str );
  test.is( _.routineIs( map.begin ) );
  test.identical( map.str, 'Str' );
  test.identical( container.Str, 'Str' );

  container.Str = 'Str2';
  test.identical( map.str, 'Str2' );
  test.identical( container.Str, 'Str2' );

  map.str = 'Str3';
  test.identical( map.str, 'Str3' );
  test.identical( container.Str, 'Str3' );

}

constructionAmendBlueprintAccessorAlias.description =
`
- construction extend by blueprint with alias definition produce proper object
- aliased fields of produced object has read/write access to container
`

// --
// declare
// --

var Self =
{

  name : 'Tools.base.l3.Proto.blueprint',
  silencing : 1,

  tests :
  {

    constructionAmendBlueprintGetterAlias,
    constructionAmendBlueprintSetterAlias,
    constructionAmendBlueprintAccessorAlias,

  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
