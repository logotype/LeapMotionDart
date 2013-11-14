part of LeapMotionDart;

/**
 * The Matrix class represents a transformation matrix.
 *
 * To use this class to transform a Vector, construct a matrix containing the
 * desired transformation and then use the <code>Matrix.transformPoint()</code> or
 * <code>Matrix.transformDirection()</code> functions to apply the transform.
 *
 * Transforms can be combined by multiplying two or more transform matrices
 * using the <code>multiply()</code> function.
 *
 *
 * @author logotype
 *
 */
class Matrix
{
  /**
   * The translation factors for all three axes.
   */
  Vector3 origin = new Vector3( 0.0, 0.0, 0.0 );

  /**
   * The rotation and scale factors for the x-axis.
   */
  Vector3 xBasis = new Vector3( 0.0, 0.0, 0.0 );

  /**
   * The rotation and scale factors for the y-axis.
   */
  Vector3 yBasis = new Vector3( 0.0, 0.0, 0.0 );

  /**
   * The rotation and scale factors for the z-axis.
   */
  Vector3 zBasis = new Vector3( 0.0, 0.0, 0.0 );

  /**
   * Constructs a transformation matrix from the specified basis vectors.
   * [x] A Vector specifying rotation and scale factors for the x-axis.
   * [y] A Vector specifying rotation and scale factors for the y-axis.
   * [z] A Vector specifying rotation and scale factors for the z-axis.
   * [_origin] A Vector specifying translation factors on all three axes.
   *
   */
  Matrix( { Vector3 x, Vector3 y, Vector3 z, Vector3 o: null } )
  {
    xBasis = x;
    yBasis = y;
    zBasis = z;

    if( o != null )
      origin = o;
  }

  /**
   * Sets this transformation matrix to represent a rotation around the specified vector.
   * This function erases any previous rotation and scale transforms applied to this matrix,
   * but does not affect translation.
   *
   * [_axis] A Vector specifying the axis of rotation.
   * [angleRadians] The amount of rotation in radians.
   *
   */
  void setRotation( Vector3 _axis, num angleRadians )
  {
    Vector3 axis = _axis.normalized();
    num s = Math.sin( angleRadians );
    num c = Math.cos( angleRadians );
    num C = ( 1 - c );

    xBasis = new Vector3( axis.x * axis.x * C + c, axis.x * axis.y * C - axis.z * s, axis.x * axis.z * C + axis.y * s );
    yBasis = new Vector3( axis.y * axis.x * C + axis.z * s, axis.y * axis.y * C + c, axis.y * axis.z * C - axis.x * s );
    zBasis = new Vector3( axis.z * axis.x * C - axis.y * s, axis.z * axis.y * C + axis.x * s, axis.z * axis.z * C + c );
  }

  /**
   * Transforms a vector with this matrix by transforming its rotation, scale, and translation.
   * Translation is applied after rotation and scale.
   *
   * [inVector] The Vector to transform.
   * [return] A new Vector representing the transformed original.
   *
   */
  Vector3 transformPoint( Vector3 inVector ) => new Vector3( ( xBasis * inVector.x ).x, ( yBasis * inVector.y ).y, ( zBasis * inVector.z ).z + origin.z );

  /**
   * Transforms a vector with this matrix by transforming its rotation and scale only.
   * [inVector] The Vector to transform.
   * [return] A new Vector representing the transformed original.
   *
   */
  Vector3 transformDirection( Vector3 inVector )
  {
    Vector3 x = xBasis * inVector.x;
    Vector3 y = yBasis * inVector.y;
    Vector3 z = zBasis * inVector.z;
    return x + y + z;
  }

  /**
   * Performs a matrix inverse if the matrix consists entirely of rigid transformations (translations and rotations).
   * [return] The rigid inverse of the matrix.
   *
   */
  Matrix rigidInverse()
  {
    Matrix rotInverse = new Matrix( x: new Vector3( xBasis.x, yBasis.x, zBasis.x ), y: new Vector3( xBasis.y, yBasis.y, zBasis.y ), z: new Vector3( xBasis.z, yBasis.z, zBasis.z ) );
    if( origin != null )
      rotInverse.origin = rotInverse.transformDirection( origin.opposite() );
    return rotInverse;
  }

  /**
   * Multiply transform matrices.
   * [other] A Matrix to multiply on the right hand side.
   * [return] A new Matrix representing the transformation equivalent to applying the other transformation followed by this transformation.
   *
   */
  operator *( Matrix other)
  {
    Vector3 x = transformDirection( other.xBasis );
    Vector3 y = transformDirection( other.yBasis );
    Vector3 z = transformDirection( other.zBasis );
    Vector3 o = origin;

    if( origin != null && other.origin != null )
      o = transformPoint( other.origin );

    return new Matrix( x: x, y: y, z: z, o: o );
  }

  /**
   * Compare Matrix equality/inequality component-wise.
   * [other] The Matrix to compare with.
   * [return] True; if equal, False otherwise.
   *
   */
  operator ==( Matrix other)
  {
    if( xBasis != other.xBasis )
      return false;

    if( yBasis != other.yBasis )
      return false;

    if( zBasis != other.zBasis )
      return false;

    if( origin != other.origin )
      return false;

    return true;
  }

  /**
   * Returns the identity matrix specifying no translation, rotation, and scale.
   * [return] The identity matrix.
   *
   */
  static Matrix identity()
  {
    Vector3 xBasis = new Vector3( 1.0, 0.0, 0.0 );
    Vector3 yBasis = new Vector3( 0.0, 1.0, 0.0 );
    Vector3 zBasis = new Vector3( 0.0, 0.0, 1.0 );

    return new Matrix( x: xBasis, y: yBasis, z: zBasis );
  }

  /**
   * Suppress compiler warning for operator overloads.
   *
   */
   int get hashCode => super.hashCode;

  /**
   * Write the matrix to a string in a human readable format.
   */
  String toString() => "[Matrix xBasis:" + xBasis.toString() + " yBasis:" + yBasis.toString() + " zBasis:" + zBasis.toString() + " origin:" + origin.toString() + "]";
}