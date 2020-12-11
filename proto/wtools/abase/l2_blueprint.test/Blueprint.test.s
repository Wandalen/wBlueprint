( function _Blueprint_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../wtools/Tools.s' );
  require( '../../abase/l2_blueprint/Include.s' );
  _.include( 'wReplicator' );
  _.include( 'wTesting' );
}

let _global = _global_;
let _ = _global_.wTools;

/* xxx qqq

 - cover construction.extend() + definition::*

 - allow for _.blueprint.define to have in blueprint other bluprints

*/

// --
// helper
// --

function mapOwnProperties( src )
{
  _.assert( arguments.length === 1 );
  return _.property.own( src, { onlyEnumerable : 0 } );
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

// --
// definition
// --

function definitionProp( test )
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

function definitionProps( test )
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

function definitionPropStaticBasic( test )
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

  var instance = Blueprint1.Make();
  test.identical( instance instanceof Blueprint1.Make, true );

  test.true( !Object.hasOwnProperty.call( instance, 'staticMethod1' ) );
  test.true( !Object.hasOwnProperty.call( instance, 'staticMethod2' ) );
  test.true( !Object.hasOwnProperty.call( instance, 'staticField1' ) );
  test.true( !Object.hasOwnProperty.call( instance, 'staticField2' ) );
  test.true( !Object.hasOwnProperty.call( instance, 'staticField3' ) );
  test.true( !Object.hasOwnProperty.call( instance, 'staticField4' ) );

  test.true( Object.hasOwnProperty.call( Object.getPrototypeOf( instance ), 'staticMethod1' ) );
  test.true( Object.hasOwnProperty.call( Object.getPrototypeOf( instance ), 'staticMethod2' ) );
  test.true( Object.hasOwnProperty.call( Object.getPrototypeOf( instance ), 'staticField1' ) );
  test.true( Object.hasOwnProperty.call( Object.getPrototypeOf( instance ), 'staticField2' ) );
  test.true( Object.hasOwnProperty.call( Object.getPrototypeOf( instance ), 'staticField3' ) );
  test.true( Object.hasOwnProperty.call( Object.getPrototypeOf( instance ), 'staticField4' ) );

  test.description = 'property descriptor'; /* */

  var got = Object.getOwnPropertyDescriptor( Object.getPrototypeOf( instance ), 'staticField1' );
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
    'staticField1' : 'sf1',
    'staticField2' : { 'k' : 'staticField2' },
    'staticField3' : 'sf3',
    'staticField4' : { 'k' : 'staticField4' },
    'staticField5' : { 'k' : 'staticField5' },
    'staticField6' : { 'k' : 'staticField6' }
  }
  test.identical( _.property.all( instance ), exp );

  test.description = 'own properties'; /* */

  test.identical( _.prototype.each( instance ).length, 3 );
  var exp = { 'field1' : 'b1', 'field2' : 'b1', 'method1' : m1 }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    'staticMethod1' : sm1,
    'staticMethod2' : sm2,
    'staticField1' : 'sf1',
    'staticField2' : { 'k' : 'staticField2' },
    'staticField3' : 'sf3',
    'staticField4' : { 'k' : 'staticField4' },
    'staticField5' : { 'k' : 'staticField5' },
    'staticField6' : { 'k' : 'staticField6' }
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 2 ] ), exp );

  test.true( Blueprint1.Make.staticField1 === Blueprint1.prototype.staticField1 );
  test.true( Blueprint1.Make.staticField2 === Blueprint1.prototype.staticField2 );
  test.true( Blueprint1.Make.staticField3 === Blueprint1.prototype.staticField3 );
  test.true( Blueprint1.Make.staticField4 === Blueprint1.prototype.staticField4 );
  test.true( Blueprint1.Make.staticField5 === Blueprint1.prototype.staticField5 );
  test.true( Blueprint1.Make.staticField6 === Blueprint1.prototype.staticField6 );
  test.true( Blueprint1.Make.staticMethod1 === Blueprint1.prototype.staticMethod1 );
  test.true( Blueprint1.Make.staticMethod2 === Blueprint1.prototype.staticMethod2 );

  /* */

}

definitionPropStaticBasic.description =
`
- static fields added to prototype
`

//

