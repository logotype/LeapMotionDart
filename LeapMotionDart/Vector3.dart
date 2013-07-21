import 'dart:math';

/**
 * The Vector class represents a three-component mathematical vector
 * or point such as a direction or position in three-dimensional space.
 *
 * <p>The Leap Motion software employs a right-handed Cartesian coordinate system.
 * Values given are in units of real-world millimeters. The origin is
 * centered at the center of the Leap Motion Controller. The x- and z-axes lie in
 * the horizontal plane, with the x-axis running parallel to the long edge
 * of the device. The y-axis is vertical, with positive values increasing
 * upwards (in contrast to the downward orientation of most computer
 * graphics coordinate systems). The z-axis has positive values increasing
 * away from the computer screen.</p>
 *
 * @author logotype
 *
 */
class Vector3
{
  /**
   * The horizontal component.
   */
  num x;

  /**
   * The vertical component.
   */
  num y;

  /**
   * The depth component.
   */
  num z;

  /**
   * Creates a new Vector with the specified component values.
   * @param x The horizontal component.
   * @param y The vertical component.
   * @param z The depth component.
   *
   */
  Vector3( num x, num y, num z )
  {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  /**
   * A copy of this vector pointing in the opposite direction.
   * @return A Vector3 object with all components negated.
   *
   */
  Vector3 opposite()
  {
    return new Vector3( -x, -y, -z );
  }

  /**
   * Add vectors component-wise.
   * @param other
   * @return
   *
   */
  Vector3 plus( Vector3 other )
  {
    return new Vector3( x + other.x, y + other.y, z + other.z );
  }

  /**
   * Add vectors component-wise and assign the value.
   * @param other
   * @return This Vector3.
   *
   */
  Vector3 plusAssign( Vector3 other )
  {
    x += other.x;
    y += other.y;
    z += other.z;
    return this;
  }

  /**
   * A copy of this vector pointing in the opposite direction.
   * @param other
   * @return
   *
   */
  Vector3 minus( Vector3 other )
  {
    return new Vector3( x - other.x, y - other.y, z - other.z );
  }

  /**
   * A copy of this vector pointing in the opposite direction and assign the value.
   * @param other
   * @return This Vector3.
   *
   */
  Vector3 minusAssign( Vector3 other )
  {
    x -= other.x;
    y -= other.y;
    z -= other.z;
    return this;
  }

  /**
   * Multiply vector by a scalar.
   * @param scalar
   * @return
   *
   */
  Vector3 multiply( num scalar )
  {
    return new Vector3( x * scalar, y * scalar, z * scalar );
  }

  /**
   * Multiply vector by a scalar and assign the quotient.
   * @param scalar
   * @return This Vector3.
   *
   */
  Vector3 multiplyAssign( num scalar )
  {
    x *= scalar;
    y *= scalar;
    z *= scalar;
    return this;
  }

  /**
   * Divide vector by a scalar.
   * @param scalar
   * @return
   *
   */
  Vector3 divide( num scalar )
  {
    return new Vector3( x / scalar, y / scalar, z / scalar );
  }

  /**
   * Divide vector by a scalar and assign the value.
   * @param scalar
   * @return This Vector3.
   *
   */
  Vector3 divideAssign( num scalar )
  {
    x /= scalar;
    y /= scalar;
    z /= scalar;
    return this;
  }

  /**
   * Compare Vector equality/inequality component-wise.
   * @param other The Vector3 to compare with.
   * @return True; if equal, False otherwise.
   *
   */
  bool isEqualTo( Vector3 other )
  {
    if( x != other.x || y != other.y || z != other.z )
      return false;
    else
      return true;
  }

  /**
   * The angle between this vector and the specified vector in radians.
   *
   * <p>The angle is measured in the plane formed by the two vectors.
   * The angle returned is always the smaller of the two conjugate angles.
   * Thus <code>A.angleTo(B) == B.angleTo(A)</code> and is always a positive value less
   * than or equal to pi radians (180 degrees).</p>
   *
   * <p>If either vector has zero length, then this function returns zero.</p>
   *
   * @param other A Vector object.
   * @return The angle between this vector and the specified vector in radians.
   *
   */
  num angleTo( Vector3 other )
  {
    num denom = magnitudeSquared() * other.magnitudeSquared();
    if( denom <= 0 )
      return 0;

    return acos( dot( other ) / sqrt( denom ) );
  }

  /**
   * The cross product of this vector and the specified vector.
   *
   * The cross product is a vector orthogonal to both original vectors.
   * It has a magnitude equal to the area of a parallelogram having the
   * two vectors as sides. The direction of the returned vector is
   * determined by the right-hand rule. Thus <code>A.cross(B) == -B.cross(A)</code>.
   *
   * @param other A Vector object.
   * @return The cross product of this vector and the specified vector.
   *
   */
  Vector3 cross( Vector3 other )
  {
    return new Vector3( ( y * other.z ) - ( z * other.y ), ( z * other.x ) - ( x * other.z ), ( x * other.y ) - ( y * other.x ) );
  }

  /**
   * The distance between the point represented by this Vector
   * object and a point represented by the specified Vector object.
   *
   * @param other A Vector object.
   * @return The distance from this point to the specified point.
   *
   */
  num distanceTo( Vector3 other )
  {
    return sqrt( ( x - other.x ) * ( x - other.x ) + ( y - other.y ) * ( y - other.y ) + ( z - other.z ) * ( z - other.z ) );
  }

  /**
   * The dot product of this vector with another vector.
   * The dot product is the magnitude of the projection of this vector
   * onto the specified vector.
   *
   * @param other A Vector object.
   * @return The dot product of this vector and the specified vector.
   *
   */
  num dot( Vector3 other )
  {
    return ( x * other.x ) + ( y * other.y ) + ( z * other.z );
  }

  /**
   * Returns true if all of the vector's components are finite.
   * @return If any component is NaN or infinite, then this returns false.
   *
   */
  bool isValid()
  {
    return ( x <= double.MAX_FINITE && x >= -double.MAX_FINITE ) && ( y <= double.MAX_FINITE && y >= -double.MAX_FINITE ) && ( z <= double.MAX_FINITE && z >= -double.MAX_FINITE );
  }

  /**
   * Returns an invalid Vector3 object.
   *
   * You can use the instance returned by this function in
   * comparisons testing whether a given Vector3 instance
   * is valid or invalid.
   * (You can also use the Vector3.isValid property.)
   *
   * @return The invalid Vector3 instance.
   *
   */
  static Vector3 invalid()
  {
    return new Vector3( double.NAN, double.NAN, double.NAN );
  }

  /**
   * The magnitude, or length, of this vector.
   * The magnitude is the L2 norm, or Euclidean distance between the
   * origin and the point represented by the (x, y, z) components
   * of this Vector object.
   *
   * @return The length of this vector.
   *
   */
  num magnitude()
  {
    return sqrt( x * x + y * y + z * z );
  }

  /**
   * The square of the magnitude, or length, of this vector.
   * @return The square of the length of this vector.
   *
   */
  num magnitudeSquared()
  {
    return x * x + y * y + z * z;
  }

  /**
   * A normalized copy of this vector.
   * A normalized vector has the same direction as the original
   * vector, but with a length of one.
   * @return A Vector object with a length of one, pointing in the same direction as this Vector object.
   *
   */
  Vector3 normalized()
  {
    num denom = magnitudeSquared();
    if( denom <= 0 )
      return new Vector3( 0, 0, 0 );

    denom = 1 / sqrt( denom );
    return new Vector3( x * denom, y * denom, z * denom );
  }

  /**
   * The pitch angle in radians.
   * Pitch is the angle between the negative z-axis and the projection
   * of the vector onto the y-z plane. In other words, pitch represents
   * rotation around the x-axis. If the vector points upward, the
   * returned angle is between 0 and pi radians (180 degrees); if it
   * points downward, the angle is between 0 and -pi radians.
   *
   * @return The angle of this vector above or below the horizon (x-z plane).
   *
   */
  num get pitch => atan2( y, -z );

  /**
   * The yaw angle in radians.
   * Yaw is the angle between the negative z-axis and the projection
   * of the vector onto the x-z plane. In other words, yaw represents
   * rotation around the y-axis. If the vector points to the right of
   * the negative z-axis, then the returned angle is between 0 and pi
   * radians (180 degrees); if it points to the left, the angle is
   * between 0 and -pi radians.
   *
   * @return The angle of this vector to the right or left of the negative z-axis.
   *
   */
  num get yaw => atan2( x, -z );

  /**
   * The roll angle in radians.
   * Roll is the angle between the y-axis and the projection of the vector
   * onto the x-y plane. In other words, roll represents rotation around
   * the z-axis. If the vector points to the left of the y-axis, then the
   * returned angle is between 0 and pi radians (180 degrees); if it
   * points to the right, the angle is between 0 and -pi radians.
   *
   * Use this function to get roll angle of the plane to which this vector
   * is a normal. For example, if this vector represents the normal to
   * the palm, then this function returns the tilt or roll of the palm
   * plane compared to the horizontal (x-z) plane.
   *
   * @return The angle of this vector to the right or left of the y-axis.
   *
   */
  num get roll => atan2( x, -y );

  /**
   * The zero vector: (0, 0, 0)
   * @return
   *
   */
  static Vector3 zero()
  {
    return new Vector3( 0, 0, 0 );
  }

  /**
   * The x-axis unit vector: (1, 0, 0)
   * @return
   *
   */
  static Vector3 xAxis()
  {
    return new Vector3( 1, 0, 0 );
  }

  /**
   * The y-axis unit vector: (0, 1, 0)
   * @return
   *
   */
  static Vector3 yAxis()
  {
    return new Vector3( 0, 1, 0 );
  }

  /**
   * The z-axis unit vector: (0, 0, 1)
   * @return
   *
   */
  static Vector3 zAxis()
  {
    return new Vector3( 0, 0, 1 );
  }

  /**
   * The unit vector pointing left along the negative x-axis: (-1, 0, 0)
   * @return
   *
   */
  static Vector3 left()
  {
    return new Vector3( -1, 0, 0 );
  }

  /**
   * The unit vector pointing right along the positive x-axis: (1, 0, 0)
   * @return
   *
   */
  static Vector3 right()
  {
    return xAxis();
  }

  /**
   * The unit vector pointing down along the negative y-axis: (0, -1, 0)
   * @return
   *
   */
  static Vector3 down()
  {
    return new Vector3( 0, -1, 0 );
  }

  /**
   * The unit vector pointing up along the positive x-axis: (0, 1, 0)
   * @return
   *
   */
  static Vector3 up()
  {
    return yAxis();
  }

  /**
   * The unit vector pointing forward along the negative z-axis: (0, 0, -1)
   * @return
   *
   */
  static Vector3 forward()
  {
    return new Vector3( 0, 0, -1 );
  }

  /**
   * The unit vector pointing backward along the positive z-axis: (0, 0, 1)
   * @return
   *
   */
  static Vector3 backward()
  {
    return zAxis();
  }

  /**
   * Returns a string containing this vector in a human readable format: (x, y, z).
   * @return
   *
   */
  String toString()
  {
    return "[Vector3 x:" + x.toString() + " y:" + y.toString() + " z:" + z.toString() + "]";
  }
}