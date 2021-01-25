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
  return _.prototypeIsPrototypeOf( _.Blueprint.prototype, blueprint ) && !!blueprint.Traits;
}

//

function isRuntime( runtime )
{
  if( !runtime )
  return false;
  return _.prototypeIsPrototypeOf( _.Blueprint.prototype, runtime ) && !runtime.Traits;
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
  return _.blueprint._define({ args : arguments, amending : 'extend' });
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
  blueprint.Traits = Object.create( null );
  blueprint._NamedDefinitionsMap = Object.create( null );
  blueprint._UnnamedDefinitionsArray = [];
  Object.preventExtensions( blueprint );

  /* xxx : remove the cycle */
  for( let a = 0 ; a < o.args.length ; a++ )
  {
    _.blueprint._amend
    ({
      blueprint,
      extension : o.args[ a ],
      amending : o.amending,
      blueprintAction : 'inherit',
    });
  }

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

  if( _global_.debugger )
  debugger;

  runtime.Typed = blueprint.Traits.typed.val;
  runtime._MakingTyped = false;
  runtime._MakingTyped = false;
  if( blueprint.Traits.typed.val === true )
  runtime._MakingTyped = true;
  else if( blueprint.Traits.typed.val === _.maybe && blueprint.Traits.typed.prototype && blueprint.Traits.typed.prototype !== Object.prototype )
  runtime._MakingTyped = true;
  runtime.Reprototyping = blueprint.Traits.typed.prototype;

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
  args : null,
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
      // _.definition.forInheritance( o.extension );
      // let extension =
      // {
      //   extension : _.define.extension( o.extension ),
      //   // prototype : _.trait.prototype( o.extension ),
      //   // typed : _.trait.typed( true ),
      //   typed : _.trait.typed( true, { prototype : o.extension } ),
      // };
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
    for( let k in ext.PropsExtension )
    {
      amendWithPrimitive( ext.PropsExtension[ k ], k );
    }
    for( let k in ext.PropsSupplementation )
    {
      amendWithPrimitive( ext.PropsSupplementation[ k ], k );
    }
    for( let k in ext._NamedDefinitionsMap )
    {
      let definition = ext._NamedDefinitionsMap[ k ];
      if( definitionDepthCheck( definition ) )
      amendWithNamedDefinition( definition.clone(), k );
    }
    for( let k = 0 ; k < ext._UnnamedDefinitionsArray.length ; k++ )
    {
      let definition = ext._UnnamedDefinitionsArray[ k ];
      if( definitionDepthCheck( definition ) )
      amendWithUnnamedDefinition( definition, k );
    }
    for( let k in ext.Traits )
    {
      let definition = ext.Traits[ k ];
      if( definitionDepthCheck( definition ) )
      amendWithTrait( definition, k );
    }
    o.blueprintDepth -= 1;
  }

  /* */

  function amendWithDefinition( definition, name )
  {
    if( _.traitIs( definition ) )
    amendWithTrait( definition, name );
    else if( definition.definitionGroup === 'definition.named' )
    amendWithNamedDefinition( definition, name );
    else
    amendWithUnnamedDefinition( definition, name );
  }

  /* */

  function amendWithNamedDefinition( srcDefinition, name )
  {
    _.assert( srcDefinition.definitionGroup === 'definition.named' );
    _.assert( _.strDefined( name ) || _.strDefined( srcDefinition.name ) );
    _.assert( name === null || srcDefinition.name === null || name === srcDefinition.name );

    if( name && name !== srcDefinition.name )
    srcDefinition.name = name;

    if( _global_.debugger )
    debugger;
    let dstDefinition = o.blueprint._NamedDefinitionsMap[ name ] || null;

    srcDefinition = definitionCloneMaybe( srcDefinition );

    let blueprintDefinitionRewrite2 = ( dstDefinition && dstDefinition.blueprintDefinitionRewrite ) || ( srcDefinition && srcDefinition.blueprintDefinitionRewrite );

    _.assert( _.strDefined( srcDefinition.name ) );

    let o2 = _.mapExtend( null, o );
    o2.blueprintDefinitionRewrite = blueprintNamedDefinitionRewrite;
    // o2.dstDefinition = dstDefinition;
    // o2.srcDefinition = srcDefinition;
    o2.name = srcDefinition.name;
    o2.definitionGroup = 'definition.named';

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

    // if( op.amending === 'supplement' )
    // if( op.blueprint._NamedDefinitionsMap[ op.dstDefinition.name ] !== undefined )
    // return;

    // if( op.amending === 'supplement' )
    // if( op.dstDefinition.name )
    // return;
    //
    // op.blueprint._NamedDefinitionsMap[ op.name ] = op.srcDefinition;

    if( _global_.debugger )
    debugger;

    if( op.secondaryDefinition && !op.primeDefinition )
    op.blueprint._NamedDefinitionsMap[ op.name ] = op.secondaryDefinition;
    else
    op.blueprint._NamedDefinitionsMap[ op.name ] = op.primeDefinition;

  }

  /* */

  function amendWithUnnamedDefinition( srcDefinition )
  {
    _.assert( srcDefinition.definitionGroup === 'definition.unnamed' );

    // srcDefinition = definitionCloneMaybe( srcDefinition );
    // o.blueprint._UnnamedDefinitionsArray.push( srcDefinition );
    // if( srcDefinition.blueprintAmend )
    // srcDefinition.blueprintAmend( o );

    let dstDefinition = o.blueprint.Traits[ srcDefinition.kind ] || null;

    srcDefinition = definitionCloneMaybe( srcDefinition );

    let blueprintDefinitionRewrite2 = ( dstDefinition && dstDefinition.blueprintDefinitionRewrite ) || ( srcDefinition && srcDefinition.blueprintDefinitionRewrite );

    let o2 = _.mapExtend( null, o );
    o2.blueprintDefinitionRewrite = blueprintUnnamedDefinitionRewrite;
    // o2.dstDefinition = dstDefinition;
    // o2.srcDefinition = srcDefinition;
    // o2.name = srcDefinition.name;
    o2.definitionGroup = 'definition.unnamed';

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
    _.arrayAppendOnceStrictly( o.blueprint._UnnamedDefinitionsArray, op.primeDefinition || op.secondaryDefinition );
  }

  /* */

  function amendWithTrait( srcDefinition, key )
  {
    _.assert( _.strIs( srcDefinition.kind ) );

    srcDefinition = definitionCloneMaybe( srcDefinition );

    let dstDefinition = o.blueprint.Traits[ srcDefinition.kind ] || null;
    let blueprintDefinitionRewrite2 = ( dstDefinition && dstDefinition.blueprintDefinitionRewrite ) || ( srcDefinition && srcDefinition.blueprintDefinitionRewrite );

    _.assert( dstDefinition === null || _.definitionIs( dstDefinition ) );

    let o2 = _.mapExtend( null, o );
    o2.blueprintDefinitionRewrite = blueprintTraitRewrite;
    o2.kind = srcDefinition.kind;
    // o2.dstDefinition = dstDefinition;
    // o2.srcDefinition = srcDefinition;

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

    if( blueprintDefinitionRewrite2 )
    {
      // let o2 = _.mapExtend( null, o );

      _.assert( !dstDefinition || _.routineIs( dstDefinition.blueprintDefinitionRewrite ) );
      _.assert( _.routineIs( srcDefinition.blueprintDefinitionRewrite ) );

      // o2.dstDefinition = dstDefinition;
      // o2.srcDefinition = srcDefinition;
      //
      // if( o.amending === 'supplement' )
      // {
      //   o2.primeDefinition = dstDefinition;
      //   o2.secondaryDefinition = srcDefinition;
      // }
      // else
      // {
      //   o2.primeDefinition = srcDefinition;
      //   o2.secondaryDefinition = dstDefinition;
      // }

      srcDefinition.blueprintDefinitionRewrite( o2 );

    }
    else
    {

      o2.blueprintDefinitionRewrite( o2 );

      // if( !dstDefinition || o.amending !== 'supplement' )
      // dstDefinition = srcDefinition;

      // if( !dstDefinition || o.amending !== 'supplement' )
      // o.blueprint.Traits[ srcDefinition.kind ] = srcDefinition;

    }

    // if( o.amending === 'supplement' )
    // if( dstDefinition !== undefined )
    // {
    //
    //   if( dstDefinition.blueprintDefinitionRewrite )
    //   {
    //
    //     _.assert( _.routineIs( srcDefinition.blueprintDefinitionRewrite ) );
    //     let o2 = _.mapExtend( null, o );
    //
    //     o2.primeDefinition = dstDefinition;
    //     o2.secondaryDefinition = srcDefinition;
    //
    //     if( dstDefinition.blueprintDefinitionRewrite( o2 ) === false )
    //     return;
    //
    //   }
    //   else
    //   {
    //     return
    //   }
    //
    // }
    //
    // // if( o.amending === 'extend' ) /* xxx */
    // if( dstDefinition && dstDefinition.blueprintDefinitionRewrite )
    // {
    //   _.assert( _.routineIs( srcDefinition.blueprintDefinitionRewrite ) );
    //   let o2 = _.mapExtend( null, o );
    //
    //   o2.primeDefinition = srcDefinition;
    //   o2.secondaryDefinition = dstDefinition;
    //
    //   if( dstDefinition.blueprintDefinitionRewrite( o2 ) === false )
    //   return;
    // }
    // else
    // {
    //   o.blueprint.Traits[ srcDefinition.kind ] = srcDefinition;
    // }
    //
    // if( srcDefinition.blueprintAmend )
    // srcDefinition.blueprintAmend( o );

  }

  /* */

  function blueprintTraitRewrite( op )
  {
    if( op.secondaryDefinition && !op.primeDefinition )
    op.blueprint.Traits[ op.kind ] = op.secondaryDefinition;
    else
    op.blueprint.Traits[ op.kind ] = op.primeDefinition;
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

  function definitionCloneMaybe( defenition )
  {
    if( defenition.blueprint )
    {
      defenition = defenition.clone();
      if( defenition.blueprint )
      defenition.blueprint = null;
      if( defenition._ )
      defenition._ = Object.create( null );
    }
    _.assert( defenition.blueprint === null || defenition.blueprint === false );
    return defenition;
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
    if( definition.blueprint === false )
    return;
    _.assert( definition.blueprint === null || definition.blueprint === false );
    if( definition.kind === 'extend' ) /* xxx */
    debugger;
    _.assert( !Object.isFrozen( definition ) );
    definition.blueprint = blueprint;
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

  let stages = [ o.stage ];
  for( let n = 0 ; n < stages.length ; n++ )
  {
    let stage = stages[ n ];
    _.blueprint.eachDefinition( o.blueprint, ( blueprint, definition, propName ) =>
    {
      if( definition[ stage ] )
      {
        o.propName = propName;
        definition[ stage ]( o );
        delete o.propName;
      }
    });
  }

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

  Object.preventExtensions( blueprint );
  Object.preventExtensions( blueprint._NamedDefinitionsMap );
  Object.preventExtensions( blueprint._UnnamedDefinitionsArray );
  Object.preventExtensions( blueprint.Traits );
  Object.preventExtensions( blueprint.PropsExtension );
  Object.preventExtensions( blueprint.PropsSupplementation );
  Object.preventExtensions( blueprint._RuntimeRoutinesMap );

}

//

function _validate( blueprint )
{
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
  _.assert( !blueprint.Traits.typed || blueprint.Typed === blueprint.Traits.typed.val || blueprint.Traits.typed.val === _.maybe );
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

  for( let k in blueprint.Traits )
  {
    let trait = blueprint.Traits[ k ];
    onEach( blueprint, trait, k );
  }

  for( let k in blueprint._NamedDefinitionsMap )
  {
    let definition = blueprint._NamedDefinitionsMap[ k ];
    onEach( blueprint, definition, k );
  }

  for( let k = 0 ; k < blueprint._UnnamedDefinitionsArray.length ; k++ )
  {
    let definition = blueprint._UnnamedDefinitionsArray[ k ];
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

function definitionQualifiedName( blueprint, definition )
{

  _.assert( arguments.length === 2 );
  _.assert( _.blueprint.isDefinitive( blueprint ) );
  _.assert( _.definition.is( definition ) );

  if( _.definition.trait.is( definition ) )
  {
    for( let k in blueprint.Traits )
    {
      if( blueprint.Traits[ k ] === definition )
      return `trait::${k}`
    }
  }
  else
  {
    for( let k in blueprint._NamedDefinitionsMap )
    {
      if( blueprint._NamedDefinitionsMap[ k ] === definition )
      return `definition::${k}`
    }
    for( let k = 0 ; k < blueprint._UnnamedDefinitionsArray.length ; k++ )
    {
      if( blueprint._UnnamedDefinitionsArray[ k ] === definition )
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
  definitionQualifiedName,

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
