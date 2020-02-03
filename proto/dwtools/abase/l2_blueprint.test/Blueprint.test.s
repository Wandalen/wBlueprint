( function _Blueprint_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  _.include( 'wTesting' );

  if( !_.module.isIncluded( 'wProto' ) )
  {
    require( '../../abase/l3_proto/Include.s' );
  }

}

var _global = _global_;
var _ = _global_.wTools;

// --
// test
// --

function constructTyped( test )
{

  function rfield( arg )
  {
    debugger;
    return 'x' + arg;
  }

  /* */

  test.case = 'blueprint with untyped instance, implicit';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
  });
  var instance = _.blueprint.construct( Blueprint );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), false );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), false );

  test.identical( instance instanceof Blueprint.construct, false );
  test.identical( Object.getPrototypeOf( instance ), null );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototypeEach( instance );
  test.identical( prototypes.length, 1 );
  test.is( prototypes[ 0 ] === instance );
  test.is( !_.prototypeHasPrototype( instance, Blueprint ) );
  test.is( _.objectIs( instance ) );
  test.is( _.mapIs( instance ) );
  test.is( _.mapLike( instance ) );
  test.is( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

  test.case = 'blueprint with untyped instance, explicit';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var instance = _.blueprint.construct( Blueprint );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), false );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), false );

  test.identical( instance instanceof Blueprint.construct, false );
  test.identical( Object.getPrototypeOf( instance ), null );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototypeEach( instance );
  test.identical( prototypes.length, 1 );
  test.is( prototypes[ 0 ] === instance );
  test.is( !_.prototypeHasPrototype( instance, Blueprint ) );
  test.is( _.objectIs( instance ) );
  test.is( _.mapIs( instance ) );
  test.is( _.mapLike( instance ) );
  test.is( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

  test.case = 'blueprint with typed instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var instance = _.blueprint.construct( Blueprint );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), true );

  test.identical( instance instanceof Blueprint.construct, true );
  test.identical( Object.getPrototypeOf( instance ), _.Construction.prototype );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototypeEach( instance );
  test.identical( prototypes.length, 3 );
  test.is( prototypes[ 0 ] === instance );
  test.is( prototypes[ 1 ] === Blueprint.construct.prototype );
  test.is( prototypes[ 2 ] === _.Construction.prototype );
  test.is( _.prototypeHasPrototype( instance, instance ) );
  test.is( _.prototypeHasPrototype( instance, Blueprint.construct.prototype ) );
  test.is( _.prototypeHasPrototype( instance, _.Construction.prototype ) );
  test.is( _.objectIs( instance ) );
  test.is( !_.mapIs( instance ) );
  test.is( _.mapLike( instance ) );
  test.is( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

}

constructTyped.description =
`
- construction is not typed by default
- construction is typed if trait typed is true
`

//

function constructWithoutHelper( test )
{

  function rfield( arg )
  {
    debugger;
    return 'x' + arg;
  }

  /* */

  test.case = 'without new, blueprint with untyped instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var instance = Blueprint.construct();

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), false );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), false );

  test.identical( instance instanceof Blueprint.construct, false );
  test.identical( Object.getPrototypeOf( instance ), null );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototypeEach( instance );
  test.identical( prototypes.length, 1 );
  test.is( prototypes[ 0 ] === instance );
  test.is( !_.prototypeHasPrototype( instance, Blueprint ) );
  test.is( _.objectIs( instance ) );
  test.is( _.mapIs( instance ) );
  test.is( _.mapLike( instance ) );
  test.is( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

  test.case = 'without new, blueprint with typed instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var instance = Blueprint.construct();

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), true );

  test.identical( instance instanceof Blueprint.construct, true );
  test.identical( Object.getPrototypeOf( instance ), _.Construction.prototype );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototypeEach( instance );
  test.identical( prototypes.length, 3 );
  test.is( prototypes[ 0 ] === instance );
  test.is( prototypes[ 1 ] === Blueprint.construct.prototype );
  test.is( prototypes[ 2 ] === _.Construction.prototype );
  test.is( _.prototypeHasPrototype( instance, instance ) );
  test.is( _.prototypeHasPrototype( instance, Blueprint.construct.prototype ) );
  test.is( _.prototypeHasPrototype( instance, _.Construction.prototype ) );
  test.is( _.objectIs( instance ) );
  test.is( !_.mapIs( instance ) );
  test.is( _.mapLike( instance ) );
  test.is( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

  test.case = 'with new, blueprint with untyped instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var instance = new Blueprint.construct();

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), false );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), false );

  test.identical( instance instanceof Blueprint.construct, false );
  test.identical( Object.getPrototypeOf( instance ), null );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototypeEach( instance );
  test.identical( prototypes.length, 1 );
  test.is( prototypes[ 0 ] === instance );
  test.is( !_.prototypeHasPrototype( instance, Blueprint ) );
  test.is( _.objectIs( instance ) );
  test.is( _.mapIs( instance ) );
  test.is( _.mapLike( instance ) );
  test.is( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

  test.case = 'with new, blueprint with typed instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var instance = new Blueprint.construct();

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), true );

  test.identical( instance instanceof Blueprint.construct, true );
  test.identical( Object.getPrototypeOf( instance ), _.Construction.prototype );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototypeEach( instance );
  test.identical( prototypes.length, 3 );
  test.is( prototypes[ 0 ] === instance );
  test.is( prototypes[ 1 ] === Blueprint.construct.prototype );
  test.is( prototypes[ 2 ] === _.Construction.prototype );
  test.is( _.prototypeHasPrototype( instance, instance ) );
  test.is( _.prototypeHasPrototype( instance, Blueprint.construct.prototype ) );
  test.is( _.prototypeHasPrototype( instance, _.Construction.prototype ) );
  test.is( _.objectIs( instance ) );
  test.is( !_.mapIs( instance ) );
  test.is( _.mapLike( instance ) );
  test.is( !_.instanceIs( instance ) );
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
    debugger;
    return 'x' + arg;
  }

  /* */

  test.case = 'without new, blueprint with untyped instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var opts = { field1 : 13 };
  var instance = Blueprint.construct( opts );

  test.is( instance !== opts );
  var exp = { field1 : 13 }
  test.identical( instance, exp );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), false );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), false );

  test.identical( instance instanceof Blueprint.construct, false );
  test.identical( Object.getPrototypeOf( instance ), null );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototypeEach( instance );
  test.identical( prototypes.length, 1 );
  test.is( prototypes[ 0 ] === instance );
  test.is( !_.prototypeHasPrototype( instance, Blueprint ) );
  test.is( _.objectIs( instance ) );
  test.is( _.mapIs( instance ) );
  test.is( _.mapLike( instance ) );
  test.is( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

  test.case = 'without new, blueprint with typed instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var opts = { field1 : 13 };
  var instance = Blueprint.construct( opts );

  test.is( instance !== opts );
  var exp = { field1 : 13 }
  test.identical( instance, exp );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), true );

  test.identical( instance instanceof Blueprint.construct, true );
  test.identical( Object.getPrototypeOf( instance ), _.Construction.prototype );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototypeEach( instance );
  test.identical( prototypes.length, 3 );
  test.is( prototypes[ 0 ] === instance );
  test.is( prototypes[ 1 ] === Blueprint.construct.prototype );
  test.is( prototypes[ 2 ] === _.Construction.prototype );
  test.is( _.prototypeHasPrototype( instance, instance ) );
  test.is( _.prototypeHasPrototype( instance, Blueprint.construct.prototype ) );
  test.is( _.prototypeHasPrototype( instance, _.Construction.prototype ) );
  test.is( _.objectIs( instance ) );
  test.is( !_.mapIs( instance ) );
  test.is( _.mapLike( instance ) );
  test.is( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

  test.case = 'with new, blueprint with untyped instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var opts = { field1 : 13 };
  var instance = new Blueprint.construct( opts );

  test.is( instance !== opts );
  var exp = { field1 : 13 }
  test.identical( instance, exp );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), false );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), false );

  test.identical( instance instanceof Blueprint.construct, false );
  test.identical( Object.getPrototypeOf( instance ), null );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototypeEach( instance );
  test.identical( prototypes.length, 1 );
  test.is( prototypes[ 0 ] === instance );
  test.is( !_.prototypeHasPrototype( instance, Blueprint ) );
  test.is( _.objectIs( instance ) );
  test.is( _.mapIs( instance ) );
  test.is( _.mapLike( instance ) );
  test.is( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

  /* */

  test.case = 'with new, blueprint with typed instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var opts = { field1 : 13 };
  var instance = new Blueprint.construct( opts );

  test.is( instance !== opts );
  var exp = { field1 : 13 }
  test.identical( instance, exp );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), true );

  test.identical( instance instanceof Blueprint.construct, true );
  test.identical( Object.getPrototypeOf( instance ), _.Construction.prototype );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototypeEach( instance );
  test.identical( prototypes.length, 3 );
  test.is( prototypes[ 0 ] === instance );
  test.is( prototypes[ 1 ] === Blueprint.construct.prototype );
  test.is( prototypes[ 2 ] === _.Construction.prototype );
  test.is( _.prototypeHasPrototype( instance, instance ) );
  test.is( _.prototypeHasPrototype( instance, Blueprint.construct.prototype ) );
  test.is( _.prototypeHasPrototype( instance, _.Construction.prototype ) );
  test.is( _.objectIs( instance ) );
  test.is( !_.mapIs( instance ) );
  test.is( _.mapLike( instance ) );
  test.is( !_.instanceIs( instance ) );
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
    debugger;
    return 'x' + arg;
  }

  /* */

  test.case = 'extendable:1, without new, blueprint with untyped instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
    extendable : _.trait.extendable(),
  });
  var opts = { fieldBad : 13 };
  var instance = Blueprint.construct( opts );

  test.is( instance !== opts );
  var exp = { field1 : rfield, fieldBad : 13 }
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint.construct, false );

  /* */

  test.case = 'extendable:1, without new, blueprint with typed instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
    extendable : _.trait.extendable(),
  });
  var opts = { fieldBad : 13 };
  var instance = Blueprint.construct( opts );

  test.is( instance !== opts );
  var exp = { field1 : rfield, fieldBad : 13 }
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint.construct, true );

  /* */

  test.case = 'extendable:1, with new, blueprint with untyped instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
    extendable : _.trait.extendable(),
  });
  var opts = { fieldBad : 13 };
  var instance = new Blueprint.construct( opts );

  test.is( instance !== opts );
  var exp = { field1 : rfield, fieldBad : 13 }
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint.construct, false );

  /* */

  test.case = 'extendable:1, with new, blueprint with typed instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
    extendable : _.trait.extendable(),
  });
  var opts = { fieldBad : 13 };
  var instance = new Blueprint.construct( opts );

  test.is( instance !== opts );
  var exp = { field1 : rfield, fieldBad : 13 }
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint.construct, true );

  /* */

  test.case = 'extendable:0, without new, blueprint with untyped instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
    extendable : _.trait.extendable( false ),
  });
  var opts = { fieldBad : 13 };
  test.shouldThrowErrorSync( () => Blueprint.construct( opts ) );

  /* */

  test.case = 'extendable:0, without new, blueprint with typed instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
    extendable : _.trait.extendable( false ),
  });
  var opts = { fieldBad : 13 };
  test.shouldThrowErrorSync( () => Blueprint.construct( opts ) );

  /* */

  test.case = 'extendable:0, with new, blueprint with untyped instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
    extendable : _.trait.extendable( false ),
  });
  var opts = { fieldBad : 13 };
  test.shouldThrowErrorSync( () => new Blueprint.construct( opts ) );

  /* */

  test.case = 'extendable:0, with new, blueprint with typed instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
    extendable : _.trait.extendable( false ),
  });
  var opts = { fieldBad : 13 };
  test.shouldThrowErrorSync( () => new Blueprint.construct( opts ) );

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
    debugger;
    return 'x' + arg;
  }

  /* */

  test.case = 'without new, blueprint with untyped instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var opts = { field1 : 13 };
  var instance1 = Blueprint.construct( opts );
  var instance2 = Blueprint.construct( instance1 );

  test.is( instance1 !== opts );
  test.is( instance2 !== opts );
  test.is( instance1 !== instance2 );
  var exp = { field1 : 13 }
  test.identical( instance2, exp );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance2 ), false );
  test.identical( _.construction.isInstanceOf( instance2, Blueprint ), false );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance2 ), false );

  test.identical( instance2 instanceof Blueprint.construct, false );
  test.identical( Object.getPrototypeOf( instance2 ), null );
  test.identical( instance2.constructor, undefined );
  var prototypes = _.prototypeEach( instance2 );
  test.identical( prototypes.length, 1 );
  test.is( prototypes[ 0 ] === instance2 );
  test.is( !_.prototypeHasPrototype( instance2, Blueprint ) );
  test.is( _.objectIs( instance2 ) );
  test.is( _.mapIs( instance2 ) );
  test.is( _.mapLike( instance2 ) );
  test.is( !_.instanceIs( instance2 ) );
  test.identical( _.mapKeys( instance2 ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance2 ), [ 'field1' ] );

  /* */

  test.case = 'without new, blueprint with typed instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var opts = { field1 : 13 };
  var instance1 = Blueprint.construct( opts );
  var instance2 = Blueprint.construct( instance1 );

  test.is( instance1 !== opts );
  test.is( instance2 !== opts );
  test.is( instance1 === instance2 );
  var exp = { field1 : 13 }
  test.identical( instance2, exp );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance2 ), true );
  test.identical( _.construction.isInstanceOf( instance2, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance2 ), true );

  test.identical( instance2 instanceof Blueprint.construct, true );
  test.identical( Object.getPrototypeOf( instance2 ), _.Construction.prototype );
  test.identical( instance2.constructor, undefined );
  var prototypes = _.prototypeEach( instance2 );
  test.identical( prototypes.length, 3 );
  test.is( prototypes[ 0 ] === instance2 );
  test.is( prototypes[ 1 ] === Blueprint.construct.prototype );
  test.is( prototypes[ 2 ] === _.Construction.prototype );
  test.is( _.prototypeHasPrototype( instance2, instance2 ) );
  test.is( _.prototypeHasPrototype( instance2, Blueprint.construct.prototype ) );
  test.is( _.prototypeHasPrototype( instance2, _.Construction.prototype ) );
  test.is( _.objectIs( instance2 ) );
  test.is( !_.mapIs( instance2 ) );
  test.is( _.mapLike( instance2 ) );
  test.is( !_.instanceIs( instance2 ) );
  test.identical( _.mapKeys( instance2 ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance2 ), [ 'field1' ] );

  /* */

  test.case = 'with new, blueprint with untyped instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var opts = { field1 : 13 };
  var instance1 = new Blueprint.construct( opts );
  var instance2 = new Blueprint.construct( instance1 );

  test.is( instance1 !== opts );
  test.is( instance2 !== opts );
  test.is( instance1 !== instance2 );
  var exp = { field1 : 13 }
  test.identical( instance2, exp );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance2 ), false );
  test.identical( _.construction.isInstanceOf( instance2, Blueprint ), false );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance2 ), false );

  test.identical( instance2 instanceof Blueprint.construct, false );
  test.identical( Object.getPrototypeOf( instance2 ), null );
  test.identical( instance2.constructor, undefined );
  var prototypes = _.prototypeEach( instance2 );
  test.identical( prototypes.length, 1 );
  test.is( prototypes[ 0 ] === instance2 );
  test.is( !_.prototypeHasPrototype( instance2, Blueprint ) );
  test.is( _.objectIs( instance2 ) );
  test.is( _.mapIs( instance2 ) );
  test.is( _.mapLike( instance2 ) );
  test.is( !_.instanceIs( instance2 ) );
  test.identical( _.mapKeys( instance2 ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance2 ), [ 'field1' ] );

  /* */

  test.case = 'with new, blueprint with typed instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var opts = { field1 : 13 };
  var instance1 = new Blueprint.construct( opts );
  var instance2 = new Blueprint.construct( instance1 );

  test.is( instance1 !== opts );
  test.is( instance2 !== opts );
  test.is( instance1 !== instance2 );
  var exp = { field1 : 13 }
  test.identical( instance2, exp );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance2 ), true );
  test.identical( _.construction.isInstanceOf( instance2, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance2 ), true );

  test.identical( instance2 instanceof Blueprint.construct, true );
  test.identical( Object.getPrototypeOf( instance2 ), _.Construction.prototype );
  test.identical( instance2.constructor, undefined );
  var prototypes = _.prototypeEach( instance2 );
  test.identical( prototypes.length, 3 );
  test.is( prototypes[ 0 ] === instance2 );
  test.is( prototypes[ 1 ] === Blueprint.construct.prototype );
  test.is( prototypes[ 2 ] === _.Construction.prototype );
  test.is( _.prototypeHasPrototype( instance2, instance2 ) );
  test.is( _.prototypeHasPrototype( instance2, Blueprint.construct.prototype ) );
  test.is( _.prototypeHasPrototype( instance2, _.Construction.prototype ) );
  test.is( _.objectIs( instance2 ) );
  test.is( !_.mapIs( instance2 ) );
  test.is( _.mapLike( instance2 ) );
  test.is( !_.instanceIs( instance2 ) );
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