function definitionPropStaticInheritance( test )
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
    'method1' : Blueprint1.Props.method1,
    'method2' : Blueprint2.Props.method2,
    'method3' : Blueprint2.Props.method3,
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
    'method1' : Blueprint1.Props.method1,
    'method2' : Blueprint2.Props.method2,
    'method3' : Blueprint2.Props.method3,
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'StaticMethod2' : Blueprint2.prototype.StaticMethod2,
    'StaticMethod3' : Blueprint2.prototype.StaticMethod3,
    'constructor' : Blueprint2.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'StaticMethod1' : Blueprint1.prototype.StaticMethod1,
    'StaticMethod2' : Blueprint1.prototype.StaticMethod2,
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 3 ] ), exp );

  test.description = '_.mapExtend( null, instance1 )'; /* */

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'method1' : Blueprint1.Props.method1,
    'method2' : Blueprint2.Props.method2,
    'method3' : Blueprint2.Props.method3,
  }
  var got = _.mapExtend( null, instance1 );
  test.identical( got, exp );

  test.description = '_.mapExtend( instance1, src )'; /* */

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'new',
    'field3' : 'b2',
    'method1' : Blueprint1.Props.method1,
    'method2' : 'new',
    'method3' : Blueprint2.Props.method3,
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
    'method1' : Blueprint1.Props.method1,
    'method2' : 'new',
    'method3' : Blueprint2.Props.method3,
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'new',
    'StaticField3' : 'new',
    'StaticMethod2' : 'new',
    'StaticMethod3' : Blueprint2.prototype.StaticMethod3,
    'constructor' : Blueprint2.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'new',
    'StaticField2' : 'b1',
    'StaticMethod1' : 'new',
    'StaticMethod2' : Blueprint1.prototype.StaticMethod2,
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 3 ] ), exp );

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

function definitionPropEnumerable( test )
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
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 3 ] ), exp );

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
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 3 ] ), exp );

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
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 3 ] ), exp );

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

function definitionPropWritable( test )
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
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 3 ] ), exp );

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
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 3 ] ), exp );

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
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 3 ] ), exp );

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

function definitionPropConfigurable( test )
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
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 3 ] ), exp );

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
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 3 ] ), exp );
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
  test.identical( mapOwnProperties( Blueprint2.prototype ), exp );
  var exp =
  {
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( Blueprint1.prototype ), exp );

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
  test.identical( mapOwnProperties( Blueprint2.prototype ), exp );
  var exp =
  {
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( Blueprint1.prototype ), exp );

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
  test.identical( mapOwnProperties( Blueprint2.prototype ), exp );
  var exp =
  {
    'StaticField2' : 'new',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( Blueprint1.prototype ), exp );

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
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 3 ] ), exp );

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
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 3 ] ), exp );
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
  test.identical( mapOwnProperties( Blueprint2.prototype ), exp );
  var exp =
  {
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( Blueprint1.prototype ), exp );

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
  test.identical( mapOwnProperties( Blueprint2.prototype ), exp );
  var exp =
  {
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( Blueprint1.prototype ), exp );

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
  test.identical( mapOwnProperties( Blueprint2.prototype ), exp );
  var exp =
  {
    'StaticField2' : 'new',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( Blueprint1.prototype ), exp );

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
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 3 ] ), exp );

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
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 3 ] ), exp );
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
  test.identical( mapOwnProperties( Blueprint2.prototype ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( Blueprint1.prototype ), exp );

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
  test.identical( mapOwnProperties( Blueprint2.prototype ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( Blueprint1.prototype ), exp );

  test.true( Blueprint1.Make.StaticField1 === 'b1' );
  test.true( Blueprint1.Make.StaticField2 === 'b1' );
  test.true( Blueprint1.Make.StaticField3 === undefined );
  test.true( Blueprint2.Make.StaticField1 === 'b1' );
  test.true( Blueprint2.Make.StaticField2 === 'b2' );
  test.true( Blueprint2.Make.StaticField3 === 'b2' );

  /* */

}

//

function definitionProper( test )
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
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 3 ] ), exp );

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
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    'StaticField2' : 'b2',
    'StaticField3' : 'b2',
    'constructor' : Blueprint2.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    'StaticField1' : 'b1',
    'StaticField2' : 'b1',
    'constructor' : Blueprint1.Make
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 3 ] ), exp );

  /* */

}

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
  var instance = Blueprint2.Make();
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint1.Make, false );
  test.identical( instance instanceof Blueprint2.Make, false );

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
  var instance = Blueprint2.Make();
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint1.Make, false );
  test.identical( instance instanceof Blueprint2.Make, false );

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
  var instance = Blueprint2.Make();
  test.identical( instance, exp );
  test.identical( instance instanceof Blueprint1.Make, false );
  test.identical( instance instanceof Blueprint2.Make, false );

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
  var instance = Blueprint2.Make();
  test.containsOnly( instance, exp );
  test.identical( instance instanceof Blueprint1.Make, false );
  test.identical( instance instanceof Blueprint2.Make, true );

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
  var instance = Blueprint2.Make();
  test.containsOnly( instance, exp );
  test.identical( instance instanceof Blueprint1.Make, false );
  test.identical( instance instanceof Blueprint2.Make, false );

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

  var instance = Blueprint1.Make();
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( _.property.all( instance ), exp );

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

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField2' : 'b2',
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

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
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

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
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

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'field3' : 'b2',
    'staticField2' : 'b2',
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

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'field3' : 'b2',
    'staticField2' : 'b2',
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

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
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

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
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

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
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

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

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

  var instance = Blueprint1.Make();
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( _.property.all( instance ), exp );

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

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField2' : 'b2',
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

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
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

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
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

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField2' : 'b2',
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

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField2' : 'b2',
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

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
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

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
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

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
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

  var instance = Blueprint2.Make();

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );

  /* */

}

