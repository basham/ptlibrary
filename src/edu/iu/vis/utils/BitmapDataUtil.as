package edu.iu.vis.utils {
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class BitmapDataUtil {

		public static function StrokeRect( rect:Rectangle, data:BitmapData, strokeColor:uint = 0xFF0000 ):void {
			var s:Shape = new Shape();
			s.graphics.lineStyle(2, strokeColor);
			s.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			data.draw( s );
		}
		
		public static function StrokePoint( point:Point, data:BitmapData, strokeColor:uint = 0xFF0000 ):void {
			var s:Shape = new Shape();
			s.graphics.lineStyle(2, strokeColor);
			s.graphics.drawRect(point.x - 1, point.y - 1, 2, 2);
			data.draw( s );
		}
		
		// TODO: Retain all transparency?
		public static function TwoBitBitmap( bitmap:BitmapData, ratio:Number = .5 ):void {
			var p:Point = new Point();
			var mask:uint = 0xFFFFFFFF;
			var colorHigh:uint = 0xFFFFFFFF;
			var colorLow:uint = 0xFF000000;
			var thresh:uint = ( ( colorHigh - colorLow ) * NumberUtil.CleanPercentage(ratio) ) + colorLow;
			
			bitmap.threshold( bitmap, bitmap.rect, p, ">", thresh, colorHigh, mask, false );
			bitmap.threshold( bitmap, bitmap.rect, p, "<=", thresh, colorLow, mask, false );
		}
		
		// Find the bounding rectangular region of a blob containing the given point
		// The unique color must not be present in the sourceBitmapData, otherwise, you get false results
		// TODO: automatically find a unique color
		public static function GetPointRegionBoundingRect( sourceBitmapData:BitmapData, point:Point, fillColor:uint = 0xFFFFF000,
			uniqueColor:uint = 0xFFFFFF00, copySource:Boolean = false ):Rectangle {
			
			var bitmap:BitmapData = copySource ? sourceBitmapData.clone() : sourceBitmapData;
			
			// Fill the bitmap with a unique color to separate the blob from the rest of the search area
			bitmap.floodFill( point.x, point.y, uniqueColor );

			// Find the bounds of the unique color, which is the bounds of the blob
			var bound:Rectangle = bitmap.getColorBoundsRect( 0xFFFFFFFF, uniqueColor, true );
			
			if ( copySource )
				bitmap.dispose();
			else 
				bitmap.floodFill( point.x, point.y, fillColor ); // Refill the bitmap, replacing the unique color
			
			return bound;
		}
		
		public static function SelectClosestColor( color:uint, data:BitmapData, clip:Rectangle, operation:String = "<=" ):Point {

			// Since the bound is known, there must be at least one point in the first row
			// of the bound that matches the parameterized color value. Therefore, it is
			// unnecessary to do a nested loop to look beyond the first row of data.
			
			// Search the shortest side of the bounds, either the first row or first column, to minimize enumeration
			if ( clip.width <= clip.height ) {
				for ( var x:uint = clip.x; x < clip.x + clip.width; x++ ) {
					// If the color at least exceeds the found color, it returns the coordinates of the pixel
					if ( Util.StringOperation( data.getPixel32( x, clip.y ), color, operation ) )
						return new Point( x, clip.y );
				}
			}
			else {
				for ( var y:uint = clip.y; y < clip.y + clip.height; y++ ) {
					// If the color at least exceeds the found color, it returns the coordinates of the pixel
					if ( Util.StringOperation( data.getPixel32( clip.x, y ), color, operation ) )
						return new Point( clip.x, y );
				}
			}

			// No pixel color found
			return null;
		}
		
		// Finds the color region within a rectangular bound in the source bitmap
		public static function GetSmartColorBoundsRect( sourceBitmapData:BitmapData, rect:Rectangle, mask:uint, color:uint, relativeBounds:Boolean = false, findColor:Boolean = true ):Rectangle {
			var bmp:BitmapData = new BitmapData( rect.width, rect.height );
			bmp.copyPixels( sourceBitmapData, rect, new Point() );
			var bounds:Rectangle = bmp.getColorBoundsRect( mask, color, findColor );
			bmp.dispose();
			
			if ( !relativeBounds ) {
				bounds.x += rect.x;
				bounds.y += rect.y;
			}
			
			return bounds;
		}
		
	}
}