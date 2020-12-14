
let _ = require( 'wblueprint' );

/**/

var Blueprint1 = _.Blueprint
({
  field1 : 1,
  field2 : 2,
});

var Blueprint2 = _.Blueprint
({
  field2 : 22,
  field3 : 33,
  extend : _.define.extension( Blueprint1 ),
});

var instance = Blueprint2.construct();
console.log( instance );

/* log :
{
  field2 : 2,
  field3 : 33,
  field1 : 1,
}
*/