function constructWithArgumentLong( test )
{

  function rfield( arg )
  {
    debugger;
    return 'x' + arg;
  }

  /* */

  test.case = 'without new, blueprint with untyped instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var args = [ { field1 : 1 }, new Blueprint.construct({ field1 : 2 }), Blueprint.construct() ];
  var instances = Blueprint.construct( args );

  test.is( instances !== args );
  test.is( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.identical( instances[ 0 ], exp );
  test.identical( instances[ 0 ] instanceof Blueprint.construct, false );
  test.is( instances[ 0 ] !== args[ 0 ] );
  var exp = { field1 : 2 }
  test.identical( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.construct, false );
  test.is( instances[ 1 ] !== args[ 1 ] );
  var exp = { field1 : rfield }
  test.identical( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.construct, false );
  test.is( instances[ 2 ] !== args[ 2 ] );

  /* */

  test.case = 'without new, blueprint with typed instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var args = [ { field1 : 1 }, new Blueprint.construct({ field1 : 2 }), Blueprint.construct() ];
  var instances = Blueprint.construct( args );

  test.is( instances !== args );
  test.is( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.identical( instances[ 0 ], exp );
  test.identical( instances[ 0 ] instanceof Blueprint.construct, true );
  test.is( instances[ 0 ] !== args[ 0 ] );
  var exp = { field1 : 2 }
  test.identical( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.construct, true );
  test.is( instances[ 1 ] === args[ 1 ] );
  var exp = { field1 : rfield }
  test.identical( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.construct, true );
  test.is( instances[ 2 ] === args[ 2 ] );

  /* */

  test.case = 'with new, blueprint with untyped instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var args = [ { field1 : 1 }, new Blueprint.construct({ field1 : 2 }), Blueprint.construct() ];
  var instances = new Blueprint.construct( args );

  test.is( instances !== args );
  test.is( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.identical( instances[ 0 ], exp );
  test.identical( instances[ 0 ] instanceof Blueprint.construct, false );
  test.is( instances[ 0 ] !== args[ 0 ] );
  var exp = { field1 : 2 }
  test.identical( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.construct, false );
  test.is( instances[ 1 ] !== args[ 1 ] );
  var exp = { field1 : rfield }
  test.identical( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.construct, false );
  test.is( instances[ 2 ] !== args[ 2 ] );

  /* */

  test.case = 'with new, blueprint with typed instance';
  var Blueprint = _.blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var args = [ { field1 : 1 }, new Blueprint.construct({ field1 : 2 }), Blueprint.construct() ];
  var instances = new Blueprint.construct( args );

  test.is( instances !== args );
  test.is( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.identical( instances[ 0 ], exp );
  test.identical( instances[ 0 ] instanceof Blueprint.construct, true );
  test.is( instances[ 0 ] !== args[ 0 ] );
  var exp = { field1 : 2 }
  test.identical( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.construct, true );
  test.is( instances[ 1 ] !== args[ 1 ] );
  var exp = { field1 : rfield }
  test.identical( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.construct, true );
  test.is( instances[ 2 ] !== args[ 2 ] );

  /* */

}

constructWithArgumentLong.description =
`
- construct with long in argument produce array with instances
- constructor take into account directive new even if argument is long
`

//

function constructWithHelper( test )
{

  function _getter( arg )
  {
    debugger;
    return 'x' + arg;
  }

  var Blueprint1 = _.blueprint
  ({
    field1 : null,
  });
  var instance = _.blueprint.construct( Blueprint1 );
  instance.field1 = _getter;

  var prototypes = _.prototypeEach( _.Blueprint );
  test.identical( prototypes.length, 1 );
  test.is( prototypes[ 0 ] === _.Blueprint );
  var prototypes = _.prototypeEach( Blueprint1 );
  test.identical( prototypes.length, 2 );
  test.is( prototypes[ 0 ] === Blueprint1 );
  test.is( prototypes[ 1 ] === _.Blueprint );
  var prototypes = _.prototypeEach( instance );
  test.identical( prototypes.length, 1 );
  test.is( prototypes[ 0 ] === instance );

  test.is( !_.prototypeHasPrototype( instance, Blueprint1 ) );
  test.is( _.objectIs( instance ) );
  test.is( _.mapIs( instance ) );
  test.is( _.mapLike( instance ) );
  test.is( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

}

//

function constructWithNewAndHelper( test )
{

  function _getter( arg )
  {
    debugger;
    return 'x' + arg;
  }

  var Blueprint = new _.blueprint
  ({
    field1 : null,
  });

  var instance = _.blueprint.construct( Blueprint );
  instance.field1 = _getter;

  var prototypes = _.prototypeEach( _.Blueprint );
  test.identical( prototypes.length, 1 );
  test.is( prototypes[ 0 ] === _.Blueprint );
  var prototypes = _.prototypeEach( Blueprint );
  test.identical( prototypes.length, 2 );
  test.is( prototypes[ 0 ] === Blueprint );
  test.is( prototypes[ 1 ] === _.Blueprint );
  var prototypes = _.prototypeEach( instance );
  test.identical( prototypes.length, 1 );
  test.is( prototypes[ 0 ] === instance );

  test.is( !_.prototypeHasPrototype( instance, Blueprint ) );
  test.is( _.objectIs( instance ) );
  test.is( _.mapIs( instance ) );
  test.is( _.mapLike( instance ) );
  test.is( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

}

//

function constructExtendable( test )
{

  function rfield( arg )
  {
    debugger;
    return 'x' + arg;
  }

  /* */

  test.case = 'not extendable, implicit';
  var Blueprint = _.blueprint
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
  var Blueprint = _.blueprint
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
  var Blueprint = _.blueprint
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
  var Blueprint = _.blueprint
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

}

constructExtendable.description =
`
- blueprint without trait extandable is not extenable
- blueprint with trait extandable with argument false is not extenable
- blueprint with trait extandable is extenable
- blueprint with trait extandable without argument is extenable
`

//

function blueprintExtend( test )
{

  /* */

  test.case = 'not typed -> not typed';
  var Blueprint1 = _.blueprint
  ({
    field1 : 'b1',
    field2 : 'b1',
    typed : _.trait.typed( false ),
  });

  var Blueprint2 = _.blueprint
  ({
    typed : _.trait.typed( false ),
    field2 : 'b2',
    field3 : 'b2',
    extension : _.define.extension( Blueprint1 ),
  });

  var exp = { field1 : 'b1', field2 : 'b1', field3 : 'b2' };
  var instance = Blueprint2.construct();
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint1.construct, false );
  test.identical( instance instanceof Blueprint2.construct, false );

  /* */

  test.case = 'not typed -> typed';
  var Blueprint1 = _.blueprint
  ({
    field1 : 'b1',
    field2 : 'b1',
    typed : _.trait.typed( false ),
  });

  var Blueprint2 = _.blueprint
  ({
    typed : _.trait.typed( true ),
    field2 : 'b2',
    field3 : 'b2',
    extension : _.define.extension( Blueprint1 ),
  });

  var exp = { field1 : 'b1', field2 : 'b1', field3 : 'b2' };
  var instance = Blueprint2.construct();
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint1.construct, false );
  test.identical( instance instanceof Blueprint2.construct, false );

  /* */

  test.case = 'typed -> not typed';
  var Blueprint1 = _.blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
  });

  var Blueprint2 = _.blueprint
  ({
    typed : _.trait.typed( false ),
    field2 : 'b2',
    field3 : 'b2',
    extension : _.define.extension( Blueprint1 ),
  });

  var exp = { field1 : 'b1', field2 : 'b1', field3 : 'b2' };
  var instance = Blueprint2.construct();
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint1.construct, false );
  test.identical( instance instanceof Blueprint2.construct, true );

  /* */

  test.case = 'typed -> typed';
  var Blueprint1 = _.blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
  });

  var Blueprint2 = _.blueprint
  ({
    typed : _.trait.typed( true ),
    field2 : 'b2',
    field3 : 'b2',
    extension : _.define.extension( Blueprint1 ),
  });

  var exp = { field1 : 'b1', field2 : 'b1', field3 : 'b2' };
  var instance = Blueprint2.construct();
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint1.construct, false );
  test.identical( instance instanceof Blueprint2.construct, true );

  /* */

}

