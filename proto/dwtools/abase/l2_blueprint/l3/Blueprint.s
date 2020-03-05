( function _Blueprint_s_() {

'use strict';

let _global = _global_;
let _ = _global_.wTools;

// --
// implementation
// --

function is( blueprint )
{
  return _.isPrototypeOf( _.Blueprint, blueprint );
}

//

function isBlueprintOf( blueprint, construction )
{
  _.assert( arguments.length === 2 );
  _.assert( _.blueprint.is( blueprint ) );
  return _.construction.isInstanceOf( construction, blueprint );
}

//

function isRuntime( runtime )
{
  if( !runtime )
  return false;
  return Object.getPrototypeOf( runtime ) === _.BlueprintRuntime;
}

//

function blueprintIsBlueprintOf( construction )
{
  let blueprint = this;
  _.assert( arguments.length === 1 );
  _.assert( _.blueprint.is( blueprint ) );
  return _.blueprint.isBlueprintOf( blueprint, construction );
}

//

function compileSourceCode( blueprint )
{
  _.assert( arguments.length === 1 );
  let generator = _.Generator();

  // generator.external( x ); /* zzz : implement */

  generator.import
  ({
    src : _.construction.makeWithRuntime
  });

  return generator.generateSourceCode();
}

//

function blueprintCompileSourceCode()
{
  let blueprint = this;
  _.assert( arguments.length === 0 );
  return _.blueprint.compileSourceCode( blueprint );
}

//

function define()
{
  let blueprint = Object.create( _.Blueprint );
  blueprint.namedDefinitions = Object.create( null );
  blueprint.unnamedDefinitions = [];
  // blueprint.extensions = []; /* zzz : implement extensions, supplemetations and structure to track order of amending */
  // blueprint.supplementations = [];
  blueprint.traits = Object.create( null );
  blueprint.fields = Object.create( null );
  blueprint.constructionHandlers = Object.create( null );

  let defaultSupplement =
  {
    extendable : _.trait.extendable( false ),
    typed : _.trait.typed( false ),
  }

  for( let a = 0 ; a < arguments.length ; a++ )
  {
    _.blueprint._amend
    ({
      blueprint,
      extension : arguments[ a ],
      amending : 'extend',
      blueprintAction : 'prototype+extend',
    });
  }

  _.blueprint._supplement( blueprint, defaultSupplement );

  let construct = Construction;
  construct.prototype = Object.create( _.Construction.prototype );
  _.assert( _.routineIs( _.Construction ) );
  _.assert( _.mapIs( _.Construction.prototype ) );

  blueprint.construct = construct;
  // construct.blueprint = blueprint

  _.blueprint._blueprintForm( blueprint );

  let runtime = Object.create( _.BlueprintRuntime );
  runtime.constructionHandlers = blueprint.constructionHandlers;
  runtime.fields = blueprint.fields;
  runtime.construct = construct;
  runtime.typed = blueprint.traits.typed.value;
  Object.preventExtensions( runtime );

  blueprint.runtime = runtime;
  construct.runtime = runtime;

  Object.preventExtensions( blueprint );
  Object.preventExtensions( blueprint.namedDefinitions );
  Object.preventExtensions( blueprint.unnamedDefinitions );
  Object.preventExtensions( blueprint.traits );
  Object.preventExtensions( blueprint.fields );
  Object.preventExtensions( blueprint.constructionHandlers );

  return blueprint;

  /* */

  function Construction() /* zzz : implement naming trait */
  {
    let construction = this;

    if( construction === undefined )
    {
      construction = null;
    }
    else if( _.blueprint.is( construction ) )
    {
      construction = null;
    }
    else if( arguments.length === 1 && arguments[ 0 ] === runtime.construct )
    {
      /* if argument is its own constructr then typed container is only what needed */
      return construction;
    }

    if( runtime.makeCompiled ) /* zzz */
    debugger;
    if( runtime.makeCompiled )
    construction = runtime.makeCompiled( construction, arguments );
    else
    construction = _.construction.makeWithRuntime( construction, runtime, arguments );

    return construction;
  }

  /* */

}

//

function _amend( o )
{

  _.assert( arguments.length === 1 );

  if( _.longIs( o.extension ) )
  {
    for( let e = 0 ; e < o.extension.length ; e++ )
    _.blueprint._amend({ ... o, extension : o.extension[ e ] });
    return o.blueprint;
  }

  _.routineOptions( _amend, arguments );
  _.assert( _.longHas( [ 'extend', 'supplement' ], o.amending ) );
  _.assert( _.mapLike( o.extension ) );
  _.assert( _.longHas( [ 'throw', 'amend', 'prototype+extend' ], o.blueprintAction ) )

  if( _.blueprint.is( o.extension ) )
  {
    if( o.blueprintAction === 'amend' )
    {
      extendWithBlueprint( o.extension );
      return o.blueprint;
    }
    else if( o.blueprintAction === 'prototype+extend' )
    {
      o.extension =
      {
        prototype : _.trait.prototype( o.extension ),
        extension : _.define.extension( o.extension ),
        typed : _.trait.typed( true ),
      };
    }
    else
    {
      debugger;
      throw _.err( 'Cant extend by blueprint' );
    }

  }

  for( let k in o.extension )
  {
    let ext = o.extension[ k ];
    if( _.definitionIs( ext ) )
    {
      if( _.traitIs( ext ) )
      extendWithTrait( ext, k );
      else if( ext.definitionGroup === 'definition.named' )
      extendWithNamedDefinition( ext, k );
      else
      extendWithUnnamedDefinition( ext, k );
    }
    else
    {
      extendWithPrimitive( ext, k );
    }
  }

  return o.blueprint;

  /* */

  function extendWithTrait( ext, key )
  {
    _.assert( _.strIs( ext.kind ) );

    if( o.amending === 'supplement' )
    if( o.blueprint.traits[ ext.kind ] !== undefined )
    return;

    o.blueprint.traits[ ext.kind ] = ext;

    if( ext.blueprintAmend )
    ext.blueprintAmend( o );
  }

  /* */

  function extendWithNamedDefinition( ext, key )
  {
    _.assert( ext.definitionGroup === 'definition.named' );

    if( o.amending === 'supplement' )
    if( o.blueprint.namedDefinitions[ key ] !== undefined )
    return;

    _.assert( o.blueprint.namedDefinitions[ key ] === undefined, 'not tested' ); /* zzz : test */

    o.blueprint.namedDefinitions[ key ] = ext;
    ext.name = key;

    if( ext.blueprintAmend )
    ext.blueprintAmend( o );
  }

  /* */

  function extendWithUnnamedDefinition( ext )
  {
    _.assert( ext.definitionGroup === 'definition.unnamed' );
    o.blueprint.unnamedDefinitions.push( ext );
    if( ext.blueprintAmend )
    ext.blueprintAmend( o );
  }

  /* */

  function extendWithBlueprint( ext, k )
  {
    for( let k in ext.fields )
    {
      extendWithPrimitive( ext.fields[ k ], k );
    }
    for( let k in ext.namedDefinitions )
    {
      let definition = ext.namedDefinitions[ k ]
      extendWithNamedDefinition( definition.clone(), k );
    }
    for( let k = 0 ; k < ext.unnamedDefinitions.length ; k++ )
    {
      let definition = ext.unnamedDefinitions[ k ]
      extendWithUnnamedDefinition( definition, k );
    }
    for( let k in ext.traits )
    {
      extendWithTrait( ext.traits[ k ], k );
    }
  }

  /* */

  function extendWithPrimitive( ext, key )
  {
    _.assert
    (
      _.primitiveIs( ext ) || _.routineIs( ext ),
      () => `Field could be prtimitive or routine, but element ${key} is ${_.strType( key )}.\nUse _.defined.* to defined more complex data structure`
    );
    if( o.amending === 'supplement' )
    if( o.blueprint.fields[ key ] !== undefined )
    return;
    o.blueprint.fields[ key ] = ext;
  }

  /* */

}

_amend.defaults =
{
  blueprint : null,
  extension : null,
  amending : null,
  blueprintAction : 'throw',
}

//

function _supplement( blueprint, extension )
{
  return _.blueprint._amend
  ({
    blueprint,
    extension,
    amending : 'supplement',
  });
}

//

function _extend( blueprint, extension )
{
  return _.blueprint._amend
  ({
    blueprint,
    extension,
    amending : 'extend',
  });
}

//

function _blueprintForm( blueprint )
{
  _.assert( arguments.length === 1 );
  _.assert( _.blueprint.is( blueprint ) );

  let handlersNames = [ 'blueprintForm1', 'blueprintForm2', 'blueprintForm3' ];

  for( let n = 0 ; n < handlersNames.length ; n++ )
  {
    let name = handlersNames[ n ];
    _.blueprint.eachDefinition( blueprint, ( blueprint, definition, key ) =>
    {
      if( definition[ name ] )
      definition[ name ]( blueprint, key );
    });
  }

  _.assert( _.routineIs( blueprint.constructionHandlers.allocate ), `Each blueprint should have handler::allocate, but definition::${blueprint.name} does not have` );

  return blueprint;
}

//

function eachDefinition( blueprint, onEach )
{
  _.assert( arguments.length === 2 );
  _.assert( _.blueprint.is( blueprint ) );

  for( let k in blueprint.traits )
  {
    let trait = blueprint.traits[ k ];
    onEach( blueprint, trait, k );
  }

  for( let k in blueprint.namedDefinitions )
  {
    let definition = blueprint.namedDefinitions[ k ];
    onEach( blueprint, definition, k );
  }

  for( let k = 0 ; k < blueprint.unnamedDefinitions.length ; k++ )
  {
    let definition = blueprint.unnamedDefinitions[ k ];
    onEach( blueprint, definition, k );
  }

}

//

function defineConstructor()
{
  let blueprint = _.blueprint.define( ... arguments );
  return blueprint.construct;
}

//

function constructorOf( blueprint )
{
  let result = blueprint.construct;
  _.assert( _.blueprint.is( blueprint ) );
  _.assert( _.routineIs( result ) );
  return result;
}

//

function construct( blueprint )
{
  let result;
  _.assert( arguments.length === 1 );

  if( !_.blueprint.is( blueprint ) )
  {
    blueprint = _.blueprint.define( blueprint );
  }

  let construct = _.blueprint.constructorOf( blueprint );
  _.assert( _.routineIs( construct ), 'Cant find constructor for blueprint' );
  let construction2 = construct();
  return construction2;
}

//

function definitionQualifiedName( blueprint, definition )
{

  _.assert( arguments.length === 2 );
  _.assert( _.blueprint.is( blueprint ) );
  _.assert( _.definition.is( definition ) );

  if( _.definition.trait.is( definition ) )
  {
    for( let k in blueprint.traits )
    {
      if( blueprint.traits[ k ] === definition )
      return `trait::${k}`
    }
  }
  else
  {
    for( let k in blueprint.namedDefinitions )
    {
      if( blueprint.namedDefinitions[ k ] === definition )
      return `definition::${k}`
    }
    for( let k = 0 ; k < blueprint.unnamedDefinitions.length ; k++ )
    {
      if( blueprint.unnamedDefinitions[ k ] === definition )
      return `definition::${k}`
    }
  }

  return;
}

// --
// declare
// --

let BlueprintRuntime = Object.create( null );
Object.preventExtensions( BlueprintRuntime );

let Blueprint = Object.create( null );
Blueprint.isBlueprintOf = blueprintIsBlueprintOf;
Blueprint.compileSourceCode = blueprintCompileSourceCode;
Object.preventExtensions( Blueprint );

let blueprint = function Blueprint()
{
  return _.blueprint.define( ... arguments );
}

// --
// define blueprint
// --

var BlueprintExtension =
{

  // routines

  is,
  isBlueprintOf,
  isRuntime,
  compileSourceCode,
  define,
  _amend,
  _supplement,
  _extend,
  _blueprintForm,
  eachDefinition,

  defineConstructor,
  constructorOf,
  construct,
  definitionQualifiedName,

}

Object.assign( blueprint, BlueprintExtension );

// --
// define tools
// --

var ToolsExtension =
{

  // routines

  blueprint,

  // fields

  BlueprintRuntime,
  Blueprint,

}

_.assert( _.blueprint === undefined );
Object.assign( _, ToolsExtension );

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _;

})();
