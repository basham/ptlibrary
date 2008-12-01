package edu.iu.vis.utils {
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class RectangleUtil {

		public static function Centroid( bounds:Rectangle ):Point {
			return new Point( bounds.x + ( bounds.width / 2 ), bounds.y + ( bounds.height / 2 ) );
		}
		
		public static function Boundless( rect:Rectangle, minBounds:Rectangle = null, useMinArea:Boolean = false ):Boolean {
			if ( !minBounds )
				minBounds = new Rectangle();
			if ( !useMinArea )
				return ( rect.width <= minBounds.width && rect.height <= minBounds.height );
			return ( rect.width * rect.height <= minBounds.width * minBounds.height );
		}

		public static function AnyRectangleContainsRectangle( rect:Rectangle, rectangles:Array ):Boolean {
			
			for each( var r:Rectangle in rectangles )
				if ( r.containsRect( rect ) )
					return true;

			return false;
		}
		
		public static function RemoveNestedRectangles( rectangles:Array ):Array {
			var a:Array = rectangles;
			
			for ( var i:uint = 0; i < rectangles.length; i++ ) {
				var r1:Rectangle = rectangles[i];
				for ( var j:uint = 0; j < rectangles.length; j++ ) {
					var r2:Rectangle = rectangles[j];
					if ( r1.containsRect( r2 ) ) {
						rectangles.splice( j, 1 );
					}
				}
			}

			return rectangles;
		}
		
		public static function ApproachingSquare( rect:Rectangle, deviance:Number = 0 ):Boolean {
			var ratio:Number = rect.height / rect.width;
			deviance = ( deviance < 0 ) ? 0 : ( deviance > 1 ? 1 : deviance );
			return ( ratio >= 1 - deviance && ratio <= 1 + deviance );
		}
		
	}
}