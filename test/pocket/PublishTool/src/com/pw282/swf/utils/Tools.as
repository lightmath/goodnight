package com.pw282.swf.utils
{
	import com.pw282.swf.data.KeyWords;
	import com.pw282.swf.data.abc.AbcFile;

	import com.pw282.swf.tags.Tag;
	import com.pw282.swf.tags.actions.DoABCTag;

	import flash.utils.ByteArray;

	
	public class Tools
	{
		/**
		 * 用做中转，很多地方的toString或其他方法使用
		 * 在访问AbcFile时候重设
		 */		
		public static var abcFile:AbcFile;
		public function Tools()
		{
		}
		
		
		/**
		 * 读取一定长度的位 
		 * 无符号的
		 * 
		 * @param bytes 二进制序列
		 * @param bitStartPosition 开始读取的位置，从0开始算
		 * @param bitLength     读取长度
		 * @return 无符号数字
		 * 
		 */ 
		public static function readUBits(bytes:ByteArray, bitStartPosition:int, bitLength:int):uint{
			var bitBuffer:int;
			var bitCursor:int;
			
			var remainLength:int;
			var result:uint=0;
			
			bitCursor= bitStartPosition % 8;
			bytes.position = bitStartPosition / 8;
			
			if (bitCursor == 0){
				bitBuffer = bytes.readUnsignedByte();
				bitCursor = 8;
			}else{
				bitBuffer = bytes.readUnsignedByte();
				bitBuffer = bitBuffer & (0xFF >> bitCursor);
				bitCursor = 8 - bitCursor;
			}
			
			while(bytes.bytesAvailable > 0){
				remainLength = bitLength - bitCursor;
				if (remainLength > 0){
					result = result | (bitBuffer << remainLength);
					bitLength -= bitCursor;
					bitBuffer = bytes.readUnsignedByte();
					bitCursor = 8;
				}else{
					result = result | (bitBuffer >> -remainLength);
					return result;
				}
			}
			return 0;
		}
		public static function wirteBits(bytes:ByteArray, bitStartPosition:int, bitLength:int, v:int):void{
			var bitBuffer:int;//bytes中取出的值
			var bitCursor:int;//bytes的填入起始位
			var v_startIndex:int = 0;//取v的v_len位的起始，从左到右递增
			var v_len:int = 0;//对v取多长
			var v_value:int = 0;//从v中取的值
			
			bitCursor = bitStartPosition % 8;
			bytes.position = bitStartPosition / 8;
			
			while(bitLength > v_startIndex){
				v_len = 8 - bitCursor;
				v_len = v_len > (bitLength - v_startIndex) ? (bitLength - v_startIndex) : v_len;
				
				bitBuffer = bytes.readUnsignedByte();
				bitBuffer &= getAndPar(bitCursor, 8 - bitCursor);
				
				v_value = v & getAndPar(v_len, bitLength - v_startIndex - v_len);
				v -= v_value;
				
				v_value >>= (bitLength - v_startIndex - v_len);
				v_value <<= (8 - (bitCursor + v_len));
				
				bytes[bytes.position - 1] = bitBuffer | v_value;
				
				bitCursor = 0;
				v_startIndex += v_len;
			}
		}
		/**
		 * 获得与参数
		 * 比如getAndPar(5, 3)则返回二进制的（11111000）
		 * 
		 */		
		private static function getAndPar(num:uint, leftCount:uint):uint{
			var v:uint = Math.pow(2, num) - 1;
			return v << leftCount;
		}
		/**
		 * 读取一定长度的位 
		 * 有符号的
		 * 
		 * @param bytes 二进制序列
		 * @param bitStartPosition 开始读取的位置，从0开始算
		 * @param bitLength 读取长度
		 * @return 有符号数字
		 * 
		 */     
		public static function readSBits(bytes:ByteArray, bitStartPosition:int, bitLength:int):int{
			
			var result:int = readUBits(bytes, bitStartPosition, bitLength);
			
			var offset:int = (32 - bitLength);
			// 补齐符号位
			result = ((result << offset) >> offset);
			
			return result;
		}
		public static function readS24(bt:ByteArray):int{
			var v1:int = bt.readByte();
			var v2:int = bt.readByte();
			var v3:int = bt.readByte();
			v2 <<= 8;
			v3 <<= 16;
			return v1 | v2 | v3;
		}
		public static function writeS24(bt:ByteArray, v:int):void{
			bt.writeByte(v & 0xff);
			bt.writeByte(v >> 8 & 0xff);
			bt.writeByte(v >> 16);
		}
		
		public static function readFBits(bytes:ByteArray, bitStartPosition:int, bitLength:int):int{
			var result:int = readUBits(bytes, bitStartPosition, bitLength);
			var n1:int = result & 0xFFFF0000;
			var offset:uint = 32 - bitLength + 16;
			offset = Math.min(offset, 32);
			// 补齐符号位
			n1 = ((n1 << offset) >> offset);
			var n2:uint = result & 0x0000FFFF;
			
			result = parseInt(n1 + "." + n2);
			
			return result;
		}
		
		public static function getABCXMLList(tags:Array):XMLList{
			var xmlStr:String = "<node label='DoABCs'>";
			var i:int = 0;
			var count:int = tags.length;
			var showCount:int = 20;
			for(i = 0; i < count; i++){
				var tag:Tag = tags[i];
				if(showCount > 0 && tag.tagType == TagTypes.TAG_DOABC){
					xmlStr += "<node label='DoABC_" + i + "' txt='" + tag.toXmlString() + "'>";
					xmlStr += tag.getXmlStr()
					xmlStr += "</node>";
					showCount--;
				}
			}
			xmlStr += "</node>";
			return new XMLList(xmlStr);
		}
		public static function getABCList(tags:Array):Array{
			var arr:Array = new Array();
			var i:int = 0;
			var count:int = tags.length;
			for(i = 0; i < count; i++){
				var tag:Tag = tags[i];
				if(tag.tagType == TagTypes.TAG_DOABC){
					var ob:Object = {};
					ob.label = i + "_" + (tag as DoABCTag).Flags + "_" + (tag as DoABCTag).Name;
					ob.data = i;
					arr.push(ob);
				}
			}
			return arr;
		}
		public static function toArrString(arr:Array):String{
			var str:String = "";
			var i:int = 0;
			var count:int = arr.length;
			for(i = 0; i < count; i++){
				str += i + "：\t" + arr[i] + "\n";
			}
			return str;
		}
		public static function toArrString2(arr:Array, exceptKeyWords:Boolean = true):String{
			var str:String = "";
			var i:int = 0;
			var count:int = arr.length;
			var addCount:int = 0;
			for(i = 0; i < count; i++){
				if(exceptKeyWords && KeyWords.isKeyWords(arr[i])){
					continue;
				}
				addCount++;
				str += arr[i] + "\n";
			}
			str += addCount + "\n";
			return str;
		}
		public static function toArrString3(arr:Array):String{
			var str:String = "";
			var i:int = 0;
			var count:int = arr.length;
			for(i = 0; i < count; i++){
				str += arr[i];
			}
			return str;
		}
		public static function getRandom(min:int, max:int):int {
			return int(Math.random() * (max - min) + min)
		}
	}
}