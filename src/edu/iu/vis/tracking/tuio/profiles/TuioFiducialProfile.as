package edu.iu.vis.tracking.tuio.profiles {
	
	import edu.iu.vis.tracking.Region;
	import edu.iu.vis.tracking.RegionAdjacencyGraph;
	import edu.iu.vis.utils.RectangleUtil;
	import edu.iu.vis.utils.TrigUtil;
	
	import flash.geom.Point;
	
	public class TuioFiducialProfile extends AbstractTuioInterpreterProfile {
		
		public var fiducials:Array = new Array();
		
		public function TuioFiducialProfile() {
			fiducials.push( '01233333333332222222' );
			fiducials.push( '01233333233232322222' );
			fiducials.push( '0121' );
			fiducials.push( '01233222' );
		}
		
		override public function interpretGraph( rag:RegionAdjacencyGraph ):void {
			
			var pattern:String = '(' + fiducials.join('|') + ')$';
			var fiducialRegions:Array = rag.getRegionsMatchingDepthSequence(pattern, 0);
			
			for each( var region:Region in fiducialRegions ) {
				
				var orientationMarks:Array = ( region.children[0] as Region ).getRegionsByNumChildren(0);
				var orientationPoints:Array = new Array();
				
				for each( var omRegion:Region in orientationMarks )
					orientationPoints.push( omRegion.centroid );

				var orientationPoint:Point = TrigUtil.AvgPoint( orientationPoints );
				var centroid:Point = RectangleUtil.Centroid( region.bounds );
				var rotation:Number = TrigUtil.DegreesFromOrigin( centroid, orientationPoint );
				var classId:uint = fiducials.indexOf( region.relativeDepthSequence );
				
				region.print( rag.bitmapData );
				trace( centroid, rotation );
				
				// Send Tuio obj data back to Interpreter
				this.sendObj( classId, centroid.x, centroid.y, rotation );
			}
			
			//if ( fiducialRegions.length == 0 )
			//	rag.printBounds();
		}

	}
}