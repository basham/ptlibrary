package edu.iu.vis.utils {
	
	/**
	 * The NumberUtil class defines general, static utility functions for Number values.
	 * 
	 * @author Chris Basham
	 * 
	 * */
	public class NumberUtil {
		
		/**
		 * Formats a Number to be constrained within <code>0 ... 1</code>, ideal for percentage values.
		 * 
		 * @param value A Number value to be formatted.
		 * 
		 * @return Returns the formatted Number value.
		 * 
		 * */
		public static function CleanPercentage( value:Number ):Number {
			return ( value > 1 ? 1 : ( value < 0 ? 0 : value ) );
		}

		/**
		 * Finds the relative percentage difference between two values.
		 * 
		 * @param value1 A Number value to compare with value2.
		 * @param value2 A Number value to compare with value1.
		 * @param max A Number value indicating the maximum range the two values are constrained within.
		 * 
		 * @return Returns the relative percentage difference of the two given values.
		 * */
		// 
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
		
	}
}