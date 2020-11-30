( function _Proto_s_() {

'use strict';

let Self = _global_.wTools;
let _global = _global_;
let _ = _global_.wTools;

// --
// implementation
// --

/**
 * @namespace Tools.prototype
 * @module Tools/base/Proto
 */

/**
 * Iterate through prototypes.
 * @param {object} proto - prototype
 * @function each
 * @namespace Tools.prototype
 */

function each( proto, onEach )
{
  let result = [];

  _.assert( _.routineIs( onEach ) || !onEach );
  _.assert( !_.primitiveIs( proto ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  do
  {
    if( onEach )
    onEach.call( this, proto );
    result.push( proto );
    proto = Object.getPrototypeOf( proto );
  }
  while( proto );

  return result;
}

//

/**
 * Does srcProto has insProto as prototype.
 * @param {object} srcProto - proto stack to investigate.
 * @param {object} insProto - proto to look for.
 * @function hasPrototype
 * @namespace Tools.prototype
 */

function hasPrototype( srcProto, insProto )
{

  while( srcProto !== null )
  {
    if( srcProto === insProto )
    return true;
    srcProto = Object.getPrototypeOf( srcProto );
  }

  return false;
}

//

/**
 * Return proto owning names.
 * @param {object} srcPrototype - src object to investigate proto stack.
 * @function hasProperty
 * @namespace Tools.prototype
 */

function hasProperty( srcPrototype, names ) /* xxx qqq : names could be only string */
{
  names = _nameFielded( names );
  _.assert( _.objectIs( srcPrototype ) );

  do
  {
    let has = true;
    for( let n in names )
    if( !_ObjectHasOwnProperty.call( srcPrototype, n ) )
    {
      has = false;
      break;
    }
    if( has )
    return srcPrototype;

    srcPrototype = Object.getPrototypeOf( srcPrototype );
  }
  while( srcPrototype !== Object.prototype && srcPrototype );

  return null;
}

// --
// define
// --

let PrototypeExtension =
{

  each,

  hasProperty,
  hasPrototype,

}

_.prototype = _.prototype || Object.create( null );
_.mapExtend( _.prototype, PrototypeExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
