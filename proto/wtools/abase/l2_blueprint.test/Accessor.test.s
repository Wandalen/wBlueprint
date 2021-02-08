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

function _normalizedAsuiteForm( test )
{

  /* */

  test.case = 'suite.*:null normalizedAsuite.*:null methods.*:routine';

  var options =
  {
    name : 'a',
    methods :
    {
      aGrab : () => null,
      aGet : () => null,
      aPut : () => null,
      aSet : () => null,
      aMove : () => null,
    },
    suite :
    {
      grab : null,
      get : null,
      put : null,
      set : null,
      move : null,
    },
    normalizedAsuite :
    {
      grab : null,
      get : null,
      put : null,
      set : null,
      move : null,
    },
  }
  var got = _.accessor._normalizedAsuiteForm( options );
  var exp =
  {
    'grab' : got.grab,
    'get' : got.get,
    'put' : got.put,
    'set' : got.set,
    'move' : got.move,
  }
  test.identical( got, exp );
  test.true( got === options.normalizedAsuite );
  test.true( _.routineIs( got.grab ) );
  test.true( _.routineIs( got.get ) );
  test.true( _.routineIs( got.put ) );
  test.true( _.routineIs( got.set ) );
  test.true( _.routineIs( got.move ) );

  /* */

  test.case = 'suite.*:null normalizedAsuite.*:null';

  var options =
  {
    name : 'a',
    methods : {},
    suite :
    {
      grab : null,
      get : null,
      put : null,
      set : null,
      move : null,
    },
    normalizedAsuite :
    {
      grab : null,
      get : null,
      put : null,
      set : null,
      move : null,
    },
  }
  var got = _.accessor._normalizedAsuiteForm( options );
  var exp =
  {
    'grab' : got.grab,
    'get' : got.get,
    'put' : got.put,
    'set' : got.set,
    'move' : false,
  }
  test.identical( got, exp );
  test.true( got === options.normalizedAsuite );
  test.true( _.routineIs( got.grab ) );
  test.true( _.routineIs( got.get ) );
  test.true( _.routineIs( got.put ) );
  test.true( _.routineIs( got.set ) );
  test.true( _.boolIs( got.move ) );

  /* */

  test.case = 'suite.*:false';

  var options =
  {
    name : 'a',
    methods :
    {
      aGrab : () => null,
      aGet : () => null,
      aPut : () => null,
      aSet : () => null,
      aMove : () => null,
    },
    suite :
    {
      grab : false,
      get : false,
      put : false,
      set : false,
      move : false,
    },
    normalizedAsuite :
    {
      grab : null,
      get : null,
      put : null,
      set : null,
      move : null,
    },
  }
  var got = _.accessor._normalizedAsuiteForm( options );
  var exp =
  {
    'grab' : false,
    'get' : false,
    'put' : false,
    'set' : false,
    'move' : false,
  }
  test.identical( got, exp );
  test.true( got === options.normalizedAsuite );

  /* */

  test.case = 'normalizedAsuite.*:false';

  var options =
  {
    name : 'a',
    methods :
    {
      aGrab : () => null,
      aGet : () => null,
      aPut : () => null,
      aSet : () => null,
      aMove : () => null,
    },
    suite :
    {
      grab : null,
      get : null,
      put : null,
      set : null,
      move : null,
    },
    normalizedAsuite :
    {
      grab : false,
      get : false,
      put : false,
      set : false,
      move : false,
    },
  }
  var got = _.accessor._normalizedAsuiteForm( options );
  var exp =
  {
    'grab' : false,
    'get' : false,
    'put' : false,
    'set' : false,
    'move' : false,
  }
  test.identical( got, exp );
  test.true( got === options.normalizedAsuite );

  /* */

  test.case = 'suite.grab:false';

  var options =
  {
    name : 'a',
    methods :
    {
      aGrab : () => null,
      aGet : () => null,
      aPut : () => null,
      aSet : () => null,
      aMove : () => null,
    },
    suite :
    {
      grab : false,
      get : null,
      put : null,
      set : null,
      move : null,
    },
    normalizedAsuite :
    {
      grab : null,
      get : null,
      put : null,
      set : null,
      move : null,
    },
  }
  var got = _.accessor._normalizedAsuiteForm( options );
  var exp =
  {
    'grab' : false,
    'get' : got.get,
    'put' : got.put,
    'set' : got.set,
    'move' : got.move,
  }
  test.identical( got, exp );
  test.true( got === options.normalizedAsuite );
  test.true( _.boolIs( got.grab ) );
  test.true( _.routineIs( got.get ) );
  test.true( _.routineIs( got.put ) );
  test.true( _.routineIs( got.set ) );
  test.true( _.routineIs( got.move ) );

  /* */

  test.case = 'suite.get:false';

  var options =
  {
    name : 'a',
    methods :
    {
      aGrab : () => null,
      aGet : () => null,
      aPut : () => null,
      aSet : () => null,
      aMove : () => null,
    },
    suite :
    {
      grab : null,
      get : false,
      put : null,
      set : null,
      move : null,
    },
    normalizedAsuite :
    {
      grab : null,
      get : null,
      put : null,
      set : null,
      move : null,
    },
  }
  var got = _.accessor._normalizedAsuiteForm( options );
  var exp =
  {
    'grab' : got.grab,
    'get' : false,
    'put' : got.put,
    'set' : got.set,
    'move' : got.move,
  }
  test.identical( got, exp );
  test.true( got === options.normalizedAsuite );
  test.true( _.routineIs( got.grab ) );
  test.true( _.boolIs( got.get ) );
  test.true( _.routineIs( got.put ) );
  test.true( _.routineIs( got.set ) );
  test.true( _.routineIs( got.move ) );

  /* */

  test.case = 'suite.put:false';

  var options =
  {
    name : 'a',
    methods :
    {
      aGrab : () => null,
      aGet : () => null,
      aPut : () => null,
      aSet : () => null,
      aMove : () => null,
    },
    suite :
    {
      grab : null,
      get : null,
      put : null,
      set : false,
      move : null,
    },
    normalizedAsuite :
    {
      grab : null,
      get : null,
      put : null,
      set : null,
      move : null,
    },
  }
  var got = _.accessor._normalizedAsuiteForm( options );
  var exp =
  {
    'grab' : got.grab,
    'get' : got.get,
    'put' : got.put,
    'set' : false,
    'move' : got.move,
  }
  test.identical( got, exp );
  test.true( got === options.normalizedAsuite );
  test.true( _.routineIs( got.grab ) );
  test.true( _.routineIs( got.get ) );
  test.true( _.routineIs( got.put ) );
  test.true( _.boolIs( got.set ) );
  test.true( _.routineIs( got.move ) );

  /* */

  test.case = 'suite.move:false';

  var options =
  {
    name : 'a',
    methods :
    {
      aGrab : () => null,
      aGet : () => null,
      aPut : () => null,
      aSet : () => null,
      aMove : () => null,
    },
    suite :
    {
      grab : null,
      get : null,
      put : null,
      set : null,
      move : false,
    },
    normalizedAsuite :
    {
      grab : null,
      get : null,
      put : null,
      set : null,
      move : null,
    },
  }
  var got = _.accessor._normalizedAsuiteForm( options );
  var exp =
  {
    'grab' : got.grab,
    'get' : got.get,
    'put' : got.put,
    'set' : got.set,
    'move' : false,
  }
  test.identical( got, exp );
  test.true( got === options.normalizedAsuite );
  test.true( _.routineIs( got.grab ) );
  test.true( _.routineIs( got.get ) );
  test.true( _.routineIs( got.put ) );
  test.true( _.routineIs( got.set ) );
  test.true( _.boolIs( got.move ) );

  /* */

}

//

function _objectSetValueNoShadowing( test )
{

  /* */

  test.case = 'basic';

  var proto = Object.create( null );
  var obj = Object.create( proto );
  obj.f1 = 1;

  var o2 = _.accessor.declareSingle
  ({
    name : 'f1',
    object : proto,
    storingStrategy : 'underscore',
    storageIniting : false,
    addingMethods : false,
    val : _.nothing,
  });

  _.accessor._objectInitStorage( obj, o2.normalizedAsuite );

  debugger;
  _.accessor._objectSetValue
  ({
    object : obj,
    normalizedAsuite : o2.normalizedAsuite,
    storingStrategy : 'underscore',
    name : 'f1',
    val : 2,
  });

  var exp = { f1 : 2 };
  test.identical( _.property.of( obj ), exp );

  var exp = {};
  test.identical( _.mapBut( proto, [ 'f1' ] ), exp );

  debugger;

  /* */

}

_objectSetValueNoShadowing.description =
`
 - property of object should not shadow value of accessor defined in prototype
`

//

