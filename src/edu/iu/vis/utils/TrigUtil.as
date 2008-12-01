package edu.iu.vis.utils {
	
	import flash.geom.Point;
	
	public class TrigUtil {
		
		public static function Degrees( radians:Number ):Number {
			return ( 180 / Math.PI * radians );
		}
		
		public static function Radians( degrees:Number ):Number {
			return ( Math.PI / 180 * degrees );
		}
		
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
		
		public static function RadiansFromOrigin( origin:Point, point:Point ):Number {
			return Radians( DegreesFromOrigin( origin, point ) );
		}
		
		public static function DistanceBetweenPoints( p1:Point, p2:Point ):Number {
			return Math.sqrt( Math.pow( p2.x - p1.x, 2 ) + Math.pow( p2.y - p1.y, 2 ) );
		}
		public static function RadiansBetweenPoints( p1:Point, p2:Point ):Number {
			return Math.atan2( p2.y - p1.y, p2.x - p1.x );
		}
		
		public static function PointFromArc( point:Point, radians:Number, arc:Number ):Point {
			return new Point( arc * Math.cos( radians ) + point.x, arc * Math.sin( radians ) + point.y );
		}

	}
}