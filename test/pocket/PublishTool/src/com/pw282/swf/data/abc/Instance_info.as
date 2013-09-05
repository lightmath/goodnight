package com.pw282.swf.data.abc
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;
	import com.pw282.swf.data.abc.trait.Trait_class;
	import com.pw282.swf.data.abc.trait.Trait_method;
	import com.pw282.swf.utils.Tools;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-6-13
	 */	
	public class Instance_info extends BaseData
	{
		public static const CONSTANT_ClassSealed:uint = 0x01;
		public static const CONSTANT_ClassFinal:uint = 0x02;
		public static const CONSTANT_ClassInterface:uint = 0x04;
		public static const CONSTANT_ClassProtectedNs:uint = 0x08;
		
		public var name:int;
		public static var name_S:String = "";
		public var super_name:int;
		public var flags:int;
		public var protectedNs:int = -1;
		public var intrf_count:int;
		public var arrInterface:Array;
		public static var arrInterface_S:Array;
		public var iinit:int;
		public var trait_count:int;
		public var arrTraits:Array;
		public function Instance_info(bt:ByteArray=null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			name = EncodedU32.read(bt);
			name_S = Tools.abcFile.cpool_info.arrMultiname_S[name - 1];
			super_name = EncodedU32.read(bt);
			flags = bt.readByte();
			if(flags < 0){
				trace(flags);
			}
			if(flags & CONSTANT_ClassProtectedNs){
				protectedNs = EncodedU32.read(bt);
			}
			intrf_count = EncodedU32.read(bt);
			var i:int = 0;
			arrInterface = [];
			arrInterface_S = [];
			for(i = 0; i < intrf_count; i++){
				arrInterface.push(EncodedU32.read(bt));
				arrInterface_S.push(Tools.abcFile.cpool_info.arrMultiname_S[arrInterface[i] - 1]);
			}
			iinit = EncodedU32.read(bt);
			trait_count = EncodedU32.read(bt);
			arrTraits = [];
			for(i = 0; i < trait_count; i++){
				arrTraits.push(new Traits_info(bt));
			}
		}
		override public function write(bt:ByteArray):void{
			EncodedU32.write(bt, name);
			EncodedU32.write(bt, super_name);
			bt.writeByte(flags);
			if(flags & CONSTANT_ClassProtectedNs){
				EncodedU32.write(bt, protectedNs);
			}
			EncodedU32.write(bt, intrf_count);
			var i:int = 0;
			for(i = 0; i < intrf_count; i++){
				EncodedU32.write(bt, arrInterface[i]);
			}
			EncodedU32.write(bt, iinit);
			EncodedU32.write(bt, trait_count);
			for(i = 0; i < trait_count; i++){
				(arrTraits[i] as Traits_info).write(bt);
			}
		}
		override public function toString():String{
			return "arrTraits" + arrTraits
		}
		public function toXmlString():String{
			return "name:" + name_S
				+ "\n super_name:" + Tools.abcFile.cpool_info.arrMultiname_S[super_name - 1]
				+ "\n flags:" + flags
				+ "\n protectedNs:" + (flags & CONSTANT_ClassProtectedNs ? Tools.abcFile.cpool_info.arrNamespace_S[protectedNs - 1] : "no set")
				+ "\n intrf_count:" + intrf_count
				+ "\n iinit:" + iinit
				+ "\n trait_count:" + trait_count
		}
		public function getMethodList():Array{
			var arr:Array = [];
			var ob:Object = {};
			
			var i:int = 0;
			for(i = 0; i < trait_count; i++){
				var traits_info:Traits_info = arrTraits[i];
//				if(traits_info.traitType == Traits_info.Trait_Class){
//					var trait_class:Trait_class = traits_info.trait;
//					var instance_info:Instance_info = Tools.abcFile.arrInstance[trait_class.classi];
//					ob = {};
//					ob.label = Tools.abcFile.cpool_info.arrMultiname_S[instance_info.name - 1];
//					ob.data = cinit;
//					arr.push(ob);
//				}else 
				if(traits_info.traitType == Traits_info.Trait_Method){
					var trait_method:Trait_method = traits_info.trait;
					ob = {};
					ob.label = Tools.abcFile.cpool_info.arrMultiname_S[traits_info.name - 1];
					ob.data = trait_method.method_v;
					arr.push(ob);
				}
			}
			return arr;
		}
	}
}