function declareBasic( test )
{

  /* */

  test.case = 'basic';

  var obj1 = {};
  var exp = { a : 1 };
  var returned = _.accessor.declare( obj1, { a : { val : 1 } } );
  test.identical( obj1, exp );

  var got = Object.getOwnPropertyDescriptor( obj1, 'a' );
  var exp =
  {
    get : got.get,
    set : got.set,
    'enumerable' : true,
    'configurable' : true,
  }
  test.identical( got, exp );

  /* */

  test.case = 'unrolled accessor';

  var obj1 = {};
  var exp = { a : 1 };
  var accessor1 = { get : get1, set : set1, grab : grab1, put : put1, move : move1 };
  var returned = _.accessor.declare( obj1, { a : { ... accessor1 } } );
  test.identical( obj1, exp );

  var got = Object.getOwnPropertyDescriptor( obj1, 'a' );
  var exp =
  {
    get : got.get,
    set : got.set,
    'enumerable' : true,
    'configurable' : true,
  }
  test.identical( got, exp );
  test.true( got.get === get1 );
  test.true( got.set === set1 );

  /* */

  test.case = 'suite';

  var obj1 = {};
  var exp = { a : 1 };
  var accessor1 = { get : get1, set : set1, grab : grab1, put : put1, move : move1 };
  var returned = _.accessor.declare( obj1, { a : { suite : accessor1 } } );
  test.identical( obj1, exp );

  var got = Object.getOwnPropertyDescriptor( obj1, 'a' );
  var exp =
  {
    get : got.get,
    set : got.set,
    'enumerable' : true,
    'configurable' : true,
  }
  test.identical( got, exp );
  test.true( got.get === get1 );
  test.true( got.set === set1 );

  /* */

  test.case = 'throwing';

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync
  (
    () => _.accessor.declare( Object, { a : { val : 1 } } ),
    ( err ) =>
    {
      test.identical( err.originalMessage, 'Attempt to polute _global_.Object' );
    }
  );
  test.shouldThrowErrorSync
  (
    () => _.accessor.declare( Object.prototype, { a : { val : 1 } } ),
    ( err ) =>
    {
      test.identical( err.originalMessage, 'Attempt to pollute _global_.Object.prototype' );
    }
  );

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

function declareConstant( test )
{

  /* */

  test.case = 'read only explicitly, get is definitition';

  var dst =
  {
  };

  var exp = { 'a' : 'a1' };
  _.accessor.declare
  ({
    object : dst,
    names : { a : { writable : 0, get : () => 'a1' } },
    prime : 0,
  });
  test.identical( dst, exp );
  test.shouldThrowErrorSync( () => dst.a = 'a2' );

  /* */

  test.case = 'read only implicitly, value in descriptor';

  var dst =
  {
  };

  var exp = { 'a' : 'a1' }
  _.accessor.declare
  ({
    object : dst,
    names : { a : { set : false, get : () => 'a1' } },
    prime : 0,
  });
  test.identical( dst, exp );
  test.shouldThrowErrorSync( () => dst.a = 'a2' );

  /* */

}

//

function declareConstantSymbol( test )
{

  /* */

  test.case = 'read only implicitly, value in descriptor';

  var dst =
  {
  };

  var exp = {}
  _.accessor.declare
  ({
    object : dst,
    names : { [ Symbol.for( 'a' ) ] : { set : false, get : () => 'a1' } },
    prime : 0,
  });
  test.identical( dst, exp );
  test.identical( dst[ Symbol.for( 'a' ) ], 'a1' );
  test.shouldThrowErrorSync( () => dst[ Symbol.for( 'a' ) ] = 'a2' );
  var exp = { a : 'a3' };
  dst.a = 'a3';
  test.identical( dst, exp );
  test.identical( dst[ Symbol.for( 'a' ) ], 'a1' );

  /* */

}

//

function declareConstantWithDefinition( test )
{

  /* */

  test.case = 'read only explicitly, get is definitition';

  var dst =
  {
  };

  var exp = { 'a' : 'a1' };
  _.accessor.declare
  ({
    object : dst,
    // names : { a : { writable : 0, get : _.define.constant( 'a1' ) } },
    names : { a : { writable : 0, get : _.define.constant( 'a1' ) } },
    prime : 0,
  });
  test.identical( dst, exp );
  test.shouldThrowErrorSync( () => dst.a = 'a2' );

  /* */

  test.case = 'read only implicitly, value in descriptor';

  var dst =
  {
  };

  var exp = { 'a' : 'a1' }
  _.accessor.declare
  ({
    object : dst,
    names : { a : { set : false, get : _.define.constant( 'a1' ) } },
    prime : 0,
  });
  test.identical( dst, exp );
  test.shouldThrowErrorSync( () => dst.a = 'a2' );

  /* */

  test.case = 'read only implicitly, value instead of descriptor';

  var dst =
  {
  };

  var exp = { 'a' : 'a1' }
  _.accessor.declare
  ({
    object : dst,
    names : { a : _.define.constant( 'a1' ) },
    prime : 0,
  });
  test.identical( dst, exp );
  test.shouldThrowErrorSync( () => dst.a = 'a2' );

  /* */

}

//

function declareConstantSymbolWithDefinition( test )
{

  /* */

  test.case = 'read only implicitly, value in descriptor';

  var dst =
  {
  };

  var exp = {};
  _.accessor.declare
  ({
    object : dst,
    names : { [ Symbol.for( 'a' ) ] : { set : false, get : _.define.constant( 'a1' ) } },
    prime : 0,
  });
  test.identical( dst, exp );
  test.identical( dst[ Symbol.for( 'a' ) ], 'a1' );
  test.shouldThrowErrorSync( () => dst[ Symbol.for( 'a' ) ] = 'a2' );
  var exp = { a : 'a3' };
  dst.a = 'a3';
  test.identical( dst, exp );
  test.identical( dst[ Symbol.for( 'a' ) ], 'a1' );

  /* */

  test.case = 'read only implicitly, value instead of descriptor';

  var dst =
  {
  };

  var exp = {}
  _.accessor.declare
  ({
    object : dst,
    names : { [ Symbol.for( 'a' ) ] : _.define.constant( 'a1' ) },
    prime : 0,
  });
  test.identical( dst, exp );
  test.identical( dst[ Symbol.for( 'a' ) ], 'a1' );
  test.shouldThrowErrorSync( () => dst[ Symbol.for( 'a' ) ] = 'a2' );
  var exp = { a : 'a3' };
  dst.a = 'a3';
  test.identical( dst, exp );
  test.identical( dst[ Symbol.for( 'a' ) ], 'a1' );

  /* */

}

//

function accessorMethodsDeducing( test )
{

  /* */

  test.case = 'not, only grab';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    aGrab : function()
    {
      track.push( 'aGrab' );
      return this[ symbol ];
    },
    a : 10,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : { get : 0, put : 0, set : 0 } },
    prime : 0,
  });

  test.identical( track, [] );
  // test.identical( ins1.a, 10 );
  test.shouldThrowErrorSync( () => ins1.a );

  test.identical( track, [] );
  test.identical( ins1.aGrab(), 10 );
  test.identical( track, [ 'aGrab' ] );
  test.shouldThrowErrorSync( () => dst.a = 30 );

  /* */

  test.case = 'not, only get';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    aGet : function()
    {
      track.push( 'aGet' );
      return this[ symbol ];
    },
    a : 10,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : { grab : 0, put : 0, set : 0 } },
    prime : 0,
  });

  test.identical( track, [] );
  test.identical( ins1.a, 10 );
  test.identical( track, [ 'aGet' ] );
  test.shouldThrowErrorSync( () => dst.a = 30 );

  /* */

  test.case = 'not, only put';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    aPut : function()
    {
      track.push( 'aPut' );
      return this[ symbol ];
    },
    a : 10,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : { grab : 0, get : 0, set : 0 } },
    prime : 0,
  });

  test.identical( track, [ 'aPut' ] );
  // test.identical( ins1.a, 10 );
  test.shouldThrowErrorSync( () => ins1.a );
  test.identical( track, [ 'aPut' ] );
  ins1.aPut( 20 );
  // test.identical( ins1.a, 10 );
  test.shouldThrowErrorSync( () => ins1.a );
  test.identical( track, [ 'aPut', 'aPut' ] );
  test.shouldThrowErrorSync( () => dst.a = 30 );

  /* */

  test.case = 'not, only set';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    aSet : function()
    {
      track.push( 'aSet' );
      return this[ symbol ];
    },
    a : 10,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : { grab : 0, get : 0, put : 0 } },
    prime : 0,
  });

  test.identical( track, [ 'aSet' ] );
  // test.identical( ins1.a, undefined );
  test.shouldThrowErrorSync( () => ins1.a );
  test.identical( track, [ 'aSet' ] );
  ins1.aSet( 20 );
  // test.identical( ins1.a, undefined );
  test.shouldThrowErrorSync( () => ins1.a );
  test.identical( track, [ 'aSet', 'aSet' ] );

  ins1.a = 30;
  // test.identical( ins1.a, undefined );
  test.shouldThrowErrorSync( () => ins1.a );
  test.identical( track, [ 'aSet', 'aSet', 'aSet' ] );

  /* */

  test.case = 'aGrab defined, despite options';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    aGrab : function()
    {
      track.push( 'aGrab' );
      return this[ symbol ];
    },
    a : 10,
  };

  test.shouldThrowErrorSync( () =>
  {
    _.accessor.declare
    ({
      object : ins1,
      names : { a : { grab : 0 } },
      prime : 0,
    });
  }
  , ( err ) =>
  {
    test.true( _.errIs( err ) );
    test.identical( err.originalMessage, `Object should not have method aGrab, if accessor has it disabled` );
  });

  /* */

  test.case = 'only underscored';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    _aGrab : function()
    {
      track.push( '_aGrab' );
      return this[ symbol ]
    },
    _aGet : function()
    {
      track.push( '_aGet' );
      return this[ symbol ]
    },
    _aPut : function( src )
    {
      track.push( '_aPut' );
      this[ symbol ] = src;
    },
    _aSet : function( src )
    {
      track.push( '_aSet' );
      this[ symbol ] = src;
    },
    a : 10,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : 'a' },
    prime : 0,
  });

  test.identical( track, [ '_aPut' ] );
  test.identical( ins1.a, 10 );
  test.identical( track, [ '_aPut', '_aGet' ] );
  ins1.a = 20;
  test.identical( track, [ '_aPut', '_aGet', '_aSet' ] );
  test.identical( ins1.a, 20 );
  test.identical( track, [ '_aPut', '_aGet', '_aSet', '_aGet' ] );

  /* */

  test.case = 'only not-underscored';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    aGrab : function()
    {
      track.push( 'aGrab' );
      return this[ symbol ]
    },
    aGet : function()
    {
      track.push( 'aGet' );
      return this[ symbol ]
    },
    aPut : function( src )
    {
      track.push( 'aPut' );
      this[ symbol ] = src;
    },
    aSet : function( src )
    {
      track.push( 'aSet' );
      this[ symbol ] = src;
    },
    a : 10,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : 'a' },
    prime : 0,
  });

  test.identical( track, [ 'aPut' ] );
  test.identical( ins1.a, 10 );
  test.identical( track, [ 'aPut', 'aGet' ] );
  ins1.a = 20;
  test.identical( track, [ 'aPut', 'aGet', 'aSet' ] );
  test.identical( ins1.a, 20 );
  test.identical( track, [ 'aPut', 'aGet', 'aSet', 'aGet' ] );

  /* */

  test.case = 'underscored and not-underscored';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    _aGrab : function()
    {
      track.push( '_aGrab' );
      return this[ symbol ]
    },
    _aGet : function()
    {
      track.push( '_aGet' );
      return this[ symbol ]
    },
    _aPut : function( src )
    {
      track.push( '_aPut' );
      this[ symbol ] = src;
    },
    _aSet : function( src )
    {
      track.push( '_aSet' );
      this[ symbol ] = src;
    },
    aGrab : function()
    {
      track.push( 'aGrab' );
      return this[ symbol ]
    },
    aGet : function()
    {
      track.push( 'aGet' );
      return this[ symbol ]
    },
    aPut : function( src )
    {
      track.push( 'aPut' );
      this[ symbol ] = src;
    },
    aSet : function( src )
    {
      track.push( 'aSet' );
      this[ symbol ] = src;
    },
    a : 10,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : 'a' },
    prime : 0,
  });

  test.identical( track, [ 'aPut' ] );
  test.identical( ins1.a, 10 );
  test.identical( track, [ 'aPut', 'aGet' ] );
  ins1.a = 20;
  test.identical( track, [ 'aPut', 'aGet', 'aSet' ] );
  test.identical( ins1.a, 20 );
  test.identical( track, [ 'aPut', 'aGet', 'aSet', 'aGet' ] );

  /* */

  test.case = 'only underscored and explicit true';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    _aGrab : function()
    {
      track.push( '_aGrab' );
      return this[ symbol ]
    },
    _aGet : function()
    {
      track.push( '_aGet' );
      return this[ symbol ]
    },
    _aPut : function( src )
    {
      track.push( '_aPut' );
      this[ symbol ] = src;
    },
    _aSet : function( src )
    {
      track.push( '_aSet' );
      this[ symbol ] = src;
    },
    a : 10,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : { grab : true, get : true, put : true, set : true } },
    prime : 0,
  });

  test.identical( track, [ '_aPut' ] );
  test.identical( ins1.a, 10 );
  test.identical( track, [ '_aPut', '_aGet' ] );
  ins1.a = 20;
  test.identical( track, [ '_aPut', '_aGet', '_aSet' ] );
  test.identical( ins1.a, 20 );
  test.identical( track, [ '_aPut', '_aGet', '_aSet', '_aGet' ] );

  /* */

  test.case = 'only not underscored and explicit true';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    _aGrab : function()
    {
      track.push( '_aGrab' );
      return this[ symbol ]
    },
    _aGet : function()
    {
      track.push( '_aGet' );
      return this[ symbol ]
    },
    _aPut : function( src )
    {
      track.push( '_aPut' );
      this[ symbol ] = src;
    },
    _aSet : function( src )
    {
      track.push( '_aSet' );
      this[ symbol ] = src;
    },
    aGrab : function()
    {
      track.push( 'aGrab' );
      return this[ symbol ]
    },
    aGet : function()
    {
      track.push( 'aGet' );
      return this[ symbol ]
    },
    aPut : function( src )
    {
      track.push( 'aPut' );
      this[ symbol ] = src;
    },
    aSet : function( src )
    {
      track.push( 'aSet' );
      this[ symbol ] = src;
    },
    a : 10,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : { grab : true, get : true, put : true, set : true } },
    prime : 0,
  });

  test.identical( track, [ 'aPut' ] );
  test.identical( ins1.a, 10 );
  test.identical( track, [ 'aPut', 'aGet' ] );
  ins1.a = 20;
  test.identical( track, [ 'aPut', 'aGet', 'aSet' ] );
  test.identical( ins1.a, 20 );
  test.identical( track, [ 'aPut', 'aGet', 'aSet', 'aGet' ] );

  /* */

  test.case = 'only not underscored and explicit true';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    aGrab : function()
    {
      track.push( 'aGrab' );
      return this[ symbol ]
    },
    aGet : function()
    {
      track.push( 'aGet' );
      return this[ symbol ]
    },
    aPut : function( src )
    {
      track.push( 'aPut' );
      this[ symbol ] = src;
    },
    aSet : function( src )
    {
      track.push( 'aSet' );
      this[ symbol ] = src;
    },
    a : 10,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : { grab : true, get : true, put : true, set : true } },
    prime : 0,
  });

  test.identical( track, [ 'aPut' ] );
  test.identical( ins1.a, 10 );
  test.identical( track, [ 'aPut', 'aGet' ] );
  ins1.a = 20;
  test.identical( track, [ 'aPut', 'aGet', 'aSet' ] );
  test.identical( ins1.a, 20 );
  test.identical( track, [ 'aPut', 'aGet', 'aSet', 'aGet' ] );

  /* */

  test.case = '_aGrab only';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    _aGrab : function()
    {
      track.push( '_aGrab' );
      return this[ symbol ]
    },
    a : 10,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : 'a' },
    prime : 0,
  });

  test.identical( track, [] );
  test.identical( ins1.a, 10 );
  test.identical( track, [ '_aGrab' ] );
  ins1.a = 20;
  test.identical( track, [ '_aGrab' ] );
  test.identical( ins1.a, 20 );
  test.identical( track, [ '_aGrab', '_aGrab' ] );

  /* */

  test.case = 'aGrab only';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    aGrab : function()
    {
      track.push( 'aGrab' );
      return this[ symbol ]
    },
    a : 10,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : 'a' },
    prime : 0,
  });

  test.identical( track, [] );
  test.identical( ins1.a, 10 );
  test.identical( track, [ 'aGrab' ] );
  ins1.a = 20;
  test.identical( track, [ 'aGrab' ] );
  test.identical( ins1.a, 20 );
  test.identical( track, [ 'aGrab', 'aGrab' ] );

  /* */

  test.case = '_aGet only';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    _aGet : function()
    {
      track.push( '_aGet' );
      return this[ symbol ]
    },
    a : 10,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : 'a' },
    prime : 0,
  });

  test.identical( track, [] );
  test.identical( ins1.a, 10 );
  test.identical( track, [ '_aGet' ] );
  ins1.a = 20;
  test.identical( track, [ '_aGet' ] );
  test.identical( ins1.a, 20 );
  test.identical( track, [ '_aGet', '_aGet' ] );

  /* */

  test.case = 'aGet only';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    aGet : function()
    {
      track.push( 'aGet' );
      return this[ symbol ]
    },
    a : 10,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : 'a' },
    prime : 0,
  });

  test.identical( track, [] );
  test.identical( ins1.a, 10 );
  test.identical( track, [ 'aGet' ] );
  ins1.a = 20;
  test.identical( track, [ 'aGet' ] );
  test.identical( ins1.a, 20 );
  test.identical( track, [ 'aGet', 'aGet' ] );

  /* */

  test.case = '_aSet only';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    _aSet : function( src )
    {
      track.push( '_aSet' );
      this[ symbol ] = src;
    },
    a : 10,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : 'a' },
    prime : 0,
  });

  test.identical( track, [ '_aSet' ] );
  test.identical( ins1.a, 10 );
  test.identical( track, [ '_aSet' ] );
  ins1.a = 20;
  test.identical( track, [ '_aSet', '_aSet' ] );
  test.identical( ins1.a, 20 );
  test.identical( track, [ '_aSet', '_aSet' ] );

  /* */

  test.case = '_aPut only';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    _aPut : function( src )
    {
      track.push( '_aPut' );
      this[ symbol ] = src;
    },
    a : 10,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : 'a' },
    prime : 0,
  });

  test.identical( track, [ '_aPut' ] );
  test.identical( ins1.a, 10 );
  test.identical( track, [ '_aPut' ] );
  ins1.a = 20;
  test.identical( track, [ '_aPut', '_aPut' ] );
  test.identical( ins1.a, 20 );
  test.identical( track, [ '_aPut', '_aPut' ] );

  /* */

  test.case = 'aPut only';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    aPut : function( src )
    {
      track.push( 'aPut' );
      this[ symbol ] = src;
    },
    a : 10,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : 'a' },
    prime : 0,
  });

  test.identical( track, [ 'aPut' ] );
  test.identical( ins1.a, 10 );
  test.identical( track, [ 'aPut' ] );
  ins1.a = 20;
  test.identical( track, [ 'aPut', 'aPut' ] );
  test.identical( ins1.a, 20 );
  test.identical( track, [ 'aPut', 'aPut' ] );

  /* */

  test.case = 'aSet only';
  var symbol = Symbol.for( 'a' );
  var track = [];
  var ins1 =
  {
    aSet : function( src )
    {
      track.push( 'aSet' );
      this[ symbol ] = src;
    },
    a : 10,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : 'a' },
    prime : 0,
  });

  test.identical( track, [ 'aSet' ] );
  test.identical( ins1.a, 10 );
  test.identical( track, [ 'aSet' ] );
  ins1.a = 20;
  test.identical( track, [ 'aSet', 'aSet' ] );
  test.identical( ins1.a, 20 );
  test.identical( track, [ 'aSet', 'aSet' ] );

  /* */

}

