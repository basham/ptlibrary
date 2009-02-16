package edu.iu.vis.utils {
	
	public class Util {
		
		// Find the relative percentage difference of two values
		public static function PercentDifferenceRange( value1:Number, value2:Number, max:Number ):Number {
			
			var diff:Number = Math.abs( value1 - value2 );
			
			//
			// Loop values backward if the difference exceeds max
			//
			// EXAMPLE: DEGREE ANGLES
			// Value1 100, Value2 300, Max 180
			// diff ( 200 ) > 180
			// 		diff = 180 - ( 200 % 180 ( 20 ) ) = 160
			// perc = 160 / 180 == ( ( 100 + ( 360 - 300 ) ) / 180 )
			//
			if ( diff > max )
				diff = max - ( diff % max );
				
			var diffPerc:Number = diff / max;
			
			return diffPerc;
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