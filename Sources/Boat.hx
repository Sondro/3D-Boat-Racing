package;

import kha.Color;
import kha.math.Matrix4;
import kha.math.FastMatrix4;
import kha.math.Vector2;
import kha.math.Vector3;
import kha.math.Vector4;
import khajak.RenderObject;

class Boat extends RenderObject {

/*	
	public static var IMPULSE_DAMPING = 0.5;
	public static var IMPULSE_SPEED = 7.5;
	public static var ROTATING_DAMPING = 0.5;
	public static var ROTATING_SPEED = 0.25 * Math.PI;
*/

	public static var IMPULSE_DAMPING = 0.5;
	public static var IMPULSE_SPEED = 90.5;
	public static var ROTATING_DAMPING = 0.5;
	public static var ROTATING_SPEED = 0.25 * Math.PI;


	public var position(default, null): Vector4;
	public var direction(default, null): Vector4;
	
	private var angle: Float;
	private var impulse: Vector4;
	private var rotationDir: Float;
	private var rotationStrength: Float;
	private var startingPosition: Vector4;
	private var paddle: Paddle;
	
	public function new(position: Vector4, color: Color, paddle: Paddle) {
		super(Meshes.Boat, color, kha.Assets.images.black, true);
		
		this.paddle = paddle;
		
		startingPosition = position;
		resetAll();
	}
	
	private function resetMovement() {
		angle = 0;
		direction = new Vector4(0, 0, 1);
		impulse = new Vector4(0, 0, 0);
		rotationDir = 0;
		rotationStrength = 0;
	}
	
	public function addImpulse(strength: Float, left: Bool) {
		rotationStrength = strength;
		rotationDir = (left ? 1 : -1) * rotationStrength;
		direction = Matrix4.rotationY(angle).multvec(new Vector4(0, 0, 1));
		impulse = impulse.add(direction.mult(strength));
	}
	
	public function update(deltaTime: Float, paddleLeft: Bool, paddleRot: Float) {
		position.y = Water.map(new Vector2(position.x, position.z)) - 0.5;
		var trackCenter = TrackGenerator.the.getY(position.z);
		if (Math.abs(TrackGenerator.the.getY(position.z) - position.x) >= TrackGenerator.the.width) 
		{
						addImpulse(1, false);

			resetMovement();
			position = new Vector4(trackCenter, position.y, position.z - 5);
			kha.audio1.Audio.play(kha.Assets.sounds.explosion_medium_wood_debris);
		}
		else 
		{
			impulse.length = Math.max(impulse.length * (1 - IMPULSE_DAMPING * deltaTime), 0);
			rotationStrength =  Math.max(rotationStrength * (1 - ROTATING_DAMPING * deltaTime), 0);
			
			angle += rotationDir * rotationStrength * ROTATING_SPEED * deltaTime;
			position = position.add(impulse.mult(IMPULSE_SPEED * deltaTime));
		}
		
		model = FastMatrix4.translation(position.x, position.y, position.z).multmat(FastMatrix4.rotationY(angle));
		var paddleOffset = paddleLeft ? 1 : -1;
		var paddleRotation = 0.125 * Math.PI - paddleRot * 0.25 * Math.PI;
		paddle.model = FastMatrix4.translation(position.x, position.y + 1.5, position.z).multmat(
			FastMatrix4.rotationY(angle).multmat(
				FastMatrix4.translation(paddleOffset, 0, 0).multmat(
					FastMatrix4.rotationZ(paddleOffset * 0.125 * Math.PI).multmat(
						FastMatrix4.rotationX(paddleRotation).multmat(
							FastMatrix4.translation(0, -1.5, 0).multmat(
								FastMatrix4.scale(1.1, 1.1, 1.1)))))));
	}
	
	public function getDistFromTrackCenter(): Float {
		return Math.abs(TrackGenerator.the.getY(position.z) - position.x);
	}
	
	public function resetAll() {
		resetMovement();
		position = startingPosition;
	}
}