definitionSupplementationOrder.description =
`
- order of definition::supplementation makes difference
`

//

function definitionsOrder( test )
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
  test.true( prototypes3[ 1 ] === Blueprint3.Make.prototype );
  test.true( prototypes3[ 2 ] === Blueprint1.Make.prototype );
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
  test.true( prototypes2[ 1 ] === Blueprint2.Make.prototype );
  test.true( prototypes2[ 2 ] === Blueprint1.Make.prototype );
  test.true( prototypes2[ 3 ] === _.Construction.prototype );

  var instance3 = _.blueprint.construct( Blueprint3 );
  var prototypes3 = _.prototype.each( instance3 );
  test.identical( prototypes3.length, 4 );
  test.true( prototypes3[ 0 ] === instance3 );
  test.true( prototypes3[ 1 ] === Blueprint3.Make.prototype );
  test.true( prototypes3[ 2 ] === Blueprint1.Make.prototype );
  test.true( prototypes3[ 3 ] === _.Construction.prototype );

  /* */

}

definitionsOrder.description =
`
- order of definitionProp/traits makes difference
- typing first and then extending by untyped blueprint produce untyped blueprint
- extending by untyped blueprint and then typing produce typed blueprint
- typing first and then supplementing by untyped blueprint produce typed blueprint
- supplementing by untyped blueprint and then typing produce typed blueprint
`

//

function defineShallowComplex( test )
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

defineShallowComplex.description =
`
- shortcut shallow define definition field with valToIns:shallow
`

//

function defineShallowComplexSourceCode( test )
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

  // debugger;
  // var sourceCode = blueprint.defineShallowComplexSourceCode();
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

defineShallowComplexSourceCode.description =
`
- zzz
`

