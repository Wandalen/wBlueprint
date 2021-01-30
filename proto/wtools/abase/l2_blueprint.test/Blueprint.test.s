( function _Blueprint_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../wtools/Tools.s' );
  require( '../../abase/l2_blueprint/Include.s' );
  // _.include( 'wReplicator' );
  _.include( 'wTesting' );
}

let _global = _global_;
let _ = _global_.wTools;
let select = _globals_.testing.wTools.select;

/* xxx qqq

 - cover construction.extend() + definition::*
 - implement options but, only for amending

*/

// --
// helper
// --

function propertyOwn( src )
{
  _.assert( arguments.length === 1 );
  return _.property.onlyOwn( src, { onlyEnumerable : 0 } );
}

//

function keysOwn( src )
{
  _.assert( arguments.length === 1 );
  return _.mapKeys( src, { onlyOwn : 1, onlyEnumerable : 0 } );
}

//

function eachKindOfProp()
{
  let result = Object.create( null );

  add({ propKind : 'valToIns:val', prop : _.define.prop( 1 , { valToIns : 'val' } ) });
  add({ propKind : 'valToIns:shallow', prop : _.define.prop( 1, { valToIns : 'shallow' } ) });
  add({ propKind : 'configurable:0', prop : _.define.prop( 1, { configurable : 0 } ) });
  add({ propKind : 'get:1, set:1', prop : _.define.prop( 1, { get : 1, set : 1 } ) });
  add({ propKind : 'static:1', prop : _.define.prop( 1, { static : 1 } ) });
  add({ propKind : 'static:1, get:1, set:1', prop : _.define.prop( 1, { static : 1, get : 1, set : 1 } ) });

  return result;

  function add( prop )
  {
    result[ prop.propKind ] = prop;
  }

}

// --
// etc
// --

function blueprintIsDefinitive( test )
{

  var Blueprint1 = _.Blueprint
  ({
    field1 : null,
  });
  var Blueprint2 = _.Blueprint( Blueprint1 );
  var Blueprint3 = _.Blueprint
  ({
    typed : _.trait.typed(),
    field2 : 2,
  });
  var instance1 = _.blueprint.construct( Blueprint1 );
  var instance2 = _.blueprint.construct( Blueprint2 );
  var instance3 = _.blueprint.construct( Blueprint3 );

  test.identical( _.objectIs( Blueprint1.Runtime ), true );
  test.identical( _.objectIs( Blueprint2.Runtime ), true );
  test.identical( _.objectIs( Blueprint3.Runtime ), true );

  test.identical( _.blueprint.isDefinitive( _.blueprint ), false );
  test.identical( _.blueprint.isDefinitive( _.Blueprint ), false );
  test.identical( _.blueprint.isDefinitive( _.Blueprint.prototype ), false );
  test.identical( _.blueprint.isDefinitive( Blueprint1 ), true );
  test.identical( _.blueprint.isDefinitive( Blueprint2 ), true );
  test.identical( _.blueprint.isDefinitive( Blueprint3 ), true );
  test.identical( _.blueprint.isDefinitive( Blueprint1.Runtime ), false );
  test.identical( _.blueprint.isDefinitive( Blueprint2.Runtime ), false );
  test.identical( _.blueprint.isDefinitive( Blueprint3.Runtime ), false );
  test.identical( _.blueprint.isDefinitive( instance1 ), false );
  test.identical( _.blueprint.isDefinitive( instance2 ), false );
  test.identical( _.blueprint.isDefinitive( instance3 ), false );

}

blueprintIsDefinitive.description =
`
- instances of blueprint are not blueprints
- blueprint is blueprint
- abstract _.Blueprint is blueprint
- namespace _.blueprint is not blueprint
`

//

function blueprintIsRuntime( test )
{

  var Blueprint1 = _.Blueprint
  ({
    field1 : null,
  });
  var Blueprint2 = _.Blueprint( Blueprint1 );
  var Blueprint3 = _.Blueprint
  ({
    typed : _.trait.typed(),
    field2 : 2,
  });
  var instance1 = _.blueprint.construct( Blueprint1 );
  var instance2 = _.blueprint.construct( Blueprint2 );
  var instance3 = _.blueprint.construct( Blueprint3 );

  test.identical( _.objectIs( Blueprint1.Runtime ), true );
  test.identical( _.objectIs( Blueprint2.Runtime ), true );
  test.identical( _.objectIs( Blueprint3.Runtime ), true );

  test.identical( _.blueprint.isRuntime( _.blueprint ), false );
  test.identical( _.blueprint.isRuntime( _.Blueprint ), false );
  test.identical( _.blueprint.isRuntime( _.Blueprint.prototype ), true );
  test.identical( _.blueprint.isRuntime( Blueprint1 ), false );
  test.identical( _.blueprint.isRuntime( Blueprint2 ), false );
  test.identical( _.blueprint.isRuntime( Blueprint3 ), false );
  test.identical( _.blueprint.isRuntime( Blueprint1.Runtime ), true );
  test.identical( _.blueprint.isRuntime( Blueprint2.Runtime ), true );
  test.identical( _.blueprint.isRuntime( Blueprint3.Runtime ), true );
  test.identical( _.blueprint.isRuntime( instance1 ), false );
  test.identical( _.blueprint.isRuntime( instance2 ), false );
  test.identical( _.blueprint.isRuntime( instance3 ), false );

}

//

function blueprintStructure( test )
{

  var Blueprint1 = _.Blueprint
  ({
    field1 : null,
  });
  test.true( !_.mapOwn( Blueprint1, 'Runtime' ) );
  test.true( _.mapHas( Blueprint1, 'Runtime' ) );
  test.true( Blueprint1.Runtime === _.prototype.of( Blueprint1 ) );

  test.true( !_.mapOwn( Blueprint1, 'prototype' ) );
  test.true( _.mapHas( Blueprint1, 'prototype' ) );
  test.true( _.mapOwn( Blueprint1.Runtime, 'prototype' ) );

}

// --
// define inherit
// --

function blueprintInheritManually( test )
{

  /* */

  test.case = 'with trait inherit';

  let s = _.define.static;

  test.description = 'blueprint1'; /* */

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : s( 'b1' ),
    s2 : s( 'b1' ),
  });

  var instance = Blueprint1.Make();
  test.identical( instance instanceof Blueprint1.Make, true );

  test.identical( _.prototype.each( instance ).length, 3 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( _.property.all( instance ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    's1' : 'b1', 's2' : 'b1'
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 2 ] ), exp );

  test.description = 'blueprint2'; /* */

  var Blueprint2 = _.Blueprint
  ({
    extension : _.define.extension( Blueprint1 ),
    typed : _.trait.typed({ val : Blueprint1.TraitsMap.typed.val, prototype : Blueprint1 }),
    // prototype : _.trait.prototype( Blueprint1 ),
    field2 : 'b2',
    field3 : 'b2',
    s2 : s( 'b2' ),
    staticField3 : s( 'b2' ),
  });

  var instance = Blueprint2.Make();

  test.identical( instance instanceof Blueprint1.Make, true );
  test.identical( instance instanceof Blueprint2.Make, true );

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    's1' : 'b1',
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( _.prototype.each( instance ).length, 4 );
  test.identical( propertyOwn( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    's2' : 'b2', 'staticField3' : 'b2'
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
    's1' : 'b1', 's2' : 'b1'
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 3 ] ), exp );

  test.description = 'control blueprint1'; /* */

  var instance = Blueprint1.Make();
  test.identical( instance instanceof Blueprint1.Make, true );
  test.identical( instance instanceof Blueprint2.Make, false );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    's1' : 'b1',
    's2' : 'b1',
  }
  var got = _.property.all( instance );
  test.identical( got, exp );

  test.description = 'blueprint3'; /* */

  var Blueprint3 = _.Blueprint
  ({
    extend : _.define.extension( Blueprint2 ),
    typed : _.trait.typed({ val : 1, prototype : Blueprint2 }),
    // prototype : _.trait.prototype( Blueprint2 ),
    'field3' : 'b3',
    'field4' : 'b3',
    staticField3 : s( 'b3' ),
    staticField4 : s( 'b3' ),
  });

  var instance = Blueprint3.Make();

  test.identical( instance instanceof Blueprint1.Make, true );
  test.identical( instance instanceof Blueprint2.Make, true );
  test.identical( instance instanceof Blueprint3.Make, true );

  test.identical( _.prototype.each( instance ).length, 5 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b3',
    'field4' : 'b3',
    'staticField3' : 'b3',
    'staticField4' : 'b3',
    's1' : 'b1',
    's2' : 'b2'
  }
  test.identical( _.property.all( instance ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b3',
    'field4' : 'b3',
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    'staticField3' : 'b3', 'staticField4' : 'b3'
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
    's2' : 'b2', 'staticField3' : 'b2'
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 2 ] ), exp );
  var exp =
  {
    's1' : 'b1', 's2' : 'b1'
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 3 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 4 ] ), exp );

  /* */

}

blueprintInheritManually.description =
`
- defintition prototype makes another blueprint prototype of instance of the blueprint
`

//

function blueprintInheritWithHelper( test )
{

  /* */

  test.case = 'typed';

  var s = _.define.static;
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : s( 'b1' ),
    s2 : s( 'b1' ),
  });

  test.description = 'blueprint1'; /* */

  var instance = Blueprint1.Make();
  test.identical( instance instanceof Blueprint1.Make, true );

  test.identical( _.prototype.each( instance ).length, 3 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( _.property.all( instance ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    's1' : 'b1', 's2' : 'b1'
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 2 ] ), exp );

  test.description = 'blueprint2'; /* */

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : 'b2',
    field3 : 'b2',
    s2 : s( 'b2' ),
    staticField3 : s( 'b2' ),
  });

  var instance = Blueprint2.Make();

  test.identical( instance instanceof Blueprint1.Make, true );
  test.identical( instance instanceof Blueprint2.Make, true );

  test.identical( _.prototype.each( instance ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    's1' : 'b1',
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    's2' : 'b2', 'staticField3' : 'b2'
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
    's1' : 'b1', 's2' : 'b1'
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 3 ] ), exp );

  test.description = 'control blueprint1'; /* */

  var instance = Blueprint1.Make();
  test.identical( instance instanceof Blueprint1.Make, true );
  test.identical( instance instanceof Blueprint2.Make, false );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    's1' : 'b1',
    's2' : 'b1',
  }
  var got = _.property.all( instance );
  test.identical( got, exp );

  test.description = 'blueprint3'; /* */

  var Blueprint3 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint2 ),
    'field3' : 'b3',
    'field4' : 'b3',
    staticField3 : s( 'b3' ),
    staticField4 : s( 'b3' ),
  });

  var instance = Blueprint3.Make();

  test.identical( instance instanceof Blueprint1.Make, true );
  test.identical( instance instanceof Blueprint2.Make, true );
  test.identical( instance instanceof Blueprint3.Make, true );

  test.identical( _.prototype.each( instance ).length, 5 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b3',
    'field4' : 'b3',
    'staticField3' : 'b3',
    'staticField4' : 'b3',
    's1' : 'b1',
    's2' : 'b2'
  }
  test.identical( _.property.all( instance ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b3',
    'field4' : 'b3',
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    'staticField3' : 'b3', 'staticField4' : 'b3'
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
    's2' : 'b2', 'staticField3' : 'b2'
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 2 ] ), exp );
  var exp =
  {
    's1' : 'b1', 's2' : 'b1'
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 3 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 4 ] ), exp );

  /* */

  test.case = 'untyped';

  var s = _.define.static;
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( false ),
    field1 : 'b1',
    field2 : 'b1',
  });

  test.description = 'blueprint2'; /* */

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : 'b2',
    field3 : 'b2',
  });

  var instance = Blueprint2.Make();

  // test.identical( instance instanceof Blueprint1.Make, false );
  test.identical( instance instanceof Blueprint2.Make, true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint1 ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint2 ), true );

  test.identical( _.prototype.each( instance ).length, 3 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 0 ] ), exp );

  test.description = 'blueprint3'; /* */

  var Blueprint3 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint2 ),
    'field3' : 'b3',
    'field4' : 'b3',
  });

  var instance = Blueprint3.Make();

  // test.identical( instance instanceof Blueprint1.Make, false );
  test.identical( instance instanceof Blueprint2.Make, true );
  test.identical( instance instanceof Blueprint3.Make, true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint1 ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint2 ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint3 ), true );

  test.identical( _.prototype.each( instance ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b3',
    'field4' : 'b3',
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 0 ] ), exp );

  /* */

  test.case = 'implicit untyped';

  var s = _.define.static;
  var Blueprint1 = _.Blueprint
  ({
    field1 : 'b1',
    field2 : 'b1',
  });

  test.description = 'blueprint2'; /* */

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : 'b2',
    field3 : 'b2',
  });

  var instance = Blueprint2.Make();

  // test.identical( instance instanceof Blueprint1.Make, false );
  test.identical( instance instanceof Blueprint2.Make, true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint1 ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint2 ), true );

  test.identical( _.prototype.each( instance ).length, 3 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 0 ] ), exp );

  test.description = 'blueprint3'; /* */

  var Blueprint3 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint2 ),
    'field3' : 'b3',
    'field4' : 'b3',
  });

  var instance = Blueprint3.Make();

  // test.identical( instance instanceof Blueprint1.Make, false );
  test.identical( instance instanceof Blueprint2.Make, true );
  test.identical( instance instanceof Blueprint3.Make, true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint1 ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint2 ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint3 ), true );

  test.identical( _.prototype.each( instance ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b3',
    'field4' : 'b3',
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 0 ] ), exp );

  /* */

  test.case = 'typed -> untyped';

  var s = _.define.static;
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
  });

  test.description = 'blueprint2'; /* */

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    typed : _.trait.typed( false ),
    field2 : 'b2',
    field3 : 'b2',
  });

  var instance = Blueprint2.Make();

  test.identical( instance instanceof Blueprint1.Make, false );
  // test.identical( instance instanceof Blueprint2.Make, false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint1 ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint2 ), _.maybe );

  test.identical( _.prototype.each( instance ).length, 1 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 0 ] ), exp );

  test.description = 'blueprint3'; /* */

  var Blueprint3 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint2 ),
    'field3' : 'b3',
    'field4' : 'b3',
  });

  var instance = Blueprint3.Make();

  test.identical( instance instanceof Blueprint1.Make, false );
  // test.identical( instance instanceof Blueprint2.Make, false );
  test.identical( instance instanceof Blueprint3.Make, true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint1 ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint2 ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint3 ), true );

  test.identical( _.prototype.each( instance ).length, 3 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b3',
    'field4' : 'b3',
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 0 ] ), exp );

  /* */

  test.case = 'typed -> untyped, but before';

  var s = _.define.static;
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
  });

  test.description = 'blueprint2'; /* */

  var Blueprint2 = _.Blueprint
  ({
    typed : _.trait.typed( false ),
    inherit : _.define.inherit( Blueprint1 ),
    field2 : 'b2',
    field3 : 'b2',
  });

  var instance = Blueprint2.Make();

  test.identical( instance instanceof Blueprint1.Make, true );
  test.identical( instance instanceof Blueprint2.Make, true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint1 ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint2 ), true );

  test.identical( _.prototype.each( instance ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 0 ] ), exp );

  test.description = 'blueprint3'; /* */

  var Blueprint3 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint2 ),
    'field3' : 'b3',
    'field4' : 'b3',
  });

  var instance = Blueprint3.Make();

  test.identical( instance instanceof Blueprint1.Make, true );
  test.identical( instance instanceof Blueprint2.Make, true );
  test.identical( instance instanceof Blueprint3.Make, true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint1 ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint2 ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint3 ), true );

  test.identical( _.prototype.each( instance ).length, 5 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b3',
    'field4' : 'b3',
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 0 ] ), exp );

  /* */

}

blueprintInheritWithHelper.description =
`
- blueprint inheritance with trait
`

//

function blueprintInheritSingle( test )
{

  eachCase({});

  function eachCase( tops )
  {

    /* */

    test.case = 'from untyped'

    var Blueprint1 = _.Blueprint
    ({
      field1 : 1,
    });
    test.identical( Blueprint1.TraitsMap.typed.val, false );
    test.true( Blueprint1.TraitsMap.typed.prototype === false );

    var Blueprint2 = _.Blueprint( Blueprint1 );
    test.identical( Blueprint2.TraitsMap.typed.val, true );
    test.true( Blueprint2.TraitsMap.typed.prototype === false );

    var instance1 = _.blueprint.construct( Blueprint1 );
    test.identical( _.prototype.each( instance1 ).length, 1 );

    var instance2 = _.blueprint.construct( Blueprint2 );
    test.identical( _.prototype.each( instance2 ).length, 3 );
    test.true( _.prototype.each( instance2 )[ 1 ] === Blueprint2.prototype );
    test.true( _.prototype.each( instance2 )[ 2 ] === _.Construction.prototype );

    var exp = { field1 : 1 }
    test.identical( _.property.all( instance2 ), exp );

    /* */

    test.case = 'from typed'

    var Blueprint1 = _.Blueprint
    ({
      type : _.trait.typed( 1 ),
      field1 : 1,
    });
    test.identical( Blueprint1.TraitsMap.typed.val, true );
    test.true( Blueprint1.TraitsMap.typed.prototype === true );

    var Blueprint2 = _.Blueprint( Blueprint1 );
    test.identical( Blueprint2.TraitsMap.typed.val, true );
    test.true( Blueprint2.TraitsMap.typed.prototype === Blueprint1 );

    var instance1 = _.blueprint.construct( Blueprint1 );
    test.identical( _.prototype.each( instance1 ).length, 3 );
    test.true( _.prototype.each( instance1 )[ 1 ] === Blueprint1.prototype );
    test.true( _.prototype.each( instance1 )[ 2 ] === _.Construction.prototype );

    var instance2 = _.blueprint.construct( Blueprint2 );
    test.identical( _.prototype.each( instance2 ).length, 4 );
    test.true( _.prototype.each( instance2 )[ 1 ] === Blueprint2.prototype );
    test.true( _.prototype.each( instance2 )[ 2 ] === Blueprint1.prototype );
    test.true( _.prototype.each( instance2 )[ 3 ] === _.Construction.prototype );

    var exp = { field1 : 1 }
    test.identical( _.property.all( instance2 ), exp );

    /* */

    test.case = 'from typed, prototype:1'

    var Blueprint1 = _.Blueprint
    ({
      type : _.trait.typed({ val : 1, prototype : 1 }),
      field1 : 1,
    });
    test.identical( Blueprint1.TraitsMap.typed.val, true );
    test.true( Blueprint1.TraitsMap.typed.prototype === true );

    var Blueprint2 = _.Blueprint( Blueprint1 );
    test.identical( Blueprint2.TraitsMap.typed.val, true );
    test.true( Blueprint2.TraitsMap.typed.prototype === Blueprint1 );

    var instance1 = _.blueprint.construct( Blueprint1 );
    test.identical( _.prototype.each( instance1 ).length, 3 );
    test.true( _.prototype.each( instance1 )[ 1 ] === Blueprint1.prototype );
    test.true( _.prototype.each( instance1 )[ 2 ] === _.Construction.prototype );

    var instance2 = _.blueprint.construct( Blueprint2 );
    test.identical( _.prototype.each( instance2 ).length, 4 );
    test.true( _.prototype.each( instance2 )[ 1 ] === Blueprint2.prototype );
    test.true( _.prototype.each( instance2 )[ 2 ] === Blueprint1.prototype );
    test.true( _.prototype.each( instance2 )[ 3 ] === _.Construction.prototype );

    var exp = { field1 : 1 }
    test.identical( _.property.all( instance2 ), exp );

    /* */

    test.case = 'from typed, prototype:0'

    var Blueprint1 = _.Blueprint
    ({
      type : _.trait.typed({ val : 1, prototype : 0 }),
      field1 : 1,
    });
    test.identical( Blueprint1.TraitsMap.typed.val, true );
    test.true( Blueprint1.TraitsMap.typed.prototype === false );

    var Blueprint2 = _.Blueprint( Blueprint1 );
    test.identical( Blueprint2.TraitsMap.typed.val, true );
    test.true( Blueprint2.TraitsMap.typed.prototype === Blueprint1 );

    var instance1 = _.blueprint.construct( Blueprint1 );
    test.identical( _.prototype.each( instance1 ).length, 3 );
    test.true( _.prototype.each( instance1 )[ 1 ] === Blueprint1.prototype );
    test.true( _.prototype.each( instance1 )[ 2 ] === _.Construction.prototype );

    var instance2 = _.blueprint.construct( Blueprint2 );
    test.identical( _.prototype.each( instance2 ).length, 4 );
    test.true( _.prototype.each( instance2 )[ 1 ] === Blueprint2.prototype );
    test.true( _.prototype.each( instance2 )[ 2 ] === Blueprint1.prototype );
    test.true( _.prototype.each( instance2 )[ 3 ] === _.Construction.prototype );

    var exp = { field1 : 1 }
    test.identical( _.property.all( instance2 ), exp );

    /* */

  }

}

//

function blueprintInheritMultiple( test )
{

  eachCase({});

  function eachCase( tops )
  {

    /* */

    test.case = 'inherit from several, first typed, second typed'

    var Blueprint1 = _.Blueprint
    ({
      type : _.trait.typed({ val : 1 }),
      field1 : 1,
      field2 : 1,
    });

    var Blueprint2 = _.Blueprint
    ({
      type : _.trait.typed({ val : 1 }),
      field2 : 2,
      field3 : 2,
    });

    var Blueprint3 = _.Blueprint( Blueprint1, Blueprint2 );
    test.identical( Blueprint3.TraitsMap.typed.val, true );
    test.true( Blueprint3.TraitsMap.typed.prototype === Blueprint2 );
    test.identical( Blueprint3.TraitsMap.typed.new, true );

    var instance3 = _.blueprint.construct( Blueprint3 );
    test.identical( _.prototype.each( instance3 ).length, 4 );
    test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint3.prototype );
    test.true( _.prototype.each( instance3 )[ 2 ] === Blueprint2.prototype );
    test.true( _.prototype.each( instance3 )[ 3 ] === _.Construction.prototype );

    var exp = { field1 : 1, field2 : 2, field3 : 2, }
    test.identical( _.property.all( instance3 ), exp );

    /* */

    test.case = 'inherit from several, first typed, second untyped'

    var Blueprint1 = _.Blueprint
    ({
      type : _.trait.typed({ val : 1 }),
      field1 : 1,
      field2 : 1,
    });

    var Blueprint2 = _.Blueprint
    ({
      type : _.trait.typed({ val : 0 }),
      field2 : 2,
      field3 : 2,
    });

    var Blueprint3 = _.Blueprint( Blueprint1, Blueprint2 );
    test.identical( Blueprint3.TraitsMap.typed.val, true );
    test.true( Blueprint3.TraitsMap.typed.prototype === false );
    test.identical( Blueprint3.TraitsMap.typed.new, false );

    var instance3 = _.blueprint.construct( Blueprint3 );
    test.identical( _.prototype.each( instance3 ).length, 3 );
    test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint3.prototype );
    test.true( _.prototype.each( instance3 )[ 2 ] === _.Construction.prototype );

    var exp = { field1 : 1, field2 : 2, field3 : 2, }
    test.identical( _.property.all( instance3 ), exp );

    /* */

    test.case = 'inherit from several, first untyped, second typed'

    var Blueprint1 = _.Blueprint
    ({
      type : _.trait.typed({ val : 0 }),
      field1 : 1,
      field2 : 1,
    });

    var Blueprint2 = _.Blueprint
    ({
      type : _.trait.typed({ val : 1 }),
      field2 : 2,
      field3 : 2,
    });

    var Blueprint3 = _.Blueprint( Blueprint1, Blueprint2 );
    test.identical( Blueprint3.TraitsMap.typed.val, true );
    test.true( Blueprint3.TraitsMap.typed.prototype === Blueprint2 );
    test.identical( Blueprint3.TraitsMap.typed.new, true );

    var instance3 = _.blueprint.construct( Blueprint3 );
    test.identical( _.prototype.each( instance3 ).length, 4 );
    test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint3.prototype );
    test.true( _.prototype.each( instance3 )[ 2 ] === Blueprint2.prototype );
    test.true( _.prototype.each( instance3 )[ 3 ] === _.Construction.prototype );

    var exp = { field1 : 1, field2 : 2, field3 : 2, }
    test.identical( _.property.all( instance3 ), exp );

    /* */

    test.case = 'inherit from several, first untyped, second untyped'

    var Blueprint1 = _.Blueprint
    ({
      type : _.trait.typed({ val : 0 }),
      field1 : 1,
      field2 : 1,
    });

    var Blueprint2 = _.Blueprint
    ({
      type : _.trait.typed({ val : 0 }),
      field2 : 2,
      field3 : 2,
    });

    var Blueprint3 = _.Blueprint( Blueprint1, Blueprint2 );
    test.identical( Blueprint3.TraitsMap.typed.val, true );
    test.identical( Blueprint3.TraitsMap.typed.prototype, false );
    test.identical( Blueprint3.TraitsMap.typed.new, false );

    var instance3 = _.blueprint.construct( Blueprint3 );
    test.identical( _.prototype.each( instance3 ).length, 3 );
    test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint3.prototype );
    test.true( _.prototype.each( instance3 )[ 2 ] === _.Construction.prototype );

    var exp = { field1 : 1, field2 : 2, field3 : 2, }
    test.identical( _.property.all( instance3 ), exp );

    /* */

  }

}

//

function blueprintInheritMultipleAlternatives( test )
{

  eachCase({});

  function eachCase( tops )
  {

    /* */

    test.case = 'unrolled array'

    var Blueprint1 = _.Blueprint
    ({
      type : _.trait.typed({ val : 1 }),
      field1 : 1,
      field2 : 1,
    });

    var Blueprint2 = _.Blueprint
    ({
      type : _.trait.typed({ val : 1 }),
      field2 : 2,
      field3 : 2,
    });

    var Blueprint3 = _.Blueprint( Blueprint1, Blueprint2 );
    test.identical( Blueprint3.TraitsMap.typed.val, true );
    test.true( Blueprint3.TraitsMap.typed.prototype === Blueprint2 );
    test.identical( Blueprint3.TraitsMap.typed.new, true );

    var instance3 = _.blueprint.construct( Blueprint3 );
    test.identical( _.prototype.each( instance3 ).length, 4 );
    var exp = { field1 : 1, field2 : 2, field3 : 2, }
    test.identical( _.property.all( instance3 ), exp );

    /* */

    test.case = 'array'

    var Blueprint1 = _.Blueprint
    ({
      type : _.trait.typed({ val : 1 }),
      field1 : 1,
      field2 : 1,
    });

    var Blueprint2 = _.Blueprint
    ({
      type : _.trait.typed({ val : 1 }),
      field2 : 2,
      field3 : 2,
    });

    var Blueprint3 = _.Blueprint([ Blueprint1, Blueprint2 ]);
    test.identical( Blueprint3.TraitsMap.typed.val, true );
    test.true( Blueprint3.TraitsMap.typed.prototype === Blueprint2 );
    test.identical( Blueprint3.TraitsMap.typed.new, true );

    var instance3 = _.blueprint.construct( Blueprint3 );
    test.identical( _.prototype.each( instance3 ).length, 4 );
    var exp = { field1 : 1, field2 : 2, field3 : 2, }
    test.identical( _.property.all( instance3 ), exp );

    /* */

    test.case = 'map'

    var Blueprint1 = _.Blueprint
    ({
      type : _.trait.typed({ val : 1 }),
      field1 : 1,
      field2 : 1,
    });

    var Blueprint2 = _.Blueprint
    ({
      type : _.trait.typed({ val : 1 }),
      field2 : 2,
      field3 : 2,
    });

    var Blueprint3 = _.Blueprint({ b1 : Blueprint1, b2 : Blueprint2 });
    test.identical( Blueprint3.TraitsMap.typed.val, true );
    test.true( Blueprint3.TraitsMap.typed.prototype === Blueprint2 );
    test.identical( Blueprint3.TraitsMap.typed.new, true );

    var instance3 = _.blueprint.construct( Blueprint3 );
    test.identical( _.prototype.each( instance3 ).length, 4 );
    var exp = { field1 : 1, field2 : 2, field3 : 2, }
    test.identical( _.property.all( instance3 ), exp );

    /* */

  }

}

// --
// define prop
// --

function defineProp( test )
{

  /* */

  test.case = 'val / shallow';

  var exp =
  {
    shallow1 : [ 2, 2 ],
    shallow2 : [ [ 2, 2 ], { a : 2 } ],
    val1 : 2,
    val2 : [ 2, 2 ],
    val3 : { a : 2 },
  }
  var options =
  {
    shallow1 : _.define.shallow([ 2, 2 ]),
    shallow2 : _.define.shallow([ [ 2, 2 ], { a : 2 } ]),
    val1 : 2,
    val2 : _.define.val( [ 2, 2 ] ),
    val3 : _.define.val( { a : 2 } ),
  }
  var instance1 = _.blueprint.construct( options )
  test.identical( instance1, exp );

  test.true( !!options.shallow1.val );
  test.true( !!options.shallow2.val );
  test.true( !!options.shallow2.val[ 0 ] );
  test.true( !!options.shallow2.val[ 1 ] );
  test.true( !!options.val1 );
  test.true( !!options.val2.val );
  test.true( !!options.val3.val );

  test.true( instance1.shallow1 !== options.shallow1.val );
  test.true( instance1.shallow2 !== options.shallow2.val );
  test.true( instance1.shallow2[ 0 ] === options.shallow2.val[ 0 ] );
  test.true( instance1.shallow2[ 1 ] === options.shallow2.val[ 1 ] );
  test.true( instance1.val1 === options.val1 );
  test.true( instance1.val2 === options.val2.val );
  test.true( instance1.val3 === options.val3.val );

  /* */

  test.case = 'call / new';

  var exp =
  {
    call1 : { b : 3 },
    new1 : { a : 2, b : 3 },
  }
  var options =
  {
    call1 : _.define.call( constr1 ),
    new1 : _.define.new( constr1 ),
  }
  var instance1 = _.blueprint.construct( options )
  test.identical( instance1, exp );
  test.true( !!options.call1.val );
  test.true( !!options.new1.val );
  test.true( instance1.call1 !== options.call1.val );
  test.true( instance1.new1 !== options.new1.val );

  /* */

  test.case = 'deep';

  if( _.replicate )
  {

    var exp =
    {
      deep1 : [ 2, 2 ],
      deep2 : [ [ 2, 2 ], { a : 2 } ],
    }
    var options =
    {
      deep1 : _.define.deep([ 2, 2 ]),
      deep2 : _.define.deep([ [ 2, 2 ], { a : 2 } ]),
    }
    var instance1 = _.blueprint.construct( options )
    test.identical( instance1, exp );

    test.true( !!options.deep1.val );
    test.true( !!options.deep2.val );
    test.true( !!options.deep2.val[ 0 ] );
    test.true( !!options.deep2.val[ 1 ] );

    test.true( instance1.deep1 !== options.deep1.val );
    test.true( instance1.deep2 !== options.deep2.val );
    test.true( instance1.deep2[ 0 ] !== options.deep2.val[ 0 ] );
    test.true( instance1.deep2[ 1 ] !== options.deep2.val[ 1 ] );
  }

  /* */

  test.case = 'map of map';

  if( _.replicate )
  {

    var exp =
    {
      a : 2
    }
    var options = { val2 : { a : 2 }, }
    var instance1 = _.blueprint.construct( options )
    test.identical( instance1, exp );
    test.true( !!options.val2.a );
    test.true( instance1.a === options.val2.a );

  }

  /* */

  test.case = 'throwing';

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => _.blueprint.construct({ val2 : [ 2, 2 ], }) );

  /* */

  function constr1()
  {
    let self = this;
    if( self instanceof constr1 )
    self = { a : 2 }
    else
    self = Object.create( null );
    self.b = 3;
    return self;
  }

}

//

function defineProps( test )
{

  /* */

  test.case = 'val / shallow';

  var exp =
  {
    shallow1 : [ 2, 2 ],
    shallow2 : [ [ 2, 2 ], { a : 2 } ],
    val1 : 2,
    val2 : [ 2, 2 ],
    val3 : { a : 2 },
  }
  var options =
  {
    shallow : _.define.shallows({ shallow1 : [ 2, 2 ], shallow2 : [ [ 2, 2 ], { a : 2 } ] }),
    val : _.define.vals({ val1 : 2, val2 : [ 2, 2 ], val3 : { a : 2 } }),
  }
  var instance1 = _.blueprint.construct( options )
  test.identical( instance1, exp );

  test.true( !!options.shallow[ 0 ].val );
  test.true( !!options.shallow[ 1 ].val );
  test.true( !!options.shallow[ 1 ].val[ 0 ] );
  test.true( !!options.shallow[ 1 ].val[ 1 ] );
  test.true( !!options.val[ 0 ].val );
  test.true( !!options.val[ 1 ].val );
  test.true( !!options.val[ 2 ].val );

  test.true( instance1.shallow1 !== options.shallow[ 0 ].val );
  test.true( instance1.shallow2 !== options.shallow[ 1 ].val );
  test.true( instance1.shallow2[ 0 ] === options.shallow[ 1 ].val[ 0 ] );
  test.true( instance1.shallow2[ 1 ] === options.shallow[ 1 ].val[ 1 ] );
  test.true( instance1.val1 === options.val[ 0 ].val );
  test.true( instance1.val2 === options.val[ 1 ].val );
  test.true( instance1.val3 === options.val[ 2 ].val );

  /* */

  test.case = 'call / new';

  var exp =
  {
    call1 : { b : 3 },
    call2 : { b : 33 },
    new1 : { a : 2, b : 3 },
    new2 : { a : 22, b : 33 },
  }
  var options =
  {
    calls : _.define.calls({ call1 : constr1, call2 : constr2 }),
    news : _.define.news({ new1 : constr1, new2 : constr2 }),
  }
  var instance1 = _.blueprint.construct( options )
  test.identical( instance1, exp );
  test.true( !!options.calls[ 0 ].val );
  test.true( !!options.calls[ 1 ].val );
  test.true( !!options.news[ 0 ].val );
  test.true( !!options.news[ 1 ].val );
  test.true( instance1.call1 !== options.calls[ 0 ].val );
  test.true( instance1.call2 !== options.calls[ 1 ].val );
  test.true( instance1.new1 !== options.news[ 0 ].val );
  test.true( instance1.new2 !== options.news[ 1 ].val );

  /* */

  test.case = 'deep';

  if( _.replicate )
  {
    var exp =
    {
      deep1 : [ 2, 2 ],
      deep2 : [ [ 2, 2 ], { a : 2 } ],
    }
    var options =
    {
      deeps : _.define.deeps({ deep1 : [ 2, 2 ], deep2 : [ [ 2, 2 ], { a : 2 } ] }),
    }
    var instance1 = _.blueprint.construct( options )
    test.identical( instance1, exp );
    test.true( !!options.deeps[ 0 ].val );
    test.true( !!options.deeps[ 1 ].val );
    test.true( !!options.deeps[ 1 ].val[ 0 ] );
    test.true( !!options.deeps[ 1 ].val[ 1 ] );
    test.true( instance1.deep1 !== options.deeps[ 0 ].val );
    test.true( instance1.deep2 !== options.deeps[ 1 ].val );
    test.true( instance1.deep2[ 0 ] !== options.deeps[ 1 ].val[ 0 ] );
    test.true( instance1.deep2[ 1 ] !== options.deeps[ 1 ].val[ 1 ] );
  }

  /* */

  function constr1()
  {
    let self = this;
    if( self instanceof constr1 )
    self = { a : 2 }
    else
    self = Object.create( null );
    self.b = 3;
    return self;
  }

  /* */

  function constr2()
  {
    let self = this;
    if( self instanceof constr2 )
    self = { a : 22 }
    else
    self = Object.create( null );
    self.b = 33;
    return self;
  }

}

//

function definePropStaticBasic( test )
{

  /* */

  test.case = 'basic';
  let m1 = function(){ return 'm1' };
  let sm1 = function(){ return 'sm1' };
  let sm2 = function(){ return 'sm2' };
  let s = _.define.static;
  let ss = _.define.statics;
  let staticsA =
  {
    staticField5 : { k : 'staticField5' },
  }
  let staticsB =
  {
    staticField6 : { k : 'staticField6' },
  }
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    method1 : m1,
    staticMethod1 : s( sm1 ),
    s1 : s( 'sf1' ),
    s2 : s( { k : 's2' } ),
    statics1 : ss
    ({
      staticMethod2 : sm2,
      staticField3 : 'sf3',
      staticField4 : { k : 'staticField4' },
    }),
    statics2 : ss( [ staticsA, staticsB ] )
  });

  var instance = Blueprint1.Make();
  test.identical( instance instanceof Blueprint1.Make, true );

  test.true( !Object.hasOwnProperty.call( instance, 'staticMethod1' ) );
  test.true( !Object.hasOwnProperty.call( instance, 'staticMethod2' ) );
  test.true( !Object.hasOwnProperty.call( instance, 's1' ) );
  test.true( !Object.hasOwnProperty.call( instance, 's2' ) );
  test.true( !Object.hasOwnProperty.call( instance, 'staticField3' ) );
  test.true( !Object.hasOwnProperty.call( instance, 'staticField4' ) );

  test.true( Object.hasOwnProperty.call( Object.getPrototypeOf( instance ), 'staticMethod1' ) );
  test.true( Object.hasOwnProperty.call( Object.getPrototypeOf( instance ), 'staticMethod2' ) );
  test.true( Object.hasOwnProperty.call( Object.getPrototypeOf( instance ), 's1' ) );
  test.true( Object.hasOwnProperty.call( Object.getPrototypeOf( instance ), 's2' ) );
  test.true( Object.hasOwnProperty.call( Object.getPrototypeOf( instance ), 'staticField3' ) );
  test.true( Object.hasOwnProperty.call( Object.getPrototypeOf( instance ), 'staticField4' ) );

  test.description = 'property descriptor'; /* */

  var got = Object.getOwnPropertyDescriptor( Object.getPrototypeOf( instance ), 's1' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    'enumerable' : false,
    'configurable' : true,
  }
  test.identical( got, exp );

  var got = Object.getOwnPropertyDescriptor( Object.getPrototypeOf( instance ), 'staticMethod1' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    'enumerable' : false,
    'configurable' : true,
  }
  test.identical( got, exp );

  test.description = 'all properties';  /* */

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'method1' : m1,
    'staticMethod1' : sm1,
    'staticMethod2' : sm2,
    's1' : 'sf1',
    's2' : { 'k' : 's2' },
    'staticField3' : 'sf3',
    'staticField4' : { 'k' : 'staticField4' },
    'staticField5' : { 'k' : 'staticField5' },
    'staticField6' : { 'k' : 'staticField6' }
  }
  test.identical( _.property.all( instance ), exp );

  test.description = 'own properties'; /* */

  test.identical( _.prototype.each( instance ).length, 3 );
  var exp = { 'field1' : 'b1', 'field2' : 'b1', 'method1' : m1 }
  test.identical( propertyOwn( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    'staticMethod1' : sm1,
    'staticMethod2' : sm2,
    's1' : 'sf1',
    's2' : { 'k' : 's2' },
    'staticField3' : 'sf3',
    'staticField4' : { 'k' : 'staticField4' },
    'staticField5' : { 'k' : 'staticField5' },
    'staticField6' : { 'k' : 'staticField6' }
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance )[ 2 ] ), exp );

  test.true( Blueprint1.Make.s1 === Blueprint1.prototype.s1 );
  test.true( Blueprint1.Make.s2 === Blueprint1.prototype.s2 );
  test.true( Blueprint1.Make.staticField3 === Blueprint1.prototype.staticField3 );
  test.true( Blueprint1.Make.staticField4 === Blueprint1.prototype.staticField4 );
  test.true( Blueprint1.Make.staticField5 === Blueprint1.prototype.staticField5 );
  test.true( Blueprint1.Make.staticField6 === Blueprint1.prototype.staticField6 );
  test.true( Blueprint1.Make.staticMethod1 === Blueprint1.prototype.staticMethod1 );
  test.true( Blueprint1.Make.staticMethod2 === Blueprint1.prototype.staticMethod2 );

  /* */

}

definePropStaticBasic.description =
`
- static fields added to prototype
`

//

function definePropStaticInheritance( test )
{
  let context = this;
  let s = _.define.static;

  /* */

  test.case = 'classes';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    name : _.trait.name( 'Blueprint1X' ),
    field1 : 'b1',
    field2 : 'b1',
    method1 : function(){},
    method2 : function(){},
    StaticField1 : s( 'b1' ),
    StaticField2 : s( 'b1' ),
    StaticMethod1 : s( function(){} ),
    StaticMethod2 : s( function(){} ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    name : _.trait.name( 'Blueprint2X' ),
    field2 : 'b2',
    field3 : 'b2',
    method2 : function(){},
    method3 : function(){},
    StaticField2 : s( 'b2' ),
    StaticField3 : s( 'b2' ),
    StaticMethod2 : s( function(){} ),
    StaticMethod3 : s( function(){} ),
  });

  test.true( !!Blueprint1.Make.StaticField1 );
  test.true( !!Blueprint1.Make.StaticField2 );
  test.true( !Blueprint1.Make.StaticField3 );
  test.true( Blueprint1.Make.StaticField1 === Blueprint1.prototype.StaticField1 );
  test.true( Blueprint1.Make.StaticField2 === Blueprint1.prototype.StaticField2 );
  test.true( Blueprint1.Make.StaticField3 === Blueprint1.prototype.StaticField3 );
  test.true( Blueprint1.Make.StaticMethod1 === Blueprint1.prototype.StaticMethod1 );
  test.true( Blueprint1.Make.StaticMethod2 === Blueprint1.prototype.StaticMethod2 );
  test.true( Blueprint1.Make.StaticMethod3 === Blueprint1.prototype.StaticMethod3 );

  test.true( !!Blueprint2.Make.StaticField1 );
  test.true( !!Blueprint2.Make.StaticField2 );
  test.true( !!Blueprint2.Make.StaticField3 );
  test.true( Blueprint2.Make.StaticField1 === Blueprint2.prototype.StaticField1 );
  test.true( Blueprint2.Make.StaticField2 === Blueprint2.prototype.StaticField2 );
  test.true( Blueprint2.Make.StaticField3 === Blueprint2.prototype.StaticField3 );
  test.true( Blueprint2.Make.StaticMethod1 === Blueprint2.prototype.StaticMethod1 );
  test.true( Blueprint2.Make.StaticMethod2 === Blueprint2.prototype.StaticMethod2 );
  test.true( Blueprint2.Make.StaticMethod3 === Blueprint2.prototype.StaticMethod3 );

  test.true( Blueprint2.Make.StaticField1 === Blueprint1.Make.StaticField1 );
  test.true( Blueprint2.Make.StaticField2 !== Blueprint1.Make.StaticField2 );
  test.true( Blueprint2.Make.StaticField3 !== Blueprint1.Make.StaticField3 );
  test.true( Blueprint2.Make.StaticMethod1 === Blueprint1.Make.StaticMethod1 );
  test.true( Blueprint2.Make.StaticMethod2 !== Blueprint1.Make.StaticMethod2 );
  test.true( Blueprint2.Make.StaticMethod3 !== Blueprint1.Make.StaticMethod3 );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint2.Make();
  test.identical( instance1 instanceof Blueprint1.Make, true );
  test.identical( instance1 instanceof Blueprint2.Make, true );
  test.true( _.routineIs( instance1.constructor ) );
  test.identical( instance1.constructor.name, 'Blueprint2X' );

  test.description = 'all properites'; /* */

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'method1' : Blueprint1.PropsExtension.method1,
    'method2' : Blueprint2.PropsExtension.method2,
    'method3' : Blueprint2.PropsExtension.method3,
    'StaticField1' : 'b1',
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'StaticMethod1' : Blueprint1.prototype.StaticMethod1,
    'StaticMethod2' : Blueprint2.prototype.StaticMethod2,
    'StaticMethod3' : Blueprint2.prototype.StaticMethod3,
    'constructor' : Blueprint2.Make
  }
  test.identical( _.property.all( instance1 ), exp );

  test.description = 'own properites'; /* */

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'method1' : Blueprint1.PropsExtension.method1,
    'method2' : Blueprint2.PropsExtension.method2,
    'method3' : Blueprint2.PropsExtension.method3,
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'StaticMethod2' : Blueprint2.prototype.StaticMethod2,
    'StaticMethod3' : Blueprint2.prototype.StaticMethod3,
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'StaticMethod1' : Blueprint1.prototype.StaticMethod1,
    'StaticMethod2' : Blueprint1.prototype.StaticMethod2,
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 3 ] ), exp );

  test.description = '_.mapExtend( null, instance1 )'; /* */

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'method1' : Blueprint1.PropsExtension.method1,
    'method2' : Blueprint2.PropsExtension.method2,
    'method3' : Blueprint2.PropsExtension.method3,
  }
  var got = _.mapExtend( null, instance1 );
  test.identical( got, exp );

  test.description = '_.mapExtend( instance1, src )'; /* */

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'new',
    'field3' : 'b2',
    'method1' : Blueprint1.PropsExtension.method1,
    'method2' : 'new',
    'method3' : Blueprint2.PropsExtension.method3,
  }
  var src =
  {
    'field2' : 'new',
    'method2' : 'new',
    'StaticField1' : 'new',
    'StaticField2' : 'new',
    'StaticField3' : 'new',
    'StaticMethod1' : 'new',
    'StaticMethod2' : 'new',
    'StaticMethod3' : 'new',
  }
  var got = _.mapExtend( instance1, src );
  test.true( got === instance1 );

  test.description = 'proto chain';
  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'new',
    'field3' : 'b2',
    'method1' : Blueprint1.PropsExtension.method1,
    'method2' : 'new',
    'method3' : Blueprint2.PropsExtension.method3,
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'new',
    'StaticField3' : 'new',
    'StaticMethod2' : 'new',
    'StaticMethod3' : Blueprint2.prototype.StaticMethod3,
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'new',
    'StaticField2' : 'b1',
    'StaticMethod1' : 'new',
    'StaticMethod2' : Blueprint1.prototype.StaticMethod2,
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 3 ] ), exp );

  test.description = 'StaticField1';
  test.true( instance1.StaticField1 === src.StaticField1 );
  test.true( instance1.StaticField1 === Blueprint1.Make.StaticField1 );
  test.true( instance1.StaticField1 === Blueprint2.Make.StaticField1 );
  test.true( instance1.StaticField1 === Blueprint1.prototype.StaticField1 );
  test.true( instance1.StaticField1 === Blueprint2.prototype.StaticField1 );
  test.true( !!Blueprint1.prototype.StaticField1 );
  test.true( !!Blueprint2.prototype.StaticField1 );

  test.description = 'StaticField2';
  test.true( instance1.StaticField2 === src.StaticField2 );
  test.true( instance1.StaticField2 !== Blueprint1.Make.StaticField2 );
  test.true( instance1.StaticField2 === Blueprint2.Make.StaticField2 );
  test.true( instance1.StaticField2 !== Blueprint1.prototype.StaticField2 );
  test.true( instance1.StaticField2 === Blueprint2.prototype.StaticField2 );
  test.true( !!Blueprint1.prototype.StaticField2 );
  test.true( !!Blueprint2.prototype.StaticField2 );

  test.description = 'StaticField3';
  test.true( instance1.StaticField3 === src.StaticField3 );
  test.true( instance1.StaticField3 !== Blueprint1.Make.StaticField3 );
  test.true( instance1.StaticField3 === Blueprint2.Make.StaticField3 );
  test.true( instance1.StaticField3 !== Blueprint1.prototype.StaticField3 );
  test.true( instance1.StaticField3 === Blueprint2.prototype.StaticField3 );
  test.true( !Blueprint1.prototype.StaticField3 );
  test.true( !!Blueprint2.prototype.StaticField3 );

  test.description = 'StaticMethod1';
  test.true( instance1.StaticMethod1 === src.StaticMethod1 );
  test.true( instance1.StaticMethod1 === Blueprint1.Make.StaticMethod1 );
  test.true( instance1.StaticMethod1 === Blueprint2.Make.StaticMethod1 );
  test.true( instance1.StaticMethod1 === Blueprint1.prototype.StaticMethod1 );
  test.true( instance1.StaticMethod1 === Blueprint2.prototype.StaticMethod1 );
  test.true( !!Blueprint1.prototype.StaticMethod1 );
  test.true( !!Blueprint2.prototype.StaticMethod1 );

  test.description = 'StaticMethod2';
  test.true( instance1.StaticMethod2 === src.StaticMethod2 );
  test.true( instance1.StaticMethod2 !== Blueprint1.Make.StaticMethod2 );
  test.true( instance1.StaticMethod2 === Blueprint2.Make.StaticMethod2 );
  test.true( instance1.StaticMethod2 !== Blueprint1.prototype.StaticMethod2 );
  test.true( instance1.StaticMethod2 === Blueprint2.prototype.StaticMethod2 );
  test.true( !!Blueprint1.prototype.StaticMethod2 );
  test.true( !!Blueprint2.prototype.StaticMethod2 );

  test.description = 'StaticMethod3';
  test.true( instance1.StaticMethod3 === src.StaticMethod3 );
  test.true( instance1.StaticMethod3 !== Blueprint1.Make.StaticMethod3 );
  test.true( instance1.StaticMethod3 === Blueprint2.Make.StaticMethod3 );
  test.true( instance1.StaticMethod3 !== Blueprint1.prototype.StaticMethod3 );
  test.true( instance1.StaticMethod3 === Blueprint2.prototype.StaticMethod3 );
  test.true( !Blueprint1.prototype.StaticMethod3 );
  test.true( !!Blueprint2.prototype.StaticMethod3 );

  /* */

}

//

function definePropStaticMaybeAmendConstruction( test )
{
  let context = this;

  eachTyped({ amending : 'extend', accessor : 0, typed : _.nothing });

  function eachTyped( tops )
  {
    tops.typed = _.nothing;
    eachAccessor( tops );
    tops.typed = _.maybe;
    eachAccessor( tops );
    tops.typed = 0;
    eachAccessor( tops );
    tops.typed = 1;
    eachAccessor( tops );
  }

  function eachAccessor( tops )
  {
    tops.accessor = 0;
    eachAmending( tops );
    tops.accessor = 1;
    eachAmending( tops );
  }

  function eachAmending( tops )
  {
    tops.amending = 'extend';
    eachCase( tops );
    tops.amending = 'supplement';
    eachCase( tops );
  }

  function eachCase( tops )
  {

    /* - */

    test.case = `typed:${_.toStr( tops.typed )}, accessor:${_.toStr( tops.accessor )}, amending:${_.toStr( tops.amending )}, pure map`;

    var dstContainer = Object.create( null );

    var extension = { s1 : _.define.prop( 1, { static : _.maybe, accessor : tops.accessor } ) };
    if( tops.typed !== _.nothing )
    extension.typed = _.trait.typed( tops.typed );

    var keysBefore = _.mapAllKeys( Object.prototype );
    var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    if( tops.typed === 1 )
    test.identical( _.prototype.each( dstContainer ).length, 3 );
    else
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    var exp =
    {
    }
    if( tops.typed !== 1 )
    {
      exp.s1 = 1;
    }
    if( tops.accessor && tops.typed !== 1 )
    {
      exp._ = Object.create( null );
      exp._.s1 = 1;
    }
    test.identical( _.property.onlyOwn( dstContainer, { onlyEnumerable : 0 } ), exp );

    if( tops.typed === 1 )
    {
      var exp =
      {
        s1 : 1,
      }
      if( tops.accessor )
      {
        exp._ = Object.create( null );
        exp._.s1 = 1;
      }
      test.identical( _.property.onlyOwn( _.prototype.of( dstContainer ), { onlyEnumerable : 0 } ), exp );
    }

    /* */

    test.case = `typed:${_.toStr( tops.typed )}, accessor:${_.toStr( tops.accessor )}, amending:${_.toStr( tops.amending )}, pure map, rewriting in instance`;

    var dstContainer = Object.create( null );
    dstContainer.s1 = 0;

    var extension = { s1 : _.define.prop( 1, { static : _.maybe, accessor : tops.accessor } ) };
    if( tops.typed !== _.nothing )
    extension.typed = _.trait.typed( tops.typed );

    var keysBefore = _.mapAllKeys( Object.prototype );
    var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    if( tops.typed === 1 )
    test.identical( _.prototype.each( dstContainer ).length, 3 );
    else
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    var exp =
    {
      s1 : 0,
    }
    if( tops.typed !== 1 )
    {
      if( tops.amending === 'extend' )
      exp.s1 = 1;
    }
    if( tops.accessor && tops.typed !== 1 )
    {
      exp._ = Object.create( null );
      if( tops.amending === 'extend' )
      exp._.s1 = 1;
      else
      exp._.s1 = 0;
    }
    test.identical( _.property.onlyOwn( dstContainer, { onlyEnumerable : 0 } ), exp );

    if( tops.typed === 1 )
    {
      var exp =
      {
        s1 : 1,
      }
      if( tops.accessor )
      {
        exp._ = Object.create( null );
        exp._.s1 = 1;
      }
      test.identical( _.property.onlyOwn( _.prototype.of( dstContainer ), { onlyEnumerable : 0 } ), exp );
    }

    /* */

    test.case = `typed:${_.toStr( tops.typed )}, accessor:${_.toStr( tops.accessor )}, amending:${_.toStr( tops.amending )}, polluted map`;

    var dstContainer = {};

    var extension = { s1 : _.define.prop( 1, { static : _.maybe, accessor : tops.accessor } ) };
    if( tops.typed !== _.nothing )
    extension.typed = _.trait.typed( tops.typed );

    var keysBefore = _.mapAllKeys( Object.prototype );
    var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    if( tops.typed === 1 )
    test.identical( _.prototype.each( dstContainer ).length, 3 );
    else
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    var exp =
    {
    }
    if( tops.typed !== 1 )
    {
      exp.s1 = 1;
    }
    if( tops.accessor && tops.typed !== 1 )
    {
      exp._ = Object.create( null );
      exp._.s1 = 1;
    }
    test.identical( _.property.onlyOwn( dstContainer, { onlyEnumerable : 0 } ), exp );

    if( tops.typed === 1 )
    {
      var exp =
      {
        s1 : 1,
      }
      if( tops.accessor )
      {
        exp._ = Object.create( null );
        exp._.s1 = 1;
      }
      test.identical( _.property.onlyOwn( _.prototype.of( dstContainer ), { onlyEnumerable : 0 } ), exp );
    }

    /* */

    test.case = `typed:${_.toStr( tops.typed )}, accessor:${_.toStr( tops.accessor )}, amending:${_.toStr( tops.amending )}, polluted map, rewriting in instance`;

    var dstContainer = {};
    dstContainer.s1 = 0;

    var extension = { s1 : _.define.prop( 1, { static : _.maybe, accessor : tops.accessor } ) };
    if( tops.typed !== _.nothing )
    extension.typed = _.trait.typed( tops.typed );

    var keysBefore = _.mapAllKeys( Object.prototype );
    var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    if( tops.typed === 1 )
    test.identical( _.prototype.each( dstContainer ).length, 3 );
    else
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    var exp =
    {
      s1 : 0,
    }
    if( tops.typed !== 1 )
    {
      if( tops.amending === 'extend' )
      exp.s1 = 1;
    }
    if( tops.accessor && tops.typed !== 1 )
    {
      exp._ = Object.create( null );
      if( tops.amending === 'extend' )
      exp._.s1 = 1;
      else
      exp._.s1 = 0;
    }
    test.identical( _.property.onlyOwn( dstContainer, { onlyEnumerable : 0 } ), exp );

    if( tops.typed === 1 )
    {
      var exp =
      {
        s1 : 1,
      }
      if( tops.accessor )
      {
        exp._ = Object.create( null );
        exp._.s1 = 1;
      }
      test.identical( _.property.onlyOwn( _.prototype.of( dstContainer ), { onlyEnumerable : 0 } ), exp );
    }

    /* */

    test.case = `typed:${_.toStr( tops.typed )}, accessor:${_.toStr( tops.accessor )}, amending:${_.toStr( tops.amending )}, object`;

    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );

    var extension = { s1 : _.define.prop( 1, { static : _.maybe, accessor : tops.accessor } ) };
    if( tops.typed !== _.nothing )
    extension.typed = _.trait.typed( tops.typed );

    var keysBefore = _.mapAllKeys( Object.prototype );
    var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    if( tops.typed === 1 )
    test.identical( _.prototype.each( dstContainer ).length, 3 );
    else if( tops.typed === 0 )
    test.identical( _.prototype.each( dstContainer ).length, 1 );
    else
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    var exp =
    {
    }
    if( tops.typed === 0 )
    {
      exp.s1 = 1;
    }
    if( tops.accessor && tops.typed === 0 )
    {
      exp._ = Object.create( null );
      exp._.s1 = 1;
    }
    test.identical( _.property.onlyOwn( dstContainer, { onlyEnumerable : 0 } ), exp );

    if( tops.typed === 1 )
    {
      var exp =
      {
        s1 : 1,
      }
      if( tops.accessor )
      {
        exp._ = Object.create( null );
        exp._.s1 = 1;
      }
      test.identical( _.property.onlyOwn( _.prototype.of( dstContainer ), { onlyEnumerable : 0 } ), exp );
    }

    /* */

    test.case = `typed:${_.toStr( tops.typed )}, accessor:${_.toStr( tops.accessor )}, amending:${_.toStr( tops.amending )}, object, rewriting in instance`;

    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );
    dstContainer.s1 = 0;

    var extension = { s1 : _.define.prop( 1, { static : _.maybe, accessor : tops.accessor } ) };
    if( tops.typed !== _.nothing )
    extension.typed = _.trait.typed( tops.typed );

    var keysBefore = _.mapAllKeys( Object.prototype );
    var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    if( tops.typed === 1 )
    test.identical( _.prototype.each( dstContainer ).length, 3 );
    else if( tops.typed === 0 )
    test.identical( _.prototype.each( dstContainer ).length, 1 );
    else
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    var exp =
    {
      s1 : 0,
    }
    if( tops.typed === 0 )
    {
      if( tops.amending === 'extend' )
      exp.s1 = 1;
    }
    if( tops.accessor && tops.typed === 0 )
    {
      exp._ = Object.create( null );
      if( tops.amending === 'extend' )
      exp._.s1 = 1;
      else
      exp._.s1 = 0;
    }
    test.identical( _.property.onlyOwn( dstContainer, { onlyEnumerable : 0 } ), exp );

    if( tops.typed === 1 )
    {
      var exp =
      {
        s1 : 1,
      }
      if( tops.accessor )
      {
        exp._ = Object.create( null );
        exp._.s1 = 1;
      }
      test.identical( _.property.onlyOwn( _.prototype.of( dstContainer ), { onlyEnumerable : 0 } ), exp );
    }

    /* */

    test.case = `typed:${_.toStr( tops.typed )}, accessor:${_.toStr( tops.accessor )}, amending:${_.toStr( tops.amending )}, object, rewriting in prototype`;

    var prototype = Object.create( null );
    prototype.s1 = 0;
    var dstContainer = Object.create( prototype );

    var extension = { s1 : _.define.prop( 1, { static : _.maybe, accessor : tops.accessor } ) };
    if( tops.typed !== _.nothing )
    extension.typed = _.trait.typed( tops.typed );

    var keysBefore = _.mapAllKeys( Object.prototype );
    var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    if( tops.typed === 1 )
    test.identical( _.prototype.each( dstContainer ).length, 3 );
    else if( tops.typed === 0 )
    test.identical( _.prototype.each( dstContainer ).length, 1 );
    else
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    var exp =
    {
    }
    if( tops.typed === 0 )
    {
      exp.s1 = 1;
    }
    if( tops.accessor && tops.typed === 0 )
    {
      exp._ = Object.create( null );
      exp._.s1 = 1;
    }
    test.identical( _.property.onlyOwn( dstContainer, { onlyEnumerable : 0 } ), exp );

    if( tops.typed === 1 )
    {
      var exp =
      {
        s1 : 0,
      }
      if( tops.amending === 'extend' || tops.typed === 1 )
      exp.s1 = 1;
      if( tops.accessor )
      {
        exp._ = Object.create( null );
        if( tops.amending === 'extend' || tops.typed === 1 )
        exp._.s1 = 1;
        else
        exp._.s1 = 0;
      }
      test.identical( _.property.onlyOwn( _.prototype.of( dstContainer ), { onlyEnumerable : 0 } ), exp );
    }

    /* - */

  }

}

definePropStaticMaybeAmendConstruction.timeOut = 30000;

//

function definePropEnumerable( test )
{
  let context = this;
  let s = _.define.static;
  let p = _.define.prop;

  /* */

  test.case = 'enumerable : null';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    field1 : p( 'b1', { enumerable : null } ),
    field2 : p( 'b1', { enumerable : null } ),
    StaticField1 : s( 'b1', { enumerable : null } ),
    StaticField2 : s( 'b1', { enumerable : null } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : p( 'b2', { enumerable : null } ),
    field3 : p( 'b2', { enumerable : null } ),
    StaticField2 : s( 'b2', { enumerable : null } ),
    StaticField3 : s( 'b2', { enumerable : null } ),
  });

  test.description = 'descriptor of Blueprint1.StaticField1';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.Make, 'StaticField1' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'StaticField1' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint1.StaticField2';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.Make, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.StaticField2';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.Make, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.StaticField3';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.Make, 'StaticField3' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'StaticField3' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint2.Make();

  test.description = 'all properites'; /* */

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'StaticField1' : 'b1',
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( _.property.all( instance1 ), exp );

  test.description = 'own properites'; /* */

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 3 ] ), exp );

  test.description = '_.mapExtend( null, instance1 )'; /* */
  var exp =
  {
    'field1' : 'b1', 'field2' : 'b2', 'field3' : 'b2'
  }
  var got = _.mapExtend( null, instance1 );
  test.identical( got, exp );

  test.description = 'descriptor of instance.field1';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field1' );
  var exp =
  {
    value : 'b1',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field2';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field2' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field3';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field3' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  /* */

  test.case = 'enumerable : 0';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    field1 : p( 'b1', { enumerable : 0 } ),
    field2 : p( 'b1', { enumerable : 0 } ),
    StaticField1 : s( 'b1', { enumerable : 0 } ),
    StaticField2 : s( 'b1', { enumerable : 0 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : p( 'b2', { enumerable : 0 } ),
    field3 : p( 'b2', { enumerable : 0 } ),
    StaticField2 : s( 'b2', { enumerable : 0 } ),
    StaticField3 : s( 'b2', { enumerable : 0 } ),
  });

  test.description = 'descriptor of Blueprint1.StaticField1';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.Make, 'StaticField1' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'StaticField1' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint1.StaticField2';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.Make, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.StaticField2';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.Make, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.StaticField3';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.Make, 'StaticField3' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'StaticField3' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint2.Make();

  test.description = 'all properites'; /* */

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'StaticField1' : 'b1',
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( _.property.all( instance1 ), exp );

  test.description = 'own properites'; /* */

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 3 ] ), exp );

  test.description = '_.mapExtend( null, instance1 )'; /* */
  var exp =
  {
  }
  var got = _.mapExtend( null, instance1 );
  test.identical( got, exp );

  test.description = 'descriptor of instance.field1';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field1' );
  var exp =
  {
    value : 'b1',
    enumerable : false,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field2';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field2' );
  var exp =
  {
    value : 'b2',
    enumerable : false,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field3';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field3' );
  var exp =
  {
    value : 'b2',
    enumerable : false,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  /* */

  test.case = 'enumerable : 1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    field1 : p( 'b1', { enumerable : 1 } ),
    field2 : p( 'b1', { enumerable : 1 } ),
    StaticField1 : s( 'b1', { enumerable : 1 } ),
    StaticField2 : s( 'b1', { enumerable : 1 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : p( 'b2', { enumerable : 1 } ),
    field3 : p( 'b2', { enumerable : 1 } ),
    StaticField2 : s( 'b2', { enumerable : 1 } ),
    StaticField3 : s( 'b2', { enumerable : 1 } ),
  });

  test.description = 'descriptor of Blueprint1.StaticField1';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.Make, 'StaticField1' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : true,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'StaticField1' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : true,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint1.StaticField2';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.Make, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : true,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : true,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.StaticField2';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.Make, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : true,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : true,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.StaticField3';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.Make, 'StaticField3' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : true,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'StaticField3' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : true,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint2.Make();

  test.description = 'all properites'; /* */

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'StaticField1' : 'b1',
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( _.property.all( instance1 ), exp );

  test.description = 'own properites'; /* */

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 3 ] ), exp );

  test.description = '_.mapExtend( null, instance1 )'; /* */
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'StaticField1' : 'b1'
  }
  var got = _.mapExtend( null, instance1 );
  test.identical( got, exp );

  test.description = 'descriptor of instance.field1';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field1' );
  var exp =
  {
    value : 'b1',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field2';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field2' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field3';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field3' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  /* */

}

//

function definePropWritable( test )
{
  let context = this;
  let s = _.define.static;
  let p = _.define.prop;

  /* */

  test.case = 'writable : null';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    field1 : p( 'b1', { writable : null } ),
    field2 : p( 'b1', { writable : null } ),
    StaticField1 : s( 'b1', { writable : null } ),
    StaticField2 : s( 'b1', { writable : null } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : p( 'b2', { writable : null } ),
    field3 : p( 'b2', { writable : null } ),
    StaticField2 : s( 'b2', { writable : null } ),
    StaticField3 : s( 'b2', { writable : null } ),
  });

  test.description = 'descriptor of Blueprint1.StaticField1';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.Make, 'StaticField1' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'StaticField1' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint1.StaticField2';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.Make, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.StaticField2';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.Make, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.StaticField3';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.Make, 'StaticField3' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'StaticField3' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint2.Make();

  test.description = 'all properites'; /* */

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'StaticField1' : 'b1',
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( _.property.all( instance1 ), exp );

  test.description = 'own properites'; /* */
  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 3 ] ), exp );

  test.description = '_.mapExtend( null, instance1 )'; /* */
  var exp =
  {
    'field1' : 'b1', 'field2' : 'b2', 'field3' : 'b2'
  }
  var got = _.mapExtend( null, instance1 );
  test.identical( got, exp );

  test.description = 'descriptor of instance.field1';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field1' );
  var exp =
  {
    value : 'b1',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field2';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field2' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field3';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field3' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = '_.mapExtend( instance1, src )'; /* */
  var exp =
  {
    'field1' : 'ext',
    'field2' : 'ext',
    'field3' : 'b2',
    'StaticField1' : 'ext',
    'StaticField2' : 'ext',
    'StaticField3' : 'b2',
    'constructor' : instance1.constructor,
  }
  var ext =
  {
    'field1' : 'ext',
    'field2' : 'ext',
    'StaticField1' : 'ext',
    'StaticField2' : 'ext',
  }
  var got = _.mapExtend( instance1, ext );
  test.identical( _.property.all( instance1 ), exp );

  test.description = 'descriptor of instance.field1';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field1' );
  var exp =
  {
    value : 'ext',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field2';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field2' );
  var exp =
  {
    value : 'ext',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field3';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field3' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  /* */

  test.case = 'writable : 1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    field1 : p( 'b1', { writable : 1 } ),
    field2 : p( 'b1', { writable : 1 } ),
    StaticField1 : s( 'b1', { writable : 1 } ),
    StaticField2 : s( 'b1', { writable : 1 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : p( 'b2', { writable : 1 } ),
    field3 : p( 'b2', { writable : 1 } ),
    StaticField2 : s( 'b2', { writable : 1 } ),
    StaticField3 : s( 'b2', { writable : 1 } ),
  });

  test.description = 'descriptor of Blueprint1.StaticField1';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.Make, 'StaticField1' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'StaticField1' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint1.StaticField2';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.Make, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.StaticField2';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.Make, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.StaticField3';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.Make, 'StaticField3' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'StaticField3' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint2.Make();

  test.description = 'all properites'; /* */

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'StaticField1' : 'b1',
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( _.property.all( instance1 ), exp );

  test.description = 'own properites'; /* */
  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 3 ] ), exp );

  test.description = '_.mapExtend( null, instance1 )'; /* */
  var exp =
  {
    'field1' : 'b1', 'field2' : 'b2', 'field3' : 'b2'
  }
  var got = _.mapExtend( null, instance1 );
  test.identical( got, exp );

  test.description = 'descriptor of instance.field1';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field1' );
  var exp =
  {
    value : 'b1',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field2';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field2' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field3';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field3' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = '_.mapExtend( instance1, src )'; /* */
  var exp =
  {
    'field1' : 'ext',
    'field2' : 'ext',
    'field3' : 'b2',
    'StaticField1' : 'ext',
    'StaticField2' : 'ext',
    'StaticField3' : 'b2',
    'constructor' : instance1.constructor,
  }
  var ext =
  {
    'field1' : 'ext',
    'field2' : 'ext',
    'StaticField1' : 'ext',
    'StaticField2' : 'ext',
  }
  var got = _.mapExtend( instance1, ext );
  test.identical( _.property.all( instance1 ), exp );

  test.description = 'descriptor of instance.field1';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field1' );
  var exp =
  {
    value : 'ext',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field2';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field2' );
  var exp =
  {
    value : 'ext',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field3';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field3' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  /* */

  test.case = 'writable : 0';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    field1 : p( 'b1', { writable : 0 } ),
    field2 : p( 'b1', { writable : 0 } ),
    StaticField1 : s( 'b1', { writable : 0 } ),
    StaticField2 : s( 'b1', { writable : 0 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : p( 'b2', { writable : 0 } ),
    field3 : p( 'b2', { writable : 0 } ),
    StaticField2 : s( 'b2', { writable : 0 } ),
    StaticField3 : s( 'b2', { writable : 0 } ),
  });

  test.description = 'descriptor of Blueprint1.StaticField1';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.Make, 'StaticField1' );
  var exp =
  {
    value : 'b1',
    writable : false,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'StaticField1' );
  var exp =
  {
    value : 'b1',
    writable : false,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint1.StaticField2';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.Make, 'StaticField2' );
  var exp =
  {
    value : 'b1',
    writable : false,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'StaticField2' );
  var exp =
  {
    value : 'b1',
    writable : false,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.StaticField2';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.Make, 'StaticField2' );
  var exp =
  {
    value : 'b2',
    writable : false,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'StaticField2' );
  var exp =
  {
    value : 'b2',
    writable : false,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.StaticField3';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.Make, 'StaticField3' );
  var exp =
  {
    value : 'b2',
    writable : false,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'StaticField3' );
  var exp =
  {
    value : 'b2',
    writable : false,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint2.Make();

  test.description = 'all properites'; /* */

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'StaticField1' : 'b1',
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( _.property.all( instance1 ), exp );

  test.description = 'own properites'; /* */
  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 3 ] ), exp );

  test.description = '_.mapExtend( null, instance1 )'; /* */
  var exp =
  {
    'field1' : 'b1', 'field2' : 'b2', 'field3' : 'b2'
  }
  var got = _.mapExtend( null, instance1 );
  test.identical( got, exp );

  test.description = 'descriptor of instance.field1';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field1' );
  var exp =
  {
    value : 'b1',
    enumerable : true,
    configurable : true,
    writable : false,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field2';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field2' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : false,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field3';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field3' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : false,
  }
  test.identical( got, exp );

  test.description = '_.mapExtend( instance1, src )'; /* */
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'StaticField1' : 'b1',
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : instance1.constructor,
  }
  var ext =
  {
    'field1' : 'ext',
    'field2' : 'ext',
    'StaticField1' : 'ext',
    'StaticField2' : 'ext',
  }
  test.shouldThrowErrorSync( () => _.mapExtend( instance1, ext ) );
  test.identical( _.property.all( instance1 ), exp );

  test.description = 'descriptor of instance.field1';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field1' );
  var exp =
  {
    value : 'b1',
    enumerable : true,
    configurable : true,
    writable : false,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field2';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field2' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : false,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field3';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field3' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : false,
  }
  test.identical( got, exp );

  /* */

}

//

function definePropConfigurable( test )
{
  let context = this;
  let s = _.define.static;
  let p = _.define.prop;

  /* */

  test.case = 'writing, configurable : null';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    field1 : p( 'b1', { configurable : null } ),
    field2 : p( 'b1', { configurable : null } ),
    StaticField1 : s( 'b1', { configurable : null } ),
    StaticField2 : s( 'b1', { configurable : null } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : p( 'b2', { configurable : null } ),
    field3 : p( 'b2', { configurable : null } ),
    StaticField2 : s( 'b2', { configurable : null } ),
    StaticField3 : s( 'b2', { configurable : null } ),
  });

  test.description = 'descriptor of Blueprint1.StaticField1';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.Make, 'StaticField1' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'StaticField1' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint1.StaticField2';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.Make, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.StaticField2';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.Make, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.StaticField3';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.Make, 'StaticField3' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'StaticField3' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint2.Make();

  test.description = 'all properites'; /* */

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'StaticField1' : 'b1',
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( _.property.all( instance1 ), exp );

  test.description = 'own properites'; /* */
  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 3 ] ), exp );

  test.description = '_.mapExtend( null, instance1 )'; /* */
  var exp =
  {
    'field1' : 'b1', 'field2' : 'b2', 'field3' : 'b2'
  }
  var got = _.mapExtend( null, instance1 );
  test.identical( got, exp );

  test.description = 'descriptor of instance.field1';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field1' );
  var exp =
  {
    value : 'b1',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field2';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field2' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field3';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field3' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = '_.mapExtend( instance1, src )'; /* */
  var exp =
  {
    'field1' : 'ext',
    'field2' : 'ext',
    'field3' : 'b2',
    'StaticField1' : 'ext',
    'StaticField2' : 'ext',
    'StaticField3' : 'b2',
    'constructor' : instance1.constructor,
  }
  var ext =
  {
    'field1' : 'ext',
    'field2' : 'ext',
    'StaticField1' : 'ext',
    'StaticField2' : 'ext',
  }
  var got = _.mapExtend( instance1, ext );
  test.identical( _.property.all( instance1 ), exp );

  test.description = 'descriptor of instance.field1';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field1' );
  var exp =
  {
    value : 'ext',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field2';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field2' );
  var exp =
  {
    value : 'ext',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field3';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field3' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  /* */

  test.case = 'deleting, configurable : null';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    field1 : p( 'b1', { configurable : null } ),
    field2 : p( 'b1', { configurable : null } ),
    StaticField1 : s( 'b1', { configurable : null } ),
    StaticField2 : s( 'b1', { configurable : null } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : p( 'b2', { configurable : null } ),
    field3 : p( 'b2', { configurable : null } ),
    StaticField2 : s( 'b2', { configurable : null } ),
    StaticField3 : s( 'b2', { configurable : null } ),
  });

  var instance1 = Blueprint2.Make();

  test.description = 'in instance'; /* */

  delete instance1.field2;
  delete instance1.StaticField2;
  delete instance1.StaticField3;

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 3 ] ), exp );
  test.true( Blueprint1.Make.StaticField1 === 'b1' );
  test.true( Blueprint1.Make.StaticField2 === 'b1' );
  test.true( Blueprint1.Make.StaticField3 === undefined );
  test.true( Blueprint2.Make.StaticField1 === 'b1' );
  test.true( Blueprint2.Make.StaticField2 === 'b2' );
  test.true( Blueprint2.Make.StaticField3 === 'b2' );

  test.description = 'in prototype'; /* */

  delete Blueprint1.prototype.StaticField1;
  delete Blueprint2.prototype.StaticField2;
  delete Blueprint2.prototype.StaticField3;

  var exp =
  {
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( Blueprint2.prototype ), exp );
  var exp =
  {
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( Blueprint1.prototype ), exp );

  test.true( Blueprint1.Make.StaticField1 === 'b1' );
  test.true( Blueprint1.Make.StaticField2 === 'b1' );
  test.true( Blueprint1.Make.StaticField3 === undefined );
  test.true( Blueprint2.Make.StaticField1 === 'b1' );
  test.true( Blueprint2.Make.StaticField2 === 'b2' );
  test.true( Blueprint2.Make.StaticField3 === 'b2' );

  test.description = 'in class'; /* */

  delete Blueprint1.Make.StaticField1;
  delete Blueprint2.Make.StaticField2;
  delete Blueprint2.Make.StaticField3;

  var exp =
  {
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( Blueprint2.prototype ), exp );
  var exp =
  {
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( Blueprint1.prototype ), exp );

  test.true( Blueprint1.Make.StaticField1 === undefined );
  test.true( Blueprint1.Make.StaticField2 === 'b1' );
  test.true( Blueprint1.Make.StaticField3 === undefined );
  test.true( Blueprint2.Make.StaticField1 === undefined );
  test.true( Blueprint2.Make.StaticField2 === 'b1' );
  test.true( Blueprint2.Make.StaticField3 === undefined );

  test.description = 'set in class'; /* */

  Blueprint2.Make.StaticField1 = 'new';
  Blueprint2.Make.StaticField2 = 'new';
  Blueprint2.Make.StaticField3 = 'new';

  var exp =
  {
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( Blueprint2.prototype ), exp );
  var exp =
  {
    'StaticField2' : 'new',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( Blueprint1.prototype ), exp );

  test.true( Blueprint1.Make.StaticField1 === undefined );
  test.true( Blueprint1.Make.StaticField2 === 'new' );
  test.true( Blueprint1.Make.StaticField3 === undefined );
  test.true( Blueprint2.Make.StaticField1 === 'new' );
  test.true( Blueprint2.Make.StaticField2 === 'new' );
  test.true( Blueprint2.Make.StaticField3 === 'new' );

  /* */

  test.case = 'writing, configurable : 1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    field1 : p( 'b1', { configurable : 1 } ),
    field2 : p( 'b1', { configurable : 1 } ),
    StaticField1 : s( 'b1', { configurable : 1 } ),
    StaticField2 : s( 'b1', { configurable : 1 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : p( 'b2', { configurable : 1 } ),
    field3 : p( 'b2', { configurable : 1 } ),
    StaticField2 : s( 'b2', { configurable : 1 } ),
    StaticField3 : s( 'b2', { configurable : 1 } ),
  });

  test.description = 'descriptor of Blueprint1.StaticField1';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.Make, 'StaticField1' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'StaticField1' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint1.StaticField2';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.Make, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.StaticField2';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.Make, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.StaticField3';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.Make, 'StaticField3' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'StaticField3' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : true,
  }
  test.identical( got, exp );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint2.Make();

  test.description = 'all properites'; /* */

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'StaticField1' : 'b1',
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( _.property.all( instance1 ), exp );

  test.description = 'own properites'; /* */
  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 3 ] ), exp );

  test.description = '_.mapExtend( null, instance1 )'; /* */
  var exp =
  {
    'field1' : 'b1', 'field2' : 'b2', 'field3' : 'b2'
  }
  var got = _.mapExtend( null, instance1 );
  test.identical( got, exp );

  test.description = 'descriptor of instance.field1';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field1' );
  var exp =
  {
    value : 'b1',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field2';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field2' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field3';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field3' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = '_.mapExtend( instance1, src )'; /* */
  var exp =
  {
    'field1' : 'ext',
    'field2' : 'ext',
    'field3' : 'b2',
    'StaticField1' : 'ext',
    'StaticField2' : 'ext',
    'StaticField3' : 'b2',
    'constructor' : instance1.constructor,
  }
  var ext =
  {
    'field1' : 'ext',
    'field2' : 'ext',
    'StaticField1' : 'ext',
    'StaticField2' : 'ext',
  }
  var got = _.mapExtend( instance1, ext );
  test.identical( _.property.all( instance1 ), exp );

  test.description = 'descriptor of instance.field1';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field1' );
  var exp =
  {
    value : 'ext',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field2';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field2' );
  var exp =
  {
    value : 'ext',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field3';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field3' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : true,
    writable : true,
  }
  test.identical( got, exp );

  /* */

  test.case = 'deleting, configurable : 1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    field1 : p( 'b1', { configurable : 1 } ),
    field2 : p( 'b1', { configurable : 1 } ),
    StaticField1 : s( 'b1', { configurable : 1 } ),
    StaticField2 : s( 'b1', { configurable : 1 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : p( 'b2', { configurable : 1 } ),
    field3 : p( 'b2', { configurable : 1 } ),
    StaticField2 : s( 'b2', { configurable : 1 } ),
    StaticField3 : s( 'b2', { configurable : 1 } ),
  });

  var instance1 = Blueprint2.Make();

  test.description = 'in instance'; /* */

  delete instance1.field2;
  delete instance1.StaticField2;
  delete instance1.StaticField3;

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 3 ] ), exp );
  test.true( Blueprint1.Make.StaticField1 === 'b1' );
  test.true( Blueprint1.Make.StaticField2 === 'b1' );
  test.true( Blueprint1.Make.StaticField3 === undefined );
  test.true( Blueprint2.Make.StaticField1 === 'b1' );
  test.true( Blueprint2.Make.StaticField2 === 'b2' );
  test.true( Blueprint2.Make.StaticField3 === 'b2' );

  test.description = 'in prototype'; /* */

  delete Blueprint1.prototype.StaticField1;
  delete Blueprint2.prototype.StaticField2;
  delete Blueprint2.prototype.StaticField3;

  var exp =
  {
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( Blueprint2.prototype ), exp );
  var exp =
  {
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( Blueprint1.prototype ), exp );

  test.true( Blueprint1.Make.StaticField1 === 'b1' );
  test.true( Blueprint1.Make.StaticField2 === 'b1' );
  test.true( Blueprint1.Make.StaticField3 === undefined );
  test.true( Blueprint2.Make.StaticField1 === 'b1' );
  test.true( Blueprint2.Make.StaticField2 === 'b2' );
  test.true( Blueprint2.Make.StaticField3 === 'b2' );

  test.description = 'in class'; /* */

  delete Blueprint1.Make.StaticField1;
  delete Blueprint2.Make.StaticField2;
  delete Blueprint2.Make.StaticField3;

  var exp =
  {
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( Blueprint2.prototype ), exp );
  var exp =
  {
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( Blueprint1.prototype ), exp );

  test.true( Blueprint1.Make.StaticField1 === undefined );
  test.true( Blueprint1.Make.StaticField2 === 'b1' );
  test.true( Blueprint1.Make.StaticField3 === undefined );
  test.true( Blueprint2.Make.StaticField1 === undefined );
  test.true( Blueprint2.Make.StaticField2 === 'b1' );
  test.true( Blueprint2.Make.StaticField3 === undefined );

  test.description = 'set in class'; /* */

  Blueprint2.Make.StaticField1 = 'new';
  Blueprint2.Make.StaticField2 = 'new';
  Blueprint2.Make.StaticField3 = 'new';

  var exp =
  {
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( Blueprint2.prototype ), exp );
  var exp =
  {
    'StaticField2' : 'new',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( Blueprint1.prototype ), exp );

  test.true( Blueprint1.Make.StaticField1 === undefined );
  test.true( Blueprint1.Make.StaticField2 === 'new' );
  test.true( Blueprint1.Make.StaticField3 === undefined );
  test.true( Blueprint2.Make.StaticField1 === 'new' );
  test.true( Blueprint2.Make.StaticField2 === 'new' );
  test.true( Blueprint2.Make.StaticField3 === 'new' );

  /* */

  test.case = 'writing, configurable : 0';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    field1 : p( 'b1', { configurable : 0 } ),
    field2 : p( 'b1', { configurable : 0 } ),
    StaticField1 : s( 'b1', { configurable : 0 } ),
    StaticField2 : s( 'b1', { configurable : 0 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : p( 'b2', { configurable : 0 } ),
    field3 : p( 'b2', { configurable : 0 } ),
    StaticField2 : s( 'b2', { configurable : 0 } ),
    StaticField3 : s( 'b2', { configurable : 0 } ),
  });

  test.description = 'descriptor of Blueprint1.StaticField1';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.Make, 'StaticField1' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : false,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'StaticField1' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : false,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint1.StaticField2';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.Make, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : false,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : false,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.StaticField2';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.Make, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : false,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'StaticField2' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : false,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.StaticField3';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.Make, 'StaticField3' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : false,
  }
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'StaticField3' );
  var exp =
  {
    get : got.get || true,
    set : got.set || true,
    enumerable : false,
    configurable : false,
  }
  test.identical( got, exp );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint2.Make();

  test.description = 'all properites'; /* */

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'StaticField1' : 'b1',
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( _.property.all( instance1 ), exp );

  test.description = 'own properites'; /* */
  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 3 ] ), exp );

  test.description = '_.mapExtend( null, instance1 )'; /* */
  var exp =
  {
    'field1' : 'b1', 'field2' : 'b2', 'field3' : 'b2'
  }
  var got = _.mapExtend( null, instance1 );
  test.identical( got, exp );

  test.description = 'descriptor of instance.field1';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field1' );
  var exp =
  {
    value : 'b1',
    enumerable : true,
    configurable : false,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field2';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field2' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : false,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field3';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field3' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : false,
    writable : true,
  }
  test.identical( got, exp );

  test.description = '_.mapExtend( instance1, src )'; /* */
  var exp =
  {
    'field1' : 'ext',
    'field2' : 'ext',
    'field3' : 'b2',
    'StaticField1' : 'ext',
    'StaticField2' : 'ext',
    'StaticField3' : 'b2',
    'constructor' : instance1.constructor,
  }
  var ext =
  {
    'field1' : 'ext',
    'field2' : 'ext',
    'StaticField1' : 'ext',
    'StaticField2' : 'ext',
  }
  var got = _.mapExtend( instance1, ext );
  test.identical( _.property.all( instance1 ), exp );

  test.description = 'descriptor of instance.field1';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field1' );
  var exp =
  {
    value : 'ext',
    enumerable : true,
    configurable : false,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field2';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field2' );
  var exp =
  {
    value : 'ext',
    enumerable : true,
    configurable : false,
    writable : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of instance.field3';
  var got = Object.getOwnPropertyDescriptor( instance1, 'field3' );
  var exp =
  {
    value : 'b2',
    enumerable : true,
    configurable : false,
    writable : true,
  }
  test.identical( got, exp );

  /* */

  test.case = 'deleting, configurable : 0';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    field1 : p( 'b1', { configurable : 0 } ),
    field2 : p( 'b1', { configurable : 0 } ),
    StaticField1 : s( 'b1', { configurable : 0 } ),
    StaticField2 : s( 'b1', { configurable : 0 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : p( 'b2', { configurable : 0 } ),
    field3 : p( 'b2', { configurable : 0 } ),
    StaticField2 : s( 'b2', { configurable : 0 } ),
    StaticField3 : s( 'b2', { configurable : 0 } ),
  });

  var instance1 = Blueprint2.Make();

  test.description = 'in instance'; /* */

  test.shouldThrowErrorSync( () => delete instance1.field2 );
  test.mustNotThrowError( () => delete instance1.StaticField2 );
  test.mustNotThrowError( () => delete instance1.StaticField3 );

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 3 ] ), exp );
  test.true( Blueprint1.Make.StaticField1 === 'b1' );
  test.true( Blueprint1.Make.StaticField2 === 'b1' );
  test.true( Blueprint1.Make.StaticField3 === undefined );
  test.true( Blueprint2.Make.StaticField1 === 'b1' );
  test.true( Blueprint2.Make.StaticField2 === 'b2' );
  test.true( Blueprint2.Make.StaticField3 === 'b2' );

  test.description = 'in prototype'; /* */

  test.mustNotThrowError( () => delete Blueprint2.prototype.StaticField1 );
  test.shouldThrowErrorSync( () => delete Blueprint2.prototype.StaticField2 );
  test.shouldThrowErrorSync( () => delete Blueprint2.prototype.StaticField3 );

  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( Blueprint2.prototype ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( Blueprint1.prototype ), exp );

  test.true( Blueprint1.Make.StaticField1 === 'b1' );
  test.true( Blueprint1.Make.StaticField2 === 'b1' );
  test.true( Blueprint1.Make.StaticField3 === undefined );
  test.true( Blueprint2.Make.StaticField1 === 'b1' );
  test.true( Blueprint2.Make.StaticField2 === 'b2' );
  test.true( Blueprint2.Make.StaticField3 === 'b2' );

  test.description = 'in class'; /* */

  test.mustNotThrowError( () => delete Blueprint2.Make.StaticField1 );
  test.shouldThrowErrorSync( () => delete Blueprint2.Make.StaticField2 );
  test.shouldThrowErrorSync( () => delete Blueprint2.Make.StaticField3 );

  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( Blueprint2.prototype ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( Blueprint1.prototype ), exp );

  test.true( Blueprint1.Make.StaticField1 === 'b1' );
  test.true( Blueprint1.Make.StaticField2 === 'b1' );
  test.true( Blueprint1.Make.StaticField3 === undefined );
  test.true( Blueprint2.Make.StaticField1 === 'b1' );
  test.true( Blueprint2.Make.StaticField2 === 'b2' );
  test.true( Blueprint2.Make.StaticField3 === 'b2' );

  /* */

}

//

function defineProper( test )
{
  let context = this;

  /* */

  test.case = 'enumerable : 0';

  var s = _.define.static.er({ enumerable : 0 });
  var p = _.define.prop.er({ enumerable : 0 });

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    field1 : p( 'b1' ),
    field2 : p( 'b1' ),
    StaticField1 : s( 'b1' ),
    StaticField2 : s( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : p( 'b2' ),
    field3 : p( 'b2' ),
    StaticField2 : s( 'b2' ),
    StaticField3 : s( 'b2' ),
  });

  var instance1 = Blueprint2.Make();

  test.description = '_.mapExtend( null, instance1 )';
  var exp =
  {
  }
  var got = _.mapExtend( null, instance1 );
  test.identical( got, exp );

  test.description = 'own properites'; /* */

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 3 ] ), exp );

  /* */

  test.case = 'enumerable : 1';

  var s = _.define.static.er({ enumerable : 1 });
  var p = _.define.prop.er({ enumerable : 1 });

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    field1 : p( 'b1' ),
    field2 : p( 'b1' ),
    StaticField1 : s( 'b1' ),
    StaticField2 : s( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : p( 'b2' ),
    field3 : p( 'b2' ),
    StaticField2 : s( 'b2' ),
    StaticField3 : s( 'b2' ),
  });

  var instance1 = Blueprint2.Make();

  test.description = '_.mapExtend( null, instance1 )';
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'StaticField1' : 'b1',
  }
  var got = _.mapExtend( null, instance1 );
  test.identical( got, exp );

  test.description = 'own properites'; /* */

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 3 ] ), exp );

  /* */

}

//

function definePropShallowComplex( test )
{

  /* */

  var e = [];
  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed(),
    array : _.define.shallow( [ e ] ),
    map : _.define.shallow( { k : e } ),
  });
  var instance1 = blueprint.Make();
  var instance2 = blueprint.Make();
  var exp =
  {
    array : [ [] ],
    map : { k : [] },
  }

  test.containsOnly( instance1, exp );
  test.identical( instance1 instanceof blueprint.Make, true );
  test.containsOnly( instance2, exp );
  test.identical( instance2 instanceof blueprint.Make, true );
  test.true( instance1.array !== instance2.array );
  test.true( instance1.map !== instance2.map );
  test.true( instance1.array[ 0 ] === instance2.array[ 0 ] );
  test.true( instance1.map.k === instance2.map.k );

  /* */

}

definePropShallowComplex.description =
`
- shortcut shallow define definition field with valToIns:shallow
`

//

function definePropShallowComplexSourceCode( test )
{

  /* */

  var e = [];
  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed(),
    array : _.define.shallow( [ e ] ),
    map : _.define.shallow( { k : e } ),
  });
  var instance1 = blueprint.Make();
  var instance2 = blueprint.Make();
  var exp =
  {
    array : [ [] ],
    map : { k : [] },
  }

  test.containsOnly( instance1, exp );
  test.identical( instance1 instanceof blueprint.Make, true );
  test.containsOnly( instance2, exp );
  test.identical( instance2 instanceof blueprint.Make, true );
  test.true( instance1.array !== instance2.array );
  test.true( instance1.map !== instance2.map );
  test.true( instance1.array[ 0 ] === instance2.array[ 0 ] );
  test.true( instance1.map.k === instance2.map.k );

  /* */

  // var sourceCode = blueprint.definePropShallowComplexSourceCode();

/*
  var constructor = blueprint.compileConstructor();
  var instance1 = constructor();
  var instance2 = constructor();
  var exp =
  {
    array : [ [] ],
    map : { k : [] },
  }

  test.identical( instance1, exp );
  test.identical( instance1 instanceof constructor, true );
  test.identical( instance2, exp );
  test.identical( instance2 instanceof constructor, true );
  test.true( instance1.array !== instance2.array );
  test.true( instance1.map !== instance2.map );
  test.true( instance1.array[ 0 ] === instance2.array[ 0 ] );
  test.true( instance1.map.k === instance2.map.k );
*/

  /* */

}

definePropShallowComplexSourceCode.description =
`
- zzz
`

//

function definePropStaticAccessorBasic( test )
{

  /* */

  test.case = 'accessor : true, typed : true';

  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed( true ),
    s1 : _.define.static( 1, { accessor : true } ),
  });
  var instance1 = blueprint.Make();

  test.description = 'instance'; /* */

  test.identical( _.prototype.each( instance1 ).length, 3 );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    '_' : { 's1' : 1 },
    's1' : 1,
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );

  test.description = 'prototype'; /* */

  test.identical( _.prototype.each( blueprint.prototype ).length, 2 );
  var exp =
  {
    '_' : { 's1' : 1 },
    's1' : 1,
  }
  test.identical( propertyOwn( _.prototype.each( blueprint.prototype )[ 0 ] ), exp );

  test.description = 'constructor'; /* */

  test.identical( blueprint.Make.s1, 1 );

  test.description = 'instance set'; /* */

  instance1.s1 = 2;

  test.identical( instance1.s1, 2 );
  test.identical( blueprint.prototype.s1, 2 );
  test.identical( blueprint.Make.s1, 2 );

  var exp =
  {
    '_' : { 's1' : 2 },
    's1' : 2,
  }
  test.identical( propertyOwn( _.prototype.each( blueprint.prototype )[ 0 ] ), exp );

  test.description = 'prototype set'; /* */

  blueprint.prototype.s1 = 3;

  test.identical( instance1.s1, 3 );
  test.identical( blueprint.prototype.s1, 3 );
  test.identical( blueprint.Make.s1, 3 );

  var exp =
  {
    '_' : { 's1' : 3 },
    's1' : 3,
  }
  test.identical( propertyOwn( _.prototype.each( blueprint.prototype )[ 0 ] ), exp );

  test.description = 'constructor set'; /* */

  blueprint.Make.s1 = 4;

  test.identical( instance1.s1, 4 );
  test.identical( blueprint.prototype.s1, 4 );
  test.identical( blueprint.Make.s1, 4 );

  var exp =
  {
    '_' : { 's1' : 4 },
    's1' : 4,
  }
  test.identical( propertyOwn( _.prototype.each( blueprint.prototype )[ 0 ] ), exp );

  /* */

  test.case = 'accessor : true, typed : false';

  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed( false ),
    s1 : _.define.static( 1, { accessor : true } ),
  });
  var instance1 = blueprint.Make();

  test.description = 'instance'; /* */

  test.identical( instance1.s1, undefined );
  test.identical( _.prototype.each( instance1 ).length, 1 );
  var exp =
  {
  }

  test.description = 'prototype'; /* */

  test.identical( _.prototype.each( blueprint.prototype ).length, 0 );
  // test.identical( _.prototype.each( blueprint.prototype ).length, 2 );
  // var exp =
  // {
  //   '_' : { 's1' : 1 },
  //   's1' : 1,
  // }
  // test.identical( propertyOwn( _.prototype.each( blueprint.prototype )[ 0 ] ), exp );

  test.description = 'constructor'; /* */

  test.identical( blueprint.Make.s1, undefined );
  // test.identical( blueprint.Make.s1, 1 );

  test.description = 'instance set'; /* */

  test.shouldThrowErrorSync( () => instance1.s1 = 2 );

  test.identical( instance1.s1, undefined );
  // test.identical( blueprint.prototype.s1, 1 );
  // test.identical( blueprint.Make.s1, 1 );
  test.identical( blueprint.Make.s1, undefined );

  // var exp =
  // {
  //   '_' : { 's1' : 1 },
  //   's1' : 1,
  // }
  // test.identical( propertyOwn( _.prototype.each( blueprint.prototype )[ 0 ] ), exp );
  //
  // test.description = 'prototype set'; /* */
  //
  // blueprint.prototype.s1 = 3;
  //
  // test.identical( instance1.s1, undefined );
  // test.identical( blueprint.prototype.s1, 3 );
  // test.identical( blueprint.Make.s1, 3 );
  //
  // var exp =
  // {
  //   '_' : { 's1' : 3 },
  //   's1' : 3,
  // }
  // test.identical( propertyOwn( _.prototype.each( blueprint.prototype )[ 0 ] ), exp );

  test.description = 'constructor set'; /* */

  blueprint.Make.s1 = 4;

  test.identical( instance1.s1, undefined );
  // test.identical( blueprint.prototype.s1, 4 );
  test.identical( blueprint.Make.s1, 4 );

  // var exp =
  // {
  //   '_' : { 's1' : 4 },
  //   's1' : 4,
  // }
  // test.identical( propertyOwn( _.prototype.each( blueprint.prototype )[ 0 ] ), exp );

  /* */

  test.case = 'set : false, typed : true';

  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed( true ),
    s1 : _.define.static( 1, { accessor : { set : false } } ),
  });
  var instance1 = blueprint.Make();

  test.description = 'instance'; /* */

  test.identical( _.prototype.each( instance1 ).length, 3 );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    '_' : { 's1' : 1 },
    's1' : 1,
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );

  test.description = 'prototype'; /* */

  test.identical( _.prototype.each( blueprint.prototype ).length, 2 );
  var exp =
  {
    '_' : { 's1' : 1 },
    's1' : 1,
  }
  test.identical( propertyOwn( _.prototype.each( blueprint.prototype )[ 0 ] ), exp );

  test.description = 'constructor'; /* */

  test.identical( blueprint.Make.s1, 1 );

  test.description = 'set'; /* */

  test.shouldThrowErrorSync( () => instance1.s1 = 2 );
  test.shouldThrowErrorSync( () => blueprint.prototype.s1 = 2 );
  test.shouldThrowErrorSync( () => blueprint.Make.s1 = 2 );

  test.identical( instance1.s1, 1 );
  test.identical( blueprint.prototype.s1, 1 );
  test.identical( blueprint.Make.s1, 1 );

  var exp =
  {
    '_' : { 's1' : 1 },
    's1' : 1,
  }
  test.identical( propertyOwn( _.prototype.each( blueprint.prototype )[ 0 ] ), exp );

  test.description = 'set with underscore'; /* */

  blueprint.prototype._.s1 = 2;

  test.identical( instance1.s1, 2 );
  test.identical( blueprint.prototype.s1, 2 );
  test.identical( blueprint.Make.s1, 2 );

  var exp =
  {
    '_' : { 's1' : 2 },
    's1' : 2,
  }
  test.identical( propertyOwn( _.prototype.each( blueprint.prototype )[ 0 ] ), exp );

  /* */

  test.case = 'set : false, typed : false';

  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed( false ),
    s1 : _.define.static( 1, { accessor : { set : false } } ),
  });
  var instance1 = blueprint.Make();

  test.description = 'instance'; /* */

  test.identical( instance1.s1, undefined );
  test.identical( _.prototype.each( instance1 ).length, 1 );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );

  test.description = 'prototype'; /* */

  test.identical( _.prototype.each( blueprint.prototype ).length, 0 );
  // test.identical( _.prototype.each( blueprint.prototype ).length, 2 );
  // var exp =
  // {
  //   '_' : { 's1' : 1 },
  //   's1' : 1,
  // }
  // test.identical( propertyOwn( _.prototype.each( blueprint.prototype )[ 0 ] ), exp );

  test.description = 'constructor'; /* */

  test.identical( blueprint.Make.s1, undefined );
  // test.identical( blueprint.Make.s1, 1 );

  test.description = 'set'; /* */

  test.shouldThrowErrorSync( () => instance1.s1 = 2 );
  test.shouldThrowErrorSync( () => blueprint.prototype.s1 = 2 );
  // test.shouldThrowErrorSync( () => blueprint.Make.s1 = 2 );

  blueprint.Make.s1 = 2;
  test.identical( blueprint.Make.s1, 2 );

  test.identical( instance1.s1, undefined );
  // test.identical( blueprint.prototype.s1, 1 );
  // test.identical( blueprint.Make.s1, 1 );
  test.identical( blueprint.Make.s1, 2 );

  // var exp =
  // {
  //   '_' : { 's1' : 1 },
  //   's1' : 1,
  // }
  // test.identical( propertyOwn( _.prototype.each( blueprint.prototype )[ 0 ] ), exp );
  //
  // test.description = 'set with underscore'; /* */
  //
  // blueprint.prototype._.s1 = 2;
  //
  // test.identical( instance1.s1, undefined );
  // test.identical( blueprint.prototype.s1, 2 );
  // test.identical( blueprint.Make.s1, 2 );
  //
  // var exp =
  // {
  //   '_' : { 's1' : 2 },
  //   's1' : 2,
  // }
  // test.identical( propertyOwn( _.prototype.each( blueprint.prototype )[ 0 ] ), exp );
  //
  /* */

}

definePropStaticAccessorBasic.description =
`
  - _.define.static() with accessor declare accessor
  - change of value of such static property in prototype changes value in constructor
  - change of value of such static property in constructor changes value in prototype
`

//

function definePropAccessorBasic( test )
{

  /* */

  test.case = 'accessor : true, typed : true';

  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed( true ),
    f1 : _.define.prop( 1, { accessor : true } ),
  });
  var instance1 = blueprint.Make();

  test.description = 'instance'; /* */

  test.identical( instance1.f1, 1 );
  test.identical( blueprint.prototype.f1, undefined );
  test.identical( blueprint.Make.f1, undefined );

  test.identical( _.prototype.each( instance1 ).length, 3 );
  var exp =
  {
    'f1' : 1,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 1,
  }
  test.identical( _.property.all( instance1._ ), exp );

  test.description = 'instance set'; /* */

  instance1.f1 = 2;

  test.identical( instance1.f1, 2 );
  test.identical( blueprint.prototype.f1, undefined );
  test.identical( blueprint.Make.f1, undefined );

  var exp =
  {
    'f1' : 2,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 2,
  }
  test.identical( _.property.all( instance1._ ), exp );

  /* */

  test.case = 'accessor : true, typed : false';

  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed( false ),
    f1 : _.define.prop( 1, { accessor : true } ),
  });
  var instance1 = blueprint.Make();

  test.description = 'instance'; /* */

  test.identical( instance1.f1, 1 );
  // test.identical( blueprint.prototype.f1, undefined );
  test.identical( blueprint.Make.f1, undefined );

  test.identical( _.prototype.each( instance1 ).length, 1 );
  var exp =
  {
    'f1' : 1,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 1,
  }
  test.identical( _.property.all( instance1._ ), exp );

  test.description = 'instance set'; /* */

  instance1.f1 = 2;

  test.identical( instance1.f1, 2 );
  // test.identical( blueprint.prototype.f1, undefined );
  test.identical( blueprint.Make.f1, undefined );

  var exp =
  {
    'f1' : 2,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 2,
  }
  test.identical( _.property.all( instance1._ ), exp );

  /* */

  test.case = 'accessor.set : false, typed : true';

  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed( true ),
    f1 : _.define.prop( 1, { accessor : { set : false } } ),
  });
  var instance1 = blueprint.Make();

  test.description = 'instance'; /* */

  test.identical( instance1.f1, 1 );
  test.identical( blueprint.prototype.f1, undefined );
  test.identical( blueprint.Make.f1, undefined );

  test.identical( _.prototype.each( instance1 ).length, 3 );
  var exp =
  {
    'f1' : 1,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 1,
  }
  test.identical( _.property.all( instance1._ ), exp );

  test.description = 'instance set'; /* */

  instance1._.f1 = 2;
  test.shouldThrowErrorSync( () => instance1.f1 = 3 );

  test.identical( instance1.f1, 2 );
  test.identical( blueprint.prototype.f1, undefined );
  test.identical( blueprint.Make.f1, undefined );

  var exp =
  {
    'f1' : 2,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 2,
  }
  test.identical( _.property.all( instance1._ ), exp );

  /* */

  test.case = 'accessor.set : false, typed : false';

  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed( false ),
    f1 : _.define.prop( 1, { accessor : { set : false } } ),
  });
  var instance1 = blueprint.Make();

  test.description = 'instance'; /* */

  test.identical( instance1.f1, 1 );
  // test.identical( blueprint.prototype.f1, undefined );
  test.identical( blueprint.Make.f1, undefined );

  test.identical( _.prototype.each( instance1 ).length, 1 );
  var exp =
  {
    'f1' : 1,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 1,
  }
  test.identical( _.property.all( instance1._ ), exp );

  test.description = 'instance set'; /* */

  instance1._.f1 = 2;
  test.shouldThrowErrorSync( () => instance1.f1 = 3 );

  test.identical( instance1.f1, 2 );
  // test.identical( blueprint.prototype.f1, undefined );
  test.identical( blueprint.Make.f1, undefined );

  var exp =
  {
    'f1' : 2,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 2,
  }
  test.identical( _.property.all( instance1._ ), exp );

  /* */

  test.case = 'accessor.get : false, typed : true';

  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed( true ),
    f1 : _.define.prop( 1, { accessor : { get : false } } ),
  });
  var instance1 = blueprint.Make();

  test.description = 'instance'; /* */

  test.shouldThrowErrorSync( () => instance1.f1 );
  test.shouldThrowErrorSync( () => blueprint.prototype.f1 );
  test.identical( blueprint.Make.f1, undefined );

  test.identical( _.prototype.each( instance1 ).length, 3 );
  var exp =
  {
    'f1' : 1,
  }
  test.identical( _.property.all( instance1._ ), exp );
  test.shouldThrowErrorSync( () => instance1.f1 );

  test.description = 'instance set'; /* */

  instance1.f1 = 2;

  test.shouldThrowErrorSync( () => instance1.f1 );
  test.shouldThrowErrorSync( () => blueprint.prototype.f1 );
  test.identical( blueprint.Make.f1, undefined );

  var exp =
  {
    'f1' : 2,
  }
  test.identical( _.property.all( instance1._ ), exp );
  test.shouldThrowErrorSync( () => instance1.f1 );

  /* */

  test.case = 'accessor.get : false, typed : false';

  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed( false ),
    f1 : _.define.prop( 1, { accessor : { get : false } } ),
  });
  var instance1 = blueprint.Make();

  test.description = 'instance'; /* */

  test.shouldThrowErrorSync( () => instance1.f1 );
  // test.identical( blueprint.prototype.f1, undefined );
  test.identical( blueprint.Make.f1, undefined );

  test.identical( _.prototype.each( instance1 ).length, 1 );
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ]._ ), { 'f1' : 1 } );

  test.description = 'instance set'; /* */

  instance1.f1 = 2;

  test.shouldThrowErrorSync( () => instance1.f1 );
  // test.identical( blueprint.prototype.f1, undefined );
  test.identical( blueprint.Make.f1, undefined );

  var exp =
  {
    'f1' : 2,
  }
  test.identical( _.property.all( instance1._ ), exp );
  test.shouldThrowErrorSync( () => instance1.f1 );

  /* */

}

//

function definePropAccessorTypedMaybe( test )
{
  let context = this;
  let props = context.eachKindOfProp();
  let visitedProps = Object.create( null );

  eachKindOfProp();

  /* - */

  function eachKindOfProp()
  {
    _.each( props, ( prop ) =>
    {
      eachCase({ typed : 1, ... prop });
      eachCase({ typed : _.maybe, ... prop });
    });
    test.case = 'validation';
    test.identical( visitedProps, props );
  }

  /* - */

  function eachCase( tops )
  {

    /* */

    console.log( tops.propKind );

    if( _.longHas( [ 'valToIns:val', 'valToIns:shallow', 'configurable:0' ], tops.propKind ) )
    {

      test.case = `${tops.propKind}, typed : ${_.toStr( tops.typed )}`;

      var blueprint = _.blueprint.define
      ({
        typed : _.trait.typed( tops.typed ),
        f1 : tops.prop,
      });

      if( tops.typed === 1 )
      test.identical( _.prototype.each( blueprint.prototype ).length, 2 );
      else
      test.identical( _.prototype.each( blueprint.prototype ).length, 0 );

      if( tops.typed === 1 )
      {
        var got = Object.getOwnPropertyDescriptor( blueprint.prototype, 'f1' );
        var exp = undefined;
        test.identical( got, exp );
      }

      var got = Object.getOwnPropertyDescriptor( blueprint.Make, 'f1' );
      var exp = undefined;
      test.identical( got, exp );

      test.description = 'instance'; /* */

      var instance1 = blueprint.Make();
      test.identical( instance1.f1, 1 );

      var exp = [ 'f1' ];
      test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 0 ] ) ), new Set( exp ) );
      if( tops.typed === 1 )
      {
        var exp = [];
        test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 1 ] ) ), new Set( exp ) );
        var exp = [];
        test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 2 ] ) ), new Set( exp ) );
      }

      visitedProps[ tops.propKind ] = { propKind : tops.propKind, prop : tops.prop };
    }

    /* */

    if( _.longHas( [ 'get:1, set:1' ], tops.propKind ) )
    {

      test.case = `${tops.propKind}, typed : ${_.toStr( tops.typed )}`;
      test.true( _.definition.is( tops.prop ) );

      var blueprint = _.blueprint.define
      ({
        typed : _.trait.typed( tops.typed ),
        f1 : tops.prop,
      });

      if( tops.typed === 1 )
      {
        var got = Object.getOwnPropertyDescriptor( blueprint.prototype, 'f1' );
        var exp =
        {
          'get' : got.get,
          'set' : got.set,
          'enumerable' : true,
          'configurable' : true,
        };
        test.identical( got, exp );
      }

      var got = Object.getOwnPropertyDescriptor( blueprint.Make, 'f1' );
      var exp = undefined;
      test.identical( got, exp );

      test.description = 'instance'; /* */

      var instance1 = blueprint.Make();
      if( tops.typed === 1 )
      test.identical( _.prototype.each( instance1 ).length, 3 );
      else
      test.identical( _.prototype.each( instance1 ).length, 1 );

      var exp =
      {
        f1 : 1,
      }
      test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ]._ ), exp );
      if( tops.typed === 1 )
      {
        var exp =
        {
        }
        test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ]._ ), exp );
      }

      if( tops.typed === 1 )
      {
        var exp = [ '_' ];
        test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 0 ] ) ), new Set( exp ) );
      }
      else
      {
        var exp = [ '_', 'f1' ];
        test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 0 ] ) ), new Set( exp ) );
      }

      if( tops.typed === 1 )
      {
        var exp = [ 'f1', '_' ];
        test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 1 ] ) ), new Set( exp ) );
        var exp = [];
        test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 2 ] ) ), new Set( exp ) );
      }

      visitedProps[ tops.propKind ] = { propKind : tops.propKind, prop : tops.prop };
    }

    /* */

    if( _.longHas( [ 'static:1, get:1, set:1' ], tops.propKind ) )
    {

      test.case = `${tops.propKind}, typed : ${_.toStr( tops.typed )}`;
      test.true( _.definition.is( tops.prop ) );

      var blueprint = _.blueprint.define
      ({
        typed : _.trait.typed( tops.typed ),
        f1 : tops.prop,
      });

      if( tops.typed === 1 )
      {
        var got = Object.getOwnPropertyDescriptor( blueprint.prototype, 'f1' );
        var exp =
        {
          'get' : got.get,
          'set' : got.set,
          'enumerable' : false,
          'configurable' : true,
        };
        test.identical( got, exp );

        var got = Object.getOwnPropertyDescriptor( blueprint.Make, 'f1' );
        var exp =
        {
          'get' : got.get,
          'set' : got.set,
          'enumerable' : false,
          'configurable' : true,
        };
        test.identical( got, exp );

      }

      test.description = 'instance'; /* */

      var instance1 = blueprint.Make();
      if( tops.typed === 1 )
      test.identical( _.prototype.each( instance1 ).length, 3 );
      else
      test.identical( _.prototype.each( instance1 ).length, 1 );

      var exp =
      {
        f1 : 1,
      }
      if( tops.typed === 1 )
      {
        test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ]._ ), exp );
        var exp =
        {
          f1 : 1,
        }
        test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ]._ ), exp );

        var exp = [];
        test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 0 ] ) ), new Set( exp ) );
        var exp = [ '_', 'f1' ];
        test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 1 ] ) ), new Set( exp ) );
        var exp = [];
        test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 2 ] ) ), new Set( exp ) );
      }

      visitedProps[ tops.propKind ] = { propKind : tops.propKind, prop : tops.prop };
    }

    /* */

    if( _.longHas( [ 'static:1' ], tops.propKind ) )
    {

      test.case = `${tops.propKind}, typed : ${_.toStr( tops.typed )}`;
      test.true( _.definition.is( tops.prop ) );

      var blueprint = _.blueprint.define
      ({
        typed : _.trait.typed( tops.typed ),
        f1 : tops.prop,
      });

      if( tops.typed === 1 )
      {
        var got = Object.getOwnPropertyDescriptor( blueprint.prototype, 'f1' );
        var exp =
        {
          'get' : got.get,
          'set' : got.set,
          'enumerable' : false,
          'configurable' : true,
        };
        test.identical( got, exp );

        var got = Object.getOwnPropertyDescriptor( blueprint.Make, 'f1' );
        var exp =
        {
          'get' : got.get,
          'set' : got.set,
          'enumerable' : false,
          'configurable' : true,
        };
        test.identical( got, exp );
      }
      else
      {
        var got = Object.getOwnPropertyDescriptor( blueprint.Make, 'f1' );
        test.identical( got, undefined );
      }

      test.description = 'instance'; /* */

      var instance1 = blueprint.Make();
      if( tops.typed === 1 )
      test.identical( _.prototype.each( instance1 ).length, 3 );
      else
      test.identical( _.prototype.each( instance1 ).length, 1 );
      test.true( instance1._ === undefined );

      var exp = [];
      test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 0 ] ) ), new Set( exp ) );
      if( tops.typed === 1 )
      {
        var exp = [ 'f1' ];
        test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 1 ] ) ), new Set( exp ) );
        var exp = [];
        test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 2 ] ) ), new Set( exp ) );
      }

      visitedProps[ tops.propKind ] = { propKind : tops.propKind, prop : tops.prop };
    }

    /* */

  }

  /* - */

}

definePropAccessorTypedMaybe.description =
`
- blueprint with definition::property and and trait::typed::maybe
  give the same construction as blueprint with definition::property and and trait::typed::true
`

//

function definePropAccessorConstructionAmend( test )
{
  let context = this;
  let props = context.eachKindOfProp();
  let visited1 = Object.create( null );
  let visited2 = Object.create( null );

  eachKindOfProp();

  /* - */

  function eachKindOfProp()
  {

    var permutations = _.eachSample
    ({
      sets :
      {
        amending : [ 'extend', 'supplement' ],
        typed : [ _.nothing, _.maybe, 1, 0 ],
        propKind : _.mapKeys( props ),
      },
      result : 1,
    });

    _.each( permutations, ( permutation ) =>
    {
      eachCase({ ... permutation, ... props[ permutation.propKind ] });
    });

    test.case = 'validation';
    test.identical( visited1, visited2 );
  }

  /* - */

  function nameFor( tops )
  {
    let result = [];
    _.each( tops, ( e, k ) =>
    {
      if( k === 'prop' )
      return;
      if( k === 'propKind' )
      result.push( `${_.toStrShort( e )}` );
      else
      result.push( `${k}:${_.toStrShort( e )}` );
    });
    return result.join( ' ' );
  }

  /* - */

  function eachCase( tops )
  {
    console.log( nameFor( tops ) );
    visited1[ nameFor( tops ) ] = 1;

    // if( nameFor( tops ) !== 'amending:extend typed:Symbol(maybe) static:1' )
    // return;

    /* */

    if
    (
         _.longHas( [ 'valToIns:val', 'valToIns:shallow', 'configurable:0' ], tops.propKind )
      && _.longHas( [ _.nothing, _.maybe, 0 ], tops.typed )
    )
    {
      test.case = `${nameFor( tops )}, amend pure map`;

      var extension =
      {
        f1 : tops.prop,
      };
      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed( tops.typed );
      var dstContainer = Object.create( null );

      var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
      test.true( dstContainer === instance1 );
      test.true( _.prototype.of( dstContainer ) === null );
      test.identical( _.prototype.each( instance1 ).length, 1 );
      test.identical( instance1.f1, 1 );
      var exp = [ 'f1' ];
      test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 0 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'valToIns:val', 'valToIns:shallow', 'configurable:0' ], tops.propKind )
      && _.longHas( [ 1 ], tops.typed )
    )
    {
      test.case = `${nameFor( tops )}, amend pure map`;

      var extension =
      {
        f1 : tops.prop,
      };
      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed( tops.typed );
      var dstContainer = Object.create( null );

      var instance1 = _.construction[ tops.amending ]( dstContainer, extension );

      test.true( dstContainer === instance1 );
      test.true( _.prototype.of( dstContainer ) !== Object.prototype );
      test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );
      test.identical( _.prototype.each( instance1 ).length, 3 );
      test.identical( instance1.f1, 1 );
      var exp = [ 'f1' ];
      test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 0 ] ) ), new Set( exp ) );
      test.identical( _.prototype.each( dstContainer )[ 1 ].f1, undefined );
      var exp = [];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 1 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'valToIns:val', 'valToIns:shallow', 'configurable:0' ], tops.propKind )
      && _.longHas( [ _.maybe, _.nothing, 0 ], tops.typed )
    )
    {
      test.case = `${nameFor( tops )}, amend polluted map`;

      var extension =
      {
        f1 : tops.prop,
      };

      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed( tops.typed );
      var dstContainer = {};

      var keysBefore = _.mapAllKeys( Object.prototype );
      var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
      var keysAfter = _.mapAllKeys( Object.prototype );
      test.identical( keysAfter, keysBefore );

      test.true( dstContainer === instance1 );
      test.true( _.prototype.of( dstContainer ) === Object.prototype );
      test.identical( _.prototype.each( instance1 ).length, 2 );
      test.identical( instance1.f1, 1 );
      var exp = [ 'f1' ];
      test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 0 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'valToIns:val', 'valToIns:shallow', 'configurable:0' ], tops.propKind )
      && _.longHas( [ 1 ], tops.typed )
    )
    {
      test.case = `${nameFor( tops )}, amend polluted map`;

      var extension =
      {
        f1 : tops.prop,
      };
      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed({ val : tops.typed } );
      var dstContainer = {};

      var keysBefore = _.mapAllKeys( Object.prototype );
      var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
      var keysAfter = _.mapAllKeys( Object.prototype );
      test.identical( keysAfter, keysBefore );

      test.true( dstContainer === instance1 );
      test.true( _.prototype.of( dstContainer ) !== Object.prototype );
      test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );
      test.identical( _.prototype.each( instance1 ).length, 3 );
      test.identical( instance1.f1, 1 );
      var exp = [ 'f1' ];
      test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 0 ] ) ), new Set( exp ) );
      test.identical( _.prototype.each( dstContainer )[ 1 ].f1, undefined );
      var exp = [];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 1 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'valToIns:val', 'valToIns:shallow', 'configurable:0' ], tops.propKind )
      && _.longHas( [ _.nothing, _.maybe, 1 ], tops.typed )
    )
    {
      test.case = `${nameFor( tops )}, amend object`;

      var extension =
      {
        f1 : tops.prop,
      };

      var prototype = Object.create( null );
      var dstContainer = Object.create( prototype );

      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed({ val : tops.typed, prototype });

      var instance1 = _.construction[ tops.amending ]( dstContainer, extension );

      test.true( dstContainer === instance1 );
      test.true( _.prototype.of( dstContainer ) === prototype );
      test.identical( _.prototype.each( instance1 ).length, 2 );
      test.identical( instance1.f1, 1 );
      var exp = [ 'f1' ];
      test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 0 ] ) ), new Set( exp ) );
      test.identical( _.prototype.each( dstContainer )[ 1 ].f1, undefined );
      var exp = [];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 1 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'valToIns:val', 'valToIns:shallow', 'configurable:0' ], tops.propKind )
      && _.longHas( [ 0 ], tops.typed )
    )
    {
      test.case = `${nameFor( tops )}, amend object`;

      var extension =
      {
        f1 : tops.prop,
      };

      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed( tops.typed );
      var prototype = Object.create( null );
      var dstContainer = Object.create( prototype );

      var instance1 = _.construction[ tops.amending ]( dstContainer, extension );

      test.true( dstContainer === instance1 );
      test.true( _.prototype.of( dstContainer ) !== prototype );
      test.identical( _.prototype.each( instance1 ).length, 1 );
      test.identical( instance1.f1, 1 );
      var exp = [ 'f1' ];
      test.identical( new Set( keysOwn( _.prototype.each( instance1 )[ 0 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'get:1, set:1' ], tops.propKind )
      && _.longHas( [ _.nothing, _.maybe, 0 ], tops.typed )
    )
    {
      test.case = `${tops.propKind}, ${_.toStr( tops.typed )}, amend pure map`;

      var extension =
      {
        f1 : tops.prop,
      };
      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed( tops.typed );
      var dstContainer = Object.create( null );

      var keysBefore = _.mapAllKeys( Object.prototype );
      var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
      var keysAfter = _.mapAllKeys( Object.prototype );
      test.identical( keysAfter, keysBefore );

      test.true( _.prototype.of( dstContainer ) === null );
      test.identical( _.prototype.each( dstContainer ).length, 1 );
      test.identical( dstContainer.f1, 1 );
      var exp = [ '_', 'f1' ];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 0 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'get:1, set:1' ], tops.propKind )
      && _.longHas( [ 1 ], tops.typed )
    )
    {
      test.case = `${tops.propKind}, ${_.toStr( tops.typed )}, amend pure map`;

      var extension =
      {
        f1 : tops.prop,
      };
      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed( tops.typed );
      var dstContainer = Object.create( null );

      var keysBefore = _.mapAllKeys( Object.prototype );
      var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
      var keysAfter = _.mapAllKeys( Object.prototype );
      test.identical( keysAfter, keysBefore );

      test.true( _.prototype.of( dstContainer ) !== Object.prototype );
      test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );
      test.identical( _.prototype.each( dstContainer ).length, 3 );
      test.identical( dstContainer.f1, 1 );
      var exp = [ '_' ];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 0 ] ) ), new Set( exp ) );
      test.identical( _.prototype.each( dstContainer )[ 1 ].f1, undefined );
      var exp = [ '_', 'f1' ];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 1 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'get:1, set:1' ], tops.propKind )
      && _.longHas( [ 1, _.nothing ], tops.typed )
    )
    {
      test.case = `${tops.propKind}, ${_.toStr( tops.typed )}, amend polluted map with explicit prototype:1`;

      var extension =
      {
        f1 : tops.prop,
        typed : _.trait.typed({ val : tops.typed === _.nothing ? undefined : tops.typed, prototype : 1 }),
      };
      var dstContainer = {};

      var keysBefore = _.mapAllKeys( Object.prototype );
      _.construction[ tops.amending ]( dstContainer, extension );
      var keysAfter = _.mapAllKeys( Object.prototype );
      test.identical( keysAfter, keysBefore );

      test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );
      test.identical( _.prototype.each( dstContainer ).length, 3 );
      test.identical( dstContainer.f1, 1 );
      var exp = [ '_' ];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 0 ] ) ), new Set( exp ) );
      test.identical( _.prototype.each( dstContainer )[ 1 ].f1, undefined );
      var exp = [ '_', 'f1' ];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 1 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'get:1, set:1' ], tops.propKind )
      && _.longHas( [ 0 ], tops.typed )
    )
    {
      test.case = `${tops.propKind}, ${_.toStr( tops.typed )}, amend polluted map`;

      var extension =
      {
        f1 : tops.prop,
      };
      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed( tops.typed );
      var dstContainer = {};

      var keysBefore = _.mapAllKeys( _.prototype.of( dstContainer ) );
      var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
      var keysAfter = _.mapAllKeys( _.prototype.of( dstContainer ) );
      test.identical( keysAfter, keysBefore );

      test.true( _.prototype.of( dstContainer ) === Object.prototype );
      test.identical( _.prototype.each( dstContainer ).length, 2 );
      test.identical( dstContainer.f1, 1 );
      var exp = [ '_', 'f1' ];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 0 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'get:1, set:1' ], tops.propKind )
      && _.longHas( [ _.nothing, _.maybe ], tops.typed )
    )
    {
      test.case = `${tops.propKind}, ${_.toStr( tops.typed )}, amend object`;

      var extension =
      {
        f1 : tops.prop,
      };
      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed( tops.typed );
      var prototype = Object.create( null );
      var dstContainer = Object.create( prototype );

      _.construction[ tops.amending ]( dstContainer, extension );

      test.true( _.prototype.of( dstContainer ) === prototype );
      test.identical( _.prototype.each( dstContainer ).length, 2 );
      test.identical( dstContainer.f1, 1 );
      var exp = [ '_' ];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 0 ] ) ), new Set( exp ) );
      test.identical( _.prototype.each( dstContainer )[ 1 ].f1, undefined );
      var exp = [ '_', 'f1' ];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 1 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'get:1, set:1' ], tops.propKind )
      && _.longHas( [ 1 ], tops.typed )
    )
    {
      test.case = `${tops.propKind}, ${_.toStr( tops.typed )}, amend object`;

      var extension =
      {
        f1 : tops.prop,
      };
      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed( tops.typed );
      var prototype = Object.create( null );
      var dstContainer = Object.create( prototype );

      _.construction[ tops.amending ]( dstContainer, extension );

      test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );
      test.identical( _.prototype.each( dstContainer ).length, 3 );
      test.identical( dstContainer.f1, 1 );
      var exp = [ '_' ];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 0 ] ) ), new Set( exp ) );
      test.identical( _.prototype.each( dstContainer )[ 1 ].f1, undefined );
      var exp = [ '_', 'f1' ];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 1 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'get:1, set:1' ], tops.propKind )
      && _.longHas( [ 0 ], tops.typed )
    )
    {
      test.case = `${tops.propKind}, ${_.toStr( tops.typed )}, amend object`;

      var extension =
      {
        f1 : tops.prop,
      };
      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed( tops.typed );
      var prototype = Object.create( null );
      var dstContainer = Object.create( prototype );

      var instance1 = _.construction[ tops.amending ]( dstContainer, extension );

      test.true( instance1 === dstContainer );
      test.true( _.prototype.of( dstContainer ) === null );
      test.identical( _.prototype.each( dstContainer ).length, 1 );
      test.identical( dstContainer.f1, 1 );
      var exp = [ '_', 'f1' ];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 0 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'static:1, get:1, set:1', 'static:1' ], tops.propKind )
      && _.longHas( [ _.nothing, _.maybe, 0 ], tops.typed )
    )
    {
      test.case = `${tops.propKind}, ${_.toStr( tops.typed )}, amend pure map`;

      var extension =
      {
        f1 : tops.prop,
      };
      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed( tops.typed );
      var dstContainer = Object.create( null );

      var keysBefore = _.mapAllKeys( Object.prototype );
      var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
      var keysAfter = _.mapAllKeys( Object.prototype );
      test.identical( keysAfter, keysBefore );

      test.true( _.prototype.of( dstContainer ) === null );
      test.identical( _.prototype.each( dstContainer ).length, 1 );
      test.identical( dstContainer.f1, undefined );
      var exp = [];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 0 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'static:1, get:1, set:1', 'static:1' ], tops.propKind )
      && _.longHas( [ 1 ], tops.typed )
    )
    {
      test.case = `${tops.propKind}, ${_.toStr( tops.typed )}, amend pure map`;

      var extension =
      {
        f1 : tops.prop,
      };
      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed( tops.typed );
      var dstContainer = Object.create( null );

      var keysBefore = _.mapAllKeys( Object.prototype );
      var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
      var keysAfter = _.mapAllKeys( Object.prototype );
      test.identical( keysAfter, keysBefore );

      test.true( _.prototype.of( dstContainer ) !== Object.prototype );
      test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );
      test.identical( _.prototype.each( dstContainer ).length, 3 );
      test.identical( dstContainer.f1, 1 );
      var exp = [];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 0 ] ) ), new Set( exp ) );
      test.identical( _.prototype.each( dstContainer )[ 1 ].f1, 1 );
      var exp = [ 'f1' ];
      if( tops.propKind === 'static:1, get:1, set:1' )
      exp.push( '_' );
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 1 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'static:1, get:1, set:1', 'static:1' ], tops.propKind )
      && _.longHas( [ 0, _.maybe, _.nothing ], tops.typed )
    )
    {
      test.case = `${tops.propKind}, ${_.toStr( tops.typed )}, amend polluted map`;

      var extension =
      {
        f1 : tops.prop,
      };
      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed( tops.typed );
      var dstContainer = {};

      var keysBefore = _.mapAllKeys( Object.prototype );
      var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
      var keysAfter = _.mapAllKeys( Object.prototype );
      test.identical( keysAfter, keysBefore );

      test.true( _.prototype.of( dstContainer ) === Object.prototype );
      test.identical( _.prototype.each( dstContainer ).length, 2 );
      test.identical( dstContainer.f1, undefined );
      var exp = [];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 0 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'static:1, get:1, set:1', 'static:1' ], tops.propKind )
      && _.longHas( [ 1 ], tops.typed )
    )
    {
      test.case = `${tops.propKind}, ${_.toStr( tops.typed )}, amend polluted map`;

      var extension =
      {
        f1 : tops.prop,
      };
      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed( tops.typed );
      var dstContainer = {};

      var keysBefore = _.mapAllKeys( Object.prototype );
      var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
      var keysAfter = _.mapAllKeys( Object.prototype );
      test.identical( keysAfter, keysBefore );

      test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );
      test.identical( _.prototype.each( dstContainer ).length, 3 );
      test.identical( dstContainer.f1, 1 );
      var exp = [];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 0 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'static:1, get:1, set:1', 'static:1' ], tops.propKind )
      && _.longHas( [ 1 ], tops.typed )
    )
    {
      test.case = `${tops.propKind}, typed:${_.toStr( tops.typed )}, amend object`;

      var extension =
      {
        f1 : tops.prop,
      };
      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed( tops.typed );
      var prototype = Object.create( null );
      var dstContainer = Object.create( prototype );

      var keysBefore = _.mapAllKeys( Object.prototype );
      var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
      var keysAfter = _.mapAllKeys( Object.prototype );
      test.identical( keysAfter, keysBefore );

      test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );
      test.true( _.prototype.of( dstContainer ) !== prototype );
      test.identical( _.prototype.each( dstContainer ).length, 3 );
      test.identical( dstContainer.f1, 1 );
      var exp = [];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 0 ] ) ), new Set( exp ) );
      test.identical( _.prototype.each( dstContainer )[ 1 ].f1, 1 );
      var exp = [ 'f1' ];
      if( tops.propKind === 'static:1, get:1, set:1' )
      exp.push( '_' );
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 1 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'static:1, get:1, set:1', 'static:1' ], tops.propKind )
      && _.longHas( [ _.nothing, _.maybe ], tops.typed )
    )
    {
      test.case = `${tops.propKind}, typed:${_.toStr( tops.typed )}, amend object`;

      var extension =
      {
        f1 : tops.prop,
      };
      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed( tops.typed );
      var prototype = Object.create( null );
      var dstContainer = Object.create( prototype );

      var keysBefore = _.mapAllKeys( Object.prototype );
      var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
      var keysAfter = _.mapAllKeys( Object.prototype );
      test.identical( keysAfter, keysBefore );

      test.true( _.prototype.of( dstContainer ) === prototype );
      test.identical( _.prototype.each( dstContainer ).length, 2 );
      test.identical( dstContainer.f1, 1 );
      var exp = [];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 0 ] ) ), new Set( exp ) );
      test.identical( _.prototype.each( dstContainer )[ 1 ].f1, 1 );
      var exp = [ 'f1' ];
      if( tops.propKind === 'static:1, get:1, set:1' )
      exp.push( '_' );
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 1 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

    if
    (
         _.longHas( [ 'static:1, get:1, set:1', 'static:1' ], tops.propKind )
      && _.longHas( [ 0 ], tops.typed )
    )
    {
      test.case = `${tops.propKind}, typed:${_.toStr( tops.typed )}, amend object`;

      var extension =
      {
        f1 : tops.prop,
      };
      if( tops.typed !== _.nothing )
      extension.typed = _.trait.typed( tops.typed );
      var prototype = Object.create( null );
      var dstContainer = Object.create( prototype );

      var keysBefore = _.mapAllKeys( Object.prototype );
      var instance1 = _.construction[ tops.amending ]( dstContainer, extension );
      var keysAfter = _.mapAllKeys( Object.prototype );
      test.identical( keysAfter, keysBefore );

      test.true( _.prototype.of( dstContainer ) === null );
      test.identical( _.prototype.each( dstContainer ).length, 1 );
      test.identical( dstContainer.f1, undefined );
      var exp = [];
      test.identical( new Set( keysOwn( _.prototype.each( dstContainer )[ 0 ] ) ), new Set( exp ) );

      visited2[ nameFor( tops ) ] = 1;
    }

    /* */

  }

}

definePropAccessorConstructionAmend.description =
`
  - amending pure map with prop with accessor does not throw error
  - amending polluted map with prop with accessor throws error, no extra pollution
`

definePropAccessorConstructionAmend.timeOut = 30000;
definePropAccessorConstructionAmend.rapidity = 1;

//

function definePropAccessorAlternativeOptions( test )
{
  let context = this;

  _.accessor.methodWithStoringStrategyUnderscore( get1 )

  /* */

  test.case = 'typed:1 static:0 accesors:both';

  var accessor1 = { get : get1, set : set1, grab : grab1, put : put1, move : move1 };
  var accessor2 = { get : get2, set : set2, grab : grab2, put : put2, move : move2 };
  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed( true ),
    f1 : _.define.prop( -100, { addingMethods : 1, static : 0, ... accessor1, accessor : accessor2 } ),
  });
  var instance1 = blueprint.Make();

  test.description = 'instance'; /* */

  test.identical( instance1.f1, 1 );
  test.identical( blueprint.prototype.f1, 1 );
  test.identical( blueprint.Make.f1, undefined );

  var exp =
  {
    f1 : 1,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    x : -70,
  }
  test.identical( _.property.all( instance1._ ), exp );
  test.true( instance1.f1Grab === grab1 );
  test.true( instance1.f1Get === get1 );
  test.true( instance1.f1Put === put1 );
  test.true( instance1.f1Set === set1 );
  test.true( instance1.f1Move === move1 );

  /* */

  test.case = 'typed:true static:0 accesors:unrolled';

  var accessor1 = { get : get1, set : set1, grab : grab1, put : put1, move : move1 };
  var accessor2 = { get : get2, set : set2, grab : grab2, put : put2, move : move2 };
  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed( 1 ),
    f1 : _.define.prop( -100, { addingMethods : 1, static : 0, ... accessor1 } ),
  });
  var instance1 = blueprint.Make();

  test.description = 'instance'; /* */

  test.identical( instance1.f1, 1 );
  test.identical( blueprint.prototype.f1, 1 );
  test.identical( blueprint.Make.f1, undefined );

  var exp =
  {
    f1 : 1,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    x : -70,
  }
  test.identical( _.property.all( instance1._ ), exp );
  test.true( instance1.f1Grab === grab1 );
  test.true( instance1.f1Get === get1 );
  test.true( instance1.f1Put === put1 );
  test.true( instance1.f1Set === set1 );
  test.true( instance1.f1Move === move1 );

  /* */

  test.case = 'typed:true static:0 accesors:map';

  var accessor1 = { get : get1, set : set1, grab : grab1, put : put1, move : move1 };
  var accessor2 = { get : get2, set : set2, grab : grab2, put : put2, move : move2 };
  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed( 1 ),
    f1 : _.define.prop( -100, { addingMethods : 1, static : 0, accessor : accessor1 } ),
  });
  var instance1 = blueprint.Make();

  test.description = 'instance'; /* */

  test.identical( blueprint.prototype.f1, 1 );
  test.identical( blueprint.Make.f1, undefined );

  var exp =
  {
    f1 : 1,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    x : -70,
  }
  test.identical( _.property.all( instance1._ ), exp );
  test.true( instance1.f1Grab === grab1 );
  test.true( instance1.f1Get === get1 );
  test.true( instance1.f1Put === put1 );
  test.true( instance1.f1Set === set1 );
  test.true( instance1.f1Move === move1 );

  /* */

  test.case = 'typed:1 static:1 accesors:both';

  var accessor1 = { get : get1, set : set1, grab : grab1, put : put1, move : move1 };
  var accessor2 = { get : get2, set : set2, grab : grab2, put : put2, move : move2 };
  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed( true ),
    f1 : _.define.prop( -100, { addingMethods : 1, static : 1, ... accessor1, accessor : accessor2 } ),
  });
  var instance1 = blueprint.Make();

  test.description = 'instance'; /* */

  test.identical( instance1.f1, 1 );
  test.identical( blueprint.prototype.f1, 1 );
  test.identical( blueprint.Make.f1, 1 );

  var exp =
  {
    x : -70,
  }
  test.identical( _.property.all( instance1._ ), exp );
  test.true( instance1.f1Grab.originalRoutine === grab1 );
  test.true( instance1.f1Get.originalRoutine === get1 );
  test.true( instance1.f1Put.originalRoutine === put1 );
  test.true( instance1.f1Set.originalRoutine === set1 );
  test.true( instance1.f1Move.originalRoutine === move1 );

  /* */

  test.case = 'typed:true static:1 accesors:unrolled';

  var accessor1 = { get : get1, set : set1, grab : grab1, put : put1, move : move1 };
  var accessor2 = { get : get2, set : set2, grab : grab2, put : put2, move : move2 };
  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed( 1 ),
    f1 : _.define.prop( -100, { addingMethods : 1, static : 1, ... accessor1 } ),
  });
  var instance1 = blueprint.Make();

  test.description = 'instance'; /* */

  test.identical( instance1.f1, 1 );
  test.identical( blueprint.prototype.f1, 1 );
  test.identical( blueprint.Make.f1, 1 );

  var exp =
  {
    x : -70,
  }
  test.identical( _.property.all( instance1._ ), exp );

  test.true( instance1.f1Grab.originalRoutine === grab1 );
  test.true( instance1.f1Get.originalRoutine === get1 );
  test.true( instance1.f1Put.originalRoutine === put1 );
  test.true( instance1.f1Set.originalRoutine === set1 );
  test.true( instance1.f1Move.originalRoutine === move1 );

  /* */

  test.case = 'typed:true static:1 accesors:map';

  var accessor1 = { get : get1, set : set1, grab : grab1, put : put1, move : move1 };
  var accessor2 = { get : get2, set : set2, grab : grab2, put : put2, move : move2 };
  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed( 1 ),
    f1 : _.define.prop( -100, { addingMethods : 1, static : 1, accessor : accessor1 } ),
  });
  var instance1 = blueprint.Make();

  test.description = 'instance'; /* */

  test.identical( instance1.f1, 1 );
  test.identical( blueprint.prototype.f1, 1 );
  test.identical( blueprint.Make.f1, 1 );

  var exp =
  {
    x : -70,
  }
  test.identical( _.property.all( instance1._ ), exp );

  test.true( instance1.f1Grab.originalRoutine === grab1 );
  test.true( instance1.f1Get.originalRoutine === get1 );
  test.true( instance1.f1Put.originalRoutine === put1 );
  test.true( instance1.f1Set.originalRoutine === set1 );
  test.true( instance1.f1Move.originalRoutine === move1 );

  /* */

  function get1()
  {
    return 1;
  }

  /* */

  function get2()
  {
    return 2;
  }

  /* */

  function grab1()
  {
    return 3;
  }

  /* */

  function grab2()
  {
    return 4;
  }

  /* */

  function set1( src )
  {
    this._.x = src + 10;
  }

  /* */

  function set2()
  {
    this._.x = src + 20;
  }

  /* */

  function put1( src )
  {
    this._.x = src + 30;
  }

  /* */

  function put2()
  {
    this._.x = src + 40;
  }

  /* */

  function move1( it )
  {
  }

  /* */

  function move2( it )
  {
  }

}

//

function definePropAccessorStaticNonStatic( test )
{

  /* */

  test.case = 'f1 and s1, typed : true';

  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed( true ),
    f1 : _.define.prop( 1, { accessor : 1 } ),
    s1 : _.define.prop( 2, { static : 1, accessor : 1 } ),
  });
  var instance1 = blueprint1.Make();

  test.description = 'instance'; /* */

  test.identical( instance1.f1, 1 );
  test.identical( blueprint1.prototype.f1, undefined );
  test.identical( blueprint1.Make.f1, undefined );

  test.identical( instance1.s1, 2 );
  test.identical( blueprint1.prototype.s1, 2 );
  test.identical( blueprint1.Make.s1, 2 );

  test.identical( _.prototype.each( instance1 ).length, 3 );
  var exp =
  {
    'f1' : 1,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 1,
  }
  test.identical( _.property.all( instance1._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    's1' : 2,
  }
  test.identical( _.property.all( blueprint1.prototype._, { onlyOwn : 1 } ), exp );

  test.description = 'instance set f1'; /* */

  instance1.f1 = 3;

  test.identical( instance1.f1, 3 );
  test.identical( blueprint1.prototype.f1, undefined );
  test.identical( blueprint1.Make.f1, undefined );

  test.identical( instance1.s1, 2 );
  test.identical( blueprint1.prototype.s1, 2 );
  test.identical( blueprint1.Make.s1, 2 );

  test.identical( _.prototype.each( instance1 ).length, 3 );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.all( instance1._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    's1' : 2,
  }
  test.identical( _.property.all( blueprint1.prototype._, { onlyOwn : 1 } ), exp );

  test.description = 'instance set s1'; /* */

  instance1.s1 = 4;

  test.identical( instance1.f1, 3 );
  test.identical( blueprint1.prototype.f1, undefined );
  test.identical( blueprint1.Make.f1, undefined );

  test.identical( instance1.s1, 4 );
  test.identical( blueprint1.prototype.s1, 4 );
  test.identical( blueprint1.Make.s1, 4 );

  test.identical( _.prototype.each( instance1 ).length, 3 );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.all( instance1._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    's1' : 4,
  }
  test.identical( _.property.all( blueprint1.prototype._, { onlyOwn : 1 } ), exp );

  test.description = 'prototype set f1'; /* */

  blueprint1.prototype.f1 = 5;

  test.identical( instance1.f1, 3 );
  test.identical( blueprint1.prototype.f1, 5 );
  test.identical( blueprint1.Make.f1, undefined );

  test.identical( instance1.s1, 4 );
  test.identical( blueprint1.prototype.s1, 4 );
  test.identical( blueprint1.Make.s1, 4 );

  test.identical( _.prototype.each( instance1 ).length, 3 );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.all( instance1._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    'f1' : 5,
    's1' : 4,
  }
  test.identical( _.property.all( blueprint1.prototype._, { onlyOwn : 1 } ), exp );

  test.description = 'prototype set s1'; /* */

  blueprint1.prototype.s1 = 6;

  test.identical( instance1.f1, 3 );
  test.identical( blueprint1.prototype.f1, 5 );
  test.identical( blueprint1.Make.f1, undefined );

  test.identical( instance1.s1, 6 );
  test.identical( blueprint1.prototype.s1, 6 );
  test.identical( blueprint1.Make.s1, 6 );

  test.identical( _.prototype.each( instance1 ).length, 3 );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.all( instance1._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    'f1' : 5,
    's1' : 6,
  }
  test.identical( _.property.all( blueprint1.prototype._, { onlyOwn : 1 } ), exp );

  /* */

}

//

function definePropAccessorRewriting( test )
{

  /* */

  test.case = 'overriding static:1 by static:1, typed : true';

  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed( true ),
    f1 : _.define.prop( 1, { accessor : 1, static : 1 } ),
  });
  var blueprint2 = _.blueprint.define
  ({
    inherit : _.define.inherit( blueprint1 ),
    f1 : _.define.prop( 2, { accessor : 1, static : 1, combining : 'rewrite' } ),
  });
  var instance1 = blueprint2.Make();

  test.description = 'instance'; /* */

  test.identical( instance1.f1, 2 );
  test.identical( blueprint1.prototype.f1, 1 );
  test.identical( blueprint1.Make.f1, 1 );
  test.identical( blueprint2.prototype.f1, 2 );
  test.identical( blueprint2.Make.f1, 2 );

  test.true( !Object.hasOwnProperty.call( instance1, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint1.prototype, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint2.prototype, '_' ) );
  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 1,
  }
  test.identical( _.property.all( blueprint1.prototype._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    'f1' : 2,
  }
  test.identical( _.property.all( blueprint2.prototype._, { onlyOwn : 1 } ), exp );

  test.description = 'instance set f1'; /* */

  instance1.f1 = 3;

  test.identical( instance1.f1, 3 );
  test.identical( blueprint1.prototype.f1, 1 );
  test.identical( blueprint1.Make.f1, 1 );
  test.identical( blueprint2.prototype.f1, 3 );
  test.identical( blueprint2.Make.f1, 3 );

  test.true( !Object.hasOwnProperty.call( instance1, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint1.prototype, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint2.prototype, '_' ) );
  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.all( instance1._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    'f1' : 1,
  }
  test.identical( _.property.all( blueprint1.prototype._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.all( blueprint2.prototype._, { onlyOwn : 1 } ), exp );

  test.description = 'blueprint1.prototype set f1'; /* */

  blueprint1.prototype.f1 = 5;

  test.true( !Object.hasOwnProperty.call( instance1, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint1.prototype, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint2.prototype, '_' ) );
  test.identical( instance1.f1, 3 );
  test.identical( blueprint1.prototype.f1, 5 );
  test.identical( blueprint1.Make.f1, 5 );
  test.identical( blueprint2.prototype.f1, 3 );
  test.identical( blueprint2.Make.f1, 3 );

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.all( instance1._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    'f1' : 5,
  }
  test.identical( _.property.all( blueprint1.prototype._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.all( blueprint2.prototype._, { onlyOwn : 1 } ), exp );

  test.description = 'blueprint2.prototype set f1'; /* */

  blueprint2.prototype.f1 = 6;

  test.true( !Object.hasOwnProperty.call( instance1, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint1.prototype, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint2.prototype, '_' ) );
  test.identical( instance1.f1, 6 );
  test.identical( blueprint1.prototype.f1, 5 );
  test.identical( blueprint1.Make.f1, 5 );
  test.identical( blueprint2.prototype.f1, 6 );
  test.identical( blueprint2.Make.f1, 6 );

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'f1' : 6,
  }
  test.identical( _.property.all( instance1._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    'f1' : 5,
  }
  test.identical( _.property.all( blueprint1.prototype._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    'f1' : 6,
  }
  test.identical( _.property.all( blueprint2.prototype._, { onlyOwn : 1 } ), exp );

  /* */

  test.case = 'overriding static:1 by static:1, typed : false';

  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed( false ),
    f1 : _.define.prop( 1, { accessor : 1, static : 1 } ),
  });
  var blueprint2 = _.blueprint.define
  ({
    inherit : _.define.inherit( blueprint1 ),
    f1 : _.define.prop( 2, { accessor : 1, static : 1, combining : 'rewrite' } ),
  });
  var instance1 = blueprint2.Make();

  test.description = 'instance'; /* */

  test.identical( blueprint1.prototype, null );
  test.identical( instance1.f1, 2 );
  test.identical( blueprint2.prototype.f1, 2 );
  test.identical( blueprint2.Make.f1, 2 );

  test.true( !Object.hasOwnProperty.call( instance1, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint2.prototype, '_' ) );
  test.identical( _.prototype.each( instance1 ).length, 3 );
  var exp =
  {
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 2,
  }
  test.identical( _.property.all( blueprint2.prototype._, { onlyOwn : 1 } ), exp );

  test.description = 'instance set f1'; /* */

  instance1.f1 = 3;

  test.identical( instance1.f1, 3 );
  test.identical( blueprint2.prototype.f1, 3 );
  test.identical( blueprint2.Make.f1, 3 );

  test.true( !Object.hasOwnProperty.call( instance1, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint2.prototype, '_' ) );
  test.identical( _.prototype.each( instance1 ).length, 3 );

  /* */

  test.case = 'overriding static:0 by static:0, typed : true';

  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed( true ),
    f1 : _.define.prop( 1, { accessor : 1, static : 0 } ),
  });
  var blueprint2 = _.blueprint.define
  ({
    inherit : _.define.inherit( blueprint1 ),
    f1 : _.define.prop( 2, { accessor : 1, static : 0, combining : 'rewrite' } ),
  });
  var instance1 = blueprint2.Make();

  test.description = 'instance'; /* */

  test.identical( instance1.f1, 2 );
  test.identical( blueprint1.prototype.f1, undefined );
  test.identical( blueprint1.Make.f1, undefined );
  test.identical( blueprint2.prototype.f1, undefined );
  test.identical( blueprint2.Make.f1, undefined );

  test.true( Object.hasOwnProperty.call( instance1, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint1.prototype, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint2.prototype, '_' ) );
  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'f1' : 2,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
  }
  test.identical( _.property.all( blueprint1.prototype._, { onlyOwn : 1 } ), exp );
  var exp =
  {
  }
  test.identical( _.property.all( blueprint2.prototype._, { onlyOwn : 1 } ), exp );

  test.description = 'instance set f1'; /* */

  instance1.f1 = 3;

  test.identical( instance1.f1, 3 );
  test.identical( blueprint1.prototype.f1, undefined );
  test.identical( blueprint1.Make.f1, undefined );
  test.identical( blueprint2.prototype.f1, undefined );
  test.identical( blueprint2.Make.f1, undefined );

  test.true( Object.hasOwnProperty.call( instance1, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint1.prototype, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint2.prototype, '_' ) );
  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.all( instance1._, { onlyOwn : 1 } ), exp );
  var exp =
  {
  }
  test.identical( _.property.all( blueprint1.prototype._, { onlyOwn : 1 } ), exp );
  var exp =
  {
  }
  test.identical( _.property.all( blueprint2.prototype._, { onlyOwn : 1 } ), exp );

  test.description = 'blueprint2.prototype set f1'; /* */

  blueprint2.prototype.f1 = 5;

  test.true( Object.hasOwnProperty.call( instance1, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint1.prototype, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint2.prototype, '_' ) );
  test.identical( instance1.f1, 3 );
  test.identical( blueprint1.prototype.f1, undefined );
  test.identical( blueprint1.Make.f1, undefined );
  test.identical( blueprint2.prototype.f1, 5 );
  test.identical( blueprint2.Make.f1, undefined );

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.all( instance1._, { onlyOwn : 1 } ), exp );
  var exp =
  {
  }
  test.identical( _.property.all( blueprint1.prototype._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    'f1' : 5,
  }
  test.identical( _.property.all( blueprint2.prototype._, { onlyOwn : 1 } ), exp );

  test.description = 'blueprint1.prototype set f1'; /* */

  blueprint1.prototype.f1 = 6;

  test.true( Object.hasOwnProperty.call( instance1, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint1.prototype, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint2.prototype, '_' ) );
  test.identical( instance1.f1, 3 );
  test.identical( blueprint1.prototype.f1, 6 );
  test.identical( blueprint1.Make.f1, undefined );
  test.identical( blueprint2.prototype.f1, 5 );
  test.identical( blueprint2.Make.f1, undefined );

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.all( instance1._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    'f1' : 6,
  }
  test.identical( _.property.all( blueprint1.prototype._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    'f1' : 5,
  }
  test.identical( _.property.all( blueprint2.prototype._, { onlyOwn : 1 } ), exp );

  /* */

  test.case = 'overriding static:0 by static:0, typed:false';

  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed( true ),
    f1 : _.define.prop( 1, { accessor : 1, static : 0 } ),
  });
  var blueprint2 = _.blueprint.define
  ({
    inherit : _.define.inherit( blueprint1 ),
    f1 : _.define.prop( 2, { accessor : 1, static : 0, combining : 'rewrite' } ),
  });
  var instance1 = blueprint2.Make();

  test.description = 'instance'; /* */

  test.identical( instance1.f1, 2 );
  test.identical( blueprint1.prototype.f1, undefined );
  test.identical( blueprint1.Make.f1, undefined );
  test.identical( blueprint2.prototype.f1, undefined );
  test.identical( blueprint2.Make.f1, undefined );

  test.true( Object.hasOwnProperty.call( instance1, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint1.prototype, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint2.prototype, '_' ) );
  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'f1' : 2,
  }
  test.identical( _.property.of( instance1 ), exp );

  test.description = 'instance set f1'; /* */

  instance1.f1 = 3;

  test.identical( instance1.f1, 3 );
  test.identical( blueprint1.prototype.f1, undefined );
  test.identical( blueprint1.Make.f1, undefined );
  test.identical( blueprint2.prototype.f1, undefined );
  test.identical( blueprint2.Make.f1, undefined );

  test.true( Object.hasOwnProperty.call( instance1, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint1.prototype, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint2.prototype, '_' ) );
  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.all( instance1._, { onlyOwn : 1 } ), exp );

  test.description = 'blueprint2.prototype set f1'; /* */

  blueprint2.prototype.f1 = 5;

  test.true( Object.hasOwnProperty.call( instance1, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint1.prototype, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint2.prototype, '_' ) );
  test.identical( instance1.f1, 3 );
  test.identical( blueprint1.prototype.f1, undefined );
  test.identical( blueprint1.Make.f1, undefined );
  test.identical( blueprint2.prototype.f1, 5 );
  test.identical( blueprint2.Make.f1, undefined );

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.all( instance1._, { onlyOwn : 1 } ), exp );

  test.description = 'blueprint1.prototype set f1'; /* */

  blueprint1.prototype.f1 = 6;

  test.true( Object.hasOwnProperty.call( instance1, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint1.prototype, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint2.prototype, '_' ) );
  test.identical( instance1.f1, 3 );
  test.identical( blueprint1.prototype.f1, 6 );
  test.identical( blueprint1.Make.f1, undefined );
  test.identical( blueprint2.prototype.f1, 5 );
  test.identical( blueprint2.Make.f1, undefined );

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.all( instance1._, { onlyOwn : 1 } ), exp );

  /* */

  test.case = 'overriding static by non-static, typed : true';

  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed( true ),
    f1 : _.define.prop( 1, { accessor : 1, static : 1 } ),
  });
  var blueprint2 = _.blueprint.define
  ({
    inherit : _.define.inherit( blueprint1 ),
    f1 : _.define.prop( 2, { accessor : 1, static : 0, combining : 'rewrite' } ),
  });
  var instance1 = blueprint2.Make();

  test.description = 'instance'; /* */

  test.true( Object.getPrototypeOf( blueprint2.Make ) === blueprint1.Make );
  test.identical( instance1.f1, 2 );
  test.identical( blueprint1.prototype.f1, 1 );
  test.identical( blueprint1.Make.f1, 1 );
  test.identical( blueprint2.prototype.f1, 1 );
  test.identical( blueprint2.Make.f1, 1 );

  test.true( Object.hasOwnProperty.call( instance1, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint1.prototype, '_' ) );
  test.true( Object.hasOwnProperty.call( blueprint2.prototype, '_' ) );
  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'f1' : 2,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 2,
  }
  test.identical( _.property.all( instance1._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    'f1' : 1,
  }
  test.identical( _.property.all( blueprint1.prototype._, { onlyOwn : 1 } ), exp );
  var exp =
  {
  }
  test.identical( _.property.all( blueprint2.prototype._, { onlyOwn : 1 } ), exp );

  test.description = 'instance set f1'; /* */

  instance1.f1 = 3;

  test.identical( instance1.f1, 3 );
  test.identical( blueprint1.prototype.f1, 1 );
  test.identical( blueprint1.Make.f1, 1 );
  test.identical( blueprint2.prototype.f1, 1 );
  test.identical( blueprint2.Make.f1, 1 );

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.all( instance1._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    'f1' : 1,
  }
  test.identical( _.property.all( blueprint1.prototype._, { onlyOwn : 1 } ), exp );
  var exp =
  {
  }
  test.identical( _.property.all( blueprint2.prototype._, { onlyOwn : 1 } ), exp );

  test.description = 'blueprint1.prototype set f1'; /* */

  blueprint1.prototype.f1 = 5;

  test.identical( instance1.f1, 3 );
  test.identical( blueprint1.prototype.f1, 5 );
  test.identical( blueprint1.Make.f1, 5 );
  test.identical( blueprint2.prototype.f1, 5 );
  test.identical( blueprint2.Make.f1, 5 );

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.all( instance1._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    'f1' : 5,
  }
  test.identical( _.property.all( blueprint1.prototype._, { onlyOwn : 1 } ), exp );
  var exp =
  {
  }
  test.identical( _.property.all( blueprint2.prototype._, { onlyOwn : 1 } ), exp );

  test.description = 'blueprint2.prototype set f1'; /* */

  blueprint2.prototype.f1 = 6;

  test.identical( instance1.f1, 3 );
  test.identical( blueprint1.prototype.f1, 5 );
  test.identical( blueprint1.Make.f1, 5 );
  test.identical( blueprint2.prototype.f1, 6 );
  test.identical( blueprint2.Make.f1, 5 );

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.of( instance1 ), exp );
  var exp =
  {
    'f1' : 3,
  }
  test.identical( _.property.all( instance1._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    'f1' : 5,
  }
  test.identical( _.property.all( blueprint1.prototype._, { onlyOwn : 1 } ), exp );
  var exp =
  {
    'f1' : 6,
  }
  test.identical( _.property.all( blueprint2.prototype._, { onlyOwn : 1 } ), exp );

  /* */

}

//

function definePropConstructionAmendWithBlueprint( test )
{

  let escapedNothing = _.escape.nothing;
  let escapedEscapedNothing = _.escape.left( _.escape.nothing );

  eachTyped({ amending : 'extend' });
  eachTyped({ amending : 'supplement' });

  function eachTyped( tops )
  {
    tops.typed = 0;
    eachVal( tops );
    tops.typed = 1;
    eachVal( tops );
    tops.typed = _.maybe;
    eachVal( tops );
  }

  function eachVal( tops )
  {
    if( tops.typed === undefined )
    tops.typed = 0;

    tops.val = 1;
    act( tops );
    tops.val = _.nothing;
    act( tops );
    tops.val = undefined;
    act( tops );
    tops.val = _.undefined;
    act( tops );
    tops.val = null;
    act( tops );
    tops.val = _.null;
    act( tops );
    tops.val = escapedNothing;
    act( tops );
    tops.val = escapedEscapedNothing;
    act( tops );

  }

  function act( tops )
  {

    _.assert( _.fuzzyLike( tops.typed ) );

    /* */

    test.case = `typed : ${_.toStr( tops.typed )}, static : 0, props, amending : ${tops.amending}, val : ${_.toStr( tops.val )}`;

    var dstContainer =
    {
      f2 : 0,
    }

    var extension = _.Blueprint
    ({
      typed : _.trait.typed( tops.typed ),
      f1 : _.define.prop( tops.val, { static : 0 } ),
      f2 : _.define.prop( tops.val, { static : 0 } ),
    });

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    var exp =
    {
      'f1' : 1,
      'f2' : 1,
    }

    if( tops.val === _.undefined || tops.val === undefined || tops.val === _.nothing )
    {
      exp.f1 = undefined;
      if( tops.val === _.undefined )
      exp.f2 = undefined;
    }
    else if( tops.val === _.null || tops.val === null )
    {
      exp.f1 = null;
      exp.f2 = null;
    }
    else if( tops.val === escapedNothing )
    {
      exp.f1 = _.nothing;
      exp.f2 = _.nothing;
    }
    else if( tops.val === escapedEscapedNothing )
    {
      exp.f1 = escapedNothing;
      exp.f2 = escapedNothing;
    }
    if( tops.amending === 'supplement' || tops.val === undefined || tops.val === _.nothing )
    exp.f2 = 0;

    test.identical( _.property.of( dstContainer ), exp );
    test.true( dstContainer._ === undefined );
    if( tops.typed === 1 )
    test.true( _.prototype.of( dstContainer ) === extension.prototype );
    else
    test.true( _.prototype.of( dstContainer ) === Object.prototype );

    var got = Object.getOwnPropertyDescriptor( dstContainer, 'f1' );
    var exp =
    {
      'enumerable' : true,
      'configurable' : true,
      'writable' : true,
      'value' : 1,
    }

    if( tops.val === _.undefined || tops.val === undefined || tops.val === _.nothing )
    exp.value = undefined;
    else if( tops.val === _.null || tops.val === null )
    exp.value = null;
    else if( tops.val === escapedNothing )
    exp.value = _.nothing;
    else if( tops.val === escapedEscapedNothing )
    exp.value = escapedNothing;

    test.identical( got, exp );
    test.true( _.undefinedIs( got.get ) );
    test.true( _.undefinedIs( got.set ) );

    var got = Object.getOwnPropertyDescriptor( dstContainer, 'f2' );
    var exp =
    {
      'enumerable' : true,
      'configurable' : true,
      'writable' : true,
      'value' : 1,
    }

    if( tops.val === _.undefined )
    exp.value = undefined;
    else if( tops.val === _.null || tops.val === null )
    exp.value = null;
    else if( tops.val === escapedNothing )
    exp.value = _.nothing;
    else if( tops.val === escapedEscapedNothing )
    exp.value = escapedNothing;

    if( tops.amending === 'supplement' || tops.val === undefined || tops.val === _.nothing )
    exp.value = 0;

    test.identical( got, exp );
    test.true( _.undefinedIs( got.get ) );
    test.true( _.undefinedIs( got.set ) );

    /* */

    test.case = `typed : ${_.toStr( tops.typed )}, static : 0, ordinary ( not props ), amending : ${tops.amending}, val : ${_.toStr( tops.val )}`;

    var dstContainer =
    {
      f2 : 0,
    }

    var extension = _.Blueprint
    ({
      typed : _.trait.typed( tops.typed ),
      f1 : _.define.prop( tops.val, { static : 0, valToIns : 'shallow' } ),
      f2 : _.define.prop( tops.val, { static : 0, valToIns : 'shallow' } ),
    });

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    var exp =
    {
      'f1' : 1,
      'f2' : 1,
    }
    if( tops.val === _.undefined || tops.val === undefined || tops.val === _.nothing )
    {
      exp.f1 = undefined;
      if( tops.val === _.undefined )
      exp.f2 = undefined;
    }
    else if( tops.val === _.null || tops.val === null )
    {
      exp.f1 = null;
      exp.f2 = null;
    }
    else if( tops.val === escapedNothing )
    {
      exp.f1 = _.nothing;
      exp.f2 = _.nothing;
    }
    else if( tops.val === escapedEscapedNothing )
    {
      exp.f1 = escapedNothing;
      exp.f2 = escapedNothing;
    }

    if( tops.amending === 'supplement' || tops.val === undefined || tops.val === _.nothing )
    exp.f2 = 0;

    test.identical( _.property.of( dstContainer ), exp );
    test.true( dstContainer._ === undefined );
    if( tops.typed === 1 )
    test.true( _.prototype.of( dstContainer ) === extension.prototype );
    else
    test.true( _.prototype.of( dstContainer ) === Object.prototype );
    test.true( dstContainer._ === undefined );

    var got = Object.getOwnPropertyDescriptor( dstContainer, 'f1' );
    var exp =
    {
      'enumerable' : true,
      'configurable' : true,
      'writable' : true,
      'value' : 1,
    }

    if( tops.val === _.undefined || tops.val === undefined || tops.val === _.nothing )
    exp.value = undefined;
    else if( tops.val === _.null || tops.val === null )
    exp.value = null;
    else if( tops.val === escapedNothing )
    exp.value = _.nothing;
    else if( tops.val === escapedEscapedNothing )
    exp.value = escapedNothing;

    test.identical( got, exp );
    test.true( _.undefinedIs( got.get ) );
    test.true( _.undefinedIs( got.set ) );

    var got = Object.getOwnPropertyDescriptor( dstContainer, 'f2' );
    var exp =
    {
      'enumerable' : true,
      'configurable' : true,
      'writable' : true,
      'value' : 1,
    }

    if( tops.val === _.undefined )
    exp.value = undefined;
    else if( tops.val === _.null || tops.val === null )
    exp.value = null;
    else if( tops.val === escapedNothing )
    exp.value = _.nothing;
    else if( tops.val === escapedEscapedNothing )
    exp.value = escapedNothing;

    if( tops.amending === 'supplement' || tops.val === undefined || tops.val === _.nothing )
    exp.value = 0;

    test.identical( got, exp );
    test.true( _.undefinedIs( got.get ) );
    test.true( _.undefinedIs( got.set ) );

    /* */

    test.case = `typed : ${_.toStr( tops.typed )}, static : 0, configurable : 0, amending : ${tops.amending}, val : ${_.toStr( tops.val )}`;

    var dstContainer =
    {
      f2 : 0,
    }

    var extension = _.Blueprint
    ({
      typed : _.trait.typed( tops.typed ),
      f1 : _.define.prop( tops.val, { static : 0, configurable : 0 } ),
      f2 : _.define.prop( tops.val, { static : 0, configurable : 0 } ),
    });

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    var exp =
    {
      'f1' : 1,
      'f2' : 1,
    }
    if( tops.val === _.undefined || tops.val === undefined || tops.val === _.nothing )
    {
      exp.f1 = undefined;
      if( tops.val === _.undefined )
      exp.f2 = undefined;
    }
    else if( tops.val === _.null || tops.val === null )
    {
      exp.f1 = null;
      exp.f2 = null;
    }
    else if( tops.val === escapedNothing )
    {
      exp.f1 = _.nothing;
      exp.f2 = _.nothing;
    }
    else if( tops.val === escapedEscapedNothing )
    {
      exp.f1 = escapedNothing;
      exp.f2 = escapedNothing;
    }

    if( tops.amending === 'supplement' || tops.val === undefined || tops.val === _.nothing )
    exp.f2 = 0;

    test.identical( _.property.of( dstContainer ), exp );
    test.true( dstContainer._ === undefined );
    if( tops.typed === 1 )
    test.true( _.prototype.of( dstContainer ) === extension.prototype );
    else
    test.true( _.prototype.of( dstContainer ) === Object.prototype );
    test.true( dstContainer._ === undefined );

    var got = Object.getOwnPropertyDescriptor( dstContainer, 'f1' );
    var exp =
    {
      'enumerable' : true,
      'configurable' : false,
      'writable' : true,
      'value' : 1,
    }

    if( tops.val === _.undefined || tops.val === undefined || tops.val === _.nothing )
    exp.value = undefined;
    else if( tops.val === _.null || tops.val === null )
    exp.value = null;
    else if( tops.val === escapedNothing )
    exp.value = _.nothing;
    else if( tops.val === escapedEscapedNothing )
    exp.value = escapedNothing;

    test.identical( got, exp );
    test.true( _.undefinedIs( got.get ) );
    test.true( _.undefinedIs( got.set ) );

    var got = Object.getOwnPropertyDescriptor( dstContainer, 'f2' );
    var exp =
    {
      'enumerable' : true,
      'configurable' : false,
      'writable' : true,
      'value' : 1,
    }

    if( tops.val === _.undefined )
    exp.value = undefined;
    else if( tops.val === _.null || tops.val === null )
    exp.value = null;
    else if( tops.val === escapedNothing )
    exp.value = _.nothing;
    else if( tops.val === escapedEscapedNothing )
    exp.value = escapedNothing;

    if( tops.amending === 'supplement' || tops.val === undefined || tops.val === _.nothing )
    exp.value = 0;

    test.identical( got, exp );
    test.true( _.undefinedIs( got.get ) );
    test.true( _.undefinedIs( got.set ) );

    /* */

    test.case = `typed : ${_.toStr( tops.typed )}, static : 0, accessor : 1, amending : ${tops.amending}, val : ${_.toStr( tops.val )}`;

    var dstContainer =
    {
      f2 : 0,
    }

    var extension = _.Blueprint
    ({
      typed : _.trait.typed( tops.typed ),
      f1 : _.define.prop( tops.val, { static : 0, accessor : 1 } ),
      f2 : _.define.prop( tops.val, { static : 0, accessor : 1 } ),
    });

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    var exp =
    {
      'f1' : 1,
      'f2' : 1,
    }

    if( tops.val === _.undefined || tops.val === undefined || tops.val === _.nothing )
    {
      exp.f1 = undefined;
      if( tops.val === _.undefined )
      exp.f2 = undefined;
    }
    else if( tops.val === _.null || tops.val === null )
    {
      exp.f1 = null;
      exp.f2 = null;
    }
    else if( tops.val === escapedNothing )
    {
      exp.f1 = _.nothing;
      exp.f2 = _.nothing;
    }
    else if( tops.val === escapedEscapedNothing )
    {
      exp.f1 = escapedNothing;
      exp.f2 = escapedNothing;
    }
    if( tops.amending === 'supplement' || tops.val === undefined || tops.val === _.nothing )
    exp.f2 = 0;

    test.identical( _.property.of( dstContainer ), exp );
    test.true( _.mapIs( dstContainer._ ) ^ tops.typed === 1 );
    test.true( _.mapIs( dstContainer ) ^ tops.typed === 1 );

    var got = Object.getOwnPropertyDescriptor( tops.typed === 1 ? _.prototype.of( dstContainer ) : dstContainer, 'f1' );
    var exp =
    {
      'get' : got.get,
      'set' : got.set,
      'enumerable' : true,
      'configurable' : true,
    }

    test.identical( got, exp );
    test.true( _.routineIs( got.get ) );
    test.true( _.routineIs( got.set ) );

    var got = Object.getOwnPropertyDescriptor( tops.typed === 1 ? _.prototype.of( dstContainer ) : dstContainer, 'f2' );
    var exp =
    {
      'get' : got.get,
      'set' : got.set,
      'enumerable' : true,
      'configurable' : true,
    }

    test.identical( got, exp );
    test.true( _.routineIs( got.get ) );
    test.true( _.routineIs( got.set ) );

    /* */

    if( tops.typed === 1 )
    {

      test.case = `typed : ${_.toStr( tops.typed )}, static : 1, accessor : 1, amending : ${tops.amending}, val : ${_.toStr( tops.val )}, amending polluted map`;

      var dstContainer =
      {
        f2 : 0,
      }

      var extension = _.Blueprint
      ({
        typed : _.trait.typed( tops.typed ),
        f1 : _.define.prop( tops.val, { static : 1, accessor : 1 } ),
        f2 : _.define.prop( tops.val, { static : 1, accessor : 1 } ),
      });

      var keysBefore = _.mapAllKeys( Object.prototype );
      _.construction[ tops.amending ]( dstContainer, extension );
      var keysAfter = _.mapAllKeys( Object.prototype );
      test.identical( keysAfter, keysBefore );

      if( tops.val === _.undefined || tops.val === undefined || tops.val === _.nothing )
      {
        test.identical( _.prototype.of( dstContainer ).f1, undefined );
        test.identical( _.prototype.of( dstContainer ).f2, undefined );

        test.identical( dstContainer.f1, undefined );
        test.identical( dstContainer.f2, 0 );
      }
      else if( tops.val === _.null || tops.val === null )
      {
        test.identical( _.prototype.of( dstContainer ).f1, null );
        test.identical( _.prototype.of( dstContainer ).f2, null );

        test.identical( dstContainer.f1, null );
        test.identical( dstContainer.f2, 0 );
      }
      else if( tops.val === escapedNothing )
      {
        test.identical( _.prototype.of( dstContainer ).f1, _.nothing );
        test.identical( _.prototype.of( dstContainer ).f2, _.nothing );

        test.identical( dstContainer.f1, _.nothing );
        test.identical( dstContainer.f2, 0 );
      }
      else if( tops.val === escapedEscapedNothing )
      {
        test.identical( _.prototype.of( dstContainer ).f1, _.escape.nothing );
        test.identical( _.prototype.of( dstContainer ).f2, _.escape.nothing );

        test.identical( dstContainer.f1, _.escape.nothing );
        test.identical( dstContainer.f2, 0 );
      }
      else
      {
        test.identical( _.prototype.of( dstContainer ).f1, 1 );
        test.identical( _.prototype.of( dstContainer ).f2, 1 );

        test.identical( dstContainer.f1, 1 );
        test.identical( dstContainer.f2, 0 );
      }

      test.true( _.mapIs( dstContainer._ ) );
      test.true( _.mapIs( dstContainer ) ^ tops.typed === 1 );

      var got = Object.getOwnPropertyDescriptor( _.prototype.of( dstContainer ), 'f1' );
      var exp =
      {
        'get' : got.get,
        'set' : got.set,
        'enumerable' : false,
        'configurable' : true,
      }

      test.identical( got, exp );
      test.true( _.routineIs( got.get ) );
      test.true( _.routineIs( got.set ) );

      var got = Object.getOwnPropertyDescriptor( _.prototype.of( dstContainer ), 'f2' );
      var exp =
      {
        'get' : got.get,
        'set' : got.set,
        'enumerable' : false,
        'configurable' : true,
      }

      test.identical( got, exp );
      test.true( _.routineIs( got.get ) );
      test.true( _.routineIs( got.set ) );

    }

    /* */

    if( tops.typed === _.maybe )
    {

      test.case = `typed : ${_.toStr( tops.typed )}, static : 1, accessor : 1, amending : ${tops.amending}, val : ${_.toStr( tops.val )}, amending polluted map`;

      var dstContainer =
      {
        f2 : 0,
      }

      var extension = _.Blueprint
      ({
        typed : _.trait.typed( tops.typed ),
        f1 : _.define.prop( tops.val, { static : 1, accessor : 1 } ),
        f2 : _.define.prop( tops.val, { static : 1, accessor : 1 } ),
      });

      var keysBefore = _.mapAllKeys( Object.prototype );
      _.construction[ tops.amending ]( dstContainer, extension );
      var keysAfter = _.mapAllKeys( Object.prototype );
      test.identical( keysAfter, keysBefore );

      test.identical( _.prototype.of( dstContainer ).f1, undefined );
      test.identical( _.prototype.of( dstContainer ).f2, undefined );

      test.identical( dstContainer.f1, undefined );
      test.identical( dstContainer.f2, 0 );

      test.true( !dstContainer._ );
      test.true( _.mapIs( dstContainer ) ^ tops.typed === 1 );

      var exp = { f2 : 0 }
      test.identical( _.property.all( dstContainer, { onlyEnumerable : 1 } ), exp );

    }

    /* */

    if( tops.typed )
    {

      test.case = `typed : ${_.toStr( tops.typed )}, static : 1, accessor : 1, amending : ${tops.amending}, val : ${_.toStr( tops.val )}, amending object`;

      var prototype = Object.create( null );
      prototype.f2 = 0;
      var dstContainer = Object.create( prototype );

      var extension = _.Blueprint
      ({
        typed : _.trait.typed( tops.typed, { prototype } ),
        f1 : _.define.prop( tops.val, { static : 1, accessor : 1 } ),
        f2 : _.define.prop( tops.val, { static : 1, accessor : 1 } ),
      });

      var keysBefore = _.mapAllKeys( Object.prototype );
      _.construction[ tops.amending ]( dstContainer, extension );
      var keysAfter = _.mapAllKeys( Object.prototype );
      test.identical( keysAfter, keysBefore );

      if( tops.val === _.nothing || tops.val === undefined )
      {
        test.identical( _.prototype.of( dstContainer ).f1, undefined );
        test.identical( _.prototype.of( dstContainer ).f2, 0 );
        test.identical( dstContainer.f1, undefined );
        test.identical( dstContainer.f2, 0 );
      }
      else if( tops.val === _.undefined )
      {
        test.identical( _.prototype.of( dstContainer ).f1, undefined );
        test.identical( _.prototype.of( dstContainer ).f2, undefined );
        test.identical( dstContainer.f1, undefined );
        test.identical( dstContainer.f2, undefined );
      }
      else if( tops.val === _.null || tops.val === null )
      {
        test.identical( _.prototype.of( dstContainer ).f1, null );
        test.identical( _.prototype.of( dstContainer ).f2, null );
        test.identical( dstContainer.f1, null );
        test.identical( dstContainer.f2, null );
      }
      else if( tops.val === escapedNothing )
      {
        test.identical( _.prototype.of( dstContainer ).f1, _.nothing );
        test.identical( _.prototype.of( dstContainer ).f2, _.nothing );
        test.identical( dstContainer.f1, _.nothing );
        test.identical( dstContainer.f2, _.nothing );
      }
      else if( tops.val === escapedEscapedNothing )
      {
        test.identical( _.prototype.of( dstContainer ).f1, _.escape.nothing );
        test.identical( _.prototype.of( dstContainer ).f2, _.escape.nothing );
        test.identical( dstContainer.f1, _.escape.nothing );
        test.identical( dstContainer.f2, _.escape.nothing );
      }
      else
      {
        test.identical( _.prototype.of( dstContainer ).f1, 1 );
        test.identical( _.prototype.of( dstContainer ).f2, 1 );
        test.identical( dstContainer.f1, 1 );
        test.identical( dstContainer.f2, 1 );
      }

      test.true( _.objectIs( dstContainer._ ) );
      test.true( _.objectIs( _.prototype.of( dstContainer )._ ) );
      test.true( _.mapIs( dstContainer ) ^ !!tops.typed );

      var got = Object.getOwnPropertyDescriptor( extension.prototype, 'f1' );
      var exp =
      {
        'get' : got.get,
        'set' : got.set,
        'enumerable' : false,
        'configurable' : true,
      }

      test.identical( got, exp );
      test.true( _.routineIs( got.get ) );
      test.true( _.routineIs( got.set ) );

      var got = Object.getOwnPropertyDescriptor( extension.prototype, 'f2' );
      var exp =
      {
        'get' : got.get,
        'set' : got.set,
        'enumerable' : false,
        'configurable' : true,
      }

      test.identical( got, exp );
      test.true( _.routineIs( got.get ) );
      test.true( _.routineIs( got.set ) );

    }

    /* */

    if( tops.typed )
    {

      test.case = `typed : ${_.toStr( tops.typed )}, static : 1, accessor : 1, amending : ${tops.amending}, val : ${_.toStr( tops.val )}, amending object by map`;

      var prototype = Object.create( null );
      prototype.f2 = 0;
      var dstContainer = Object.create( prototype );

      var extension =
      {
        typed : _.trait.typed( tops.typed, { prototype } ),
        f1 : _.define.prop( tops.val, { static : 1, accessor : 1 } ),
        f2 : _.define.prop( tops.val, { static : 1, accessor : 1 } ),
      };

      var keysBefore = _.mapAllKeys( Object.prototype );
      _.construction[ tops.amending ]( dstContainer, extension );
      var keysAfter = _.mapAllKeys( Object.prototype );
      test.identical( keysAfter, keysBefore );

      if( tops.amending === 'supplement' )
      {
        if( tops.val === _.nothing || tops.val === undefined )
        {
          test.identical( _.prototype.of( dstContainer ).f1, undefined );
          test.identical( _.prototype.of( dstContainer ).f2, 0 );
          test.identical( dstContainer.f1, undefined );
          test.identical( dstContainer.f2, 0 );
        }
        else if( tops.val === _.undefined )
        {
          test.identical( _.prototype.of( dstContainer ).f1, undefined );
          test.identical( _.prototype.of( dstContainer ).f2, 0 );
          test.identical( dstContainer.f1, undefined );
          test.identical( dstContainer.f2, 0 );
        }
        else if( tops.val === _.null || tops.val === null )
        {
          test.identical( _.prototype.of( dstContainer ).f1, null );
          test.identical( _.prototype.of( dstContainer ).f2, 0 );
          test.identical( dstContainer.f1, null );
          test.identical( dstContainer.f2, 0 );
        }
        else if( tops.val === escapedNothing )
        {
          test.identical( _.prototype.of( dstContainer ).f1, _.nothing );
          test.identical( _.prototype.of( dstContainer ).f2, 0 );
          test.identical( dstContainer.f1, _.nothing );
          test.identical( dstContainer.f2, 0 );
        }
        else if( tops.val === escapedEscapedNothing )
        {
          test.identical( _.prototype.of( dstContainer ).f1, _.escape.nothing );
          test.identical( _.prototype.of( dstContainer ).f2, 0 );
          test.identical( dstContainer.f1, _.escape.nothing );
          test.identical( dstContainer.f2, 0 );
        }
        else
        {
          test.identical( _.prototype.of( dstContainer ).f1, 1 );
          test.identical( _.prototype.of( dstContainer ).f2, 0 );
          test.identical( dstContainer.f1, 1 );
          test.identical( dstContainer.f2, 0 );
        }
      }
      else
      {
        if( tops.val === _.nothing || tops.val === undefined )
        {
          test.identical( _.prototype.of( dstContainer ).f1, undefined );
          test.identical( _.prototype.of( dstContainer ).f2, 0 );
          test.identical( dstContainer.f1, undefined );
          test.identical( dstContainer.f2, 0 );
        }
        else if( tops.val === _.undefined )
        {
          test.identical( _.prototype.of( dstContainer ).f1, undefined );
          test.identical( _.prototype.of( dstContainer ).f2, undefined );
          test.identical( dstContainer.f1, undefined );
          test.identical( dstContainer.f2, undefined );
        }
        else if( tops.val === _.null || tops.val === null )
        {
          test.identical( _.prototype.of( dstContainer ).f1, null );
          test.identical( _.prototype.of( dstContainer ).f2, null );
          test.identical( dstContainer.f1, null );
          test.identical( dstContainer.f2, null );
        }
        else if( tops.val === escapedNothing )
        {
          test.identical( _.prototype.of( dstContainer ).f1, _.nothing );
          test.identical( _.prototype.of( dstContainer ).f2, _.nothing );
          test.identical( dstContainer.f1, _.nothing );
          test.identical( dstContainer.f2, _.nothing );
        }
        else if( tops.val === escapedEscapedNothing )
        {
          test.identical( _.prototype.of( dstContainer ).f1, _.escape.nothing );
          test.identical( _.prototype.of( dstContainer ).f2, _.escape.nothing );
          test.identical( dstContainer.f1, _.escape.nothing );
          test.identical( dstContainer.f2, _.escape.nothing );
        }
        else
        {
          test.identical( _.prototype.of( dstContainer ).f1, 1 );
          test.identical( _.prototype.of( dstContainer ).f2, 1 );
          test.identical( dstContainer.f1, 1 );
          test.identical( dstContainer.f2, 1 );
        }
      }

      test.true( _.objectIs( dstContainer._ ) );
      test.true( _.objectIs( _.prototype.of( dstContainer )._ ) );
      test.true( _.mapIs( dstContainer ) ^ !!tops.typed );

      var got = Object.getOwnPropertyDescriptor( _.prototype.of( dstContainer ), 'f1' );
      var exp =
      {
        'get' : got.get,
        'set' : got.set,
        'enumerable' : false,
        'configurable' : true,
      }

      test.identical( got, exp );
      test.true( _.routineIs( got.get ) );
      test.true( _.routineIs( got.set ) );

      var got = Object.getOwnPropertyDescriptor( _.prototype.of( dstContainer ), 'f2' );
      var exp =
      {
        'get' : got.get,
        'set' : got.set,
        'enumerable' : false,
        'configurable' : true,
      }

      test.identical( got, exp );
      test.true( _.routineIs( got.get ) );
      test.true( _.routineIs( got.set ) );

    }

    /* */

    if( tops.typed )
    {

      test.case = `typed : ${_.toStr( tops.typed )}, static : 1, accessor : 0, amending : ${tops.amending}, val : ${_.toStr( tops.val )}, amending object by map`;

      var prototype = Object.create( null );
      prototype.f2 = 0;
      var dstContainer = Object.create( prototype );

      var extension =
      {
        typed : _.trait.typed( tops.typed, { prototype } ),
        f1 : _.define.prop( tops.val, { static : 1, accessor : 0 } ),
        f2 : _.define.prop( tops.val, { static : 1, accessor : 0 } ),
      };

      var keysBefore = _.mapAllKeys( Object.prototype );
      _.construction[ tops.amending ]( dstContainer, extension );
      var keysAfter = _.mapAllKeys( Object.prototype );
      test.identical( keysAfter, keysBefore );

      if( tops.amending === 'supplement' )
      {
        if( tops.val === _.nothing || tops.val === undefined )
        {
          test.identical( _.prototype.of( dstContainer ).f1, undefined );
          test.identical( _.prototype.of( dstContainer ).f2, 0 );
          test.identical( dstContainer.f1, undefined );
          test.identical( dstContainer.f2, 0 );
        }
        else if( tops.val === _.undefined )
        {
          test.identical( _.prototype.of( dstContainer ).f1, undefined );
          test.identical( _.prototype.of( dstContainer ).f2, 0 );
          test.identical( dstContainer.f1, undefined );
          test.identical( dstContainer.f2, 0 );
        }
        else if( tops.val === _.null || tops.val === null )
        {
          test.identical( _.prototype.of( dstContainer ).f1, null );
          test.identical( _.prototype.of( dstContainer ).f2, 0 );
          test.identical( dstContainer.f1, null );
          test.identical( dstContainer.f2, 0 );
        }
        else if( tops.val === escapedNothing )
        {
          test.identical( _.prototype.of( dstContainer ).f1, _.nothing );
          test.identical( _.prototype.of( dstContainer ).f2, 0 );
          test.identical( dstContainer.f1, _.nothing );
          test.identical( dstContainer.f2, 0 );
        }
        else if( tops.val === escapedEscapedNothing )
        {
          test.identical( _.prototype.of( dstContainer ).f1, _.escape.nothing );
          test.identical( _.prototype.of( dstContainer ).f2, 0 );
          test.identical( dstContainer.f1, _.escape.nothing );
          test.identical( dstContainer.f2, 0 );
        }
        else
        {
          test.identical( _.prototype.of( dstContainer ).f1, 1 );
          test.identical( _.prototype.of( dstContainer ).f2, 0 );
          test.identical( dstContainer.f1, 1 );
          test.identical( dstContainer.f2, 0 );
        }
      }
      else
      {
        if( tops.val === _.nothing || tops.val === undefined )
        {
          test.identical( _.prototype.of( dstContainer ).f1, undefined );
          test.identical( _.prototype.of( dstContainer ).f2, 0 );
          test.identical( dstContainer.f1, undefined );
          test.identical( dstContainer.f2, 0 );
        }
        else if( tops.val === _.undefined )
        {
          test.identical( _.prototype.of( dstContainer ).f1, undefined );
          test.identical( _.prototype.of( dstContainer ).f2, undefined );
          test.identical( dstContainer.f1, undefined );
          test.identical( dstContainer.f2, undefined );
        }
        else if( tops.val === _.null || tops.val === null )
        {
          test.identical( _.prototype.of( dstContainer ).f1, null );
          test.identical( _.prototype.of( dstContainer ).f2, null );
          test.identical( dstContainer.f1, null );
          test.identical( dstContainer.f2, null );
        }
        else if( tops.val === escapedNothing )
        {
          test.identical( _.prototype.of( dstContainer ).f1, _.nothing );
          test.identical( _.prototype.of( dstContainer ).f2, _.nothing );
          test.identical( dstContainer.f1, _.nothing );
          test.identical( dstContainer.f2, _.nothing );
        }
        else if( tops.val === escapedEscapedNothing )
        {
          test.identical( _.prototype.of( dstContainer ).f1, _.escape.nothing );
          test.identical( _.prototype.of( dstContainer ).f2, _.escape.nothing );
          test.identical( dstContainer.f1, _.escape.nothing );
          test.identical( dstContainer.f2, _.escape.nothing );
        }
        else
        {
          test.identical( _.prototype.of( dstContainer ).f1, 1 );
          test.identical( _.prototype.of( dstContainer ).f2, 1 );
          test.identical( dstContainer.f1, 1 );
          test.identical( dstContainer.f2, 1 );
        }
      }

      test.true( dstContainer._ === undefined );
      test.true( _.prototype.of( dstContainer )._ === undefined );
      test.true( _.mapIs( dstContainer ) ^ !!tops.typed );

      var got = Object.getOwnPropertyDescriptor( _.prototype.of( dstContainer ), 'f1' );
      var exp =
      {
        'get' : got.get,
        'set' : got.set,
        'enumerable' : false,
        'configurable' : true,
      }

      test.identical( got, exp );
      test.true( _.routineIs( got.get ) );
      test.true( _.routineIs( got.set ) );

      var got = Object.getOwnPropertyDescriptor( _.prototype.of( dstContainer ), 'f2' );
      var exp =
      {
        'get' : got.get,
        'set' : got.set,
        'enumerable' : false,
        'configurable' : true,
      }

      test.identical( got, exp );
      test.true( _.routineIs( got.get ) );
      test.true( _.routineIs( got.set ) );

    }

    /* */

  }

}

definePropConstructionAmendWithBlueprint.timeOut = 60000;

// --
// define alias
// --

function definePropAliasBasic( test )
{

  /* */

  test.case = 'typed:true';
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    f1 : '1',
    s1 : _.define.prop( '1', { static : 1, enumerable : 1 } ),
    af1p : _.define.alias({ originalName : 'f1', static : 0, enumerable : 1 }),
    af1s : _.define.alias({ originalName : 'f1', static : 1, enumerable : 1 }),
    as1p : _.define.alias({ originalName : 's1', static : 0, enumerable : 1 }),
    as1s : _.define.alias({ originalName : 's1', static : 1, enumerable : 1 }),
  });

  var instance1 = Blueprint1.Make();
  var exp =
  {
    'f1' : '1',
    's1' : '1',
    'af1p' : '1',
    'af1s' : undefined,
    'as1p' : '1',
    'as1s' : '1'
  }
  test.identical( _.property.of( instance1, { onlyOwn : 0 } ), exp );

  test.true( instance1._ === undefined );

  var exp =
  {
    'f1' : '1',
    's1' : '1',
    'af1p' : '1',
    'af1s' : undefined,
    'as1p' : '1',
    'as1s' : '1'
  }
  test.identical( _.mapExtend( null, instance1 ), exp );

  test.description = 'descriptor of f1'; /* */

  var exp =
  {
    'value' : '1',
    'writable' : true,
    'enumerable' : true,
    'configurable' : true,
  }
  var got = Object.getOwnPropertyDescriptor( instance1, 'f1' );
  test.identical( got, exp );
  var exp = undefined;
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'f1' );
  test.identical( got, exp );

  test.description = 'descriptor of af1p'; /* */

  var exp = undefined;
  var got = Object.getOwnPropertyDescriptor( instance1, 'af1p' );
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'af1p' );
  var exp =
  {
    get : got.get,
    set : got.set,
    'enumerable' : true,
    'configurable' : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of af1s'; /* */

  var exp = undefined;
  var got = Object.getOwnPropertyDescriptor( instance1, 'af1s' );
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'af1s' );
  var exp =
  {
    get : got.get,
    set : got.set,
    'enumerable' : true,
    'configurable' : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of s1'; /* */

  var exp = undefined;
  var got = Object.getOwnPropertyDescriptor( instance1, 's1' );
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 's1' );
  var exp =
  {
    get : got.get,
    set : got.set,
    'enumerable' : true,
    'configurable' : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of as1p'; /* */

  var exp = undefined;
  var got = Object.getOwnPropertyDescriptor( instance1, 'as1p' );
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'as1p' );
  var exp =
  {
    get : got.get,
    set : got.set,
    'enumerable' : true,
    'configurable' : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of as1s'; /* */

  var exp = undefined;
  var got = Object.getOwnPropertyDescriptor( instance1, 'as1s' );
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'as1s' );
  var exp =
  {
    get : got.get,
    set : got.set,
    'enumerable' : true,
    'configurable' : true,
  }
  test.identical( got, exp );

  test.description = 'set f1'; /* */
  instance1.f1 = '2';

  var exp =
  {
    'f1' : '2',
    's1' : '1',
    'af1p' : '2',
    'af1s' : undefined,
    'as1p' : '1',
    'as1s' : '1'
  }
  test.identical( _.property.of( instance1, { onlyOwn : 0 } ), exp );

  test.true( instance1._ === undefined );

  test.description = 'set af1p'; /* */
  instance1.af1p = 'af1p';

  var exp =
  {
    'f1' : 'af1p',
    's1' : '1',
    'af1p' : 'af1p',
    'af1s' : undefined,
    'as1p' : '1',
    'as1s' : '1'
  }
  test.identical( _.property.of( instance1, { onlyOwn : 0 } ), exp );

  test.true( instance1._ === undefined );

  test.description = 'set af1s'; /* */
  instance1.af1s = 'af1s'

  var exp =
  {
    'f1' : 'af1p',
    's1' : '1',
    'af1p' : 'af1p',
    'af1s' : 'af1s',
    'as1p' : '1',
    'as1s' : '1'
  }
  test.identical( _.property.of( instance1, { onlyOwn : 0 } ), exp );

  test.true( instance1._ === undefined );

  test.true( Blueprint1.prototype._ === undefined );

  test.description = 'set s1'; /* */
  instance1.s1 = '3';

  var exp =
  {
    'f1' : 'af1p',
    's1' : '3',
    'af1p' : 'af1p',
    'af1s' : 'af1s',
    'as1p' : '3',
    'as1s' : '3'
  };
  test.identical( _.property.of( instance1, { onlyOwn : 0 } ), exp );

  test.true( instance1._ === undefined );

  test.description = 'set as1p'; /* */
  instance1.as1p = '4';

  var exp =
  {
    'f1' : 'af1p',
    's1' : '4',
    'af1p' : 'af1p',
    'af1s' : 'af1s',
    'as1p' : '4',
    'as1s' : '4'
  }
  test.identical( _.property.of( instance1, { onlyOwn : 0 } ), exp );

  test.true( instance1._ === undefined );

  test.description = 'set as1s'; /* */
  instance1.as1s = '5';

  var exp =
  {
    'f1' : 'af1p',
    's1' : '5',
    'af1p' : 'af1p',
    'af1s' : 'af1s',
    'as1p' : '5',
    'as1s' : '5'
  }
  test.identical( _.property.of( instance1, { onlyOwn : 0 } ), exp );

  test.true( instance1._ === undefined );

  /* */

  test.case = 'typed:false';
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( false ),
    f1 : '1',
    s1 : _.define.prop( '1', { static : 1, enumerable : 1 } ),
    af1p : _.define.alias({ originalName : 'f1', static : 0, enumerable : 1 }),
    af1s : _.define.alias({ originalName : 'f1', static : 1, enumerable : 1 }),
    as1p : _.define.alias({ originalName : 's1', static : 0, enumerable : 1 }),
    as1s : _.define.alias({ originalName : 's1', static : 1, enumerable : 1 }),
  });

  var instance1 = Blueprint1.Make();
  var exp =
  {
    'f1' : '1',
    'af1p' : '1',
    'as1p' : undefined,
  }
  test.identical( _.property.of( instance1, { onlyOwn : 0 } ), exp );

  test.true( instance1._ === undefined );

  var exp =
  {
    'f1' : '1',
    'af1p' : '1',
    'as1p' : undefined,
  }
  test.identical( _.mapExtend( null, instance1 ), exp );

  test.description = 'descriptor of f1'; /* */

  var exp =
  {
    'value' : '1',
    'writable' : true,
    'enumerable' : true,
    'configurable' : true,
  }
  var got = Object.getOwnPropertyDescriptor( instance1, 'f1' );
  test.identical( got, exp );
  test.true( Blueprint1.prototype === null );
  // var exp = undefined;
  // var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'f1' );
  // test.identical( got, exp );

  test.description = 'descriptor of af1p'; /* */

  var got = Object.getOwnPropertyDescriptor( instance1, 'af1p' );
  var exp =
  {
    get : got.get,
    set : got.set,
    'enumerable' : true,
    'configurable' : true,
  }
  test.identical( got, exp );
  // var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'af1p' );
  // var exp = undefined;
  // test.identical( got, exp );

  test.description = 'descriptor of af1s'; /* */

  var exp = undefined;
  var got = Object.getOwnPropertyDescriptor( instance1, 'af1s' );
  test.identical( got, exp );
  // var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'af1s' );
  // var exp =
  // {
  //   get : got.get,
  //   set : got.set,
  //   'enumerable' : true,
  //   'configurable' : true,
  // }
  // test.identical( got, exp );

  test.description = 'descriptor of s1'; /* */

  var exp = undefined;
  var got = Object.getOwnPropertyDescriptor( instance1, 's1' );
  test.identical( got, exp );
  // var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 's1' );
  // var exp =
  // {
  //   get : got.get,
  //   set : got.set,
  //   'enumerable' : true,
  //   'configurable' : true,
  // }
  // test.identical( got, exp );

  test.description = 'descriptor of as1p'; /* */

  var got = Object.getOwnPropertyDescriptor( instance1, 'as1p' );
  var exp =
  {
    get : got.get,
    set : got.set,
    'enumerable' : true,
    'configurable' : true,
  }
  test.identical( got, exp );
  // var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'as1p' );
  // var exp = undefined;
  // test.identical( got, exp );

  test.description = 'descriptor of as1s'; /* */

  var exp = undefined;
  var got = Object.getOwnPropertyDescriptor( instance1, 'as1s' );
  test.identical( got, exp );
  // var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'as1s' );
  // var exp =
  // {
  //   get : got.get,
  //   set : got.set,
  //   'enumerable' : true,
  //   'configurable' : true,
  // }
  // test.identical( got, exp );

  test.description = 'set f1'; /* */
  instance1.f1 = '2';

  var exp =
  {
    'f1' : '2',
    'af1p' : '2',
    'as1p' : undefined,
  }
  test.identical( _.property.of( instance1, { onlyOwn : 0 } ), exp );

  test.true( instance1._ === undefined );

  test.description = 'set af1p'; /* */
  instance1.af1p = 'af1p';

  var exp =
  {
    'f1' : 'af1p',
    'af1p' : 'af1p',
    'as1p' : undefined,
  }
  test.identical( _.property.of( instance1, { onlyOwn : 0 } ), exp );

  test.true( instance1._ === undefined );

  test.description = 'set af1s'; /* */
  test.shouldThrowErrorSync( () => instance1.af1s = 'af1s' );

  var exp =
  {
    'f1' : 'af1p',
    'af1p' : 'af1p',
    'as1p' : undefined,
  }
  test.identical( _.property.of( instance1, { onlyOwn : 0 } ), exp );

  test.true( instance1._ === undefined );

  test.description = 'set s1'; /* */
  test.shouldThrowErrorSync( () => instance1.s1 = '3' );

  var exp =
  {
    'f1' : 'af1p',
    'af1p' : 'af1p',
    'as1p' : undefined,
  }
  test.identical( _.property.of( instance1, { onlyOwn : 0 } ), exp );

  var exp =
  {
  }
  test.true( instance1._ === undefined );

  test.description = 'set as1p'; /* */
  test.shouldThrowErrorSync( () => instance1.as1p = '4' );

  var exp =
  {
    'f1' : 'af1p',
    'af1p' : 'af1p',
    'as1p' : undefined,
  }
  test.identical( _.property.of( instance1, { onlyOwn : 0 } ), exp );

  var exp =
  {
  }
  test.true( instance1._ === undefined );

  test.description = 'set as1s'; /* */
  test.shouldThrowErrorSync( () => instance1.as1s = '5' );

  var exp =
  {
    'f1' : 'af1p',
    'af1p' : 'af1p',
    'as1p' : undefined,
  }
  test.identical( _.property.of( instance1, { onlyOwn : 0 } ), exp );

  var exp =
  {
  }
  test.true( instance1._ === undefined );

  /* */

  test.case = 'typed:true, enumerable : implicit';
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    f1 : '1',
    s1 : _.define.prop( '1', { static : 1 } ),
    af1p : _.define.alias({ originalName : 'f1', static : 0 }),
    af1s : _.define.alias({ originalName : 'f1', static : 1 }),
    as1p : _.define.alias({ originalName : 's1', static : 0 }),
    as1s : _.define.alias({ originalName : 's1', static : 1 }),
  });

  var instance1 = Blueprint1.Make();
  var exp =
  {
    'f1' : '1',
    'af1p' : '1',
    'as1p' : '1',
  }
  test.identical( _.property.of( instance1, { onlyOwn : 0 } ), exp );

  var exp =
  {
  }
  test.true( instance1._ === undefined );

  var exp =
  {
    'f1' : '1',
    'af1p' : '1',
    'as1p' : '1',
  }
  test.identical( _.mapExtend( null, instance1 ), exp );

  test.description = 'descriptor of f1'; /* */

  var exp =
  {
    'value' : '1',
    'writable' : true,
    'enumerable' : true,
    'configurable' : true,
  }
  var got = Object.getOwnPropertyDescriptor( instance1, 'f1' );
  test.identical( got, exp );
  var exp = undefined;
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'f1' );
  test.identical( got, exp );

  test.description = 'descriptor of af1p'; /* */

  var exp = undefined;
  var got = Object.getOwnPropertyDescriptor( instance1, 'af1p' );
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'af1p' );
  var exp =
  {
    get : got.get,
    set : got.set,
    'enumerable' : true,
    'configurable' : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of af1s'; /* */

  var exp = undefined;
  var got = Object.getOwnPropertyDescriptor( instance1, 'af1s' );
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'af1s' );
  var exp =
  {
    get : got.get,
    set : got.set,
    'enumerable' : false,
    'configurable' : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of s1'; /* */

  var exp = undefined;
  var got = Object.getOwnPropertyDescriptor( instance1, 's1' );
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 's1' );
  var exp =
  {
    get : got.get,
    set : got.set,
    'enumerable' : false,
    'configurable' : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of as1p'; /* */

  var exp = undefined;
  var got = Object.getOwnPropertyDescriptor( instance1, 'as1p' );
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'as1p' );
  var exp =
  {
    get : got.get,
    set : got.set,
    'enumerable' : true,
    'configurable' : true,
  }
  test.identical( got, exp );

  test.description = 'descriptor of as1s'; /* */

  var exp = undefined;
  var got = Object.getOwnPropertyDescriptor( instance1, 'as1s' );
  test.identical( got, exp );
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'as1s' );
  var exp =
  {
    get : got.get,
    set : got.set,
    'enumerable' : false,
    'configurable' : true,
  }
  test.identical( got, exp );

  /* */

}

//

function definePropAliasOptionOriginalContainer( test )
{

  act({ set : true });
  act({ set : false });

  function act( tops )
  {

    /* */

    test.case = `typed:true set:${tops.set} basic`;

    var originalContainer =
    {
      f1 : '1',
      f2 : '2',
    }

    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed( true ),
      p : _.define.alias({ originalContainer, originalName : 'f1', static : 0, set : tops.set }),
      s : _.define.alias({ originalContainer, originalName : 'f2', static : 1, set : tops.set }),
    });

    var instance1 = Blueprint1.Make();

    test.description = 'properties'; /* */

    test.identical( instance1.p, '1' );
    test.identical( instance1.s, '2' );
    test.identical( Blueprint1.prototype.p, '1' );
    test.identical( Blueprint1.prototype.s, '2' );

    test.true( !Object.hasOwnProperty.call( instance1, '_' ) );
    test.true( !Object.hasOwnProperty.call( Blueprint1.prototype, '_' ) );
    test.true( instance1._ === undefined );
    test.true( Blueprint1.prototype._ === undefined );

    var exp =
    {
      'p' : '1',
      's' : '2',
    }
    test.identical( _.mapBut( _.property.all( instance1 ), [ '_' ] ), exp );

    var exp =
    {
    }
    test.identical( _.property.onlyOwn( instance1 ), exp );

    var exp =
    {
      'p' : '1',
    }
    test.identical( _.mapExtend( null, instance1 ), exp );

    var exp =
    {
      f1 : '1',
      f2 : '2',
    }
    test.identical( originalContainer, exp );

    test.description = 'descriptor of p'; /* */

    var got = Object.getOwnPropertyDescriptor( instance1, 'p' );
    var exp = undefined;
    test.identical( got, exp );

    var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'p' );
    var exp =
    {
      get : got.get,
      set : got.set,
      'enumerable' : true,
      'configurable' : true,
    }
    test.identical( got, exp );
    if( !tops.set )
    test.true( got.set === undefined );

    test.description = 'descriptor of s'; /* */

    var got = Object.getOwnPropertyDescriptor( instance1, 's' );
    var exp = undefined;
    test.identical( got, exp );

    var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 's' );
    var exp =
    {
      get : got.get,
      set : got.set,
      'enumerable' : false,
      'configurable' : true,
    }
    test.identical( got, exp );
    if( !tops.set )
    test.true( got.set === undefined );

    /* */

    test.case = `typed:true set:${tops.set} set instance.p`;

    var originalContainer =
    {
      f1 : '1',
      f2 : '2',
    }

    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed( true ),
      p : _.define.alias({ originalContainer, originalName : 'f1', static : 0, set : tops.set }),
      s : _.define.alias({ originalContainer, originalName : 'f2', static : 1, set : tops.set }),
    });

    var instance1 = Blueprint1.Make();

    test.description = 'properties'; /* */

    if( tops.set )
    instance1.p = '3';
    else
    test.shouldThrowErrorSync( () => instance1.p = '3' );

    test.identical( instance1.p, tops.set ? '3' : '1' );
    test.identical( instance1.s, '2' );
    test.identical( Blueprint1.prototype.p, tops.set ? '3' : '1' );
    test.identical( Blueprint1.prototype.s, '2' );

    var exp =
    {
      'p' : tops.set ? '3' : '1',
      's' : '2',
    }
    test.identical( _.mapBut( _.property.all( instance1 ), [ '_' ] ), exp );

    var exp =
    {
    }
    test.identical( _.property.onlyOwn( instance1 ), exp );

    var exp =
    {
      'p' : tops.set ? '3' : '1',
    }
    test.identical( _.mapExtend( null, instance1 ), exp );

    var exp =
    {
      f1 : tops.set ? '3' : '1',
      f2 : '2',
    }
    test.identical( originalContainer, exp );

    test.description = 'descriptor of p'; /* */

    var got = Object.getOwnPropertyDescriptor( instance1, 'p' );
    var exp = undefined;
    test.identical( got, exp );

    test.description = 'descriptor of s'; /* */

    var got = Object.getOwnPropertyDescriptor( instance1, 's' );
    var exp = undefined;
    test.identical( got, exp );

    /* */

    test.case = `typed:true set:${tops.set} set instance.s`;

    var originalContainer =
    {
      f1 : '1',
      f2 : '2',
    }

    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed( true ),
      p : _.define.alias({ originalContainer, originalName : 'f1', static : 0, set : tops.set }),
      s : _.define.alias({ originalContainer, originalName : 'f2', static : 1, set : tops.set }),
    });

    var instance1 = Blueprint1.Make();

    test.description = 'properties'; /* */

    if( tops.set )
    instance1.s = '3';
    else
    test.shouldThrowErrorSync( () => instance1.s = '3' );

    test.identical( instance1.p, '1' );
    test.identical( instance1.s, tops.set ? '3' : '2' );
    test.identical( Blueprint1.prototype.p, '1' );
    test.identical( Blueprint1.prototype.s, tops.set ? '3' : '2' );

    var exp =
    {
      'p' : '1',
      's' : tops.set ? '3' : '2',
    }
    test.identical( _.mapBut( _.property.all( instance1 ), [ '_' ] ), exp );

    var exp =
    {
    }
    test.identical( _.property.onlyOwn( instance1 ), exp );

    var exp =
    {
      'p' : '1',
    }
    test.identical( _.mapExtend( null, instance1 ), exp );

    var exp =
    {
      f1 : '1',
      f2 : tops.set ? '3' : '2',
    }
    test.identical( originalContainer, exp );

    test.description = 'descriptor of p'; /* */

    var got = Object.getOwnPropertyDescriptor( instance1, 'p' );
    var exp = undefined;
    test.identical( got, exp );

    test.description = 'descriptor of s'; /* */

    var got = Object.getOwnPropertyDescriptor( instance1, 's' );
    var exp = undefined;
    test.identical( got, exp );

    /* */

    test.case = `typed:false set:${tops.set} basic`;

    var originalContainer =
    {
      f1 : '1',
      f2 : '2',
    }

    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed( false ),
      p : _.define.alias({ originalContainer, originalName : 'f1', static : 0, set : tops.set }),
      s : _.define.alias({ originalContainer, originalName : 'f2', static : 1, set : tops.set }),
    });

    var instance1 = Blueprint1.Make();

    test.description = 'properties'; /* */

    test.identical( instance1.p, '1' );
    test.identical( instance1.s, undefined );
    // test.identical( Blueprint1.prototype.p, undefined );
    // test.identical( Blueprint1.prototype.s, '2' );

    test.true( !Object.hasOwnProperty.call( instance1, '_' ) );
    // test.true( !Object.hasOwnProperty.call( Blueprint1.prototype, '_' ) );
    test.true( instance1._ === undefined );
    // test.true( Blueprint1.prototype._ === undefined );

    var exp =
    {
      'p' : '1',
    }
    test.identical( _.mapBut( _.property.all( instance1 ), [ '_' ] ), exp );

    var exp =
    {
      'p' : '1',
    }
    test.identical( _.property.onlyOwn( instance1 ), exp );

    var exp =
    {
      'p' : '1',
    }
    test.identical( _.mapExtend( null, instance1 ), exp );

    var exp =
    {
      f1 : '1',
      f2 : '2',
    }
    test.identical( originalContainer, exp );

    test.description = 'descriptor of p'; /* */

    var got = Object.getOwnPropertyDescriptor( instance1, 'p' );
    var exp =
    {
      get : got.get,
      set : got.set,
      'enumerable' : true,
      'configurable' : true,
    }
    test.identical( got, exp );
    if( !tops.set )
    test.true( got.set === undefined );

    // var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'p' );
    // var exp = undefined;
    // test.identical( got, exp );

    test.description = 'descriptor of s'; /* */

    var got = Object.getOwnPropertyDescriptor( instance1, 's' );
    var exp = undefined;
    test.identical( got, exp );

    // var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 's' );
    // var exp =
    // {
    //   get : got.get,
    //   set : got.set,
    //   'enumerable' : false,
    //   'configurable' : true,
    // }
    // test.identical( got, exp );
    // if( !tops.set )
    // test.true( got.set === undefined );

    /* */

    test.case = `typed:false set:${tops.set} set instance.p`;

    var originalContainer =
    {
      f1 : '1',
      f2 : '2',
    }

    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed( false ),
      p : _.define.alias({ originalContainer, originalName : 'f1', static : 0, set : tops.set }),
      s : _.define.alias({ originalContainer, originalName : 'f2', static : 1, set : tops.set }),
    });

    var instance1 = Blueprint1.Make();

    test.description = 'properties'; /* */

    if( tops.set )
    instance1.p = '3'
    else
    test.shouldThrowErrorSync( () => instance1.p = '3' );

    test.identical( instance1.p, tops.set ? '3' : '1' );
    test.identical( instance1.s, undefined );
    // test.identical( Blueprint1.prototype.p, undefined );
    // test.identical( Blueprint1.prototype.s, '2' );

    var exp =
    {
      'p' : tops.set ? '3' : '1',
    }
    test.identical( _.mapBut( _.property.all( instance1 ), [ '_' ] ), exp );

    var exp =
    {
      'p' : tops.set ? '3' : '1',
    }
    test.identical( _.property.onlyOwn( instance1 ), exp );

    var exp =
    {
      'p' : tops.set ? '3' : '1',
    }
    test.identical( _.mapExtend( null, instance1 ), exp );

    var exp =
    {
      f1 : tops.set ? '3' : '1',
      f2 : '2',
    }
    test.identical( originalContainer, exp );

    /* */

    test.case = `typed:false set:${tops.set} set instance.s`;

    var originalContainer =
    {
      f1 : '1',
      f2 : '2',
    }

    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed( false ),
      p : _.define.alias({ originalContainer, originalName : 'f1', static : 0, set : tops.set }),
      s : _.define.alias({ originalContainer, originalName : 'f2', static : 1, set : tops.set }),
    });

    var instance1 = Blueprint1.Make();

    test.description = 'properties'; /* */

    test.shouldThrowErrorSync( () => instance1.s = '3' );

    test.identical( instance1.p, '1' );
    test.identical( instance1.s, undefined );
    // test.identical( Blueprint1.prototype.p, undefined );
    // test.identical( Blueprint1.prototype.s, '2' );

    var exp =
    {
      'p' : '1',
    }
    test.identical( _.mapBut( _.property.all( instance1 ), [ '_' ] ), exp );

    var exp =
    {
      'p' : '1',
    }
    test.identical( _.property.onlyOwn( instance1 ), exp );

    var exp =
    {
      'p' : '1',
    }
    test.identical( _.mapExtend( null, instance1 ), exp );

    var exp =
    {
      f1 : '1',
      f2 : '2',
    }
    test.identical( originalContainer, exp );

    /* */

  }

}

//

function definePropAliasConstructionAmendWithDefinition( test )
{

  act({ amending : 'extend' });
  act({ amending : 'supplement' });

  function act( tops )
  {

    /* */

    test.case = `amending : ${tops.amending}, static : 0, without trait::typed::0`;

    var originalContainer =
    {
      f1 : '1',
      f2 : '2',
    }

    var dstContainer =
    {
      f1 : '11',
      f2 : '12',
    }

    var extension =
    {
      p : _.define.alias({ originalContainer, originalName : 'f1', static : 0 }),
      f2 : _.define.alias({ originalContainer, originalName : 'f2', static : 0 }),
    }

    var keysBefore = _.mapAllKeys( _.prototype.of( dstContainer ) );
    _.construction[ tops.amending ]( dstContainer, extension )
    var keysAfter = _.mapAllKeys( _.prototype.of( dstContainer ) );
    test.identical( keysAfter, keysBefore );

    var exp  =
    {
      f1 : '1',
      f2 : '12',
    }
    test.identical( originalContainer, exp );

    var exp  =
    {
      p : '1',
      f1 : '11',
      f2 : '12',
    }
    test.identical( dstContainer, exp );

    var got = Object.getOwnPropertyDescriptor( dstContainer, 'p' );
    var exp =
    {
      get : got.get,
      set : got.set,
      'enumerable' : true,
      'configurable' : true,
    }
    test.identical( got, exp );
    test.true( _.routineIs( got.get ) );
    test.true( _.routineIs( got.set ) );

    /* */

    test.case = `amending : ${tops.amending}, static : 0, with trait::typed::0`;

    var originalContainer =
    {
      f1 : '1',
      f2 : '2',
    }

    var dstContainer =
    {
      f1 : '11',
      f2 : '12',
    }

    var extension =
    {
      p : _.define.alias({ originalContainer, originalName : 'f1', static : 0 }),
      f2 : _.define.alias({ originalContainer, originalName : 'f2', static : 0 }),
      typed : _.trait.typed( 0 ),
    }

    var keysBefore = _.mapAllKeys( _.prototype.of( dstContainer ) );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( _.prototype.of( dstContainer ) );
    test.identical( keysAfter, keysBefore );

    var exp =
    {
      'f1' : '11',
      'f2' : '12',
      'p' : '1',
    }
    test.identical( dstContainer, exp );
    test.true( dstContainer._ === undefined );

    var exp =
    {
      'f1' : '1',
      'f2' : '12',
    }
    test.identical( originalContainer, exp );

    var got = Object.getOwnPropertyDescriptor( dstContainer, 'p' );
    var exp =
    {
      get : got.get,
      set : got.set,
      'enumerable' : true,
      'configurable' : true,
    }
    test.identical( got, exp );
    test.true( _.routineIs( got.get ) );
    test.true( _.routineIs( got.set ) );

    /* */

    test.case = `amending : ${tops.amending}, static : 1`;

    var originalContainer =
    {
      f1 : '1',
      f2 : '2',
    }

    var prototype = Object.create( Object.prototype );
    var dstContainer = Object.create( prototype );
    dstContainer.f1 = '11';
    dstContainer.f2 = '12';

    var extension =
    {
      s : _.define.alias({ originalContainer, originalName : 'f1', static : 1 }),
      f2 : _.define.alias({ originalContainer, originalName : 'f2', static : 0 }),
    }

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    var exp =
    {
      'f1' : '11',
      'f2' : '12',
    }
    test.identical( _.property.all( dstContainer, { onlyEnumerable : 1 } ), exp );
    test.identical( dstContainer.s, '1' );
    test.identical( dstContainer.f2, '12' );
    test.true( dstContainer._ === undefined );

    var exp =
    {
      'f1' : '1',
      'f2' : '12',
    }
    test.identical( originalContainer, exp );

    var got = Object.getOwnPropertyDescriptor( prototype, 's' );
    var exp =
    {
      get : got.get,
      set : got.set,
      'enumerable' : false,
      'configurable' : true,
    }
    test.identical( got, exp );
    test.true( _.routineIs( got.get ) );
    test.true( _.routineIs( got.set ) );

    /* */

    test.case = `amending : ${tops.amending}, polution`;

    var originalContainer =
    {
      f1 : '1',
      f2 : '2',
    }

    var dstContainer =
    {
    }

    var extension =
    {
      s : _.define.alias({ originalContainer, originalName : 'f2', static : 1 }),
      f2 : _.define.alias({ originalContainer, originalName : 'f2', static : 0 }),
    }

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    var exp =
    {
      'f1' : '1',
      'f2' : '2',
    }
    test.identical( originalContainer, exp );

    var exp  =
    {
      'f2' : '2',
    }
    test.identical( dstContainer, exp );

    /* */

    test.case = `amending : ${tops.amending}, several`;

    var dstContainer =
    {
      a : 1,
      b : 2,
      d : 3,
    }

    var extensionMap =
    {
      c : _.define.alias( 'a' ),
      d : _.define.alias( 'b' ),
      typed : _.trait.typed( 0 ),
    }

    _.construction[ tops.amending ]( dstContainer, extensionMap );

    var exp =
    {
      'a' : 1,
      'b' : 3,
      'c' : 1,
      'd' : 3,
    }
    test.identical( dstContainer, exp );
    test.true( Object.isExtensible( dstContainer ) );

    /* */

    test.case = `amending : ${tops.amending}, several with originalContainer`;

    var dstContainer =
    {
      a : 1,
      b : 2,
    }

    var originalContainer =
    {
      a : 3,
      b : 4,
      d : 5,
    }

    var extensionMap =
    {
      c : _.define.alias({ originalName : 'a', originalContainer }),
      d : _.define.alias({ originalName : 'b', originalContainer }),
      typed : _.trait.typed( 0 ),
    }

    _.construction[ tops.amending ]( dstContainer, extensionMap );

    var exp =
    {
      'a' : 1,
      'b' : 2,
      'c' : 3,
      'd' : 4,
    }
    test.identical( dstContainer, exp );
    test.true( Object.isExtensible( dstContainer ) );

    var exp =
    {
      a : 3,
      b : 4,
      d : 5,
    }
    test.identical( originalContainer, exp );

    /* */

  }

}

//

function definePropAliasConstructionAmendWithBlueprint( test )
{

  act({ amending : 'extend' });
  act({ amending : 'supplement' });

  function act( tops )
  {

    /* */

    test.case = `static : 0`;

    var originalContainer =
    {
      f1 : '1',
      f2 : '2',
    }

    var dstContainer =
    {
      f1 : '11',
      f2 : '12',
    }

    var extension = _.Blueprint
    ({
      p : _.define.alias({ originalContainer, originalName : 'f1', static : 0 }),
      f2 : _.define.alias({ originalContainer, originalName : 'f2', static : 0 }),
    });

    var keysBefore = _.mapAllKeys( _.prototype.of( dstContainer ) );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( _.prototype.of( dstContainer ) );
    test.identical( keysAfter, keysBefore );

    var exp =
    {
      'f1' : '11',
      'f2' : '12',
      'p' : '1',
    }
    test.identical( dstContainer, exp );
    test.true( dstContainer._ === undefined );

    var exp =
    {
      'f1' : '1',
      'f2' : '12',
    }
    test.identical( originalContainer, exp );

    var got = Object.getOwnPropertyDescriptor( dstContainer, 'p' );
    var exp =
    {
      get : got.get,
      set : got.set,
      'enumerable' : true,
      'configurable' : true,
    }
    test.identical( got, exp );
    test.true( _.routineIs( got.get ) );
    test.true( _.routineIs( got.set ) );
    test.true( !Object.isExtensible( dstContainer ) );
    test.true( _.mapIs( dstContainer ) );

    /* */

    test.case = `static : 1, typed : 0`;

    var originalContainer =
    {
      f1 : '1',
      f2 : '2',
    }

    var prototype = Object.create( Object.prototype );
    var dstContainer = Object.create( prototype );
    dstContainer.f1 = '11';
    dstContainer.f2 = '12';

    var extension = _.Blueprint
    ({
      typed : _.trait.typed( 0 ),
      s : _.define.alias({ originalContainer, originalName : 'f1', static : 1 }),
      f2 : _.define.alias({ originalContainer, originalName : 'f2', static : 1 }),
    })

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    var exp =
    {
      'f1' : '11',
      'f2' : '12',
    }
    test.identical( _.property.all( dstContainer, { onlyEnumerable : 1 } ), exp );

    test.identical( dstContainer.s, undefined );
    // test.identical( extension.prototype.s, '1' );
    test.true( dstContainer._ === undefined );
    test.true( Object.getPrototypeOf( dstContainer ) === null );
    test.true( !Object.isExtensible( dstContainer ) );
    test.true( _.mapIs( dstContainer ) );

    /* */

    test.case = `static : 1, typed : 1`;

    var originalContainer =
    {
      f1 : '1',
      f2 : '2',
    }

    var prototype = Object.create( Object.prototype );
    var dstContainer = Object.create( prototype );
    dstContainer.f1 = '11';
    dstContainer.f2 = '12';

    var extension = _.Blueprint
    ({
      typed : _.trait.typed( 1 ),
      s : _.define.alias({ originalContainer, originalName : 'f1', static : 1 }),
      f2 : _.define.alias({ originalContainer, originalName : 'f2', static : 1 }),
    })

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    var exp =
    {
      'f1' : '11',
      'f2' : '12',
    }
    test.identical( _.property.all( dstContainer, { onlyEnumerable : 1 } ), exp );

    var exp =
    {
      'f1' : '1',
      'f2' : '2',
    }
    test.identical( originalContainer, exp );

    test.identical( dstContainer.s, '1' );
    test.identical( extension.prototype.s, '1' );
    test.true( dstContainer._ === undefined );
    test.true( Object.getPrototypeOf( dstContainer ) === extension.prototype );
    test.true( !Object.isExtensible( dstContainer ) );
    test.true( !_.mapIs( dstContainer ) );

    /* */

    test.case = `static : 1, impure, no pollution`;

    var originalContainer =
    {
      f1 : '1',
      f2 : '2',
    }

    var dstContainer =
    {
      f1 : '11',
      f2 : '12',
    }

    test.true( Object.isExtensible( dstContainer ) );

    var extension = _.Blueprint
    ({
      s : _.define.alias({ originalContainer, originalName : 'f2', static : 1 }),
      f2 : _.define.alias({ originalContainer, originalName : 'f2', static : 1 }),
    });

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );
    test.identical( dstContainer.s, undefined );
    // test.identical( extension.prototype.s, '2' );

    var exp =
    {
      'f1' : '1',
      'f2' : '2',
    }
    test.identical( originalContainer, exp );

    test.true( !Object.isExtensible( dstContainer ) );
    test.true( _.mapIs( dstContainer ) );

    /* */

  }

}

// --
// define amendment
// --

function defineExtensionBasic( test )
{

  /* */

  test.case = 'untyped -> untyped';
  var Blueprint1 = _.Blueprint
  ({
    field1 : 'b1',
    field2 : 'b1',
    typed : _.trait.typed( false ),
  });

  var Blueprint2 = _.Blueprint
  ({
    typed : _.trait.typed( false ),
    field2 : 'b2',
    field3 : 'b2',
    extension : _.define.extension( Blueprint1 ),
  });

  var exp = { field1 : 'b1', field2 : 'b1', field3 : 'b2' };
  var instance = Blueprint2.Make();
  test.identical( instance, exp );
  // test.identical( instance instanceof Blueprint1.Make, false );
  // test.identical( instance instanceof Blueprint2.Make, false );
  test.true( Blueprint1.prototype === null );
  test.true( Blueprint2.prototype === null );

  /* */

  test.case = 'untyped -> typed';
  var Blueprint1 = _.Blueprint
  ({
    field1 : 'b1',
    field2 : 'b1',
    typed : _.trait.typed( false ),
  });

  var Blueprint2 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field2 : 'b2',
    field3 : 'b2',
    extension : _.define.extension( Blueprint1 ),
  });

  var exp = { field1 : 'b1', field2 : 'b1', field3 : 'b2' };
  var instance = Blueprint2.Make();
  test.identical( instance, exp );
  // test.identical( instance instanceof Blueprint1.Make, false );
  // test.identical( instance instanceof Blueprint2.Make, false );
  test.true( Blueprint1.prototype === null );
  test.true( Blueprint2.prototype === null );

  /* */

  test.case = 'typed -> untyped';
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
  });

  var Blueprint2 = _.Blueprint
  ({
    typed : _.trait.typed( false ),
    field2 : 'b2',
    field3 : 'b2',
    extension : _.define.extension( Blueprint1 ),
  });

  var exp = { field1 : 'b1', field2 : 'b1', field3 : 'b2' };
  var instance = Blueprint2.Make();
  test.containsOnly( instance, exp );
  test.identical( instance instanceof Blueprint1.Make, false );
  test.identical( instance instanceof Blueprint2.Make, true );

  /* */

  test.case = 'typed -> typed';
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
  });

  var Blueprint2 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field2 : 'b2',
    field3 : 'b2',
    extension : _.define.extension( Blueprint1 ),
  });

  var exp = { field1 : 'b1', field2 : 'b1', field3 : 'b2' };
  var instance = Blueprint2.Make();
  test.containsOnly( instance, exp );
  test.identical( instance instanceof Blueprint1.Make, false );
  test.identical( instance instanceof Blueprint2.Make, true );

  /* */

}

defineExtensionBasic.description =
`
- blueprint extend another blueprint by fields
- blueprint extend another blueprint by traits
`

//

function defineSupplementationBasic( test )
{

  /* */

  test.case = 'untyped -> untyped';
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( false ),
    field1 : 'b1',
    field2 : 'b1',
  });

  var Blueprint2 = _.Blueprint
  ({
    typed : _.trait.typed( false ),
    field2 : 'b2',
    field3 : 'b2',
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var exp = { field1 : 'b1', field2 : 'b2', field3 : 'b2' };
  var instance = Blueprint2.Make();
  test.identical( instance, exp );
  // test.identical( instance instanceof Blueprint1.Make, false );
  // test.identical( instance instanceof Blueprint2.Make, false );
  test.true( Blueprint1.prototype === null );
  test.true( Blueprint2.prototype === null );

  /* */

  test.case = 'untyped -> typed';
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( false ),
    field1 : 'b1',
    field2 : 'b1',
  });

  var Blueprint2 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field2 : 'b2',
    field3 : 'b2',
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var exp = { field1 : 'b1', field2 : 'b2', field3 : 'b2' };
  var instance = Blueprint2.Make();
  test.containsOnly( instance, exp );
  // test.identical( instance instanceof Blueprint1.Make, false );
  test.identical( instance instanceof Blueprint2.Make, true );
  test.true( Blueprint1.prototype === null );
  test.true( Blueprint2.prototype !== null );

  /* */

  test.case = 'typed -> untyped';
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
  });

  var Blueprint2 = _.Blueprint
  ({
    typed : _.trait.typed( false ),
    field2 : 'b2',
    field3 : 'b2',
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var exp = { field1 : 'b1', field2 : 'b2', field3 : 'b2' };
  var instance = Blueprint2.Make();
  test.containsOnly( instance, exp );
  test.identical( instance instanceof Blueprint1.Make, false );
  // test.identical( instance instanceof Blueprint2.Make, false );
  test.true( Blueprint1.prototype !== null );
  test.true( Blueprint2.prototype === null );

  /* */

  test.case = 'typed -> typed';
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
  });

  var Blueprint2 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field2 : 'b2',
    field3 : 'b2',
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var exp = { field1 : 'b1', field2 : 'b2', field3 : 'b2' };
  var instance = Blueprint2.Make();
  test.containsOnly( instance, exp );
  test.identical( instance instanceof Blueprint1.Make, false );
  test.identical( instance instanceof Blueprint2.Make, true );

  /* */

}

defineSupplementationBasic.description =
`
- blueprint supplement another blueprint by fields
- blueprint supplement another blueprint by traits
`

//

function defineExtensionOrder( test )
{

  /* */

  test.case = 'blueprint1'; /* */

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1' ),
    s2 : _.define.static( 'b1' ),
  });

  var instance = Blueprint1.Make();
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

  test.case = 'extension before';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1' ),
    s2 : _.define.static( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    extension : _.define.extension( Blueprint1 ),
    field2 : 'b2',
    field3 : 'b2',
    s2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
  });

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

  test.case = 'extension before, extension.blueprintDepthReserve:Infinity';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1' ),
    s2 : _.define.static( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    extension : _.define.extension( Blueprint1, { blueprintDepthReserve : Infinity } ),
    field2 : 'b2',
    field3 : 'b2',
    s2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
  });

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    's1' : 'b1',
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

  test.case = 'extension before, static.blueprintDepthReserve:Infinity';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1', { blueprintDepthReserve : Infinity } ),
    s2 : _.define.static( 'b1', { blueprintDepthReserve : Infinity } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    extension : _.define.extension( Blueprint1 ),
    field2 : 'b2',
    field3 : 'b2',
    s2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
  });

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    's1' : 'b1',
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

  test.case = 'extension after';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1' ),
    s2 : _.define.static( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    s2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    extension : _.define.extension( Blueprint1 ),
  });

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'field3' : 'b2',
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

  test.case = 'extension after, field.blueprintDepthLimit:1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1', { blueprintDepthLimit : 1 } ),
    s2 : _.define.static( 'b1', { blueprintDepthLimit : 1 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    s2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    extension : _.define.extension( Blueprint1 ),
  });

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'field3' : 'b2',
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

  test.case = 'extension after, field.blueprintDepthReserve:Infinity';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1', { blueprintDepthReserve : Infinity } ),
    s2 : _.define.static( 'b1', { blueprintDepthReserve : Infinity } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    s2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    extension : _.define.extension( Blueprint1 ),
  });

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'field3' : 'b2',
    's1' : 'b1',
    's2' : 'b1',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

  test.case = 'extension after, field.blueprintDepthReserve:1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1', { blueprintDepthReserve : 1 } ),
    s2 : _.define.static( 'b1', { blueprintDepthReserve : 1 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    s2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    extension : _.define.extension( Blueprint1 ),
  });

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'field3' : 'b2',
    's1' : 'b1',
    's2' : 'b1',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

  test.case = 'extension after, field.blueprintDepthLimit:0';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1', { blueprintDepthLimit : 0 } ),
    s2 : _.define.static( 'b1', { blueprintDepthLimit : 0 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    s2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    extension : _.define.extension( Blueprint1 ),
  });

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'field3' : 'b2',
    's1' : 'b1',
    's2' : 'b1',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

  test.case = 'extension after, extension.blueprintDepthReserve:Infinity';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1' ),
    s2 : _.define.static( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    s2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    extension : _.define.extension( Blueprint1, { blueprintDepthReserve : Infinity } ),
  });

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'field3' : 'b2',
    's1' : 'b1',
    's2' : 'b1',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

}

defineExtensionOrder.description =
`
- order of definition::extension makes difference
`

//

function defineSupplementationOrder( test )
{

  /* */

  test.case = 'blueprint1'; /* */

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1' ),
    s2 : _.define.static( 'b1' ),
  });

  var instance = Blueprint1.Make();
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

  test.case = 'supplementation before';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1' ),
    s2 : _.define.static( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    supplementation : _.define.supplementation( Blueprint1 ),
    field2 : 'b2',
    field3 : 'b2',
    s2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
  });

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

  test.case = 'supplementation before, supplementation.blueprintDepthReserve:Infinity';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1' ),
    s2 : _.define.static( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    supplementation : _.define.supplementation( Blueprint1, { blueprintDepthReserve : Infinity } ),
    field2 : 'b2',
    field3 : 'b2',
    s2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
  });

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    's1' : 'b1',
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

  test.case = 'supplementation before, static.blueprintDepthReserve:Infinity';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1', { blueprintDepthReserve : Infinity } ),
    s2 : _.define.static( 'b1', { blueprintDepthReserve : Infinity } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    supplementation : _.define.supplementation( Blueprint1 ),
    field2 : 'b2',
    field3 : 'b2',
    s2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
  });

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    's1' : 'b1',
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

  test.case = 'supplementation after';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1' ),
    s2 : _.define.static( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    s2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

  test.case = 'supplementation after, field.blueprintDepthLimit:1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1', { blueprintDepthLimit : 1 } ),
    s2 : _.define.static( 'b1', { blueprintDepthLimit : 1 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    s2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

  test.case = 'supplementation after, field.blueprintDepthReserve:Infinity';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1', { blueprintDepthReserve : Infinity } ),
    s2 : _.define.static( 'b1', { blueprintDepthReserve : Infinity } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    s2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    's1' : 'b1',
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

  test.case = 'supplementation after, field.blueprintDepthReserve:1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1', { blueprintDepthReserve : 1 } ),
    s2 : _.define.static( 'b1', { blueprintDepthReserve : 1 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    s2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    's1' : 'b1',
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

  test.case = 'supplementation after, field.blueprintDepthLimit:0';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1', { blueprintDepthLimit : 0 } ),
    s2 : _.define.static( 'b1', { blueprintDepthLimit : 0 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    s2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    's1' : 'b1',
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

  test.case = 'supplementation after, supplementation.blueprintDepthReserve:Infinity';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : _.define.static( 'b1' ),
    s2 : _.define.static( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    s2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    supplementation : _.define.supplementation( Blueprint1, { blueprintDepthReserve : Infinity } ),
  });

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    's1' : 'b1',
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

}

defineSupplementationOrder.description =
`
- order of definition::supplementation makes difference
`

//

function defineAmendmentOrder( test )
{

  /* */

  test.case = 'extension';

  var prototype1 = Object.create( null );
  var prototype2 = Object.create( null );
  var prototype3 = Object.create( null );

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( 1, { prototype : prototype1 } ),
    field1 : null,
  });

  var Blueprint2 = _.Blueprint
  ({
    typed : _.trait.typed( 1, { prototype : prototype2 } ),
    extension : _.define.extension( Blueprint1 ),
  });

  var Blueprint3 = _.Blueprint
  ({
    extension : _.define.extension( Blueprint1 ),
    typed : _.trait.typed( 1, { prototype : prototype3 } ),
  });

  var instance1 = _.blueprint.construct( Blueprint1 );
  test.identical( _.prototype.each( instance1 ).length, 2 );
  test.true( _.prototype.each( instance1 )[ 1 ] === prototype1 );

  var instance2 = _.blueprint.construct( Blueprint2 );
  test.identical( _.prototype.each( instance2 ).length, 2 );
  test.true( _.prototype.each( instance2 )[ 1 ] === prototype1 );

  var instance3 = _.blueprint.construct( Blueprint3 );
  test.identical( _.prototype.each( instance3 ).length, 2 );
  test.true( _.prototype.each( instance3 )[ 1 ] === prototype3 );

  /* */

  test.case = 'supplementation';

  var prototype1 = Object.create( null );
  var prototype2 = Object.create( null );
  var prototype3 = Object.create( null );

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( 1, { prototype : prototype1 } ),
    field1 : null,
  });

  var Blueprint2 = _.Blueprint
  ({
    typed : _.trait.typed( 1, { prototype : prototype2 } ),
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var Blueprint3 = _.Blueprint
  ({
    supplementation : _.define.supplementation( Blueprint1 ),
    typed : _.trait.typed( 1, { prototype : prototype3 } ),
  });

  var instance1 = _.blueprint.construct( Blueprint1 );
  test.identical( _.prototype.each( instance1 ).length, 2 );
  test.true( _.prototype.each( instance1 )[ 1 ] === prototype1 );

  var instance2 = _.blueprint.construct( Blueprint2 );
  test.identical( _.prototype.each( instance2 ).length, 2 );
  test.true( _.prototype.each( instance2 )[ 1 ] === prototype2 );

  var instance3 = _.blueprint.construct( Blueprint3 );
  test.identical( _.prototype.each( instance3 ).length, 2 );
  test.true( _.prototype.each( instance3 )[ 1 ] === prototype3 );

  /* */

}

defineAmendmentOrder.description =
`
- order of defineProp/traits makes difference
- typing first and then extending by untyped blueprint produce untyped blueprint
- extending by untyped blueprint and then typing produce typed blueprint
- typing first and then supplementing by untyped blueprint produce typed blueprint
- supplementing by untyped blueprint and then typing produce typed blueprint
`

//

function defineAmendmentPropInheritance( test )
{

  /* */

  test.case = 'untyped';

  var Blueprint1 = _.Blueprint
  ({
    s1 : _.define.prop( '1', { static : 1 } ),
    f1 : _.define.prop( '1', { static : 0 } ),
  });

  test.identical( new Set([ ... _.mapKeys( Blueprint1.NamedMap ) ]), new Set([ 'f1', 's1' ]) );
  test.identical( new Set([ ... select( Blueprint1.UnnamedArray, '*/amending' ) ]), new Set([]) );
  test.identical( Blueprint1.UnnamedArray.length, 0 );

  var Blueprint2 = _.Blueprint
  ({
    s2 : _.define.prop( '2', { static : 1 } ),
    f2 : _.define.prop( '2', { static : 0 } ),
    extension : _.define.supplementation( Blueprint1 ),
  });

  test.identical( new Set([ ... _.mapKeys( Blueprint2.NamedMap ) ]), new Set([ 'f1', 'f2', 's2' ]) );
  test.identical( new Set([ ... select( Blueprint2.UnnamedArray, '*/amending' ) ]), new Set([]) );
  test.identical( Blueprint2.UnnamedArray.length, 0 );

  var Blueprint3 = _.Blueprint
  ({
    s3 : _.define.prop( '3', { static : 1 } ),
    f3 : _.define.prop( '3', { static : 0 } ),
    extension : _.define.extension( Blueprint2 ),
  });

  test.identical( new Set([ ... _.mapKeys( Blueprint3.NamedMap ) ]), new Set([ 'f1', 'f2', 'f3', 's3' ]) );
  test.identical( new Set([ ... select( Blueprint3.UnnamedArray, '*/amending' ) ]), new Set([]) );
  test.identical( Blueprint3.UnnamedArray.length, 0 );

  var instance1 = _.blueprint.construct( Blueprint1 );
  var exp =
  {
    f1 : '1',
  }
  test.identical( _.property.all( instance1 ), exp );

  var instance2 = _.blueprint.construct( Blueprint2 );
  var exp =
  {
    f2 : '2',
    f1 : '1',
  }
  test.identical( _.property.all( instance2 ), exp );

  var instance3 = _.blueprint.construct( Blueprint3 );
  var exp =
  {
    f3 : '3',
    f2 : '2',
    f1 : '1',
  }
  test.identical( _.property.all( instance3 ), exp );

  /* */

  test.case = 'typed';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed(),
    s1 : _.define.prop( '1', { static : 1 } ),
    f1 : _.define.prop( '1', { static : 0 } ),
  });

  test.identical( new Set([ ... _.mapKeys( Blueprint1.NamedMap ) ]), new Set([ 'f1', 's1' ]) );
  test.identical( new Set([ ... select( Blueprint1.UnnamedArray, '*/amending' ) ]), new Set([]) );
  test.identical( Blueprint1.UnnamedArray.length, 0 );

  var Blueprint2 = _.Blueprint
  ({
    s2 : _.define.prop( '2', { static : 1 } ),
    f2 : _.define.prop( '2', { static : 0 } ),
    extension : _.define.supplementation( Blueprint1 ),
  });

  test.identical( new Set([ ... _.mapKeys( Blueprint2.NamedMap ) ]), new Set([ 'f1', 'f2', 's2' ]) );
  test.identical( new Set([ ... select( Blueprint2.UnnamedArray, '*/amending' ) ]), new Set([]) );
  test.identical( Blueprint2.UnnamedArray.length, 0 );

  var Blueprint3 = _.Blueprint
  ({
    s3 : _.define.prop( '3', { static : 1 } ),
    f3 : _.define.prop( '3', { static : 0 } ),
    extension : _.define.extension( Blueprint2 ),
  });

  test.identical( new Set([ ... _.mapKeys( Blueprint3.NamedMap ) ]), new Set([ 'f1', 'f2', 'f3', 's3' ]) );
  test.identical( new Set([ ... select( Blueprint3.UnnamedArray, '*/amending' ) ]), new Set([]) );
  test.identical( Blueprint3.UnnamedArray.length, 0 );

  var instance1 = _.blueprint.construct( Blueprint1 );
  var exp =
  {
    f1 : '1',
    s1 : '1',
  }
  test.identical( _.property.all( instance1 ), exp );

  var instance2 = _.blueprint.construct( Blueprint2 );
  var exp =
  {
    f2 : '2',
    f1 : '1',
    s2 : '2',
  }
  test.identical( _.property.all( instance2 ), exp );

  var instance3 = _.blueprint.construct( Blueprint3 );
  var exp =
  {
    f3 : '3',
    f2 : '2',
    f1 : '1',
    s3 : '3',
  }
  test.identical( _.property.all( instance3 ), exp );

  /* */

}

defineAmendmentPropInheritance.description =
`
- amendments are not inheritable, but subdefinitions of such amendments are
- static has blueprintDepthLimit:1 to avoid defefinition in descendants
  so extension without inheriting prototype drops inheritance of static fields
`

// --
// define etc
// --

function defineNothing( test )
{

  /* */

  test.case = 'basic';

  var nothing = _.define.nothing();
  test.true( _.definition.is( nothing ) );
  test.true( Object.isFrozen( nothing ) );

  /* */

  test.case = 'blueprint';

  var Blueprint1 = _.Blueprint
  ({
    nothing : _.define.nothing(),
    f1 : '1',
  });

  test.identical( new Set([ ... _.mapKeys( Blueprint1.TraitsMap ) ]), new Set([ 'extendable', 'typed' ]) );
  test.identical( new Set([ ... _.mapKeys( Blueprint1.NamedMap ) ]), new Set([]) );
  test.identical( new Set([ ... select( Blueprint1.UnnamedArray, '*/kind' ) ]), new Set([]) );
  test.identical( Blueprint1.UnnamedArray.length, 0 );

  var instance1 = _.blueprint.construct( Blueprint1 );
  var exp =
  {
    f1 : '1',
  }
  test.identical( _.property.all( instance1 ), exp );
  test.true( !Object.isExtensible( instance1 ) );
  test.true( _.mapIs( instance1 ) );

  /* */

  test.case = 'extension';

  var Blueprint1 = _.Blueprint
  ({
    nothing : _.define.nothing(),
    f1 : '1',
  });
  var Blueprint2 = _.Blueprint
  ({
    extension : _.define.extension( Blueprint1 ),
  });

  test.identical( new Set([ ... _.mapKeys( Blueprint1.TraitsMap ) ]), new Set([ 'extendable', 'typed' ]) );
  test.identical( new Set([ ... _.mapKeys( Blueprint1.NamedMap ) ]), new Set([]) );
  test.identical( new Set([ ... select( Blueprint1.UnnamedArray, '*/kind' ) ]), new Set([]) );
  test.identical( Blueprint1.UnnamedArray.length, 0 );

  var instance2 = _.blueprint.construct( Blueprint2 );
  var exp =
  {
    f1 : '1',
  }
  test.identical( _.property.all( instance1 ), exp );
  test.true( !Object.isExtensible( instance1 ) );
  test.true( _.mapIs( instance1 ) );

  /* */

}

//

function constructionExtendWithBlueprintWithNothing( test )
{

  /* */

  test.case = 'extend untyped construction with blueprint typed:0';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( 0 ),
    nothing : _.define.nothing(),
    f1 : '1',
  });

  test.identical( new Set([ ... _.mapKeys( Blueprint1.TraitsMap ) ]), new Set([ 'extendable', 'typed' ]) );
  test.identical( new Set([ ... _.mapKeys( Blueprint1.NamedMap ) ]), new Set([]) );
  test.identical( new Set([ ... select( Blueprint1.UnnamedArray, '*/kind' ) ]), new Set([ /*'nothing'*/ ]) );
  test.identical( Blueprint1.UnnamedArray.length, 0 );

  var construction1 = Object.create( null )
  test.true( Object.isExtensible( construction1 ) );
  test.true( _.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === null );

  _.construction.extend( construction1, Blueprint1 );
  var exp =
  {
    f1 : '1',
  }
  test.identical( _.property.all( construction1 ), exp );
  test.true( !Object.isExtensible( construction1 ) );
  test.true( _.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === null );

  /* */

  test.case = 'extend untyped impure construction with blueprint typed:0';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( 0 ),
    nothing : _.define.nothing(),
    f1 : '1',
  });

  test.identical( new Set([ ... _.mapKeys( Blueprint1.TraitsMap ) ]), new Set([ 'extendable', 'typed' ]) );
  test.identical( new Set([ ... _.mapKeys( Blueprint1.NamedMap ) ]), new Set([]) );
  test.identical( new Set([ ... select( Blueprint1.UnnamedArray, '*/kind' ) ]), new Set([ /*'nothing'*/ ]) );
  test.identical( Blueprint1.UnnamedArray.length, 0 );

  var construction1 = {};
  test.true( Object.isExtensible( construction1 ) );
  test.true( _.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === Object.prototype );

  _.construction.extend( construction1, Blueprint1 );
  var exp =
  {
    f1 : '1',
  }
  test.identical( _.property.all( construction1, { onlyEnumerable : 1 } ), exp );
  test.true( !Object.isExtensible( construction1 ) );
  test.true( _.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === Object.prototype );

  /* */

  test.case = 'extend untyped construction with blueprint typed:1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( 1 ),
    nothing : _.define.nothing(),
    f1 : '1',
  });

  test.identical( new Set([ ... _.mapKeys( Blueprint1.TraitsMap ) ]), new Set([ 'extendable', 'typed' ]) );
  test.identical( new Set([ ... _.mapKeys( Blueprint1.NamedMap ) ]), new Set([]) );
  test.identical( new Set([ ... select( Blueprint1.UnnamedArray, '*/kind' ) ]), new Set([ /*'nothing'*/ ]) );
  test.identical( Blueprint1.UnnamedArray.length, 0 );

  var construction1 = Object.create( null )
  test.true( Object.isExtensible( construction1 ) );
  test.true( _.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === null );

  _.construction.extend( construction1, Blueprint1 );
  var exp =
  {
    f1 : '1',
  }
  test.identical( _.property.all( construction1 ), exp );
  test.true( !Object.isExtensible( construction1 ) );
  test.true( !_.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === Blueprint1.prototype );

  /* */

  test.case = 'extend untyped impure construction with blueprint typed:1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( 1 ),
    nothing : _.define.nothing(),
    f1 : '1',
  });

  test.identical( new Set([ ... _.mapKeys( Blueprint1.TraitsMap ) ]), new Set([ 'extendable', 'typed' ]) );
  test.identical( new Set([ ... _.mapKeys( Blueprint1.NamedMap ) ]), new Set([]) );
  test.identical( new Set([ ... select( Blueprint1.UnnamedArray, '*/kind' ) ]), new Set([ /*'nothing'*/ ]) );
  test.identical( Blueprint1.UnnamedArray.length, 0 );

  var construction1 = {};
  test.true( Object.isExtensible( construction1 ) );
  test.true( _.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === Object.prototype );

  _.construction.extend( construction1, Blueprint1 );
  var exp =
  {
    f1 : '1',
  }
  test.identical( _.property.all( construction1 ), exp );
  test.true( !Object.isExtensible( construction1 ) );
  test.true( !_.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === Blueprint1.prototype );

  /* */

  test.case = 'extend typed construction with blueprint typed:0';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( 0 ),
    nothing : _.define.nothing(),
    f1 : '1',
  });

  test.identical( new Set([ ... _.mapKeys( Blueprint1.TraitsMap ) ]), new Set([ 'extendable', 'typed' ]) );
  test.identical( new Set([ ... _.mapKeys( Blueprint1.NamedMap ) ]), new Set([]) );
  test.identical( new Set([ ... select( Blueprint1.UnnamedArray, '*/kind' ) ]), new Set([ /*'nothing'*/ ]) );
  test.identical( Blueprint1.UnnamedArray.length, 0 );

  var prototype1 = Object.create( null );
  var construction1 = Object.create( prototype1 );
  test.true( Object.isExtensible( construction1 ) );
  test.true( !_.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === prototype1 );

  _.construction.extend( construction1, Blueprint1 );
  var exp =
  {
    f1 : '1',
  }
  test.identical( _.property.all( construction1 ), exp );
  test.true( !Object.isExtensible( construction1 ) );
  test.true( _.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === null );

  /* */

  test.case = 'extend typed construction with blueprint typed:1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( 1 ),
    nothing : _.define.nothing(),
    f1 : '1',
  });

  test.identical( new Set([ ... _.mapKeys( Blueprint1.TraitsMap ) ]), new Set([ 'extendable', 'typed' ]) );
  test.identical( new Set([ ... _.mapKeys( Blueprint1.NamedMap ) ]), new Set([]) );
  test.identical( new Set([ ... select( Blueprint1.UnnamedArray, '*/kind' ) ]), new Set([ /*'nothing'*/ ]) );
  test.identical( Blueprint1.UnnamedArray.length, 0 );

  var prototype1 = Object.create( null );
  var construction1 = Object.create( prototype1 );
  test.true( Object.isExtensible( construction1 ) );
  test.true( !_.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === prototype1 );

  _.construction.extend( construction1, Blueprint1 );
  var exp =
  {
    f1 : '1',
  }
  test.identical( _.property.all( construction1 ), exp );
  test.true( !Object.isExtensible( construction1 ) );
  test.true( !_.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === Blueprint1.prototype );

  /* */

  test.case = 'extend untyped construction with blueprint typed:maybe';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( _.maybe ),
    nothing : _.define.nothing(),
    f1 : '1',
  });

  test.identical( new Set([ ... _.mapKeys( Blueprint1.TraitsMap ) ]), new Set([ 'extendable', 'typed' ]) );
  test.identical( new Set([ ... _.mapKeys( Blueprint1.NamedMap ) ]), new Set([]) );
  test.identical( new Set([ ... select( Blueprint1.UnnamedArray, '*/kind' ) ]), new Set([ /*'nothing'*/ ]) );
  test.identical( Blueprint1.UnnamedArray.length, 0 );

  var construction1 = Object.create( null )
  test.true( Object.isExtensible( construction1 ) );
  test.true( _.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === null );

  _.construction.extend( construction1, Blueprint1 );
  var exp =
  {
    f1 : '1',
  }
  test.identical( _.property.all( construction1 ), exp );
  test.true( !Object.isExtensible( construction1 ) );
  test.true( _.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === null );

  /* */

  test.case = 'extend untyped impure construction with blueprint typed:maybe';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( _.maybe ),
    nothing : _.define.nothing(),
    f1 : '1',
  });

  test.identical( new Set([ ... _.mapKeys( Blueprint1.TraitsMap ) ]), new Set([ 'extendable', 'typed' ]) );
  test.identical( new Set([ ... _.mapKeys( Blueprint1.NamedMap ) ]), new Set([]) );
  test.identical( new Set([ ... select( Blueprint1.UnnamedArray, '*/kind' ) ]), new Set([ /*'nothing'*/ ]) );
  test.identical( Blueprint1.UnnamedArray.length, 0 );

  var construction1 = {};
  test.true( Object.isExtensible( construction1 ) );
  test.true( _.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === Object.prototype );

  _.construction.extend( construction1, Blueprint1 );
  var exp =
  {
    f1 : '1',
  }
  test.identical( _.property.all( construction1, { onlyEnumerable : 1 } ), exp );
  test.true( !Object.isExtensible( construction1 ) );
  test.true( _.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === Object.prototype );

  /* */

  test.case = 'extend typed construction with blueprint typed:maybe';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( _.maybe ),
    nothing : _.define.nothing(),
    f1 : '1',
  });

  test.identical( new Set([ ... _.mapKeys( Blueprint1.TraitsMap ) ]), new Set([ 'extendable', 'typed' ]) );
  test.identical( new Set([ ... _.mapKeys( Blueprint1.NamedMap ) ]), new Set([]) );
  test.identical( new Set([ ... select( Blueprint1.UnnamedArray, '*/kind' ) ]), new Set([ /*'nothing'*/ ]) );
  test.identical( Blueprint1.UnnamedArray.length, 0 );

  var prototype1 = Object.create( null );
  var construction1 = Object.create( prototype1 );
  test.true( Object.isExtensible( construction1 ) );
  test.true( !_.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === prototype1 );

  _.construction.extend( construction1, Blueprint1 );
  var exp =
  {
    f1 : '1',
  }
  test.identical( _.property.all( construction1 ), exp );
  test.true( !Object.isExtensible( construction1 ) );
  test.true( !_.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === prototype1 );

  /* */

}

//

function constructionExtendWithNothing( test )
{

  /* */

  test.case = 'extend untyped construction';

  var extension =
  {
    nothing : _.define.nothing(),
  }

  var construction1 = Object.create( null );
  construction1.f1 = '1';
  test.true( Object.isExtensible( construction1 ) );
  test.true( _.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === null );

  _.construction.extend( construction1, extension );
  var exp =
  {
    f1 : '1',
  }
  test.identical( _.property.all( construction1 ), exp );
  test.true( Object.isExtensible( construction1 ) );
  test.true( _.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === null );

  /* */

  test.case = 'extend untyped impure construction';

  var extension =
  {
    nothing : _.define.nothing(),
  }

  var construction1 = {};
  construction1.f1 = '1';
  test.true( Object.isExtensible( construction1 ) );
  test.true( _.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === Object.prototype );

  _.construction.extend( construction1, extension );
  var exp =
  {
    f1 : '1',
  }
  test.identical( _.property.all( construction1, { onlyEnumerable : 1 } ), exp );
  test.true( Object.isExtensible( construction1 ) );
  test.true( _.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === Object.prototype );

  /* */

  test.case = 'extend typed construction';

  var extension =
  {
    nothing : _.define.nothing(),
  }

  var prototype1 = Object.create( null );
  var construction1 = Object.create( prototype1 );
  construction1.f1 = '1';
  test.true( Object.isExtensible( construction1 ) );
  test.true( !_.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === prototype1 );

  _.construction.extend( construction1, extension );
  var exp =
  {
    f1 : '1',
  }
  test.identical( _.property.all( construction1 ), exp );
  test.true( Object.isExtensible( construction1 ) );
  test.true( !_.mapIs( construction1 ) );
  test.true( _.objectIs( construction1 ) );
  test.true( _.prototype.of( construction1 ) === prototype1 );

  /* */

}

// --
// trait
// --

function traitTypePrototype( test )
{

  /* */

  test.case = 'with blueprint';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed(),
    field1 : null,
  });

  var Blueprint2 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true, prototype : Blueprint1 }),
    // typed : _.trait.typed( true ),
    // prototype : _.trait.prototype( Blueprint1 ),
  });

  var Blueprint3 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true, prototype : Blueprint2 }),
    // typed : _.trait.typed( true ),
    // prototype : _.trait.prototype( Blueprint2 ),
  });

  var instance1 = _.blueprint.construct( Blueprint1 );
  test.identical( _.prototype.each( instance1 ).length, 3 );

  var instance2 = _.blueprint.construct( Blueprint2 );
  test.identical( _.prototype.each( instance2 ).length, 4 );

  var instance3 = _.blueprint.construct( Blueprint3 );
  test.identical( _.prototype.each( instance3 ).length, 5 );

  test.true( _.prototype.each( instance3 )[ 0 ] === instance3 );
  test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint3.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 2 ] === Blueprint2.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 3 ] === Blueprint1.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 4 ] === _.Construction.prototype );

  /* */

  test.case = 'with blueprint, new:1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed(),
    field1 : null,
  });

  var Blueprint2 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true, prototype : Blueprint1 }),
    // typed : _.trait.typed( true ),
    // prototype : _.trait.prototype( Blueprint1 ),
  });

  var Blueprint3 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true, new : 1, prototype : Blueprint2 }),
    // typed : _.trait.typed( true ),
    // prototype : _.trait.prototype( Blueprint2, { new : 1 } ),
  });

  var instance1 = _.blueprint.construct( Blueprint1 );
  test.identical( _.prototype.each( instance1 ).length, 3 );

  var instance2 = _.blueprint.construct( Blueprint2 );
  test.identical( _.prototype.each( instance2 ).length, 4 );

  var instance3 = _.blueprint.construct( Blueprint3 );
  test.identical( _.prototype.each( instance3 ).length, 5 );

  test.true( _.prototype.each( instance3 )[ 0 ] === instance3 );
  test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint3.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 2 ] === Blueprint2.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 3 ] === Blueprint1.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 4 ] === _.Construction.prototype );

  /* */

  test.case = 'with blueprint, new:0';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed(),
    field1 : null,
  });

  var Blueprint2 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true, prototype : Blueprint1 }),
    // typed : _.trait.typed( true ),
    // prototype : _.trait.prototype( Blueprint1 ),
  });

  var Blueprint3 = _.Blueprint
  ({
      typed : _.trait.typed({ val : true, prototype : Blueprint2, new : 0 }),
    // typed : _.trait.typed( true ),
    // prototype : _.trait.prototype( Blueprint2, { new : 0 } ),
  });

  var instance1 = _.blueprint.construct( Blueprint1 );
  test.identical( _.prototype.each( instance1 ).length, 3 );

  var instance2 = _.blueprint.construct( Blueprint2 );
  test.identical( _.prototype.each( instance2 ).length, 4 );

  var instance3 = _.blueprint.construct( Blueprint3 );
  test.identical( _.prototype.each( instance3 ).length, 4 );

  test.true( _.prototype.each( instance3 )[ 0 ] === instance3 );
  test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint3.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint2.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 2 ] === Blueprint1.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 3 ] === _.Construction.prototype );

  /* */

  test.case = 'with object. new:implicit';

  var proto1 = Object.create( null );
  var proto2 = Object.create( proto1 );

  var Blueprint3 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true, prototype : proto2 }),
    // typed : _.trait.typed( true ),
    // prototype : _.trait.prototype( proto2 ),
  });

  var instance3 = _.blueprint.construct( Blueprint3 );
  test.identical( _.prototype.each( instance3 ).length, 3 );

  test.true( _.prototype.each( instance3 )[ 0 ] === instance3 );
  test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint3.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 1 ] === proto2 );
  test.true( _.prototype.each( instance3 )[ 2 ] === proto1 );

  /* */

  test.case = 'with object. new:0';

  var proto1 = Object.create( null );
  var proto2 = Object.create( proto1 );

  var Blueprint3 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true, prototype : proto2, new : 0 }),
    // typed : _.trait.typed( true ),
    // prototype : _.trait.prototype( proto2, { new : 0 } ),
  });

  var instance3 = _.blueprint.construct( Blueprint3 );
  test.identical( _.prototype.each( instance3 ).length, 3 );

  test.true( _.prototype.each( instance3 )[ 0 ] === instance3 );
  test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint3.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 1 ] === proto2 );
  test.true( _.prototype.each( instance3 )[ 2 ] === proto1 );

  /* */

  test.case = 'with object. new:1';

  var proto1 = Object.create( null );
  var proto2 = Object.create( proto1 );

  var Blueprint3 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true, prototype : proto2, new : 1 }),
    // typed : _.trait.typed( true ),
    // prototype : _.trait.prototype( proto2, { new : 1 } ),
  });

  var instance3 = _.blueprint.construct( Blueprint3 );
  test.identical( _.prototype.each( instance3 ).length, 4 );

  test.true( _.prototype.each( instance3 )[ 0 ] === instance3 );
  test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint3.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 2 ] === proto2 );
  test.true( _.prototype.each( instance3 )[ 3 ] === proto1 );

  /* */

  test.case = 'with object with constructor immediately. new:implicit';

  var proto1 = Object.create( null );
  var proto2 = Object.create( proto1 );
  proto2.constructor = function constr1(){}

  var Blueprint3 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true, prototype : proto2 }),
    // typed : _.trait.typed( true ),
    // prototype : _.trait.prototype( proto2 ),
  });

  var instance3 = _.blueprint.construct( Blueprint3 );

  test.identical( _.prototype.each( instance3 ).length, 3 );
  test.true( _.prototype.each( instance3 )[ 0 ] === instance3 );
  test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint3.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 1 ] === proto2 );
  test.true( _.prototype.each( instance3 )[ 2 ] === proto1 );

  test.identical( _.prototype.each( Blueprint3.Make ).length, 4 );
  test.true( _.prototype.each( Blueprint3.Make )[ 0 ] !== proto2.constructor );
  test.true( _.prototype.each( Blueprint3.Make )[ 1 ] === proto2.constructor );
  test.true( _.prototype.each( Blueprint3.Make )[ 2 ] === Function.prototype );
  test.true( _.prototype.each( Blueprint3.Make )[ 3 ] === Object.prototype );

  /* */

  test.case = 'with object with constructor immediately. new:0';

  var proto1 = Object.create( null );
  var proto2 = Object.create( proto1 );
  proto2.constructor = function constr1(){}

  var Blueprint3 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true, prototype : proto2, new : 0 }),
    // typed : _.trait.typed( true ),
    // prototype : _.trait.prototype( proto2, { new : 0 } ),
  });

  var instance3 = _.blueprint.construct( Blueprint3 );
  test.identical( _.prototype.each( instance3 ).length, 3 );

  test.identical( _.prototype.each( instance3 ).length, 3 );
  test.true( _.prototype.each( instance3 )[ 0 ] === instance3 );
  test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint3.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 1 ] === proto2 );
  test.true( _.prototype.each( instance3 )[ 2 ] === proto1 );

  test.identical( _.prototype.each( Blueprint3.Make ).length, 4 );
  test.true( _.prototype.each( Blueprint3.Make )[ 0 ] !== proto2.constructor );
  test.true( _.prototype.each( Blueprint3.Make )[ 1 ] === proto2.constructor );
  test.true( _.prototype.each( Blueprint3.Make )[ 2 ] === Function.prototype );
  test.true( _.prototype.each( Blueprint3.Make )[ 3 ] === Object.prototype );

  /* */

  test.case = 'with object with constructor immediately. new:1';

  var proto1 = Object.create( null );
  var proto2 = Object.create( proto1 );
  proto2.constructor = function constr1(){}

  var Blueprint3 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true, prototype : proto2, new : 1 }),
    // typed : _.trait.typed( true ),
    // prototype : _.trait.prototype( proto2, { new : 1 } ),
  });

  var instance3 = _.blueprint.construct( Blueprint3 );

  test.identical( _.prototype.each( instance3 ).length, 4 );
  test.true( _.prototype.each( instance3 )[ 0 ] === instance3 );
  test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint3.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 2 ] === proto2 );
  test.true( _.prototype.each( instance3 )[ 3 ] === proto1 );

  test.identical( _.prototype.each( Blueprint3.Make ).length, 4 );
  test.true( _.prototype.each( Blueprint3.Make )[ 0 ] !== proto2.constructor );
  test.true( _.prototype.each( Blueprint3.Make )[ 1 ] === proto2.constructor );
  test.true( _.prototype.each( Blueprint3.Make )[ 2 ] === Function.prototype );
  test.true( _.prototype.each( Blueprint3.Make )[ 3 ] === Object.prototype );

  /* */

  test.case = 'with object with constructor mediatory. new:implicit';

  var proto1 = Object.create( null );
  proto1.constructor = function constr1(){}
  var proto2 = Object.create( proto1 );

  var Blueprint3 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true, prototype : proto2 }),
    // typed : _.trait.typed( true ),
    // prototype : _.trait.prototype( proto2 ),
  });

  var instance3 = _.blueprint.construct( Blueprint3 );

  test.identical( _.prototype.each( instance3 ).length, 3 );
  test.true( _.prototype.each( instance3 )[ 0 ] === instance3 );
  test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint3.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 1 ] === proto2 );
  test.true( _.prototype.each( instance3 )[ 2 ] === proto1 );

  test.identical( _.prototype.each( Blueprint3.Make ).length, 1 );

  /* */

  test.case = 'with object with constructor mediatory. new:0';

  var proto1 = Object.create( null );
  proto1.constructor = function constr1(){}
  var proto2 = Object.create( proto1 );

  var Blueprint3 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true, prototype : proto2, new : 0 }),
    // typed : _.trait.typed( true ),
    // prototype : _.trait.prototype( proto2, { new : 0 } ),
  });

  var instance3 = _.blueprint.construct( Blueprint3 );
  test.identical( _.prototype.each( instance3 ).length, 3 );

  test.identical( _.prototype.each( instance3 ).length, 3 );
  test.true( _.prototype.each( instance3 )[ 0 ] === instance3 );
  test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint3.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 1 ] === proto2 );
  test.true( _.prototype.each( instance3 )[ 2 ] === proto1 );

  test.identical( _.prototype.each( Blueprint3.Make ).length, 1 );

  /* */

  test.case = 'with object with constructor mediatory. new:1';

  var proto1 = Object.create( null );
  proto1.constructor = function constr1(){}
  var proto2 = Object.create( proto1 );

  var Blueprint3 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true, prototype : proto2, new : 1 }),
    // typed : _.trait.typed( true ),
    // prototype : _.trait.prototype( proto2, { new : 1 } ),
  });

  var instance3 = _.blueprint.construct( Blueprint3 );

  test.identical( _.prototype.each( instance3 ).length, 4 );
  test.true( _.prototype.each( instance3 )[ 0 ] === instance3 );
  test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint3.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 2 ] === proto2 );
  test.true( _.prototype.each( instance3 )[ 3 ] === proto1 );

  test.identical( _.prototype.each( Blueprint3.Make ).length, 1 );

  /* */

  test.case = 'with null. new:implicit';

  var proto1 = null;
  var Blueprint3 = _.Blueprint
  ({
    typed : _.trait.typed({ val : false, prototype : proto1 }),
    // typed : _.trait.typed( false ),
    // prototype : _.trait.prototype( proto1 ),
  });

  var instance3 = _.blueprint.construct( Blueprint3 );
  test.identical( _.prototype.each( instance3 ).length, 1 );

  test.true( _.prototype.each( instance3 )[ 0 ] === instance3 );

  /* */

  test.case = 'with null. new:0';

  var proto1 = null;
  var Blueprint3 = _.Blueprint
  ({
    typed : _.trait.typed({ val : false, prototype : proto1, new : 0 }),
    // typed : _.trait.typed( false ),
    // prototype : _.trait.prototype( proto1, { new : 0 } ),
  });

  var instance3 = _.blueprint.construct( Blueprint3 );
  test.identical( _.prototype.each( instance3 ).length, 1 );

  test.true( _.prototype.each( instance3 )[ 0 ] === instance3 );

  /* */

  test.case = 'with null. new:1';

  var proto1 = null;
  var Blueprint3 = _.Blueprint
  ({
    typed : _.trait.typed({ val : false, prototype : proto1, new : 1 }),
    // typed : _.trait.typed( false ),
    // prototype : _.trait.prototype( proto1, { new : 1 } ),
  });

   var instance3 = _.blueprint.construct( Blueprint3 );
  test.identical( _.prototype.each( instance3 ).length, 1 );
  test.true( _.prototype.each( instance3 )[ 0 ] === instance3 );

  /* */

  test.case = 'throwing, prototype:null, val:false, new:false';
  if( Config.debug )
  test.mustNotThrowError( () =>
  {
    _.Blueprint
    ({
      typed : _.trait.typed({ prototype : null, val : false, new : false }),
    });
  });

  test.case = 'throwing, prototype:null, val:false, new:true';
  if( Config.debug )
  test.mustNotThrowError( () =>
  {
    _.Blueprint
    ({
      typed : _.trait.typed({ prototype : null, val : false, new : true }),
    });
  });

  test.case = 'throwing, prototype:null, val:true, new:false';
  if( Config.debug )
  test.shouldThrowErrorSync( () =>
  {
    _.Blueprint
    ({
      typed : _.trait.typed({ prototype : null, val : true, new : false }),
    });
  });

  test.case = 'throwing, prototype:null, val:true, new:true';
  if( Config.debug )
  test.shouldThrowErrorSync( () =>
  {
    _.Blueprint
    ({
      typed : _.trait.typed({ prototype : null, val : true, new : true }),
    });
  });

  /* */

}

//

function traitTypedTrivial( test )
{

  /* */

  test.case = 'blueprint with untyped instance, implicit';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
  });
  var instance = _.blueprint.construct( Blueprint );

  test.identical( _.blueprint.isDefinitive( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), _.maybe );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), _.maybe );

  // test.identical( instance instanceof Blueprint.Make, false );
  test.identical( Object.getPrototypeOf( instance ), null );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 1 );
  test.true( prototypes[ 0 ] === instance );
  test.true( !_.prototype.hasPrototype( instance, Blueprint ) );
  test.true( _.objectIs( instance ) );
  test.true( _.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

  test.case = 'blueprint with untyped instance, explicit';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var instance = _.blueprint.construct( Blueprint );

  test.identical( _.blueprint.isDefinitive( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), _.maybe );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), _.maybe );

  // test.identical( instance instanceof Blueprint.Make, false );
  test.identical( Object.getPrototypeOf( instance ), null );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 1 );
  test.true( prototypes[ 0 ] === instance );
  test.true( !_.prototype.hasPrototype( instance, Blueprint ) );
  test.true( _.objectIs( instance ) );
  test.true( _.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

  test.case = 'blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var instance = _.blueprint.construct( Blueprint );

  test.identical( _.blueprint.isDefinitive( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), true );

  test.identical( instance instanceof Blueprint.Make, true );
  test.identical( Object.getPrototypeOf( Object.getPrototypeOf( instance ) ), _.Construction.prototype );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === instance );
  test.true( prototypes[ 1 ] === Blueprint.Make.prototype );
  test.true( prototypes[ 2 ] === _.Construction.prototype );
  test.true( _.prototype.hasPrototype( instance, instance ) );
  test.true( _.prototype.hasPrototype( instance, Blueprint.Make.prototype ) );
  test.true( _.prototype.hasPrototype( instance, _.Construction.prototype ) );
  test.true( _.objectIs( instance ) );
  test.true( !_.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

  function rfield( arg )
  {
    return 'x' + arg;
  }

}

traitTypedTrivial.description =
`
- construction is untyped by default
- construction is typed if trait typed is true
`

//

function traitTypedBasic( test )
{

  /* - */

  test.case = `implicit typing`;
  var blueprint1 = _.blueprint.define
  ({
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* - */

  test.case = `typed:0 prototype:0`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 0, prototype : 0 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* */

  test.case = `typed:0 prototype:0 new:0`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 0, prototype : 0, new : 0 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* */

  test.case = `typed:0 prototype:0 new:1`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 0, prototype : 0, new : 1 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* */

  test.case = `typed:0 prototype:1`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 0, prototype : 1 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* */

  test.case = `typed:0 prototype:1 new:0`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 0, prototype : 1, new : 0 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* */

  test.case = `typed:0 prototype:1 new:1`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 0, prototype : 1, new : 1 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* */

  test.case = `typed:0 prototype:null`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 0, prototype : null }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* */

  test.case = `typed:0 prototype:null new:1`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 0, prototype : null, new : 1 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* */

  test.case = `typed:0 prototype:null new:0`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 0, prototype : null, new : 0 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* */

  if( Config.debug )
  {
    test.case = `typed:0 prototype:object`;
    var prototype2 = Object.create( null );
    test.shouldThrowErrorSync( () =>
    {
      var blueprint1 = _.blueprint.define
      ({
        typed : _.trait.typed({ val : 0, prototype : prototype2 }),
        f1 : 'a',
      });
    });
  }

  /* */

  test.case = `typed:0 prototype:implicit`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 0 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* */

  test.case = `typed:0 prototype:implicit new:1`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 0, new : 1 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* */

  test.case = `typed:0 prototype:implicit, new : 0`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 0, new : 0 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* - */

  test.case = `typed:1 prototype:0`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 1, prototype : 0 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 3 );

  /* */

  test.case = `typed:1 prototype:0 new:1`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 1, prototype : 0, new : 1 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 3 );

  /* */

  test.case = `typed:1 prototype:0 new:0`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 1, prototype : 0, new : 0 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 3 );

  /* */

  test.case = `typed:1 prototype:1`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 1, prototype : 1 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 3 );

  /* */

  test.case = `typed:1 prototype:1 new:1`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 1, prototype : 1, new : 1 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 3 );

  /* */

  test.case = `typed:1 prototype:1 new:0`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 1, prototype : 1, new : 0 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 3 );

  /* */

  if( Config.debug )
  {
    test.case = `typed:1 prototype:null`;
    test.shouldThrowErrorSync( () =>
    {
      var blueprint1 = _.blueprint.define
      ({
        typed : _.trait.typed({ val : 1, prototype : null }),
        f1 : 'a',
      });
    });
  }

  /* */

  test.case = `typed:1 prototype:object`;
  var prototype2 = Object.create( null );
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 1, prototype : prototype2 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 2 );
  test.true( _.prototype.each( instance1 )[ 0 ] === instance1 );
  test.true( _.prototype.each( instance1 )[ 1 ] === prototype2 );

  /* */

  test.case = `typed:1 prototype:object new:1`;
  var prototype2 = Object.create( null );
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 1, prototype : prototype2, new : 1 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 3 );
  test.true( _.prototype.each( instance1 )[ 0 ] === instance1 );
  test.true( _.prototype.each( instance1 )[ 2 ] === prototype2 );

  /* */

  test.case = `typed:1 prototype:object new:0`;
  var prototype2 = Object.create( null );
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 1, prototype : prototype2, new : 0 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 2 );
  test.true( _.prototype.each( instance1 )[ 0 ] === instance1 );
  test.true( _.prototype.each( instance1 )[ 1 ] === prototype2 );

  /* */

  test.case = `typed:1 prototype:implicit`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 1 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 3 );
  test.true( _.prototype.each( instance1 )[ 0 ] === instance1 );
  test.true( _.prototype.each( instance1 )[ 2 ] === _.Construction.prototype );

  /* */

  test.case = `typed:1 prototype:implicit new:1`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 1, new : 1 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 3 );
  test.true( _.prototype.each( instance1 )[ 0 ] === instance1 );
  test.true( _.prototype.each( instance1 )[ 2 ] === _.Construction.prototype );

  /* */

  test.case = `typed:1 prototype:implicit, new:0`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : 1, new : 0 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 3 );
  test.true( _.prototype.each( instance1 )[ 0 ] === instance1 );
  test.true( _.prototype.each( instance1 )[ 2 ] === _.Construction.prototype );

  /* - */

  test.case = `typed:maybe prototype:0`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : _.maybe, prototype : 0 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* */

  test.case = `typed:maybe prototype:0 new:1`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : _.maybe, prototype : 0, new : 1 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* */

  test.case = `typed:maybe prototype:0 new:0`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : _.maybe, prototype : 0, new : 0 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* */

  test.case = `typed:maybe prototype:1`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : _.maybe, prototype : 1 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 3 );

  /* */

  test.case = `typed:maybe prototype:1 new:0`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : _.maybe, prototype : 1, new : 0 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 3 );

  /* */

  test.case = `typed:maybe prototype:1 new:1`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : _.maybe, prototype : 1, new : 1 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 3 );

  /* */

  test.case = `typed:maybe prototype:null`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : _.maybe, prototype : null }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* */

  test.case = `typed:maybe prototype:null new:0`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : _.maybe, prototype : null, new : 0 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* */

  test.case = `typed:maybe prototype:null new:1`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : _.maybe, prototype : null, new : 1 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );

  /* */

  test.case = `typed:maybe prototype:object`;
  var prototype2 = Object.create( null );
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : _.maybe, prototype : prototype2 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 2 );
  test.true( _.prototype.each( instance1 )[ 0 ] === instance1 );
  test.true( _.prototype.each( instance1 )[ 1 ] === prototype2 );

  /* */

  test.case = `typed:maybe prototype:object, new:0`;
  var prototype2 = Object.create( null );
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : _.maybe, prototype : prototype2, new : 0 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 2 );
  test.true( _.prototype.each( instance1 )[ 0 ] === instance1 );
  test.true( _.prototype.each( instance1 )[ 1 ] === prototype2 );

  /* */

  test.case = `typed:maybe prototype:object, new:1`;
  var prototype2 = Object.create( null );
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : _.maybe, prototype : prototype2, new : 1 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 3 );
  test.true( _.prototype.each( instance1 )[ 0 ] === instance1 );
  test.true( _.prototype.each( instance1 )[ 2 ] === prototype2 );

  /* */

  test.case = `typed:maybe prototype:implicit`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : _.maybe }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );
  test.true( _.prototype.each( instance1 )[ 0 ] === instance1 );

  /* */

  test.case = `typed:maybe prototype:implicit new:0`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : _.maybe, new : 0 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );
  test.true( _.prototype.each( instance1 )[ 0 ] === instance1 );

  /* */

  test.case = `typed:maybe prototype:implicit new:1`;
  var blueprint1 = _.blueprint.define
  ({
    typed : _.trait.typed({ val : _.maybe, new : 1 }),
    f1 : 'a',
  });
  var instance1 = blueprint1.Make();
  var exp = { f1 : 'a' }
  test.identical( _.property.all( instance1 ), exp );
  test.identical( _.prototype.each( instance1 ).length, 1 );
  test.true( _.prototype.each( instance1 )[ 0 ] === instance1 );

  /* - */

}

traitTypedBasic.timeOut = 30000;
traitTypedBasic.rapidity = 1;

//

function traitTypedConstructionAmend( test )
{
  let context = this;

  eachHow({ amending : 'extend' });
  eachHow({ amending : 'supplement' });

  /* - */

  function eachHow( tops )
  {
    tops.extension = 'map';
    eachCase( tops );
    tops.extension = 'blueprint';
    eachCase( tops );
  }

  /* -- */

  function eachCase( tops )
  {
    var instance1;

    /* - */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, pure map, typed:implicict, prototype:implicit`;
    var extension =
    {
    };
    var dstContainer = Object.create( null );

    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );

    test.true( instance1 === dstContainer );
    test.true( _.mapIs( dstContainer ) );
    test.true( _.prototype.of( dstContainer ) === null );
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, polluted map, typed:implicict, prototype:implicit`;
    var extension =
    {
    };
    var dstContainer = {};
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.mapIs( dstContainer ) );
    test.true( _.prototype.of( dstContainer ) === Object.prototype );
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, prototyped, typed:implicict, prototype:implicit`;
    var extension =
    {
    };
    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );

    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );

    if( tops.extension === 'map' )
    {
      test.true( !_.mapIs( dstContainer ) );
      test.true( _.prototype.each( dstContainer )[ 1 ] === prototype );
      test.identical( _.prototype.each( dstContainer ).length, 2 );
    }
    else
    {
      test.true( _.mapIs( dstContainer ) );
      test.identical( _.prototype.each( dstContainer ).length, 1 );
    }

    /* - */

/*

== typed:0

prototype:0
preserve prototype of the map, but change if not map to pure map

prototype:1
change prototype to null

prototype:null
change prototype to null

prototype:object
throw error

*/

    test.case = `amending:${tops.amending}, extension:${tops.extension}, pure map, typed:0, prototype:0`;
    var extension =
    {
      typed : _.trait.typed( 0, { prototype : false } ),
    };
    var dstContainer = Object.create( null );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.mapIs( dstContainer ) );
    test.true( _.prototype.of( dstContainer ) === null );
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, pure map, typed:0, prototype:1`;
    var extension =
    {
      typed : _.trait.typed( 0, { prototype : true } ),
    };
    var dstContainer = Object.create( null );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.mapIs( dstContainer ) );
    test.true( _.prototype.of( dstContainer ) === null );
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, pure map, typed:0, prototype:null`;
    var extension =
    {
      typed : _.trait.typed( 0, { prototype : null } ),
    };
    var dstContainer = Object.create( null );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.mapIs( dstContainer ) );
    test.true( _.prototype.of( dstContainer ) === null );
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, pure map, typed:0, prototype:implicit`;
    var extension =
    {
      typed : _.trait.typed( 0 ),
    };
    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.mapIs( dstContainer ) );
    test.true( _.prototype.of( dstContainer ) === null );
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    /* - */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, polluted map, typed:0, prototype:0`;
    var extension =
    {
      typed : _.trait.typed( 0, { prototype : false } ),
    };
    var dstContainer = {};
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.mapIs( dstContainer ) );
    test.true( _.prototype.of( dstContainer ) === Object.prototype );
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, polluted map, typed:0, prototype:1`;
    var extension =
    {
      typed : _.trait.typed( 0, { prototype : true } ),
    };
    var dstContainer = {};
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.mapIs( dstContainer ) );
    test.true( _.prototype.of( dstContainer ) === null );
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, polluted map, typed:0, prototype:null`;
    var extension =
    {
      typed : _.trait.typed( 0, { prototype : null } ),
    };
    var dstContainer = {};
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.mapIs( dstContainer ) );
    test.true( _.prototype.of( dstContainer ) === null );
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, polluted map, typed:0, prototype:implicit`;
    var extension =
    {
      typed : _.trait.typed( 0 ),
    };
    var dstContainer = {};
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.mapIs( dstContainer ) );
    test.true( _.prototype.of( dstContainer ) === Object.prototype );
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    /* - */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, prototyped, typed:0, prototype:0`;
    var extension =
    {
      typed : _.trait.typed( 0, { prototype : false } ),
    };
    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.mapIs( dstContainer ) );
    test.true( _.prototype.of( dstContainer ) === null );
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, prototyped, typed:0, prototype:1`;
    var extension =
    {
      typed : _.trait.typed( 0, { prototype : true } ),
    };
    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.mapIs( dstContainer ) );
    test.true( _.prototype.of( dstContainer ) === null );
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, prototyped, typed:0, prototype:null`;
    var extension =
    {
      typed : _.trait.typed( 0, { prototype : null } ),
    };
    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.mapIs( dstContainer ) );
    test.true( _.prototype.of( dstContainer ) === null );
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, prototyped, typed:0, prototype:explicit`;
    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );
    if( Config.debug )
    test.shouldThrowErrorSync( () =>
    {
      var extension =
      {
        typed : _.trait.typed( 0, { prototype : prototype } ),
      };
    },
    ( err ) =>
    {
      test.identical( err.originalMessage, 'Trait::typed should be either not false or prototype should be [ true, false, null ], it is Map.pure' );
    });

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, prototyped, typed:0, prototype:implicit`;
    var extension =
    {
      typed : _.trait.typed( 0 ),
    };
    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.mapIs( dstContainer ) );
    test.true( _.prototype.of( dstContainer ) === null );
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    /* - */

/*

== typed:1

prototype:0
preserve prototype of typed destination, but change if it is map

prototype:1
set generated prototype

prototype:null
throw error

prototype:object
set custom prototype

*/

    test.case = `amending:${tops.amending}, extension:${tops.extension}, pure map, typed:1, prototype:0`;
    var extension =
    {
      typed : _.trait.typed( 1, { prototype : false } ),
    };
    var dstContainer = Object.create( null );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );
    test.identical( _.prototype.each( dstContainer ).length, 3 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, pure map, typed:1, prototype:1`;
    var extension =
    {
      typed : _.trait.typed( 1, { prototype : true } ),
    };
    var dstContainer = Object.create( null );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );
    test.identical( _.prototype.each( dstContainer ).length, 3 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, pure map, typed:1, prototype:null`;
    var extension =
    {
      typed : _.trait.typed( 1, { prototype : null } ),
    };
    var dstContainer = Object.create( null );
    if( Config.debug )
    test.shouldThrowErrorSync
    (
      () => _.construction[ tops.amending ]( dstContainer, extension ),
      ( err ) =>
      {
        test.identical( err.originalMessage, 'Object with null prototype cant be typed' )
      }
    );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, pure map, typed:1, prototype:explicit`;
    var prototype2 = Object.create( null );
    var dstContainer = Object.create( null );
    var extension =
    {
      typed : _.trait.typed( 1, { prototype : prototype2 } ),
    };
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.each( dstContainer )[ 1 ] === prototype2 );
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, pure map, typed:1, prototype:implicict`;
    var extension =
    {
      typed : _.trait.typed( 1 ),
    };
    var dstContainer = Object.create( null );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );
    test.identical( _.prototype.each( dstContainer ).length, 3 );

    /* - */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, polluted map, typed:1, prototype:0`;
    var extension =
    {
      typed : _.trait.typed( 1, { prototype : false } ),
    };
    var dstContainer = {};
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );
    test.identical( _.prototype.each( dstContainer ).length, 3 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, polluted map, typed:1, prototype:1`;
    var extension =
    {
      typed : _.trait.typed( 1, { prototype : true } ),
    };
    var dstContainer = {};
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );
    test.identical( _.prototype.each( dstContainer ).length, 3 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, polluted map, typed:1, prototype:null`;
    var extension =
    {
      typed : _.trait.typed( 1, { prototype : null } ),
    };
    var dstContainer = {};
    if( Config.debug )
    test.shouldThrowErrorSync
    (
      () =>
      {
        if( tops.extension === 'map' )
        _.construction[ tops.amending ]( dstContainer, extension );
        else
        instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
      },
      ( err ) =>
      {
        test.identical( err.originalMessage, 'Object with null prototype cant be typed' )
      }
    );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, polluted map, typed:1, prototype:explicit`;
    var prototype2 = Object.create( null );
    var dstContainer = {};
    var extension =
    {
      typed : _.trait.typed( 1, { prototype : prototype2 } ),
    };
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.each( dstContainer )[ 1 ] === prototype2 );
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, polluted map, typed:1, prototype:implicit`;
    var extension =
    {
      typed : _.trait.typed( 1 ),
    };
    var dstContainer = {};
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );
    test.identical( _.prototype.each( dstContainer ).length, 3 );

    /* - */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, prototyped, typed:1, prototype:0`;
    var extension =
    {
      typed : _.trait.typed( 1, { prototype : false } ),
    };
    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.of( dstContainer ) === prototype );
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, prototyped, typed:1, prototype:1`;
    var extension =
    {
      typed : _.trait.typed( 1, { prototype : true } ),
    };
    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );
    test.identical( _.prototype.each( dstContainer ).length, 3 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, prototyped, typed:1, prototype:null`;
    var extension =
    {
      typed : _.trait.typed( 1, { prototype : null } ),
    };
    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );
    if( Config.debug )
    test.shouldThrowErrorSync
    (
      () =>
      {
        if( tops.extension === 'map' )
        _.construction[ tops.amending ]( dstContainer, extension );
        else
        instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
      },
      ( err ) =>
      {
        test.identical( err.originalMessage, 'Object with null prototype cant be typed' )
      }
    );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, prototyped, typed:1, prototype:explicit same`;
    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );
    var extension =
    {
      typed : _.trait.typed( 1, { prototype : prototype } ),
    };
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.of( dstContainer ) === prototype );
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, prototyped, typed:1, prototype:explicit different`;
    var prototype = Object.create( null );
    var prototype2 = Object.create( null );
    var dstContainer = Object.create( prototype );
    var extension =
    {
      typed : _.trait.typed( 1, { prototype : prototype2 } ),
    };
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.of( dstContainer ) === prototype2 );
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, prototyped, typed:1, prototype:implicict`;
    var extension =
    {
      typed : _.trait.typed( 1 ),
    };
    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );
    test.identical( _.prototype.each( dstContainer ).length, 3 );

    /* - */

/*

== typed:maybe

prototype:0
preserve prototype of typed destination
preserve as map if untyped destination
create untyped

prototype:1
set generated prototype if destination is typed
change prototype to null if untyped
create typed

prototype:null
preserve prototype if typed
set prototype to null if untyped
create untyped

prototype:object
set custom prototype if typed
preserve if untyped
create typed

*/

    test.case = `amending:${tops.amending}, extension:${tops.extension}, pure map, typed:maybe, prototype:0`;
    var extension =
    {
      typed : _.trait.typed( _.maybe, { prototype : false } ),
    };
    var dstContainer = Object.create( null );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.of( dstContainer ) === null );
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, pure map, typed:maybe, prototype:1`;
    var extension =
    {
      typed : _.trait.typed( _.maybe, { prototype : true } ),
    };
    var dstContainer = Object.create( null );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.of( dstContainer ) === null );
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, pure map, typed:maybe, prototype:null`;
    var extension =
    {
      typed : _.trait.typed( _.maybe, { prototype : null } ),
    };
    var dstContainer = Object.create( null );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.of( dstContainer ) === null );
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, pure map, typed:maybe`;
    var prototype2 = Object.create( null );
    var dstContainer = Object.create( null );
    var extension =
    {
      typed : _.trait.typed( _.maybe, { prototype : prototype2 } ),
    };
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.of( dstContainer ) === null );
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, pure map, typed:maybe, prototype:implicit`;
    var extension =
    {
      typed : _.trait.typed( _.maybe ),
    };
    var dstContainer = Object.create( null );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.of( dstContainer ) === null );
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    /* - */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, polluted map, typed:maybe, prototype:0`;
    var extension =
    {
      typed : _.trait.typed( _.maybe, { prototype : false } ),
    };
    var dstContainer = {};
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.of( dstContainer ) === Object.prototype );
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, polluted map, typed:maybe, prototype:1`;
    var extension =
    {
      typed : _.trait.typed( _.maybe, { prototype : true } ),
    };
    var dstContainer = {};
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.of( dstContainer ) === null );
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, polluted map, typed:maybe, prototype:null`;
    var extension =
    {
      typed : _.trait.typed( _.maybe, { prototype : null } ),
    };
    var dstContainer = {};
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.of( dstContainer ) === null );
    test.identical( _.prototype.each( dstContainer ).length, 1 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, polluted map, typed:maybe, prototype:explicict`;
    var prototype2 = Object.create( null );
    var dstContainer = {};
    var extension =
    {
      typed : _.trait.typed( _.maybe, { prototype : prototype2 } ),
    };
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.of( dstContainer ) === Object.prototype );
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, polluted map, typed:maybe, prototype:implicit`;
    var extension =
    {
      typed : _.trait.typed( _.maybe ),
    };
    var dstContainer = {};
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.of( dstContainer ) === Object.prototype );
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    /* - */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, prototyped, typed:maybe, prototype:0`;
    var extension =
    {
      typed : _.trait.typed( _.maybe, { prototype : false } ),
    };
    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.of( dstContainer ) === prototype );
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, prototyped, typed:maybe, prototype:1`;
    var extension =
    {
      typed : _.trait.typed( _.maybe, { prototype : true } ),
    };
    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );
    test.identical( _.prototype.each( dstContainer ).length, 3 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, prototyped, typed:maybe, prototype:null`;
    var extension =
    {
      typed : _.trait.typed( _.maybe, { prototype : null } ),
    };
    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.each( dstContainer )[ 1 ] === prototype );
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, prototyped, typed:maybe, prototype:explicit same`;
    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );
    var extension =
    {
      typed : _.trait.typed( _.maybe, { prototype : prototype } ),
    };
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.of( dstContainer ) === prototype );
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, prototyped, typed:maybe, prototype:explicit different`;
    var prototype = Object.create( null );
    var prototype2 = Object.create( null );
    var dstContainer = Object.create( prototype );
    var extension =
    {
      typed : _.trait.typed( _.maybe, { prototype : prototype2 } ),
    };
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.of( dstContainer ) === prototype2 );
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    /* */

    test.case = `amending:${tops.amending}, extension:${tops.extension}, prototyped, typed:maybe, prototype:implicit`;
    var extension =
    {
      typed : _.trait.typed( _.maybe ),
    };
    var prototype = Object.create( null );
    var dstContainer = Object.create( prototype );
    if( tops.extension === 'map' )
    instance1 = _.construction[ tops.amending ]( dstContainer, extension );
    else
    instance1 = _.construction[ tops.amending ]( dstContainer, _.Blueprint( extension ) );
    test.true( instance1 === dstContainer );
    test.true( _.prototype.of( dstContainer ) === prototype );
    test.identical( _.prototype.each( dstContainer ).length, 2 );

    /* - */

  }

}

traitTypedConstructionAmend.timeOut = 30000;
traitTypedConstructionAmend.rapidity = 1;

//

function traitTypedPrototypeBlueprint( test )
{

  /* */

  test.case = 'default';

  var Blueprint1 = _.Blueprint
  ({
    field1 : null,
  });

  var instance1 = _.blueprint.construct( Blueprint1 );
  var prototypes1 = _.prototype.each( instance1 );
  test.identical( prototypes1.length, 1 );

  /* */

  test.case = 'trivial throwing';

  var Blueprint1 = _.Blueprint
  ({
    field1 : null,
  });

  var instance1 = _.blueprint.construct( Blueprint1 );
  var prototypes1 = _.prototype.each( instance1 );
  test.identical( prototypes1.length, 1 );

  test.shouldThrowErrorSync
  (
    () =>
    {
      var Blueprint2 = _.Blueprint
      ({
        typed : _.trait.typed( 1, { prototype : Blueprint1 } ),
      });
    },
    ( err ) => test.identical( err.originalMessage, 'Cant use Blueprint:: as prototype. This blueprint is not prototyped.' ),
  );

  /* */

  test.case = 'named throwing';

  var Blueprint1 = _.Blueprint
  ({
    field1 : null,
    name : _.trait.name( 'name1' ),
  });

  var instance1 = _.blueprint.construct( Blueprint1 );
  var prototypes1 = _.prototype.each( instance1 );
  test.identical( prototypes1.length, 1 );

  test.shouldThrowErrorSync
  (
    () =>
    {
      var Blueprint2 = _.Blueprint
      ({
        typed : _.trait.typed( 1, { prototype : Blueprint1 } ),
      });
    },
    ( err ) => test.identical( err.originalMessage, 'Cant use Blueprint::name1 as prototype. This blueprint is not prototyped.' ),
  );

  /* */

  test.case = 'does not throw, because overridden';

  var Blueprint1 = _.Blueprint
  ({
    field1 : null,
  });

  var Blueprint2 = _.Blueprint
  ({
    typed : _.trait.typed( 1, { prototype : Blueprint1 } ),
    extension : _.define.extension( Blueprint1 ),
  });

  var instance1 = _.blueprint.construct( Blueprint1 );
  var prototypes1 = _.prototype.each( instance1 );
  test.identical( prototypes1.length, 1 );

  var instance2 = _.blueprint.construct( Blueprint2 );
  var prototypes2 = _.prototype.each( instance2 );
  test.identical( prototypes2.length, 1 );

  /* */

  test.case = 'legal';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( 1 ),
  });

  var Blueprint2 = _.Blueprint
  ({
    typed : _.trait.typed( 1, { prototype : Blueprint1 } ),
  });

  var Blueprint3 = _.Blueprint
  ({
    typed : _.trait.typed( 1, { prototype : Blueprint2 } ),
  });

  var instance1 = _.blueprint.construct( Blueprint1 );
  test.identical( _.prototype.each( instance1 ).length, 3 );
  test.true( _.prototype.each( instance1 )[ 0 ] === instance1 );
  test.true( _.prototype.each( instance1 )[ 1 ] === Blueprint1.prototype );
  test.true( _.prototype.each( instance1 )[ 1 ] === Blueprint1.Make.prototype );
  test.true( _.prototype.each( instance1 )[ 2 ] === _.Construction.prototype );

  var instance2 = _.blueprint.construct( Blueprint2 );
  test.identical( _.prototype.each( instance2 ).length, 4 );
  test.true( _.prototype.each( instance2 )[ 0 ] === instance2 );
  test.true( _.prototype.each( instance2 )[ 1 ] === Blueprint2.prototype );
  test.true( _.prototype.each( instance2 )[ 1 ] === Blueprint2.Make.prototype );
  test.true( _.prototype.each( instance2 )[ 2 ] === Blueprint1.prototype );
  test.true( _.prototype.each( instance2 )[ 2 ] === Blueprint1.Make.prototype );
  test.true( _.prototype.each( instance2 )[ 3 ] === _.Construction.prototype );

  var instance3 = _.blueprint.construct( Blueprint3 );
  test.identical( _.prototype.each( instance3 ).length, 5 );
  test.true( _.prototype.each( instance3 )[ 0 ] === instance3 );
  test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint3.prototype );
  test.true( _.prototype.each( instance3 )[ 1 ] === Blueprint3.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 2 ] === Blueprint2.prototype );
  test.true( _.prototype.each( instance3 )[ 2 ] === Blueprint2.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 3 ] === Blueprint1.prototype );
  test.true( _.prototype.each( instance3 )[ 3 ] === Blueprint1.Make.prototype );
  test.true( _.prototype.each( instance3 )[ 4 ] === _.Construction.prototype );

}

//

function traitTypedPrototype( test )
{

  /* */

  test.case = 'typed:maybe, prototype:explicit, order:( prototype, typed )';

  var amending = 'extend';
  var prototype = Object.create( null );
  prototype.constructor = constructor1;
  var construction = Object.create( prototype );
  var args = [];
  args.push( _.trait.typed({ val : _.maybe, prototype, new : false }) );

  var blueprint = _.blueprint._define({ src : args, amending });

  _.construction._init
  ({
    constructing : false,
    construction,
    amending,
    runtime : blueprint.Runtime,
  });

  test.identical( _.prototype.each( construction ).length, 2 );
  test.identical( construction.constructor.name, 'constructor1' );

  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( construction )[ 0 ] ), exp );
  var exp =
  {
    constructor : constructor1,
  }
  test.identical( propertyOwn( _.prototype.each( construction )[ 1 ] ), exp );

  /* */

  test.case = 'typed:maybe, prototype:explicit, order:( typed, prototype )';

  var amending = 'extend';
  var prototype = Object.create( null );
  prototype.constructor = constructor1;
  var construction = Object.create( prototype );
  var args = [];
  args.push( _.trait.typed({ val : _.maybe, prototype, new : false }) );

  var blueprint = _.blueprint._define({ src : args, amending });

  _.construction._init
  ({
    constructing : false,
    construction,
    amending,
    runtime : blueprint.Runtime,
  });

  test.identical( _.prototype.each( construction ).length, 2 );
  test.identical( construction.constructor.name, 'constructor1' );

  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( construction )[ 0 ] ), exp );
  var exp =
  {
    constructor : constructor1,
  }
  test.identical( propertyOwn( _.prototype.each( construction )[ 1 ] ), exp );

  /* */

  test.case = 'typed:1, prototype:explicit, order:( prototype, typed )';

  var amending = 'extend';
  var prototype = Object.create( null );
  prototype.constructor = constructor1;
  var construction = Object.create( prototype );
  var args = [];
  args.push( _.trait.typed({ val : 1, prototype, new : false }) );

  var blueprint = _.blueprint._define({ src : args, amending });

  _.construction._init
  ({
    constructing : false,
    construction,
    amending,
    runtime : blueprint.Runtime,
  });

  test.identical( _.prototype.each( construction ).length, 2 );
  test.identical( construction.constructor.name, 'constructor1' );

  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( construction )[ 0 ] ), exp );
  var exp =
  {
    constructor : constructor1,
  }
  test.identical( propertyOwn( _.prototype.each( construction )[ 1 ] ), exp );

  /* */

  test.case = 'typed:1, prototype:explicit, order:( typed, prototype )';

  var amending = 'extend';
  var prototype = Object.create( null );
  prototype.constructor = constructor1;
  var construction = Object.create( prototype );
  var args = [];
  args.push( _.trait.typed({ val : 1, prototype, new : false }) );

  var blueprint = _.blueprint._define({ src : args, amending });

  _.construction._init
  ({
    constructing : false,
    construction,
    amending,
    runtime : blueprint.Runtime,
  });

  test.identical( _.prototype.each( construction ).length, 2 );
  test.identical( construction.constructor.name, 'constructor1' );

  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( construction )[ 0 ] ), exp );
  var exp =
  {
    constructor : constructor1,
  }
  test.identical( propertyOwn( _.prototype.each( construction )[ 1 ] ), exp );

  /* */

  function constructor1()
  {
  }

  /* */

  function constructor2()
  {
  }

}

traitTypedPrototype.description =
`
  - extending prototyped object with explicitly defined prototype
  -- does not throw errors
`

//

function traitTypedLogistic( test )
{

  eachCase({ typed : 1 });

  function eachCase( tops )
  {

    /* */

    test.case = `typed:${_.toStr( tops.typed )}, basic`;
    var trait = _.trait.typed({ val : tops.typed });
    test.true( !Object.isExtensible( trait ) );
    test.true( !Object.isFrozen( trait ) );
    test.true( trait._blueprint === null );

    var blueprint1 = _.Blueprint( trait );

    test.true( !Object.isExtensible( trait ) );
    test.true( Object.isFrozen( trait ) );
    test.true( trait._blueprint === blueprint1 );
    test.true( trait === blueprint1.TraitsMap.typed );

    var instance1 = blueprint1.Make();
    test.identical( _.prototype.each( instance1 ).length, 3 );

    /* */

  }

}

traitTypedLogistic.description =
`
  - checks reusability of the same trait
  - checks implemtination is optimal and does not make extra copy of a trait
  - checks implemtination is safe and freeze trait when it supposed to be frozen
`

// --
// other traits
// --

function traitName( test )
{
  let context = this;
  let s = _.define.static;

  /* */

  test.case = 'unnamed blueprint';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    field1 : 'b1',
    field2 : 'b1',
    s1 : s( 'b1' ),
    s2 : s( 'b1' ),
  });

  test.identical( Blueprint1.Make.name, 'Construction' );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint1.Make();
  test.identical( instance1 instanceof Blueprint1.Make, true );
  test.true( _.routineIs( instance1.constructor ) );
  test.identical( instance1.constructor.name, 'Construction' );

  test.description = 'instance2'; /* */

  var instance2 = instance1.constructor();
  test.identical( instance2 instanceof Blueprint1.Make, true );
  test.true( _.routineIs( instance2.constructor ) );
  test.identical( instance2.constructor.name, 'Construction' );

  /* */

  test.case = 'named blueprint';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    name : _.trait.name( 'Blueprint1X' ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : s( 'b1' ),
    s2 : s( 'b1' ),
  });

  test.identical( Blueprint1.Make.name, 'Blueprint1X' );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint1.Make();
  test.identical( instance1 instanceof Blueprint1.Make, true );
  test.true( _.routineIs( instance1.constructor ) );
  test.identical( instance1.constructor.name, 'Blueprint1X' );

  test.description = 'instance2'; /* */

  var instance2 = instance1.constructor();
  test.identical( instance2 instanceof Blueprint1.Make, true );
  test.true( _.routineIs( instance2.constructor ) );
  test.identical( instance2.constructor.name, 'Blueprint1X' );

  /* */

  test.case = 'inheritance with overriding';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    name : _.trait.name( 'Blueprint1X' ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : s( 'b1' ),
    s2 : s( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    name : _.trait.name( 'Blueprint2X' ),
    field2 : 'b2',
    field3 : 'b2',
    s2 : s( 'b2' ),
    staticField3 : s( 'b2' ),
  });

  test.identical( Blueprint1.Make.name, 'Blueprint1X' );
  test.identical( Blueprint2.Make.name, 'Blueprint2X' );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint2.Make();
  test.identical( instance1 instanceof Blueprint2.Make, true );
  test.true( _.routineIs( instance1.constructor ) );
  test.identical( instance1.constructor.name, 'Blueprint2X' );

  test.description = 'instance2'; /* */

  var instance2 = instance1.constructor();
  test.identical( instance2 instanceof Blueprint2.Make, true );
  test.true( _.routineIs( instance2.constructor ) );
  test.identical( instance2.constructor.name, 'Blueprint2X' );

  /* */

  test.case = 'inheritance without overriding';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    name : _.trait.name( 'Blueprint1X' ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : s( 'b1' ),
    s2 : s( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : 'b2',
    field3 : 'b2',
    s2 : s( 'b2' ),
    staticField3 : s( 'b2' ),
  });

  test.identical( Blueprint2.Make.name, 'Blueprint1X' );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint2.Make();
  test.identical( instance1 instanceof Blueprint2.Make, true );
  test.true( _.routineIs( instance1.constructor ) );
  test.identical( instance1.constructor.name, 'Blueprint1X' );

  test.description = 'instance2'; /* */

  var instance2 = instance1.constructor();
  test.identical( instance2 instanceof Blueprint2.Make, true );
  test.true( _.routineIs( instance2.constructor ) );
  test.identical( instance2.constructor.name, 'Blueprint1X' );

  /* */

}

traitName.description =
`
  - trait name change name of the generated constructor
  - trait name in inheritable
`

//

function traitWithConstructorBasic( test )
{
  let context = this;
  let s = _.define.static;

  /* */

  test.case = 'unnamed blueprint, typed:0';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : 0 }),
    withConstructor : _.trait.withConstructor(),
    field1 : 'b1',
    field2 : 'b1',
    s1 : s( 'b1' ),
    s2 : s( 'b1' ),
  });
  test.true( Blueprint1.prototype === Blueprint1.Make.prototype );
  test.true( Blueprint1.constructor === undefined );
  test.identical( Blueprint1.Make.name, 'Construction' );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint1.Make();
  test.true( _.routineIs( instance1.constructor ) );
  test.identical( instance1.constructor.name, 'Construction' );

  test.identical( _.prototype.each( instance1 ).length, 1 );
  var exp =
  {
    constructor : instance1.constructor,
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( _.property.all( instance1 ), exp );
  var exp =
  {
    constructor : instance1.constructor,
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );

  test.description = 'instance2'; /* */

  var instance2 = instance1.constructor();
  test.true( _.routineIs( instance2.constructor ) );
  test.identical( instance2.constructor.name, 'Construction' );

  test.identical( _.prototype.each( instance2 ).length, 1 );
  var exp =
  {
    constructor : instance2.constructor,
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance2 )[ 0 ] ), exp );

  /* */

  test.case = 'unnamed blueprint, typed:1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    field1 : 'b1',
    field2 : 'b1',
    s1 : s( 'b1' ),
    s2 : s( 'b1' ),
  });
  test.true( Blueprint1.prototype === Blueprint1.Make.prototype );
  test.true( Blueprint1.Make === Blueprint1.prototype.constructor );
  test.true( Blueprint1.constructor === undefined );
  test.identical( Blueprint1.Make.name, 'Construction' );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint1.Make();
  test.identical( instance1 instanceof Blueprint1.Make, true );
  test.true( _.routineIs( instance1.constructor ) );
  test.identical( instance1.constructor.name, 'Construction' );

  test.identical( _.prototype.each( instance1 ).length, 3 );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    'field1' : 'b1',
    'field2' : 'b1',
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( _.property.all( instance1 ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );

  test.description = 'instance2'; /* */

  var instance2 = instance1.constructor();
  test.identical( instance2 instanceof Blueprint1.Make, true );
  test.true( _.routineIs( instance2.constructor ) );
  test.identical( instance2.constructor.name, 'Construction' );

  test.identical( _.prototype.each( instance2 ).length, 3 );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    'field1' : 'b1',
    'field2' : 'b1',
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( _.property.all( instance2 ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance2 )[ 0 ] ), exp );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance2 )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance2 )[ 2 ] ), exp );

  /* */

  test.case = 'named blueprint, typed:1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    name : _.trait.name( 'Blueprint1X' ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : s( 'b1' ),
    s2 : s( 'b1' ),
  });

  test.true( Blueprint1.prototype === Blueprint1.Make.prototype );
  test.true( Blueprint1.Make === Blueprint1.prototype.constructor );
  test.true( Blueprint1.constructor === undefined );
  test.identical( Blueprint1.Make.name, 'Blueprint1X' );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint1.Make();
  test.identical( instance1 instanceof Blueprint1.Make, true );
  test.true( _.routineIs( instance1.constructor ) );
  test.identical( instance1.constructor.name, 'Blueprint1X' );

  test.identical( _.prototype.each( instance1 ).length, 3 );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    'field1' : 'b1',
    'field2' : 'b1',
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( _.property.all( instance1 ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );

  test.description = 'instance2'; /* */

  var instance2 = instance1.constructor();
  test.identical( instance2 instanceof Blueprint1.Make, true );
  test.true( _.routineIs( instance2.constructor ) );
  test.identical( instance2.constructor.name, 'Blueprint1X' );

  test.identical( _.prototype.each( instance2 ).length, 3 );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    'field1' : 'b1',
    'field2' : 'b1',
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( _.property.all( instance2 ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance2 )[ 0 ] ), exp );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance2 )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance2 )[ 2 ] ), exp );

  /* */

  test.case = 'unnamed blueprint, typed:maybe, prototype:false';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : _.maybe, prototype : false }),
    withConstructor : _.trait.withConstructor(),
    field1 : 'b1',
    field2 : 'b1',
    s1 : s( 'b1' ),
    s2 : s( 'b1' ),
  });
  test.true( Blueprint1.prototype === Blueprint1.Make.prototype );
  test.true( Blueprint1.constructor === undefined );
  test.identical( Blueprint1.Make.name, 'Construction' );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint1.Make();
  test.true( _.routineIs( instance1.constructor ) );
  test.identical( instance1.constructor.name, 'Construction' );

  test.identical( _.prototype.each( instance1 ).length, 1 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    constructor : instance1.constructor,
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );

  test.description = 'instance2'; /* */

  var instance2 = instance1.constructor();
  test.true( _.routineIs( instance2.constructor ) );
  test.identical( instance2.constructor.name, 'Construction' );

  test.identical( _.prototype.each( instance2 ).length, 1 );
  var exp =
  {
    constructor : instance2.constructor,
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance2 )[ 0 ] ), exp );

  /* */

  test.case = 'unnamed blueprint, typed:maybe, prototype:true';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : _.maybe, prototype : true }),
    withConstructor : _.trait.withConstructor(),
    field1 : 'b1',
    field2 : 'b1',
    s1 : s( 'b1' ),
    s2 : s( 'b1' ),
  });
  test.true( Blueprint1.prototype === Blueprint1.Make.prototype );
  test.true( Blueprint1.Make === Blueprint1.prototype.constructor );
  test.true( Blueprint1.constructor === undefined );
  test.identical( Blueprint1.Make.name, 'Construction' );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint1.Make();
  test.identical( instance1 instanceof Blueprint1.Make, true );
  test.true( _.routineIs( instance1.constructor ) );
  test.identical( instance1.constructor.name, 'Construction' );

  test.identical( _.prototype.each( instance1 ).length, 3 );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    'field1' : 'b1',
    'field2' : 'b1',
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( _.property.all( instance1 ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );

  test.description = 'instance2'; /* */

  var instance2 = instance1.constructor();
  test.identical( instance2 instanceof Blueprint1.Make, true );
  test.true( _.routineIs( instance2.constructor ) );
  test.identical( instance2.constructor.name, 'Construction' );

  test.identical( _.prototype.each( instance2 ).length, 3 );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    'field1' : 'b1',
    'field2' : 'b1',
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( _.property.all( instance2 ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance2 )[ 0 ] ), exp );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance2 )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance2 )[ 2 ] ), exp );

  /* */

  test.case = 'named blueprint, typed:maybe, prototype:true';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : _.maybe, prototype : true }),
    withConstructor : _.trait.withConstructor(),
    name : _.trait.name( 'Blueprint1X' ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : s( 'b1' ),
    s2 : s( 'b1' ),
  });

  test.true( Blueprint1.prototype === Blueprint1.Make.prototype );
  test.true( Blueprint1.Make === Blueprint1.prototype.constructor );
  test.true( Blueprint1.constructor === undefined );
  test.identical( Blueprint1.Make.name, 'Blueprint1X' );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint1.Make();
  test.identical( instance1 instanceof Blueprint1.Make, true );
  test.true( _.routineIs( instance1.constructor ) );
  test.identical( instance1.constructor.name, 'Blueprint1X' );

  test.identical( _.prototype.each( instance1 ).length, 3 );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    'field1' : 'b1',
    'field2' : 'b1',
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( _.property.all( instance1 ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );

  test.description = 'instance2'; /* */

  var instance2 = instance1.constructor();
  test.identical( instance2 instanceof Blueprint1.Make, true );
  test.true( _.routineIs( instance2.constructor ) );
  test.identical( instance2.constructor.name, 'Blueprint1X' );

  test.identical( _.prototype.each( instance2 ).length, 3 );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    'field1' : 'b1',
    'field2' : 'b1',
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( _.property.all( instance2 ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance2 )[ 0 ] ), exp );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance2 )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance2 )[ 2 ] ), exp );

  /* */

  test.case = 'inheritance, typed:1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    name : _.trait.name( 'Blueprint1X' ),
    field1 : 'b1',
    field2 : 'b1',
    s1 : s( 'b1' ),
    s2 : s( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    name : _.trait.name( 'Blueprint2X' ),
    field2 : 'b2',
    field3 : 'b2',
    s2 : s( 'b2' ),
    staticField3 : s( 'b2' ),
  });

  test.description = 'descriptor of Blueprint1.prototype.constructor';
  var got = Object.getOwnPropertyDescriptor( Blueprint1.prototype, 'constructor' );
  var exp =
  {
    value : Blueprint1.prototype.constructor,
    enumerable : false,
    configurable : false,
    writable : false,
  }
  test.identical( got, exp );

  test.description = 'descriptor of Blueprint2.prototype.constructor';
  var got = Object.getOwnPropertyDescriptor( Blueprint2.prototype, 'constructor' );
  var exp =
  {
    value : Blueprint2.prototype.constructor,
    enumerable : false,
    configurable : false,
    writable : false,
  }
  test.identical( got, exp );

  test.true( Blueprint2.prototype === Blueprint2.Make.prototype );
  test.true( Blueprint2.Make === Blueprint2.prototype.constructor );
  test.true( Blueprint2.constructor === undefined );
  test.identical( Blueprint2.Make.name, 'Blueprint2X' );

  test.description = 'instance1'; /* */

  var instance1 = Blueprint2.Make();
  test.identical( instance1 instanceof Blueprint2.Make, true );
  test.true( _.routineIs( instance1.constructor ) );
  test.identical( instance1.constructor.name, 'Blueprint2X' );

  test.identical( _.prototype.each( instance1 ).length, 4 );
  var exp =
  {
    constructor : Blueprint2.prototype.constructor,
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    's1' : 'b1',
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance1 ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    constructor : Blueprint2.prototype.constructor,
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance1 )[ 3 ] ), exp );

  test.description = 'instance2'; /* */

  var instance2 = instance1.constructor();
  test.identical( instance2 instanceof Blueprint2.Make, true );
  test.true( _.routineIs( instance2.constructor ) );
  test.identical( instance2.constructor.name, 'Blueprint2X' );

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance2 )[ 0 ] ), exp );
  var exp =
  {
    constructor : Blueprint2.prototype.constructor,
    's2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( propertyOwn( _.prototype.each( instance2 )[ 1 ] ), exp );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    's1' : 'b1',
    's2' : 'b1',
  }
  test.identical( propertyOwn( _.prototype.each( instance2 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( propertyOwn( _.prototype.each( instance2 )[ 3 ] ), exp );

  /* */

}

traitWithConstructorBasic.description =
`
- blueprint inheritance with trait make inheritance
`

//

function traitWithConstructorAmendConstruction( test )
{
  let context = this;
  let s = _.define.static;

  act({ amending : 'extend' });
  act({ amending : 'supplement' });

  function act( tops )
  {

    /* - */

    test.case = `method:${tops.amending}, pure map`;

    var extension = [ _.trait.withConstructor() ];
    var dstContainer = Object.create( null );

    _.construction[ tops.amending ]( dstContainer, extension );
    test.true( _.routineIs( dstContainer.constructor ) );
    test.identical( dstContainer.constructor.name, 'Construction' );

    test.identical( _.prototype.each( dstContainer ).length, 1 );
    var exp =
    {
      constructor : dstContainer.constructor,
    }
    test.identical( propertyOwn( _.property.all( dstContainer ) ), exp );

    /* */

    test.case = `method:${tops.amending}, pure map, typed:1`;

    var extension = [ _.trait.withConstructor(), _.trait.typed() ];
    var dstContainer = Object.create( null );

    _.construction[ tops.amending ]( dstContainer, extension );
    test.true( _.routineIs( dstContainer.constructor ) );
    test.identical( dstContainer.constructor.name, 'Construction' );

    test.identical( _.prototype.each( dstContainer ).length, 3 );
    var exp =
    {
      constructor : dstContainer.constructor,
    }
    test.identical( propertyOwn( _.property.all( dstContainer ) ), exp );

    /* */

    test.case = `method:${tops.amending}, pure map, replacing`;

    var extension = [ _.trait.withConstructor() ];
    var dstContainer = Object.create( null );
    dstContainer.constructor = constructor1;

    _.construction[ tops.amending ]( dstContainer, extension );
    test.true( _.routineIs( dstContainer.constructor ) );
    test.identical( dstContainer.constructor.name, tops.amending === 'extend' ? 'Construction' : 'constructor1' );

    test.identical( _.prototype.each( dstContainer ).length, 1 );
    var exp =
    {
      constructor : tops.amending === 'extend' ? dstContainer.constructor : constructor1,
    }
    test.identical( _.property.all( dstContainer ), exp );

    /* */

    test.case = `method:${tops.amending}, pure map, replacing, typed : 1`;

    var extension = [ _.trait.withConstructor(), _.trait.typed() ];
    var dstContainer = Object.create( null );
    dstContainer.constructor = constructor1;

    _.construction[ tops.amending ]( dstContainer, extension );
    test.true( _.routineIs( dstContainer.constructor ) );

    test.identical( _.prototype.each( dstContainer ).length, 3 );
    var exp =
    {
      constructor : constructor1,
    }
    test.identical( _.property.onlyOwn( _.prototype.each( dstContainer )[ 0 ], { onlyEnumerable : 0 } ), exp );
    var exp =
    {
      constructor : _.prototype.of( dstContainer ).constructor,
    }
    test.identical( _.property.onlyOwn( _.prototype.each( dstContainer )[ 1 ], { onlyEnumerable : 0 } ), exp );
    test.identical( _.prototype.of( dstContainer ).constructor.name, 'Construction' );

    /* - */

    test.case = `method:${tops.amending}, polluted map`;

    var extension = [ _.trait.withConstructor() ];
    var dstContainer = {};

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    test.true( _.routineIs( dstContainer.constructor ) );
    test.identical( dstContainer.constructor.name, 'Construction' );
    test.identical( _.prototype.each( dstContainer ).length, 2 );
    test.true( _.prototype.each( dstContainer )[ 1 ] === Object.prototype );
    var exp =
    {
      constructor : dstContainer.constructor,
    }
    test.identical( propertyOwn( _.property.all( dstContainer, { onlyOwn : 1 } ) ), exp );

    /* */

    test.case = `method:${tops.amending}, polluted map, typed:1`;

    var extension = [ _.trait.withConstructor(), _.trait.typed() ];
    var dstContainer = {};

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    test.true( _.routineIs( dstContainer.constructor ) );
    test.identical( dstContainer.constructor.name, 'Construction' );
    test.identical( _.prototype.each( dstContainer ).length, 3 );
    var exp =
    {
      constructor : dstContainer.constructor,
    }
    test.identical( propertyOwn( _.property.all( dstContainer ) ), exp );

    /* */

    test.case = `method:${tops.amending}, polluted map, replacing`;

    var extension = [ _.trait.withConstructor() ];
    var dstContainer = {};
    dstContainer.constructor = constructor1;

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    test.true( _.routineIs( dstContainer.constructor ) );
    test.identical( dstContainer.constructor.name, tops.amending === 'extend' ? 'Construction' : 'constructor1' );
    test.identical( _.prototype.each( dstContainer ).length, 2 );
    test.true( _.prototype.each( dstContainer )[ 1 ] === Object.prototype );
    var exp =
    {
      constructor : tops.amending === 'extend' ? dstContainer.constructor : constructor1,
    }
    test.identical( _.property.all( dstContainer, { onlyOwn : 1 } ), exp );

    /* */

    test.case = `method:${tops.amending}, polluted map, replacing, typed : 1`;

    var extension = [ _.trait.withConstructor(), _.trait.typed() ];
    var dstContainer = {};
    dstContainer.constructor = constructor1;

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    test.true( _.routineIs( dstContainer.constructor ) );
    test.identical( _.prototype.each( dstContainer ).length, 3 );
    var exp =
    {
      constructor : constructor1,
    }
    test.identical( _.property.onlyOwn( _.prototype.each( dstContainer )[ 0 ], { onlyEnumerable : 0 } ), exp );
    var exp =
    {
      constructor : _.prototype.of( dstContainer ).constructor,
    }
    test.identical( _.property.onlyOwn( _.prototype.each( dstContainer )[ 1 ], { onlyEnumerable : 0 } ), exp );
    test.identical( _.prototype.of( dstContainer ).constructor.name, 'Construction' );

    /* - */

    test.case = `method:${tops.amending}, object`;

    var extension = [ _.trait.withConstructor() ];
    var proto = {};
    var dstContainer = Object.create( proto );

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    test.true( _.routineIs( dstContainer.constructor ) );
    test.identical( dstContainer.constructor.name, 'Construction' );
    test.identical( _.prototype.each( dstContainer ).length, 3 );
    test.true( _.prototype.each( dstContainer )[ 1 ] === proto );
    test.true( _.prototype.each( dstContainer )[ 2 ] === Object.prototype );

    var exp =
    {
    }
    test.identical( propertyOwn( _.prototype.each( dstContainer )[ 0 ] ), exp );

    var exp =
    {
      constructor : dstContainer.constructor
    }
    test.identical( propertyOwn( _.prototype.each( dstContainer )[ 1 ] ), exp );

    /* */

    test.case = `method:${tops.amending}, object, typed:1`;

    var extension = [ _.trait.withConstructor(), _.trait.typed() ];
    var proto = {};
    var dstContainer = Object.create( proto );

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    test.true( _.routineIs( dstContainer.constructor ) );
    test.identical( dstContainer.constructor.name, 'Construction' );
    test.identical( _.prototype.each( dstContainer ).length, 3 );
    test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );

    var exp =
    {
    }
    test.identical( propertyOwn( _.prototype.each( dstContainer )[ 0 ] ), exp );

    var exp =
    {
      constructor : dstContainer.constructor
    }
    test.identical( propertyOwn( _.prototype.each( dstContainer )[ 1 ] ), exp );

    /* */

    test.case = `method:${tops.amending}, object with constructor in prototype`;

    var extension = [ _.trait.withConstructor() ];
    var proto = { constructor : constructor1 };
    var dstContainer = Object.create( proto );

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    test.true( _.routineIs( dstContainer.constructor ) );
    test.identical( _.prototype.each( dstContainer ).length, 3 );
    test.true( _.prototype.each( dstContainer )[ 1 ] === proto );
    test.true( _.prototype.each( dstContainer )[ 2 ] === Object.prototype );

    var exp =
    {
    }
    test.identical( propertyOwn( _.prototype.each( dstContainer )[ 0 ] ), exp );
    test.identical( _.prototype.each( dstContainer )[ 0 ].constructor.name, tops.amending === 'extend' ? 'Construction' : 'constructor1' );

    var exp =
    {
      constructor : dstContainer.constructor
    }
    test.identical( propertyOwn( _.prototype.each( dstContainer )[ 1 ] ), exp );
    test.identical( _.prototype.each( dstContainer )[ 1 ].constructor.name, tops.amending === 'extend' ? 'Construction' : 'constructor1' );

    /* */

    test.case = `method:${tops.amending}, object with constructor in prototype, typed`;

    var extension = [ _.trait.withConstructor(), _.trait.typed() ];
    var proto = { constructor : constructor1 };
    var dstContainer = Object.create( proto );

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    test.true( _.routineIs( dstContainer.constructor ) );
    test.identical( _.prototype.each( dstContainer ).length, 3 );
    test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );

    var exp =
    {
    }
    test.identical( propertyOwn( _.prototype.each( dstContainer )[ 0 ] ), exp );
    test.identical( _.prototype.each( dstContainer )[ 0 ].constructor.name, 'Construction' );

    var exp =
    {
      constructor : dstContainer.constructor
    }
    test.identical( propertyOwn( _.prototype.each( dstContainer )[ 1 ] ), exp );
    test.identical( _.prototype.each( dstContainer )[ 1 ].constructor.name, 'Construction' );

    /* */

    test.case = `method:${tops.amending}, object with constructor in instance`;

    var extension = [ _.trait.withConstructor() ];
    var proto = {};
    var dstContainer = Object.create( proto );
    dstContainer.constructor = constructor1;

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    test.true( _.routineIs( dstContainer.constructor ) );
    test.identical( _.prototype.each( dstContainer ).length, 3 );
    test.true( _.prototype.each( dstContainer )[ 1 ] === proto );
    test.true( _.prototype.each( dstContainer )[ 2 ] === Object.prototype );

    var exp =
    {
      constructor : dstContainer.constructor,
    }
    test.identical( propertyOwn( _.prototype.each( dstContainer )[ 0 ] ), exp );
    test.identical( _.prototype.each( dstContainer )[ 0 ].constructor.name, 'constructor1' );

    var exp =
    {
      constructor : _.prototype.each( dstContainer )[ 1 ].constructor,
    }
    test.identical( propertyOwn( _.prototype.each( dstContainer )[ 1 ] ), exp );
    test.identical( _.prototype.each( dstContainer )[ 1 ].constructor.name, 'Construction' );

    /* */

    test.case = `method:${tops.amending}, object with constructor in instance`;

    var extension = [ _.trait.withConstructor(), _.trait.typed() ];
    var proto = {};
    var dstContainer = Object.create( proto );
    dstContainer.constructor = constructor1;

    var keysBefore = _.mapAllKeys( Object.prototype );
    _.construction[ tops.amending ]( dstContainer, extension );
    var keysAfter = _.mapAllKeys( Object.prototype );
    test.identical( keysAfter, keysBefore );

    test.true( _.routineIs( dstContainer.constructor ) );
    test.identical( _.prototype.each( dstContainer ).length, 3 );
    test.true( _.prototype.each( dstContainer )[ 1 ] !== proto );
    test.true( _.prototype.each( dstContainer )[ 2 ] === _.Construction.prototype );

    var exp =
    {
      constructor : dstContainer.constructor,
    }
    test.identical( propertyOwn( _.prototype.each( dstContainer )[ 0 ] ), exp );
    test.identical( _.prototype.each( dstContainer )[ 0 ].constructor.name, 'constructor1' );

    var exp =
    {
      constructor : _.prototype.each( dstContainer )[ 1 ].constructor,
    }
    test.identical( propertyOwn( _.prototype.each( dstContainer )[ 1 ] ), exp );
    test.identical( _.prototype.each( dstContainer )[ 1 ].constructor.name, 'Construction' );

    /* */

  }

  function constructor1(){}

}

//

function traitWithConstructorAmendConstructionAlternatives( test )
{
  let context = this;
  let s = _.define.static;

  act({ amending : 'extend' });
  act({ amending : 'supplement' });

  function act( tops )
  {

    /* */

    test.case = `method:${tops.amending}, pure map by definition`;

    var extension = _.trait.withConstructor();
    var dstContainer = Object.create( null );

    _.construction[ tops.amending ]( dstContainer, extension ),

    test.true( _.routineIs( dstContainer.constructor ) );
    test.identical( dstContainer.constructor.name, 'Construction' );
    test.identical( _.prototype.each( dstContainer ).length, 1 );
    var exp =
    {
      constructor : dstContainer.constructor,
    }
    test.identical( propertyOwn( _.prototype.each( dstContainer )[ 0 ] ), exp );

    /* */

    test.case = `method:${tops.amending}, pure map by map of definition`;

    var extension =
    ({
      withConstructor : _.trait.withConstructor(),
    });
    var dstContainer = Object.create( null );

    _.construction[ tops.amending ]( dstContainer, extension );
    test.true( _.routineIs( dstContainer.constructor ) );
    test.identical( dstContainer.constructor.name, 'Construction' );

    test.identical( _.prototype.each( dstContainer ).length, 1 );
    var exp =
    {
      constructor : dstContainer.constructor,
    }
    test.identical( propertyOwn( _.property.all( dstContainer ) ), exp );

    /* */

    test.case = `method:${tops.amending}, typed:1, pure map by map of definition`;

    var extension =
    ({
      withConstructor : _.trait.withConstructor(),
      typed : _.trait.typed(),
    });
    var dstContainer = Object.create( null );

    _.construction[ tops.amending ]( dstContainer, extension );
    test.true( _.routineIs( dstContainer.constructor ) );
    test.identical( dstContainer.constructor.name, 'Construction' );

    test.identical( _.prototype.each( dstContainer ).length, 3 );
    var exp =
    {
      constructor : dstContainer.constructor,
    }
    test.identical( propertyOwn( _.property.all( dstContainer ) ), exp );

    /* */

    test.case = `method:${tops.amending}, pure map by array of definition`;

    var extension = [ _.trait.withConstructor() ];
    var dstContainer = Object.create( null );

    _.construction[ tops.amending ]( dstContainer, extension );
    test.true( _.routineIs( dstContainer.constructor ) );
    test.identical( dstContainer.constructor.name, 'Construction' );

    test.identical( _.prototype.each( dstContainer ).length, 1 );
    var exp =
    {
      constructor : dstContainer.constructor,
    }
    test.identical( propertyOwn( _.property.all( dstContainer ) ), exp );

    /* */

    test.case = `method:${tops.amending}, typed:1, pure map by array of definition`;

    var extension = [ _.trait.withConstructor(), _.trait.typed() ];
    var dstContainer = Object.create( null );

    _.construction[ tops.amending ]( dstContainer, extension );
    test.true( _.routineIs( dstContainer.constructor ) );
    test.identical( dstContainer.constructor.name, 'Construction' );

    test.identical( _.prototype.each( dstContainer ).length, 3 );
    var exp =
    {
      constructor : dstContainer.constructor,
    }
    test.identical( propertyOwn( _.property.all( dstContainer ) ), exp );

    /* */

  }

  function constructor1(){}

}

//

function traitWithConstructorTraitPrototypeTraitTyped( test )
{

  act({ order : [ 'withConstructor', 'typed' ] });
  act({ order : [ 'typed', 'withConstructor' ] });

  function act( tops )
  {

    _.assert( _.arraySetIdentical( tops.order, [ 'withConstructor', 'typed' ] ) );

    /* */

    test.case = `typed:maybe, prototype:explicit, withConstructor:1, order:( ${tops.order.join( ' ' )} )`;

    var amending = 'extend';
    var prototype = Object.create( null );
    prototype.constructor = constructor1;
    var construction = Object.create( prototype );
    var args = [];
    tops.order.forEach( ( name ) => traitAdd( args, name, prototype ) );

    var blueprint = _.blueprint._define({ src : args, amending });

    _.construction._init
    ({
      constructing : false,
      construction,
      amending,
      runtime : blueprint.Runtime,
    });

    test.identical( _.prototype.each( construction ).length, 2 );
    test.identical( construction.constructor.name, 'Construction' );

    var exp =
    {
    }
    test.identical( propertyOwn( _.prototype.each( construction )[ 0 ] ), exp );
    var exp =
    {
      constructor : construction.constructor,
    }
    test.identical( propertyOwn( _.prototype.each( construction )[ 1 ] ), exp );

  }

  /* */

  function traitAdd( args, name, prototype )
  {
    if( name === 'withConstructor' )
    args.push( _.trait.withConstructor( 1 ) );
    else if( name === 'typed' )
    args.push( _.trait.typed({ val : _.maybe, prototype, new : false }) );
    else _.assert( 0 );
  }

  /* */

  function constructor1()
  {
  }

  /* */

  function constructor2()
  {
  }

  /* */

}

traitWithConstructorTraitPrototypeTraitTyped.description =
`
  - mixing of traits::withConstructor, trait::typed and option::prototype
  -- does not throw error
  -- order does not matter
`

//

function traitExtendable( test )
{

  /* */

  test.case = 'not extendable, implicit';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
  });
  var instance = _.blueprint.construct( Blueprint );

  test.description = 'write';
  test.shouldThrowErrorSync( () => instance.field2 = null );

  test.description = 'read';
  var got = instance.field2;
  test.identical( got, undefined );

  /* */

  test.case = 'not extendable, explicit';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    extendable : _.trait.extendable( false ),
  });
  var instance = _.blueprint.construct( Blueprint );

  test.description = 'write';
  test.shouldThrowErrorSync( () => instance.field2 = null );

  test.description = 'read';
  var got = instance.field2;
  test.identical( got, undefined );

  /* */

  test.case = 'extendable';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    extendable : _.trait.extendable( true ),
  });
  var instance = _.blueprint.construct( Blueprint );

  test.description = 'write';
  instance.field2 = null;

  test.description = 'read';
  var got = instance.field2;
  test.identical( got, null );

  /* */

  test.case = 'extendable, implicit argument';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    extendable : _.trait.extendable(),
  });
  var instance = _.blueprint.construct( Blueprint );

  test.description = 'write';
  instance.field2 = null;

  test.description = 'read';
  var got = instance.field2;
  test.identical( got, null );

  /* */

  function rfield( arg )
  {
    return 'x' + arg;
  }

}

traitExtendable.description =
`
- blueprint without trait extandable is not extenable
- blueprint with trait extandable with argument false is not extenable
- blueprint with trait extandable is extenable
- blueprint with trait extandable without argument is extenable
`

//

function traitExtendableAmendConstruction( test )
{

  eachCase({ amending : 'extend' });
  eachCase({ amending : 'supplement' });

  /* - */

  function eachCase( tops )
  {

    /* */

    test.case = `amending : ${_.toStr( tops.amending )}, pure map, extendable : 1`;

    var amendation = _.trait.extendable( 1 );
    var dstConstruction = Object.create( null );
    _.construction[ tops.amending ]( dstConstruction, amendation );
    dstConstruction.a = 2;
    var exp =
    {
      a : 2,
    }
    test.identical( dstConstruction, exp );

    /* */

    test.case = `amending : ${_.toStr( tops.amending )}, pure map, extendable : 0`;

    var amendation = _.trait.extendable( 0 );
    var dstConstruction = Object.create( null );
    _.construction[ tops.amending ]( dstConstruction, amendation );
    test.shouldThrowErrorSync( () => dstConstruction.a = 2 );
    var exp =
    {
    }
    test.identical( dstConstruction, exp );

    /* */

    test.case = `amending : ${_.toStr( tops.amending )}, polluted map, extendable : 1`;

    var amendation = _.trait.extendable( 1 );
    var dstConstruction = {};
    _.construction[ tops.amending ]( dstConstruction, amendation );
    dstConstruction.a = 2;
    var exp =
    {
      a : 2,
    }
    test.identical( dstConstruction, exp );

    /* */

    test.case = `amending : ${_.toStr( tops.amending )}, polluted map, extendable : 0`;

    var amendation = _.trait.extendable( 0 );
    var dstConstruction = {};
    _.construction[ tops.amending ]( dstConstruction, amendation );
    test.shouldThrowErrorSync( () => dstConstruction.a = 2 );
    var exp =
    {
    }
    test.identical( dstConstruction, exp );

    /* */

    test.case = `amending : ${_.toStr( tops.amending )}, object, extendable : 1`;

    var amendation = _.trait.extendable( 1 );
    var prototype = Object.create( null );
    var dstConstruction = Object.create( prototype );
    _.construction[ tops.amending ]( dstConstruction, amendation );
    dstConstruction.a = 2;
    var exp =
    {
      a : 2,
    }
    test.identical( _.property.all( dstConstruction ), exp );

    /* */

    test.case = `amending : ${_.toStr( tops.amending )}, object, extendable : 0`;

    var amendation = _.trait.extendable( 0 );
    var prototype = Object.create( null );
    var dstConstruction = Object.create( prototype );
    _.construction[ tops.amending ]( dstConstruction, amendation );
    test.shouldThrowErrorSync( () => dstConstruction.a = 2 );
    var exp =
    {
    }
    test.identical( _.property.all( dstConstruction ), exp );

    prototype.a = 2;
    var exp =
    {
      a : 2,
    }
    test.identical( _.property.all( dstConstruction ), exp );

    /* */

  }

}

traitExtendableAmendConstruction.description =
`
- Amend construction with trait::extendable
`

//

// function traitCallable( test )
// {
//
//   function _getter( arg )
//   {
//     return 'x' + arg;
//   }
//
//   var Blueprint1 = _.Blueprint
//   ({
//     functor : null,
//     '__call__' : _.define.ownerCallback( 'functor' ),
//   });
//
//   var instance = _.blueprint.construct( Blueprint1 );
//   instance.functor = _getter;
//
//   var prototypes = _.prototype.each( _.Blueprint );
//   test.identical( prototypes.length, 1 );
//   test.true( prototypes[ 0 ] === _.Blueprint );
//   var prototypes = _.prototype.each( Blueprint1 );
//   test.identical( prototypes.length, 2 );
//   test.true( prototypes[ 0 ] === Blueprint1 );
//   test.true( prototypes[ 1 ] === _.Blueprint );
//   var prototypes = _.prototype.each( instance );
//   test.identical( prototypes.length, 3 );
//   test.true( prototypes[ 0 ] === instance );
//   test.true( prototypes[ 1 ] === Blueprint1 );
//   test.true( prototypes[ 2 ] === _.Blueprint );
//
//   test.true( _.prototype.hasPrototype( instance, Blueprint1 ) );
//   test.true( _.routineIs( instance ) );
//   // test.identical( _.mapKeys( instance ), [ 'functor' ] );
//   // test.identical( _.mapAllKeys( instance ), [ 'functor' ] );
//
//   var got = instance( '+y' );
//   test.identical( got, 'x+y' );
//
// }

// --
// construct / define
// --

function constructWithoutHelper( test )
{

  function rfield( arg )
  {
    return 'x' + arg;
  }

  /* */

  test.case = 'without new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var instance = Blueprint.Make();

  test.identical( _.blueprint.isDefinitive( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), _.maybe );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), _.maybe );

  // test.identical( instance instanceof Blueprint.Make, false );
  test.identical( Object.getPrototypeOf( instance ), null );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 1 );
  test.true( prototypes[ 0 ] === instance );
  test.true( !_.prototype.hasPrototype( instance, Blueprint ) );
  test.true( _.objectIs( instance ) );
  test.true( _.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

  test.case = 'without new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var instance = Blueprint.Make();

  test.identical( _.blueprint.isDefinitive( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), true );

  test.identical( instance instanceof Blueprint.Make, true );
  test.identical( Object.getPrototypeOf( Object.getPrototypeOf( instance ) ), _.Construction.prototype );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === instance );
  test.true( prototypes[ 1 ] === Blueprint.Make.prototype );
  test.true( prototypes[ 2 ] === _.Construction.prototype );
  test.true( _.prototype.hasPrototype( instance, instance ) );
  test.true( _.prototype.hasPrototype( instance, Blueprint.Make.prototype ) );
  test.true( _.prototype.hasPrototype( instance, _.Construction.prototype ) );
  test.true( _.objectIs( instance ) );
  test.true( !_.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

  test.case = 'with new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var instance = new Blueprint.Make();

  test.identical( _.blueprint.isDefinitive( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), _.maybe );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), _.maybe );

  test.identical( Object.getPrototypeOf( instance ), null );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 1 );
  test.true( prototypes[ 0 ] === instance );
  test.true( !_.prototype.hasPrototype( instance, Blueprint ) );
  test.true( _.objectIs( instance ) );
  test.true( _.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

  test.case = 'with new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var instance = new Blueprint.Make();

  test.identical( _.blueprint.isDefinitive( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), true );

  test.identical( instance instanceof Blueprint.Make, true );
  test.identical( Object.getPrototypeOf( Object.getPrototypeOf( instance ) ), _.Construction.prototype );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === instance );
  test.true( prototypes[ 1 ] === Blueprint.Make.prototype );
  test.true( prototypes[ 2 ] === _.Construction.prototype );
  test.true( _.prototype.hasPrototype( instance, instance ) );
  test.true( _.prototype.hasPrototype( instance, Blueprint.Make.prototype ) );
  test.true( _.prototype.hasPrototype( instance, _.Construction.prototype ) );
  test.true( _.objectIs( instance ) );
  test.true( !_.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

}

constructWithoutHelper.description =
`
- construction without the helper _.blueprint.construct produce the same result as with the helper
- directive has no impact
`

//

function constructWithArgumentMap( test )
{

  function rfield( arg )
  {
    return 'x' + arg;
  }

  /* */

  test.case = 'without new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var opts = { field1 : 13 };
  var instance = Blueprint.Make( opts );

  test.true( instance !== opts );
  var exp = { field1 : 13 }
  test.identical( instance, exp );

  test.identical( _.blueprint.isDefinitive( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), _.maybe );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), _.maybe );

  // test.identical( instance instanceof Blueprint.Make, false );
  test.identical( Object.getPrototypeOf( instance ), null );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 1 );
  test.true( prototypes[ 0 ] === instance );
  test.true( !_.prototype.hasPrototype( instance, Blueprint ) );
  test.true( _.objectIs( instance ) );
  test.true( _.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

  test.case = 'without new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var opts = { field1 : 13 };

  var instance = Blueprint.Make( opts );

  test.true( instance !== opts );
  var exp = { field1 : 13 }
  test.containsAll( instance, exp );

  test.identical( _.blueprint.isDefinitive( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), true );

  test.identical( instance instanceof Blueprint.Make, true );
  test.identical( Object.getPrototypeOf( Object.getPrototypeOf( instance ) ), _.Construction.prototype );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === instance );
  test.true( prototypes[ 1 ] === Blueprint.Make.prototype );
  test.true( prototypes[ 2 ] === _.Construction.prototype );
  test.true( _.prototype.hasPrototype( instance, instance ) );
  test.true( _.prototype.hasPrototype( instance, Blueprint.Make.prototype ) );
  test.true( _.prototype.hasPrototype( instance, _.Construction.prototype ) );
  test.true( _.objectIs( instance ) );
  test.true( !_.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

  test.case = 'with new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var opts = { field1 : 13 };
  var instance = new Blueprint.Make( opts );

  test.true( instance !== opts );
  var exp = { field1 : 13 }
  test.identical( instance, exp );

  test.identical( _.blueprint.isDefinitive( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), _.maybe );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), _.maybe );

  // test.identical( instance instanceof Blueprint.Make, false );
  test.identical( Object.getPrototypeOf( instance ), null );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 1 );
  test.true( prototypes[ 0 ] === instance );
  test.true( !_.prototype.hasPrototype( instance, Blueprint ) );
  test.true( _.objectIs( instance ) );
  test.true( _.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

  test.case = 'with new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var opts = { field1 : 13 };
  var instance = new Blueprint.Make( opts );

  test.true( instance !== opts );
  var exp = { field1 : 13 }
  test.containsOnly( instance, exp );

  test.identical( _.blueprint.isDefinitive( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), true );

  test.identical( instance instanceof Blueprint.Make, true );
  test.identical( Object.getPrototypeOf( Object.getPrototypeOf( instance ) ), _.Construction.prototype );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === instance );
  test.true( prototypes[ 1 ] === Blueprint.Make.prototype );
  test.true( prototypes[ 2 ] === _.Construction.prototype );
  test.true( _.prototype.hasPrototype( instance, instance ) );
  test.true( _.prototype.hasPrototype( instance, Blueprint.Make.prototype ) );
  test.true( _.prototype.hasPrototype( instance, _.Construction.prototype ) );
  test.true( _.objectIs( instance ) );
  test.true( !_.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

}

constructWithArgumentMap.description =
`
- construction without the helper _.blueprint.construct and with argument produces construction
- construction with argument takes into account argument
- directive new constructs a new structure even if argument has proper type, duplicating it
`

//

function constructWithArgumentMapUndeclaredFields( test )
{

  function rfield( arg )
  {
    return 'x' + arg;
  }

  /* */

  test.case = 'extendable:1, without new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
    extendable : _.trait.extendable(),
  });
  var opts = { fieldBad : 13 };
  var instance = Blueprint.Make( opts );

  test.true( instance !== opts );
  var exp = { field1 : rfield, fieldBad : 13 }
  test.identical( instance, exp );
  // test.identical( instance instanceof Blueprint.Make, false );

  /* */

  test.case = 'extendable:1, without new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
    extendable : _.trait.extendable(),
  });
  var opts = { fieldBad : 13 };
  var instance = Blueprint.Make( opts );

  test.true( instance !== opts );
  var exp = { field1 : rfield, fieldBad : 13 }
  test.containsOnly( instance, exp );
  test.identical( instance instanceof Blueprint.Make, true );

  /* */

  test.case = 'extendable:1, with new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
    extendable : _.trait.extendable(),
  });
  var opts = { fieldBad : 13 };
  var instance = new Blueprint.Make( opts );

  test.true( instance !== opts );
  var exp = { field1 : rfield, fieldBad : 13 }
  test.identical( instance, exp );
  // test.identical( instance instanceof Blueprint.Make, false );

  /* */

  test.case = 'extendable:1, with new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
    extendable : _.trait.extendable(),
  });
  var opts = { fieldBad : 13 };
  var instance = new Blueprint.Make( opts );

  test.true( instance !== opts );
  var exp = { field1 : rfield, fieldBad : 13 }
  test.containsOnly( instance, exp );
  test.identical( instance instanceof Blueprint.Make, true );

  /* */

  test.case = 'extendable:0, without new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
    extendable : _.trait.extendable( false ),
  });
  var opts = { fieldBad : 13 };
  test.shouldThrowErrorSync( () => Blueprint.Make( opts ) );

  /* */

  test.case = 'extendable:0, without new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
    extendable : _.trait.extendable( false ),
  });
  var opts = { fieldBad : 13 };
  test.shouldThrowErrorSync( () => Blueprint.Make( opts ) );

  /* */

  test.case = 'extendable:0, with new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
    extendable : _.trait.extendable( false ),
  });
  var opts = { fieldBad : 13 };
  test.shouldThrowErrorSync( () => new Blueprint.Make( opts ) );

  /* */

  test.case = 'extendable:0, with new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
    extendable : _.trait.extendable( false ),
  });
  var opts = { fieldBad : 13 };
  test.shouldThrowErrorSync( () => new Blueprint.Make( opts ) );

  /* */

}

constructWithArgumentMapUndeclaredFields.description =
`
- if extandable:1 then undeclared fields of argument should throw no error
- if extandable:1 then undeclared fields of argument should extend construction
- if extandable:0 then undeclared fields of argument should throw error
- if extandable:0 then undeclared fields of argument should not extend construction
`

//

function constructWithArgumentInstance( test )
{

  function rfield( arg )
  {
    return 'x' + arg;
  }

  /* */

  test.case = 'without new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var opts = { field1 : 13 };
  var instance1 = Blueprint.Make( opts );
  var instance2 = Blueprint.Make( instance1 );

  test.true( instance1 !== opts );
  test.true( instance2 !== opts );
  test.true( instance1 !== instance2 );
  var exp = { field1 : 13 }
  test.containsOnly( instance2, exp );

  test.identical( _.blueprint.isDefinitive( Blueprint ), true );
  test.identical( _.construction.isTyped( instance2 ), false );
  test.identical( _.construction.isInstanceOf( instance2, Blueprint ), _.maybe );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance2 ), _.maybe );

  // test.identical( instance2 instanceof Blueprint.Make, false );
  test.identical( Object.getPrototypeOf( instance2 ), null );
  test.identical( instance2.constructor, undefined );
  var prototypes = _.prototype.each( instance2 );
  test.identical( prototypes.length, 1 );
  test.true( prototypes[ 0 ] === instance2 );
  test.true( !_.prototype.hasPrototype( instance2, Blueprint ) );
  test.true( _.objectIs( instance2 ) );
  test.true( _.mapIs( instance2 ) );
  test.true( _.mapLike( instance2 ) );
  test.true( !_.instanceIs( instance2 ) );
  test.identical( _.mapKeys( instance2 ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance2 ), [ 'field1' ] );

  /* */

  test.case = 'without new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var opts = { field1 : 13 };
  var instance1 = Blueprint.Make( opts );
  var instance2 = Blueprint.Make( instance1 );
  var instance3 = Blueprint.From( instance1 );

  test.true( instance1 !== opts );
  test.true( instance2 !== opts );
  test.true( instance1 !== instance2 );
  test.true( instance1 === instance3 );
  var exp = { field1 : 13 }
  test.containsOnly( instance2, exp );

  test.identical( _.blueprint.isDefinitive( Blueprint ), true );
  test.identical( _.construction.isTyped( instance2 ), true );
  test.identical( _.construction.isInstanceOf( instance2, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance2 ), true );

  test.identical( instance2 instanceof Blueprint.Make, true );
  test.identical( Object.getPrototypeOf( Object.getPrototypeOf( instance2 ) ), _.Construction.prototype );
  test.identical( instance2.constructor, undefined );
  var prototypes = _.prototype.each( instance2 );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === instance2 );
  test.true( prototypes[ 1 ] === Blueprint.Make.prototype );
  test.true( prototypes[ 2 ] === _.Construction.prototype );
  test.true( _.prototype.hasPrototype( instance2, instance2 ) );
  test.true( _.prototype.hasPrototype( instance2, Blueprint.Make.prototype ) );
  test.true( _.prototype.hasPrototype( instance2, _.Construction.prototype ) );
  test.true( _.objectIs( instance2 ) );
  test.true( !_.mapIs( instance2 ) );
  test.true( _.mapLike( instance2 ) );
  test.true( !_.instanceIs( instance2 ) );
  test.identical( _.mapKeys( instance2 ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance2 ), [ 'field1' ] );

  /* */

  test.case = 'with new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var opts = { field1 : 13 };
  var instance1 = new Blueprint.Make( opts );
  var instance2 = new Blueprint.Make( instance1 );

  test.true( instance1 !== opts );
  test.true( instance2 !== opts );
  test.true( instance1 !== instance2 );
  var exp = { field1 : 13 }
  test.containsOnly( instance2, exp );

  test.identical( _.blueprint.isDefinitive( Blueprint ), true );
  test.identical( _.construction.isTyped( instance2 ), false );
  test.identical( _.construction.isInstanceOf( instance2, Blueprint ), _.maybe );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance2 ), _.maybe );

  // test.identical( instance2 instanceof Blueprint.Make, false );
  test.identical( Object.getPrototypeOf( instance2 ), null );
  test.identical( instance2.constructor, undefined );
  var prototypes = _.prototype.each( instance2 );
  test.identical( prototypes.length, 1 );
  test.true( prototypes[ 0 ] === instance2 );
  test.true( !_.prototype.hasPrototype( instance2, Blueprint ) );
  test.true( _.objectIs( instance2 ) );
  test.true( _.mapIs( instance2 ) );
  test.true( _.mapLike( instance2 ) );
  test.true( !_.instanceIs( instance2 ) );
  test.identical( _.mapKeys( instance2 ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance2 ), [ 'field1' ] );

  /* */

  test.case = 'with new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var opts = { field1 : 13 };
  var instance1 = new Blueprint.Make( opts );
  var instance2 = new Blueprint.Make( instance1 );

  test.true( instance1 !== opts );
  test.true( instance2 !== opts );
  test.true( instance1 !== instance2 );
  var exp = { field1 : 13 }
  test.containsOnly( instance2, exp );

  test.identical( _.blueprint.isDefinitive( Blueprint ), true );
  test.identical( _.construction.isTyped( instance2 ), true );
  test.identical( _.construction.isInstanceOf( instance2, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance2 ), true );

  test.identical( instance2 instanceof Blueprint.Make, true );
  test.identical( Object.getPrototypeOf( Object.getPrototypeOf( instance2 ) ), _.Construction.prototype );
  test.identical( instance2.constructor, undefined );
  var prototypes = _.prototype.each( instance2 );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === instance2 );
  test.true( prototypes[ 1 ] === Blueprint.Make.prototype );
  test.true( prototypes[ 2 ] === _.Construction.prototype );
  test.true( _.prototype.hasPrototype( instance2, instance2 ) );
  test.true( _.prototype.hasPrototype( instance2, Blueprint.Make.prototype ) );
  test.true( _.prototype.hasPrototype( instance2, _.Construction.prototype ) );
  test.true( _.objectIs( instance2 ) );
  test.true( !_.mapIs( instance2 ) );
  test.true( _.mapLike( instance2 ) );
  test.true( !_.instanceIs( instance2 ) );
  test.identical( _.mapKeys( instance2 ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance2 ), [ 'field1' ] );

  /* */

}

constructWithArgumentInstance.description =
`
- no new + untyped instance -> make a new instance
- no new + typed instance -> reutrns that instance
- new + untyped instance -> make a new instance
- new + typed instance -> make a new instance
`

//

function makeEachBasic( test )
{

  function rfield( arg )
  {
    return 'x' + arg;
  }

  /* */

  test.case = 'without new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var args = [ { field1 : 1 }, new Blueprint.Make({ field1 : 2 }), Blueprint.Make() ];
  var instances = Blueprint.MakeEach( ... args );

  test.true( instances !== args );
  test.true( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.containsOnly( instances[ 0 ], exp );
  // test.identical( instances[ 0 ] instanceof Blueprint.Make, false );
  test.true( instances[ 0 ] !== args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  // test.identical( instances[ 1 ] instanceof Blueprint.Make, false );
  test.true( instances[ 1 ] !== args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  // test.identical( instances[ 2 ] instanceof Blueprint.Make, false );
  test.true( instances[ 2 ] !== args[ 2 ] );

  /* */

  test.case = 'without new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var args = [ { field1 : 1 }, new Blueprint.Make({ field1 : 2 }), Blueprint.Make() ];
  var instances = Blueprint.MakeEach( ... args );

  test.true( instances !== args );
  test.true( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.containsOnly( instances[ 0 ], exp );
  test.identical( instances[ 0 ] instanceof Blueprint.Make, true );
  test.true( instances[ 0 ] !== args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.Make, true );
  test.true( instances[ 1 ] !== args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.Make, true );
  test.true( instances[ 2 ] !== args[ 2 ] );

  /* */

  test.case = 'with new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var args = [ { field1 : 1 }, new Blueprint.Make({ field1 : 2 }), Blueprint.Make() ];
  var instances = new Blueprint.MakeEach( ... args );

  test.true( instances !== args );
  test.true( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.containsOnly( instances[ 0 ], exp );
  // test.identical( instances[ 0 ] instanceof Blueprint.Make, false );
  test.true( instances[ 0 ] !== args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  // test.identical( instances[ 1 ] instanceof Blueprint.Make, false );
  test.true( instances[ 1 ] !== args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  // test.identical( instances[ 2 ] instanceof Blueprint.Make, false );
  test.true( instances[ 2 ] !== args[ 2 ] );

  /* */

  test.case = 'with new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var args = [ { field1 : 1 }, new Blueprint.Make({ field1 : 2 }), Blueprint.Make() ];
  var instances = new Blueprint.MakeEach( ... args );

  test.true( instances !== args );
  test.true( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.containsOnly( instances[ 0 ], exp );
  test.identical( instances[ 0 ] instanceof Blueprint.Make, true );
  test.true( instances[ 0 ] !== args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.Make, true );
  test.true( instances[ 1 ] !== args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.Make, true );
  test.true( instances[ 2 ] !== args[ 2 ] );

  /* */

}

makeEachBasic.description =
`
- MakeEach with several argument produce array with instances
- new instance is created if instance passed
`

//

function fromEachBasic( test )
{

  function rfield( arg )
  {
    return 'x' + arg;
  }

  /* */

  test.case = 'without new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var args = [ { field1 : 1 }, new Blueprint.Make({ field1 : 2 }), Blueprint.Make() ];
  var instances = Blueprint.FromEach( ... args );

  test.true( instances !== args );
  test.true( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.containsOnly( instances[ 0 ], exp );
  // test.identical( instances[ 0 ] instanceof Blueprint.Make, false );
  test.true( instances[ 0 ] === args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  // test.identical( instances[ 1 ] instanceof Blueprint.Make, false );
  test.true( instances[ 1 ] === args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  // test.identical( instances[ 2 ] instanceof Blueprint.Make, false );
  test.true( instances[ 2 ] === args[ 2 ] );

  /* */

  test.case = 'without new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var args = [ { field1 : 1 }, new Blueprint.Make({ field1 : 2 }), Blueprint.Make() ];
  var instances = Blueprint.FromEach( ... args );

  test.true( instances !== args );
  test.true( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.containsOnly( instances[ 0 ], exp );
  test.identical( instances[ 0 ] instanceof Blueprint.Make, true );
  test.true( instances[ 0 ] !== args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.Make, true );
  test.true( instances[ 1 ] === args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.Make, true );
  test.true( instances[ 2 ] === args[ 2 ] );

  /* */

  test.case = 'with new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var args = [ { field1 : 1 }, new Blueprint.Make({ field1 : 2 }), Blueprint.Make() ];
  var instances = new Blueprint.FromEach( ... args );

  test.true( instances !== args );
  test.true( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.containsOnly( instances[ 0 ], exp );
  // test.identical( instances[ 0 ] instanceof Blueprint.Make, false );
  test.true( instances[ 0 ] === args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  // test.identical( instances[ 1 ] instanceof Blueprint.Make, false );
  test.true( instances[ 1 ] === args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  // test.identical( instances[ 2 ] instanceof Blueprint.Make, false );
  test.true( instances[ 2 ] === args[ 2 ] );

  /* */

  test.case = 'with new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var args = [ { field1 : 1 }, new Blueprint.Make({ field1 : 2 }), Blueprint.Make() ];
  var instances = new Blueprint.FromEach( ... args );

  test.true( instances !== args );
  test.true( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.containsOnly( instances[ 0 ], exp );
  test.identical( instances[ 0 ] instanceof Blueprint.Make, true );
  test.true( instances[ 0 ] !== args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.Make, true );
  test.true( instances[ 1 ] === args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.Make, true );
  test.true( instances[ 2 ] === args[ 2 ] );

  /* */

}

fromEachBasic.description =
`
- FromEach with several argument produce array with instances
- new instance is not created if instance passed
`

//

function retypeEachBasic( test )
{

  function rfield( arg )
  {
    return 'x' + arg;
  }

  /* */

  test.case = 'without new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var args = [ { field1 : 1 }, new Blueprint.Make({ field1 : 2 }), Blueprint.Make() ];
  var instances = Blueprint.RetypeEach( ... args );

  test.true( instances !== args );
  test.true( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.containsOnly( instances[ 0 ], exp );
  // test.identical( instances[ 0 ] instanceof Blueprint.Make, false );
  test.true( instances[ 0 ] === args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  // test.identical( instances[ 1 ] instanceof Blueprint.Make, false );
  test.true( instances[ 1 ] === args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  // test.identical( instances[ 2 ] instanceof Blueprint.Make, false );
  test.true( instances[ 2 ] === args[ 2 ] );

  /* */

  test.case = 'without new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var args = [ { field1 : 1 }, new Blueprint.Make({ field1 : 2 }), Blueprint.Make() ];
  var instances = Blueprint.RetypeEach( ... args );

  test.true( instances !== args );
  test.true( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.containsOnly( instances[ 0 ], exp );
  test.identical( instances[ 0 ] instanceof Blueprint.Make, true );
  test.true( instances[ 0 ] === args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.Make, true );
  test.true( instances[ 1 ] === args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.Make, true );
  test.true( instances[ 2 ] === args[ 2 ] );

  /* */

  test.case = 'with new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var args = [ { field1 : 1 }, new Blueprint.Make({ field1 : 2 }), Blueprint.Make() ];
  var instances = new Blueprint.RetypeEach( ... args );

  test.true( instances !== args );
  test.true( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.containsOnly( instances[ 0 ], exp );
  // test.identical( instances[ 0 ] instanceof Blueprint.Make, false );
  test.true( instances[ 0 ] === args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  // test.identical( instances[ 1 ] instanceof Blueprint.Make, false );
  test.true( instances[ 1 ] === args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  // test.identical( instances[ 2 ] instanceof Blueprint.Make, false );
  test.true( instances[ 2 ] === args[ 2 ] );

  /* */

  test.case = 'with new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var args = [ { field1 : 1 }, new Blueprint.Make({ field1 : 2 }), Blueprint.Make() ];
  var instances = new Blueprint.RetypeEach( ... args );

  test.true( instances !== args );
  test.true( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.containsOnly( instances[ 0 ], exp );
  test.identical( instances[ 0 ] instanceof Blueprint.Make, true );
  test.true( instances[ 0 ] === args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.Make, true );
  test.true( instances[ 1 ] === args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.Make, true );
  test.true( instances[ 2 ] === args[ 2 ] );

  /* */

}

retypeEachBasic.description =
`
- RetypeEach with several argument produce array with instances
- same objects are reused, no new objects created
`

//

function helperConstruct( test )
{

  function _getter( arg )
  {
    return 'x' + arg;
  }

  var Blueprint1 = _.Blueprint
  ({
    field1 : null,
  });
  var instance = _.blueprint.construct( Blueprint1 );
  instance.field1 = _getter;

  var prototypes = _.prototype.each( _.Blueprint );
  test.identical( prototypes.length, 1 );
  var prototypes = _.prototype.each( _.blueprint );
  test.identical( prototypes.length, 1 );
  test.true( prototypes[ 0 ] === _.blueprint );

  var prototypes = _.prototype.each( Blueprint1 );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === Blueprint1 );
  test.true( prototypes[ 1 ] === Blueprint1.Runtime );
  test.true( prototypes[ 2 ] === _.Blueprint.prototype );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 1 );
  test.true( prototypes[ 0 ] === instance );

  test.true( !_.prototype.hasPrototype( instance, Blueprint1 ) );
  test.true( _.objectIs( instance ) );
  test.true( _.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

}

//

function helperDefineConstructor( test )
{

  let constr = _.blueprint.defineConstructor
  ({
    ins : null,
    names : null,
  });
  test.true( _.routineIs( constr ) );

  var exp = { ins : null, names : null };
  var instance = constr();
  test.identical( instance, exp );
  test.true( _.mapIs( instance ) );

  var exp = { ins : 13, names : null };
  var instance = constr({ ins : 13 });
  test.identical( instance, exp );
  test.true( _.mapIs( instance ) );

}

helperDefineConstructor.description =
`
- _.blueprint.defineConstructor returns constructor of blueprint
`

//

function helperConstructAndNew( test )
{

  function _getter( arg )
  {
    return 'x' + arg;
  }

  var Blueprint = new _.Blueprint
  ({
    field1 : null,
  });

  var instance = _.blueprint.construct( Blueprint );
  instance.field1 = _getter;

  var prototypes = _.prototype.each( _.Blueprint );
  test.identical( prototypes.length, 1 );
  test.true( prototypes[ 0 ] === _.Blueprint );
  var prototypes = _.prototype.each( Blueprint );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === Blueprint );
  test.true( prototypes[ 1 ] === Blueprint.Runtime );
  test.true( prototypes[ 2 ] === _.Blueprint.prototype );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 1 );
  test.true( prototypes[ 0 ] === instance );

  test.true( !_.prototype.hasPrototype( instance, Blueprint ) );
  test.true( _.objectIs( instance ) );
  test.true( _.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

}

//

function defineReusingSingleBlueprint( test )
{

  /* */

  test.case = 'basic';

  var Blueprint1 = _.Blueprint
  ({
    field1 : null,
  });

  var Blueprint2 = _.Blueprint( Blueprint1 );
  var instance = _.blueprint.construct( Blueprint2 );
  instance.field1 = '1';

  test.shouldThrowErrorSync( () =>
  {
    instance.field2 = 2;
  });

  var prototypes = _.prototype.each( _.Blueprint );
  test.identical( prototypes.length, 1 );
  test.true( prototypes[ 0 ] === _.Blueprint );
  var prototypes = _.prototype.each( Blueprint2 );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === Blueprint2 );
  test.true( prototypes[ 1 ] === Blueprint2.Runtime );
  test.true( prototypes[ 2 ] === _.Blueprint.prototype );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === instance );
  test.true( prototypes[ 1 ] === Blueprint2.Make.prototype );
  test.true( prototypes[ 2 ] === _.Construction.prototype );

  test.true( Blueprint1.Make.prototype === null );
  test.true( _.prototype.hasPrototype( instance, Blueprint2.Make.prototype ) );
  test.true( _.objectIs( instance ) );
  test.true( !_.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

  test.case = 'basic';

  var Blueprint1 = _.Blueprint
  ({
    field1 : null,
    typed : _.trait.typed(),
  });

  var Blueprint2 = _.Blueprint( Blueprint1 );
  var instance = _.blueprint.construct( Blueprint2 );
  instance.field1 = '1';

  test.shouldThrowErrorSync( () =>
  {
    instance.field2 = 2;
  });

  var prototypes = _.prototype.each( _.Blueprint );
  test.identical( prototypes.length, 1 );
  test.true( prototypes[ 0 ] === _.Blueprint );
  var prototypes = _.prototype.each( Blueprint2 );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === Blueprint2 );
  test.true( prototypes[ 1 ] === Blueprint2.Runtime );
  test.true( prototypes[ 2 ] === _.Blueprint.prototype );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 4 );
  test.true( prototypes[ 0 ] === instance );
  test.true( prototypes[ 1 ] === Blueprint2.Make.prototype );
  test.true( prototypes[ 2 ] === Blueprint1.Make.prototype );
  test.true( prototypes[ 3 ] === _.Construction.prototype );

  test.true( _.prototype.hasPrototype( instance, Blueprint1.Make.prototype ) );
  test.true( _.prototype.hasPrototype( instance, Blueprint2.Make.prototype ) );
  test.true( _.objectIs( instance ) );
  test.true( !_.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

}

defineReusingSingleBlueprint.description =
`
- prototype of typed instance inherit its own prototype, prototope of parent and _.Construction.prototype
`

//

function defineReusingMultipleBlueprints( test )
{

  var Blueprint1 = _.Blueprint
  ({
    field1 : null,
    typed : _.trait.typed( 1 ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : null,
    typed : _.trait.typed( 1 ),
  });

  var Blueprint3 = _.Blueprint( Blueprint1, Blueprint2, { field3 : '3' } );
  var instance = _.blueprint.construct( Blueprint3 );

  var exp = { 'field1' : null, 'field2' : null, 'field3' : '3' };
  test.containsOnly( instance, exp );

  var exp = { 'field1' : null, 'field2' : null, 'field3' : '3' };
  var got = _.property.all( instance );
  test.identical( got, exp );

  var prototypes = _.prototype.each( _.Blueprint );
  test.identical( prototypes.length, 1 );
  test.true( prototypes[ 0 ] === _.Blueprint );
  var prototypes = _.prototype.each( Blueprint3 );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === Blueprint3 );
  test.true( prototypes[ 1 ] === Blueprint3.Runtime );
  test.true( prototypes[ 2 ] === _.Blueprint.prototype );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 4 );
  test.true( prototypes[ 0 ] === instance );
  test.true( prototypes[ 1 ] === Blueprint3.Make.prototype );
  test.true( prototypes[ 2 ] === Blueprint2.Make.prototype );
  test.true( prototypes[ 3 ] === _.Construction.prototype );

  test.true( !_.prototype.hasPrototype( instance, Blueprint1.Make.prototype ) );
  test.true( _.prototype.hasPrototype( instance, Blueprint2.Make.prototype ) );
  test.true( _.prototype.hasPrototype( instance, Blueprint3.Make.prototype ) );
  test.true( _.objectIs( instance ) );
  test.true( !_.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1', 'field2', 'field3' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1', 'field2', 'field3' ] );

}

defineReusingMultipleBlueprints.description =
`
- passing multiple blueprints to maker of blueprint use the first last prototype
- all fields of all passed blueprints to maker of blueprints extends new blueprint
`

// --
// make / from / retype
// --

function makeAlternativeRoutinesUntyped( test )
{

  /* */

  test.case = 'structural';
  var Blueprint1 = _.Blueprint
  ({
    a : 1,
  });
  test.true( Blueprint1.constructor === undefined );
  test.true( Blueprint1.Runtime.constructor === undefined );
  test.true( Blueprint1.prototype === null );
  test.true( Blueprint1.Make.prototype === null );
  // test.true( Blueprint1.prototype.constructor === undefined );
  test.true( Blueprint1.Make === Blueprint1.Runtime.Make );

  act({ method : 'Make' });

  function act( top )
  {

    /* */

    test.case = `Blueprint.${top.method}()`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance1 = Blueprint1[ top.method ]();
    var exp =
    {
      a : 1,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );

    /* */

    test.case = `new.Blueprint.${top.method}()`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance1 = new Blueprint1[ top.method ]();
    var exp =
    {
      a : 1,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );

    /* */

    test.case = `Blueprint.${top.method}( instance0 )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance0 = new Blueprint1[ top.method ]();
    instance0.a = 2;
    var instance1 = Blueprint1[ top.method ]( instance0 );
    var exp =
    {
      a : 2,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );
    test.true( instance0 !== instance1 );

    /* */

    test.case = `new.Blueprint.${top.method}( instance0 )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance0 = new Blueprint1[ top.method ]();
    instance0.a = 2;
    var instance1 = new Blueprint1[ top.method ]( instance0 );
    var exp =
    {
      a : 2,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );
    test.true( instance0 !== instance1 );

    /* */

    test.case = `Blueprint.${top.method}( opts )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var opts = { a : 0 };
    var instance1 = Blueprint1[ top.method ]( opts );
    var exp =
    {
      a : 0,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );
    test.true( opts !== instance1 );

    /* */

    test.case = `new.Blueprint.${top.method}( opts )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var opts = { a : 0 };
    var instance1 = new Blueprint1[ top.method ]( opts );
    var exp =
    {
      a : 0,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );
    test.true( opts !== instance1 );

    /* */

    test.case = `Blueprint.${top.method}( null )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance1 = Blueprint1[ top.method ]( null );
    var exp =
    {
      a : 1,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );

    /* */

    test.case = `new.Blueprint.${top.method}( null )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance1 = new Blueprint1[ top.method ]( null );
    var exp =
    {
      a : 1,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );

    /* */

    test.case = `Blueprint.Runtime.${top.method}()`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance1 = Blueprint1.Runtime[ top.method ]();
    var exp =
    {
      a : 1,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );

    /* */

    test.case = `new.Blueprint.Runtime.${top.method}()`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance1 = new Blueprint1.Runtime[ top.method ]();
    var exp =
    {
      a : 1,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );

    /* */

    test.case = `Blueprint.Runtime.${top.method}( instance0 )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance0 = new Blueprint1[ top.method ]();
    instance0.a = 2;
    var instance1 = Blueprint1.Runtime[ top.method ]( instance0 );
    var exp =
    {
      a : 2,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );
    test.true( instance0 !== instance1 );

    /* */

    test.case = `new.Blueprint.Runtime.${top.method}( instance0 )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance0 = new Blueprint1[ top.method ]();
    instance0.a = 2;
    var instance1 = new Blueprint1.Runtime[ top.method ]( instance0 );
    var exp =
    {
      a : 2,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );
    test.true( instance0 !== instance1 );

    /* */

    test.case = `Blueprint.Runtime.${top.method}( opts )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var opts = { a : 0 };
    var instance1 = Blueprint1.Runtime[ top.method ]( opts );
    var exp =
    {
      a : 0,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );
    test.true( opts !== instance1 );

    /* */

    test.case = `new.Blueprint.Runtime.${top.method}( opts )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var opts = { a : 0 };
    var instance1 = new Blueprint1.Runtime[ top.method ]( opts );
    var exp =
    {
      a : 0,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );
    test.true( opts !== instance1 );

    /* */

    test.case = `Blueprint.Runtime.${top.method}( null )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance1 = Blueprint1.Runtime[ top.method ]( null );
    var exp =
    {
      a : 1,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );

    /* */

    test.case = `new.Blueprint.Runtime.${top.method}( null )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance1 = new Blueprint1.Runtime[ top.method ]( null );
    var exp =
    {
      a : 1,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );

    /* */

  }

}

makeAlternativeRoutinesUntyped.description =
`
  - there are many ways to construct construction, all should work similarly
`

//

function makeAlternativeRoutinesTyped( test )
{

  /* */

  test.case = 'structural';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor( false ),
    a : 1,
  });
  test.true( Blueprint1.constructor === undefined );
  test.true( Blueprint1.Runtime.constructor === undefined );
  test.true( Blueprint1.prototype.constructor === undefined );
  test.true( Blueprint1.Make === Blueprint1.Runtime.Make );

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    a : 1,
  });
  test.true( Blueprint1.constructor === undefined );
  test.true( Blueprint1.Runtime.constructor === undefined );
  test.true( Blueprint1.prototype.constructor === Blueprint1.Make );
  test.true( Blueprint1.Make === Blueprint1.Runtime.Make );

  act({ method : 'Make', withConstructor : false });
  act({ method : 'Make', withConstructor : true });

  function act( top )
  {

    test.open( `withConstructor:${top.withConstructor}` );

    /* */

    test.case = `Blueprint.${top.method}()`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance1 = Blueprint1[ top.method ]();
    var exp =
    {
      a : 1,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );

    /* */

    test.case = `new.Blueprint.${top.method}()`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance1 = new Blueprint1[ top.method ]();
    var exp =
    {
      a : 1,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );

    /* */

    test.case = `Blueprint.${top.method}( instance0 )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance0 = new Blueprint1[ top.method ]();
    instance0.a = 2;
    var instance1 = Blueprint1[ top.method ]( instance0 );
    var exp =
    {
      a : 2,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );
    test.true( instance0 !== instance1 );

    /* */

    test.case = `new.Blueprint.${top.method}( instance0 )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance0 = new Blueprint1[ top.method ]();
    instance0.a = 2;
    var instance1 = new Blueprint1[ top.method ]( instance0 );
    var exp =
    {
      a : 2,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );
    test.true( instance0 !== instance1 );

    /* */

    test.case = `Blueprint.${top.method}( opts )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var opts = { a : 0 };
    var instance1 = Blueprint1[ top.method ]( opts );
    var exp =
    {
      a : 0,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );
    test.true( opts !== instance1 );

    /* */

    test.case = `new.Blueprint.${top.method}( opts )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var opts = { a : 0 };
    var instance1 = new Blueprint1[ top.method ]( opts );
    var exp =
    {
      a : 0,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );
    test.true( opts !== instance1 );

    /* */

    test.case = `Blueprint.${top.method}( null )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance1 = Blueprint1[ top.method ]( null );
    var exp =
    {
      a : 1,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );

    /* */

    test.case = `new.Blueprint.${top.method}( null )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance1 = new Blueprint1[ top.method ]( null );
    var exp =
    {
      a : 1,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );

    /* */

    test.case = `Blueprint.Runtime.${top.method}()`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance1 = Blueprint1.Runtime[ top.method ]();
    var exp =
    {
      a : 1,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );

    /* */

    test.case = `new.Blueprint.Runtime.${top.method}()`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance1 = new Blueprint1.Runtime[ top.method ]();
    var exp =
    {
      a : 1,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );

    /* */

    test.case = `Blueprint.Runtime.${top.method}( instance0 )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance0 = new Blueprint1[ top.method ]();
    instance0.a = 2;
    var instance1 = Blueprint1.Runtime[ top.method ]( instance0 );
    var exp =
    {
      a : 2,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );
    test.true( instance0 !== instance1 );

    /* */

    test.case = `new.Blueprint.Runtime.${top.method}( instance0 )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance0 = new Blueprint1[ top.method ]();
    instance0.a = 2;
    var instance1 = new Blueprint1.Runtime[ top.method ]( instance0 );
    var exp =
    {
      a : 2,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );
    test.true( instance0 !== instance1 );

    /* */

    test.case = `Blueprint.Runtime.${top.method}( opts )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var opts = { a : 0 };
    var instance1 = Blueprint1.Runtime[ top.method ]( opts );
    var exp =
    {
      a : 0,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );
    test.true( opts !== instance1 );

    /* */

    test.case = `new.Blueprint.Runtime.${top.method}( opts )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var opts = { a : 0 };
    var instance1 = new Blueprint1.Runtime[ top.method ]( opts );
    var exp =
    {
      a : 0,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );
    test.true( opts !== instance1 );

    /* */

    test.case = `Blueprint.Runtime.${top.method}( null )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance1 = Blueprint1.Runtime[ top.method ]( null );
    var exp =
    {
      a : 1,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );

    /* */

    test.case = `new.Blueprint.Runtime.${top.method}( null )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance1 = new Blueprint1.Runtime[ top.method ]( null );
    var exp =
    {
      a : 1,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );

    /* */

    test.close( `withConstructor:${top.withConstructor}` );

  }

}

makeAlternativeRoutinesTyped.description =
`
  - there are many ways to construct construction, all should work similarly
`

//

function fromAlternativeRoutinesUntyped( test )
{

  /* */

  test.case = 'structural';
  var Blueprint1 = _.Blueprint
  ({
    a : 1,
  });
  test.true( Blueprint1.From === Blueprint1.Runtime.From );

  act({ method : 'From' });

  function act( top )
  {

    /* */

    test.case = `Blueprint.${top.method}()`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance1 = Blueprint1[ top.method ]();
    var exp =
    {
      a : 1,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );

    /* */

    test.case = `Blueprint.${top.method}( instance0 )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance0 = new Blueprint1.Make();
    instance0.a = 2;
    var instance1 = Blueprint1[ top.method ]( instance0 );
    var exp =
    {
      a : 2,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );
    test.true( instance0 === instance1 );

    /* */

    test.case = `Blueprint.${top.method}( opts )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var opts = { a : 0 };
    var instance1 = Blueprint1[ top.method ]( opts );
    var exp =
    {
      a : 0,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );
    test.true( opts === instance1 );

    /* */

    test.case = `Blueprint.${top.method}( null )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance1 = Blueprint1[ top.method ]( null );
    var exp =
    {
      a : 1,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );

    /* */

    test.case = `Blueprint.Runtime.${top.method}()`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance1 = Blueprint1.Runtime[ top.method ]();
    var exp =
    {
      a : 1,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );

    /* */

    test.case = `Blueprint.Runtime.${top.method}( instance0 )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance0 = new Blueprint1.Make();
    instance0.a = 2;
    var instance1 = Blueprint1.Runtime[ top.method ]( instance0 );
    var exp =
    {
      a : 2,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );
    test.true( instance0 === instance1 );

    /* */

    test.case = `Blueprint.Runtime.${top.method}( opts )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var opts = { a : 0 };
    var instance1 = Blueprint1.Runtime[ top.method ]( opts );
    var exp =
    {
      a : 0,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );
    test.true( opts === instance1 );

    /* */

    test.case = `Blueprint.Runtime.${top.method}( null )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance1 = Blueprint1.Runtime[ top.method ]( null );
    var exp =
    {
      a : 1,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );

    /* */

    if( !Config.debug )
    return;

    test.case = `throwing`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    test.shouldThrowErrorSync( () => new Blueprint1[ top.method ]() );
    test.shouldThrowErrorSync( () => new Blueprint1.Runtime[ top.method ]() );

    /* */

  }

}

fromAlternativeRoutinesUntyped.description =
`
  - there are many ways to from, all should work similarly
`

//

function fromAlternativeRoutinesTyped( test )
{

  /* */

  test.case = 'structural';
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor( false ),
    a : 1,
  });
  test.true( Blueprint1.From === Blueprint1.Runtime.From );
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    a : 1,
  });
  test.true( Blueprint1.From === Blueprint1.Runtime.From );

  act({ method : 'From', withConstructor : false });
  act({ method : 'From', withConstructor : true });

  function act( top )
  {
    test.open( `withConstructor:${top.withConstructor}` );

    /* */

    test.case = `Blueprint.${top.method}()`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance1 = Blueprint1[ top.method ]();
    var exp =
    {
      a : 1,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );

    /* */

    test.case = `Blueprint.${top.method}( instance0 )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance0 = new Blueprint1.Make();
    instance0.a = 2;
    var instance1 = Blueprint1[ top.method ]( instance0 );
    var exp =
    {
      a : 2,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );
    test.true( instance0 === instance1 );

    /* */

    test.case = `Blueprint.${top.method}( opts )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var opts = { a : 0 };
    var instance1 = Blueprint1[ top.method ]( opts );
    var exp =
    {
      a : 0,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );
    test.true( opts !== instance1 );

    /* */

    test.case = `Blueprint.${top.method}( null )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance1 = Blueprint1[ top.method ]( null );
    var exp =
    {
      a : 1,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );

    /* */

    test.case = `Blueprint.Runtime.${top.method}()`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance1 = Blueprint1.Runtime[ top.method ]();
    var exp =
    {
      a : 1,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );

    /* */

    test.case = `Blueprint.Runtime.${top.method}( instance0 )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance0 = new Blueprint1.Make();
    instance0.a = 2;
    var instance1 = Blueprint1.Runtime[ top.method ]( instance0 );
    var exp =
    {
      a : 2,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );
    test.true( instance0 === instance1 );

    /* */

    test.case = `Blueprint.Runtime.${top.method}( opts )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var opts = { a : 0 };
    var instance1 = Blueprint1.Runtime[ top.method ]( opts );
    var exp =
    {
      a : 0,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );
    test.true( opts !== instance1 );

    /* */

    test.case = `Blueprint.Runtime.${top.method}( null )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance1 = Blueprint1.Runtime[ top.method ]( null );
    var exp =
    {
      a : 1,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );

    /* */

    if( !Config.debug )
    return;

    test.case = `throwing`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    test.shouldThrowErrorSync( () => new Blueprint1[ top.method ]() );
    test.shouldThrowErrorSync( () => new Blueprint1.Runtime[ top.method ]() );

    /* */

    test.close( `withConstructor:${top.withConstructor}` );
  }

}

fromAlternativeRoutinesTyped.description =
`
  - there are many ways to from, all should work similarly
`

//

function retypeAlternativeRoutinesUntyped( test )
{

  /* */

  test.case = 'structural';
  var Blueprint1 = _.Blueprint
  ({
    a : 1,
  });
  test.true( Blueprint1.Retype === Blueprint1.Runtime.Retype );

  act({ method : 'Retype' });

  function act( top )
  {

    /* */

    test.case = `Blueprint.${top.method}()`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance1 = Blueprint1[ top.method ]();
    var exp =
    {
      a : 1,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );

    /* */

    test.case = `Blueprint.${top.method}( instance0 )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance0 = new Blueprint1.Make();
    instance0.a = 2;
    var instance1 = Blueprint1[ top.method ]( instance0 );
    var exp =
    {
      a : 2,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );
    test.true( instance0 === instance1 );

    /* */

    test.case = `Blueprint.${top.method}( opts )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var opts = { a : 0 };
    var instance1 = Blueprint1[ top.method ]( opts );
    var exp =
    {
      a : 0,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );
    test.true( opts === instance1 );

    /* */

    test.case = `Blueprint.${top.method}( null )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance1 = Blueprint1[ top.method ]( null );
    var exp =
    {
      a : 1,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );

    /* */

    test.case = `Blueprint.Runtime.${top.method}()`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance1 = Blueprint1.Runtime[ top.method ]();
    var exp =
    {
      a : 1,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );

    /* */

    test.case = `Blueprint.Runtime.${top.method}( instance0 )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance0 = new Blueprint1.Make();
    instance0.a = 2;
    var instance1 = Blueprint1.Runtime[ top.method ]( instance0 );
    var exp =
    {
      a : 2,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );
    test.true( instance0 === instance1 );

    /* */

    test.case = `Blueprint.Runtime.${top.method}( opts )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var opts = { a : 0 };
    var instance1 = Blueprint1.Runtime[ top.method ]( opts );
    var exp =
    {
      a : 0,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );
    test.true( opts === instance1 );

    /* */

    test.case = `Blueprint.Runtime.${top.method}( null )`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });
    var instance1 = Blueprint1.Runtime[ top.method ]( null );
    var exp =
    {
      a : 1,
    }
    test.identical( instance1, exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), _.maybe );

    /* */

    if( !Config.debug )
    return;

    test.case = `throwing`;
    var Blueprint1 = _.Blueprint
    ({
      a : 1,
    });

    test.shouldThrowErrorSync( () => new Blueprint1[ top.method ]() );
    test.shouldThrowErrorSync( () => new Blueprint1.Runtime[ top.method ]() );

    /* */

  }

}

retypeAlternativeRoutinesUntyped.description =
`
  - there are many ways to retype, all should work similarly
`

//

function retypeAlternativeRoutinesTyped( test )
{

  /* */

  test.case = 'structural';
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor( false ),
    a : 1,
  });
  test.true( Blueprint1.Retype === Blueprint1.Runtime.Retype );

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    a : 1,
  });
  test.true( Blueprint1.Retype === Blueprint1.Runtime.Retype );

  act({ method : 'Retype', withConstructor : false });
  act({ method : 'Retype', withConstructor : true });

  function act( top )
  {
    test.open( `withConstructor:${top.withConstructor}` );

    /* */

    test.case = `Blueprint.${top.method}()`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance1 = Blueprint1[ top.method ]();
    var exp =
    {
      a : 1,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );

    /* */

    test.case = `Blueprint.${top.method}( instance0 )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance0 = new Blueprint1.Make();
    instance0.a = 2;
    var instance1 = Blueprint1[ top.method ]( instance0 );
    var exp =
    {
      a : 2,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );
    test.true( instance0 === instance1 );

    /* */

    test.case = `Blueprint.${top.method}( opts )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var opts = { a : 0 };
    var instance1 = Blueprint1[ top.method ]( opts );
    var exp =
    {
      a : 0,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );
    test.true( opts === instance1 );

    /* */

    test.case = `Blueprint.${top.method}( null )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true, }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance1 = Blueprint1[ top.method ]( null );
    var exp =
    {
      a : 1,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );

    /* */

    test.case = `Blueprint.Runtime.${top.method}()`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance1 = Blueprint1.Runtime[ top.method ]();
    var exp =
    {
      a : 1,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );

    /* */

    test.case = `Blueprint.Runtime.${top.method}( instance0 )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance0 = new Blueprint1.Make();
    instance0.a = 2;
    var instance1 = Blueprint1.Runtime[ top.method ]( instance0 );
    var exp =
    {
      a : 2,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );
    test.true( instance0 === instance1 );

    /* */

    test.case = `Blueprint.Runtime.${top.method}( opts )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var opts = { a : 0 };
    var instance1 = Blueprint1.Runtime[ top.method ]( opts );
    var exp =
    {
      a : 0,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );
    test.true( opts === instance1 );

    /* */

    test.case = `Blueprint.Runtime.${top.method}( null )`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    var instance1 = Blueprint1.Runtime[ top.method ]( null );
    var exp =
    {
      a : 1,
    }
    if( top.withConstructor )
    exp.constructor = instance1.constructor;
    test.identical( _.property.all( instance1 ), exp );
    test.identical( _.construction.isInstanceOf( instance1, Blueprint1 ), true );

    /* */

    if( !Config.debug )
    return;

    test.case = `throwing`;
    var Blueprint1 = _.Blueprint
    ({
      typed : _.trait.typed({ val : true }),
      withConstructor : _.trait.withConstructor( top.withConstructor ),
      a : 1,
    });
    test.shouldThrowErrorSync( () => new Blueprint1[ top.method ]() );
    test.shouldThrowErrorSync( () => new Blueprint1.Runtime[ top.method ]() );

    /* */

    test.close( `withConstructor:${top.withConstructor}` );
  }

}

retypeAlternativeRoutinesTyped.description =
`
  - there are many ways to retype, all should work similarly
`

//

function retypeBasic( test )
{

  /* */

  test.case = 'Make -- control';
  var blueprint1 = _.Blueprint
  ({
    a : 'a',
    b : '3',
  });
  var src = { a : 'a2' }
  test.true( Object.getPrototypeOf( src ) === Object.prototype );
  var got = new blueprint1.Make( src );
  test.true( Object.getPrototypeOf( got ) === null );
  test.true( Object.getPrototypeOf( src ) === Object.prototype );
  test.true( got !== src );
  var exp =
  {
    a : 'a2',
    b : '3',
  }
  test.identical( got, exp );
  var exp =
  {
    a : 'a2',
  }
  test.identical( src, exp );

  /* */

  test.case = 'untyped impure to untyped';
  var blueprint1 = _.Blueprint
  ({
    a : 'a',
    b : '3',
  });
  var src = { a : 'a2' }
  test.true( Object.getPrototypeOf( src ) === Object.prototype );
  var got = blueprint1.Retype( src );
  test.true( Object.getPrototypeOf( got ) === Object.prototype );
  test.true( got === src );
  var exp =
  {
    a : 'a2',
    b : '3',
  }
  test.identical( got, exp );

  /* */

  test.case = 'pure untyped to untyped';
  var blueprint1 = _.Blueprint
  ({
    a : 'a',
    b : '3',
  });
  var src = Object.create( null );
  src.a = 'a2';
  test.true( Object.getPrototypeOf( src ) === null );
  var got = blueprint1.Retype( src );
  test.true( Object.getPrototypeOf( got ) === null );
  test.true( got === src );
  var exp =
  {
    a : 'a2',
    b : '3',
  }
  test.identical( got, exp );

  /* */

  test.case = 'typed to untyped';
  var blueprint1 = _.Blueprint
  ({
    a : 'a',
    b : '3',
  });
  var prototype = {}
  var src = Object.create( prototype );
  src.a = 'a2';
  test.true( Object.getPrototypeOf( src ) === prototype );
  var got = blueprint1.Retype( src );
  test.true( Object.getPrototypeOf( got ) === null );
  test.true( got === src );
  var exp =
  {
    a : 'a2',
    b : '3',
  }
  test.identical( got, exp );

  /* */

  test.case = 'untyped to typed';
  var blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed(),
    a : 'a',
    b : '3',
  });
  var src = { a : 'a2' }
  test.true( Object.getPrototypeOf( src ) === Object.prototype );
  var got = blueprint1.Retype( src );
  test.true( Object.getPrototypeOf( got ) === blueprint1.Make.prototype );
  test.true( Object.getPrototypeOf( Object.getPrototypeOf( got ) ) === _.Construction.prototype );
  test.true( got === src );
  var exp =
  {
    a : 'a2',
    b : '3',
  }
  test.identical( _.property.all( got ), propertyOwn( exp ) );

  /* */

  test.case = 'pure untyped to typed';
  var blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed(),
    a : 'a',
    b : '3',
  });
  var src = Object.create( null );
  src.a = 'a2';
  test.true( Object.getPrototypeOf( src ) === null );
  var got = blueprint1.Retype( src );
  test.true( Object.getPrototypeOf( got ) === blueprint1.Make.prototype );
  test.true( Object.getPrototypeOf( Object.getPrototypeOf( got ) ) === _.Construction.prototype );
  test.true( got === src );
  var exp =
  {
    a : 'a2',
    b : '3',
  }
  test.identical( _.property.all( got ), propertyOwn( exp ) );

  /* */

  test.case = 'typed to typed';
  var blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed(),
    a : 'a',
    b : '3',
  });
  var prototype = {}
  var src = Object.create( prototype );
  src.a = 'a2';
  test.true( Object.getPrototypeOf( src ) === prototype );
  var got = blueprint1.Retype( src );
  test.true( Object.getPrototypeOf( got ) === blueprint1.Make.prototype );
  test.true( Object.getPrototypeOf( Object.getPrototypeOf( got ) ) === _.Construction.prototype );
  test.true( got === src );
  var exp =
  {
    a : 'a2',
    b : '3',
  }
  test.identical( _.property.all( got ), propertyOwn( exp ) );

  /* */

  test.case = 'typed to typed -- with global routine';
  var blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed(),
    a : 'a',
    b : '3',
  });
  var prototype = {}
  var src = Object.create( prototype );
  src.a = 'a2';
  test.true( Object.getPrototypeOf( src ) === prototype );
  var got = _.blueprint.retype( blueprint1, src );
  test.true( Object.getPrototypeOf( got ) === blueprint1.Make.prototype );
  test.true( Object.getPrototypeOf( Object.getPrototypeOf( got ) ) === _.Construction.prototype );
  test.true( got === src );
  var exp =
  {
    a : 'a2',
    b : '3',
  }
  test.identical( _.property.all( got ), propertyOwn( exp ) );

  /* */

  test.case = 'typed to same typed';
  var blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed(),
    a : 'a',
    b : '3',
  });
  var prototype = {}
  var src = blueprint1.Make();
  src.a = 'a2';
  test.true( Object.getPrototypeOf( src ) === blueprint1.Make.prototype );
  var got = blueprint1.Retype( src );
  test.true( Object.getPrototypeOf( got ) === blueprint1.Make.prototype );
  test.true( Object.getPrototypeOf( Object.getPrototypeOf( got ) ) === _.Construction.prototype );
  test.true( got === src );
  var exp =
  {
    a : 'a2',
    b : '3',
  }
  test.identical( _.property.all( got ), propertyOwn( exp ) );

  /* */

}

//

function retypeExtendable( test )
{

  /* */

  test.case = 'implicit trait.extendable()';
  var Blueprint1 = _.Blueprint
  ({
    a : 1,
    b : 1,
  });
  var src = { b : 2, c : 3 };
  test.true( Object.isExtensible( src ) );
  var got = Blueprint1.Retype( src );
  test.true( got === src );
  test.true( !Object.isExtensible( got ) );

  /* */

  test.case = 'trait.extendable( false )';
  var Blueprint1 = _.Blueprint
  ({
    a : 1,
    b : 1,
    extendable : _.trait.extendable( false ),
  });
  var src = { b : 2, c : 3 };
  test.true( Object.isExtensible( src ) );
  var got = Blueprint1.Retype( src );
  test.true( got === src );
  test.true( !Object.isExtensible( got ) );

  /* */

  test.case = 'trait.extendable( true )';
  var Blueprint1 = _.Blueprint
  ({
    a : 1,
    b : 1,
    extendable : _.trait.extendable( true ),
  });
  var src = { b : 2, c : 3 };
  test.true( Object.isExtensible( src ) );
  var got = Blueprint1.Retype( src );
  test.true( got === src );
  test.true( Object.isExtensible( got ) );

  /* */

}

// --
// declare
// --

let Self =
{

  name : 'Tools.l2.blueprint.Blueprint',
  silencing : 1,

  context :
  {

    propertyOwn,
    keysOwn,
    eachKindOfProp,

  },

  tests :
  {

    // etc

    blueprintIsDefinitive,
    blueprintIsRuntime,
    blueprintStructure,

    // define inherit

    blueprintInheritManually,
    blueprintInheritWithHelper,
    blueprintInheritSingle,
    blueprintInheritMultiple,
    blueprintInheritMultipleAlternatives,

    // define prop

    defineProp,
    defineProps,
    definePropStaticBasic,
    definePropStaticInheritance,
    definePropStaticMaybeAmendConstruction,
    definePropEnumerable,
    definePropWritable,
    definePropConfigurable,
    defineProper,

    definePropShallowComplex,
    definePropShallowComplexSourceCode,

    definePropStaticAccessorBasic,
    definePropAccessorBasic,
    definePropAccessorTypedMaybe,
    definePropAccessorConstructionAmend, /* critical */
    definePropAccessorAlternativeOptions,
    definePropAccessorStaticNonStatic,
    definePropAccessorRewriting,

    definePropConstructionAmendWithBlueprint,

    // define alias

    definePropAliasBasic,
    definePropAliasOptionOriginalContainer,
    definePropAliasConstructionAmendWithDefinition,
    definePropAliasConstructionAmendWithBlueprint,

    // define amendment

    defineExtensionBasic,
    defineSupplementationBasic,
    defineExtensionOrder,
    defineSupplementationOrder,
    defineAmendmentOrder,
    defineAmendmentPropInheritance,

    // define etc

    defineNothing,
    constructionExtendWithBlueprintWithNothing,
    constructionExtendWithNothing,

    // trait

    traitTypePrototype,
    traitTypedTrivial,
    traitTypedBasic, /* critical */
    traitTypedConstructionAmend, /* critical */
    traitTypedPrototypeBlueprint,
    traitTypedPrototype,
    traitTypedLogistic,

    // other traits

    traitName,
    traitWithConstructorBasic,
    traitWithConstructorAmendConstruction,
    traitWithConstructorAmendConstructionAlternatives,
    traitWithConstructorTraitPrototypeTraitTyped,
    traitExtendable,
    traitExtendableAmendConstruction,

    // construct / define

    constructWithoutHelper,
    constructWithArgumentMap,
    constructWithArgumentMapUndeclaredFields,
    constructWithArgumentInstance,
    makeEachBasic,
    fromEachBasic,
    retypeEachBasic,

    helperConstruct,
    helperDefineConstructor,
    helperConstructAndNew,

    defineReusingSingleBlueprint,
    defineReusingMultipleBlueprints,

    // make / from

    makeAlternativeRoutinesUntyped,
    makeAlternativeRoutinesTyped,
    fromAlternativeRoutinesUntyped,
    fromAlternativeRoutinesTyped,

    // retype

    retypeAlternativeRoutinesUntyped,
    retypeAlternativeRoutinesTyped,
    retypeBasic,
    retypeExtendable,

  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
