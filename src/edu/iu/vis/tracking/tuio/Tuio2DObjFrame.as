package edu.iu.vis.tracking.tuio {
	
	import it.h_umus.tuio.Tuio2DObj;
	
	public class Tuio2DObjFrame {
		
		public var frame:uint = 0;
		public var tuio:Tuio2DObj;
		
		public function Tuio2DObjFrame( frame:uint = 0, tuio:Tuio2DObj = null ) {
			this.frame = frame;
			this.tuio = tuio;
		}

	}
}