// --
// trait
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
    staticField1 : s( 'b1' ),
    staticField2 : s( 'b1' ),
  });

  var instance = Blueprint1.Make();
  test.identical( instance instanceof Blueprint1.Make, true );

  test.identical( _.prototype.each( instance ).length, 3 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( _.property.all( instance ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    'staticField1' : 'b1', 'staticField2' : 'b1'
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 2 ] ), exp );

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

  var instance = Blueprint2.Make();

  test.identical( instance instanceof Blueprint1.Make, true );
  test.identical( instance instanceof Blueprint2.Make, true );

  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
    'staticField1' : 'b1',
    'staticField2' : 'b2',
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
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    'staticField2' : 'b2', 'staticField3' : 'b2'
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
    'staticField1' : 'b1', 'staticField2' : 'b1'
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 3 ] ), exp );

  test.description = 'control blueprint1'; /* */

  var instance = Blueprint1.Make();
  test.identical( instance instanceof Blueprint1.Make, true );
  test.identical( instance instanceof Blueprint2.Make, false );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  var got = _.property.all( instance );
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
    'staticField1' : 'b1',
    'staticField2' : 'b2'
  }
  test.identical( _.property.all( instance ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b3',
    'field4' : 'b3',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    'staticField3' : 'b3', 'staticField4' : 'b3'
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
    'staticField2' : 'b2', 'staticField3' : 'b2'
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 2 ] ), exp );
  var exp =
  {
    'staticField1' : 'b1', 'staticField2' : 'b1'
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 3 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 4 ] ), exp );

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

  test.case = 'typed';

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

  var instance = Blueprint1.Make();
  test.identical( instance instanceof Blueprint1.Make, true );

  test.identical( _.prototype.each( instance ).length, 3 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( _.property.all( instance ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    'staticField1' : 'b1', 'staticField2' : 'b1'
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 2 ] ), exp );

  test.description = 'blueprint2'; /* */

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : s( 'b2' ),
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
    'staticField1' : 'b1',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    'staticField2' : 'b2', 'staticField3' : 'b2'
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
    'staticField1' : 'b1', 'staticField2' : 'b1'
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 3 ] ), exp );

  test.description = 'control blueprint1'; /* */

  var instance = Blueprint1.Make();
  test.identical( instance instanceof Blueprint1.Make, true );
  test.identical( instance instanceof Blueprint2.Make, false );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
    'staticField1' : 'b1',
    'staticField2' : 'b1',
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
    'staticField1' : 'b1',
    'staticField2' : 'b2'
  }
  test.identical( _.property.all( instance ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b3',
    'field4' : 'b3',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );
  var exp =
  {
    'staticField3' : 'b3', 'staticField4' : 'b3'
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 1 ] ), exp );
  var exp =
  {
    'staticField2' : 'b2', 'staticField3' : 'b2'
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 2 ] ), exp );
  var exp =
  {
    'staticField1' : 'b1', 'staticField2' : 'b1'
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 3 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 4 ] ), exp );

  /* */

  test.case = 'untyped';

  let s = _.define.static;
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

  test.identical( instance instanceof Blueprint1.Make, false );
  test.identical( instance instanceof Blueprint2.Make, false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint1 ), _.maybe );
  test.identical( _.construction.isInstanceOf( instance, Blueprint2 ), _.maybe );

  test.identical( _.prototype.each( instance ).length, 1 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );

  test.description = 'blueprint3'; /* */

  var Blueprint3 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint2 ),
    'field3' : 'b3',
    'field4' : 'b3',
  });

  var instance = Blueprint3.Make();

  test.identical( instance instanceof Blueprint1.Make, false );
  test.identical( instance instanceof Blueprint2.Make, false );
  test.identical( instance instanceof Blueprint3.Make, false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint1 ), _.maybe );
  test.identical( _.construction.isInstanceOf( instance, Blueprint2 ), _.maybe );
  test.identical( _.construction.isInstanceOf( instance, Blueprint3 ), _.maybe );

  test.identical( _.prototype.each( instance ).length, 1 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b3',
    'field4' : 'b3',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );

  /* */

  test.case = 'implicit untyped';

  let s = _.define.static;
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

  test.identical( instance instanceof Blueprint1.Make, false );
  test.identical( instance instanceof Blueprint2.Make, false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint1 ), _.maybe );
  test.identical( _.construction.isInstanceOf( instance, Blueprint2 ), _.maybe );

  test.identical( _.prototype.each( instance ).length, 1 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );

  test.description = 'blueprint3'; /* */

  var Blueprint3 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint2 ),
    'field3' : 'b3',
    'field4' : 'b3',
  });

  var instance = Blueprint3.Make();

  test.identical( instance instanceof Blueprint1.Make, false );
  test.identical( instance instanceof Blueprint2.Make, false );
  test.identical( instance instanceof Blueprint3.Make, false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint1 ), _.maybe );
  test.identical( _.construction.isInstanceOf( instance, Blueprint2 ), _.maybe );
  test.identical( _.construction.isInstanceOf( instance, Blueprint3 ), _.maybe );

  test.identical( _.prototype.each( instance ).length, 1 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b3',
    'field4' : 'b3',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );

  /* */

  test.case = 'typed -> untyped';

  let s = _.define.static;
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
  test.identical( instance instanceof Blueprint2.Make, false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint1 ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint2 ), _.maybe );

  test.identical( _.prototype.each( instance ).length, 1 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );

  test.description = 'blueprint3'; /* */

  var Blueprint3 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint2 ),
    'field3' : 'b3',
    'field4' : 'b3',
  });

  var instance = Blueprint3.Make();

  test.identical( instance instanceof Blueprint1.Make, false );
  test.identical( instance instanceof Blueprint2.Make, false );
  test.identical( instance instanceof Blueprint3.Make, false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint1 ), false );
  test.identical( _.construction.isInstanceOf( instance, Blueprint2 ), _.maybe );
  test.identical( _.construction.isInstanceOf( instance, Blueprint3 ), _.maybe );

  test.identical( _.prototype.each( instance ).length, 1 );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b3',
    'field4' : 'b3',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );

  /* */

  test.case = 'typed -> untyped, but before';

  let s = _.define.static;
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
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );

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
  test.identical( mapOwnProperties( _.prototype.each( instance )[ 0 ] ), exp );

  /* */

}

