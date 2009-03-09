package edu.iu.vis.utils {
	
	public class Util {
		
		public static function Construct( type:Class, parameters:Array ):* {
			switch( parameters.length ) {
				case 0:
					return new type();
				case 1:
					return new type( parameters[0] );
				case 2:
					return new type( parameters[0], parameters[1] );
				case 3:
					return new type( parameters[0], parameters[1], parameters[2] );
				case 4:
					return new type( parameters[0], parameters[1], parameters[2], parameters[3] );
				case 5:
					return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4] );
				default:
					return null;
			}
		}
		
		public static function StringOperation( value1:uint, value2:uint, operation:String ):Boolean {
			switch( operation ) {
				case '<':
					return ( value1 < value2 );
				case '<=':
					return ( value1 <= value2 );
				case '>':
					return ( value1 > value2 );
				case '>=':
					return ( value1 >= value2 );
				case '==':
					return ( value1 == value2 );
				case '!=':
					return ( value1 != value2 );
				default:
					return false;
			}
		}

	}
}