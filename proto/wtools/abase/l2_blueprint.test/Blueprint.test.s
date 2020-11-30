( function _Blueprint_test_s_( ) {

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

function constructions( test )
{

  var exp =
  {
    segments : [ 2,2 ],
    size : [ 2,2 ],
    axis : 2,
  }
  var got = _.blueprint
  .construct
  ({
    segments : _.define.shallow([ 2,2 ]),
    size : _.define.shallow([ 2,2 ]),
    axis : 2,
  })
  var got = test.identical( got, exp );


/*

var Settings = _.like()
.also
({
  segments : _.define.own([ 2,2 ]),
  size : _.define.own([ 2,2 ]),
  axis : 2,
})
.end

*/

}

//

function constructTyped( test )
{

  function rfield( arg )
  {
    debugger;
    return 'x' + arg;
  }

  /* */

  test.case = 'blueprint with untyped instance, implicit';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
  });
  var instance = _.blueprint.construct( Blueprint );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), false );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), false );

  test.identical( instance instanceof Blueprint.Construct, false );
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

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), false );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), false );

  test.identical( instance instanceof Blueprint.Construct, false );
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

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), true );

  test.identical( instance instanceof Blueprint.Construct, true );
  test.identical( Object.getPrototypeOf( Object.getPrototypeOf( instance ) ), _.Construction.prototype );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === instance );
  test.true( prototypes[ 1 ] === Blueprint.Construct.prototype );
  test.true( prototypes[ 2 ] === _.Construction.prototype );
  test.true( _.prototype.hasPrototype( instance, instance ) );
  test.true( _.prototype.hasPrototype( instance, Blueprint.Construct.prototype ) );
  test.true( _.prototype.hasPrototype( instance, _.Construction.prototype ) );
  test.true( _.objectIs( instance ) );
  test.true( !_.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
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
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var instance = Blueprint.Construct();

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), false );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), false );

  test.identical( instance instanceof Blueprint.Construct, false );
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
  var instance = Blueprint.Construct();

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), true );

  test.identical( instance instanceof Blueprint.Construct, true );
  test.identical( Object.getPrototypeOf( Object.getPrototypeOf( instance ) ), _.Construction.prototype );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === instance );
  test.true( prototypes[ 1 ] === Blueprint.Construct.prototype );
  test.true( prototypes[ 2 ] === _.Construction.prototype );
  test.true( _.prototype.hasPrototype( instance, instance ) );
  test.true( _.prototype.hasPrototype( instance, Blueprint.Construct.prototype ) );
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
  var instance = new Blueprint.Construct();

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), false );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), false );

  test.identical( instance instanceof Blueprint.Construct, false );
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
  var instance = new Blueprint.Construct();

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), true );

  test.identical( instance instanceof Blueprint.Construct, true );
  test.identical( Object.getPrototypeOf( Object.getPrototypeOf( instance ) ), _.Construction.prototype );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === instance );
  test.true( prototypes[ 1 ] === Blueprint.Construct.prototype );
  test.true( prototypes[ 2 ] === _.Construction.prototype );
  test.true( _.prototype.hasPrototype( instance, instance ) );
  test.true( _.prototype.hasPrototype( instance, Blueprint.Construct.prototype ) );
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
    debugger;
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
  var instance = Blueprint.Construct( opts );

  test.true( instance !== opts );
  var exp = { field1 : 13 }
  test.identical( instance, exp );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), false );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), false );

  test.identical( instance instanceof Blueprint.Construct, false );
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
  var instance = Blueprint.Construct( opts );

  test.true( instance !== opts );
  var exp = { field1 : 13 }
  test.containsAll( instance, exp );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), true );

  test.identical( instance instanceof Blueprint.Construct, true );
  test.identical( Object.getPrototypeOf( Object.getPrototypeOf( instance ) ), _.Construction.prototype );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === instance );
  test.true( prototypes[ 1 ] === Blueprint.Construct.prototype );
  test.true( prototypes[ 2 ] === _.Construction.prototype );
  test.true( _.prototype.hasPrototype( instance, instance ) );
  test.true( _.prototype.hasPrototype( instance, Blueprint.Construct.prototype ) );
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
  var instance = new Blueprint.Construct( opts );

  test.true( instance !== opts );
  var exp = { field1 : 13 }
  test.identical( instance, exp );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), false );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), false );

  test.identical( instance instanceof Blueprint.Construct, false );
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
  var instance = new Blueprint.Construct( opts );

  test.true( instance !== opts );
  var exp = { field1 : 13 }
  test.containsOnly( instance, exp );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance ), true );
  test.identical( _.construction.isInstanceOf( instance, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance ), true );

  test.identical( instance instanceof Blueprint.Construct, true );
  test.identical( Object.getPrototypeOf( Object.getPrototypeOf( instance ) ), _.Construction.prototype );
  test.identical( instance.constructor, undefined );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === instance );
  test.true( prototypes[ 1 ] === Blueprint.Construct.prototype );
  test.true( prototypes[ 2 ] === _.Construction.prototype );
  test.true( _.prototype.hasPrototype( instance, instance ) );
  test.true( _.prototype.hasPrototype( instance, Blueprint.Construct.prototype ) );
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
    debugger;
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
  var instance = Blueprint.Construct( opts );

  test.true( instance !== opts );
  var exp = { field1 : rfield, fieldBad : 13 }
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint.Construct, false );

  /* */

  test.case = 'extendable:1, without new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
    extendable : _.trait.extendable(),
  });
  var opts = { fieldBad : 13 };
  var instance = Blueprint.Construct( opts );

  test.true( instance !== opts );
  var exp = { field1 : rfield, fieldBad : 13 }
  test.containsOnly( instance, exp );
  test.identical( instance instanceof Blueprint.Construct, true );

  /* */

  test.case = 'extendable:1, with new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
    extendable : _.trait.extendable(),
  });
  var opts = { fieldBad : 13 };
  var instance = new Blueprint.Construct( opts );

  test.true( instance !== opts );
  var exp = { field1 : rfield, fieldBad : 13 }
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint.Construct, false );

  /* */

  test.case = 'extendable:1, with new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
    extendable : _.trait.extendable(),
  });
  var opts = { fieldBad : 13 };
  var instance = new Blueprint.Construct( opts );

  test.true( instance !== opts );
  var exp = { field1 : rfield, fieldBad : 13 }
  test.containsOnly( instance, exp );
  test.identical( instance instanceof Blueprint.Construct, true );

  /* */

  test.case = 'extendable:0, without new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
    extendable : _.trait.extendable( false ),
  });
  var opts = { fieldBad : 13 };
  test.shouldThrowErrorSync( () => Blueprint.Construct( opts ) );

  /* */

  test.case = 'extendable:0, without new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
    extendable : _.trait.extendable( false ),
  });
  var opts = { fieldBad : 13 };
  test.shouldThrowErrorSync( () => Blueprint.Construct( opts ) );

  /* */

  test.case = 'extendable:0, with new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
    extendable : _.trait.extendable( false ),
  });
  var opts = { fieldBad : 13 };
  test.shouldThrowErrorSync( () => new Blueprint.Construct( opts ) );

  /* */

  test.case = 'extendable:0, with new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
    extendable : _.trait.extendable( false ),
  });
  var opts = { fieldBad : 13 };
  test.shouldThrowErrorSync( () => new Blueprint.Construct( opts ) );

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
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var opts = { field1 : 13 };
  var instance1 = Blueprint.Construct( opts );
  var instance2 = Blueprint.Construct( instance1 );

  test.true( instance1 !== opts );
  test.true( instance2 !== opts );
  test.true( instance1 !== instance2 );
  var exp = { field1 : 13 }
  test.containsOnly( instance2, exp );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance2 ), false );
  test.identical( _.construction.isInstanceOf( instance2, Blueprint ), false );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance2 ), false );

  test.identical( instance2 instanceof Blueprint.Construct, false );
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
  var instance1 = Blueprint.Construct( opts );
  var instance2 = Blueprint.Construct( instance1 );

  test.true( instance1 !== opts );
  test.true( instance2 !== opts );
  test.true( instance1 === instance2 );
  var exp = { field1 : 13 }
  test.containsOnly( instance2, exp );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance2 ), true );
  test.identical( _.construction.isInstanceOf( instance2, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance2 ), true );

  test.identical( instance2 instanceof Blueprint.Construct, true );
  test.identical( Object.getPrototypeOf( Object.getPrototypeOf( instance2 ) ), _.Construction.prototype );
  test.identical( instance2.constructor, undefined );
  var prototypes = _.prototype.each( instance2 );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === instance2 );
  test.true( prototypes[ 1 ] === Blueprint.Construct.prototype );
  test.true( prototypes[ 2 ] === _.Construction.prototype );
  test.true( _.prototype.hasPrototype( instance2, instance2 ) );
  test.true( _.prototype.hasPrototype( instance2, Blueprint.Construct.prototype ) );
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
  var instance1 = new Blueprint.Construct( opts );
  var instance2 = new Blueprint.Construct( instance1 );

  test.true( instance1 !== opts );
  test.true( instance2 !== opts );
  test.true( instance1 !== instance2 );
  var exp = { field1 : 13 }
  test.containsOnly( instance2, exp );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance2 ), false );
  test.identical( _.construction.isInstanceOf( instance2, Blueprint ), false );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance2 ), false );

  test.identical( instance2 instanceof Blueprint.Construct, false );
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
  var instance1 = new Blueprint.Construct( opts );
  var instance2 = new Blueprint.Construct( instance1 );

  test.true( instance1 !== opts );
  test.true( instance2 !== opts );
  test.true( instance1 !== instance2 );
  var exp = { field1 : 13 }
  test.containsOnly( instance2, exp );

  test.identical( _.blueprint.is( Blueprint ), true );
  test.identical( _.construction.isTyped( instance2 ), true );
  test.identical( _.construction.isInstanceOf( instance2, Blueprint ), true );
  test.identical( _.blueprint.isBlueprintOf( Blueprint, instance2 ), true );

  test.identical( instance2 instanceof Blueprint.Construct, true );
  test.identical( Object.getPrototypeOf( Object.getPrototypeOf( instance2 ) ), _.Construction.prototype );
  test.identical( instance2.constructor, undefined );
  var prototypes = _.prototype.each( instance2 );
  test.identical( prototypes.length, 3 );
  test.true( prototypes[ 0 ] === instance2 );
  test.true( prototypes[ 1 ] === Blueprint.Construct.prototype );
  test.true( prototypes[ 2 ] === _.Construction.prototype );
  test.true( _.prototype.hasPrototype( instance2, instance2 ) );
  test.true( _.prototype.hasPrototype( instance2, Blueprint.Construct.prototype ) );
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

