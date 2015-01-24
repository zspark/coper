/*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

package z_spark.coper
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class Utils
	{
		/////////////////////////File//////////////////////////////
		public static function read(filename:String):String{
			var f:File=new File(filename);
			var fs:FileStream=new FileStream();
			fs.open(f,FileMode.READ);
			var s:String=fs.readUTFBytes(fs.bytesAvailable);
			fs.close();
			return s;
		}
		
		public static function exists(filename:String):Boolean{
			var f:File=new File(filename);
			return f.exists;
		}
		
		public static function readByteArray(filename:String):ByteArray{
			var f:File=new File(filename);
			var fs:FileStream=new FileStream();
			fs.open(f,FileMode.READ);
			var br:ByteArray=new ByteArray();
			fs.readBytes(br);
			fs.close();
			return br;
		}
		
		public static function writeByteArray(filename:String,bytes:ByteArray):void{
			var f:File=new File(filename);
			var fs:FileStream=new FileStream();
			fs.open(f,FileMode.WRITE);
			fs.writeBytes(bytes);
			fs.close();
		}
		
		public static function getDirectoryListing(directoryName:String):Array{
			var f:File=new File(directoryName);
			return f.getDirectoryListing();
		}
		
		public static function createDirectory(directoryName:String):void{
			var f:File=new File(directoryName);
			f.createDirectory()
		}
		
		
		/////////////////////////html//////////////////////////////////
		public static function color(txt:String,color:String):String{
			return "<font color=\""+color+"\">"+txt+"</font>";
		}
		
		public static function size(txt:String,fontSize:uint):String{
			return "<font size=\""+size+"\">"+txt+"</font>";
		}
		
		
		///////////////////////////////others////////////////////////////////////
		public static function splitStringBy(str:String,sign:*):Array{
			return str.split(sign);
		}
		
		public static function isExtensionRight(fileName:String,ext:String):Boolean{
			var e:String=fileName.substr(getLastIndexOfSign(fileName,'.')+1);
			return e===ext || ext===Constance.EXT_ALL;
		}
		
		public static function hasSign(str:String,sign:String):Boolean{
			return str.indexOf(sign)>=0;
		}
		
		public static function getLastIndexOfSign(str:String,sign:String):int{
			return str.lastIndexOf(sign);
		}
		
		public static const DEC_NUMBERS:String="0123456789";
		public static function isStringAllDecNumbers(str:String):Boolean{
			var i:int=0;
			while(i<str.length){
				if(DEC_NUMBERS.indexOf(str.charAt(i))>=0){
					i++;
					continue;
				}else return false;
			}
			return true;
		}
		
		public static function fixToLength(num:int,l:int):String{
			var result:String=String(num);
			if(result.length>l)throw new Error("试图将一个更长的数字调整为长度较短的字符串！");
			else {
				while(result.length<l){
					result=0+result;
				}
			}
			return result;
		}
		
		
		
	}
}