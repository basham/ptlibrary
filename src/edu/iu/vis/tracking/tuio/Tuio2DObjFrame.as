package edu.iu.vis.tracking.tuio {
	
	import edu.iu.vis.utils.Pool;
	
	import it.h_umus.tuio.Tuio2DObj;
	
	public class Tuio2DObjFrame {
		
		static private var TuioPool:Array = new Array();
		
		public var frame:uint = 0;
		public var tuio:Tuio2DObj;
		
		public function Tuio2DObjFrame( frame:uint = 0, tuio:Tuio2DObj = null ) {
			this.frame = frame;
			this.tuio = tuio;
		}

		static public function GetTuioInstance():Tuio2DObj {
			return ( TuioPool.length > 0 ? TuioPool.pop() : new Tuio2DObj( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ) );
		}
		
		public function PoolDisposer():void {
			Pool.Dispose( tuio );
			this.frame = 0;
			this.tuio = null;
		}
		
	}
}