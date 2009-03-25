package edu.iu.vis.utils {
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The Pool class provides a way to store and retrieve unused class instances.
	 * The best classes to pool are ones to be created and destroyed often,
	 * and do not force constructor parameters.
	 * 
	 * @author Chris Basham
	 * 
	 * */
	public class Pool {
		
		/**
		 * A Dictionary listing all Pools created.
		 * Class types are Dictionary keys; Pools are Dictionary elements.
		 * 
		 * */
		private static var Pools:Dictionary = new Dictionary(true);
		
		/**
		 * A class type the Pool creates and stores.
		 * */
		private var type:Class;
		
		/**
		 * An array containing all class instances for the given Pool.
		 * 
		 * */
		private var pool:Array;
		
		/**
		 * The constructor for a Pool instance.
		 * 
		 * @param type Any class type.
		 * 
		 * */
		function Pool( type:Class ) {
			this.type = type;
			pool = new Array();
			Pools[ type ] = this;
		}
		
		/**
		 * Creates or finds an instance of the Pool class type,
		 * applying the supplied parameters if needed.
		 * 
		 * @param ...parameters A rest list of parameters to be applied to the constructor of a Pool's class type instance.
		 * 
		 * @return Returns an instance of the Pool's class type.
		 * 
		 * */
		public function getInstance( ...parameters ):* {
			return getInstanceByArray( parameters );
		}
		
		/**
		 * Creates or finds an instance of the Pool class type,
		 * applying the supplied parameters if needed.
		 * 
		 * @param parameters An array of parameters to be applied to the constructor of a Pool's class type instance.
		 * 
		 * @return Returns an instance of the Pool's class type.
		 * 
		 * @internal TODO: Apply parameters to pre-constructed instances as a sort of post-constructor.
		 * 
		 * */
		public function getInstanceByArray( parameters:Array ):* {
			return ( pool.length > 0 ? pool.pop() : Util.Construct( type, parameters ) );
			//var obj:Object = ( pool.length > 0 ? pool.pop() : Util.Construct( type, parameters ) ) as Object;
			//if ( obj.hasOwnProperty( "PoolConstructor" ) )
			//	obj.PoolConstructor();
			//return obj;
		}
		
		/**
		 * Disposes a class instance, adding it to the class Pool.
		 * 
		 * <p>If the instance contains a method named <code>PoolDisposer</code>,
		 * it will automatically be called at function execution as a pool equivalent
		 * of a deconstructor.</p>
		 * 
		 * @param object A class instance of the Pool's class type.
		 * 
		 * */
		public function dispose( object:* ):void {
			pool.push( object );
			var obj:Object = object as Object;
			if ( obj.hasOwnProperty( "PoolDisposer" ) )
				obj.PoolDisposer();
		}
		
		/**
		 * Purges a Pool's class instances, exposing them to garbage collection.
		 * 
		 * */
		public function purge():void {
			pool = new Array();
		}
		

		/**
		 * Creates or finds a Pool for the given class type.
		 * 
		 * @param type A class type.
		 * 
		 * @return Returns the single Pool associated with the given class type.
		 * 
		 * */
		public static function GetPool( type:Class ):Pool {
			if ( !Pools[ type ] )
				new Pool( type );
			return Pools[ type ];
		}
		
		/**
		 * Destroys a Pool for the given class type, exposing all its stored instances
		 * for garbage collection.
		 * 
		 * @param type A class type.
		 * 
		 * */
		public static function DistroyPool( type:Class ):void {
			Pools[ type ] = null;
			delete( Pools[ type ] );
		}
		
		/**
		 * Creates or finds an instance of the given class type.
		 * 
		 * @param type A class type.
		 * @param ...parameters A rest list of any number of parameters to be applied to the constructor
		 * of the class instance, if an instance requires parameters for construction.
		 * 
		 * @return Returns an instance of the given class type.
		 * 
		 * */
		public static function Get( type:Class, ...parameters ):* {
			return GetPool( type ).getInstanceByArray( parameters );
		}
		
		/**
		 * Disposes a class instance, adding it to the class Pool.
		 * 
		 * @param object Any class instance.
		 * @param type A class type. If not provided, it will be determined by the object.
		 * Utilize this parameter to improve this function's speed.
		 * 
		 * */
		public static function Dispose( object:*, type:Class = null ):void {
			if ( object == null )
				return;
			if ( type == null )
				type = getDefinitionByName( getQualifiedClassName( object ) ) as Class;
			GetPool( type ).dispose( object );
		}

	}
	
}
