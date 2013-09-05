package com.pw282.swf.data
{
	import flash.utils.ByteArray;

	public class EncodedU32
	{
		public function EncodedU32()
		{
		}
		public static function read(bt:ByteArray):int{
			var position:int = bt.position;
			var result:int = bt[position + 0];
			if(!(result & 0x00000080)){
				bt.position ++;
				return result;
			}
			result = (result & 0x0000007f) | bt[position + 1]<<7;
			if(!(result & 0x00004000)){
				bt.position += 2;
				return result;
			}
			result = (result & 0x00003fff) | bt[position + 2]<<14;
			if(!(result & 0x00200000)){
				bt.position += 3;
				return result;
			}
			result = (result & 0x001fffff) | bt[position + 3]<<21;
			if(!(result & 0x10000000)){
				bt.position += 4;
				return result;
			}
			result = (result & 0x0fffffff) | bt[position + 4]<<28;
			bt.position += 5;
			return result;
		}
		public static function write(bt:ByteArray, v:int):void{
			var btTmp:ByteArray = new ByteArray();
			btTmp.length = 5;
			var int_7_bit:int;
			var index:int = 0;
			
			int_7_bit = v & 0x0000007f;
			v >>>= 7;
			btTmp[index] = v ? (int_7_bit | 0x00000080) : int_7_bit;
			index ++;
			while(v){
				int_7_bit = v & 0x0000007f;
				v >>>= 7;
				btTmp[index] = v ? (int_7_bit | 0x00000080) : int_7_bit;
				index ++;
			}
			/*
			int_7_bit = (v & 0x7f0000000) >> 28;
			if(int_7_bit){
				btTmp[5 - index] = int_7_bit;
				index ++;
			}
			
			int_7_bit = (v & 0x00fe00000) >> 21;
			if(int_7_bit || index){
				btTmp[5 - index] = index ? (int_7_bit | 0x00000080) : int_7_bit;
				index ++;
			}
			
			int_7_bit = (v & 0x0001fc000) >> 14;
			if(int_7_bit || index){
				btTmp[5 - index] = index ? (int_7_bit | 0x00000080) : int_7_bit;
				index ++;
			}
			
			int_7_bit = (v & 0x000003f80) >> 7;
			if(int_7_bit || index){
				btTmp[5 - index] = index ? (int_7_bit | 0x00000080) : int_7_bit;
				index ++;
			}
			
			int_7_bit = v & 0x00000007f;
			btTmp[5 - index] = index ? (int_7_bit | 0x00000080) : int_7_bit;
			index ++;
			*/
			bt.writeBytes(btTmp, 0, index);
		}
	}
}