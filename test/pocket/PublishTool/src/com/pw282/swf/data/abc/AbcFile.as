package com.pw282.swf.data.abc
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;
	import com.pw282.swf.utils.Tools;
	
	import flash.utils.ByteArray;
	
	public class AbcFile extends BaseData
	{
		public var minor_version:int = 16;
		public var major_version:int = 46;
		public var cpool_info:Cpool_info = new Cpool_info();
		public var method_count:int = 0;
		public var arrMethod:Array = [];
		/** The metadata_info entry provides
		 *  a means of embedding arbitrary key /value
		 *  pairs into the ABC file. The
		 * AVM2 will ignore all such entries. */
		public var metadata_count:int = 0;
		public var arrMetadata:Array = [];
		public var class_count:int = 0;
		public var arrInstance:Array = [];
		public var arrClass:Array = [];
		public var script_count:int = 0;
		public var arrScript:Array = [];
		public var method_body_count:int = 0;
		public var arrMethodBody:Array = [];
		public function AbcFile(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			Tools.abcFile = this;
			minor_version = bt.readUnsignedShort();
			major_version = bt.readUnsignedShort();
			cpool_info = new Cpool_info(bt);
			method_count = EncodedU32.read(bt);
			var i:int = 0;
			arrMethod = [];
			for(i = 0; i < method_count; i++){
				var method_info:Method_info = new Method_info(bt);
				arrMethod.push(method_info);
			}
			metadata_count = EncodedU32.read(bt);
			arrMetadata = [];
			for(i = 0; i < metadata_count; i++){
				var metadata_info:Metadata_info = new Metadata_info(bt);
				arrMetadata.push(metadata_info);
			}
			class_count = EncodedU32.read(bt);
			arrInstance = [];
			for(i = 0; i < class_count; i++){
				var instance_info:Instance_info = new Instance_info(bt);
				arrInstance.push(instance_info);
			}
			arrClass = [];
			for(i = 0; i < class_count; i++){
				var class_info:Class_info = new Class_info(bt);
				arrClass.push(class_info);
			}
			script_count = EncodedU32.read(bt);
			arrScript = [];
			for(i = 0; i < script_count; i++){
				var script_info:Script_info = new Script_info(bt);
				arrScript.push(script_info);
			}
			method_body_count = EncodedU32.read(bt);
			arrMethodBody = [];
			for(i = 0; i < method_body_count; i++){
				var method_body_info:Method_body_info = new Method_body_info(bt);
				arrMethodBody.push(method_body_info);
			}
			if(bt.bytesAvailable > 0){
				throw new Error("AbcFile not read to end");
			}
		}
		override public function write(bt:ByteArray):void{
			Tools.abcFile = this;
			bt.writeShort(minor_version);
			bt.writeShort(major_version);
			cpool_info.write(bt);
			EncodedU32.write(bt, method_count);
			var i:int = 0;
			for(i = 0; i < method_count; i++){
				var method_info:Method_info = arrMethod[i];
				method_info.write(bt);
			}
			EncodedU32.write(bt, metadata_count);
			for(i = 0; i < arrMetadata.length; i++){
				var metadata_info:Metadata_info = arrMetadata[i];
				metadata_info.write(bt);
			}
			EncodedU32.write(bt, class_count);
			for(i = 0; i < class_count; i++){
				var instance_info:Instance_info = arrInstance[i];
				instance_info.write(bt);
			}
			for(i = 0; i < class_count; i++){
				var class_info:Class_info = arrClass[i];
				class_info.write(bt);
			}
			EncodedU32.write(bt, script_count);
			for(i = 0; i < script_count; i++){
				var script_info:Script_info = arrScript[i];
				script_info.write(bt);
			}
			EncodedU32.write(bt, method_body_count);
			for(i = 0; i < method_body_count; i++){
				var method_body_info:Method_body_info = arrMethodBody[i];
				method_body_info.write(bt);
			}
		}
		override public function encrypt():void{
			Tools.abcFile = this;
			cpool_info.encrypt();
			var i:int = 0;
//			for(i = 0; i < method_count; i++){
//				var method_info:Method_info = arrMethod[i];
//				method_info.encrypt();
//			}
//			for(i = 0; i < script_count; i++){
//				var script_info:Script_info = arrScript[i];
//				script_info.encrypt();
//			}
//			for(i = 0; i < method_body_count; i++){
//				var method_body_info:Method_body_info = arrMethodBody[i];
//				method_body_info.encrypt();
//			}
		}
		override public function toString():String{
			Tools.abcFile = this;
			return "minor_version:" + minor_version
				+ ",major_version:" + major_version
//				+ ",cpool_info:" + cpool_info
				+ "\n method_count:" + method_count
//				+ "\n metadata_count:" + metadata_count
//				+ "\n arrMethod:" + arrMethod
				+ "\n arrInstance:" + arrInstance
		}
		public function toXmlString():String{
			Tools.abcFile = this;
			return "minor_version:" + minor_version
				+ "\n major_version:" + major_version
				+ "\n method_count:" + method_count
				+ "\n class_count:" + class_count
				+ "\n script_count:" + script_count
				+ "\n method_body_count:" + method_body_count
		}
		public function getXmlStr():String{
			Tools.abcFile = this;
			return "<node label='AbcFile' txt='" + this.toXmlString() + "'>"
				+ cpool_info.getXmlStr()
//				+ "<node label='arrMethod' txt='" + Tools.toArrString(arrMethod) + "' />"
//				+ "<node label='arrMetadata' txt='" + Tools.toArrString(arrMetadata) + "' />"
//				+ "<node label='arrInstance' txt='arrInstance.length:" + arrInstance.length + "'>"
//				+ Tools.toArrString3(arrInstance)
//				+ "</node>"
//				+ "<node label='arrClass' txt='" + Tools.toArrString(arrClass) + "' />"
				+ "</node>"
		}
		
		public function getArrayList(arr:Array):void{
			Tools.abcFile = this;
			var ob:Object = {};
			ob.label = "--arrMethod:" + method_count;
			ob.data = Tools.toArrString(arrMethod);
			arr.addItem(ob);
			ob = {};
			ob.label = "--cpool_info";
			ob.data = cpool_info.toXmlString();
			arr.addItem(ob);
			cpool_info.getArrayList(arr);
		}
		public function getMethodBodyList(arr:Array):void{
			Tools.abcFile = this;
			var ob:Object;
			var i:int = 0;
			for(i = 0; i < method_body_count; i++){
				var method_body_info:Method_body_info = arrMethodBody[i];
				ob = {};
				var M:Method_info = arrMethod[method_body_info.method];
				ob.label = "--" + M;
				ob.data = i;
				arr.push(ob);
			}
		}
		public function getInstanceList():Array{
			Tools.abcFile = this;
			var arr:Array = [];
			var ob:Object;
			var i:int = 0;
			for(i = 0; i < class_count; i++){
				var instance_info:Instance_info = arrInstance[i];
				ob = {};
				ob.label = Tools.abcFile.cpool_info.arrMultiname_S[instance_info.name - 1];
				ob.data = i;
				arr.push(ob);
			}
			return arr;
		}
		public function getMethod_body_info(method:int):Method_body_info{
			var i:int = 0;
			for(i = 0; i < method_body_count; i++){
				var method_body_info:Method_body_info = arrMethodBody[i];
				if(method_body_info.method == method){
					return method_body_info;
				}
			}
			return null;
		}
	}
}