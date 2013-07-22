part of LeapMotionDart;

/**
 * LeapUtil is a collection of static utility functions.
 *
 */
class LeapUtil
{
  /** The constant pi as a single precision floating point number. */
  static const double PI = 3.1415926536;

  /**
   * The constant ratio to convert an angle measure from degrees to radians.
   * Multiply a value in degrees by this constant to convert to radians.
   */
  static const double DEG_TO_RAD = 0.0174532925;

  /**
   * The constant ratio to convert an angle measure from radians to degrees.
   * Multiply a value in radians by this constant to convert to degrees.
   */
  static const double RAD_TO_DEG = 57.295779513;

  /**
   * Pi &#42; 2.
   */
  static const double TWO_PI = Math.PI + Math.PI;

  /**
   * Pi &#42; 0.5.
   */
  static const double HALF_PI = Math.PI * 0.5;

  /**
   * Represents the smallest positive single value greater than zero.
   */
  static const double EPSILON = 0.00001;

  LeapUtil()
  {
  }

  /**
   * Convert an angle measure from radians to degrees.
   *
   * @param radians
   * @return The value, in degrees.
   *
   */
  static double toDegrees( double radians )
  {
    return radians * 180 / Math.PI;
  }

  /**
   * Determines if a value is equal to or less than 0.00001.
   *
   * @return True, if equal to or less than 0.00001; false otherwise.
   */
  bool isNearZero( double value )
  {
    return value.abs() <= EPSILON;
  }

  /**
   * Determines if all Vector3 components is equal to or less than 0.00001.
   *
   * @return True, if equal to or less than 0.00001; false otherwise.
   */
  bool vectorIsNearZero( Vector3 inVector )
  {
    return isNearZero( inVector.x ) && isNearZero( inVector.y ) && isNearZero( inVector.z );
  }

  /**
   * Create a new matrix with just the rotation block from the argument matrix
   */
  Matrix extractRotation( Matrix mtxTransform )
  {
    return new Matrix( x: mtxTransform.xBasis, y: mtxTransform.yBasis, z: mtxTransform.zBasis );
  }

  /**
   * Returns a matrix representing the inverse rotation by simple transposition of the rotation block.
   */
  Matrix rotationInverse( Matrix mtxRot )
  {
    return new Matrix( x: new Vector3( mtxRot.xBasis.x, mtxRot.yBasis.x, mtxRot.zBasis.x ), y: new Vector3( mtxRot.xBasis.y, mtxRot.yBasis.y, mtxRot.zBasis.y ), z: new Vector3( mtxRot.xBasis.z, mtxRot.yBasis.z, mtxRot.zBasis.z ) );
  }

  /**
   * Returns a matrix that is the orthonormal inverse of the argument matrix.
   * This is only valid if the input matrix is orthonormal
   * (the basis vectors are mutually perpendicular and of length 1)
   */
  Matrix rigidInverse( Matrix mtxTransform )
  {
    Matrix rigidInverse = rotationInverse( mtxTransform );
    rigidInverse.origin = rigidInverse.transformDirection( mtxTransform.origin.opposite() );
    return rigidInverse;
  }

  Vector3 componentWiseMin( Vector3 vLHS, Vector3 vRHS )
  {
    return new Vector3( Math.min( vLHS.x, vRHS.x ), Math.min( vLHS.y, vRHS.y ), Math.min( vLHS.z, vRHS.z ) );
  }

  Vector3 componentWiseMax( Vector3 vLHS, Vector3 vRHS )
  {
    return new Vector3( Math.max( vLHS.x, vRHS.x ), Math.max( vLHS.y, vRHS.y ), Math.max( vLHS.z, vRHS.z ) );
  }

  Vector3 componentWiseScale( Vector3 vLHS, Vector3 vRHS )
  {
    return new Vector3( vLHS.x * vRHS.x, vLHS.y * vRHS.y, vLHS.z * vRHS.z );
  }

  Vector3 componentWiseReciprocal( Vector3 inVector )
  {
    return new Vector3( 1.0 / inVector.x, 1.0 / inVector.y, 1.0 / inVector.z );
  }