//

function accessorOptionReadOnly( test )
{

  /* */

  test.case = 'control, str';

  var dst =
  {
    aGet : function() { return 'a1' },
  };

  var exp = { 'a' : 'a1', 'aGet' : dst.aGet }
  _.accessor.declare
  ({
    object : dst,
    names : { a : 'a' },
    prime : 0,
  });
  test.identical( dst, exp );

  /* */

  test.case = 'control, map';

  var dst =
  {
    aGet : function() { return 'a1' },
  };

  var exp = { 'a' : 'a1', 'aGet' : dst.aGet }
  _.accessor.declare
  ({
    object : dst,
    names : { a : {} },
    prime : 0,
  });
  test.identical( dst, exp );

  /* */

  test.case = 'read only explicitly, value in object';

  var dst =
  {
    a : 'a1',
  };

  var exp = { 'a' : 'a1' }
  _.accessor.declare
  ({
    object : dst,
    names : { a : { writable : 0 } },
    prime : 0,
  });
  test.identical( dst, exp );
  test.shouldThrowErrorSync( () => dst.a = 'a2' );

  /* */

  test.case = 'read only implicitly, value in object';

  var dst =
  {
    a : 'a1',
  };

  var exp = { 'a' : 'a1' }
  _.accessor.declare
  ({
    object : dst,
    names : { a : { set : false } },
    prime : 0,
  });
  test.identical( dst, exp );
  test.shouldThrowErrorSync( () => dst.a = 'a2' );

  /* */

}