blueprintExtend.description =
`
- blueprint extend another blueprint by fields
- blueprint extend another blueprint by traits
`

//

function blueprintSupplement( test )
{

  /* */

  test.case = 'not typed -> not typed';
  var Blueprint1 = _.blueprint
  ({
    typed : _.trait.typed( false ),
    field1 : 'b1',
    field2 : 'b1',
  });

  var Blueprint2 = _.blueprint
  ({
    typed : _.trait.typed( false ),
    field2 : 'b2',
    field3 : 'b2',
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var exp = { field1 : 'b1', field2 : 'b2', field3 : 'b2' };
  var instance = Blueprint2.construct();
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint1.construct, false );
  test.identical( instance instanceof Blueprint2.construct, false );

  /* */

  test.case = 'not typed -> typed';
  var Blueprint1 = _.blueprint
  ({
    typed : _.trait.typed( false ),
    field1 : 'b1',
    field2 : 'b1',
  });

  var Blueprint2 = _.blueprint
  ({
    typed : _.trait.typed( true ),
    field2 : 'b2',
    field3 : 'b2',
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var exp = { field1 : 'b1', field2 : 'b2', field3 : 'b2' };
  var instance = Blueprint2.construct();
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint1.construct, false );
  test.identical( instance instanceof Blueprint2.construct, true );

  /* */

  test.case = 'typed -> not typed';
  var Blueprint1 = _.blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
  });

  var Blueprint2 = _.blueprint
  ({
    typed : _.trait.typed( false ),
    field2 : 'b2',
    field3 : 'b2',
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var exp = { field1 : 'b1', field2 : 'b2', field3 : 'b2' };
  var instance = Blueprint2.construct();
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint1.construct, false );
  test.identical( instance instanceof Blueprint2.construct, false );

  /* */

  test.case = 'typed -> typed';
  var Blueprint1 = _.blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
  });

  var Blueprint2 = _.blueprint
  ({
    typed : _.trait.typed( true ),
    field2 : 'b2',
    field3 : 'b2',
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var exp = { field1 : 'b1', field2 : 'b2', field3 : 'b2' };
  var instance = Blueprint2.construct();
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint1.construct, false );
  test.identical( instance instanceof Blueprint2.construct, true );

  /* */

}

