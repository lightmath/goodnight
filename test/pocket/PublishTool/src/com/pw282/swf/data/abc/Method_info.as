package com.pw282.swf.data.abc
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;
	import com.pw282.swf.utils.Tools;
	
	import flash.utils.ByteArray;
	
	public class Method_info extends BaseData
	{
		public static const NEED_ARGUMENTS:int = 0x01;
		public static const NEED_ACTIVATION:int = 0x02;
		public static const NEED_REST:int = 0x04;
		public static const HAS_OPTIONAL:int = 0x08;
		public static const SET_DXNS:int = 0x40;
		public static const HAS_PARAM_NAMES:int = 0x80;
		
		public var param_count:int;
		public var return_type:int;
		public var arrParam_type:Array;
		public var name:int;
		public var strName:String = "";
		public var flags:int;
		public var options:Option_info;
		public var arrParam_names:Array;
		public function Method_info(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			param_count = EncodedU32.read(bt);
			return_type = EncodedU32.read(bt);
			var i:int = 0;
			arrParam_type = [];
			for(i = 0; i < param_count; i++){
				arrParam_type.push(EncodedU32.read(bt));
			}
			name = EncodedU32.read(bt);
			flags = bt.readUnsignedByte();
			options = new Option_info();
			if((flags & HAS_OPTIONAL) == HAS_OPTIONAL){
				options.read(bt);
			}
			arrParam_names = [];
			if((flags & HAS_PARAM_NAMES) == HAS_PARAM_NAMES){
				for(i = 0; i < param_count; i++){
					arrParam_names.push(EncodedU32.read(bt));
				}
			}
		}
		override public function write(bt:ByteArray):void{
			EncodedU32.write(bt, param_count);
			EncodedU32.write(bt, return_type);
			var i:int = 0;
			for(i = 0; i < param_count; i++){
				EncodedU32.write(bt, arrParam_type[i]);
			}
			EncodedU32.write(bt, name);
			bt.writeByte(flags);
			if((flags & HAS_OPTIONAL) == HAS_OPTIONAL){
				options.write(bt);
			}
			if((flags & HAS_PARAM_NAMES) == HAS_PARAM_NAMES){
				for(i = 0; i < param_count; i++){
					EncodedU32.write(bt, arrParam_names[i]);
				}
			}
		}
		override public function encrypt():void{
			this.name = 0;
		}
		override public function toString():String{
//			return "\n param_count:" + param_count
//				+ ",return_type:" + return_type
//				+ ",arrParam_type:" + arrParam_type
//				+ ",name:" + name
//				+ ",flags:" + flags
//				+ ",options:" + options
//				+ ",arrParam_name:" + arrParam_names
			return toFullString();
		}
		public function toFullString():String{
			return strName//Tools.abcFile.cpool_info.arrString[name - 1]
				+ "(" + getParamStr()
				+ "):" + (return_type == 0 ? "*" : Tools.abcFile.cpool_info.arrMultiname_S[return_type - 1])
		}
		private function getParamStr():String{
			var str:String = "";
			var i:int = 0;
			for(i = 0; i < param_count; i++){
				if(str != ""){
					str += ","
				}
				str += "P" + i + ":";
				str += Tools.abcFile.cpool_info.arrMultiname_S[arrParam_type[i] - 1];
				if((param_count - i) <= options.option_count){
					str += "=" + (options.arrOption[i + options.option_count - param_count] as Option_detail).toFullString();
				}
			}
			return str + "";
		}
	}
}