//

function accessorOptionAddingMethods( test )
{

  /* */

  test.case = 'deduce setter from put, object does not have methods, with _, addingMethods:1';
  var methods =
  {
    _aGet : function() { return this.b },
    _aPut : function( src ) { this.b = src },
  }
  var dst =
  {
    'a' : 'a1',
    'b' : 'b1',
  };
  var exp =
  {
    'a' : 'a1',
    'b' : 'a1',
  }
  _.accessor.declare
  ({
    object : dst,
    methods,
    names : { a : {} },
    prime : 0,
    strict : 0,
    addingMethods : 0,
  });
  test.identical( dst, exp );

  /* */

  test.case = 'deduce setter from put, object has methods, addingMethods:0';
  var dst =
  {
    'a' : 'a1',
    'b' : 'b1',
    aGet : function() { return this.b },
    aPut : function( src ) { this.b = src },
  };
  var exp =
  {
    'a' : 'a1',
    'b' : 'a1',
    aGet : dst.aGet,
    aPut : dst.aPut,
  }
  _.accessor.declare
  ({
    object : dst,
    names : { a : {} },
    prime : 0,
    strict : 0,
    addingMethods : 0,
  });
  test.identical( dst, exp );

  /* */

  test.case = 'deduce setter from put, deduce get from grab, object has methods, addingMethods:1';
  var dst =
  {
    'a' : 'a1',
    'b' : 'b1',
    aGrab : function() { return this.b },
    aPut : function( src ) { this.b = src },
  };
  var exp =
  {
    'a' : 'a1',
    'b' : 'a1',
    aGrab : dst.aGrab,
    aGet : dst.aGrab,
    aPut : dst.aPut,
    aSet : dst.aPut,
  }

  var declared = _.accessor.declare
  ({
    object : dst,
    names : { a : {} },
    prime : 0,
    strict : 0,
    addingMethods : 1,
  });
  test.identical( _.property.onlyOwn( dst, { onlyEnumerable : 0 } ), exp );
  test.true( _.routineIs( dst.aGrab ) );
  test.true( _.routineIs( dst.aGet ) );
  test.true( _.routineIs( dst.aPut ) );
  test.true( _.routineIs( dst.aSet ) );

  var exp =
  {
    'grab' : dst.aGrab,
    'get' : dst.aGet,
    'put' : dst.aPut,
    'set' : dst.aSet,
    'move' : false,
  }
  test.identical( declared.a.normalizedAsuite, exp );

  /* */

  test.case = 'deduce setter from put and get from grab, object has methods, with _, addingMethods:1';
  var dst =
  {
    'a' : 'a1',
    'b' : 'b1',
    _aGrab : function() { return this.b },
    _aPut : function( src ) { this.b = src },
  };
  var exp =
  {
    'a' : 'a1',
    'b' : 'a1',
    _aGrab : dst._aGrab,
    aGet : dst._aGrab,
    _aPut : dst._aPut,
    aSet : dst._aPut,
  }
  var declared = _.accessor.declare
  ({
    object : dst,
    names : { a : {} },
    prime : 0,
    strict : 0,
    addingMethods : 1,
  });
  test.identical( _.property.onlyOwn( dst, { onlyEnumerable : 0 } ), exp );

  var exp =
  {
    'grab' : dst._aGrab,
    'get' : dst.aGet,
    'put' : dst._aPut,
    'set' : dst.aSet,
    'move' : false,
  }
  test.identical( declared.a.normalizedAsuite, exp );

  /* */

  test.case = 'deduce setter from put and get from grab, object does not have methods, with _, addingMethods:1';
  var methods =
  {
    _aGrab : function() { return this.b },
    _aPut : function( src ) { this.b = src },
  }
  var dst =
  {
    'a' : 'a1',
    'b' : 'b1',
  };
  var exp =
  {
    'a' : 'a1',
    'b' : 'a1',
    aGrab : methods._aGrab,
    aGet : methods._aGrab,
    aSet : methods._aPut,
    aPut : methods._aPut,
  }
  var declared = _.accessor.declare
  ({
    object : dst,
    methods,
    names : { a : {} },
    prime : 0,
    strict : 0,
    addingMethods : 1,
  });
  test.identical( _.property.onlyOwn( dst, { onlyEnumerable : 0 } ), exp );

  var exp =
  {
    'grab' : dst.aGrab,
    'get' : dst.aGet,
    'put' : dst.aPut,
    'set' : dst.aSet,
    'move' : false,
  }
  test.identical( declared.a.normalizedAsuite, exp );

  /* */

  test.case = 'functors instead of accessors';

  function put_functor( o )
  {
    o = _.routineOptions( put_functor, arguments );
    let symbol = Symbol.for( o.propName );
    return function put( val )
    {
      this[ symbol ] = val;
      return val;
    }
  }

  put_functor.defaults =
  {
    propName : null,
  }

  put_functor.identity = { 'accessor' : true, 'put' : true, 'functor' : true };

  test.case = 'set : false, put : explicit';
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
    aPut : put_functor,
    aSet : put_functor,
    aGrab : put_functor,
    aGet : put_functor,
  };
  var names =
  {
    a : {},
  }
  var got = _.accessor.declare
  ({
    object,
    names,
    prime : 0,
    strict : 0,
    addingMethods : 1,
    preservingValue : 1,
  });

  /* */

  test.case = 'already has method get';

  var dst =
  {
    'a' : 'a1',
    'b' : 'b1',
    aGrab : function() { return this.b },
    aGet : function() { return this.b },
    aPut : function( src ) { this.b = src },
    aSet : function( src ) { this.b = src },
  };

  if( Config.debug )
  test.shouldThrowErrorSync( () =>
  {
    var declared = _.accessor.declare
    ({
      object : dst,
      names : { a : { get : function() { return this.b } } },
      prime : 0,
      strict : 0,
      addingMethods : 1,
    });
  });

  /* */

  test.case = 'already has method get';

  var dst =
  {
    'a' : 'a1',
    'b' : 'b1',
    aGet : function() { return this.b },
  };

  if( Config.debug )
  test.shouldThrowErrorSync( () =>
  {
    var declared = _.accessor.declare
    ({
      object : dst,
      names : { a : { get : function() { return this.b } } },
      prime : 0,
      strict : 0,
      addingMethods : 1,
    });
  });

  /* */

  test.case = 'already has method grab';

  var dst =
  {
    'a' : 'a1',
    'b' : 'b1',
    aGrab : function() { return this.b },
  };

  if( Config.debug )
  test.shouldThrowErrorSync( () =>
  {
    var declared = _.accessor.declare
    ({
      object : dst,
      names : { a : { grab : function() { return this.b } } },
      prime : 0,
      strict : 0,
      addingMethods : 1,
    });
  });

  /* */

  test.case = 'already has method set';

  var dst =
  {
    'a' : 'a1',
    'b' : 'b1',
    aSet : function( src ) { this.b = src },
  };

  if( Config.debug )
  test.shouldThrowErrorSync( () =>
  {
    var declared = _.accessor.declare
    ({
      object : dst,
      names : { a : { set : function( src ) { this.b = src } } },
      prime : 0,
      strict : 0,
      addingMethods : 1,
    });
  });

  /* */

  test.case = 'already has method put';

  var dst =
  {
    'a' : 'a1',
    'b' : 'b1',
    aPut : function( src ) { this.b = src },
  };

  if( Config.debug )
  test.shouldThrowErrorSync( () =>
  {
    var declared = _.accessor.declare
    ({
      object : dst,
      names : { a : { put : function( src ) { this.b = src } } },
      prime : 0,
      strict : 0,
      addingMethods : 1,
    });
  });

  /* */

}

//

function accessorOptionPreserveValues( test )
{

  /* */

  test.case = 'not symbol, explicit put, preservingValue : 1';
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
    aGet : function() { return this.b },
    aSet : function( src ) { this.b = src },
    aPut : function( src ) { this.b = src },
  };
  var exp =
  {
    'a' : 'a1',
    'b' : 'a1',
    aGet : object.aGet,
    aSet : object.aSet,
    aPut : object.aPut,
  }
  _.accessor.declare
  ({
    object,
    names : { a : {} },
    preservingValue : 1,
    prime : 0,
  });
  test.identical( object, exp );

  /* */

  test.case = 'not symbol, explicit put, preservingValue : 0';
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
    aGet : function() { return this.b },
    aSet : function( src ) { this.b = src },
    aPut : function( src ) { this.b = src },
  };
  var exp =
  {
    'a' : 'b1',
    'b' : 'b1',
    aGet : object.aGet,
    aSet : object.aSet,
    aPut : object.aPut,
  }
  _.accessor.declare
  ({
    object,
    names : { a : {} },
    preservingValue : 0,
    prime : 0,
  });
  test.identical( object, exp );

  /* */

  test.case = 'not symbol, no put, preservingValue : 1';
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
    aGet : function() { return this.b },
    aSet : function( src ) { this.b = src },
  };
  var exp =
  {
    'a' : 'a1',
    'b' : 'a1',
    aGet : object.aGet,
    aSet : object.aSet,
  }
  _.accessor.declare
  ({
    object,
    names : { a : {} },
    preservingValue : 1,
    prime : 0,
  });
  test.identical( object, exp );

  /* */

  test.case = 'not symbol, no put, preservingValue : 0';
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
    aGet : function() { return this.b },
    aSet : function( src ) { this.b = src },
  };
  var exp =
  {
    'a' : 'b1',
    'b' : 'b1',
    aGet : object.aGet,
    aSet : object.aSet,
  }
  _.accessor.declare
  ({
    object,
    names : { a : {} },
    preservingValue : 0,
    prime : 0,
  });
  test.identical( object, exp );

  /* */

  test.case = 'default getter/setter, preservingValue : 1';
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
  };
  var exp =
  {
    'a' : 'a1',
    'b' : 'b1',
  }
  var names =
  {
    a : {},
  }
  _.accessor.declare
  ({
    object,
    names,
    prime : 0,
    strict : 0,
    addingMethods : 0,
    preservingValue : 1,
  });
  test.identical( object, exp );

  /* */

  test.case = 'default getter/setter, preservingValue : 0';
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
  };
  var exp =
  {
    'a' : undefined,
    'b' : 'b1',
  }
  var names =
  {
    a : {},
  }
  _.accessor.declare
  ({
    object,
    names,
    prime : 0,
    strict : 0,
    addingMethods : 0,
    preservingValue : 0,
  });
  test.identical( object, exp );

  /* */

}

