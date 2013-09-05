package com.pw282.swf.tags
{
	import com.pw282.swf.utils.TagTypes;

	
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class Tag
	{
		/**
		 * 是否允许子类反序列化
		 */		
		public static var allowChildParse:Boolean = true;
		/**
		 * 是否允许子类序列化
		 */		
		public static var allowChildEncode:Boolean = true;
		/**
		 * 是否允许子类加密
		 */		
		public static var allowChildEncrypt:Boolean = true;
		
		public var bt:ByteArray;
		public var tagType:uint;
		public var tagLength:int;
		public function Tag()
		{
			bt = new ByteArray();
		}
		public function parse():void{
			bt.endian = Endian.LITTLE_ENDIAN;
			bt.position = 0;
		}
		public function get tagName():String{
			return TagTypes.getTagNameByTagType(tagType);
		}
		public function toString():String{
			return "Type:" + tagType + ",Name:" + tagName + ",Length:" + tagLength;
		}
		public function toXmlString():String{
			return ""
		}
		public function getXmlStr():String{
			return "<node label='tag'/>"
		}
		public function encode():void{
			var btTmp:ByteArray = new ByteArray();
			btTmp.endian = Endian.LITTLE_ENDIAN;
			btTmp.writeBytes(bt);
			var tmpLen:int = btTmp.length;
			if(tmpLen != tagLength){
				//trace(tagName + ":" + tmpLen + "," + tagLength);
			}
			tagLength = tmpLen;
			bt.length = 0;
			if(btTmp.length >= 0x3F){
				bt.writeShort((tagType << 6) | 0x3F);
				bt.writeUnsignedInt(tagLength);
			}else{
				bt.writeShort((tagType << 6) | tagLength);
			}
			bt.writeBytes(btTmp);
			btTmp.length = 0;
		}
		public function encrypt():void{
			
		}
	}
}