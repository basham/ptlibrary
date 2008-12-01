package edu.iu.vis.tracking.symbols.dss {
	
	import edu.iu.vis.tracking.Region;
	import edu.iu.vis.utils.BitmapDataUtil;
	import edu.iu.vis.utils.RectangleUtil;
	import edu.iu.vis.utils.TrigUtil;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class DSSDecoder {
		
		public static const CODE_REGION:uint = 0;
		public static const CENTROID_REGION:uint = 0;
		public static const ORIENTATION_MARK_REGION:uint = 1;
		
		public static function Decode( bitmap:BitmapData, region:Region ):DSSymbol {
			
			// ONLY DECODES Region with '0121'
			if ( region.relativeDepthSequence != '0121' )
				return null;
				
			var dsColor:uint = 0xFFFFFFFF;
			var p:Point = new Point();
			
			var dcx:Number = region.bounds.x;
			var dcy:Number = region.bounds.y;
			
			var codeRegion:Region = region.children[CODE_REGION];
			var centroidRegion:Region = codeRegion.children[CENTROID_REGION];
			var omRegion:Region = region.children[ORIENTATION_MARK_REGION];
			
			var centroid:Point = RectangleUtil.Centroid( centroidRegion.bounds );
			var omPoint:Point = RectangleUtil.Centroid( omRegion.bounds );
			var rotation:Number = TrigUtil.DegreesFromOrigin( centroid, omPoint );
			
			var radius:Number = Math.max( region.bounds.width, region.bounds.height ) / 2;
			
			
			var code:Array = new Array();
			var ds:DSSymbol = new DSSymbol( null, rotation, radius );
			
			for ( var s:Number = 0; s < DSSConfig.Slice; s++ ) {
				
				var angle:Number = s * DSSConfig.SingleSliceDegrees + rotation;
				
				for ( var d:uint = 0; d <= DSSConfig.Depth; d++ ) {
					var depth:uint = DSSConfig.Depth - d;
					var point:Point = ds.getSlicePoint( angle, depth, true );
					point.x -= dcx;
					point.y -= dcy;
					var pixel:uint = bitmap.getPixel32( point.x, point.y );
					var match:Boolean = pixel == dsColor;

					trace( s, d, pixel.toString(16), match );
					BitmapDataUtil.StrokePoint( point, bitmap );
					
					if ( match ) {
						code.push( depth );
						break;
					}
				}
			}
			
			trace( '//', code, rotation );
			ds.code = code;
			
			return ds;
		}
		/*
		public static function LocateBlobs( bitmap:BitmapData ):BitmapData {
			
			BitmapDataUtil.TwoBitBitmap( bitmap, true );
			
			var unfoundBound:Rectangle = new Rectangle();
			var foundBound:Rectangle = new Rectangle();
			var bounds:Array = new Array();
			var colors:Array = new Array( 0xFF000077, 0xFF0000CC, 0xFF000099, 0xFF000066, 0xFF000033 );
			var i:uint = 0;
			
			// Finds all possible points
			while( true ) {
				
				if ( i++ == 10 )
					break;
				
				// Find region bounded by transparent areas
				unfoundBound = bitmap.getColorBoundsRect(0xFFFFFFFF, 0xFF000000, true);
				
				// No dimensions to the bound means, there are no pixels to find; kill loop
				if ( RectangleUtil.Boundless( unfoundBound ) )
					break;
					
				// Gets a transparent point
				var point:Point = BitmapDataUtil.SelectClosestColor( 0xFF000000, bitmap, unfoundBound, '==' );
				//var p:Point = DSSUtil.SelectClosestColor( 0xFFFF00FF, bitmap, unfoundBound, '==' );
				//var bgPoint:Point = DSSUtil.SelectClosestColor( 0xFFFFFFFF, bitmap, unfoundBound );
				//trace(unfoundBound, point, p, bgPoint);
				// No point found, kill loop
				if (point == null)
					break;
					
				//DSSUtil.StrokePoint( point, bitmap );
				//if (bgPoint != null)
				//	bitmap.floodFill( bgPoint.x, bgPoint.y, 0xFFFF00FF );
				// Fills the point with a generic yellow
				
				
				//bitmap.floodFill( point.x, point.y, 0xFFFFFF00 );

				
				// Find the yellow bounds
				//foundBound = bitmap.getColorBoundsRect(0xFFFFFFFF, 0xFFFFFF00, true);
				
				foundBound = BitmapDataUtil.GetPointRegionBoundingRect( bitmap, point );
				trace( point, foundBound );
				// Draw the bounds (the individual shape)
				if ( !RectangleUtil.AnyRectangleContainsRectangle( foundBound, bounds ) )
					bounds.push( foundBound );
				
				// Refill the same shape with a generic blue color, so its excluded in the next yellow bounds search
				//bitmap.floodFill( point.x, point.y, colors[ bounds.length % colors.length ] );
				
				// Draw the location of the point in question
				//DSSUtil.StrokePoint( point, bitmap );

				//pointsFound++;
				//i++;
			}
			var j:uint = 0;
			for each( var r:Rectangle in bounds ) {
				var b:BitmapData = new BitmapData( r.width, r.height );
				b.copyPixels( bitmap, r, new Point() );
				b.floodFill( 0, 0, 0xFFFFFF00 );
				//Decode( b );
				//trace( '**', r, b.width );
				//i++;
				if (j++ == 0)
				break;
			}
				return b;
			//for each( var re:Rectangle in bounds )
			//	DSSUtil.StrokeRect( re, bitmap, 0x00FF00 );
		}
		
		public static function _Decode( bitmap:BitmapData, cen:Point = null, rot:Number = 0 ):DSSymbol {
			
			var dsColor:uint = 0xFF00FF00;
			var p:Point = new Point();
			
			var centroid:Point = RectangleUtil.Centroid( bitmap.rect );
			
			var dcx:Number = 0, dcy:Number = 0;
			
			if (cen) {
				dcx = centroid.x - cen.x;
				dcy = centroid.y - cen.y;
				centroid = cen;
			}
			
			//trace( centroid, cen );
			//DSSUtil.StrokePoint( centroid, bitmap, 0xFFFF00 );
			
			var radius:Number = Math.max( bitmap.width, bitmap.height ) / 2;
			
			// Reduces bitmap to two bits: black, white
			//DSSUtil.TwoBitBitmap( bitmap );
			
			// Fill DS Combination with a generic green to isolate it from the white Orientation Mark
			bitmap.floodFill( centroid.x, centroid.y + ( radius * DSSConfig.CentroidMarkRadius ) - 0, dsColor );
			
			// Get white bounds to hopefull find the Orientation Mark
			var omBound:Rectangle = bitmap.getColorBoundsRect( 0xFFFFFFFF, 0xFFFFFFFF, true );

			// No dimensions to the bound means an Orientation Mark cannot be found; kill the script.
			if ( RectangleUtil.Boundless( omBound ) )
				return null;
			
			//DSSUtil.StrokeRect( omBound, bitmap, 0x0000FF );
			
			var omPoint:Point = RectangleUtil.Centroid( omBound );
			var rotation:Number = TrigUtil.DegreesFromOrigin( centroid, omPoint );
			
			if (rot != 0) rotation = rot;
			
			var code:Array = new Array();
			var ds:DSSymbol = new DSSymbol( null, rotation, radius );
			
			for ( var s:Number = 0; s < DSSConfig.Slice; s++ ) {
				
				var angle:Number = s * DSSConfig.SingleSliceDegrees + rotation;
				
				for ( var d:uint = 0; d <= DSSConfig.Depth; d++ ) {
					var depth:uint = DSSConfig.Depth - d;
					var point:Point = ds.getSlicePoint( angle, depth, true );
					point.x -= dcx;
					point.y -= dcy;
					var pixel:uint = bitmap.getPixel32( point.x, point.y );
					var match:Boolean = pixel == dsColor;

					//trace( s, d, pixel.toString(16), match );
					//DSSUtil.StrokePoint( point, bitmap );
					
					if ( match ) {
						code.push( depth );
						break;
					}
				}
			}
			
			trace( '//', code, rotation );
			ds.code = code;
			
			return ds;
		}
*/
	}
}