blueprintInheritWithTrait.description =
`
- blueprint inheritance with trait
`

//

function traitTyped( test )
{

  function rfield( arg )
  {
    return 'x' + arg;
  }

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

  test.identical( instance instanceof Blueprint.Make, false );
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

  test.identical( instance instanceof Blueprint.Make, false );
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

}

traitTyped.description =
`
- construction is not typed by default
- construction is typed if trait typed is true
`

//

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
    staticField1 : s( 'b1' ),
    staticField2 : s( 'b1' ),
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
    staticField1 : s( 'b1' ),
    staticField2 : s( 'b1' ),
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
    staticField1 : s( 'b1' ),
    staticField2 : s( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    name : _.trait.name( 'Blueprint2X' ),
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : s( 'b2' ),
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
    staticField1 : s( 'b1' ),
    staticField2 : s( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : s( 'b2' ),
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

function traitWithConstructor( test )
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
    staticField1 : s( 'b1' ),
    staticField2 : s( 'b1' ),
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
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( _.property.all( instance1 ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );

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
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( _.property.all( instance2 ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance2 )[ 0 ] ), exp );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance2 )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance2 )[ 2 ] ), exp );

  /* */

  test.case = 'named blueprint';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    name : _.trait.name( 'Blueprint1X' ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : s( 'b1' ),
    staticField2 : s( 'b1' ),
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
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( _.property.all( instance1 ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );

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
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( _.property.all( instance2 ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b1',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance2 )[ 0 ] ), exp );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance2 )[ 1 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance2 )[ 2 ] ), exp );

  /* */

  test.case = 'inheritance';

  var Blueprint1 = _.Blueprint
  ({
    typed : _.trait.typed({ val : true }),
    withConstructor : _.trait.withConstructor(),
    name : _.trait.name( 'Blueprint1X' ),
    field1 : 'b1',
    field2 : 'b1',
    staticField1 : s( 'b1' ),
    staticField2 : s( 'b1' ),
  });

  var Blueprint2 = _.Blueprint
  ({
    inherit : _.define.inherit( Blueprint1 ),
    name : _.trait.name( 'Blueprint2X' ),
    field2 : 'b2',
    field3 : 'b2',
    staticField2 : s( 'b2' ),
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
    'staticField1' : 'b1',
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( _.property.all( instance1 ), exp );
  var exp =
  {
    'field1' : 'b1',
    'field2' : 'b2',
    'field3' : 'b2',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 0 ] ), exp );
  var exp =
  {
    constructor : Blueprint2.prototype.constructor,
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 1 ] ), exp );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance1 )[ 3 ] ), exp );

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
  test.identical( mapOwnProperties( _.prototype.each( instance2 )[ 0 ] ), exp );
  var exp =
  {
    constructor : Blueprint2.prototype.constructor,
    'staticField2' : 'b2',
    'staticField3' : 'b2',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance2 )[ 1 ] ), exp );
  var exp =
  {
    constructor : Blueprint1.prototype.constructor,
    'staticField1' : 'b1',
    'staticField2' : 'b1',
  }
  test.identical( mapOwnProperties( _.prototype.each( instance2 )[ 2 ] ), exp );
  var exp =
  {
  }
  test.identical( mapOwnProperties( _.prototype.each( instance2 )[ 3 ] ), exp );

  /* */

}