//

function accessorDeducingMethods( test )
{

  /* */

  function symbolPut_functor( o )
  {
    o = _.routineOptions( symbolPut_functor, arguments );
    let symbol = Symbol.for( o.propName );
    return function put( val )
    {
      this[ symbol ] = val;
      return val;
    }
  }

  symbolPut_functor.defaults =
  {
    propName : null,
  }

  symbolPut_functor.identity = { 'accessor' : true, 'put' : true, 'functor' : true };

  /* */

  test.case = 'set : false, put : explicit';
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
  };
  var names =
  {
    a : { set : false, put : symbolPut_functor },
  }
  var got = _.accessor.declare
  ({
    object,
    names,
    prime : 0,
    strict : 0,
    addingMethods : 1,
    preservingValue : 1,
  });
  var exp =
  {
    'a' : 'a1',
    'b' : 'b1',
  }

  test.shouldThrowErrorSync( () => object.a = 'c' );
  test.identical( object, exp );

  var exp =
  {
    'a' : 'd',
    'b' : 'b1',
    // aPut : object.aPut,
    // aGrab : object.aGrab,
    // aGet : object.aGet,
  }
  object.aPut( 'd' );
  test.identical( object, exp );

  var exp =
  {
    'grab' : object.aGrab,
    'get' : object.aGet,
    'put' : object.aPut,
    'set' : false,
    'move' : false,
  }
  test.identical( got.a.normalizedAsuite, exp );

  /* */

  test.case = 'set : false';
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
  };
  var names =
  {
    a : { set : false },
  }
  var got = _.accessor.declare
  ({
    object,
    names,
    prime : 0,
    strict : 0,
    addingMethods : 1,
    preservingValue : 1,
  });
  var exp =
  {
    'a' : 'a1',
    'b' : 'b1',
    // aGrab : object.aGrab,
    // aGet : object.aGet,
    // aPut : object.aPut,
  }
  test.identical( object, exp );

  test.shouldThrowErrorSync( () => object.a = 'c' );
  test.identical( object, exp );

  var exp =
  {
    'a' : 'd',
    'b' : 'b1',
    // aGrab : object.aGrab,
    // aGet : object.aGet,
    // aPut : object.aPut,
  }
  object.aPut( 'd' );
  test.identical( object, exp );

  var exp =
  {
    'grab' : object.aGrab,
    'get' : object.aGet,
    'put' : object.aPut,
    'set' : false,
    'move' : false,
  }
  test.identical( got.a.normalizedAsuite, exp );

  /* */

  test.case = 'put : false, set : true';
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
  };
  var names =
  {
    a : { put : false, set : true },
  }
  var got = _.accessor.declare
  ({
    object,
    names,
    prime : 0,
    strict : 0,
    addingMethods : 1,
    preservingValue : 1,
  });

  var exp =
  {
    'a' : 'a1',
    'b' : 'b1',
    // aGrab : object.aGrab,
    // aGet : object.aGet,
    // aSet : object.aSet,
  }
  test.identical( object, exp );

  var exp =
  {
    'a' : 'd',
    'b' : 'b1',
    // aGrab : object.aGrab,
    // aGet : object.aGet,
    // aSet : object.aSet,
  }
  object.aSet( 'd' );
  test.identical( object, exp );

  var exp =
  {
    'a' : 'e',
    'b' : 'b1',
    // aGrab : object.aGrab,
    // aGet : object.aGet,
    // aSet : object.aSet,
  }
  object.a = 'e';
  test.identical( object, exp );

  var exp =
  {
    'grab' : object.aGrab,
    'get' : object.aGet,
    'set' : object.aSet,
    'put' : false,
    'move' : false,
  }
  test.identical( got.a.normalizedAsuite, exp );

  /* */

  test.case = 'put : false';
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
  };
  var names =
  {
    a : { put : false },
  }
  var got = _.accessor.declare
  ({
    object,
    names,
    prime : 0,
    strict : 0,
    addingMethods : 1,
    preservingValue : 1,
  });

  var exp =
  {
    'a' : 'a1',
    'b' : 'b1',
    // aGrab : object.aGrab,
    // aGet : object.aGet,
  }
  test.identical( object, exp );

  test.shouldThrowErrorSync( () => object.aSet( 'd' ) );

  var exp =
  {
    'grab' : object.aGrab,
    'get' : object.aGet,
    'put' : false,
    'set' : false,
    'move' : false,
  }
  test.identical( got.a.normalizedAsuite, exp );

  /* */

}

//

function accessorUnfunct( test )
{

  /* */

  test.case = 'unfunct getter';
  var counter = 0;
  function getter_functor( fop )
  {
    counter += 1;
    var exp = { propName : 'a' };
    test.identical( fop, exp );
    return function get()
    {
      counter += 1;
      return this.b;
    }
  }
  getter_functor.identity = { 'accessor' : true, 'get' : true, 'functor' : true };
  // getter_functor.identity = [ 'accessor', 'getter', 'functor' ];
  getter_functor.defaults =
  {
    propName : null,
  }
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
    aGet : getter_functor,
  };
  var exp =
  {
    'a' : 'b1',
    'b' : 'b1',
    aGet : object.aGet,
  }
  _.accessor.declare
  ({
    object,
    names : { a : {} },
    prime : 0,
    strict : 0,
  });
  test.identical( object, exp );
  test.identical( counter, 3 );

  /* */

  test.case = 'unfunct setter';
  var counter = 0;
  function setter_functor( fop )
  {
    counter += 1;
    var exp = { propName : 'a' };
    test.identical( fop, exp );
    return function set( src )
    {
      counter += 1;
      return this.b = src;
    }
  }
  setter_functor.identity = { 'accessor' : true, 'set' : true, 'functor' : true };
  // setter_functor.identity = [ 'accessor', 'setter', 'functor' ];
  setter_functor.defaults =
  {
    propName : null,
  }
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
    aSet : setter_functor,
    aGet : function() { return this.b },
  };
  var exp =
  {
    'a' : 'a1',
    'b' : 'a1',
    aSet : object.aSet,
    aGet : object.aGet,
  }
  _.accessor.declare
  ({
    object,
    names : { a : {} },
    prime : 0,
    strict : 0,
  });
  test.identical( object, exp );
  test.identical( counter, 3 );

  object.a = 'c';
  var exp =
  {
    'a' : 'c',
    'b' : 'c',
    aSet : object.aSet,
    aGet : object.aGet,
  }
  test.identical( object, exp );
  test.identical( counter, 4 );

  /* */

  test.case = 'unfunct putter';
  var counter = 0;
  function putter_functor( fop )
  {
    counter += 1;
    var exp = { propName : 'a' };
    test.identical( fop, exp );
    return function set( src )
    {
      counter += 1;
      return this.b = src;
    }
  }
  putter_functor.identity = { 'accessor' : true, 'put' : true, 'functor' : true };
  // putter_functor.identity = [ 'accessor', 'put', 'functor' ];
  putter_functor.defaults =
  {
    propName : null,
  }
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
    aPut : putter_functor,
    aGet : function() { return this.b },
  };
  var exp =
  {
    'a' : 'a1',
    'b' : 'a1',
    aPut : object.aPut,
    aGet : object.aGet,
  }
  _.accessor.declare
  ({
    object,
    names : { a : {} },
    prime : 0,
    strict : 0,
  });
  test.identical( object, exp );
  test.identical( counter, 3 );

  object.a = 'c';
  var exp =
  {
    'a' : 'c',
    'b' : 'c',
    aPut : object.aPut,
    aGet : object.aGet,
  }
  test.identical( object, exp );
  test.identical( counter, 4 );

  /* */

  test.case = 'unfunct suite';
  var counter = 0;
  function accessor_functor( fop )
  {
    counter += 1;
    var exp = { propName : 'a' };
    test.identical( fop, exp );
    return {
      get : function() { return this.b },
      set : function set( src )
      {
        counter += 1;
        return this.b = src;
      }
    }
  }
  accessor_functor.identity = { 'accessor' : true, 'functor' : true };
  // accessor_functor.identity = [ 'accessor', 'functor' ];
  accessor_functor.defaults =
  {
    propName : null,
  }
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
  };
  var exp =
  {
    'a' : 'a1',
    'b' : 'a1',
  }
  _.accessor.declare
  ({
    object,
    names : { a : {} },
    suite : accessor_functor,
    prime : 0,
    strict : 0,
  });
  test.identical( object, exp );
  test.identical( counter, 2 );

  object.a = 'c';
  var exp =
  {
    'a' : 'c',
    'b' : 'c',
  }
  test.identical( object, exp );
  test.identical( counter, 3 );

  /* */

}

//

