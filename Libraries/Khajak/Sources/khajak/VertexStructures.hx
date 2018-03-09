package khajak;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;

class VertexStructures {
	
	static var basic: VertexStructure;
	public static var Basic(get, null): VertexStructure;
	static function get_Basic() {
		if (basic == null) {
			basic = new VertexStructure();
			basic.add("pos", VertexData.Float3);
			basic.add("uv", VertexData.Float2);
			basic.add("nor", VertexData.Float3);
		}
		
		return basic;
	}
	
	static var billboards: VertexStructure;
	public static var Billboards(get, null): VertexStructure;
	static function get_Billboards() {
		if (billboards == null) {
			billboards = new VertexStructure();
			billboards.add("pos", VertexData.Float3);
			billboards.add("uv", VertexData.Float2);
		}
		
		return billboards;
	}
	
	static var billboardsInstanced: VertexStructure;
	public static var BillboardsInstanced(get, null): VertexStructure;
	static function get_BillboardsInstanced() {
		if (billboardsInstanced == null) {
			billboardsInstanced = new VertexStructure();
			billboardsInstanced.add("sizeWorldspace", VertexData.Float2);
			billboardsInstanced.add("centerWorldspace", VertexData.Float3);
			billboardsInstanced.add("rotData", VertexData.Float2);
			billboardsInstanced.add("baseColor", VertexData.Float4);
			billboardsInstanced.add("mvpMatrix", VertexData.Float4x4);
		}
		
		return billboardsInstanced;
	}
}