traitWithConstructor.description =
`
- blueprint inheritance with trait make inheritance
`

//

function traitExtendable( test )
{

  function rfield( arg )
  {
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

traitExtendable.description =
`
- blueprint without trait extandable is not extenable
- blueprint with trait extandable with argument false is not extenable
- blueprint with trait extandable is extenable
- blueprint with trait extandable without argument is extenable
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

  test.identical( instance instanceof Blueprint.Make, false );
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

  test.identical( instance instanceof Blueprint.Make, false );
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

  test.identical( instance instanceof Blueprint.Make, false );
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

  test.identical( instance instanceof Blueprint.Make, false );
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
  test.identical( instance instanceof Blueprint.Make, false );

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
  test.identical( instance instanceof Blueprint.Make, false );

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

  test.identical( instance2 instanceof Blueprint.Make, false );
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

  test.identical( instance2 instanceof Blueprint.Make, false );
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
  test.identical( instances[ 0 ] instanceof Blueprint.Make, false );
  test.true( instances[ 0 ] !== args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.Make, false );
  test.true( instances[ 1 ] !== args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.Make, false );
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
  test.identical( instances[ 0 ] instanceof Blueprint.Make, false );
  test.true( instances[ 0 ] !== args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.Make, false );
  test.true( instances[ 1 ] !== args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.Make, false );
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
  test.identical( instances[ 0 ] instanceof Blueprint.Make, false );
  test.true( instances[ 0 ] === args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.Make, false );
  test.true( instances[ 1 ] === args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.Make, false );
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
  test.identical( instances[ 0 ] instanceof Blueprint.Make, false );
  test.true( instances[ 0 ] === args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.Make, false );
  test.true( instances[ 1 ] === args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.Make, false );
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
  test.identical( instances[ 0 ] instanceof Blueprint.Make, false );
  test.true( instances[ 0 ] === args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.Make, false );
  test.true( instances[ 1 ] === args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.Make, false );
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
  test.identical( instances[ 0 ] instanceof Blueprint.Make, false );
  test.true( instances[ 0 ] === args[ 0 ] );
  var exp = { field1 : 2 }
  test.containsOnly( instances[ 1 ], exp );
  test.identical( instances[ 1 ] instanceof Blueprint.Make, false );
  test.true( instances[ 1 ] === args[ 1 ] );
  var exp = { field1 : rfield }
  test.containsOnly( instances[ 2 ], exp );
  test.identical( instances[ 2 ] instanceof Blueprint.Make, false );
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
  test.true( Blueprint1.prototype.constructor === undefined );
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
  test.identical( Object.getPrototypeOf( src ), Object.prototype );
  var got = new blueprint1.Make( src );
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
  test.identical( _.property.all( got ), mapOwnProperties( exp ) );

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
  test.identical( _.property.all( got ), mapOwnProperties( exp ) );

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
  test.identical( _.property.all( got ), mapOwnProperties( exp ) );

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
  test.identical( _.property.all( got ), mapOwnProperties( exp ) );

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
  test.identical( _.property.all( got ), mapOwnProperties( exp ) );

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

    mapOwnProperties,

  },

  tests :
  {

    // etc

    blueprintIsDefinitive,
    blueprintIsRuntime,

    // definition

    definitionProp,
    definitionProps,
    definitionPropStaticBasic,
    definitionPropStaticInheritance,
    definitionPropEnumerable,
    definitionPropWritable,
    definitionPropConfigurable,
    definitionProper,

    definitionExtensionBasic,
    definitionSupplementationBasic,
    definitionExtensionOrder,
    definitionSupplementationOrder,

    definitionsOrder,
    defineShallowComplex,
    defineShallowComplexSourceCode,

    // trait

    blueprintInheritManually,
    blueprintInheritWithTrait,

    traitTyped,
    traitName,
    traitWithConstructor,
    traitExtendable,

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