function accessorUnfunctGetSuite( test )
{

  /* - */

  function get_functor( o )
  {

    _.assert( arguments.length === 1, 'Expects single argument' );
    _.routineOptions( get_functor, o );
    _.assert( _.strDefined( o.propName ) );

    if( o.accessor.configurable === null )
    o.accessor.configurable = 1;
    let configurable = o.accessor.configurable;
    if( configurable === null )
    configurable = _.accessor.DeclarationDefaults.configurable;
    _.assert( _.boolLike( configurable ) );

    if( o.accessorKind === 'suite' )
    {
      let result =
      {
        get : get_functor,
        set : false,
        put : false,
      }
      return result;
    }

    return function get()
    {
      if( configurable )
      {
        let o2 =
        {
          enumerable : false,
          configurable : false,
          value : 'abc3',
        }
        Object.defineProperty( this, o.propName, o2 );
        return 'abc2'
      }
      return 'abc1';
    }

  }

  get_functor.defaults =
  {
    propName : null,
    accessor : null,
    accessorKind : null,
  }

  get_functor.identity = { 'accessor' : true, 'suite' : true, 'get' : true, 'functor' : true };
  // get_functor.identity = [ 'accessor', 'suite', 'getter', 'functor' ];

  /* - */

  test.case = 'configurable : 1, set : 0, put : 0';
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
  };
  var names =
  {
    _ : { get : get_functor, set : false, put : false, configurable : true },
    a : {},
  }
  _.accessor.declare
  ({
    object,
    names,
    prime : 0,
    strict : 0,
    addingMethods : 1,
  });
  var exp =
  {
    'get' : object._Get,
    'set' : object._Set,
    'enumerable' : true,
    'configurable' : true
  }
  test.identical( _.prototype.propertyDescriptorGet( object, '_' ).descriptor, exp );
  var exp =
  {
    'a' : 'a1',
    'b' : 'b1',
    '_' : 'abc2',
    // 'aGrab' : object.aGrab,
    // 'aGet' : object.aGet,
    // 'aPut' : object.aPut,
    // 'aSet' : object.aSet,
    // '_Grab' : object._Grab,
    // '_Get' : object._Get,
  }
  test.identical( object, exp );
  test.identical( object.a, exp.a );
  test.identical( object.b, exp.b );
  var exp = { 'writable' : false, 'enumerable' : false, 'configurable' : false, value : 'abc3' }
  test.identical( _.prototype.propertyDescriptorGet( object, '_' ).descriptor, exp );

  /* */

  test.case = 'configurable : 0, set : 0, put : 0';
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
  };
  var names =
  {
    _ : { get : get_functor, set : false, put : false, configurable : false },
    a : {},
  }
  _.accessor.declare
  ({
    object,
    names,
    prime : 0,
    strict : 0,
    addingMethods : 1,
  });
  var exp =
  {
    'get' : object._Get,
    'set' : undefined,
    'enumerable' : true,
    'configurable' : false,
  }
  test.identical( _.prototype.propertyDescriptorGet( object, '_' ).descriptor, exp );
  var exp =
  {
    'a' : 'a1',
    'b' : 'b1',
    '_' : 'abc1',
    // 'aGrab' : object.aGrab,
    // 'aGet' : object.aGet,
    // 'aPut' : object.aPut,
    // 'aSet' : object.aSet,
    // '_Grab' : object._Grab,
    // '_Get' : object._Get,
  }
  test.identical( object, exp );
  test.identical( object.a, exp.a );
  test.identical( object.b, exp.b );
  var exp =
  {
    'get' : object._Get,
    'set' : undefined,
    'enumerable' : true,
    'configurable' : false,
  }
  test.identical( _.prototype.propertyDescriptorGet( object, '_' ).descriptor, exp );

  /* */

  test.case = 'configurable : 0';
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
  };
  var names =
  {
    _ : { get : get_functor },
    a : {},
  }
  _.accessor.declare
  ({
    object,
    names,
    prime : 0,
    strict : 0,
    addingMethods : 1,
  });
  var exp =
  {
    'get' : object._Get,
    'set' : object._Set,
    'enumerable' : true,
    'configurable' : true,
  }
  test.identical( _.prototype.propertyDescriptorGet( object, '_' ).descriptor, exp );
  var exp =
  {
    'a' : 'a1',
    'b' : 'b1',
    // 'aGrab' : object.aGrab,
    // 'aGet' : object.aGet,
    // 'aPut' : object.aPut,
    // 'aSet' : object.aSet,
    // '_Grab' : object._Grab,
    // '_Get' : object._Get,
    // '_Put' : object._Put,
    // '_Set' : object._Set,
    '_' : 'abc2',
  }
  test.identical( object, exp );
  test.identical( object.a, exp.a );
  test.identical( object.b, exp.b );
  var exp = { 'writable' : false, 'enumerable' : false, 'configurable' : false, 'value' : 'abc3' };
  test.identical( _.prototype.propertyDescriptorGet( object, '_' ).descriptor, exp );

  /* */

  test.case = 'suite';
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
  };
  var names =
  {
    _ : get_functor,
    a : {},
  }
  _.accessor.declare
  ({
    object,
    names,
    prime : 0,
    strict : 0,
    addingMethods : 1,
  });
  var exp =
  {
    'get' : object._Get,
    'set' : object._Set,
    'enumerable' : true,
    'configurable' : true
  }
  test.identical( _.prototype.propertyDescriptorGet( object, '_' ).descriptor, exp );
  var exp =
  {
    'a' : 'a1',
    'b' : 'b1',
    '_' : 'abc2',
    // 'aGrab' : object.aGrab,
    // 'aGet' : object.aGet,
    // 'aPut' : object.aPut,
    // 'aSet' : object.aSet,
    // '_Grab' : object._Grab,
    // '_Get' : object._Get,
    // '_Put' : object._Put,
    // '_Set' : object._Set,
  }
  test.identical( object, exp );
  test.identical( object.a, exp.a );
  test.identical( object.b, exp.b );
  var exp = { 'writable' : false, 'enumerable' : false, 'configurable' : false, 'value' : 'abc3' };
  test.identical( _.prototype.propertyDescriptorGet( object, '_' ).descriptor, exp );

  /* */

  test.case = 'suite in fields';
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
  };
  var names =
  {
    _ : { suite : get_functor },
    a : {},
  }

  _.accessor.declare
  ({
    object,
    names,
    prime : 0,
    strict : 0,
    addingMethods : 1,
  });
  var exp =
  {
    'get' : object._Get,
    'set' : object._Set,
    'enumerable' : true,
    'configurable' : true
  }
  test.identical( _.prototype.propertyDescriptorGet( object, '_' ).descriptor, exp );
  var exp =
  {
    'a' : 'a1',
    'b' : 'b1',
    '_' : 'abc2',
    // 'aGrab' : object.aGrab,
    // 'aGet' : object.aGet,
    // 'aPut' : object.aPut,
    // 'aSet' : object.aSet,
    // '_Grab' : object._Grab,
    // '_Get' : object._Get,
    // '_Put' : object._Put,
    // '_Set' : object._Set,
  }
  test.identical( object, exp );
  test.identical( object.a, exp.a );
  test.identical( object.b, exp.b );
  var exp = { 'writable' : false, 'enumerable' : false, 'configurable' : false, 'value' : 'abc3' };
  test.identical( _.prototype.propertyDescriptorGet( object, '_' ).descriptor, exp );

  /* */

  test.case = 'suite in fields, explicit configurable';
  var object =
  {
    'a' : 'a1',
    'b' : 'b1',
  };
  var names =
  {
    _ : { suite : get_functor, configurable : false },
    a : {},
  }
  _.accessor.declare
  ({
    object,
    names,
    prime : 0,
    strict : 0,
    addingMethods : 1,
  });
  var exp =
  {
    'get' : object._Get,
    'set' : object._Set,
    'enumerable' : true,
    'configurable' : false
  }
  test.identical( _.prototype.propertyDescriptorGet( object, '_' ).descriptor, exp );
  var exp =
  {
    'a' : 'a1',
    'b' : 'b1',
    '_' : 'abc1',
    // 'aGrab' : object.aGrab,
    // 'aGet' : object.aGet,
    // 'aPut' : object.aPut,
    // 'aSet' : object.aSet,
    // '_Grab' : object._Grab,
    // '_Get' : object._Get,
    // '_Put' : object._Put,
    // '_Set' : object._Set,
  }
  test.identical( object, exp );
  test.identical( object.a, exp.a );
  test.identical( object.b, exp.b );
  var exp =
  {
    'get' : object._Get,
    'set' : object._Set,
    'enumerable' : true,
    'configurable' : false
  }
  test.identical( _.prototype.propertyDescriptorGet( object, '_' ).descriptor, exp );

  /* */

}

//

