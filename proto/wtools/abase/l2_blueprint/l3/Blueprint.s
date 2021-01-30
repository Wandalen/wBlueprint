( function _Blueprint_s_() {

'use strict';

let _global = _global_;
let _ = _global_.wTools;

// --
// implementation
// --

function is( blueprint )
{
  if( !blueprint )
  return false;
  return _.prototypeIsPrototypeOf( _.Blueprint.prototype, blueprint );
}

//

function isDefinitive( blueprint )
{
  if( !blueprint )
  return false;
  return _.prototypeIsPrototypeOf( _.Blueprint.prototype, blueprint ) && !!blueprint.TraitsMap;
}

//

function isRuntime( runtime )
{
  if( !runtime )
  return false;
  return _.prototypeIsPrototypeOf( _.Blueprint.prototype, runtime ) && !runtime.TraitsMap;
}

//

function isBlueprintOf( blueprint, construction )
{
  _.assert( arguments.length === 2 );
  _.assert( _.blueprint.isDefinitive( blueprint ) );
  return _.construction.isInstanceOf( construction, blueprint );
}

//

function compileSourceCode( blueprint )
{
  _.assert( arguments.length === 1 );
  _.assert( 0, 'not implemented' );
  let generator = _.Generator();
  // generator.external( x ); /* zzz : implement */
  generator.import
  ({
    src : _.construction._construct2
  });
  return generator.generateSourceCode();
}

//

function defineConstructor()
{
  let blueprint = _.blueprint.define( ... arguments );
  _.assert( _.routineIs( blueprint.Make ) );
  return blueprint.Make;
}

//

function define()
{
  return _.blueprint._define({ src : arguments, amending : 'extend' });
}

//

function _define( o )
{

  _.routineOptions( _define, o );
  _.assert( arguments.length === 1 );

  let runtime = Object.create( _.Blueprint.prototype );
  runtime._RuntimeRoutinesMap = Object.create( null );
  runtime.PropsExtension = Object.create( null );
  runtime.PropsSupplementation = Object.create( null );
  runtime.prototype = null;
  runtime.Reprototyping = null;
  runtime.Name = null;
  runtime.Typed = null;
  runtime._MakingTyped = null;
  runtime.Make = null;
  runtime.MakeEach = MakeEach;
  runtime.From = From;
  runtime.FromEach = FromEach;
  runtime.Retype = Retype;
  runtime.RetypeEach = RetypeEach;
  runtime.Runtime = runtime;
  Object.preventExtensions( runtime );

  let blueprint = Object.create( runtime );
  blueprint.TraitsMap = Object.create( null );
  blueprint.NamedMap = Object.create( null );
  blueprint.UnnamedArray = [];
  Object.preventExtensions( blueprint );

  _.blueprint._amend
  ({
    blueprint,
    extension : o.src,
    amending : o.amending,
    blueprintAction : 'inherit',
  });

  let defContext = Object.create( null );
  defContext.blueprint = blueprint;
  defContext.amending = o.amending;

  let defaultSupplement =
  [
    _.trait.extendable( false ),
    _.trait.typed({ val : false, prototype : false }),
  ]

  _.blueprint._supplement( blueprint, defaultSupplement );

  _.blueprint._associateDefinitions( blueprint );
  defContext.stage = 'blueprintForm1';
  _.blueprint._form( defContext );

  runtime.Typed = blueprint.TraitsMap.typed.val;
  runtime._MakingTyped = false;
  runtime._MakingTyped = false;
  if( blueprint.TraitsMap.typed.val === true )
  runtime._MakingTyped = true;
  else if( blueprint.TraitsMap.typed.val === _.maybe && blueprint.TraitsMap.typed.prototype && blueprint.TraitsMap.typed.prototype !== Object.prototype )
  runtime._MakingTyped = true;
  runtime.Reprototyping = blueprint.TraitsMap.typed.prototype;

  let Name = blueprint.Name || 'Construction';
  let Construction =
  {
    [ Name ] : function()
    {
      return _.construction._make( this, runtime, arguments );
    }
  }
  let Make = Construction[ Name ];
  Object.setPrototypeOf( Make, null );
  Make.prototype = blueprint.prototype;

  runtime.Make = Make;
  Make.Runtime = runtime;

  defContext.stage = 'blueprintForm2';
  _.blueprint._form( defContext );
  defContext.stage = 'blueprintForm3';
  _.blueprint._form( defContext );

  _.blueprint._preventExtensions( blueprint );
  _.blueprint._validate( blueprint );

  _.assert( blueprint.Name === null || blueprint.Name === Name );

  return blueprint;

  /* */

  function MakeEach()
  {
    return _.construction._makeEach( this, runtime, arguments );
  }

  /* */

  function From()
  {
    return _.construction._from( this, runtime, arguments );
  }

  /* */

  function FromEach()
  {
    return _.construction._fromEach( this, runtime, arguments );
  }

  /* */

  function Retype()
  {
    return _.construction._retype( this, runtime, arguments );
  }

  /* */

  function RetypeEach()
  {
    return _.construction._retypeEach( this, runtime, arguments );
  }

  /* */

}

_define.defaults =
{
  src : null,
  amending : 'extend'
}

//

function _amend( o )
{

  _.assert( arguments.length === 1 );
  _.routineOptions( _amend, arguments );
  _.assert( _.longHas( [ 'extend', 'supplement' ], o.amending ) );
  _.assert( _.longHas( [ 'throw', 'amend', 'inherit' ], o.blueprintAction ) );

  _amendAct( o.extension, null );

  return o.blueprint;

  /* -

- amendWithArray
- amendWithMap
- amendWithBlueprint1
- amendWithBlueprint2
- amendWithDefinition
- amendWithNamedDefinition
- blueprintNamedDefinitionRewrite
- amendWithUnnamedDefinition
- blueprintUnnamedDefinitionRewrite
- amendWithTrait
- blueprintTraitRewrite
- amendWithPrimitive
- definitionCloneMaybe
- definitionDepthCheck

  */

  function _amendAct( src, name )
  {
    if( _.longIs( src ) )
    amendWithArray( src, name );
    else if( _.blueprint.isDefinitive( src ) )
    amendWithBlueprint1( src, name );
    else if( _.mapIs( src ) )
    amendWithMap(  src, name );
    else if( _.definitionIs( src ) )
    amendWithDefinition( src, name );
    else _.assert( 0, `Not clear how to amend blueprint by the amendment ${_.strType( src )}` );
  }

  /* */

  function amendWithArray( array, name )
  {
    for( let e = 0 ; e < array.length ; e++ )
    _amendAct( array[ e ], null );
  }

  /* */

  function amendWithMap( map )
  {

    _.assert( _.mapIs( map ) );

    for( let name in map )
    {
      let ext = map[ name ];
      if( _.definitionIs( ext ) )
      {
        amendWithDefinition( ext, name );
      }
      else if( _.arrayIs( ext ) )
      {
        amendWithArray( ext, name );
      }
      else if( _.primitiveIs( ext ) || _.routineIs( ext ) )
      {
        amendWithPrimitive( ext, name );
      }
      else
      {
        _amendAct( ext, name );
      }
    }

  }

  /* */

  function amendWithBlueprint1( srcBlueprint )
  {
    if( o.blueprintAction === 'amend' )
    {
      amendWithBlueprint2( srcBlueprint );
      return o.blueprint;
    }
    else if( o.blueprintAction === 'inherit' )
    {
      let extension = _.define.inherit( srcBlueprint );
      _amendAct( extension );
    }
    else
    {
      debugger;
      throw _.err( 'Not clear how to extend by blueprint' );
    }
  }

  /* */

  function amendWithBlueprint2( ext, k )
  {
    o.blueprintDepth += 1;
    for( let k in ext.TraitsMap )
    {
      let definition = ext.TraitsMap[ k ];
      if( definitionDepthCheck( definition ) )
      amendWithTrait( definition, k );
    }
    for( let k = 0 ; k < ext.UnnamedArray.length ; k++ )
    {
      let definition = ext.UnnamedArray[ k ];
      if( definitionDepthCheck( definition ) )
      amendWithUnnamedDefinition( definition, k );
    }
    for( let k in ext.NamedMap )
    {
      let definition = ext.NamedMap[ k ];
      if( definitionDepthCheck( definition ) )
      amendWithNamedDefinition( definition.cloneShallow(), k );
    }
    for( let k in ext.PropsSupplementation )
    {
      amendWithPrimitive( ext.PropsSupplementation[ k ], k );
    }
    for( let k in ext.PropsExtension )
    {
      amendWithPrimitive( ext.PropsExtension[ k ], k );
    }
    o.blueprintDepth -= 1;
  }

  /* */

  function amendWithDefinition( definition, name )
  {
    if( _.traitIs( definition ) )
    amendWithTrait( definition, name );
    else if( definition.defGroup === 'definition.named' )
    amendWithNamedDefinition( definition, name );
    else
    amendWithUnnamedDefinition( definition, name );
  }

  /* */

  function amendWithNamedDefinition( srcDefinition, name )
  {
    _.assert( srcDefinition.defGroup === 'definition.named' );
    _.assert( _.strDefined( name ) || _.strDefined( srcDefinition.name ) );
    _.assert( name === null || srcDefinition.name === null || name === srcDefinition.name );

    if( name && name !== srcDefinition.name )
    {
      _.assert( !Object.isFrozen( srcDefinition ) );
      srcDefinition.name = name;
    }

    let dstDefinition = o.blueprint.NamedMap[ name ] || null;

    srcDefinition = definitionCloneMaybe( srcDefinition );

    let blueprintDefinitionRewrite2 = ( dstDefinition && dstDefinition.blueprintDefinitionRewrite ) || ( srcDefinition && srcDefinition.blueprintDefinitionRewrite );

    _.assert( _.strDefined( srcDefinition.name ) );

    let o2 = _.mapExtend( null, o );
    o2.blueprintDefinitionRewrite = blueprintNamedDefinitionRewrite;
    o2.name = srcDefinition.name;
    o2.defGroup = 'definition.named';

    if( o.amending === 'supplement' )
    {
      o2.primeDefinition = dstDefinition;
      o2.secondaryDefinition = srcDefinition;
    }
    else
    {
      o2.primeDefinition = srcDefinition;
      o2.secondaryDefinition = dstDefinition;
    }

    o2.definition = srcDefinition;

    if( blueprintDefinitionRewrite2 )
    {
      _.assert( !dstDefinition || _.routineIs( dstDefinition.blueprintDefinitionRewrite ) );
      _.assert( _.routineIs( srcDefinition.blueprintDefinitionRewrite ) );
      srcDefinition.blueprintDefinitionRewrite( o2 );
    }
    else
    {
      o2.blueprintDefinitionRewrite( o2 );
    }

  }

  /* */

  function blueprintNamedDefinitionRewrite( op )
  {

    if( op.secondaryDefinition && !op.primeDefinition )
    op.blueprint.NamedMap[ op.name ] = op.secondaryDefinition;
    else
    op.blueprint.NamedMap[ op.name ] = op.primeDefinition;

  }

  /* */

  function amendWithUnnamedDefinition( srcDefinition )
  {
    _.assert( srcDefinition.defGroup === 'definition.unnamed' );

    let dstDefinition = o.blueprint.TraitsMap[ srcDefinition.kind ] || null;

    srcDefinition = definitionCloneMaybe( srcDefinition );

    let blueprintDefinitionRewrite2 = ( dstDefinition && dstDefinition.blueprintDefinitionRewrite ) || ( srcDefinition && srcDefinition.blueprintDefinitionRewrite );

    let o2 = _.mapExtend( null, o );
    o2.blueprintDefinitionRewrite = blueprintUnnamedDefinitionRewrite;
    o2.defGroup = 'definition.unnamed';

    if( o.amending === 'supplement' )
    {
      o2.primeDefinition = dstDefinition;
      o2.secondaryDefinition = srcDefinition;
    }
    else
    {
      o2.primeDefinition = srcDefinition;
      o2.secondaryDefinition = dstDefinition;
    }

    o2.definition = srcDefinition;

    if( blueprintDefinitionRewrite2 )
    {
      _.assert( !dstDefinition || _.routineIs( dstDefinition.blueprintDefinitionRewrite ) );
      _.assert( _.routineIs( srcDefinition.blueprintDefinitionRewrite ) );
      srcDefinition.blueprintDefinitionRewrite( o2 );
    }
    else
    {
      o2.blueprintDefinitionRewrite( o2 );
    }

  }

  /* */

  function blueprintUnnamedDefinitionRewrite( op )
  {
    _.arrayAppendOnceStrictly( o.blueprint.UnnamedArray, op.primeDefinition || op.secondaryDefinition );
  }

  /* */

  function amendWithTrait( srcDefinition, key )
  {
    _.assert( _.strIs( srcDefinition.kind ) );

    srcDefinition = definitionCloneMaybe( srcDefinition );

    let dstDefinition = o.blueprint.TraitsMap[ srcDefinition.kind ] || null;
    let blueprintDefinitionRewrite2 = ( dstDefinition && dstDefinition.blueprintDefinitionRewrite ) || ( srcDefinition && srcDefinition.blueprintDefinitionRewrite );

    _.assert( dstDefinition === null || _.definitionIs( dstDefinition ) );

    let o2 = _.mapExtend( null, o );
    o2.blueprintDefinitionRewrite = blueprintTraitRewrite;
    o2.kind = srcDefinition.kind;

    if( o.amending === 'supplement' )
    {
      o2.primeDefinition = dstDefinition;
      o2.secondaryDefinition = srcDefinition;
    }
    else
    {
      o2.primeDefinition = srcDefinition;
      o2.secondaryDefinition = dstDefinition;
    }

    o2.definition = srcDefinition;

    if( blueprintDefinitionRewrite2 )
    {

      _.assert( !dstDefinition || _.routineIs( dstDefinition.blueprintDefinitionRewrite ) );
      _.assert( _.routineIs( srcDefinition.blueprintDefinitionRewrite ) );
      srcDefinition.blueprintDefinitionRewrite( o2 );

    }
    else
    {

      o2.blueprintDefinitionRewrite( o2 );

    }

  }

  /* */

  function blueprintTraitRewrite( op )
  {
    if( op.secondaryDefinition && !op.primeDefinition )
    op.blueprint.TraitsMap[ op.kind ] = op.secondaryDefinition;
    else
    op.blueprint.TraitsMap[ op.kind ] = op.primeDefinition;
  }

  /* */

  function amendWithPrimitive( ext, key )
  {
    _.assert( _.strIs( key ) );
    _.assert
    (
      _.primitiveIs( ext ) || _.routineIs( ext ),
      () => `Property could be prtimitive or routine, but element ${key} is ${_.strType( key )}.`
      + `\nUse _.define.*() to defined more complex data structure`
    );
    if( o.amending === 'supplement' )
    if( Object.hasOwnProperty.call( o.blueprint.PropsExtension, key ) )
    return;
    if( Object.hasOwnProperty.call( o.blueprint.PropsSupplementation, key ) )
    return;
    o.blueprint.PropsExtension[ key ] = ext;
  }

  /* */

  function definitionCloneMaybe( definition ) /* xxx : introduce standard clone? */
  {
    if( definition._blueprint )
    {
      definition = definition.cloneShallow();
      if( definition._blueprint === null )
      definition._blueprint = o.blueprint;
    }
    _.assert( definition._blueprint === o.blueprint || definition._blueprint === null || definition._blueprint === false );
    return definition;
  }

  /* */

  function definitionDepthCheck( definition )
  {
    if( !definition.blueprintDepthLimit )
    return true;
    return definition.blueprintDepthLimit + definition.blueprintDepthReserve + o.blueprintDepthReserve > o.blueprintDepth;
  }

  /* */

}

_amend.defaults =
{
  blueprint : null,
  extension : null,
  amending : null,
  blueprintAction : 'throw',
  blueprintDepth : 0,
  blueprintDepthReserve : 0,
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

function _associateDefinitions( blueprint )
{
  _.assert( arguments.length === 1 );
  _.assert( _.blueprint.isDefinitive( blueprint ) );

  _.blueprint.eachDefinition( blueprint, ( blueprint, definition, key ) =>
  {
    if( definition._blueprint === false )
    {
      _.assert( Object.isFrozen( definition ) );
      return;
    }
    if( definition._blueprint === blueprint )
    return;
    _.assert( definition._blueprint === null );
    if( definition.kind === 'extend' ) /* xxx */
    debugger;
    _.assert( !Object.isFrozen( definition ) );
    definition._blueprint = blueprint;
  });

  return blueprint;
}

//

function _form( o )
{
  _.assert( arguments.length === 1 );
  _.assert( _.blueprint.isDefinitive( o.blueprint ) );
  _.assert( _.longHas( [ 'blueprintForm1', 'blueprintForm2', 'blueprintForm3' ], o.stage ) );
  _.routineOptions( _form, o );

  _.blueprint.eachDefinition( o.blueprint, ( blueprint, definition, propName ) =>
  {
    if( definition[ o.stage ] )
    {
      o.propName = propName;
      o.definition = definition;
      _.assert( definition._blueprint === false || definition._blueprint === o.blueprint );
      definition[ o.stage ]( o );
      _.assert( definition._blueprint === false || definition._blueprint === o.blueprint );
    }
  });

  delete o.propName;
  delete o.definition;

  return o.blueprint;
}

_form.defaults =
{
  blueprint : null,
  stage : null,
  amending : 'extend'
}

//

function _preventExtensions( blueprint )
{
  _.assert( _.blueprint.isDefinitive( blueprint ) );

  Object.preventExtensions( blueprint.NamedMap );
  Object.preventExtensions( blueprint.UnnamedArray );
  Object.preventExtensions( blueprint.TraitsMap );
  Object.preventExtensions( blueprint.PropsExtension );
  Object.preventExtensions( blueprint.PropsSupplementation );
  Object.preventExtensions( blueprint._RuntimeRoutinesMap );
  Object.preventExtensions( blueprint );
  Object.freeze( blueprint );

}

//

function _validate( blueprint )
{

  if( !Config.debug )
  return;

  _.assert( _.blueprint.isDefinitive( blueprint ) );
  _.assert
  (
    _.routineIs( blueprint._RuntimeRoutinesMap.allocate )
    , `Each blueprint should have handler::allocate, but definition::${blueprint.name} does not have`
  );
  _.assert
  (
    _.routineIs( blueprint._RuntimeRoutinesMap.retype )
    , `Each blueprint should have handler::retype, but definition::${blueprint.name} does not have`
  );
  _.assert( !blueprint.TraitsMap.typed || blueprint.Typed === blueprint.TraitsMap.typed.val || blueprint.TraitsMap.typed.val === _.maybe );

  _.blueprint.eachDefinition( blueprint, ( blueprint, definition, key ) =>
  {
    if( definition._blueprint === false )
    {
      _.assert( Object.isFrozen( definition ) );
      return;
    }
    _.assert
    (
      definition._blueprint === blueprint
      , () => `Blueprint of ${_.definition.qnameOf( definition )} is not set, but have to be set`
    );
    _.assert
    (
      !Object.isExtensible( definition )
      , () => `${_.definition.qnameOf( definition )} is extensible, but have to be not`
    );
    _.assert
    (
      Object.isFrozen( definition )
      , () => `${_.definition.qnameOf( definition )} is not frozen, but have to be frozen`
    );
  });

}

//

function _routineAdd( blueprint, name, routine )
{

  _.assert( _.routineIs( routine ) );
  _.assert( _.mapIs( _.definition.ConstructionRuntimeRoutines[ name ] ), `Unknown runtime routine::${name}` );

  let descriptor = _.definition.ConstructionRuntimeRoutines[ name ];

  if( descriptor.multiple )
  {
    blueprint._RuntimeRoutinesMap[ name ] = blueprint._RuntimeRoutinesMap[ name ] || [];
    blueprint._RuntimeRoutinesMap[ name ].push( routine );
  }
  else
  {
    _.assert( blueprint._RuntimeRoutinesMap[ name ] === undefined, `Blueprint already have runtime routine::${name}` );
    blueprint._RuntimeRoutinesMap[ name ] = routine;
  }

}

//

function eachDefinition( blueprint, onEach )
{
  _.assert( arguments.length === 2 );
  _.assert( _.blueprint.isDefinitive( blueprint ) );

  for( let k in blueprint.TraitsMap )
  {
    let trait = blueprint.TraitsMap[ k ];
    onEach( blueprint, trait, k );
  }

  for( let k in blueprint.NamedMap )
  {
    let definition = blueprint.NamedMap[ k ];
    onEach( blueprint, definition, k );
  }

  for( let k = 0 ; k < blueprint.UnnamedArray.length ; k++ )
  {
    let definition = blueprint.UnnamedArray[ k ];
    onEach( blueprint, definition, null );
  }

}

//

function nameOf( blueprint )
{
  _.assert( _.blueprint.is( blueprint ) );
  return blueprint.Name;
}

//

function qnameOf( blueprint )
{
  _.assert( _.blueprint.is( blueprint ) );
  return `Blueprint::${blueprint.Name || ''}`;
}

//

function constructorOf( blueprint )
{
  let result = blueprint.Make;
  _.assert( _.blueprint.isDefinitive( blueprint ) );
  _.assert( _.routineIs( result ) );
  return result;
}

//

function retyperOf( blueprint )
{
  let result = blueprint.Retype;
  _.assert( _.blueprint.isDefinitive( blueprint ) );
  _.assert( _.routineIs( result ) );
  return result;
}

//

function construct( blueprint )
{
  _.assert( arguments.length === 1 );

  if( !_.blueprint.isDefinitive( blueprint ) )
  blueprint = _.blueprint.define( blueprint );

  let construct = _.blueprint.constructorOf( blueprint );
  _.assert( _.routineIs( construct ), 'Cant find constructor for blueprint' );
  let construction = construct();
  return construction;
}

//

function retype( blueprint, construction )
{
  _.assert( arguments.length === 2 );
  _.assert( !!construction );

  if( !_.blueprint.isDefinitive( blueprint ) )
  blueprint = _.blueprint.define( blueprint );

  let retyper = _.blueprint.retyperOf( blueprint );
  _.assert( _.routineIs( retyper ), 'Cant find retyped for blueprint' );
  let construction2 = retyper( construction );
  _.assert( construction === construction2 );
  return construction;
}

//

function qnameOfDefinition( blueprint, definition )
{

  _.assert( arguments.length === 2 );
  _.assert( _.blueprint.isDefinitive( blueprint ) );
  _.assert( _.definition.is( definition ) );

  if( _.definition.trait.is( definition ) )
  {
    for( let k in blueprint.TraitsMap )
    {
      if( blueprint.TraitsMap[ k ] === definition )
      return `trait::${k}`
    }
  }
  else
  {
    for( let k in blueprint.NamedMap )
    {
      if( blueprint.NamedMap[ k ] === definition )
      return `definition::${k}`
    }
    for( let k = 0 ; k < blueprint.UnnamedArray.length ; k++ )
    {
      if( blueprint.UnnamedArray[ k ] === definition )
      return `definition::${k}`
    }
  }

  return;
}

// --
// define blueprint
// --

var BlueprintExtension =
{

  // routines

  is,
  isDefinitive,
  isRuntime,
  isBlueprintOf,

  compileSourceCode,
  defineConstructor,
  define,
  _define,
  _amend,
  _supplement,
  _extend,
  _associateDefinitions,
  _form,
  _preventExtensions,
  _validate,

  _routineAdd,
  eachDefinition,

  nameOf,
  qnameOf,
  constructorOf,
  retyperOf,
  construct,
  retype,
  qnameOfDefinition,

}

_.blueprint = _.blueprint || Object.create( null );
Object.assign( _.blueprint, BlueprintExtension );

// --
// define tools
// --

var ToolsExtension =
{
}

Object.assign( _, ToolsExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
