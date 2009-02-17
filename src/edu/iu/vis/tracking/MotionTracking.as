package edu.iu.vis.tracking {
	
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	
	import edu.iu.vis.utils.BitmapDataUtil;
	
	public class MotionTracking {
		
		private var prevTrackingData:BitmapData;
		private var currTrackingData:BitmapData;
		private var diffTrackingData:BitmapData;
		
		private var grey:Array = [
			.3, .3, .3, 0, 0,
			.3, .3, .3, 0, 0,
			.3, .3, .3, 0, 0,
			0,  0,  0, 1, 0 ];
			
		private var greyContrast:Array = [
			1, 1, 1, 0, -64,
			1, 1, 1, 0, -64,
			1, 1, 1, 0, -64,
			0, 0, 0, 1, 0 ];
			
		public function MotionTracking( w:uint, h:uint ) {
			prevTrackingData = new BitmapData(w, h);
			currTrackingData = new BitmapData(w, h);
			diffTrackingData = new BitmapData(w, h);
		}
		
		public function get filteredBitmapData():BitmapData {
			return diffTrackingData;
		}
		
		public function track( source:BitmapData ):void {
			// Redraw video stream
			//camData.draw(video);
			
			var p:Point = new Point();
			
			// Make the current frame the new frame
			prevTrackingData.copyPixels(currTrackingData, currTrackingData.rect, p);
			
			// Redraw the current frame from the video source
			//currTrackingData.draw(video);
			currTrackingData.copyPixels(source, source.rect, p);
			
			// Copy previous frame into Difference bitmap
			diffTrackingData.copyPixels(prevTrackingData, prevTrackingData.rect, p);
			// Difference the current frame with the previous frame
			diffTrackingData.draw( currTrackingData, null, null, "difference");

			// Greyscales and contrasts Difference
			var cmf:ColorMatrixFilter = new ColorMatrixFilter( greyContrast );
			// Blurs Difference to make blobby shapes
			var blur:BlurFilter = new BlurFilter(32, 32, 2);
			
			diffTrackingData.applyFilter( diffTrackingData, diffTrackingData.rect, p, cmf );	
			diffTrackingData.applyFilter( diffTrackingData, diffTrackingData.rect, p, blur );
			
			// Removes grey from blobs, making them more solid shapes
			BitmapDataUtil.TwoBitBitmap( diffTrackingData, .01 );
			
			var rag:RegionAdjacencyGraph = new RegionAdjacencyGraph( diffTrackingData );
			rag.graph();
			rag.printBounds();
			trace( rag.toString() );
		}

	}
}