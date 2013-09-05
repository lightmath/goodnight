package com.pw282.swf.data.abc
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.BaseInstruction;
	import com.pw282.swf.data.EncodedU32;

	import com.pw282.swf.instructions.O_getlocal_n;

	import com.pw282.swf.instructions.O_setlocal_n;
	import com.pw282.swf.utils.InstructionTypes;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-7-1
	 */	
	public class Method_body_info extends BaseData
	{
		public var method:int = 0;
		public var max_stack:int = 0;
		public var local_count:int = 0;
		public var init_scope_depth:int = 0;
		public var max_scope_depth:int = 0;
		public var code_length:int = 0;
		public var btCode:ByteArray;
		public var exception_count:int = 0;
		public var arrException:Array = [];
		public var trait_count:int = 0;
		public var arrTrait:Array = [];
		
		public function Method_body_info(bt:ByteArray=null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			method = EncodedU32.read(bt);
			max_stack = EncodedU32.read(bt);
			local_count = EncodedU32.read(bt);
			init_scope_depth = EncodedU32.read(bt);
			max_scope_depth = EncodedU32.read(bt);
			
			var i:int = 0;
			
			code_length = EncodedU32.read(bt);
			
			btCode = new ByteArray();
			btCode.endian = Endian.LITTLE_ENDIAN;
			bt.readBytes(btCode, 0, code_length);
			btCode.position = 0;
			
			exception_count = EncodedU32.read(bt);
			arrException = [];
			for(i = 0; i < exception_count; i++){
				arrException.push(new Exception_info(bt));
			}
			trait_count = EncodedU32.read(bt);
			arrTrait = [];
			for(i = 0; i < trait_count; i++){
				arrTrait.push(new Traits_info(bt));
			}
		}
		public function getArrCode():Array{
			var arrCode:Array = [];
			btCode.position = 0;
			while(btCode.bytesAvailable > 0){
				try{
					var opcode:int = btCode.readUnsignedByte();
					var instructionClass:Class = InstructionTypes.getInstructionClass(opcode);
					var instruction:BaseInstruction;
					if(instructionClass == O_getlocal_n || instructionClass == O_setlocal_n){
						instruction = new instructionClass(opcode, btCode);
					}else{
						instruction = new instructionClass(btCode);
					}
					if(instructionClass != BaseInstruction && instruction.opcode != opcode){
						throw new Error("opcode not equal:" + opcode);
					}
					instruction.opcode = opcode;
					
					arrCode.push(instruction);
				}catch(err:Error){
					trace("Method_body_info read btCode:" + opcode + "," + btCode.bytesAvailable);
				}
			}
			return arrCode;
		}
		public function setArrCode(arr:Array):void{
			var i:int = 0;
			var codeLen:int = arr.length;
			btCode = new ByteArray();
			btCode.endian = Endian.LITTLE_ENDIAN;
			for(i = 0; i < codeLen; i++){
				(arr[i] as BaseInstruction).write(btCode);;
			}
		}
		override public function write(bt:ByteArray):void{
			EncodedU32.write(bt, method);
			EncodedU32.write(bt, max_stack);
			EncodedU32.write(bt, local_count);
			EncodedU32.write(bt, init_scope_depth);
			EncodedU32.write(bt, max_scope_depth);
			
			var i:int = 0;
			
			EncodedU32.write(bt, btCode.length);
			bt.writeBytes(btCode);
			
			EncodedU32.write(bt, exception_count);
			for(i = 0; i < exception_count; i++){
				(arrException[i] as BaseData).write(bt);
			}
			
			EncodedU32.write(bt, trait_count);
			for(i = 0; i < trait_count; i++){
				(arrTrait[i] as BaseData).write(bt);
			}
		}
		override public function encrypt():void{
			
		}
		override public function toString():String{
			return "method:" + method
				+ ",max_stack:" + max_stack
				+ ",local_count:" + local_count
				+ ",init_scope_depth:" + init_scope_depth
				+ ",max_scope_depth:" + max_scope_depth
				+ ",code_length:" + code_length
				+ ",exception_count:" + exception_count
				+ ",trait_count:" + trait_count
		}
	}
}