function constructWithArgumentLong( test )
{

  function rfield( arg )
  {
    debugger;
    return 'x' + arg;
  }

  /* */

  test.case = 'without new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var args = [ { field1 : 1 }, new Blueprint.Construct({ field1 : 2 }), Blueprint.Construct() ];
  var instances = Blueprint.Construct( args );

  test.true( instances !== args );
  test.true( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.containsOnly( instances[ 0 ], exp );
  test.identical( instances[ 0 ] instanceof Blueprint.Construct, false );
  test.true( instances[ 0 ] !== args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.Construct, false );
  test.true( instances[ 1 ] !== args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.Construct, false );
  test.true( instances[ 2 ] !== args[ 2 ] );

  /* */

  test.case = 'without new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var args = [ { field1 : 1 }, new Blueprint.Construct({ field1 : 2 }), Blueprint.Construct() ];
  var instances = Blueprint.Construct( args );

  test.true( instances !== args );
  test.true( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.containsOnly( instances[ 0 ], exp );
  test.identical( instances[ 0 ] instanceof Blueprint.Construct, true );
  test.true( instances[ 0 ] !== args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.Construct, true );
  test.true( instances[ 1 ] === args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.Construct, true );
  test.true( instances[ 2 ] === args[ 2 ] );

  /* */

  test.case = 'with new, blueprint with untyped instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( false ),
  });
  var args = [ { field1 : 1 }, new Blueprint.Construct({ field1 : 2 }), Blueprint.Construct() ];
  var instances = new Blueprint.Construct( args );

  test.true( instances !== args );
  test.true( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.containsOnly( instances[ 0 ], exp );
  test.identical( instances[ 0 ] instanceof Blueprint.Construct, false );
  test.true( instances[ 0 ] !== args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.Construct, false );
  test.true( instances[ 1 ] !== args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.Construct, false );
  test.true( instances[ 2 ] !== args[ 2 ] );

  /* */

  test.case = 'with new, blueprint with typed instance';
  var Blueprint = _.Blueprint
  ({
    field1 : rfield,
    typed : _.trait.typed( true ),
  });
  var args = [ { field1 : 1 }, new Blueprint.Construct({ field1 : 2 }), Blueprint.Construct() ];
  var instances = new Blueprint.Construct( args );

  test.true( instances !== args );
  test.true( _.arrayIs( instances ) );
  var exp = { field1 : 1 }
  test.containsOnly( instances[ 0 ], exp );
  test.identical( instances[ 0 ] instanceof Blueprint.Construct, true );
  test.true( instances[ 0 ] !== args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.Construct, true );
  test.true( instances[ 1 ] !== args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.Construct, true );
  test.true( instances[ 2 ] !== args[ 2 ] );

  /* */

}

constructWithArgumentLong.description =
`
- Construct with long in argument produce array with instances
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

  var Blueprint1 = _.Blueprint
  ({
    field1 : null,
  });
  var instance = _.blueprint.construct( Blueprint1 );
  instance.field1 = _getter;

  var prototypes = _.prototype.each( _.Blueprint );
  test.identical( prototypes.length, 1 ); debugger;
  var prototypes = _.prototype.each( _.blueprint );
  test.identical( prototypes.length, 1 );
  test.true( prototypes[ 0 ] === _.blueprint );

  var prototypes = _.prototype.each( Blueprint1 );
  test.identical( prototypes.length, 2 ); debugger;
  test.true( prototypes[ 0 ] === Blueprint1 );
  test.true( prototypes[ 1 ] === _.Blueprint );
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

function constructWithNewAndHelper( test )
{

  function _getter( arg )
  {
    debugger;
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
  test.identical( prototypes.length, 2 );
  test.true( prototypes[ 0 ] === Blueprint );
  test.true( prototypes[ 1 ] === _.Blueprint );
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

function constructExtendable( test )
{

  function rfield( arg )
  {
    debugger;
    return 'x' + arg;
  }

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

}

constructExtendable.description =
`
- blueprint without trait extandable is not extenable
- blueprint with trait extandable with argument false is not extenable
- blueprint with trait extandable is extenable
- blueprint with trait extandable without argument is extenable
`

//

function definitionExtensionBasic( test )
{

  /* */

  test.case = 'not typed -> not typed';
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
  var instance = Blueprint2.Construct();
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint1.Construct, false );
  test.identical( instance instanceof Blueprint2.Construct, false );

  /* */

  test.case = 'not typed -> typed';
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
  var instance = Blueprint2.Construct();
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint1.Construct, false );
  test.identical( instance instanceof Blueprint2.Construct, false );

  /* */

  test.case = 'typed -> not typed';
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
  var instance = Blueprint2.Construct();
  test.containsOnly( instance, exp );
  test.identical( instance instanceof Blueprint1.Construct, false );
  test.identical( instance instanceof Blueprint2.Construct, true );

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
  var instance = Blueprint2.Construct();
  test.containsOnly( instance, exp );
  test.identical( instance instanceof Blueprint1.Construct, false );
  test.identical( instance instanceof Blueprint2.Construct, true );

  /* */

}

definitionExtensionBasic.description =
`
- blueprint extend another blueprint by fields
- blueprint extend another blueprint by traits
`

//

function definitionSupplementationBasic( test )
{

  /* */

  test.case = 'not typed -> not typed';
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
  var instance = Blueprint2.Construct();
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint1.Construct, false );
  test.identical( instance instanceof Blueprint2.Construct, false );

  /* */

  test.case = 'not typed -> typed';
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
  var instance = Blueprint2.Construct();
  test.containsOnly( instance, exp );
  test.identical( instance instanceof Blueprint1.Construct, false );
  test.identical( instance instanceof Blueprint2.Construct, true );

  /* */

  test.case = 'typed -> not typed';
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
  var instance = Blueprint2.Construct();
  test.containsOnly( instance, exp );
  test.identical( instance instanceof Blueprint1.Construct, false );
  test.identical( instance instanceof Blueprint2.Construct, false );

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
  var instance = Blueprint2.Construct();
  test.containsOnly( instance, exp );
  test.identical( instance instanceof Blueprint1.Construct, false );
  test.identical( instance instanceof Blueprint2.Construct, true );

  /* */

}

definitionSupplementationBasic.description =
`
- blueprint supplement another blueprint by fields
- blueprint supplement another blueprint by traits
`

//

function definitionExtensionOrder( test )
{

  /* */

  test.case = 'blueprint1'; /* */

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1' ),
    staticField2 : _.define.static( 'b1' ),
  });

  var instance = Blueprint1.Construct();
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

  test.case = 'extension before';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1' ),
    staticField2 : _.define.static( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    extension : _.define.extension( Blueprint1 ),
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
  });

  var instance = Blueprint2.Construct();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

  test.case = 'extension before, extension.blueprintDepthReserve:Infinity';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1' ),
    staticField2 : _.define.static( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    extension : _.define.extension( Blueprint1, { blueprintDepthReserve : Infinity } ),
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
  });

  var instance = Blueprint2.Construct();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

  test.case = 'extension before, static.blueprintDepthReserve:Infinity';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1', { blueprintDepthReserve : Infinity } ),
    staticField2 : _.define.static( 'b1', { blueprintDepthReserve : Infinity } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    extension : _.define.extension( Blueprint1 ),
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
  });

  var instance = Blueprint2.Construct();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

  test.case = 'extension after';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1' ),
    staticField2 : _.define.static( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    extension : _.define.extension( Blueprint1 ),
  });

  var instance = Blueprint2.Construct();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'field3' : 'b2',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

  test.case = 'extension after, field.blueprintDepthLimit:1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1', { blueprintDepthLimit : 1 } ),
    staticField2 : _.define.static( 'b1', { blueprintDepthLimit : 1 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    extension : _.define.extension( Blueprint1 ),
  });

  var instance = Blueprint2.Construct();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'field3' : 'b2',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

  test.case = 'extension after, field.blueprintDepthReserve:Infinity';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1', { blueprintDepthReserve : Infinity } ),
    staticField2 : _.define.static( 'b1', { blueprintDepthReserve : Infinity } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    extension : _.define.extension( Blueprint1 ),
  });

  var instance = Blueprint2.Construct();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

  test.case = 'extension after, field.blueprintDepthReserve:1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1', { blueprintDepthReserve : 1 } ),
    staticField2 : _.define.static( 'b1', { blueprintDepthReserve : 1 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    extension : _.define.extension( Blueprint1 ),
  });

  var instance = Blueprint2.Construct();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

  test.case = 'extension after, field.blueprintDepthLimit:0';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1', { blueprintDepthLimit : 0 } ),
    staticField2 : _.define.static( 'b1', { blueprintDepthLimit : 0 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    extension : _.define.extension( Blueprint1 ),
  });

  var instance = Blueprint2.Construct();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

  test.case = 'extension after, extension.blueprintDepthReserve:Infinity';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1' ),
    staticField2 : _.define.static( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    extension : _.define.extension( Blueprint1, { blueprintDepthReserve : Infinity } ),
  });

  var instance = Blueprint2.Construct();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

}

definitionExtensionOrder.description =
`
- order of definition::extension makes difference
`

//

function definitionSupplementationOrder( test )
{

  /* */

  test.case = 'blueprint1'; /* */

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1' ),
    staticField2 : _.define.static( 'b1' ),
  });

  var instance = Blueprint1.Construct();
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

  test.case = 'supplementation before';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1' ),
    staticField2 : _.define.static( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    supplementation : _.define.supplementation( Blueprint1 ),
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
  });

  var instance = Blueprint2.Construct();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

  test.case = 'supplementation before, supplementation.blueprintDepthReserve:Infinity';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1' ),
    staticField2 : _.define.static( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    supplementation : _.define.supplementation( Blueprint1, { blueprintDepthReserve : Infinity } ),
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
  });

  var instance = Blueprint2.Construct();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

  test.case = 'supplementation before, static.blueprintDepthReserve:Infinity';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1', { blueprintDepthReserve : Infinity } ),
    staticField2 : _.define.static( 'b1', { blueprintDepthReserve : Infinity } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    supplementation : _.define.supplementation( Blueprint1 ),
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
  });

  var instance = Blueprint2.Construct();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

  test.case = 'supplementation after';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1' ),
    staticField2 : _.define.static( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var instance = Blueprint2.Construct();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

  test.case = 'supplementation after, field.blueprintDepthLimit:1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1', { blueprintDepthLimit : 1 } ),
    staticField2 : _.define.static( 'b1', { blueprintDepthLimit : 1 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var instance = Blueprint2.Construct();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

  test.case = 'supplementation after, field.blueprintDepthReserve:Infinity';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1', { blueprintDepthReserve : Infinity } ),
    staticField2 : _.define.static( 'b1', { blueprintDepthReserve : Infinity } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var instance = Blueprint2.Construct();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

  test.case = 'supplementation after, field.blueprintDepthReserve:1';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1', { blueprintDepthReserve : 1 } ),
    staticField2 : _.define.static( 'b1', { blueprintDepthReserve : 1 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var instance = Blueprint2.Construct();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

  test.case = 'supplementation after, field.blueprintDepthLimit:0';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1', { blueprintDepthLimit : 0 } ),
    staticField2 : _.define.static( 'b1', { blueprintDepthLimit : 0 } ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var instance = Blueprint2.Construct();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

  test.case = 'supplementation after, supplementation.blueprintDepthReserve:Infinity';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : _.define.static( 'b1' ),
    staticField2 : _.define.static( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : _.define.static( 'b2' ),
    staticField3 : _.define.static( 'b2' ),
    supplementation : _.define.supplementation( Blueprint1, { blueprintDepthReserve : Infinity } ),
  });

  var instance = Blueprint2.Construct();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );

  /* */

}

definitionSupplementationOrder.description =
`
- order of definition::supplementation makes difference
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
  var Blueprint1 = _.Blueprint
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

  var instance = Blueprint1.Construct();
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'staticField1' : 'sf1',
    'staticField2' : { 'k' : 'staticField2' },
    'staticField3' : 'sf3',
    'staticField4' : { 'k' : 'staticField4' },
    'staticField5' : { 'k' : 'staticField5' },
    'staticField6' : { 'k' : 'staticField6' }
  };
  test.identical( _.mapFields( instance ), exp );

  var exp = { 'field1' : 'b1', 'field2' : 'b1' };
  test.identical( _.mapOwnFields( instance ), exp );

  test.identical( instance instanceof Blueprint1.Construct, true );
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
    staticField1 : s( 'b1' ),
    staticField2 : s( 'b1' ),
  });

  var instance = Blueprint1.Construct();
  test.identical( instance instanceof Blueprint1.Construct, true );

  test.identical( _.prototype.each( instance ).length, 3 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( _.mapAllProperties( instance ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    'staticField1' : 'b1', 'staticField2' : 'b1'
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 2 ] ), exp );

  test.description = 'blueprint2'; /* */

  var Blueprint2 = _.Blueprint
  ({
    extension : _.define.extension( Blueprint1 ),
    prototype : _.trait.prototype( Blueprint1 ),
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : s( 'b2' ),
    staticField3 : s( 'b2' ),
  });

  var instance = Blueprint2.Construct();

  test.identical( instance instanceof Blueprint1.Construct, true );
  test.identical( instance instanceof Blueprint2.Construct, true );

  test.identical( _.prototype.each( instance ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    'staticField2' : 'b2', 'staticField3' : 'b2'
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
    'staticField1' : 'b1', 'staticField2' : 'b1'
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 3 ] ), exp );

  test.description = 'control blueprint1'; /* */

  var instance = Blueprint1.Construct();
  test.identical( instance instanceof Blueprint1.Construct, true );
  test.identical( instance instanceof Blueprint2.Construct, false );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  var got = _.mapAllProperties( instance );
  test.identical( got, exp );

  test.description = 'blueprint3'; /* */

  var Blueprint3 = _.Blueprint
  ({
    extend : _.define.extension( Blueprint2 ),
    prototype : _.trait.prototype( Blueprint2 ),
    'field3' : 'b3',
    'field4' : 'b3',
    staticField3 : s( 'b3' ),
    staticField4 : s( 'b3' ),
  });

  var instance = Blueprint3.Construct();

  test.identical( instance instanceof Blueprint1.Construct, true );
  test.identical( instance instanceof Blueprint2.Construct, true );
  test.identical( instance instanceof Blueprint3.Construct, true );

  test.identical( _.prototype.each( instance ).length, 5 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b3',
    'field4' : 'b3',
    'staticField3' : 'b3',
    'staticField4' : 'b3',
    'staticField1' : 'b1',
    'staticField2' : 'b2'
  }
  test.identical( _.mapAllProperties( instance ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b3',
    'field4' : 'b3',
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    'staticField3' : 'b3', 'staticField4' : 'b3'
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
    'staticField2' : 'b2', 'staticField3' : 'b2'
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 2 ] ), exp );
  var exp =
  {
    'staticField1' : 'b1', 'staticField2' : 'b1'
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 3 ] ), exp );
  var exp =
  {
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 4 ] ), exp );

  /* */

}

