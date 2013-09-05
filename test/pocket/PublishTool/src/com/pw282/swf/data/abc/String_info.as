package com.pw282.swf.data.abc
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;
	import com.pw282.swf.data.KeyWords;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class String_info extends BaseData
	{
		private var _size:int;
		private var _str:String;
		public var needEncrypt:Boolean = false;
		public function String_info(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			_size = EncodedU32.read(bt);
			_str = bt.readUTFBytes(_size);
		}
		override public function write(bt:ByteArray):void{
			EncodedU32.write(bt, _size);
			bt.writeUTFBytes(_str);
		}
		override public function toString():String{
			return str;
		}
		public function get size():int{
			return _size;
		}
		public function set str(v:String):void{
			_str = v;
			var btTmp:ByteArray = new ByteArray();
			btTmp.endian = Endian.LITTLE_ENDIAN;
			btTmp.writeUTFBytes(str);
			_size = btTmp.length;
			btTmp.length = 0;
		}
		public function get str():String{
			return _str;
		}
		public function addToEncryptWords():Boolean{
			//排除fl包内的类和包被混淆，因为要和fla中资源对应
			if(_str.indexOf("fl.") != 0){
				needEncrypt = KeyWords.addNeedEncryptStr(_str);
			}
			return needEncrypt;
		}
	}
}