function accessorValueOptions( test )
{

  var sets =
  {
    storageIniting : [ 0, 1 ],
    valueGetting : [ 0, 1 ],
    valueSetting : [ 0, 1 ],
    preservingValue : [ 0, 1 ],
  };
  var samples = _.eachSample({ sets }); debugger;

  for( let tops of samples )
  eachCase( tops );

  /* - */

  function eachCase( tops )
  {

    /* */

    if( tops.storageIniting && tops.valueGetting )
    {

      test.case = `storageIniting:${tops.storageIniting}, valueGetting:${tops.valueGetting}, valueSetting:${tops.valueSetting}, preservingValue:${tops.preservingValue}`;

      var env = envMake
      ({
        storageIniting : tops.storageIniting,
        valueGetting : tops.valueGetting,
        valueSetting : tops.valueSetting,
        preservingValue : tops.preservingValue,
      });

      var exp =
      {
        'a' : '2',
        'b' : '1',
        'c' : undefined,
      }
      if( !tops.valueSetting )
      {
        exp =
        {
          'a' : undefined,
          'b' : undefined,
          'c' : undefined,
        }
      }
      if( !tops.preservingValue )
      exp.b = undefined;
      test.identical( env.object, exp );

      var exp = { a : '2', b : '1' }
      if( !tops.valueSetting )
      exp = {}
      if( !tops.preservingValue )
      delete exp.b;
      test.identical( env.object._, exp );

      test.identical( env.optionsA.val, '2' );
      if( tops.preservingValue )
      test.identical( env.optionsB.val, '1' );
      else
      test.identical( env.optionsB.val, _.nothing );
      test.identical( env.optionsC.val, _.nothing );

    }

    /* */

    if( tops.storageIniting && !tops.valueGetting )
    {

      test.case = `storageIniting:${tops.storageIniting}, valueGetting:${tops.valueGetting}, valueSetting:${tops.valueSetting}, preservingValue:${tops.preservingValue}`;

      var env = envMake
      ({
        storageIniting : tops.storageIniting,
        valueGetting : tops.valueGetting,
        valueSetting : tops.valueSetting,
        preservingValue : tops.preservingValue,
      });

      var exp =
      {
        'a' : '2',
        'b' : undefined,
        'c' : undefined,
      }
      if( !tops.valueSetting )
      {
        exp =
        {
          'a' : undefined,
          'b' : undefined,
          'c' : undefined,
        }
      }
      test.identical( env.object, exp );

      var exp = { a : '2' }
      if( !tops.valueSetting )
      exp = {}
      test.identical( env.object._, exp );

      test.identical( env.optionsA.val, '2' );
      test.identical( env.optionsB.val, _.nothing );
      test.identical( env.optionsC.val, _.nothing );

    }

    /* */

    if( !tops.storageIniting )
    {

      test.case = `storageIniting:${tops.storageIniting}, valueGetting:${tops.valueGetting}, valueSetting:${tops.valueSetting}, preservingValue:${tops.preservingValue}`;

      var env = envMake
      ({
        storageIniting : tops.storageIniting,
        valueGetting : tops.valueGetting,
        valueSetting : tops.valueSetting,
        preservingValue : tops.preservingValue,
      });

      test.true( env.object._ === undefined );

      Object.defineProperty( env.object, '_', { enumerable : 0, value : Object.create( null ) } );

      var exp =
      {
        'a' : undefined,
        'b' : undefined,
        'c' : undefined,
      }
      test.identical( env.object, exp );

      var exp = {}
      test.identical( env.object._, exp );

      test.identical( env.optionsA.val, '2' );
      test.identical( env.optionsB.val, _.nothing );
      test.identical( env.optionsC.val, _.nothing );

    }

    /* */

  }

  /* - */

  function envMake( env )
  {

    env.object =
    {
      'a' : '1',
      'b' : '1'
    };

    env.optionsA =
    {
      object : env.object,
      name : 'a',
      prime : 0,
      strict : 0,
      addingMethods : 0,
      val : '2',
      suite : 1,
      storingStrategy : 'underscore',
      storageIniting : env.storageIniting,
      valueGetting : env.valueGetting,
      valueSetting : env.valueSetting,
      preservingValue : env.preservingValue,
    }
    _.accessor.declareSingle( env.optionsA );

    env.optionsB =
    {
      object : env.object,
      name : 'b',
      prime : 0,
      strict : 0,
      addingMethods : 0,
      val : _.nothing,
      suite : 1,
      storingStrategy : 'underscore',
      storageIniting : env.storageIniting,
      valueGetting : env.valueGetting,
      valueSetting : env.valueSetting,
      preservingValue : env.preservingValue,
    }
    _.accessor.declareSingle( env.optionsB );
    /* xxx : write test of reusing options for declareSingle */

    env.optionsC =
    {
      object : env.object,
      name : 'c',
      prime : 0,
      strict : 0,
      addingMethods : 0,
      val : _.nothing,
      suite : 1,
      storingStrategy : 'underscore',
      storageIniting : env.storageIniting,
      valueGetting : env.valueGetting,
      valueSetting : env.valueSetting,
      preservingValue : env.preservingValue,
    }
    _.accessor.declareSingle( env.optionsC );

    return env;
  }

}

//

function accessorLogistic( test )
{

  test.case = 'basic';

  var options =
  {
    name : 'a',
    prime : 0,
    strict : 0,
    addingMethods : 0,
    val : '2',
    suite : 1,
    storingStrategy : 'underscore',
  }

  test.description = 'object1';

  var object1 =
  {
    'a' : '1',
    'b' : '1'
  };
  options.object = object1;
  _.debugger = 1;
  _.accessor.declareSingle( options );

  var exp =
  {
    'a' : '2',
    'b' : '1',
  }
  test.identical( object1, exp );

  var exp = { a : '2' }
  test.identical( object1._, exp );

  delete options.object;
  var exp =
  {
    'name' : 'a',
    'prime' : 0,
    'strict' : 0,
    'addingMethods' : 0,
    'val' : '2',
    'suite' : {},
    'storingStrategy' : 'underscore',
    'grab' : null,
    'get' : null,
    'put' : null,
    'set' : null,
    'move' : null,
    'methods' : null,
    'needed' : true,
    'normalizedAsuite' :
    {
      'grab' : options.normalizedAsuite.grab,
      'get' : options.normalizedAsuite.get,
      'put' : options.normalizedAsuite.put,
      'set' : options.normalizedAsuite.set,
      'move' : false,
    },
    'preservingValue' : true,
    'combining' : null,
    'enumerable' : true,
    'configurable' : true,
    'writable' : true,
    'storageIniting' : true,
    'valueGetting' : true,
    'valueSetting' : true
  }
  test.identical( options, exp );

  test.description = 'object2';

  var object2 =
  {
    'a' : '1',
    'b' : '1'
  };
  options.object = object2;
  _.debugger = 1;
  _.accessor.declareSingle( options );

  var exp =
  {
    'a' : '2',
    'b' : '1',
  }
  test.identical( object2, exp );

  var exp = { a : '2' }
  test.identical( object2._, exp );

  delete options.object;
  var exp =
  {
    'name' : 'a',
    'prime' : 0,
    'strict' : 0,
    'addingMethods' : 0,
    'val' : '2',
    'suite' : {},
    'storingStrategy' : 'underscore',
    'grab' : null,
    'get' : null,
    'put' : null,
    'set' : null,
    'move' : null,
    'methods' : null,
    'needed' : true,
    'normalizedAsuite' :
    {
      'grab' : options.normalizedAsuite.grab,
      'get' : options.normalizedAsuite.get,
      'put' : options.normalizedAsuite.put,
      'set' : options.normalizedAsuite.set,
      'move' : false,
    },
    'preservingValue' : true,
    'combining' : null,
    'enumerable' : true,
    'configurable' : true,
    'writable' : true,
    'storageIniting' : true,
    'valueGetting' : true,
    'valueSetting' : true
  }
  test.identical( options, exp );

}

//

function accessorForbid( test )
{

  test.case = 'accessor forbid getter&setter';
  var Alpha = { };
  _.accessor.forbid( Alpha, { a : 'a' } );
  test.true( _.objectIs( Alpha ) );
  test.shouldThrowErrorSync( () => Alpha.a = 5, ( err, arg, ok ) =>
  {
    Alpha[ Symbol.for( 'a' ) ] = 5;
  });
  var got;
  test.shouldThrowErrorSync( () => got = Alpha.a, ( err, arg, ok ) =>
  {
    got = Alpha[ Symbol.for( 'a' ) ];
  });

  if( !Config.debug ) /* */
  return;

  test.case = 'forbid get';
  test.shouldThrowErrorSync( function()
  {
    var Alpha = { };
    _.accessor.forbid( Alpha, { a : 'a' } );
    Alpha.a;
  });

  test.case = 'forbid set';
  test.shouldThrowErrorSync( function()
  {
    var Alpha = { };
    _.accessor.forbid( Alpha, { a : 'a' } );
    Alpha.a = 5;
  });

  test.case = 'empty call';
  test.shouldThrowErrorSync( function()
  {
    _.accessor.forbid( );
  });

  test.case = 'invalid first argument type';
  test.shouldThrowErrorSync( function()
  {
    _.accessor.forbid( 1, { a : 'a' } );
  });

  test.case = 'invalid second argument type';
  test.shouldThrowErrorSync( function()
  {
    _.accessor.forbid( {}, 1 );
  });

}

//

function forbidWithoutConstructor( test )
{

  /* */

  test.case = 'basic';

  var proto = Object.create( null );
  proto.a = 'a1';

  var dst = Object.create( proto );
  dst.b = 'b2';

  var exp = { 'b' : 'b2' }

  var names = { abc : 'abc' }
  _.accessor.forbid
  ({
    object : dst,
    names : names,
  });

  test.contains( dst, exp );
  test.shouldThrowErrorSync( () => dst.abc = 'abc' );

  /* */

}

//

function accessorMoveBasic( test )
{

  /* */

  test.case = 'basic';

  var track = [];
  var ins1 =
  {
    aMove : function( it )
    {
      console.log( 'accessorKind', it.accessorKind );
      track.push( it.accessorKind );
      if( it.accessorKind === 'set' || it.accessorKind === 'put' )
      {
        it.value += 1;
        it.dstInstance[ Symbol.for( 'a' ) ] = it.value;
      }
      else
      {
        it.value = it.srcInstance[ Symbol.for( 'a' ) ];
      }
    },
    a : 10,
    b : 20,
  };

  _.accessor.declare
  ({
    object : ins1,
    names : { a : 'a' },
    prime : 0,
  });

  test.identical( track, [ 'put' ] );
  var exp = { 'a' : 11, 'b' : 20, 'aMove' : ins1.aMove }
  test.identical( ins1, exp );
  test.identical( track, [ 'put', 'get' ] );

  ins1.a = 30;

  test.identical( track, [ 'put', 'get', 'set' ] );
  var exp = { 'a' : 31, 'b' : 20, 'aMove' : ins1.aMove }
  test.identical( ins1, exp );
  test.identical( track, [ 'put', 'get', 'set', 'get' ] );

  /* */

}

//

