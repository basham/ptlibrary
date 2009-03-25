package edu.iu.vis.utils {
	
	/**
	 * The Normalize class defines general, static utility functions to calculate an average value
	 * based on an array of numeric values. Averaging is considered the the mathematical equivalent
	 * of statistical normalizing.
	 * 
	 * @author Chris Basham
	 * 
	 * */
	public class Normalize {
		
		/**
		 * An indicator dictating to use the <code>Mean</code> function when using the <code>Average</code> function.
		 * */
		public static const MEAN:String = "normalizeMean";
		
		/**
		 * An indicator dictating to use the <code>Linear</code> function when using the <code>Average</code> function.
		 * */
		public static const LINEAR:String = "normalizeLinear";
		
		/**
		 * An indicator dictating to use the <code>Quadratic</code> function when using the <code>Average</code> function.
		 * */
		public static const QUADRATIC:String = "normalizeQuadratic";
		
		/**
		 * Calculates the average value of an array of numeric elements.
		 * 
		 * @param values An array of numeric values.
		 * @param averageType An indicator dictating the type of averaging function to utilize
		 * (<code>MEAN</code>, <code>LINEAR</code>, <code>QUADRATIC</code>).
		 * @param truncateExtremes A Boolean flag indicating to automatically remove any extreme data in the values array.
		 * @param truncatePercentage A Number percentage value (<code>0 ... 1</code>) of the number of extreme low and high elements
		 * in the values array to be removed from the array.
		 * 
		 * @return Returns a calculated average value based on the elements in the values array.
		 * 
		 * */
		public static function Average( values:Array, averageType:String = MEAN, truncateExtremes:Boolean = false, truncatePercentage:Number = .25 ):Number {
			// Removes Extremes from array
			if ( truncateExtremes )
				values = ArrayUtil.TruncateExtremes( values, truncatePercentage );
			// Returns Average based on Type
			switch( averageType ) {
				case LINEAR:
					return Linear( values );
				case QUADRATIC:
					return Quadratic( values );
				case MEAN:
				default:
					return Mean( values );
			}
		}
		
		/**
		 * Calculates the average mean value of an array of numeric elements.
		 * All elements are assigned equivalent statistical weight.
		 * 
		 * @param values An array of numeric values.
		 * 
		 * @return Returns a calculated average value based on the elements in the values array.
		 * 
		 * */
		public static function Mean( values:Array ):Number {
			var normal:Number = 0;
			for( var i:uint = 0; i < values.length; i++ )
				normal += values[ i ];
			normal /= values.length;
			return normal;
		}
		
		/**
		 * Calculates the average linear-weighted value of an array of numeric elements.
		 * The larger an element's index, the less its value affects the calculated average.
		 * Each element's weight linearly decreases as index increases.
		 * 
		 * @param values An array of numeric values.
		 * 
		 * @return Returns a calculated average value based on the elements in the values array.
		 * 
		 * */
		public static function Linear( values:Array ):Number {
			var normal:Number = 0, weight:uint = 0;
			for( var i:uint = 0, n:uint = values.length; i < values.length; i++, n-- ) {
				normal += values[ i ] * n;
				weight += n;
			}
			normal /= weight;
			return normal;
		}

		/**
		 * Calculates the average quadratic-weighted value of an array of numeric elements.
		 * The larger an element's index, the less its value affects the calculated average.
		 * Each element's weight quadratically decreases as index increases.
		 * 
		 * @param values An array of numeric values.
		 * 
		 * @return Returns a calculated average value based on the elements in the values array.
		 * 
		 * */
		public static function Quadratic( values:Array ):Number {
			var normal:Number = 0, weight:uint = 0;
			for( var i:uint = 0, n:uint = values.length, q:uint = 0; i < values.length; i++, n-- ) {
				q = n * n;
				normal += values[ i ] * q;
				weight += q;
			}
			normal /= weight;
			return normal;
		}
		
	}
}