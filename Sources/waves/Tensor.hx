package waves;

import haxe.ds.Vector;

class Tensor {
	public var ndims: Int; // number of dimensions
	public var size: Vector<Int>; // size[0],...,size[ndims-1]
	public var numel: Int; // total number of elements
	public var data: Vector<Float>; // data[0],...,data[numel-1]

	public static var format: String;    // used by toString()
	public static var valid: Int;       // after critical operations, this is 1 when ok, or 0 in case of failure
	public static var precision: Type;  // after critical operations, this is 1 when ok, or 0 in case of failure

	public function new(ndims: Int, size: Vector<Int> = null) {
		this.ndims = ndims;
		this.size = new Vector<Int>(ndims);
		if (size != null)
			for (c0 in 0...ndims)
				this.size[c0] = size[c0];
		else
			this.size[0] = 0;
		numel = 1;
		for (c0 in 0...ndims)
			numel *= this.size[c0];
		data = new Vector<Float>(numel);
		for (c0 in 0...numel)
			data.set(c0, 0);
	}
	
	/*public function not(): Tensor {
		var ret = new Tensor(ndims, size);
		for (c0 in 0...numel)
			ret.set(c0, !data.get(c0));
		return ret;
	}*/
	
	public function get(slice: Int) {
		var ret = new Tensor(ndims - 1, size);
		var c1: Int = ret.numel * slice;
		//assert(c1+ret.numel<=numel);
		for (c0 in 0...ret.numel)
			ret.data[c0]=data[c1++];
		return ret;
	}
	
	
	public static function eye(size0: Int): Tensor {
		var vec = new Vector<Int>(2);
		vec.set(0, size0);
		vec.set(1, size0);
		var ret = new Tensor(2, vec);
		var c0 = 0;
		while (c0 < ret.numel) {
			ret.data[c0]=1;
			c0 += size0 + 1;
		}
		return ret;
	}
	
	public function forValues(ind0: Int, ind: Array<Int>): Float {
		var acc = 1;
		for (c0 in 0...ndims - 1) {
			acc *= size[c0];
			ind0 += ind[c0] * acc;
		}
		//assert(0<=ind0&&ind0<numel);
		return data[ind0];
	}
}
