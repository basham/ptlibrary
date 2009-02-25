package edu.iu.vis.tracking {
	
	import edu.iu.vis.utils.BitmapDataUtil;
	
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	
	public class MotionTracking {
		
		private var prevTrackingData:BitmapData;
		private var currTrackingData:BitmapData;
		private var diffTrackingData:BitmapData;
		private var keystoneData:BitmapData;
		
		private var p:Point = new Point();
		
		private var _blur:uint;
		private var _sensitivity:uint;
		
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
			
		public function MotionTracking( w:uint, h:uint, blur:uint = 32, sensitivity:uint = 1 ) {
			prevTrackingData = new BitmapData(w, h);
			currTrackingData = new BitmapData(w, h);
			diffTrackingData = new BitmapData(w, h);
			keystoneData = new BitmapData(w, h);
			this.blur = blur;
			this.sensitivity = sensitivity;
		}
		
		public function get filteredBitmapData():BitmapData {
			return diffTrackingData;
		}
		
		public function get blur():uint {
			return _blur;
		}
		
		public function set blur( value:uint ):void {
			_blur = value;
		}
		
		public function get sensitivity():uint {
			return _sensitivity;
		}
		
		public function set sensitivity( value:uint ):void {
			_sensitivity = value;
		}
		
		public function key():void {
			keystoneData.copyPixels(currTrackingData, currTrackingData.rect, new Point());
		}
		
		public function keyTrack( source:BitmapData ):void {
			track( source, true );
		}
		
		public function motionTrack( source:BitmapData ):void {
			track( source, false );
		}
		
		public function regionTrack( source:BitmapData ):void {
			contrastBlur( source );
		}
		
		public function graph():RegionAdjacencyGraph {
			var rag:RegionAdjacencyGraph = new RegionAdjacencyGraph( filteredBitmapData );
			rag.graph();
			rag.printBounds();
			//trace( rag.toString() );
			return rag;
		}
		
		private function track( source:BitmapData, keying:Boolean = false ):void {
			
			// Make the current frame the new frame
			prevTrackingData.copyPixels(currTrackingData, currTrackingData.rect, p);
			
			// Redraw the current frame from the video source
			//currTrackingData.draw(video);
			currTrackingData.copyPixels(source, source.rect, p);

			if ( keying ) {
				// Copy previous frame into Difference bitmap
				diffTrackingData.copyPixels(keystoneData, keystoneData.rect, p);
			}
			else {
				// Copy previous frame into Difference bitmap
				diffTrackingData.copyPixels(prevTrackingData, prevTrackingData.rect, p);
			}

			// Difference the current frame with the previous frame
			diffTrackingData.draw( currTrackingData, null, null, "difference");

			contrastBlur( diffTrackingData );
		}

		private function contrastBlur( source:BitmapData ):void {
			// Greyscales and contrasts Difference
			var cmf:ColorMatrixFilter = new ColorMatrixFilter( greyContrast );
			// Blurs Difference to make blobby shapes
			var blurF:BlurFilter = new BlurFilter( blur, blur, 2 );
			
			source.applyFilter( source, source.rect, p, cmf );	
			source.applyFilter( source, source.rect, p, blurF );
			
			// Removes grey from blobs, making them more solid shapes
			BitmapDataUtil.TwoBitBitmap( source, sensitivity/100 );
		}

	}
}