blueprintSupplement.description =
`
- blueprint supplement another blueprint by fields
- blueprint supplement another blueprint by traits
`

//

function blueprintStatic( test )
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
  var Blueprint1 = _.blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    method1 : m1,
    staticMethod1 : s( sm1 ),
    staticField1 : s( 'sf1' ),
    staticField2 : s( { k : 'staticField2' } ),
    statics1 : ss
    ({
      staticMethod2 : sm2,
      staticField3 : 'sf3',
      staticField4 : { k : 'staticField4' },
    }),
    statics2 : ss( [ staticsA, staticsB ] )
  });

  var exp = { 'field1' : 'b1', 'field2' : 'b1', 'method1' : m1 };
  var instance = Blueprint1.construct();
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint1.construct, true );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'method1' : m1,
    'staticMethod1' : sm1,
    'staticMethod2' : sm2,
    'staticField1' : 'sf1',
    'staticField2' : { 'k' : 'staticField2' },
    'staticField3' : 'sf3',
    'staticField4' : { 'k' : 'staticField4' },
    'staticField5' : { 'k' : 'staticField5' },
    'staticField6' : { 'k' : 'staticField6' }
  }
  var got = _.mapAllProperties( instance );
  test.identical( got, exp );

  /* */

}

blueprintStatic.description =
`
- static fields added to prototype
`

