( function _Include_s_( ) {

'use strict';

/**
 * Classes defining tool on steroids. Make possible multiple inheritances, removing fields in descendants, defining the schema of structure, typeless objects, generating optimal code for definition, and many cool things alternatives cant do.
  @module Tools/base/Blueprint
*/

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  require( './l1/Definition.s' );
  require( './l1/Proto.s' );

  require( './l3/Blueprint.s' );
  require( './l3/Construction.s' );
  require( './l3/Trait.s' );

}

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = wTools;

})();