function accessorStoringStrategyUnderscoreBasic( test )
{

  /* */

  test.case = 'basic';

  var ins1 =
  {
    f1 : 1,
  }

  _.accessor.declare( ins1, { f2 : { storingStrategy : 'underscore' } } );

  var exp =
  {
    f1 : 1,
    f2 : undefined,
    _ : {}
  }
  test.identical( _.property.onlyOwn( ins1, { onlyEnumerable : 0 } ), exp );

  var exp =
  {
    f1 : 1,
    f2 : 3,
    _ : { f2 : 3 }
  }
  ins1.f2 = 3;
  test.identical( _.property.onlyOwn( ins1, { onlyEnumerable : 0 } ), exp );

  /* */

  test.case = 'val from accessor';

  var ins1 =
  {
    f1 : 1,
  }

  _.accessor.declare( ins1, { f2 : { val : 2, storingStrategy : 'underscore' } } );

  var exp =
  {
    f1 : 1,
    f2 : 2,
    _ : { f2 : 2 }
  }
  test.identical( _.property.onlyOwn( ins1, { onlyEnumerable : 0 } ), exp );

  var exp =
  {
    f1 : 1,
    f2 : 3,
    _ : { f2 : 3 }
  }
  ins1.f2 = 3;
  test.identical( _.property.onlyOwn( ins1, { onlyEnumerable : 0 } ), exp );

  /* */

  test.case = 'val from object';

  var ins1 =
  {
    f1 : 1,
    f2 : 2,
  }

  _.accessor.declare( ins1, { f2 : { storingStrategy : 'underscore' } } );

  var exp =
  {
    f1 : 1,
    f2 : 2,
    _ : { f2 : 2 }
  }
  test.identical( _.property.onlyOwn( ins1, { onlyEnumerable : 0 } ), exp );

  var exp =
  {
    f1 : 1,
    f2 : 3,
    _ : { f2 : 3 }
  }
  ins1.f2 = 3;
  test.identical( _.property.onlyOwn( ins1, { onlyEnumerable : 0 } ), exp );

  /* */

  test.case = 'val from accesor, but object has val too';

  var ins1 =
  {
    f1 : 1,
    f2 : 22,
  }

  _.accessor.declare( ins1, { f2 : { val : 2, storingStrategy : 'underscore' } } );

  var exp =
  {
    f1 : 1,
    f2 : 2,
    _ : { f2 : 2 }
  }
  test.identical( _.property.onlyOwn( ins1, { onlyEnumerable : 0 } ), exp );

  var exp =
  {
    f1 : 1,
    f2 : 3,
    _ : { f2 : 3 }
  }
  ins1.f2 = 3;
  test.identical( _.property.onlyOwn( ins1, { onlyEnumerable : 0 } ), exp );

  /* */

  test.case = 'writable : 0';

  var ins1 =
  {
    f1 : 1,
    f2 : 22,
  }

  _.accessor.declare( ins1, { f2 : { val : 2, storingStrategy : 'underscore', writable : 0 } } );

  var exp =
  {
    f1 : 1,
    f2 : 2,
    _ : { f2 : 2 }
  }
  test.identical( _.property.onlyOwn( ins1, { onlyEnumerable : 0 } ), exp );

  var exp =
  {
    f1 : 1,
    f2 : 2,
    _ : { f2 : 2 }
  }
  test.shouldThrowErrorSync( () => ins1.f2 = 3 );
  test.identical( _.property.onlyOwn( ins1, { onlyEnumerable : 0 } ), exp );

  /* */

}

//

function accessorStoringStrategyUnderscorePrototyped( test )
{

  /* */

  test.case = 'proto has f1';

  var proto1 = Object.create( null );
  proto1.f1 = 1;
  var ins1 = Object.create( proto1 );

  _.accessor.declare( ins1, { f1 : { storingStrategy : 'underscore', preservingValue : 1 } } );

  var exp =
  {
    f1 : undefined,
  }
  test.identical( _.property.of( ins1 ), exp );
  test.identical( _.prototype.each( ins1 ).length, 2 );
  var exp =
  {
  }
  test.identical( _.property.of( ins1._ ), exp );
  test.identical( _.prototype.each( ins1._ ).length, 1 );

  test.description = 'set'; /* */

  ins1.f1 = 2;
  var exp =
  {
    f1 : 2,
  }
  test.identical( _.property.of( ins1 ), exp );
  test.identical( _.prototype.each( ins1 ).length, 2 );
  var exp =
  {
    f1 : 2,
  }
  test.identical( _.property.of( ins1._ ), exp );
  test.identical( _.prototype.each( ins1._ ).length, 1 );
  test.true( _.prototype.each( ins1._ )[ 1 ] === proto1._ );

  /* */

  test.case = 'proto has underscore';

  var proto1 = Object.create( null );
  proto1._ = Object.create( null );
  var ins1 = Object.create( proto1 );

  _.accessor.declare( ins1, { f1 : { storingStrategy : 'underscore', preservingValue : 1 } } );

  var exp =
  {
    f1 : undefined,
  }
  test.identical( _.property.of( ins1 ), exp );
  test.identical( _.prototype.each( ins1 ).length, 2 );
  var exp =
  {
  }
  test.identical( _.property.of( ins1._ ), exp );
  test.identical( _.prototype.each( ins1._ ).length, 2 );
  test.true( _.prototype.each( ins1._ )[ 1 ] === proto1._ );
  var exp =
  {
  }
  test.identical( _.property.of( proto1._ ), exp );

  test.description = 'set'; /* */

  ins1.f1 = 2;
  var exp =
  {
    f1 : 2,
  }
  test.identical( _.property.of( ins1 ), exp );
  test.identical( _.prototype.each( ins1 ).length, 2 );
  var exp =
  {
    f1 : 2,
  }
  test.identical( _.property.of( ins1._ ), exp );
  test.identical( _.prototype.each( ins1._ ).length, 2 );
  test.true( _.prototype.each( ins1._ )[ 1 ] === proto1._ );
  var exp =
  {
  }
  test.identical( _.property.of( proto1._ ), exp );

  /* */

  test.case = 'proto has underscore with f1';

  var proto1 = Object.create( null );
  proto1._ = Object.create( null );
  proto1._.f1 = 1;
  var ins1 = Object.create( proto1 );

  _.accessor.declare( ins1, { f1 : { storingStrategy : 'underscore', preservingValue : 1 } } );

  var exp =
  {
    f1 : 1,
  }
  test.identical( _.property.of( ins1 ), exp );
  test.identical( _.prototype.each( ins1 ).length, 2 );
  var exp =
  {
    f1 : 1,
  }
  test.identical( _.property.of( ins1._ ), exp );
  test.identical( _.prototype.each( ins1._ ).length, 2 );
  test.true( _.prototype.each( ins1._ )[ 1 ] === proto1._ );
  var exp =
  {
    f1 : 1,
  }
  test.identical( _.property.of( proto1._ ), exp );

  test.description = 'set'; /* */

  ins1.f1 = 2;
  var exp =
  {
    f1 : 2,
  }
  test.identical( _.property.of( ins1 ), exp );
  test.identical( _.prototype.each( ins1 ).length, 2 );
  var exp =
  {
    f1 : 2,
  }
  test.identical( _.property.of( ins1._ ), exp );
  test.identical( _.prototype.each( ins1._ ).length, 2 );
  test.true( _.prototype.each( ins1._ )[ 1 ] === proto1._ );
  var exp =
  {
    f1 : 1,
  }
  test.identical( _.property.of( proto1._ ), exp );

  /* */

}

//

function accessorStoringStrategyUnderscoreIniting( test )
{

  /* */

  test.case = 'control';

  var obj1 = {};
  var accessor1 = {};
  var returned = _.accessor.declare( obj1, { a : { suite : accessor1, storingStrategy : 'underscore' } } );

  var got = Object.getOwnPropertyDescriptor( obj1, 'a' );
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

  var exp =
  {
    a : undefined,
  }
  test.identical( obj1, exp );

  var exp =
  {
  }
  test.identical( obj1._, exp );

  test.true( _.objectIs( obj1._ ) );

  /* */

  test.case = 'full suite';

  var obj1 = {};
  var accessor1 = { get : get1, set : set1, grab : grab1, put : put1, move : move1 };
  var returned = _.accessor.declare( obj1, { a : { suite : accessor1, storingStrategy : 'underscore' } } );

  var got = Object.getOwnPropertyDescriptor( obj1, 'a' );
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

  var exp =
  {
    a : 1,
  }
  test.identical( obj1, exp );

  test.true( obj1._ === undefined );

  /* */

  test.case = 'get + set';

  var obj1 = {};
  var accessor1 = { get : get1, set : set1 };
  var returned = _.accessor.declare( obj1, { a : { suite : accessor1, storingStrategy : 'underscore' } } );

  var exp =
  {
    a : 1,
  }
  test.identical( obj1, exp );
  test.true( obj1._ === undefined );

  /* */

  test.case = 'grab + put';

  var obj1 = {};
  var accessor1 = { grab : grab1, put : put1 };
  var returned = _.accessor.declare( obj1, { a : { suite : accessor1, storingStrategy : 'underscore' } } );

  var exp =
  {
    a : 3,
  }
  test.identical( obj1, exp );
  test.true( obj1._ === undefined );

  /* */

  test.case = 'grab only';

  var obj1 = {};
  var accessor1 = { grab : grab1 };
  var returned = _.accessor.declare( obj1, { a : { suite : accessor1, storingStrategy : 'underscore' } } );

  var exp =
  {
    a : 3,
  }
  test.identical( obj1, exp );
  test.true( _.objectIs( obj1._ ) );

  /* */

  test.case = 'get only';

  var obj1 = {};
  var accessor1 = { get : get1 };
  var returned = _.accessor.declare( obj1, { a : { suite : accessor1, storingStrategy : 'underscore' } } );

  var exp =
  {
    a : 1,
  }
  test.identical( obj1, exp );
  test.true( _.objectIs( obj1._ ) );

  /* */

  test.case = 'put only';

  var obj1 = {};
  var accessor1 = { put : put1 };
  var returned = _.accessor.declare( obj1, { a : { suite : accessor1, storingStrategy : 'underscore' } } );

  var exp =
  {
    a : undefined,
  }
  test.identical( obj1, exp );
  test.true( _.objectIs( obj1._ ) );

  /* */

  test.case = 'set only';

  var obj1 = {};
  var accessor1 = { set : set1 };
  var returned = _.accessor.declare( obj1, { a : { suite : accessor1, storingStrategy : 'underscore' } } );

  var exp =
  {
    a : undefined,
  }
  test.identical( obj1, exp );
  test.true( _.objectIs( obj1._ ) );

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

// --
// declare
// --

let Self =
{

  name : 'Tools.l2.blueprint.Accessor',
  silencing : 1,

  tests :
  {

    _normalizedAsuiteForm,
    _objectSetValueNoShadowing,

    declareBasic,

    declareConstant,
    declareConstantSymbol,
    declareConstantWithDefinition,
    declareConstantSymbolWithDefinition,

    accessorMethodsDeducing,
    accessorOptionReadOnly,
    accessorOptionAddingMethods,
    accessorOptionPreserveValues,
    accessorDeducingMethods,
    accessorUnfunct,
    accessorUnfunctGetSuite,
    accessorValueOptions,
    accessorLogistic,

    accessorForbid,
    forbidWithoutConstructor,

    accessorMoveBasic,
    accessorStoringStrategyUnderscoreBasic, /* qqq : write similar test routine with option static:1 */
    accessorStoringStrategyUnderscorePrototyped, /* qqq : write similar test routine with option static:1 */
    accessorStoringStrategyUnderscoreIniting,

  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