//

function blueprintInherit( test )
{

  /* */

  test.case = 'basic';
  let s = _.define.static;
  var Blueprint1 = _.blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : s( 'b1' ),
    staticField2 : s( 'b1' ),
  });

  test.description = 'control blueprint1';
  var exp = { 'field1' : 'b1', 'field2' : 'b1' };
  var instance = Blueprint1.construct();
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint1.construct, true );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'staticField1' : 'b1',
    'staticField2' : 'b1'
  }
  var got = _.mapAllProperties( instance );
  test.identical( got, exp );

  var Blueprint2 = _.blueprint
  ({
    typed : _.trait.typed( true ),
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : s( 'b2' ),
    staticField3 : s( 'b2' ),
    prototype : _.trait.prototype( Blueprint1 ),
  });

  test.description = 'blueprint2';
  var exp = { 'field2' : 'b2', 'field3' : 'b2' };
  var instance = Blueprint2.construct();
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint1.construct, true );
  test.identical( instance instanceof Blueprint2.construct, true );
  var exp =
  {
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
    'staticField3' : 'b2'
  }
  var got = _.mapAllProperties( instance );
  test.identical( got, exp );

  test.description = 'control blueprint1';
  var exp = { 'field1' : 'b1', 'field2' : 'b1' };
  var instance = Blueprint1.construct();
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint1.construct, true );
  test.identical( instance instanceof Blueprint2.construct, false );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'staticField1' : 'b1',
    'staticField2' : 'b1'
  }
  var got = _.mapAllProperties( instance );
  test.identical( got, exp );

  /* */

}

