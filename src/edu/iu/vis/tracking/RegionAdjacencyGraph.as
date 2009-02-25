package edu.iu.vis.tracking {
	
	import edu.iu.vis.utils.BitmapDataUtil;
	import edu.iu.vis.utils.RectangleUtil;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class RegionAdjacencyGraph {
		
		public var source:BitmapData;
		public var bitmapData:BitmapData;
		
		public var root:Region;
		public var regions:Array;
		
		static public var UniqueColor:uint = 0xFF0000;
		static public var Colors:Array = new Array( 0xFF00FF00, 0xFF0000FF );
		
		public function RegionAdjacencyGraph( source:BitmapData, copySource:Boolean = false ):void {
			this.source = source;
			this.bitmapData = copySource ? source.clone() : source;
			this.regions = new Array();
		}
		
		public function graph():void {
			BitmapDataUtil.TwoBitBitmap( bitmapData );
			root = new Region( 0, bitmapData.rect, new Point(), this );
			graphRegion( root );
		}
		
		private function graphRegion( region:Region ):void {
			
			var bitColor:uint = region.bitColor;
			
			// Find all child-regions of the given region
			while(true) {
				
				// In rare cases, the region does not have a bound
				if ( RectangleUtil.Boundless( region.bounds ) )
					break;
					
				// Find bound containing all the regions of a certain depth in the parent region
				var candidateBound:Rectangle = BitmapDataUtil.GetSmartColorBoundsRect( bitmapData, region.bounds, 0xFFFFFFFF, bitColor );
				
				// No more child-regions found; end search
				if ( RectangleUtil.Boundless( candidateBound ) )
					break;
				
				// Find the first pixel point in a candidate child region 
				var point:Point = BitmapDataUtil.SelectClosestColor( bitColor, bitmapData, candidateBound, '==' );
				
				// No point found; end search
				if ( !point )
					break;

				// Find bounds of the candidate child region
				var childBound:Rectangle = BitmapDataUtil.GetBoundingRectFromPointRegion( bitmapData, point, depthToColor( region.depth ), UniqueColor );
				
				// If the candidate child region is not bounded within the parent region, it belongs to another parent region;
				// or if the regions' sides intersect then it is an "edging" region to be ignored; skip them.
				// Since all regions will edge the root region, only use this conditional if this is a sub-region.
				if ( region.depth > 0 )
					if ( !region.bounds.containsRect( childBound ) || RectangleUtil.AnySidesIntersect( childBound, region.bounds ) )
						continue;
				
				// Instantiate and register the child region
				var child:Region = new Region( region.depth + 1, childBound, point, this );
				region.registerChild( child );
				
				// Recursively search to find child regions of the child region
				graphRegion( child );
			}

			// Left-Heavy Sort children
			region.leftHeavySortChildren();
		}
		
		/*
		compareBit
			0: Matches regions with any bit value
			1: Matches regions with TRUE/even bit values
			-1: Matches regions with FALSE/odd bit values
		*/
		
		//public function getRegionsMatchingDepthSequence( pattern:*, compareBit:Number = 0, matchAbsoluteDepthSequence:Boolean = false ):Array {
		//	return root.getRegionsMatchingDepthSequence( pattern, compareBit, matchAbsoluteDepthSequence );
		//}
		
		
		public function getRegionsMatchingDepthSequence( pattern:*, compareBit:Number = 0, matchAbsoluteDepthSequence:Boolean = false ):Array {
			
			var matches:Array = new Array();
			
			for each( var r:Region in regions ) {
				var sequence:String = matchAbsoluteDepthSequence ? r.absoluteDepthSequence : r.relativeDepthSequence;
				var match:Boolean = false;
				if ( sequence.search( pattern ) != -1 ) {
					switch( compareBit ) {
						case 0:
							match = true;
							break;
						case 1:
							if ( r.bit )
								match = true;
							break;
						case -1:
							if ( !r.bit )
								match = true;
							break;
					}
				}
				
				if ( match )
					matches.push( r );
			}
			
			return matches;
		}
		
		public function printRegion( region:Region, copySource:Boolean = true ):BitmapData {
			var bitmap:BitmapData = copySource ? bitmapData.clone() : bitmapData;
			region.print( bitmap );
			return bitmap;
		}
		
		public function registerRegion( region:Region ):void {
			regions.push( region );
		}
		
		public function toString():String {
			var s:String = 'RAG: ' + this.regions.length + ' regions\n';
			s += root.toString( true );
			return s;
		}
		
		public function printBounds():void {
			for each( var r:Region in regions )
				BitmapDataUtil.StrokeRect( ( r as Region ).bounds, bitmapData, ( r as Region ).bit ? 0xFF0000 : 0xFFFF00 );
		}
		
		public function depthToColor( depth:uint ):uint {
			return Colors[ depth % Colors.length ];
		}
		
	}
}