blueprintInheritManually.description =
`
- defintition prototype makes another blueprint prototype of instance of the blueprint
`

//

function blueprintInheritWithTrait( test )
{

  /* */

  test.case = 'with trait inherit';

  let s = _.define.static;
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed( true ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : s( 'b1' ),
    staticField2 : s( 'b1' ),
  });

  test.description = 'blueprint1'; /* */

  var instance = Blueprint1.Construct();
  test.identical( instance instanceof Blueprint1.Construct, true );

  test.identical( _.prototype.each( instance ).length, 3 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( _.mapAllProperties( instance ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    'staticField1' : 'b1', 'staticField2' : 'b1'
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 2 ] ), exp );

  test.description = 'blueprint2'; /* */

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : s( 'b2' ),
    staticField3 : s( 'b2' ),
  });

  var instance = Blueprint2.Construct();

  test.identical( instance instanceof Blueprint1.Construct, true );
  test.identical( instance instanceof Blueprint2.Construct, true );

  test.identical( _.prototype.each( instance ).length, 4 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.mapAllProperties( instance ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    'staticField2' : 'b2', 'staticField3' : 'b2'
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
    'staticField1' : 'b1', 'staticField2' : 'b1'
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 3 ] ), exp );

  test.description = 'control blueprint1'; /* */

  var instance = Blueprint1.Construct();
  test.identical( instance instanceof Blueprint1.Construct, true );
  test.identical( instance instanceof Blueprint2.Construct, false );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  var got = _.mapAllProperties( instance );
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

  var instance = Blueprint3.Construct();

  test.identical( instance instanceof Blueprint1.Construct, true );
  test.identical( instance instanceof Blueprint2.Construct, true );
  test.identical( instance instanceof Blueprint3.Construct, true );

  test.identical( _.prototype.each( instance ).length, 5 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b3',
    'field4' : 'b3',
    'staticField3' : 'b3',
    'staticField4' : 'b3',
    'staticField1' : 'b1',
    'staticField2' : 'b2'
  }
  test.identical( _.mapAllProperties( instance ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b3',
    'field4' : 'b3',
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    'staticField3' : 'b3', 'staticField4' : 'b3'
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
    'staticField2' : 'b2', 'staticField3' : 'b2'
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 2 ] ), exp );
  var exp =
  {
    'staticField1' : 'b1', 'staticField2' : 'b1'
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 3 ] ), exp );
  var exp =
  {
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 4 ] ), exp );

  /* */

}

