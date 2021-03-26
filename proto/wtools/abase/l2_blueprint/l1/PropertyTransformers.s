( function _PropertyTransformer_s_()
{

'use strict';

const Self = _global_.wTools.property = _global_.wTools.property || Object.create( null );
const _global = _global_;
const _ = _global_.wTools;

// --
//
// --

function dstNotOwnFromDefinition()
{
  let routine = dstNotOwnFromDefinition;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function dstNotOwnFromDefinition( dstContainer, srcContainer, key )
  {

    if( Object.hasOwnProperty.call( dstContainer, key ) )
    return;

    if( Object.hasOwnProperty.call( dstContainer, Symbol.for( key ) ) )
    return;

    let srcElement = srcContainer[ key ];
    if( _.definitionIs( srcElement ) )
    dstContainer[ key ] = srcElement.toVal( srcElement.val );
    else
    dstContainer[ key ] = srcElement;

  }

}

dstNotOwnFromDefinition.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function dstNotOwnFromDefinitionStrictlyPrimitive()
{
  let routine = dstNotOwnFromDefinitionStrictlyPrimitive;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function dstNotOwnFromDefinitionStrictlyPrimitive( dstContainer, srcContainer, key )
  {

    if( Object.hasOwnProperty.call( dstContainer, key ) )
    return;

    if( Object.hasOwnProperty.call( dstContainer, Symbol.for( key ) ) )
    return;

    let srcElement = srcContainer[ key ];
    if( _.definitionIs( srcElement ) )
    {
      dstContainer[ key ] = srcElement.toVal( srcElement.val );
    }
    else
    {
      _.assert
      (
        !_.consequenceIs( srcElement ) && ( _.primitiveIs( srcElement ) || _.routineIs( srcElement ) ),
        () => `${ _.entity.exportStringShallow( dstContainer ) } has non-primitive element "${ key }" use _.define.own instead`
      );
      dstContainer[ key ] = srcElement;
    }

  }

}

dstNotOwnFromDefinitionStrictlyPrimitive.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

// --
// tools
// --

function mapSupplementOwnFromDefinition( dstMap, srcMap )
{
  return _.mapExtendConditional( _.property.mapper.dstNotOwnFromDefinition(), ... arguments );
}

//

function mapSupplementOwnFromDefinitionStrictlyPrimitives( dstMap, srcMap )
{
  return _.mapExtendConditional( _.property.mapper.dstNotOwnFromDefinitionStrictlyPrimitive(), ... arguments );
}

// --
// extension
// --

let Transformers =
{

  dstNotOwnFromDefinition,
  dstNotOwnFromDefinitionStrictlyPrimitive,

}

_.property.transformersRegister( Transformers );

let Extension =
{

  mapSupplementOwnFromDefinition,
  mapSupplementOwnFromDefinitionStrictlyPrimitives,

}

_.mapExtend( _, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