blueprintInherit.description =
`
- defintition prototype makes another blueprint prototype of instance of the blueprint
`

//

function orderOfDefinitions( test )
{

  /* */

  test.case = 'extension';

  var Blueprint1 = _.blueprint
  ({
    field1 : null,
  });

  var Blueprint2 = _.blueprint
  ({
    typed : _.trait.typed(),
    prototype : _.trait.prototype( Blueprint1 ),
    extension : _.define.extension( Blueprint1 ),
  });

  var Blueprint3 = _.blueprint
  ({
    prototype : _.trait.prototype( Blueprint1 ),
    extension : _.define.extension( Blueprint1 ),
    typed : _.trait.typed(),
  });

  var instance1 = _.blueprint.construct( Blueprint1 );
  var prototypes1 = _.prototypeEach( instance1 );
  test.identical( prototypes1.length, 1 );

  var instance2 = _.blueprint.construct( Blueprint2 );
  var prototypes2 = _.prototypeEach( instance2 );
  test.identical( prototypes2.length, 1 );

  var instance3 = _.blueprint.construct( Blueprint3 );
  var prototypes3 = _.prototypeEach( instance3 );
  test.identical( prototypes3.length, 4 );
  test.is( prototypes3[ 0 ] === instance3 );
  test.is( prototypes3[ 1 ] === Blueprint3.construct.prototype );
  test.is( prototypes3[ 2 ] === Blueprint1.construct.prototype );
  test.is( prototypes3[ 3 ] === _.Construction.prototype );

  /* */

  test.case = 'supplementation';

  var Blueprint1 = _.blueprint
  ({
    field1 : null,
  });

  var Blueprint2 = _.blueprint
  ({
    typed : _.trait.typed(),
    prototype : _.trait.prototype( Blueprint1 ),
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var Blueprint3 = _.blueprint
  ({
    prototype : _.trait.prototype( Blueprint1 ),
    supplementation : _.define.supplementation( Blueprint1 ),
    typed : _.trait.typed(),
  });

  var instance1 = _.blueprint.construct( Blueprint1 );
  var prototypes1 = _.prototypeEach( instance1 );
  test.identical( prototypes1.length, 1 );

  var instance2 = _.blueprint.construct( Blueprint2 );
  var prototypes2 = _.prototypeEach( instance2 );
  test.identical( prototypes2.length, 4 );
  test.is( prototypes2[ 0 ] === instance2 );
  test.is( prototypes2[ 1 ] === Blueprint2.construct.prototype );
  test.is( prototypes2[ 2 ] === Blueprint1.construct.prototype );
  test.is( prototypes2[ 3 ] === _.Construction.prototype );

  var instance3 = _.blueprint.construct( Blueprint3 );
  var prototypes3 = _.prototypeEach( instance3 );
  test.identical( prototypes3.length, 4 );
  test.is( prototypes3[ 0 ] === instance3 );
  test.is( prototypes3[ 1 ] === Blueprint3.construct.prototype );
  test.is( prototypes3[ 2 ] === Blueprint1.construct.prototype );
  test.is( prototypes3[ 3 ] === _.Construction.prototype );

  /* */

}

orderOfDefinitions.description =
`
- order of definitions/traits makes difference
- typing first and then extending by untyped blueprint produce untyped blueprint
- extending by untyped blueprint and then typing produce typed blueprint
- typing first and then supplementing by untyped blueprint produce typed blueprint
- supplementing by untyped blueprint and then typing produce typed blueprint
`

//

function constructSingleReuse( test )
{

  var Blueprint1 = _.blueprint
  ({
    field1 : null,
  });

  var Blueprint2 = _.blueprint( Blueprint1 );
  var instance = _.blueprint.construct( Blueprint2 );
  instance.field1 = '1';

  test.shouldThrowErrorSync( () =>
  {
    instance.field2 = 2;
  });

  var prototypes = _.prototypeEach( _.Blueprint );
  test.identical( prototypes.length, 1 );
  test.is( prototypes[ 0 ] === _.Blueprint );
  var prototypes = _.prototypeEach( Blueprint2 );
  test.identical( prototypes.length, 2 );
  test.is( prototypes[ 0 ] === Blueprint2 );
  test.is( prototypes[ 1 ] === _.Blueprint );
  var prototypes = _.prototypeEach( instance );
  test.identical( prototypes.length, 4 );
  test.is( prototypes[ 0 ] === instance );
  test.is( prototypes[ 1 ] === Blueprint2.construct.prototype );
  test.is( prototypes[ 2 ] === Blueprint1.construct.prototype );
  test.is( prototypes[ 3 ] === _.Construction.prototype );

  test.is( _.prototypeHasPrototype( instance, Blueprint1.construct.prototype ) );
  test.is( _.prototypeHasPrototype( instance, Blueprint2.construct.prototype ) );
  test.is( _.objectIs( instance ) );
  test.is( !_.mapIs( instance ) );
  test.is( _.mapLike( instance ) );
  test.is( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1' ] );

}

constructSingleReuse.description =
`
- prototype of typed instance inherit its own prototype, prototope of parent and _.Construction.prototype
`

//

function constructMultipleReuse( test )
{

  var Blueprint1 = _.blueprint
  ({
    field1 : null,
  });

  var Blueprint2 = _.blueprint
  ({
    field2 : null,
  });

  var Blueprint3 = _.blueprint( Blueprint1, Blueprint2, { field3 : '3' } );
  var instance = _.blueprint.construct( Blueprint3 );

  var exp = { 'field1' : null, 'field2' : null, 'field3' : '3' };
  test.identical( instance, exp );

  var exp = { 'field1' : null, 'field2' : null, 'field3' : '3' };
  var got = _.mapAllProperties( instance );
  test.identical( got, exp );

  var prototypes = _.prototypeEach( _.Blueprint );
  test.identical( prototypes.length, 1 );
  test.is( prototypes[ 0 ] === _.Blueprint );
  var prototypes = _.prototypeEach( Blueprint3 );
  test.identical( prototypes.length, 2 );
  test.is( prototypes[ 0 ] === Blueprint3 );
  test.is( prototypes[ 1 ] === _.Blueprint );
  var prototypes = _.prototypeEach( instance );
  test.identical( prototypes.length, 4 );
  test.is( prototypes[ 0 ] === instance );
  test.is( prototypes[ 1 ] === Blueprint3.construct.prototype );
  test.is( prototypes[ 2 ] === Blueprint2.construct.prototype );
  test.is( prototypes[ 3 ] === _.Construction.prototype );

  test.is( !_.prototypeHasPrototype( instance, Blueprint1.construct.prototype ) );
  test.is( _.prototypeHasPrototype( instance, Blueprint2.construct.prototype ) );
  test.is( _.prototypeHasPrototype( instance, Blueprint3.construct.prototype ) );
  test.is( _.objectIs( instance ) );
  test.is( !_.mapIs( instance ) );
  test.is( _.mapLike( instance ) );
  test.is( !_.instanceIs( instance ) );
  test.identical( _.mapKeys( instance ), [ 'field1', 'field2', 'field3' ] );
  test.identical( _.mapAllKeys( instance ), [ 'field1', 'field2', 'field3' ] );

}

constructMultipleReuse.description =
`
- passing multiple blueprints to maker of blueprint use the first last prototype
- all fields of all passed blueprints to maker of blueprints extends new blueprint
`

//

// function callable( test )
// {
//
//   function _getter( arg )
//   {
//     debugger;
//     return 'x' + arg;
//   }
//
//   var Blueprint1 = _.blueprint
//   ({
//     functor : null,
//     '__call__' : _.define.ownerCallback( 'functor' ),
//   });
//
//   var instance = _.blueprint.construct( Blueprint1 );
//   instance.functor = _getter;
//
//   debugger;
//   var prototypes = _.prototypeEach( _.Blueprint );
//   test.identical( prototypes.length, 1 );
//   test.is( prototypes[ 0 ] === _.Blueprint );
//   var prototypes = _.prototypeEach( Blueprint1 );
//   test.identical( prototypes.length, 2 );
//   test.is( prototypes[ 0 ] === Blueprint1 );
//   test.is( prototypes[ 1 ] === _.Blueprint );
//   var prototypes = _.prototypeEach( instance );
//   test.identical( prototypes.length, 3 );
//   test.is( prototypes[ 0 ] === instance );
//   test.is( prototypes[ 1 ] === Blueprint1 );
//   test.is( prototypes[ 2 ] === _.Blueprint );
//   debugger;
//
//   test.is( _.prototypeHasPrototype( instance, Blueprint1 ) );
//   test.is( _.routineIs( instance ) );
//   // test.identical( _.mapKeys( instance ), [ 'functor' ] );
//   // test.identical( _.mapAllKeys( instance ), [ 'functor' ] );
//
//   debugger;
//   var got = instance( '+y' );
//   test.identical( got, 'x+y' );
//   debugger;
//
// }

//

function is( test )
{

  var Blueprint1 = _.blueprint
  ({
    field1 : null,
  });

  var Blueprint2 = _.blueprint( Blueprint1 );

  var instance1 = _.blueprint.construct( Blueprint1 );
  var instance2 = _.blueprint.construct( Blueprint2 );

  test.identical( _.blueprint.is( _.blueprint ), false );
  test.identical( _.blueprint.is( _.Blueprint ), true );
  test.identical( _.blueprint.is( Blueprint1 ), true );
  test.identical( _.blueprint.is( Blueprint2 ), true );
  test.identical( _.blueprint.is( instance1 ), false );
  test.identical( _.blueprint.is( instance2 ), false );

}

is.description =
`
- instances of blueprint are not blueprints
- blueprint is blueprint
- abstract _.Blueprint is blueprint
- namespace _.blueprint is not blueprint
`


//

function complexFields( test )
{

  /* */

  var e = [];
  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed(),
    array : _.define.shallow( [ e ] ),
    map : _.define.shallow( { k : e } ),
  });
  var instance1 = blueprint.construct();
  var instance2 = blueprint.construct();
  var exp =
  {
    array : [ [] ],
    map : { k : [] },
  }

  test.identical( instance1, exp );
  test.identical( instance1 instanceof blueprint.construct, true );
  test.identical( instance2, exp );
  test.identical( instance2 instanceof blueprint.construct, true );
  test.is( instance1.array !== instance2.array );
  test.is( instance1.map !== instance2.map );
  test.is( instance1.array[ 0 ] === instance2.array[ 0 ] );
  test.is( instance1.map.k === instance2.map.k );

  /* */

  // debugger;
  // var sourceCode = blueprint.compileSourceCode();
  // debugger;

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
  test.is( instance1.array !== instance2.array );
  test.is( instance1.map !== instance2.map );
  test.is( instance1.array[ 0 ] === instance2.array[ 0 ] );
  test.is( instance1.map.k === instance2.map.k );
*/

  /* */

}

complexFields.description =
`
- shortcut shallow define definition field with iniToIns:shallow
`

//

// function defineConstructor()
// {
//
//   xxx
//   debugger;
//   let TokensCollection = _.blueprint.defineConstructor
//   ({
//     ins : null,
//     names : null,
//   });
//
//   debugger;
//   test.is( _.constructorIs( TokensCollection ) );
//   debugger;
//
// }
//
// defineConstructor.description =
// `
// - xxx
// `

//

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

  name : 'Tools.base.l3.Blueprint',
  silencing : 1,

  tests :
  {

    constructTyped,
    constructWithoutHelper,
    constructWithArgumentMap,
    constructWithArgumentMapUndeclaredFields,
    constructWithArgumentInstance,
    constructWithArgumentLong,
    constructWithHelper,
    constructWithNewAndHelper,
    constructExtendable,

    blueprintExtend,
    blueprintSupplement,
    blueprintStatic,
    blueprintInherit,

    orderOfDefinitions,
    constructSingleReuse,
    constructMultipleReuse,
    is,

    complexFields,
    // defineConstructor,

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