blueprintInheritWithTrait.description =
`
- blueprint inheritance with trait
`

//

function blueprintWithConstructor( test )
{

  /* */

  test.case = 'with trait inherit';

  let s = _.define.static;
  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ typed : true, withConstructor : true }),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : s( 'b1' ),
    staticField2 : s( 'b1' ),
  });

  test.description = 'blueprint1'; /* */

  var instance = Blueprint1.Construct();
  test.identical( instance instanceof Blueprint1.Construct, true );
  test.true( _.routineIs( instance.constructor ) );

  test.identical( _.prototype.each( instance ).length, 3 );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    'field1' : 'b1',
    'field2' : 'b1',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( _.mapAllProperties( instance ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( _.mapOwnProperties( _.prototype.each( instance )[ 2 ] ), exp );

  // xxx
  // test.description = 'blueprint2'; /* */
  //
  // var Blueprint2 = _.Blueprint
  // ({
  //   inherit : _.define.inherit( Blueprint1 ),
  //   field2 : 'b2',
  //   field3 : 'b2',
  //   staticField2 : s( 'b2' ),
  //   staticField3 : s( 'b2' ),
  // });
  //
  // var instance = Blueprint2.Construct();
  //
  // test.identical( instance instanceof Blueprint1.Construct, true );
  // test.identical( instance instanceof Blueprint2.Construct, true );
  //
  // test.identical( _.prototype.each( instance ).length, 4 );
  // var exp =
  // {
  //   'field1' : 'b1',
  //   'field2' : 'b2',
  //   'field3' : 'b2',
  //   'staticField1' : 'b1',
  //   'staticField2' : 'b2',
  //   'staticField3' : 'b2',
  // }
  // test.identical( _.mapAllProperties( instance ), exp );

  /* */

}

blueprintWithConstructor.description =
`
- blueprint inheritance with trait
`

//

function orderOfDefinitions( test )
{

  /* */

  test.case = 'extension';

  var Blueprint1 = _.Blueprint
  ({
    field1 : null,
  });

  var Blueprint2 = _.Blueprint
  ({
    typed : _.trait.typed(),
    prototype : _.trait.prototype( Blueprint1 ),
    extension : _.define.extension( Blueprint1 ),
  });

  var Blueprint3 = _.Blueprint
  ({
    prototype : _.trait.prototype( Blueprint1 ),
    extension : _.define.extension( Blueprint1 ),
    typed : _.trait.typed(),
  });

  var instance1 = _.blueprint.construct( Blueprint1 );
  var prototypes1 = _.prototype.each( instance1 );
  test.identical( prototypes1.length, 1 );

  var instance2 = _.blueprint.construct( Blueprint2 );
  var prototypes2 = _.prototype.each( instance2 );
  test.identical( prototypes2.length, 1 );

  var instance3 = _.blueprint.construct( Blueprint3 );
  var prototypes3 = _.prototype.each( instance3 );
  test.identical( prototypes3.length, 4 );
  test.true( prototypes3[ 0 ] === instance3 );
  test.true( prototypes3[ 1 ] === Blueprint3.Construct.prototype );
  test.true( prototypes3[ 2 ] === Blueprint1.Construct.prototype );
  test.true( prototypes3[ 3 ] === _.Construction.prototype );

  /* */

  test.case = 'supplementation';

  var Blueprint1 = _.Blueprint
  ({
    field1 : null,
  });

  var Blueprint2 = _.Blueprint
  ({
    typed : _.trait.typed(),
    prototype : _.trait.prototype( Blueprint1 ),
    supplementation : _.define.supplementation( Blueprint1 ),
  });

  var Blueprint3 = _.Blueprint
  ({
    prototype : _.trait.prototype( Blueprint1 ),
    supplementation : _.define.supplementation( Blueprint1 ),
    typed : _.trait.typed(),
  });

  var instance1 = _.blueprint.construct( Blueprint1 );
  var prototypes1 = _.prototype.each( instance1 );
  test.identical( prototypes1.length, 1 );

  var instance2 = _.blueprint.construct( Blueprint2 );
  var prototypes2 = _.prototype.each( instance2 );
  test.identical( prototypes2.length, 4 );
  test.true( prototypes2[ 0 ] === instance2 );
  test.true( prototypes2[ 1 ] === Blueprint2.Construct.prototype );
  test.true( prototypes2[ 2 ] === Blueprint1.Construct.prototype );
  test.true( prototypes2[ 3 ] === _.Construction.prototype );

  var instance3 = _.blueprint.construct( Blueprint3 );
  var prototypes3 = _.prototype.each( instance3 );
  test.identical( prototypes3.length, 4 );
  test.true( prototypes3[ 0 ] === instance3 );
  test.true( prototypes3[ 1 ] === Blueprint3.Construct.prototype );
  test.true( prototypes3[ 2 ] === Blueprint1.Construct.prototype );
  test.true( prototypes3[ 3 ] === _.Construction.prototype );

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
  test.identical( prototypes.length, 2 );
  test.true( prototypes[ 0 ] === Blueprint2 );
  test.true( prototypes[ 1 ] === _.Blueprint );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 4 );
  test.true( prototypes[ 0 ] === instance );
  test.true( prototypes[ 1 ] === Blueprint2.Construct.prototype );
  test.true( prototypes[ 2 ] === Blueprint1.Construct.prototype );
  test.true( prototypes[ 3 ] === _.Construction.prototype );

  test.true( _.prototype.hasPrototype( instance, Blueprint1.Construct.prototype ) );
  test.true( _.prototype.hasPrototype( instance, Blueprint2.Construct.prototype ) );
  test.true( _.objectIs( instance ) );
  test.true( !_.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
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

  var Blueprint1 = _.Blueprint
  ({
    field1 : null,
  });

  var Blueprint2 = _.Blueprint
  ({
    field2 : null,
  });

  var Blueprint3 = _.Blueprint( Blueprint1, Blueprint2, { field3 : '3' } );
  var instance = _.blueprint.construct( Blueprint3 );

  var exp = { 'field1' : null, 'field2' : null, 'field3' : '3' };
  test.containsOnly( instance, exp );

  var exp = { 'field1' : null, 'field2' : null, 'field3' : '3' };
  var got = _.mapAllProperties( instance );
  test.identical( got, exp );

  var prototypes = _.prototype.each( _.Blueprint );
  test.identical( prototypes.length, 1 );
  test.true( prototypes[ 0 ] === _.Blueprint );
  var prototypes = _.prototype.each( Blueprint3 );
  test.identical( prototypes.length, 2 );
  test.true( prototypes[ 0 ] === Blueprint3 );
  test.true( prototypes[ 1 ] === _.Blueprint );
  var prototypes = _.prototype.each( instance );
  test.identical( prototypes.length, 4 );
  test.true( prototypes[ 0 ] === instance );
  test.true( prototypes[ 1 ] === Blueprint3.Construct.prototype );
  test.true( prototypes[ 2 ] === Blueprint2.Construct.prototype );
  test.true( prototypes[ 3 ] === _.Construction.prototype );

  test.true( !_.prototype.hasPrototype( instance, Blueprint1.Construct.prototype ) );
  test.true( _.prototype.hasPrototype( instance, Blueprint2.Construct.prototype ) );
  test.true( _.prototype.hasPrototype( instance, Blueprint3.Construct.prototype ) );
  test.true( _.objectIs( instance ) );
  test.true( !_.mapIs( instance ) );
  test.true( _.mapLike( instance ) );
  test.true( !_.instanceIs( instance ) );
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
//   var Blueprint1 = _.Blueprint
//   ({
//     functor : null,
//     '__call__' : _.define.ownerCallback( 'functor' ),
//   });
//
//   var instance = _.blueprint.construct( Blueprint1 );
//   instance.functor = _getter;
//
//   debugger;
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
//   debugger;
//
//   test.true( _.prototype.hasPrototype( instance, Blueprint1 ) );
//   test.true( _.routineIs( instance ) );
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

  var Blueprint1 = _.Blueprint
  ({
    field1 : null,
  });

  var Blueprint2 = _.Blueprint( Blueprint1 );

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
  var instance1 = blueprint.Construct();
  var instance2 = blueprint.Construct();
  var exp =
  {
    array : [ [] ],
    map : { k : [] },
  }

  test.containsOnly( instance1, exp );
  test.identical( instance1 instanceof blueprint.Construct, true );
  test.containsOnly( instance2, exp );
  test.identical( instance2 instanceof blueprint.Construct, true );
  test.true( instance1.array !== instance2.array );
  test.true( instance1.map !== instance2.map );
  test.true( instance1.array[ 0 ] === instance2.array[ 0 ] );
  test.true( instance1.map.k === instance2.map.k );

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
  test.true( instance1.array !== instance2.array );
  test.true( instance1.map !== instance2.map );
  test.true( instance1.array[ 0 ] === instance2.array[ 0 ] );
  test.true( instance1.map.k === instance2.map.k );
*/

  /* */

}

complexFields.description =
`
- shortcut shallow define definition field with iniToIns:shallow
`

//

function compileSourceCode( test )
{

  /* */

  var e = [];
  var blueprint = _.blueprint.define
  ({
    typed : _.trait.typed(),
    array : _.define.shallow( [ e ] ),
    map : _.define.shallow( { k : e } ),
  });
  var instance1 = blueprint.Construct();
  var instance2 = blueprint.Construct();
  var exp =
  {
    array : [ [] ],
    map : { k : [] },
  }

  test.containsOnly( instance1, exp );
  test.identical( instance1 instanceof blueprint.Construct, true );
  test.containsOnly( instance2, exp );
  test.identical( instance2 instanceof blueprint.Construct, true );
  test.true( instance1.array !== instance2.array );
  test.true( instance1.map !== instance2.map );
  test.true( instance1.array[ 0 ] === instance2.array[ 0 ] );
  test.true( instance1.map.k === instance2.map.k );

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
  test.true( instance1.array !== instance2.array );
  test.true( instance1.map !== instance2.map );
  test.true( instance1.array[ 0 ] === instance2.array[ 0 ] );
  test.true( instance1.map.k === instance2.map.k );
*/

  /* */

}

compileSourceCode.description =
`
- xxx
`

//

function defineConstructor( test )
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

defineConstructor.description =
`
- _.blueprint.defineConstructor returns constructor of blueprint
`

//

function reconstruct( test )
{

  /* */

  test.case = 'Construct -- control';
  var blueprint1 = _.Blueprint
  ({
    a : 'a',
    b : '3',
  });
  var src = { a : 'a2' }
  test.identical( Object.getPrototypeOf( src ), Object.prototype );
  var got = blueprint1.Construct( src );
  test.true( Object.getPrototypeOf( got ) === null );
  test.identical( Object.getPrototypeOf( src ), Object.prototype );
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

  test.case = 'untyped to untyped';
  var blueprint1 = _.Blueprint
  ({
    a : 'a',
    b : '3',
  });
  var src = { a : 'a2' }
  test.identical( Object.getPrototypeOf( src ), Object.prototype );
  var got = blueprint1.Reconstruct( src );
  test.true( Object.getPrototypeOf( got ) === null );
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
  var got = blueprint1.Reconstruct( src );
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
  var got = blueprint1.Reconstruct( src );
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
  var got = blueprint1.Reconstruct( src );
  test.true( Object.getPrototypeOf( got ) === blueprint1.Construct.prototype );
  test.true( Object.getPrototypeOf( Object.getPrototypeOf( got ) ) === _.Construction.prototype );
  test.true( got === src );
  var exp =
  {
    a : 'a2',
    b : '3',
  }
  test.identical( _.mapAllProperties( got ), _.mapOwnProperties( exp ) );

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
  var got = blueprint1.Reconstruct( src );
  test.true( Object.getPrototypeOf( got ) === blueprint1.Construct.prototype );
  test.true( Object.getPrototypeOf( Object.getPrototypeOf( got ) ) === _.Construction.prototype );
  test.true( got === src );
  var exp =
  {
    a : 'a2',
    b : '3',
  }
  test.identical( _.mapAllProperties( got ), _.mapOwnProperties( exp ) );

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
  var got = blueprint1.Reconstruct( src );
  test.true( Object.getPrototypeOf( got ) === blueprint1.Construct.prototype );
  test.true( Object.getPrototypeOf( Object.getPrototypeOf( got ) ) === _.Construction.prototype );
  test.true( got === src );
  var exp =
  {
    a : 'a2',
    b : '3',
  }
  test.identical( _.mapAllProperties( got ), _.mapOwnProperties( exp ) );

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
  var got = _.blueprint.reconstruct( blueprint1, src );
  test.true( Object.getPrototypeOf( got ) === blueprint1.Construct.prototype );
  test.true( Object.getPrototypeOf( Object.getPrototypeOf( got ) ) === _.Construction.prototype );
  test.true( got === src );
  var exp =
  {
    a : 'a2',
    b : '3',
  }
  test.identical( _.mapAllProperties( got ), _.mapOwnProperties( exp ) );

  /* */

  test.case = 'typed to same typed';
  var blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed(),
    a : 'a',
    b : '3',
  });
  var prototype = {}
  var src = blueprint1.Construct();
  src.a = 'a2';
  test.true( Object.getPrototypeOf( src ) === blueprint1.Construct.prototype );
  var got = blueprint1.Reconstruct( src );
  test.true( Object.getPrototypeOf( got ) === blueprint1.Construct.prototype );
  test.true( Object.getPrototypeOf( Object.getPrototypeOf( got ) ) === _.Construction.prototype );
  test.true( got === src );
  var exp =
  {
    a : 'a2',
    b : '3',
  }
  test.identical( _.mapAllProperties( got ), _.mapOwnProperties( exp ) );

  /* */

}

// --
// declare
// --

let Self =
{

  name : 'Tools.l2.Blueprint.blueprint',
  silencing : 1,

  tests :
  {

    constructions,
    constructTyped,
    constructWithoutHelper,
    constructWithArgumentMap,
    constructWithArgumentMapUndeclaredFields,
    constructWithArgumentInstance,
    constructWithArgumentLong,
    constructWithHelper,
    constructWithNewAndHelper,
    constructExtendable,

    definitionExtensionBasic,
    definitionSupplementationBasic,
    definitionExtensionOrder,
    definitionSupplementationOrder,

    blueprintStatic,
    blueprintInheritManually,
    blueprintInheritWithTrait,
    blueprintWithConstructor,

    orderOfDefinitions,
    constructSingleReuse,
    constructMultipleReuse,
    is,

    complexFields,
    compileSourceCode,
    defineConstructor,
    reconstruct,

  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
