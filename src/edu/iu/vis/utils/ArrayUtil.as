package edu.iu.vis.utils {
	
	/**
	 * The ArrayUtil class defines general, static utility functions for Arrays.
	 * 
	 * @author Chris Basham
	 * 
	 * */
	public class ArrayUtil {
		
		/**
		 * Compares the content of Arrays containing simple, standard objects,
		 * e.g. uint, Number, Boolean, String.
		 * 
		 * @param array1 The first array to compare.
		 * @param array2 The second array to compare.
		 * 
		 * @return Returns true if the arrays' content are identical.
		 * 
		 * */
		public static function CompareSimpleArrays( array1:Array, array2:Array ):Boolean {
			return ( array1.toString() == array2.toString() );
		}
		
		/**
		 * Truncates or pads an array to a specified length.
		 * 
		 * @param array The referenced array.
		 * @param length The length the array should be.
		 * @param buffer A default object to add to the array if padding is required.
		 * 
		 * @return Returns the referenced, modified array.
		 * 
		 * */
		public static function FitToLength( array:Array, length:uint, buffer:* = null ):Array {
			if (!array)
				array = new Array();
			while( array.length < length )
				array.push( buffer );
			while( array.length > length )
				array.pop();
			return array;
		}

		/**
		 * Converts an array of strings to a single, concatenated string.
		 * 
		 * @param array The referenced array.
		 * 
		 * @return Returns the concatenated string.
		 * 
		 * @internal TODO: Allow optional character delimators.
		 * 
		 * */
		public static function ToSimpleString( array:Array ):String {
			var s:String = '';
			for each( var a:String in array )
				s += a;
			return s;
		}
		
		/**
		 * Finds the Index of the smallest value in an array.
		 * 
		 * @param values An array containing a list of comparable, numeric values.
		 * 
		 * @return Returns a numeric index in the array.
		 * 
		 * */
		public static function MinIndex( values:Array ):uint {
			var minIndex:uint = 0;
			for( var i:uint = 0; i < values.length; i++ )
				if ( values[ i ] < values[ minIndex ] )
					minIndex = i;
			return minIndex;
		}
		
		/**
		 * Finds the Index of the largest value in an array
		 * 
		 * @param values An array containing a list of comparable, numeric values.
		 * 
		 * @return Returns a numeric index in the array.
		 * 
		 * */
		public static function MaxIndex( values:Array ):uint {
			var maxIndex:uint = 0;
			for( var i:uint = 0; i < values.length; i++ )
				if ( values[ i ] > values[ maxIndex ] )
					maxIndex = i;
			return maxIndex;
		}

		/**
		 * Removes High and Lows from an array of comparable, numeric values without modifying the order of the array
		 * 
		 * @param values An array containing a list of comparable, numeric values.
		 * @param percentage A percentage (<code>0 ... 1</code>) of the number of extreme low and high elements
		 * in the values array to be removed from the array.
		 * 
		 * @return Returns the original values array excluding a derrived number of extreme values.
		 * 
		 * */
		public static function TruncateExtremes( values:Array, percentage:Number = .25 ):Array {
			// Only Truncate larger arrays
			if ( values.length < 3 )
				return values;
			
			percentage = ( percentage < 0 ) ? 0 : ( ( percentage > 1 ) ? 1 : percentage );
			
			// Number of Highs and Lows to remove
			// E.g. 2 means remove 2 Maxs, 2 Mins
			var extremes:uint = Math.floor( values.length * percentage / 2 );
			
			while( extremes > 0 ) {
				values.splice( MinIndex( values ), 1 );
				values.splice( MaxIndex( values ), 1 );
				extremes--;
			}
			
			return values;
		}

	}
}