  double minComponent( Vector3 inVector )
  {
    return Math.min( inVector.x, Math.min( inVector.y, inVector.z ) );
  }

  double maxComponent( Vector3 inVector )
  {
    return Math.max( inVector.x, Math.max( inVector.y, inVector.z ) );
  }

  /**
   * Compute the polar/spherical heading of a vector direction in z/x plane
   */
  double heading( Vector3 inVector )
  {
    return Math.atan2( inVector.z, inVector.x );
  }

  /**
   * Compute the spherical elevation of a vector direction in y above the z/x plane
   */
  double elevation( Vector3 inVector )
  {
    return Math.atan2( inVector.y, Math.sqrt( inVector.z * inVector.z + inVector.x * inVector.x ) );
  }

  /**
   * Set magnitude to 1 and bring heading to [-Pi,Pi], elevation into [-Pi/2, Pi/2]
   *
   * @param The Vector3 to convert.
   * @return The normalized spherical Vector3.
   *
   */
  Vector3 normalizeSpherical( Vector3 vSpherical )
  {
    double fHeading = vSpherical.y;
    double fElevation = vSpherical.z;

    while( fElevation <= -Math.PI )
      fElevation += TWO_PI;
    while( fElevation > Math.PI )
      fElevation -= TWO_PI;

    if( fElevation.abs() > HALF_PI )
    {
      fHeading += Math.PI;
      fElevation = fElevation > 0 ? ( Math.PI - fElevation ) : -( Math.PI + fElevation );
    }

    while( fHeading <= -Math.PI )
      fHeading += TWO_PI;
    while( fHeading > Math.PI )
      fHeading -= TWO_PI;

    return new Vector3( 1.0, fHeading, fElevation );
  }

  /**
   * Convert from Cartesian (rectangular) coordinates to spherical coordinates
   * (magnitude, heading, elevation).
   *
   * @param The Vector3 to convert.
   * @return The cartesian Vector3 converted to spherical.
   *
   */
  Vector3 cartesianToSpherical( Vector3 vCartesian )
  {
    return new Vector3( vCartesian.magnitude(), heading( vCartesian ), elevation( vCartesian ) );
  }

  /**
   * Convert from spherical coordinates (magnitude, heading, elevation) to
   * Cartesian (rectangular) coordinates.
   *
   * @param The Vector3 to convert.
   * @return The spherical Vector3 converted to cartesian.
   *
   */
  Vector3 sphericalToCartesian( Vector3 vSpherical )
  {
    double fMagnitude = vSpherical.x;
    double fCosHeading = Math.cos( vSpherical.y );
    double fSinHeading = Math.sin( vSpherical.y );
    double fCosElevation = Math.cos( vSpherical.z );
    double fSinElevation = Math.sin( vSpherical.z );

    return new Vector3( fCosHeading * fCosElevation * fMagnitude, fSinElevation * fMagnitude, fSinHeading * fCosElevation * fMagnitude );
  }

  /**
   * Clamps a value between a minimum Number and maximum Number value.
   *
   * @param inVal The number to clamp.
   * @param minVal The minimum value.
   * @param maxVal The maximum value.
   * @return The value clamped between minVal and maxVal.
   *
   */
  double clamp( double inVal, double minVal, double maxVal )
  {
    return ( inVal < minVal ) ? minVal : ( ( inVal > maxVal ) ? maxVal : inVal );
  }

  /**
   * Linearly interpolates between two Numbers.
   *
   * @param a A number.
   * @param b A number.
   * @param t The interpolation coefficient [0-1].
   * @return The interpolated number.
   *
   */
  double lerp( double a, double b, double coefficient )
  {
    return a + ( ( b - a ) * coefficient );
  }

  /**
   * Linearly interpolates between two Vector3 objects.
   *
   * @param a A Vector3 object.
   * @param b A Vector3 object.
   * @param t The interpolation coefficient [0-1].
   * @return A new interpolated Vector3 object.
   *
   */
  Vector3 lerpVector( Vector3 vec1, Vector3 vec2, double coefficient )
  {
    return vec1 + vec2 - vec1 * coefficient;
  }
}