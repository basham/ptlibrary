package edu.iu.vis.tracking.tuio.profiles {
	
	import edu.iu.vis.tracking.RegionAdjacencyGraph;
	import edu.iu.vis.tracking.tuio.TuioInterpreter;
	
	public interface ITuioInterpreterProfile {
		
		function get interpreter():TuioInterpreter;
		function set interpreter( value:TuioInterpreter ):void;
		function interpretGraph( rag:RegionAdjacencyGraph ):void;
		
	}
}