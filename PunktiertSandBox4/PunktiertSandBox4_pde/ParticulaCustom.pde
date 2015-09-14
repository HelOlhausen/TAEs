import punktiert.math.Vec;


/**
 * An example how you can set up your own agent by combining/ implementing different beaviors.
 * Here the BSwarm and the VTrail Class are simply added to an extended VParticle class
 *
 */
public class ParticulaCustom extends VParticle {

  public VTrail trail;

  /**
   * Creates a ParticulaCustom at position xy, z set to 0.0
   *
   * @param x
   * @param y
   */
  public ParticulaCustom(float x, float y) {
    this(x, y, 0, 1, 1);
  }

  /**
   * Creates a ParticulaCustom at position xyz
   *
   * @param x
   * @param y
   * @param z
   */
  public ParticulaCustom(float x, float y, float z) {
    this(x, y, z, 1, 1);
  }

  /**
   * Creates a ParticulaCustom at position xyz with weight 1, default radius 1.0
   *
   * @param x
   * @param y
   * @param z
   * @param w
   */
  public ParticulaCustom(float x, float y, float z, float w) {
    this(x, y, z, w, 1);
  }

  /**
   * Creates a ParticulaCustom at position xyz with weight , radius , default flocking values as in the Processing example "Flocking" by Daniel Shiffman
   *
   * @param x
   * @param y
   * @param z
   * @param w
   */
  public ParticulaCustom(float x, float y, float z, float w, float r) {
    super(x, y, z, w, r);

    this.trail = new VTrail(this);
  }

  /**
   * Creates a ParticulaCustom at the position of the passed in vector
   *
   * @param v position
   */
  public ParticulaCustom(Vec v) {
    this(v.x, v.y, v.z, 1, 1);
  }

  /**
   * Creates a ParticulaCustom at the position of the passed in vector
   *
   * @param pos position
   * @param vel velocity / previous position
   */
  public ParticulaCustom(Vec pos, Vec vel) {
    super(pos, vel);

    this.trail = new VTrail(this);
  }

  /**
   * Creates a ParticulaCustom at the position of the passed in vector, belonging to a specific group
   *
   * @param pos position
   * @param vel velocity / previous position
   */
  public ParticulaCustom(Vec pos, Vec vel, VParticleGroup group) {
    super(pos, vel);

    this.trail = new VTrail(this);
  }

}
