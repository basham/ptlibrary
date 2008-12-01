package edu.iu.vis.utils {
	
	public class Util {
		
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