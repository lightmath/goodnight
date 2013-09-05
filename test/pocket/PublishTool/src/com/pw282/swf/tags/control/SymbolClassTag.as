package com.pw282.swf.tags.control
{
	import com.pw282.swf.data.DString;
	import com.pw282.swf.data.KeyWords;
	import com.pw282.swf.tags.Tag;
	import com.pw282.swf.utils.Tools;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class SymbolClassTag extends Tag
	{
		public var NumSymbols:int;
		public var arrSymbols:Array;
		public function SymbolClassTag()
		{
			super();
		}
		override public function parse():void{
			super.parse();
			
			if(!allowChildParse){
				return;
			}
			NumSymbols = bt.readUnsignedShort();
			var i:int = 0;
			arrSymbols = [];
			for(i = 0; i < NumSymbols; i++){
				var symbol:Symbol = new Symbol();
				symbol.tag = bt.readUnsignedShort();
				symbol.Name = DString.read(bt);
				arrSymbols.push(symbol);
			}
		}
		override public function toString():String{
			return super.toString() + "\n NumSymbols:" + NumSymbols
				+ "\n" + Tools.toArrString(arrSymbols);
		}
		override public function encrypt():void{
			if(!allowChildEncrypt){
				return;
			}
			var i:int = 0;
			for(i = 0; i < NumSymbols; i++){
				var symbol:Symbol = arrSymbols[i];
				var dotLastIndex:int = symbol.Name.lastIndexOf(".");
				var str1:String = symbol.Name.substr(0, (dotLastIndex < 0 ? 0 : dotLastIndex));
				var str2:String = symbol.Name.substring(dotLastIndex + 1);
				
				str1 = KeyWords.encryptStr(str1);
				str2 = KeyWords.encryptStr(str2);
				
				str1 = (str1 == "" ? str1 : str1 + ".");
				symbol.Name = str1 + str2;
			}
		}
		override public function encode():void{
			if(allowChildEncode){
				bt = new ByteArray();
				bt.endian = Endian.LITTLE_ENDIAN;
				bt.writeShort(NumSymbols);
				var i:int = 0;
				for(i = 0; i < NumSymbols; i++){
					var symbol:Symbol = arrSymbols[i];
					bt.writeShort(symbol.tag);
					DString.write(bt, symbol.Name);
				}
			}
			super.encode();
		}
	}
}
class Symbol{
	public var tag:int;
	public var Name:String;
	
	public function toString():String{
		return "tag:" + tag
			+ ",Name:" + Name
	}
}