package edu.iu.vis.tracking.tuio.profiles {
	
	import edu.iu.vis.tracking.RegionAdjacencyGraph;
	import edu.iu.vis.tracking.tuio.TuioInterpreter;
	
	import it.h_umus.tuio.Tuio2DObj;

	public class AbstractTuioInterpreterProfile implements ITuioInterpreterProfile {
		
		private var _interpreter:TuioInterpreter;
		
		public function AbstractTuioInterpreterProfile() {
		}

		public function get interpreter():TuioInterpreter {
			return _interpreter;
		}
		
		public function set interpreter( value:TuioInterpreter ):void {
			_interpreter = value;
		}
		
		public function interpretGraph( rag:RegionAdjacencyGraph ):void {
		}
		
		protected function sendObj( i:uint, x:Number, y:Number, a:Number ):void {
			if ( interpreter )
				interpreter.generateEventFromObj( i, x / interpreter.sourceWidth, y / interpreter.sourceHeight, a );
		}
		
	}
}