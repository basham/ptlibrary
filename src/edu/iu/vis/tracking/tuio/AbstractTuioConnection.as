package edu.iu.vis.tracking.tuio {
	
	import edu.iu.vis.net.AbstractLocalConnection;
	import edu.iu.vis.tracking.symbols.dss.DSSymbol;
	
	import flash.net.registerClassAlias;
	
	import it.h_umus.tuio.Tuio2DObj;
	import it.h_umus.tuio.events.Tuio2DObjEvent;
	
	public class AbstractTuioConnection extends AbstractLocalConnection {
		
		public function AbstractTuioConnection( connectionName:String, autoConnect:Boolean = false ) {
			super( connectionName, autoConnect );
			registerClassAlias("it.h_umus.tuio.events.Tuio2DObjEvent", Tuio2DObjEvent);
			registerClassAlias("it.h_umus.tuio.Tuio2DObj", Tuio2DObj);
			registerClassAlias("edu.iu.vis.tracking.symbols.dss.DSSymbol", DSSymbol);
			registerClassAlias("edu.iu.vis.tracking.Tuio2DObjMessage", Tuio2DObjMessage);
			registerClassAlias("edu.iu.vis.tracking.Tuio2DObjEventMessage", Tuio2DObjEventMessage);
		}

	}
}