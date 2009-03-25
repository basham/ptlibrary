package edu.iu.vis.utils {
	
	import flash.geom.Point;
	
	/**
	 * The TrigUtil class defines general, static utility functions for Trigonometry calculations.
	 * 
	 * @author Chris Basham
	 * 
	 * */
	public class TrigUtil {
		
		/**
		 * Calculates angle degrees from a radian value.
		 * 
		 * @param radians An angle value in radians.
		 * 
		 * @return Returns the equivalent degree value based on the radian value.
		 * 
		 * */
		public static function Degrees( radians:Number ):Number {
			return ( 180 / Math.PI * radians );
		}
		
		/**
		 * Calculates angle radians from a degree value.
		 * 
		 * @param degrees An angle value in degrees.
		 * 
		 * @return Returns the equivalent radian value based on the degree value.
		 * 
		 * */
		public static function Radians( degrees:Number ):Number {
			return ( Math.PI / 180 * degrees );
		}
		
		/**
		 * Calculates angle degrees from an origin to another point.
		 * 
		 * @param origin The starting Point.
		 * @param point The ending Point.
		 * 
		 * @return Returns a Number of degrees.
		 * 
		 * */
		public static function DegreesFromOrigin( origin:Point, point:Point ):Number {
			var rise:Number = origin.y - point.y;
			var run:Number = origin.x - point.x;
			var riseSign:Boolean = rise >= 0;
			var runSign:Boolean = run >= 0;
			var theta:Number = Degrees( Math.atan( run / rise ) );
			
			// QUADRENTS
			//    -----------
			//   |  IV | I  |
			//   -----------
			//  | III | II |
			//  -----------
			if ( riseSign && !runSign ) // Quadrent I
				theta = Math.abs( theta );
			if ( !riseSign && !runSign ) // Quadrent II
				theta = 180 - theta;
			if ( !riseSign && runSign ) // Quadrent III
				theta = Math.abs( theta ) + 180;
			if ( riseSign && runSign ) // Quadrent IV
				theta = 360 - theta;

			return theta % 360;
		}
		
		/**
		 * Calculates angle radians from an origin to another point.
		 * 
		 * @param origin The starting Point.
		 * @param point The ending Point.
		 * 
		 * @return Returns a Number of radians.
		 * 
		 * */
		public static function RadiansFromOrigin( origin:Point, point:Point ):Number {
			return Radians( DegreesFromOrigin( origin, point ) );
		}
		
		/**
		 * Calculates the numeric distance between any two sets of coordinates.
		 * 
		 * @param x1 The "x" coordinate of the first point.
		 * @param y1 The "y" coordinate of the first point.
		 * @param x2 The "x" coordinate of the second point.
		 * @param y2 The "y" coordinate of the second point.
		 * 
		 * @return Returns the numeric distance between the two sets of coordinates.
		 * 
		 * */
		public static function DistanceBetweenCoordinates( x1:Number, y1:Number, x2:Number, y2:Number ):Number {
			return Math.sqrt( Math.pow( x2 - x1, 2 ) + Math.pow( y2 - y1, 2 ) );
		}
		
		/**
		 * Calculates the numeric distance between any two points.
		 * 
		 * @param p1 The first Point distanced against the second Point.
		 * @param p2 The second Point distanced against the first Point.
		 * 
		 * @return Returns the numeric distance between the two Points.
		 * 
		 * */
		public static function DistanceBetweenPoints( p1:Point, p2:Point ):Number {
			return DistanceBetweenCoordinates( p1.x, p1.y, p2.x, p2.y );
		}
		
		/**
		 * Calculates the radian angle between two Points.
		 * 
		 * @param p1 A first Point.
		 * @param p2 A second Point.
		 * 
		 * @return Returns the angle in radians.
		 *  
		 * */
		public static function RadiansBetweenPoints( p1:Point, p2:Point ):Number {
			return Math.atan2( p2.y - p1.y, p2.x - p1.x );
		}
		
		/**
		 * Calculates a Point separated from an origin point by an arc distance at a given angle.
		 * 
		 * @param point An origin point.
		 * @param radians A radian angle directing the rotation of the arc.
		 * @param arc The distance the calculated Point must be from the origin Point.
		 * 
		 * @return Returns the calculated Point.
		 * 
		 * */
		public static function PointFromArc( point:Point, radians:Number, arc:Number ):Point {
			return new Point( arc * Math.cos( radians ) + point.x, arc * Math.sin( radians ) + point.y );
		}
		
		/**
		 * Calculates the average, mean coordinates of a Point from an array of Points.
		 * 
		 * @param points An array of Point objects.
		 * 
		 * @return Returns the average, mean Point from the points array.
		 * 
		 * */
		public static function AvgPoint( points:Array ):Point {
			var x:Number = 0;
			var y:Number = 0;
			for each( var p:Point in points ) {
				x += p.x;
				y += p.y;
			}
			return new Point( Math.round( x / points.length ), Math.round( y / points.length ) );
		}

	}
}