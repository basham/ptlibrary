package edu.iu.vis.tracking.tuio.profiles {
	
	import edu.iu.vis.tracking.Region;
	import edu.iu.vis.tracking.RegionAdjacencyGraph;
	import edu.iu.vis.tracking.symbols.dss.DSSConfig;
	import edu.iu.vis.tracking.symbols.dss.DSSymbol;
	import edu.iu.vis.utils.RectangleUtil;
	import edu.iu.vis.utils.TrigUtil;
	
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class TuioDSSProfile extends AbstractTuioInterpreterProfile {
		
		public static const CODE_REGION:uint = 0;
		public static const CENTROID_REGION:uint = 0;
		public static const ORIENTATION_MARK_REGION:uint = 1;
		
		public function TuioDSSProfile() {
		}

		override public function interpretGraph( rag:RegionAdjacencyGraph ):void {
			
			var dssRegions:Array = rag.getRegionsMatchingDepthSequence('0121$', 0);
			
			for each( var region:Region in dssRegions ) {
				
				if ( !RectangleUtil.ApproachingSquare( region.bounds, .2 ) ) // Ignore if not close to a square
					continue;
					
				//if ( RectangleUtil.Radius( region.bounds ) < 100 )
				//	continue;
				
				var bd:BitmapData = rag.printRegion( region );
				var sym:DSSymbol = decode( bd, region );
				var centroid:Point = RectangleUtil.Centroid( region.bounds );
				
				if ( !sym )
					continue;
				
				this.sendObj( sym.codeInt, centroid.x, centroid.y, sym.rotation ); // Send Tuio obj data back to Interpreter
			}
		}
		
		private function decode( bitmap:BitmapData, region:Region ):DSSymbol {
			
			// ONLY DECODES Region with '0121'
			if ( region.relativeDepthSequence != '0121' )
				return null;
			
			// Identify child regions in symbol region
			var codeRegion:Region = region.children[CODE_REGION]; // First child of symbol region
			var centroidRegion:Region = codeRegion.children[CENTROID_REGION]; // First child of code region
			var omRegion:Region = region.children[ORIENTATION_MARK_REGION]; // Second child of symbol region
			
			// Rotation is calculated by the angle between the Centroid, Orientation Mark points
			var centroid:Point = RectangleUtil.Centroid( centroidRegion.bounds );
			var omPoint:Point = RectangleUtil.Centroid( omRegion.bounds );
			var rotation:Number = TrigUtil.DegreesFromOrigin( centroid, omPoint );
			
			// Radius is roughly calculated by looking at the bounds of the symbol region
			var radius:Number = RectangleUtil.Radius( region.bounds );
			
			// Prepare variables for decoding
			var dsColor:uint = codeRegion.bitColor;
			var dcx:Number = region.bounds.x; // Point x offset
			var dcy:Number = region.bounds.y; // Point y offset
			var code:Array = new Array();
			var ds:DSSymbol = new DSSymbol( null, rotation, radius );
			
			// Decode the code region
			for ( var s:Number = 0; s < DSSConfig.Slice; s++ ) {
				
				// Calculates the relative angles to look for coded depth values
				var angle:Number = s * DSSConfig.SingleSliceDegrees + rotation;
				
				// Search outside-in
				//for ( var d:uint = DSSConfig.Depth; d >= 0; d-- ) {
				for ( var dd:uint = 0; dd < DSSConfig.Depth; dd++ ) {
					
					var d:uint = DSSConfig.Depth - dd;
					
					// Find point to look for a coded value
					var point:Point = ds.getSlicePoint( angle, d, true );
					point.x += dcx;
					point.y += dcy;
					
					// Check match
					var pixel:uint = bitmap.getPixel32( point.x, point.y );
					var match:Boolean = pixel == dsColor;

					//trace( s, d, point, pixel.toString(16), match );
					//BitmapDataUtil.StrokePoint( point, bitmap );
					
					if ( match ) {
						code.push( d );
						break;
					}
				}
			}

			// Apply code to symbol
			ds.code = code;
			
			return ds;
		}
		
	}
}